IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CUSP0002]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[CUSP0002]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Dong Quang
-- <Param>
---- Phong kinh doanh lay du lieu tu phong ke toan
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 04/08/2011 by Le Thi Thu Hien
---- 
---- Modified on 06/10/2011 by Le Thi Thu Hien
---- Modified on 11/10/2011 by Le Thi Thu Hien
-- <Example>
----	EXEC CUSP0002 'AS', 'ADMIN', 'IO/01/2011/0001'

CREATE PROCEDURE [dbo].[CUSP0002] 
	@DivisionID nvarchar(50),
	@UserID NVARCHAR(50),
	@VoucherID AS NVARCHAR(50),
	@Mode AS INT,		-- 1 : Lấy dữ liệu cũ trước khi lưu
						-- 2 : Lấy dữ liệu mới sau khi lưu
	@Action AS INT		-- 1 : Thêm
						-- 2 : Sửa
						-- 3 : Xóa
						-- 4 : Truyen lai
						
AS

DECLARE @sql nvarchar(4000),
		@ContractID AS VARCHAR(50)		
		
IF @Mode = 4
BEGIN

SELECT		T1.ObjectID,	T4.ObjectName,
				T1.ContractID,	T1.OriginalAmount,
				T1.CurrencyID,	T1.InvoiceNo,				T2.CostAmount,
				T3.AgentID,		T5.ObjectName AS AgentName,
				T3.AgentDate,	T3.AgentAmount,
				T6.TTR ,
				T1.ReceiveDate,
				CASE WHEN @Action = 1 THEN N'Thêm'
						WHEN @Action = 2 THEN N'Sửa'
							WHEN @Action = 3 THEN N'Xóa' END Status
	FROM		
	--- Số tiền khách hàng chuyển tiền
				(
	SELECT		A.ObjectID, MAX(A.VoucherDate) AS ReceiveDate,
				SUM(ISNULL(A.OriginalAmount, 0)) AS OriginalAmount, 
				A.CurrencyID, A.Ana02ID AS InvoiceNo,
				A.Ana01ID AS ContractID
	FROM		AT9000 A
	WHERE		A.Ana01ID IN (	SELECT	Str02
	     						FROM	AT0999 
	     		              	WHERE	UserID = @UserID 
	     		              			AND TransTypeID = 'DONGQUANG_BILLING' 
	     		              			AND KeyID = @VoucherID
	     		              )
				AND (	A.TransactionTypeID = 'T01'-- Tiền mặt
						OR A.TransactionTypeID = 'T21'-- Tiền ngân hàng
					)
			
	GROUP BY	A.ObjectID, A.Ana01ID, A.CurrencyID, A.Ana02ID
				)T1
				
	LEFT JOIN	(
	-------Chi tiền phi ngan hang
	SELECT		A.ObjectID, 
				SUM(ISNULL(A.OriginalAmount, 0)) AS CostAmount,
				A.Ana01ID AS ContractID
	FROM		AT9000 A
	WHERE		A.Ana01ID IN (	SELECT	Str02 
	     						FROM	AT0999 
	     		              	WHERE	UserID = @UserID 
	     		              			AND TransTypeID = 'DONGQUANG_BILLING' 
	     		              			AND KeyID = @VoucherID
	     		              )
				AND (	A.TransactionTypeID = 'T99'	-- Phí ngân hàng
						OR A.TransactionTypeID = 'T02'	-- Chi tiền mặt
						OR A.TransactionTypeID = 'T22' -- Chi qua ngân hàng
					)
				AND (A.Ana02ID = 'PNHT' OR A.Ana02ID = 'PNHN')
	GROUP BY	A.ObjectID, A.Ana01ID
				)T2
		ON		T1.ContractID = T2.ContractID
		
	LEFT JOIN	(	
	---- Chi Hoa hồng
	SELECT		A.ObjectID AS AgentID, MAX(A.VoucherDate) AS AgentDate,
				SUM(ISNULL(A.OriginalAmount, 0)) AS AgentAmount, 				
				A.Ana01ID AS ContractID
	FROM		AT9000 A
	WHERE		A.Ana01ID IN (	SELECT	Str02 
	     						FROM	AT0999 
	     		              	WHERE	UserID = @UserID 
	     		              			AND TransTypeID = 'DONGQUANG_BILLING' 
	     		              			AND KeyID = @VoucherID
	     		              )
				AND (	A.TransactionTypeID = 'T99'	-- Phí ngân hàng
						OR A.TransactionTypeID = 'T02'	-- Chi tiền mặt
						OR A.TransactionTypeID = 'T22' -- Chi qua ngân hàng
					)
				AND A.DebitAccountID LIKE '641%'
	GROUP BY	A.ObjectID, A.Ana01ID
				)T3
		ON		T3.ContractID = T1.ContractID

	----- Trả tiền trước
	LEFT JOIN	(
	SELECT		A.ObjectID, 
				SUM(ISNULL(A.OriginalAmount, 0)) AS TTR,
				A.Ana01ID AS ContractID
	FROM		AT9000 A
	WHERE		A.Ana01ID IN (	SELECT	Str02 
	     						FROM	AT0999 
	     		              	WHERE	UserID = @UserID 
	     		              			AND TransTypeID = 'DONGQUANG_BILLING' 
	     		              			AND KeyID = @VoucherID
	     		              )
				AND (	A.TransactionTypeID = 'T99'	-- Phí ngân hàng
						OR A.TransactionTypeID = 'T02'	-- Chi tiền mặt
						OR A.TransactionTypeID = 'T22' -- Chi qua ngân hàng
					)
				AND (A.Ana02ID = 'TTR' )
	GROUP BY	A.ObjectID, A.Ana01ID
				)T6
		ON		T1.ContractID = T6.ContractID
				AND T6.ObjectID = T1.ObjectID		
		
	LEFT JOIN	AT1202 T4
		ON		T4.ObjectID = T1.ObjectID
	LEFT JOIN	AT1202 T5
		ON		T5.ObjectID = T3.AgentID
END

IF @Mode = 1
BEGIN
	DELETE FROM AT0999 WHERE UserID = @UserID AND TransTypeID = 'DONGQUANG' AND KeyID = @VoucherID
	
	INSERT INTO AT0999 (UserID, KeyID, [Str02], TransTypeID)
	SELECT	DISTINCT @UserID , @VoucherID , Ana01ID, 'DONGQUANG'
	FROM	AT9000 
	WHERE	VoucherID = @VoucherID
			AND ISNULL(Ana01ID, '') <> ''
END

IF @Mode = 2
BEGIN
	
	DELETE FROM AT0999 WHERE UserID = @UserID AND TransTypeID = 'DONGQUANG' AND KeyID = @VoucherID
	
	INSERT INTO AT0999 (UserID, KeyID, [Str02], TransTypeID)
	SELECT	DISTINCT @UserID , @VoucherID , Ana01ID, 'DONGQUANG'
	FROM	AT9000 
	WHERE	VoucherID = @VoucherID
			AND ISNULL(Ana01ID, '') <> ''
	
	SELECT		T1.ObjectID,	T4.ObjectName,
				T1.ContractID,	T1.OriginalAmount,
				T1.CurrencyID,	T1.InvoiceNo,				T2.CostAmount,
				T3.AgentID,		T5.ObjectName AS AgentName,
				T3.AgentDate,	T3.AgentAmount,
				T6.TTR ,
				T1.ReceiveDate,
				CASE WHEN @Action = 1 THEN N'Thêm'
						WHEN @Action = 2 THEN N'Sửa'
							WHEN @Action = 3 THEN N'Xóa' END Status
	FROM		
	--- Số tiền khách hàng chuyển tiền
				(
	SELECT		A.ObjectID, MAX(A.VoucherDate) AS ReceiveDate,
				SUM(ISNULL(A.OriginalAmount, 0)) AS OriginalAmount, 
				A.CurrencyID, A.Ana02ID AS InvoiceNo,
				A.Ana01ID AS ContractID
	FROM		AT9000 A
	WHERE		A.Ana01ID IN (	SELECT	Str02 
	     						FROM	AT0999 
	     		              	WHERE	UserID = @UserID 
	     		              			AND TransTypeID = 'DONGQUANG' 
	     		              			AND KeyID = @VoucherID
	     		              )
				AND (	A.TransactionTypeID = 'T01'-- Tiền mặt
						OR A.TransactionTypeID = 'T21'-- Tiền ngân hàng
					)
			
	GROUP BY	A.ObjectID, A.Ana01ID, A.CurrencyID, A.Ana02ID
				)T1
				
	LEFT JOIN	(
	-------Chi tiền phi ngan hang
	SELECT		A.ObjectID, 
				SUM(ISNULL(A.OriginalAmount, 0)) AS CostAmount,
				A.Ana01ID AS ContractID
	FROM		AT9000 A
	WHERE		A.Ana01ID IN (	SELECT	Str02 
	     						FROM	AT0999 
	     		              	WHERE	UserID = @UserID 
	     		              			AND TransTypeID = 'DONGQUANG' 
	     		              			AND KeyID = @VoucherID
	     		              )
				AND (	A.TransactionTypeID = 'T99'	-- Phí ngân hàng
						OR A.TransactionTypeID = 'T02'	-- Chi tiền mặt
						OR A.TransactionTypeID = 'T22' -- Chi qua ngân hàng
					)
				AND (A.Ana02ID = 'PNHT' OR A.Ana02ID = 'PNHN')
	GROUP BY	A.ObjectID, A.Ana01ID
				)T2
		ON		T1.ContractID = T2.ContractID
		
	LEFT JOIN	(	
	---- Chi Hoa hồng
	SELECT		A.ObjectID AS AgentID, MAX(A.VoucherDate) AS AgentDate,
				SUM(ISNULL(A.OriginalAmount, 0)) AS AgentAmount, 				
				A.Ana01ID AS ContractID
	FROM		AT9000 A
	WHERE		A.Ana01ID IN (	SELECT	Str02 
	     						FROM	AT0999 
	     		              	WHERE	UserID = @UserID 
	     		              			AND TransTypeID = 'DONGQUANG' 
	     		              			AND KeyID = @VoucherID
	     		              )
				AND (	A.TransactionTypeID = 'T99'	-- Phí ngân hàng
						OR A.TransactionTypeID = 'T02'	-- Chi tiền mặt
						OR A.TransactionTypeID = 'T22' -- Chi qua ngân hàng
					)
				AND A.DebitAccountID LIKE '641%'
	GROUP BY	A.ObjectID, A.Ana01ID
				)T3
		ON		T3.ContractID = T1.ContractID

	----- Trả tiền trước
	LEFT JOIN	(
	SELECT		A.ObjectID, 
				SUM(ISNULL(A.OriginalAmount, 0)) AS TTR,
				A.Ana01ID AS ContractID
	FROM		AT9000 A
	WHERE		A.Ana01ID IN (	SELECT	Str02 
	     						FROM	AT0999 
	     		              	WHERE	UserID = @UserID 
	     		              			AND TransTypeID = 'DONGQUANG' 
	     		              			AND KeyID = @VoucherID
	     		              )
				AND (	A.TransactionTypeID = 'T99'	-- Phí ngân hàng
						OR A.TransactionTypeID = 'T02'	-- Chi tiền mặt
						OR A.TransactionTypeID = 'T22' -- Chi qua ngân hàng
					)
				AND (A.Ana02ID = 'TTR' )
	GROUP BY	A.ObjectID, A.Ana01ID
				)T6
		ON		T1.ContractID = T6.ContractID
				AND T6.ObjectID = T1.ObjectID		
		
	LEFT JOIN	AT1202 T4
		ON		T4.ObjectID = T1.ObjectID
	LEFT JOIN	AT1202 T5
		ON		T5.ObjectID = T3.AgentID
END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO	

