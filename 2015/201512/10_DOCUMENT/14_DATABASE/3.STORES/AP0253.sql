IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0253]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0253]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load/Tạo bút toán chênh lệch tỷ giá xuất
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 07/09/2011 by Nguyễn Bình Minh
---- 
---- Modified on 06/12/2011 by Nguyễn Bình Minh: Bổ sung phương pháp tính tỷ giá xuất theo bình quân gia quyền cuối kỳ
---- Modified on 09/05/2012 by Nguyễn Bình Minh (0016604): Sửa lỗi điều kiện lọc theo loại tiền không đúng -> tính sai tỷ giá
---- Modified on 10/05/2012 by Thien Huynh : Bo sung 5 Khoan muc
-- <Example>
/*
	DELETE AT0999
	INSERT INTO AT0999 (UserID, KeyID, TransTypeID) VALUES ('ADMIN', '1111', 'ACC')
	INSERT INTO AT0999 (UserID, KeyID, TransTypeID, Num01) VALUES ('ADMIN', 'USD', 'CUR', 21000)
	EXEC AP0253 @DivisionID = 'MFN', @UserID = 'ADMIN', @TimeMode = 1, @TranMonth = 1, @TranYear = 2011, @FromDate = '2011/01/01', @ToDate = '2011/01/31', @InterestExpCurExchDiffAccID = '511', @LostExpCurExchDiffAccID = '635', @VoucherID = NULL
*/	
CREATE PROCEDURE AP0253
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),	
	@TimeMode AS TINYINT, -- 0: Ngày, 1: Kỳ
	@TranMonth AS TINYINT,
	@TranYear AS INT,
	@FromDate AS DATETIME,
	@ToDate AS DATETIME,
	@InterestExpCurExchDiffAccID AS NVARCHAR(50),
	@LostExpCurExchDiffAccID AS NVARCHAR(50),
	@VoucherID AS NVARCHAR(50)
) 
AS

SELECT @FromDate = CONVERT(datetime, CONVERT(varchar(10), @FromDate, 101)), @ToDate = CONVERT(datetime, CONVERT(varchar(10), @ToDate, 101))

-- Tạo bút toán CLTG xuất
IF @VoucherID IS NULL
BEGIN
	DECLARE @ExpCurExchDiffAccType AS TINYINT,
			@BaseCurrencyID AS NVARCHAR(50)
			
	-- Lấy loại chênh lệch tỷ giá xuất
	SELECT	TOP 1 
			@ExpCurExchDiffAccType = ExpCurExchDiffAccType 
	FROM	AT0000 
	WHERE	DefDivisionID = @DivisionID	
	
	IF @ExpCurExchDiffAccType = 0
		RETURN
		
	SELECT		NV.VoucherNo AS ReVoucherNo,	
				NV.VoucherID AS ReVoucherID,		
				NV.BatchID AS ReBatchID,	
				NV.TransactionID AS ReTransactionID,
				CASE WHEN NV.TransactionTypeID = 'T16' THEN NV.CurrencyIDCN ELSE NV.CurrencyID END AS CurrencyID,
				NV.EmployeeID,		NV.ObjectID,	OB.ObjectName,
				NV.CreditAccountID AS AccountID,
				NV.CreditBankAccountID AS BankAccountID,
				CASE WHEN NV.TransactionTypeID = 'T16' THEN NV.OriginalAmountCN ELSE NV.OriginalAmount END AS OriginalAmount,		
				NV.ConvertedAmount,
				CONVERT(DECIMAL(28,8), 0) AS AmountOffset,
				CUR.ExchangeRateDecimal,
				CUR.Operator,
				ROUND(	CASE WHEN CUR.Operator = 0 THEN 
							CASE WHEN (CASE WHEN NV.TransactionTypeID = 'T16' THEN NV.OriginalAmountCN ELSE NV.OriginalAmount END) = 0 THEN 
								0
							ELSE 
								NV.ConvertedAmount / (CASE WHEN NV.TransactionTypeID = 'T16' THEN NV.OriginalAmountCN ELSE NV.OriginalAmount END)
							END 
						ELSE
							CASE WHEN NV.ConvertedAmount = 0 THEN 
								0
							ELSE 
								(CASE WHEN NV.TransactionTypeID = 'T16' THEN NV.OriginalAmountCN ELSE NV.OriginalAmount END) / NV.ConvertedAmount 
							END
						END, CUR.ExchangeRateDecimal) AS ExchangeRate,
				CONVERT(DECIMAL(28,8), 0) AS DiffExchangeRate,
				NV.Ana01ID, NV.Ana02ID, NV.Ana03ID, NV.Ana04ID, NV.Ana05ID,
				NV.Ana06ID, NV.Ana07ID, NV.Ana08ID, NV.Ana09ID, NV.Ana10ID				
	INTO		#OutTransList
	FROM		AT9000 NV
	INNER JOIN	AT1004 CUR
			ON	CUR.DivisionID = NV.DivisionID AND CUR.CurrencyID = NV.CurrencyID
	LEFT JOIN	AT1202 OB
			ON	OB.ObjectID = NV.ObjectID AND OB.DivisionID = NV.DivisionID			
	WHERE	NV.DivisionID = @DivisionID AND NV.TransactionTypeID IN ('T02', 'T16', 'T11', 'T22', 'T99')
			AND NOT EXISTS (SELECT TOP 1 1 FROM AT9000 LNV WHERE LNV.DivisionID = NV.DivisionID AND LNV.ReVoucherID = NV.VoucherID AND LNV.ReBatchID = NV.BatchID AND LNV.ReTransactionID = NV.TransactionID) 
			AND CASE WHEN NV.TransactionTypeID = 'T16' THEN NV.CurrencyIDCN ELSE NV.CurrencyID END IN (SELECT KeyID FROM AT0999 WHERE UserID = @UserID AND TransTypeID = 'CUR')
			AND NV.CreditAccountID IN (SELECT KeyID FROM AT0999 WHERE UserID = @UserID AND TransTypeID = 'ACC')
			AND NV.TranMonth = @TranMonth AND NV.TranYear = @TranYear
			AND NV.VoucherDate >= CASE WHEN @TimeMode = 0 THEN @FromDate ELSE NV.VoucherDate END AND NV.VoucherDate < CASE WHEN @TimeMode = 0 THEN @ToDate ELSE NV.VoucherDate END + 1

	IF @ExpCurExchDiffAccType = 1	 -- Ty gia hach toan
	BEGIN
		-- Xóa các bút toán không có CLTG
		DELETE		TL
		FROM		#OutTransList TL
		INNER JOIN	AT0999 CUR
				ON	CUR.UserID = @UserID AND CUR.KeyID = TL.CurrencyID AND CUR.TransTypeID = 'CUR'
		WHERE		CUR.Num01 = TL.ExchangeRate OR TL.ExchangeRate = 0 OR CUR.Num01 = 0
					
		-- Tính chênh lệch tỷ giá xuất
		UPDATE		TL
		SET			AmountOffset = TL.ConvertedAmount - ROUND(	(CASE WHEN TL.Operator = 0 THEN 
																			TL.OriginalAmount * CUR.Num01 
																		ELSE TL.OriginalAmount / CUR.Num01 END), TL.ExchangeRateDecimal),
					DiffExchangeRate = CUR.Num01
		FROM		#OutTransList TL
		INNER JOIN	AT0999 CUR
				ON	CUR.UserID = @UserID AND CUR.KeyID = TL.CurrencyID AND CUR.TransTypeID = 'CUR'
	END
	
	IF @ExpCurExchDiffAccType = 2 -- Binh quan gia quyen cuoi ky
	BEGIN
		-- Lấy dữ liệu để tính tỷ giá 
		SELECT		NV.DebitAccountID AS AccountID,
					NV.CurrencyID,
					SUM(NV.OriginalAmount) AS OriginalAmount,
					SUM(NV.ConvertedAmount) AS ConvertedAmount
		INTO		#AverageExg
		FROM		AT9000 NV
		WHERE		NV.DivisionID = @DivisionID 
					AND NV.DebitAccountID IN (SELECT KeyID FROM AT0999 WHERE UserID = @UserID AND TransTypeID = 'ACC')
					AND NV.CurrencyID IN (SELECT KeyID FROM AT0999 WHERE UserID = @UserID AND TransTypeID = 'CUR')					
					AND (NV.TransactionTypeID = 'T00' OR (NV.TranMonth + NV.TranYear * 100 <= @TranMonth + @TranYear * 100))
		GROUP BY 	NV.DebitAccountID,
					NV.CurrencyID					
		UNION ALL
		SELECT		NV.CreditAccountID AS AccountID,
					CASE WHEN NV.TransactionTypeID = 'T16' THEN NV.CurrencyIDCN ELSE NV.CurrencyID END AS CurrencyID,
					SUM(- CASE WHEN NV.TransactionTypeID = 'T16' THEN NV.OriginalAmountCN ELSE NV.OriginalAmount END) AS OriginalAmount,
					SUM(- NV.ConvertedAmount) AS ConvertedAmount
		FROM		AT9000 NV
		WHERE		NV.DivisionID = @DivisionID 
					AND NV.CreditAccountID IN (SELECT KeyID FROM AT0999 WHERE UserID = @UserID AND TransTypeID = 'ACC')
					AND CASE WHEN NV.TransactionTypeID = 'T16' THEN NV.CurrencyIDCN ELSE NV.CurrencyID END IN (SELECT KeyID FROM AT0999 WHERE UserID = @UserID AND TransTypeID = 'CUR')
					AND (NV.TransactionTypeID = 'T00' OR (NV.TranMonth + NV.TranYear * 100 < @TranMonth + @TranYear * 100))
		GROUP BY 	NV.CreditAccountID,
					CASE WHEN NV.TransactionTypeID = 'T16' THEN NV.CurrencyIDCN ELSE NV.CurrencyID END
					
		-- Tính tỷ giá bình quân cuối kỳ
		SELECT		AE.AccountID, AE.CurrencyID,
					ROUND(	CASE WHEN CUR.Operator = 0 THEN 
								CASE WHEN SUM(AE.OriginalAmount) = 0 THEN 
									0
								ELSE 
									SUM(AE.ConvertedAmount) / SUM(AE.OriginalAmount)
								END 
							ELSE
								CASE WHEN SUM(AE.ConvertedAmount) = 0 THEN 
									0
								ELSE 
									SUM(AE.OriginalAmount) / SUM(AE.ConvertedAmount)
								END
							END, CUR.ExchangeRateDecimal) AS ExchangeRate
		INTO		#ListAverageExg 
 		FROM		#AverageExg AE
		INNER JOIN	AT1004 CUR
				ON	CUR.CurrencyID = AE.CurrencyID
 		GROUP BY	AE.AccountID, AE.CurrencyID, CUR.Operator, CUR.ExchangeRateDecimal
 		
 		-- Xóa các bút toán không có CLTG
		DELETE		TL
		FROM		#OutTransList TL
		INNER JOIN	#ListAverageExg CUR
				ON	CUR.AccountID = TL.AccountID AND CUR.CurrencyID = TL.CurrencyID
		WHERE		CUR.ExchangeRate = TL.ExchangeRate OR TL.ExchangeRate = 0 OR CUR.ExchangeRate = 0
		
		-- Tính chênh lệch tỷ giá xuất
		UPDATE		TL
		SET			AmountOffset = TL.ConvertedAmount - ROUND(	(CASE WHEN TL.Operator = 0 THEN 
																			TL.OriginalAmount * CUR.ExchangeRate 
																		ELSE TL.OriginalAmount / CUR.ExchangeRate END), TL.ExchangeRateDecimal),
					DiffExchangeRate = CUR.ExchangeRate
		FROM		#OutTransList TL
		INNER JOIN	#ListAverageExg CUR
				ON	CUR.AccountID = TL.AccountID AND CUR.CurrencyID = TL.CurrencyID					
	END	
	
	SELECT		CASE WHEN AmountOffset > 0 THEN 0 ELSE 1 END AS ExchDiffType,
				CONVERT(INT, 0) AS OrderNum,
				CONVERT(UNIQUEIDENTIFIER, NULL) AS APK,
				CONVERT(NVARCHAR(50), '') AS VoucherTypeID,
				CONVERT(NVARCHAR(50), '') AS VoucherID,
				CONVERT(NVARCHAR(50), '') AS BatchID,
				CONVERT(NVARCHAR(50), '') AS TransactionID,
				ReVoucherNo,	
				ReVoucherID,		
				ReBatchID,	
				ReTransactionID,
				CONVERT(NVARCHAR(50), '') AS EmployeeID,
				CONVERT(NVARCHAR(50), '') AS EmployeeName,
				CONVERT(NVARCHAR(50), '') AS VoucherNo,
				CONVERT(NVARCHAR(50), '') AS BDescription,
				CONVERT(DATETIME, GETDATE()) AS VoucherDate,
				CurrencyID,
				DiffExchangeRate AS ExchangeRate,
				ABS(AmountOffset) AS ConvertedAmount,
				CASE WHEN AmountOffset < 0 THEN @LostExpCurExchDiffAccID ELSE AccountID END AS DebitAccountID,
				CASE WHEN AmountOffset < 0 THEN AccountID ELSE @InterestExpCurExchDiffAccID END AS CreditAccountID,
				CASE WHEN AmountOffset < 0 THEN NULL ELSE BankAccountID END AS DebitBankAccountID,
				CASE WHEN AmountOffset < 0 THEN BankAccountID ELSE NULL END AS CreditBankAccountID,					
				ObjectID,
				ObjectName,
				CONVERT(NVARCHAR(50), '') AS TDescription,
				Ana01ID,	Ana02ID,		Ana03ID,			Ana04ID,			Ana05ID,
				Ana06ID,	Ana07ID,		Ana08ID,			Ana09ID,			Ana10ID,
				'AT9000' AS TableID,
				0 AS IsStock,
				'0' AS Status,
				0 AS IsAudit,
				0 AS IsCost
	FROM		#OutTransList
	WHERE		AmountOffset <> 0
END

IF ISNULL(@VoucherID, '') <> ''
BEGIN
	SELECT		CASE WHEN AC.AccountID IS NOT NULL THEN 1 ELSE 0 END AS ExchDiffType,
				CONVERT(INT, 0) AS OrderNum,
				NV.APK,
				NV.VoucherTypeID,
				NV.VoucherID,
				NV.BatchID,
				NV.TransactionID,
				LNV.VoucherNo AS ReVoucherNo,	
				NV.ReVoucherID,		
				NV.ReBatchID,	
				NV.ReTransactionID,
				NV.EmployeeID,
				EM.ObjectName AS EmployeeName,
				NV.VoucherNo,
				NV.BDescription,
				NV.VoucherDate,
				NV.CurrencyID,
				NV.ExchangeRate,
				NV.ConvertedAmount,
				NV.DebitAccountID,
				NV.CreditAccountID,
				NV.DebitBankAccountID,
				NV.CreditBankAccountID,	
				NV.ObjectID,
				OB.ObjectName,
				NV.TDescription,
				NV.TableID,				NV.IsStock,				
				NV.Status,				NV.IsAudit,				NV.IsCost,
				NV.Ana01ID,				NV.Ana02ID,				NV.Ana03ID,				NV.Ana04ID,				NV.Ana05ID,
				NV.Ana06ID,				NV.Ana07ID,				NV.Ana08ID,				NV.Ana09ID,				NV.Ana10ID
	FROM		AT9000 NV
	LEFT JOIN	AT1202 EM
			ON	EM.ObjectID = NV.EmployeeID AND EM.DivisionID = NV.DivisionID
	LEFT JOIN	AT1202 OB
			ON	OB.ObjectID = NV.ObjectID AND OB.DivisionID = NV.DivisionID
	LEFT JOIN	AT9000 LNV
			ON	LNV.DivisionID = NV.DivisionID AND LNV.VoucherID = NV.ReVoucherID AND LNV.BatchID = NV.ReBatchID AND LNV.TransactionID = NV.ReTransactionID
	LEFT JOIN	AT1005 AC
			ON	AC.DivisionID = NV.DivisionID AND AC.AccountID = NV.CreditAccountID AND AC.GroupID = 'G01' 			 			
	WHERE		NV.DivisionID = @DivisionID AND NV.VoucherID = @VoucherID AND NV.TransactionTypeID = 'T19'
				AND NV.TranMonth = @TranMonth AND NV.TranYear = @TranYear			
END



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

