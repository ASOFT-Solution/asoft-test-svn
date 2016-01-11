/****** Object:  StoredProcedure [dbo].[AP7111]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------- Created BY Nguyen Thi Ngoc Minh, Date 03/08/2004.
------- So chi tiet cac tai khoan(NKSC)

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7111]
    @DivisionID NVARCHAR(50), 
    @TranMonthFrom INT, 
    @TranYearFrom INT, 
    @TranMonthTo INT, 
    @TranYearTo INT, 
    @AccountIDFrom NVARCHAR(50), 
    @AccountIDTo NVARCHAR(50), 
    @ObjectIDFrom NVARCHAR(50), 
    @ObjectIDTo NVARCHAR(50)
--@Level1 AS TINYINT
AS

DECLARE 
    @strSQL AS NVARCHAR(4000), 
    @AT7111_Cursor AS CURSOR, 
    @DivisionID1 AS NVARCHAR(50), 
    @ObjectID AS NVARCHAR(50), 
    @Orders AS NVARCHAR(350), 
    @AccountID AS NVARCHAR(50), 
    @VoucherID AS NVARCHAR(50), 
    @VoucherDate AS DATETIME, 
    @TransactionID AS NVARCHAR(50), 
    @OpeningAmount AS DECIMAL(28, 8), 
    @SignAmount AS DECIMAL(28, 8), 
    @ClosingAmount AS DECIMAL(28, 8), 
    @AccummulatedAmount AS DECIMAL(28, 8) 
    
--IF @Level1 = 0
SET @strSQL = '
    SELECT DivisionID, VoucherID, BatchID, TransactionID, 
        CAST(AccountID AS char(20)) + CAST(ObjectID AS char(20)) + CAST(Day(AV5000.VoucherDate) +
        Month(AV5000.VoucherDate) * 100 + Year(AV5000.VoucherDate) * 10000 AS char(8)) + 
        CAST(AV5000.VoucherID AS char(20)) + CAST(AV5000.TransactionID AS char(20)) + 
        (CASE WHEN AV5000.TransactionTypeID = ''T00'' THEN ''0'' ELSE ''1'' END) AS Orders, 
        TransactionTypeID, 
        AccountID, CorAccountID, D_C, 
        VoucherDate, VoucherTypeID, VoucherNo, 
        InvoiceDate, InvoiceNo, Serial, CreateDate, 
        SUM(ISNULL(ConvertedAmount, 0)) AS ConvertedAmount, 
        SUM(ISNULL(OriginalAmount, 0)) AS OriginalAmount, 
        SUM(ISNULL(OSignAmount, 0)) AS OSignAmount, 
        SUM(ISNULL(SignAmount, 0)) AS SignAmount, 
        TranMonth, TranYear, 
        ISNULL(TDescription, ISNULL(BDescription, VDescription)) AS Description, 
        ObjectID, 
        AccountID AS LinkAccountID '
/* 
ELSE
SET @strSQL = 'SELECT 
DivisionID, VoucherID, BatchID, TransactionID, 
CAST(AccountID AS char(20)) + CAST(ObjectID AS char(20)) + CAST(Day(AV5000.VoucherDate) + 
Month(AV5000.VoucherDate) * 100 + Year(AV5000.VoucherDate) * 10000 AS char(8)) + 
CAST(AV5000.VoucherID AS char(20)) + CAST(AV5000.TransactionID AS char(20)) + 
(CASE WHEN AV5000.TransactionTypeID = ''T00'' THEN ''0'' ELSE ''1'' END) AS Orders, 
TransactionTypeID, 
AccountID, CorAccountID, D_C, 
VoucherDate, VoucherTypeID, VoucherNo, 
InvoiceDate, InvoiceNo, Serial, CreateDate, 
SUM(ISNULL(ConvertedAmount, 0)) AS ConvertedAmount, 
SUM(ISNULL(OriginalAmount, 0)) AS OriginalAmount, 
SUM(ISNULL(OSignAmount, 0)) AS OSignAmount, 
SUM(ISNULL(SignAmount, 0)) AS SignAmount, 
TranMonth, TranYear, 
ISNULL(TDescription, ISNULL(BDescription, VDescription)) AS Description, 
ObjectID, 
LEFT(AccountID, ' + STR(@Level1 + 2) + ') AS LinkAccountID'
*/

SET @strSQL = @strSQL + '
    FROM AV5000 
    WHERE DivisionID LIKE ''' + @DivisionID + '''
        AND(AccountID LIKE ''' + @AccountIDFrom + '%'' OR AccountID LIKE ''' + @AccountIDTo + '%''
            OR(AccountID > = ''' + @AccountIDFrom + ''' AND AccountID < = ''' + @AccountIDTo + '''))
        AND(ObjectID LIKE ''' + @ObjectIDFrom + '%'' OR ObjectID LIKE ''' + @ObjectIDTo + '%''
            OR(ObjectID > = ''' + @ObjectIDFrom + ''' AND ObjectID < = ''' + @ObjectIDTo + '''))
        AND TranYear * 100 + TranMonth < = ''' + STR(@TranYearTo * 100 + @TranMonthTo) + '''
    GROUP BY DivisionID, VoucherID, BatchID, TransactionID, 
        TransactionTypeID, AccountID, CorAccountID, D_C, 
        VoucherDate, VoucherTypeID, VoucherNo, 
        InvoiceDate, InvoiceNo, Serial, CreateDate, 
        TranMonth, TranYear, 
        VDescription, BDescription, TDescription, 
        ObjectID, AccountID
'

IF NOT EXISTS(SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV7112' AND SYSOBJECTS.XTYPE = 'V')
    EXEC('--created BY AP7111
        CREATE VIEW AV7112 AS ' + @strSQL)
ELSE
    EXEC('--created BY AP7111
        ALTER VIEW AV7112 AS ' + @strSQL)

---- Chi hien thi So du
SET @strSQL = '
    SELECT V10.LinkAccountID, T01.AccountName, V10.DivisionID, V10.ObjectID, 
        SUM(CASE 
                WHEN V10.TranYear * 100 + TranMonth < ''' + STR(@TranYearFrom * 100 + @TranMonthFrom) + ''' 
                        OR V10.TransactionTypeID = ''' + 'T00' + ''' 
                    THEN SignAmount 
                ELSE 
            0 END) AS OpeningAmount, 
        SUM(SignAmount) AS ClosingAmount, 
        SUM(CASE 
                WHEN(V10.TranYear * 100 + V10.TranMonth) < = ''' + STR(@TranYearTo * 100 + @TranMonthTo) + ''' 
                        AND (V10.TranYear > = ''' + STR(@TranYearFrom) + ''') 
                        AND V10.D_C = ''' + 'D' + ''' 
                        AND V10.TransactionTypeID <> ''' + 'T00' + '''
                    THEN ConvertedAmount 
                ELSE 0 
            END) AS AccumulatedDebit, 
        SUM(CASE 
                WHEN(V10.TranYear * 100 + V10.TranMonth) < = ''' + STR(@TranYearTo * 100 + @TranMonthTo) + ''' 
                        AND(V10.TranYear > = ''' + STR(@TranYearFrom) + ''') 
                        AND V10.D_C = ''' + 'C' + ''' 
                        AND V10.TransactionTypeID <> ''' + 'T00' + '''
                    THEN ConvertedAmount 
                ELSE 0 
            END) AS AccumulatedCredit
    FROM AV7112 AS V10 LEFT JOIN AT1005 AS T01 ON T01.AccountID = V10.LinkAccountID AND T01.DivisionID = V10.DivisionID'
/* 
IF @Level1 <> 0 
SET @strSQL = @strSQL + ' WHERE len(V10.LinkAccountID) = ''' + STR(@Level1 + 2) + ''''
*/
SET @strSQL = @strSQL + ' GROUP BY V10.LinkAccountID, T01.AccountName, V10.DivisionID, V10.ObjectID '

IF NOT EXISTS(SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV7113' AND SYSOBJECTS.XTYPE = 'V')
    EXEC('--created BY AP7111
        CREATE VIEW AV7113 AS ' + @strSQL)
ELSE
    EXEC('--created BY AP7111 
        ALTER VIEW AV7113 AS ' + @strSQL)

----- Tra ra VIEW so lieu phat sinh
SET @strSQL = '
    SELECT * FROM AV7112 AS V10
    WHERE TranYear * 100 + TranMonth > = ''' + STR(@TranYearFrom * 100 + @TranMonthFrom) + '''
        AND(TransactionTypeID IS NULL OR TransactionTypeID <> ''' + 'T00' + ''')'
/* 
IF @Level1 <> 0 
SET @strSQL = @strSQL + 'AND len(V10.LinkAccountID) = ''' + STR(@Level1 + 2) + ''''
*/

IF NOT EXISTS(SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV7114' AND SYSOBJECTS.XTYPE = 'V')
    EXEC('--created BY AP7111
        CREATE VIEW AV7114 AS ' + @strSQL)
ELSE
    EXEC('--created BY AP7111
        ALTER VIEW AV7114 AS ' + @strSQL)

SET @strSQL = '
    SELECT DISTINCT ISNULL(V14.DivisionID, V13.DivisionID) AS DivisionID, 
        V14.VoucherID, V14.BatchID, 
        V14.TransactionID, V14.Orders, 
        ISNULL(V14.TransactionTypeID, ''T00'') AS TransactionTypeID, 
        ISNULL(V14.LinkAccountID, V13.LinkAccountID) AS AccountID, 
        V14.CorAccountID AS CorAccountID, 
        V14.D_C AS D_C, V14.VoucherTypeID, 
        V14.VoucherNo, V14.InvoiceDate, V14.VoucherDate, 
        V14.InvoiceNo, V14.Serial, V14.CreateDate, 
        ISNULL(V14.ConvertedAmount, 0) AS ConvertedAmount, 
        ISNULL(V14.OriginalAmount, 0) AS OriginalAmount, 
        ISNULL(V14.SignAmount, 0) AS SignAmount, 
        ISNULL(V14.OSignAmount, 0) AS OSignAmount, 
        V14.TranMonth, V14.TranYear, V14.Description, 
        ISNULL(V14.ObjectID, V13.ObjectID) AS ObjectID, V13.OpeningAmount, 
        ISNULL(V13.ClosingAmount, 0) AS ClosingAmount, 
        ISNULL(V13.AccountName, '''') AS AccountName, 
        V13.LinkAccountID AS ReportAccountID
    FROM AV7113 AS V13 LEFT JOIN AV7114 AS V14 ON V14.LinkAccountID = V13.LinkAccountID 
            AND V13.DivisionID = V14.DivisionID
            AND V13.ObjectID = V14.ObjectID'

IF NOT EXISTS(SELECT TOP 1 1 FROM SysObjects WHERE Name = 'AT7111' AND Xtype = 'U')
    CREATE TABLE [dbo].[AT7111](
    [DivisionID] [NVARCHAR](50) NULL, 
    [VoucherID] [NVARCHAR](50) NULL, 
    [BatchID] [NVARCHAR](50) NULL, 
    [TransactionID] [NVARCHAR](50) NULL, 

    [Orders] [NVARCHAR](350) NULL, 
    [TransactionTypeID] [NVARCHAR](50) NULL, 
    [AccountID] [NVARCHAR](50) NULL, 
    [CorAccountID] [NVARCHAR](50) NULL, 
    [D_C] [NVARCHAR](50) NULL, 
    [VoucherTypeID] [NVARCHAR](50) NULL, 
    [VoucherNo] [NVARCHAR](50) NULL, 
    [InvoiceDate] [DATETIME] NULL, 
    [VoucherDate] [DATETIME] NULL, 
    [InvoiceNo] [NVARCHAR](50) NULL, 
    [Serial] [NVARCHAR](50) NULL, 
    [CreateDate] [DATETIME] NULL, 
    [ConvertedAmount] [DECIMAL](28, 8) NULL, 
    [OriginalAmount] [DECIMAL](28, 8) NULL, 
    [SignAmount] [DECIMAL](28, 8) NULL, 
    [OSignAmount] [DECIMAL](28, 8) NULL, 
    [TranMonth] [INT] NULL, 
    [TranYear] [INT] NULL, 
    [Description] [NVARCHAR](250) NULL, 
    [ObjectID] [NVARCHAR](50) NULL, 
    [OpeningAmount] [DECIMAL](28, 8) NULL, 
    [ClosingAmount] [DECIMAL](28, 8) NULL, 
    [AccountName] [NVARCHAR](150) NULL, 
    [ReportAccountID] [NVARCHAR](20) NULL
    ) ON [PRIMARY]
ELSE
    DELETE AT7111

EXEC('INSERT INTO AT7111(DivisionID, VoucherID, BatchID, TransactionID, Orders, TransactionTypeID, AccountID, CorAccountID, D_C, VoucherTypeID, VoucherNo, InvoiceDate, VoucherDate, InvoiceNo, Serial, CreateDate, ConvertedAmount, OriginalAmount, SignAmount, OSignAmount, TranMonth, TranYear, Description, ObjectID, OpeningAmount, ClosingAmount, AccountName, ReportAccountID)' + @strSQL)

SET @AT7111_Cursor = CURSOR SCROLL KEYSET FOR
    SELECT DivisionID, ObjectID, VoucherID, VoucherDate, TransactionID, Orders, AccountID, ISNULL(OpeningAmount, 0), SignAmount
    FROM AT7111

OPEN @AT7111_Cursor
FETCH NEXT FROM @AT7111_Cursor INTO @DivisionID1, @ObjectID, @VoucherID, @VoucherDate, @TransactionID, @Orders, @AccountID, @OpeningAmount, @SignAmount

WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @AccummulatedAmount =(
            SELECT SUM(ISNULL(SignAmount, 0)) 
            FROM AT7111
            WHERE Orders < = @Orders 
                AND DivisionID = @DivisionID1 
                AND ObjectID = @ObjectID 
                AND AccountID = @AccountID)
            
        SET @ClosingAmount = @OpeningAmount + @AccummulatedAmount
        
        UPDATE AT7111 SET ClosingAmount = @ClosingAmount
        WHERE DivisionID = @DivisionID1 
            AND VoucherID = @VoucherID 
            AND VoucherDate = @VoucherDate 
            AND TransactionID = @TransactionID 
            AND ObjectID = @ObjectID 
            AND Orders = @Orders
            
        FETCH NEXT FROM @AT7111_Cursor INTO @DivisionID1, @ObjectID, @VoucherID, @VoucherDate, @TransactionID, @Orders, @AccountID, @OpeningAmount, @SignAmount
    END

CLOSE @AT7111_Cursor
DEALLOCATE @AT7111_Cursor
GO
