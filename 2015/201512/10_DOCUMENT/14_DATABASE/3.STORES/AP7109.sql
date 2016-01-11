IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7109]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7109]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

------- Created BY Van Nhan & Bao Annh Date 05/03/2007.
------- In so cai - Truy vna nguoc tu bang can doi phat sinh

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/
---- Modified on 22/10/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị

CREATE PROCEDURE [dbo].[AP7109]
    @DivisionID AS NVARCHAR(50), 
    @TranMonthFrom AS INT, 
    @TranYearFrom AS INT, 
    @TranMonthTo AS INT, 
    @TranYearTo AS INT,
    @StrDivisionID AS NVARCHAR(4000) = ''
AS

DECLARE @strSQL AS NVARCHAR(4000)
DECLARE @StrDivisionID_New AS NVARCHAR(4000)
SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END

SET @strSQL = '
    SELECT DivisionID, BatchID, TransactionTypeID, 
        AccountID, CorAccountID, D_C, 
        DebitAccountID, CreditAccountID, 
        CASE WHEN TransactionTypeID = ''T98'' THEN DateAdd(hh, 1, VoucherDate) ELSE VoucherDate END AS VoucherDate, 
        VoucherTypeID, VoucherNo, 
        InvoiceDate, InvoiceNo, Serial, 
        SUM(ISNULL(ConvertedAmount, 0)) AS ConvertedAmount, 
        SUM(ISNULL(OriginalAmount, 0)) AS OriginalAmount, 
        SUM(ISNULL(OSignAmount, 0)) AS OSignAmount, 
        SUM(ISNULL(SignAmount, 0)) AS SignAmount, 
        CurrencyID, ExchangeRate, 
        TranMonth, TranYear, TranMonth + TranYear * 100 AS Period, 
        CreateUserID, VDescription, BDescription, TDescription, 
        ObjectID, VATObjectID, 
        VATNo, VATObjectName, Object_Address, 
        VATTypeID, VATGroupID, 
        AccountID AS LinkAccountID 
    FROM AV5000
    WHERE DivisionID '+@StrDivisionID_New+'
        AND TranYear * 100 + TranMonth < = ''' + STR(@TranYearTo * 100 + @TranMonthTo) + '''
    GROUP BY DivisionID, BatchID, TransactionTypeID, 
        AccountID, CorAccountID, D_C, 
        DebitAccountID, CreditAccountID, 
        VoucherDate, VoucherTypeID, VoucherNo, 
        InvoiceDate, InvoiceNo, Serial, 
        CurrencyID, ExchangeRate, TranMonth, TranYear, 
        CreateUserID, VDescription, BDescription, TDescription, 
        ObjectID, VATObjectID, 
        VATNo, VATObjectName, Object_Address, 
        VATTypeID, VATGroupID, 
        AccountID
'

--Print @strSQL
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV4310' AND SYSOBJECTS.XTYPE = 'V')
    EXEC ('CREATE VIEW AV4310 --ap7109
    AS ' + @strSQL)
ELSE
    EXEC ('ALTER VIEW AV4310 --ap7109
    AS ' + @strSQL)

---- Chi hien thi So du
SET @strSQL = '
    SELECT V10.LinkAccountID, T01.AccountName, T01.AccountNameE, V10.DivisionID,
        SUM(CASE 
                WHEN V10.TranYear * 100 + TranMonth < ''' + STR(@TranYearFrom * 100 + @TranMonthFrom) + ''' 
                        OR V10.TransactionTypeID = ''' + 'T00' + ''' 
                    THEN SignAmount 
                ELSE 0 
            END) AS OpeningAmount,
        SUM(SignAmount) AS ClosingAmount, 
        SUM (CASE 
                WHEN (V10.TranYear * 100 + V10.TranMonth) < = ''' + STR(@TranYearTo * 100 + @TranMonthTo) + ''' 
                        AND (V10.TranYear > = ''' + STR(@TranYearFrom) + ''') 
                        AND V10.D_C = ''' + 'D' + ''' 
                        AND V10.TransactionTypeID <> ''' + 'T00' + '''
                    THEN ConvertedAmount 
                ELSE 0 
            END) AS AccumulatedDebit, 
        SUM (CASE 
                WHEN (V10.TranYear * 100 + V10.TranMonth) < = ''' + STR(@TranYearTo * 100 + @TranMonthTo) + ''' 
                        AND (V10.TranYear > = ''' + STR(@TranYearFrom) + ''') 
                        AND V10.D_C = ''' + 'C' + ''' 
                        AND V10.TransactionTypeID <> ''' + 'T00' + '''
                    THEN ConvertedAmount 
                ELSE 0 
            END) AS AccumulatedCredit
    FROM AV4310 AS V10 LEFT JOIN AT1005 AS T01 ON T01.AccountID = V10.LinkAccountID and T01.DivisionID = V10.DivisionID
    GROUP BY V10.LinkAccountID, T01.AccountName, T01.AccountNameE, V10.DivisionID
'


IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV4315' AND SYSOBJECTS.XTYPE = 'V')
    EXEC ('CREATE VIEW AV4315 --ap7109
     AS ' + @strSQL)
ELSE
    EXEC ('ALTER VIEW AV4315  --ap7109
    AS ' + @strSQL)


----- Tra ra VIEW so lieu phat sinh -- error here
SET @strSQL = ' SELECT * FROM AV4310 AS V10 '
--SET @strSQL = @strSQL + ' WHERE TranYear * 100 + TranMonth > = ''' + STR(@TranYearFrom * 100 + @TranMonthFrom) + ''''
--SET @strSQL = @strSQL + 'AND (TransactionTypeID IS NULL OR TransactionTypeID <> ''' + 'T00' + ''')'
--IF @Level1 <> 0 
--SET @strSQL = @strSQL + 'AND len(V10.LinkAccountID) = ''' + STR(@Level1 + 2) + ''''
SET @strSQL = @strSQL + '
    WHERE V10.TranYear * 100 + V10.TranMonth > = ''' + STR(@TranYearFrom * 100 + @TranMonthFrom) + '''
        AND (V10.TransactionTypeID IS NULL OR V10.TransactionTypeID <> ''' + 'T00' + ''')'

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV4316' AND SYSOBJECTS.XTYPE = 'V')
    EXEC ('CREATE VIEW AV4316 AS  --AP7109
    ' + @strSQL)
ELSE
    EXEC ('ALTER VIEW AV4316 AS  --AP7109
    ' + @strSQL)

SET @strSQL = '
    SELECT	V16.DivisionID, V16.BatchID, V16.TransactionTypeID, V16.Period, 
			ISNULL(V16.LinkAccountID, V15.LinkAccountID) AS AccountID, 
			V16.CorAccountID AS CorAccountID, 
			V16.D_C AS D_C, V16.DebitAccountID, V16.CreditAccountID, 
			V16.VoucherTypeID, 
			V16.VoucherNo, V16.InvoiceDate, V16.VoucherDate, 
			V16.InvoiceNo, V16.Serial, V16.ConvertedAmount, V16.OriginalAmount, 
			V16.CurrencyID, V16.ExchangeRate, V16.SignAmount, V16.OSignAmount, 
			V16.TranMonth, V16.TranYear, V16.CreateUserID, V16.VDescription, V16.BDescription, 
			ISNULL(V16.TDescription, ISNULL(V16.BDescription, V16.VDescription)) AS TDescription, 
			V16. ObjectID, V16.VATObjectID, V16.VATNo, V16.VATObjectName, 
			V16.Object_Address, V16.VATTypeID, V16.VATGroupID, 
			V15.OpeningAmount, 
			V15.ClosingAmount, 
			V15.AccountName, 
			V15.AccountNameE, 
			V15.LinkAccountID AS ReportAccountID, 
			V15.AccumulatedDebit, 
			V15.AccumulatedCredit
    FROM	AV4315 AS V15 
    LEFT JOIN	AV4316 AS V16 ON V16.LinkAccountID = V15.LinkAccountID
				AND V15.DivisionID = V16.DivisionID
    WHERE ISNULL(V15.OpeningAmount, 0) <> 0 
        OR ISNULL(V15.ClosingAmount, 0) <> 0 
        OR ISNULL(V16.ConvertedAmount, 0) <> 0 
'

--print @strSQL
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV7109' AND SYSOBJECTS.XTYPE = 'V')
    EXEC ('CREATE VIEW AV7109 AS  --ap7109
     ' + @strSQL)
ELSE
    EXEC ('ALTER VIEW AV7109 AS   --ap7109
    ' + @strSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

