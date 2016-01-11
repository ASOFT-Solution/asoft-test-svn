/****** Object:  StoredProcedure [dbo].[WP2026]    Script Date: 08/03/2010 15:02:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

 --- Creater :Nguyen Quoc Huy
 --- Creadate:20/07/2009
 -- Puppose :Lay du lieu don hang  do ra combo cho man hinh nhap kho   !

/********************************************
* Edited by: [GS] [Việt Khánh] [04/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[WP2026]      
    @DivisionID NVARCHAR(50), 
    @isDate TINYINT, 
    @FromDate DATETIME, 
    @ToDate DATETIME, 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @OrderIDList NVARCHAR(200), 
    @VoucherID NVARCHAR(50), 
    @ObjectID NVARCHAR(50), 
    @ConnID NVARCHAR(100) = ''
AS

DECLARE
    @sSQL NVARCHAR(4000), 
    @sTimeWhere NVARCHAR(4000), 
    @sTimeWhereWT9006 NVARCHAR(4000), 
    @sOrderIDList NVARCHAR(4000)

 ----- Buoc  1 : Tra ra thong tin Master View WV2027
IF @isDate = 0 -- Theo thang
          BEGIN
    SET @sTimeWhere = '(OT3001.TranMonth + OT3001.TranYear*100 BETWEEN (' + STR(@FromMonth) + ' + ' + STR(@FromYear) + '*100) AND (' + STR(@ToMonth) + ' + ' + STR(@ToYear) + '*100)) '
    SET @sTimeWhereWT9006 = '(WT9006.TranMonth + WT9006.TranYear*100 BETWEEN (' + STR(@FromMonth) + ' + ' + STR(@FromYear) + '*100) AND (' + STR(@ToMonth) + ' + ' + STR(@ToYear) + '*100)) '
        END
ELSE
       BEGIN
    SET @sTimeWhere = '(OT3001.OrderDate BETWEEN ''' + CONVERT(NVARCHAR(10), @FromDate, 21) + ''' AND ''' + CONVERT(NVARCHAR(10), @ToDate, 21) + ''' ) '
    SET @sTimeWhereWT9006 = '(WT9006.VoucherDate BETWEEN ''' + CONVERT(NVARCHAR(10), @FromDate, 21) + ''' AND ''' + CONVERT(NVARCHAR(10), @ToDate, 21) + ''' ) '
       END

IF ISNULL(@OrderIDList, '') = ''
    BEGIN
        SET @sOrderIDList = ''
        SET @OrderIDList = ''''''
    END
ELSE
    SET @sOrderIDList = '  AND ReSPVoucherID NOT IN (' + @OrderIDList + ') '



SET @sSQL = '
SELECT distinct  
	OT3001.DivisionID,
    OT3001.POrderID, 
    OT3001.VoucherTypeID, 
    OT3001.VoucherNo, 
    OT3001.OrderDate, 
    OT3001.OrderType, 
    OT3001.ObjectID, 
    AT1202.ObjectName, 
    OT3001.ContractNo, 
    OT3001.ShipDate, 
    AT1202.Address, 
    OT3001.Notes, OT3001.Description, 
    OT3001.OrderStatus, 
    OT3001.EmployeeID, 
    AT1103.FullName, 
    CASE WHEN OT3001.POrderID IN (' + @OrderIDList + ') THEN
            1  
 ELSE
            0
    END AS IsCheck
    
    
FROM OT3001 INNER JOIN OT3002 ON OT3002.POrderID = OT3001.POrderID
        LEFT JOIN AT1202 ON AT1202.ObjectID = OT3001.ObjectID
        LEFT JOIN AT1103 ON AT1103.EmployeeID = OT3001.EmployeeID AND AT1103.DivisionID = OT3001.DivisionID

WHERE (OT3001.DivisionID = ''' + @DivisionID + ''' AND
    OT3001.ObjectID LIKE ''' + @ObjectID + ''' AND 
 ----- OT3001.OrderStatus NOT IN (0, 9) AND 
    OT3001.Disabled = 0  AND OT3002.Finish = 0 AND 

    (OT3002.OrderQuantity - (SELECT ISNULL(SUM(ISNULL(ActualQuantity, 0)), 0) FROM AT2007 WHERE AT2007.InventoryID = OT3002.InventoryID AND AT2007.ReSPTransactionID = OT3002.TransactionID ))>0 
    
    AND ' + @sTimeWhere + ')

    OR OT3001.POrderID IN (' + @OrderIDList + ') 
 ' 
    

 -- print @sSQL

IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'WV2027' + @ConnID)
    EXEC('CREATE VIEW  WV2027' + @ConnID + ' AS ' + @sSQL)
ELSE
    EXEC('ALTER VIEW WV2027' + @ConnID + ' AS ' + @sSQL)


 ----- Buoc  2 : Tra ra thong tin Detail View WV2026

SET @sSQL = '
SELECT 
	OT3001.DivisionID,
    OT3001.POrderID, 
    OT3001.VoucherTypeID, 
    OT3001.VoucherNo, 

    OT3001.ObjectID, OT3001.CurrencyID, 
    OT3002.InventoryID, 
    
    CASE WHEN ISNULL(OT3002.InventoryCommonName, '''') = '''' THEN AT1302.InventoryName ELSE OT3002.InventoryCommonName END AS InventoryName, 
    CASE WHEN ISNULL(OT3002.InventoryCommonName, '''') = '''' THEN 0 ELSE 1 END AS isInventoryCommonName, 

    AT1302.UnitID, 
        
    (OT3002.OrderQuantity - (SELECT ISNULL(SUM(ISNULL(ActualQuantity, 0)), 0) FROM AT2007 WHERE AT2007.InventoryID = OT3002.InventoryID AND AT2007.ReSPTransactionID = OT3002.TransactionID )) AS Quantity, 

    ISNULL(AT1309.ConversionFactor, 1) AS ConversionFactor, 
    OT3002.PurchasePrice AS UnitPrice, 
    CASE WHEN OV2902.EndQuantity = OV2902.OrderQuantity THEN ISNULL(OT3002.OriginalAmount, 0) - ISNULL(OT3002.DiscountOriginalAmount, 0) 
 ELSE OV2902.EndQuantity*OT3002.PurchasePrice*(100 - OT3002.DiscountPercent)/100 END AS OriginalAmount, 
    CASE WHEN OV2902.EndQuantity = OV2902.OrderQuantity THEN ISNULL(OT3002.ConvertedAmount, 0) - ISNULL(OT3002.DiscountConvertedAmount, 0)
 ELSE OV2902.EndQuantity*OT3002.PurchasePrice*OT3001.ExchangeRate*(100 - OT3002.DiscountPercent)/100 END AS ConvertedAmount, 

    AT1302.IsSource, AT1302.IsLocation, AT1302.IsLimitDate, AT1302.AccountID, AT1302.PurchaseAccountID, 
    AT1302.MethodID, AT1302.IsStocked, 
    OT3002.Ana01ID, OT3002.Ana02ID, 
    OT3002.Ana03ID, AT1011.AnaName AS AnaName03, 
    OT3002.Ana04ID, OT3002.Ana05ID, 
    OT3002.Orders, 
    OT3002.TransactionID AS ReSPTransactionID, OT3002.POrderID AS ReSPVoucherID, 
    CASE WHEN OT3002.TransactionID IN (SELECT ReSPTransactionID FROM AT2007 WHERE ReSPVoucherID IN (' + @OrderIDList + ') AND VoucherID = ''' + @VoucherID + ''' ) THEN

            1  
 ELSE
            0
    END AS IsCheck



FROM OT3002 INNER JOIN OT3001 ON OT3001.POrderID = OT3002.POrderID
        INNER JOIN AT1302 ON AT1302.InventoryID = OT3002.InventoryID
        INNER JOIN OV2902 ON OV2902.POrderID = OT3002.POrderID AND OV2902.TransactionID = OT3002.TransactionID 
        LEFT JOIN AT1304 ON AT1304.UnitID = OT3002.UnitID
        LEFT JOIN AT1309 ON AT1309.InventoryID = OT3002.InventoryID AND AT1309.UnitID = OT3002.UnitID
        LEFT JOIN AT1011 ON AT1011.AnaID = OT3002.Ana03ID AND AT1011.AnaTypeID = ''A03''

WHERE (OT3001.DivisionID = ''' + @DivisionID + ''' AND
    OT3001.ObjectID LIKE ''' + @ObjectID + ''' AND 
    (OT3002.OrderQuantity - (SELECT ISNULL(SUM(ISNULL(ActualQuantity, 0)), 0) FROM AT2007 WHERE AT2007.InventoryID = OT3002.InventoryID AND AT2007.ReSPTransactionID = OT3002.TransactionID ))>0 
    AND ' + @sTimeWhere + ') 
    OR OT3001.POrderID IN (' + @OrderIDList + ') 
' 
    
 -- Print @sSQL

IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'WV2026' + @ConnID )
    EXEC('CREATE VIEW WV2026' + @ConnID + ' AS ' + @sSQL)
ELSE
    EXEC('ALTER VIEW WV2026' + @ConnID + ' AS ' + @sSQL)