IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7194]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7194]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created BY Van Nhan, Date 20/12/2007
---- In bao cao chi tiet khoan ngoai bang, truong hop theo ky
----Last Edit: Thuy Tuyen, date : 10/06/02008, 24/06/2008
----Last Edit: Nguyen Quoc Huy, Date :11/09/2008
-- Noi dung sua(22/10/2010): Do DivisionID nam o nhieu table khac nhau, ma trong cau Sql thi khong chi ra
-- cua table nao, nen xay ra loi Ambitious column. Da sua DivisionID -> AT9004.DivisionID 
/********************************************
'* Edited by: [GS] [Anh Tuan] [22/10/2010]
'********************************************/
CREATE PROCEDURE [dbo].[AP7194] 
    @DivisionID NVARCHAR(50), 
    @FromAccountID AS NVARCHAR(50), 
    @ToAccountID AS NVARCHAR(50), 
    @FromInventoryID AS NVARCHAR(50), 
    @ToInventoryID AS NVARCHAR(50), 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT
AS

DECLARE @sSQL AS NVARCHAR(4000)

IF @FromInventoryID = '[]' SET @FromInventoryID = ''
IF @ToInventoryID = '[]' SET @ToInventoryID = ''

SET @sSQL = '
    SELECT AT9004.AccountID, 
        AT1005.AccountName, 
        ISNULL(AT9004.InventoryID, '''') AS InventoryID, 
        InventoryName, 
        AT9004.DivisionID, 
        SUM(CASE WHEN D_C = ''D'' THEN Quantity ELSE - Quantity END) AS BeginQuantity, 
        SUM(CASE WHEN D_C = ''D'' THEN OriginalAmount ELSE -OriginalAmount END) AS BeginOriginalAmount, 
        SUM(CASE WHEN D_C = ''D'' THEN ConvertedAmount ELSE -ConvertedAmount END) AS BeginConvertedAmount
    FROM AT9004 LEFT JOIN AT1302 ON AT1302.InventoryID = AT9004.InventoryID AND AT1302.DivisionID = AT9004.DivisionID
        INNER JOIN AT1005 ON AT1005.AccountID = AT9004.AccountID AND AT1005.DivisionID = AT9004.DivisionID
    WHERE (TranMonth + TranYear * 100<' + STR(@FromMonth) + ' + ' + STR(@FromYear) + ' * 100 OR AT9004.TransactionTypeID = ''Z00'') 
        AND AT9004.DivisionID = ''' + @DivisionID + ''' 
        AND AT9004.AccountID BETWEEN ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''' 
        AND ISNULL(AT9004.InventoryID, '''') BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 
    GROUP BY AT9004.AccountID, AT9004.InventoryID, InventoryName, AT1005.AccountName, AT9004.DivisionID
'

--print @sSQL

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE Name = 'AV7192' AND Xtype = 'V')
    EXEC(' CREATE VIEW AV7192 AS ' + @sSQL)
ELSE
    EXEC(' ALTER VIEW AV7192 AS ' + @sSQL)

----Phat sinh trong ky 
SET @sSQL = '
    SELECT AT9004.AccountID AS AccountID, 
        AT1005.AccountName AS AccountName, 
        AT9004.InventoryID AS InventoryID, 
        AT1302.InventoryName AS InventoryName, 
        AT9004.VoucherDate, 
        AT9004.VoucherNo, 
        AT9004.OriginalAmount, 
        AT9004.ConvertedAmount, 
        AT9004.Quantity, 
        AT9004.UnitPrice, 
        AT9004.VDescription, 
        AT9004.TDescription, 
        TransactionTypeID, 
        D_C, 
        AT9004.DivisionID
    FROM AT9004 LEFT JOIN AT1302 ON AT1302.InventoryID = AT9004.InventoryID AND AT1302.DivisionID = AT9004.DivisionID
        INNER JOIN AT1005 ON AT1005.AccountID = AT9004.AccountID AND AT1005.DivisionID = AT9004.DivisionID
    WHERE(TranMonth + TranYear * 100 BETWEEN(' + STR(@FromMonth) + ' + ' + STR(@FromYear) + ' * 100) AND(' + STR(@ToMonth) + ' + ' + STR(@ToYear) + ' * 100)) 
        AND AT9004.DivisionID = ''' + @DivisionID + ''' 
        AND AT9004.AccountID BETWEEN ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''' 
        AND AT9004.TransactionTypeID <> ''Z00'' --- Khong phai la but toan so du
        AND ISNULL(AT9004.InventoryID, '''') BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 
'

--print @sSQL

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE Name = 'AV7193' AND Xtype = 'V')
    EXEC(' CREATE VIEW AV7193 AS ' + @sSQL)---- Tao boi AP7194
ELSE
    EXEC(' ALTER VIEW AV7193 AS ' + @sSQL) -------- Tao boi AP7194
-- Phat sinh + so du dau ky



SET @sSQL = '
    SELECT 
		ISNULL(AV7192.DivisionID, AT9004.DivisionID) As DivisionID,
    	ISNULL(AV7192.AccountID, AT9004.AccountID) AS AccountID, 
        ISNULL(AT1005.AccountName, AV7192.AccountName)AS AccountName, 
        ISNULL(AV7192.InventoryID, AT9004.InventoryID) AS InventoryID, 
        ISNULL(AV7192.InventoryName, AT1302.InventoryName) AS InventoryName, 
        AT9004.VoucherDate, 
        AT9004.VoucherNo, 
        ISNULL(AV7192.BeginQuantity, 0) AS BeginQuantity, 
        ISNULL(AV7192.BeginOriginalAmount, 0) AS BeginOriginalAmount, 
        ISNULL(AV7192.BeginConvertedAmount, 0) AS BeginConvertedAmount, 
        (CASE WHEN D_C = ''D'' AND AT9004.TransactionTypeID <> ''Z00'' THEN At9004.OriginalAmount ELSE 0 END) AS DebitOriginalAmount, 
        (CASE WHEN D_C = ''D'' AND AT9004.TransactionTypeID <> ''Z00'' THEN At9004.ConvertedAmount ELSE 0 END) AS DebitConvertedAmount, 
        (CASE WHEN D_C = ''C'' AND AT9004.TransactionTypeID <> ''Z00'' THEN At9004.OriginalAmount ELSE 0 END) AS CreditOriginalAmount, 
        (CASE WHEN D_C = ''C'' AND AT9004.TransactionTypeID <> ''Z00'' THEN At9004.ConvertedAmount ELSE 0 END) AS CreditConvertedAmount, 
        AT9004.Quantity, 
        At9004.UnitPrice, 
        At9004.VDescription, 
        At9004.TDescription
    FROM AV7193 AT9004 LEFT JOIN AT1302 ON AT1302.InventoryID = AT9004.InventoryID AND AT1302.DivisionID = AT9004.DivisionID
        INNER JOIN AT1005 ON AT1005.AccountID = AT9004.AccountID AND AT1005.DivisionID = AT9004.DivisionID
        FULL JOIN AV7192 ON AV7192.AccountID = AT9004.AccountID AND AV7192.DivisionID = AT9004.DivisionID
            AND AV7192.InventoryID = ISNULL(AT9004.InventoryID, '''') 
            AND AT9004.TransactionTypeID <> ''Z00''
    WHERE -------(TranMonth + TranYear * 100 BETWEEN(' + STR(@FromMonth) + ' + ' + STR(@FromYear) + ' * 100) AND(' + STR(@ToMonth) + ' + ' + STR(@ToYear) + ' * 100)) AND
        ISNULL(AT9004.DivisionID, AV7192.DivisionID) = ''' + @DivisionID + ''' 
        AND ISNULL(AT9004.AccountID, AV7192.AccountID) BETWEEN ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''' 
        AND ISNULL(AT9004.TransactionTypeID, '''') <> ''Z00'' --- Khong phai la but toan so du
        AND ISNULL(AT9004.InventoryID, '''') BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 
'

--print @sSQL

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE Name = 'AV7195' AND Xtype = 'V')
    EXEC('---- Tao boi AP7194
        CREATE VIEW AV7195 AS ' + @sSQL) 
ELSE
    EXEC('---- Tao boi AP7194
        ALTER VIEW AV7195 AS ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

