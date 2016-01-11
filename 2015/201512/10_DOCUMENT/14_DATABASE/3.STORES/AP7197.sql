/****** Object:  StoredProcedure [dbo].[AP7197]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created BY Van Nhan, Date 20/12/2007
---- In bao cao tong hop tai khoan ngoai bang theo ky
-- Last Edit Thuy Tuyen, date :10/06/2008; 22/06/2008
-- Noi dung sua(22/10/2010): Do DivisionID nam o nhieu table khac nhau, ma trong cau Sql thi khong chi ra
-- cua table nao, nen xay ra loi Ambitious column. Da sua DivisionID -> AT9004.DivisionID 

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'* Edited by: [GS] [Anh Tuan] [22/10/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7197] 
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
        SUM(CASE WHEN D_C = ''D'' THEN ConvertedAmount ELSE -ConvertedAmount END) AS BeginConvertedAmount, 
        ''Z00'' AS TransactionTypeID
    FROM AT9004 LEFT JOIN AT1302 ON AT1302.InventoryID = AT9004.InventoryID AND AT1302.DivisionID = AT9004.DivisionID
        INNER JOIN AT1005 ON AT1005.AccountID = AT9004.AccountID AND AT1005.DivisionID = AT9004.DivisionID
    WHERE(TranMonth + TranYear * 100<' + STR(@FromMonth) + ' + ' + STR(@FromYear) + ' * 100 OR AT9004.TransactionTypeID = ''Z00'') 
        AND AT9004.DivisionID = ''' + @DivisionID + ''' 
        AND AT9004.AccountID BETWEEN ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''' 
        AND ISNULL(AT9004.InventoryID, '''') BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 
    GROUP BY AT9004.AccountID, AT9004.InventoryID, InventoryName, AT1005.AccountName, AT9004.DivisionID
'

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE Name = 'AV7191' AND Xtype = 'V')
    EXEC(' CREATE VIEW AV7191 AS ' + @sSQL)
ELSE
    EXEC(' ALTER VIEW AV7191 AS ' + @sSQL)

------- Phat sinh trong ky
SET @sSQL = '
    SELECT AT9004.AccountID AS AccountID, 
        AT1005.AccountName AS AccountName, 
        AT9004.InventoryID AS InventoryID, 
        AT1302.InventoryName AS InventoryName, 
        TransactionTypeID, AT9004.DivisionID, 
        Quantity, OriginalAmount, 
        ConvertedAmount, D_C
    FROM AT9004 LEFT JOIN AT1302 ON AT1302.InventoryID = AT9004.InventoryID AND AT1302.DivisionID = AT9004.DivisionID
        INNER JOIN AT1005 ON AT1005.AccountID = AT9004.AccountID AND AT1005.DivisionID = AT9004.DivisionID
    WHERE Tranmonth + TranYear * 100 BETWEEN(' + STR(@FromMonth) + ' + ' + STR(@FromYear) + ' * 100) AND(' + STR(@ToMonth) + ' + ' + STR(@ToYear) + ' * 100) 
        AND AT9004.DivisionID = ''' + @DivisionID + ''' 
        AND AT9004.AccountID BETWEEN ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''' 
        AND AT9004.TransactionTypeID <> ''Z00'' --- Khong phai la but toan so du -----
        AND ISNULL(AT9004.InventoryID, '''') BETWEEN ''' + @FromInventoryID + ''' AND ''' + @toInventoryID + '''
'

IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE Name = 'AV7194' AND Xtype = 'V')
    EXEC(' CREATE VIEW AV7194 AS ' + @sSQL)
ELSE
    EXEC(' ALTER VIEW AV7194 AS ' + @sSQL)

---print @sSQL
---- Phat sinh + so du dau ky 
---IF EXISTS(SELECT TOP 1 1 FROM AT9004 WHERE TranMonth + TranYear * 100 BETWEEN(STR(@FromMonth) + STR(@FromYear) * 100) AND(STR(@ToMonth) + STR(@ToYear) * 100) AND TransactionTypeID <> 'Z00')
SET @sSQL = '
    SELECT ''' + @DivisionID + ''' DivisionID,
    	ISNULL(AT9004.AccountID, AV7191.AccountID) AS AccountID, 
        ISNULL(AT1005.AccountName, AV7191.AccountName)AS AccountName, 
        ISNULL(AT9004.InventoryID, AV7191.InventoryID) AS InventoryID, 
        ISNULL(AV7191.InventoryName, AT1302.InventoryName) AS InventoryName, 
        AV7191.BeginQuantity, 
        AV7191.BeginOriginalAmount, 
        AV7191.BeginConvertedAmount, 
        SUM(CASE WHEN D_C = ''D'' AND AT9004.TransactionTypeID <> ''Z00'' THEN Quantity ELSE 0 END) AS DebitQuantity, 
        SUM(CASE WHEN D_C = ''D'' AND AT9004.TransactionTypeID <> ''Z00'' THEN OriginalAmount ELSE 0 END) AS DebitOriginalAmount, 
        SUM(CASE WHEN D_C = ''D'' AND AT9004.TransactionTypeID <> ''Z00'' THEN ConvertedAmount ELSE 0 END) AS DebitConvertedAmount, 
        SUM(CASE WHEN D_C = ''C'' AND AT9004.TransactionTypeID <> ''Z00'' THEN Quantity ELSE 0 END) AS CreditQuantity, 
        SUM(CASE WHEN D_C = ''C'' AND AT9004.TransactionTypeID <> ''Z00'' THEN OriginalAmount ELSE 0 END) AS CreditOriginalAmount, 
        SUM(CASE WHEN D_C = ''C'' AND AT9004.TransactionTypeID <> ''Z00'' THEN ConvertedAmount ELSE 0 END) AS CreditConvertedAmount
    FROM AV7194 AT9004 LEFT JOIN AT1302 ON AT1302.InventoryID = AT9004.InventoryID AND AT1302.DivisionID = AT9004.DivisionID
        INNER JOIN AT1005 ON AT1005.AccountID = AT9004.AccountID AND AT1005.DivisionID = AT9004.DivisionID
        FULL JOIN AV7191 ON AV7191.AccountID = AT9004.AccountID AND AV7191.DivisionID = AT9004.DivisionID
            AND AV7191.InventoryID = ISNULL(AT9004.InventoryID, '''') 
            AND AT9004.TransactionTypeID <> ''Z00'' ------ AND AT9004.TransactionTypeID <> ''Z99''
    WHERE ISNULL(AT9004.DivisionID, AV7191.DivisionID) = ''' + @DivisionID + ''' 
        AND ISNULL(AT9004.AccountID, AV7191.AccountID)BETWEEN ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''' 
        AND ISNULL(AT9004.TransactionTypeID, '''') <> ''Z00'' --- Khong phai la but toan so du -----
        AND ISNULL(AV7191.InventoryID, '''') BETWEEN ''' + @FromInventoryID + ''' AND ''' + @toInventoryID + '''
    GROUP BY AT9004.AccountID, AT9004.InventoryID, AT1302.InventoryName, AV7191.AccountID, AV7191.InventoryID, AV7191.InventoryName, AV7191.BeginQuantity, AV7191.BeginOriginalAmount, AV7191.BeginConvertedAmount, AT1005.AccountName, AV7191.AccountName 
'

/* 
ELSE -- Truong hop chua phat sinh nghiep vu van len duoc so du, Tuyen bo sung 10062008 


SET @sSQL = '
SELECT
AccountID, AccountName, InventoryID, InventoryName, BeginQuantity, 
BeginAmount, null AS DebitQuantity, null AS DebitAmount, null AS CreditQuantity, null AS CreditAmount

FROM AV7191
WHERE AccountID not in(SELECT AccountID FROM AT9004 WHERE TranMonth + TranYear * 100 BETWEEN(' + STR(@FromMonth) + ' + ' + STR(@FromYear) + ' * 100) AND(' + STR(@ToMonth) + ' + ' + STR(@ToYear) + ' * 100) AND TransactionTypeID <> ''Z00'')
'


*/
---print @sSQL
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE Name = 'AV7198' AND Xtype = 'V')
    EXEC(' CREATE VIEW AV7198 AS ' + @sSQL)
ELSE
    EXEC(' ALTER VIEW AV7198 AS ' + @sSQL)
GO
