IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7401]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7401]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---------- Xu ly tong hop No phai tr¶
----------- Created BY Nguyen Van Nhan, Date 22.08.2003
---- Modified on 28/12/2012 by Lê Thị Thu Hiền : Bổ sung thêm strDivisionID
/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP7401] 
    @DivisionID AS NVARCHAR(50), 
    @CurrencyID AS NVARCHAR(50), 
    @FromAccountID AS NVARCHAR(50), 
    @ToAccountID AS NVARCHAR(50), 
    @FromObjectID AS NVARCHAR(50), 
    @ToObjectID AS NVARCHAR(50),
    @StrDivisionID AS NVARCHAR(4000) = ''
AS

DECLARE @sql AS NVARCHAR(4000),
		@StrDivisionID_New AS NVARCHAR(4000)


SET @StrDivisionID_New = ''		

IF ISNULL(@StrDivisionID,'') <> ''
	SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
	@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END
ELSE
	SELECT @StrDivisionID_New = CASE WHEN @DivisionID = '%' THEN ' LIKE ''' + 
	@DivisionID + '''' ELSE ' IN (''' + replace(@DivisionID, ',',''',''')+ ''')' END
	
	
-------------------- Phat sinh No.
SET @sql = '
    SELECT TransactionID, 
        BatchID, VoucherID, TableID, D3.DivisionID, TranMonth, TranYear, 
        ''00'' AS RPTransactionType, 
        TransactionTypeID, 
        ObjectID, 
        DebitAccountID, CreditAccountID, 
        DebitAccountID AS AccountID, 
        VoucherNo, VoucherTypeID, VoucherDate, 
        InvoiceNo, InvoiceDate, Serial, 
        VDescription, BDescription, TDescription, 
        CurrencyIDCN AS CurrencyID, ExchangeRate, OriginalAmountCN AS OriginalAmount, ConvertedAmount, 
        OriginalAmountCN AS SignOriginalAmount, ConvertedAmount AS SignConvertedAmount, 
        Status
    FROM AT9000 D3 
    INNER JOIN AT1005 ON AT1005.AccountID = D3.DebitAccountID and AT1005.DivisionID = D3.DivisionID
    WHERE AT1005.GroupID = ''G04'' 
        AND D3.DivisionID ' + @StrDivisionID_New + '
        AND (D3.ObjectID BETWEEN ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''') 
        AND D3.CurrencyIDCN LIKE ''' + @CurrencyID + '''
'

IF @FromAccountID <> '%' 
    SET @SQL = @SQL + ' AND D3.DebitAccountID > = ''' + @FromAccountID + ''' AND D3.DebitAccountID< = ''' + @ToAccountID + ''' '
ELSE
    SET @SQL = @SQL + ' AND D3.DebitAccountID LIKE ''%'' '

------------------------------- Phat sinh Co
SET @sql = @sql + '
    UNION ALL 
    SELECT TransactionID, BatchID, VoucherID, TableID, D3.DivisionID, TranMonth, TranYear, 
        ''01'' AS RPTransactionType, TransactionTypeID, 
        CASE WHEN TransactionTypeID = ''T99'' THEN CreditObjectID ELSE ObjectID END AS ObjectID, 
        DebitAccountID, CreditAccountID, 
        CreditAccountID AS AccountID, 
        VoucherNo, VoucherTypeID, VoucherDate, 
        InvoiceNo, InvoiceDate, Serial, 
        VDescription, BDescription, TDescription, 
        CurrencyIDCN AS CurrencyID, ExchangeRate, OriginalAmountCN AS OriginalAmount, ConvertedAmount, 
        OriginalAmountCN *(-1) AS SignOriginalAmount, ConvertedAmount *(-1) AS SignConvertedAmount, 
        Status 
    FROM AT9000 D3 INNER JOIN AT1005 ON AT1005.AccountID = D3.CreditAccountID and AT1005.DivisionID = D3.DivisionID
    WHERE AT1005.GroupID = ''G04'' 
        AND D3.DivisionID ' + @StrDivisionID_New + '
        AND (CASE 
                WHEN TransactionTypeID = ''T99'' 
                    THEN D3.CreditObjectID 
                ELSE D3.ObjectID 
            END BETWEEN ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''') 
        AND D3.CurrencyIDCN LIKE ''' + @CurrencyID + '''
'

IF @FromAccountID <> '%' 
    SET @SQL = @SQL + ' AND D3.CreditAccountID > = ''' + @FromAccountID + ''' AND D3.CreditAccountID< = ''' + @ToAccountID + ''' '
ELSE
    SET @SQL = @SQL + ' AND ISNULL(D3.CreditAccountID, '''') LIKE ''%'' '


IF NOT EXISTS(SELECT name FROM sysobjects WHERE id = Object_id(N'[dbo].[AV7401]') AND OBJECTPROPERTY(id, N'IsView') = 1)
    EXEC(' CREATE VIEW AV7401 AS ' + @SQL)
ELSE
    EXEC(' ALTER VIEW AV7401 AS ' + @SQL)

--Print @SQL

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

