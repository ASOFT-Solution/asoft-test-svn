IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0087]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0087]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Lấy dữ liệu để xử lý Báo cáo tiền gửi ngân hàng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 26/06/2013 by Lê Thị Thu Hiền
---- 
---- Modified on 26/06/2013 by 
---- Modified on 08/10/2015 by Tieu Mai: Sửa tiền hạch toán theo thiết lập đơn vị-chi nhánh
-- <Example>
---- EXEC AP0087 'AS', '1311', 'VND', '%' , 2, 1, 2011, 12, 2013, '2011-09-08', '2013-09-08'
CREATE PROCEDURE AP0087
( 
		@DivisionID AS NVARCHAR(50),
		@AccountID AS nvarchar(50),			
		@CurrencyID AS nvarchar(50),
		@ObjectID AS NVARCHAR(50),
		@IsTime AS INT,		-- 0 : Khong loc theo thoi gian
							-- 1 : Kỳ
							-- 2 : Ngày
		@FromMonth AS int,
		@FromYear AS int,
		@ToMonth AS int,
		@ToYear AS INT,
		@FromDate AS DATETIME,
		@ToDate AS DATETIME
) 
AS 
DECLARE @sSQL AS NVARCHAR(MAX),
		@sWHERE AS NVARCHAR(MAX),
		@sWHERE1 AS NVARCHAR(MAX),
		@sWHERE2 AS NVARCHAR(MAX)
SET @sWHERE = ''
SET @sWHERE1 = ''
SET @sWHERE2 = ''
---------------------->>>>> Dieu Kien loc
IF @DivisionID <> '' AND @DivisionID <> '%'
BEGIN
	SET @sWHERE = @sWHERE + ' 
		AND	AT9000.DivisionID = '''+@DivisionID+''' '
END

IF @CurrencyID <> '' AND @CurrencyID <> '%'
BEGIN
	SET @sWHERE1 = @sWHERE1 + ' 
		AND		CASE WHEN TransactionTypeID=''T16'' then CurrencyIDCN else AT9000.CurrencyID END = '''+@CurrencyID+''' '	
	SET @sWHERE2 = @sWHERE2 + ' 
		AND		AT1016.CurrencyID = '''+@CurrencyID+''' '
END

IF @ObjectID <> '' AND @ObjectID <> '%'
BEGIN
	SET @sWHERE = @sWHERE + ' 
		AND	AT9000.ObjectID = '''+@ObjectID+''' '
END

IF @AccountID <> '' AND @AccountID <> '%'
BEGIN
	SET @sWHERE1 = @sWHERE1 + ' 
		AND	AT9000.CreditBankAccountID = '''+@AccountID+''' '
	SET @sWHERE2 = @sWHERE2 + '
		AND AT9000.DebitBankAccountID = '''+@AccountID+''' '
END

IF @IsTime = 1
BEGIN
	SET @sWHERE = @sWHERE + N'	
		AND AT9000.TranYear*100+AT9000.TranMonth >= '+STR(@FromYear * 100 + @FromMonth)+'
		AND AT9000.TranYear*100+AT9000.TranMonth <= '+STR(@ToYear * 100 + @ToMonth)+' '
END

IF @IsTime = 2
BEGIN
	SET @sWHERE = @sWHERE + N'
		AND CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9000.VoucherDate,101),101) >= ''' + CONVERT(NVARCHAR(10), @FromDate ,101) + '''
		AND CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9000.VoucherDate,101),101) <= ''' + CONVERT(NVARCHAR(10), @ToDate ,101) + ''' '
END
---------------------------<<<<<<<<<<<<<<


SET @sSQL = N'
SELECT  AT9000.DivisionID,
		AT9000.TranMonth,
		AT9000.TranYear,
		CreditBankAccountID AS BankAccountID,
		CreditAccountID AS AccountID, 
		CreditAccountID,
		DebitAccountID,
	--	AT1016.CurrencyID,
		CASE WHEN TransactionTypeID=''T16'' then CurrencyIDCN else AT9000.CurrencyID END AS CurrencyID,
		CASE WHEN TransactionTypeID=''T16'' then ExchangeRateCN else AT9000.ExchangeRate End AS ExchangeRate,
		CASE WHEN TransactionTypeID=''T16'' then OriginalAmountCN else OriginalAmount End AS OriginalAmount,	
		ConvertedAmount,
		-CASE WHEN TransactionTypeID=''T16'' then OriginalAmountCN else OriginalAmount End AS SignOriginalAmount,	
		-ConvertedAmount AS SignConvertedAmount,
		VoucherDate,
		VoucherNo,
		VoucherID,
		ObjectID,
		VoucherTypeID
		VDescription,
		TDescription,
		BDescription,
		TransactionTypeID,
		''C'' AS D_C,
		Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
		AT9000.Ana06ID,	AT9000.Ana07ID,	AT9000.Ana08ID,AT9000.Ana09ID,AT9000.Ana10ID	 
FROM	AT9000 	
LEFT JOIN AT1016 on AT1016.BankAccountID = AT9000.CreditBankAccountID AND AT1016.DivisionID = AT9000.DivisionID
WHERE	ISNULL(CreditBankAccountID,'''') <>''''
		'+@sWHERE+'
		'+@sWHERE1+' 
UNION ALL
SELECT   AT9000.DivisionID,
		AT9000.TranMonth,
		AT9000.TranYear,
		DebitBankAccountID AS BankAccountID,
		DebitAccountID AS AccountID, 
		CreditAccountID,
		DebitAccountID,
		AT1016.CurrencyID,
		AT9000.ExchangeRate,
		CASE WHEN AT1016.CurrencyID = (SELECT   top 1 BasecurrencyID from AT1101 where DivisionID = @DivisionID) then ConvertedAmount else OriginalAmount end AS OriginalAmount,
		--OriginalAmount AS OriginalAmount,	
		ConvertedAmount,
		---OriginalAmount AS SignOriginalAmount,	
		CASE WHEN AT1016.CurrencyID = (SELECT  top  1  BasecurrencyID from AT1101 where DivisionID = @DivisionID)  then ConvertedAmount else OriginalAmount end AS SignOriginalAmount,
		ConvertedAmount AS SignConvertedAmount,

		VoucherDate,
		VoucherNo,
		VoucherID,
		ObjectID,
		VoucherTypeID
		VDescription,
		TDescription,
		BDescription,
		TransactionTypeID,
		''D'' AS D_C,
		Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
		AT9000.Ana06ID,	AT9000.Ana07ID,	AT9000.Ana08ID,AT9000.Ana09ID,AT9000.Ana10ID 
FROM	AT9000 	
LEFT JOIN AT1016 on AT1016.BankAccountID = AT9000.DebitBankAccountID AND AT1016.DivisionID = AT9000.DivisionID
WHERE  ISNULL(DebitBankAccountID,'''')<>''''
		'+@sWHERE+'
		'+@sWHERE2+' 

'

PRINT(@sSQL)

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME = 'AV0087' AND XTYPE ='V')
     EXEC ('  CREATE VIEW AV0087 AS ' + @sSQL)
ELSE
     EXEC ('  ALTER VIEW AV0087  AS ' + @sSQL)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

