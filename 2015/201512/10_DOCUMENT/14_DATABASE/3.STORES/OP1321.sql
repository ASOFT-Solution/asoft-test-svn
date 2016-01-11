IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP1321]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP1321]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Created by Nguyen Thi Thuy Tuyen  , Date 	10/07/2006      
--Purpose: Kiem tra cong no khach hang,
-- Last Edit: Thuy Tuyen , date 29/08/2008
/********************************************
'* Edited by: [GS] [Thanh Trẫm] [03/08/2010]
'********************************************/
--- Modify on 30/09/2013 by Bảo Anh: Dùng bảng tạm/sửa câu query thay cho view AV4202, AV0301 để cải thiện tốc độ
--- Modify on 14/01/2013 by Bảo Anh: Dùng bảng tạm thay AT9000 khi lấy giá trị @ReceivedDays
--- OP1321 'TL','KHKL002','10/15/2013',40000000,'VND'

CREATE PROCEDURE OP1321
(
	@DivisionID NVARCHAR(50), 
	@ObjectID NVARCHAR(50),	
	@VoucherDate DATETIME,
	@NewOriginalAmount DECIMAL,	
	@CurrencyID NVARCHAR(50)
)				
AS
--Set NoCount on
DECLARE @ReAccountID NVARCHAR(50),
		@PaAccountID NVARCHAR(50),
		@ReceivedAmount MONEY,
		@MaxReceivedAmount MONEY,
		@ReceivedDays INT, 
		@MaxReceivedDays INT, 
		@PaymentAmount MONEY,
		@Message NVARCHAR(250) = '',
		@Status TINYINT = 0
			
--SET @Status = 0
--SET @Message = ''

SELECT @ReAccountID = ReAccountID, @PaAccountID = PaAccountID FROM AT1202 WHERE ObjectID = @ObjectID
SET @ReAccountID = ISNULL(@ReAccountID, '131')
SET @PaAccountID = ISNULL(@PaAccountID, '331')

IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#TAM')) 
	DROP TABLE #TAM	
--- Tạo bảng tạm thay cho view AV4202
SELECT 	VoucherID, BatchID, TableID, CurrencyIDCN, VoucherDate, DebitAccountID AccountID, ---- PHAT SINH NO
	SUM(ISNULL(OriginalAmountCN, 0)) OriginalAmount, 'D' D_C
INTO #TAM
FROM AT9000 ---inner join AT1005 on AT1005.DivisionID = AT9000.DivisionID and AT1005.AccountID = AT9000.DebitAccountID
WHERE DivisionID = @DivisionID AND ObjectID = @ObjectID AND VoucherDate <= @VoucherDate
AND ISNULL(DebitAccountID, '') = @ReAccountID AND CurrencyIDCN = @CurrencyID ---and AT1005.GroupID  in ('G03')
AND DebitAccountID IN (SELECT AccountID FROM AT1005 WHERE GroupID = 'G03')
GROUP BY VoucherID, BatchID, TableID, CurrencyIDCN, VoucherDate, DebitAccountID 		  

UNION ALL

SELECT VoucherID, BatchID, TableID, CurrencyIDCN, VoucherDate, CreditAccountID AccountID,	---- PHAT SINH CO
	SUM(ISNULL(OriginalAmountCN, 0) * -1)OriginalAmount, 'C' D_C
FROM AT9000 ---inner join AT1005 on AT1005.DivisionID = AT9000.DivisionID and AT1005.AccountID = AT9000.CreditAccountID
WHERE DivisionID = 'TL' 
AND (CASE WHEN TransactionTypeID = 'T99' THEN CreditObjectID ELSE ObjectID END) = @ObjectID
AND CreditObjectID = @ObjectID
AND VoucherDate <= @VoucherDate 
AND ISNULL(CreditAccountID, '') = @ReAccountID 
AND CurrencyIDCN = @CurrencyID ---and AT1005.GroupID in ('G03')
AND CreditAccountID IN (SELECT AccountID FROM AT1005 WHERE GroupID = 'G03')
GROUP BY VoucherID, BatchID, TableID, CurrencyIDCN, VoucherDate, CreditAccountID

----- Buoc 1: Lay so du no den hien tai.------------------------------------
SELECT @ReceivedAmount = ISNULL(SUM(ISNULL(OriginalAmount, 0)), 0) 
FROM #TAM

----- Buoc 2: Lay tuoi no cao nhat den hien tai-------------------------------
---Set @ReceivedDays = isnull((Select Max(DATEDIFF(day,VoucherDate, @VoucherDate)) From #TAM1 Where OriginalAmount- GivedOriginalAmount <>0),0) 
SET @ReceivedDays = ISNULL((SELECT MAX(DATEDIFF(DAY, VoucherDate, @VoucherDate)) 
                            FROM (
                            	SELECT VoucherID, SUM(ISNULL(OriginalAmount, 0)) OriginalAmount,
                            		GivedOriginalAmount = ISNULL((SELECT SUM(ISNULL(OriginalAmount, 0)) 
                            	                              FROM AT0303 
                            	                              WHERE	DivisionID = @DivisionID
                            	                              AND ObjectID = @ObjectID
                            	                              AND DebitVoucherID = #TAM.VoucherID
                            	                              AND DebitBatchID = #TAM.BatchID
                            	                              AND DebitTableID = #TAM.TableID
                            	                              AND AccountID = @ReAccountID
                            	                              AND CurrencyID = @CurrencyID), 0),
									VoucherDate
								FROM #TAM
								WHERE D_C = 'D'
								GROUP BY VoucherID, BatchID, TableID, VoucherDate) A
							WHERE OriginalAmount - GivedOriginalAmount <> 0), 0)

---- Buoc 3: Lay muc han no (so tien) va muc tuoi no (ngay)--------------
SELECT @MaxReceivedAmount = ReCreditLimit, @MaxReceivedDays = ReDueDays
FROM AT1202
WHERE DivisionID = @DivisionID AND ObjectID = @ObjectID

---- Buoc 4: So sanh so thuc te va so han muc-------------------------------------
IF (ISNULL(@NewOriginalAmount + @ReceivedAmount, 0) > @MaxReceivedAmount AND ISNULL(@ReceivedDays, 0) > @MaxReceivedDays 
	AND ISNULL (@MaxReceivedAmount, 0) <> 0 AND ISNULL(@MaxReceivedDays, 0) <> 0)
   BEGIN
		SET @Status = 1
		SET @Message = 'OFML000155'
		GOTO EndMess
  END	

IF (ISNULL(@NewOriginalAmount + @ReceivedAmount, 0) > @MaxReceivedAmount AND ISNULL(@MaxReceivedAmount, 0) <> 0)
   BEGIN
	SET @Status = 1
	SET @Message = 'OFML000156'
	GOTO EndMess
  END	
IF ISNULL(@ReceivedDays, 0) > @MaxReceivedDays AND ISNULL(@MaxReceivedDays, 0) <> 0
  BEGIN
	SET @Status = 1
	SET @Message = 'OFML000156'
	GOTO EndMess
  END	
---PRINT @Status
---- Buoc 5: Tra ra ket qua ----------------------------------------
EndMess:
SELECT @Status [Status], @Message [Message]

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
