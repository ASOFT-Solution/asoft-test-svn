/****** Object:  StoredProcedure [dbo].[WP2027]    Script Date: 08/03/2010 15:02:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

 -- Creater : Nguyen Quoc Huy, Date 27/07/2009
 -- Puppose :Lay du lieu don hang  do ra combo cho man hinh xuat  kho   !

/********************************************
* Edited by: [GS] [Việt Khánh] [04/08/2010]
'********************************************/
ALTER PROCEDURE [dbo].[WP2027]     
    @DivisionID NVARCHAR(50), 
    @isDate TINYINT, 
    @FromDate DATETIME, 
    @ToDate DATETIME, 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @isSOrder TINYINT, -- 0: ke thua tu phieu giao van, 1: ke thua tu don hang ban.
    @OrderIDList NVARCHAR(200), 
    @VoucherID NVARCHAR(50), 
    @ObjectID NVARCHAR(50), 
    @ConnID NVARCHAR(100) = ''                
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @sTimeWhere NVARCHAR(500), 
    @sOrderIDList NVARCHAR(500)

 ----- Buoc  1 : Tra ra thong tin Master View AV2027
IF @isSOrder = 1 -- ke thua tu don hang ban
    BEGIN
        IF @isDate = 0 -- Theo thang
            SET @sTimeWhere = '(OT2001.TranMonth + OT2001.TranYear*100 BETWEEN (' + STR(@FromMonth) + ' + ' + STR(@FromYear) + '*100) AND (' + STR(@ToMonth) + ' + ' + STR(@ToYear) + '*100)) '
        ELSE
            SET @sTimeWhere = '(OT2001.OrderDate BETWEEN ''' + CONVERT(NVARCHAR(10), @FromDate, 21) + ''' AND ''' + CONVERT(NVARCHAR(10), @ToDate, 21) + ''' ) '
    
        IF ISNULL(@OrderIDList, '') = ''
            BEGIN
                SET @sOrderIDList = ''
                SET @OrderIDList = ''''''
            END
        ELSE
            SET @sOrderIDList = '  AND ReSPVoucherID NOT IN (' + @OrderIDList + ') '
    
        SET @sSQL = '
            SELECT DISTINCT  
                OT2001.DivisionID,
                OT2001.SOrderID, 
                OT2001.VoucherTypeID, 
                OT2001.VoucherNo, 
                OT2001.OrderDate, 
                OT2001.OrderType, 
                OT2001.ObjectID, 
                AT1202.ObjectName, 
                AT1202.Address, 
                OT2001.Notes, 
                OT2001.OrderStatus, 
                OT2001.EmployeeID, 
                AT1103.FullName, 
                CASE WHEN OT2001.SOrderID IN (' + @OrderIDList + ') THEN 1 ELSE 0 END AS IsCheck
            FROM OT2001 INNER JOIN OT2002 ON OT2002.SOrderID = OT2001.SOrderID
                LEFT JOIN AT1202 ON AT1202.ObjectID = OT2001.ObjectID
                LEFT JOIN AT1103 ON AT1103.EmployeeID = OT2001.EmployeeID 
                    AND AT1103.DivisionID = OT2001.DivisionID
            WHERE (OT2001.DivisionID = ''' + @DivisionID + ''' 
                AND OT2001.ObjectID LIKE ''' + @ObjectID + ''' 
                AND OT2001.OrderStatus NOT IN (0, 9) AND OT2001.Disabled = 0  
                AND OT2002.TransactionID NOT IN (SELECT ISNULL(ReSPTransactionID, '''') FROM AT2007 WHERE DivisionID = ''' + @DivisionID + '''    ' + @sOrderIDList + '  ) AND ' + @sTimeWhere + ')
        ' 
    END        
ELSE --- ke thua tu phieu giao van
    BEGIN
        IF @isDate = 0 -- Theo thang
            SET @sTimeWhere = '(OT2301.TranMonth + OT2301.TranYear*100 BETWEEN (' + STR(@FromMonth) + ' + ' + STR(@FromYear) + '*100) AND (' + STR(@ToMonth) + ' + ' + STR(@ToYear) + '*100)) '
        ELSE
            SET @sTimeWhere = '(OT2301.VoucherDate BETWEEN ''' + CONVERT(NVARCHAR(10), @FromDate, 21) + ''' AND ''' + CONVERT(NVARCHAR(10), @ToDate, 21) + ''' ) '
    
        IF ISNULL(@OrderIDList, '') = ''
            BEGIN
                SET @sOrderIDList = ''
                SET @OrderIDList = ''''''
            END
        ELSE
            SET @sOrderIDList = '  AND ReSPVoucherID NOT IN (' + @OrderIDList + ') '
    
        SET @sSQL = '
            SELECT DISTINCT  
                OT2301.DivisionID,
                OT2301.VoucherID AS SOrderID, 
                OT2301.VoucherTypeID, 
                OT2301.VoucherNo, 
                OT2301.VoucherDate  OrderDate, 
                0 AS OrderType, 
                OT2301.ObjectID, 
                AT1202.ObjectName, 
                AT1202.Address, 
                OT2301.Description AS Notes, 
                OT2301.Status OrderStatus, 
                OT2301.EmployeeID, 
                AT1103.FullName, 
                CASE WHEN OT2301.VoucherID IN (' + @OrderIDList + ') THEN 1 ELSE 0 END AS IsCheck
                FROM OT2301 INNER JOIN OT2302 ON OT2302.VoucherID = OT2301.VoucherID
                    LEFT JOIN AT1202 ON AT1202.ObjectID = OT2301.ObjectID
                    LEFT JOIN AT1103 ON AT1103.EmployeeID = OT2301.EmployeeID 
                        AND AT1103.DivisionID = OT2301.DivisionID
                WHERE (OT2301.DivisionID = ''' + @DivisionID + ''' 
                    AND OT2301.ObjectID LIKE ''' + @ObjectID + ''' 
                    AND OT2301.Status IN (1) 
                    AND OT2302.TransactionID NOT IN (SELECT ISNULL(ReSPTransactionID, '''') FROM AT2007 WHERE DivisionID = ''' + @DivisionID + '''    ' + @sOrderIDList + '  ) AND ' + @sTimeWhere + ')
'
    END

 -- print @sSQL


IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV2027' + @ConnID)
    EXEC('CREATE VIEW  AV2027' + @ConnID + ' AS ' + @sSQL)
ELSE
    EXEC('ALTER VIEW AV2027' + @ConnID + ' AS ' + @sSQL)


 ----- Buoc  2 : Tra ra thong tin Detail View WV2027
IF @isSOrder = 1 -- ke thua tu don hang ban
    BEGIN
        SET @sSQL = '
            SELECT 
				OT2001.DivisionID,
                OT2001.VoucherNo, OT2001.SOrderID, 
                OT2001.ObjectID, OT2001.CurrencyID, 
                OT2002.InventoryID, 
                CASE WHEN ISNULL(OT2002.InventoryCommonName, '''') = '''' THEN AT1302.InventoryName ELSE OT2002.InventoryCommonName END AS InventoryName, 
                CASE WHEN ISNULL(OT2002.InventoryCommonName, '''') = '''' THEN 0 ELSE 1 END AS IsInventoryCommonName, 
                AT1302.UnitID, 
                OV2901.EndQuantity AS Quantity, 
                1 AS ConversionFactor, 
                OT2002.SalePrice AS UnitPrice, 
                CASE WHEN OV2901.EndQuantity = OV2901.OrderQuantity THEN ISNULL(OT2002.OriginalAmount, 0) - ISNULL(OT2002.DiscountOriginalAmount, 0) 
                    ELSE OV2901.EndQuantity*OT2002.SalePrice*(100 - OT2002.DiscountPercent)/100    END AS OriginalAmount, 
                CASE WHEN OV2901.EndQuantity = OV2901.OrderQuantity THEN  ISNULL(OT2002.ConvertedAmount, 0) - ISNULL(OT2002.DiscountConvertedAmount, 0) 
                    ELSE OV2901.EndQuantity*OT2002.SalePrice*ExchangeRate*(100 - OT2002.DiscountPercent)/100    END AS ConvertedAmount, 
                OT2002.DiscountPercent, OT2002.DiscountConvertedAmount, 
                AT1302.IsSource, AT1302.IsLocation, AT1302.SalesAccountID, AT1302.IsLimitDate, 
                AT1302.AccountID, AT1302.PrimeCostAccountID, AT1302.MethodID, AT1302.IsStocked, 
                OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID, OT2002.Orders, 
                OT2002.TransactionID AS ReSPTransactionID, OT2002.SOrderID AS ReSPVoucherID, 
                CASE WHEN OT2002.TransactionID IN (SELECT ReSPTransactionID FROM AT2007 WHERE ReSPVoucherID IN (' + @OrderIDList + ') AND VoucherID = ''' + @VoucherID + ''' )                         THEN 1                     ELSE 0                 END AS IsCheck
            FROM OT2002 INNER JOIN OT2001 ON OT2001.SOrderID = OT2002.SOrderID                INNER JOIN AT1302 ON AT1302.InventoryID = OT2002.InventoryID                INNER JOIN OV2901 ON OV2901.SOrderID = OT2002.SOrderID 
                    AND OV2901.TransactionID = OT2002.TransactionID 
                LEFT JOIN AT1304 ON AT1304.UnitID = OT2002.UnitID
                LEFT JOIN AT1309 ON AT1309.InventoryID = OT2002.InventoryID 
                    AND AT1309.UnitID = OT2002.UnitID
        WHERE (OT2001.DivisionID = ''' + @DivisionID + ''' 
            AND OT2001.ObjectID LIKE ''' + @ObjectID + ''' 
            AND OT2002.TransactionID NOT IN (SELECT ISNULL(ReSPTransactionID, '''') FROM AT2007 WHERE DivisionID = ''' + @DivisionID + '''    ' + @sOrderIDList + '  ) AND ' + @sTimeWhere + ')
    ' 
    END
ELSE -- ke thua tu phieu giao van
    BEGIN
        SET @sSQL = '
            SELECT 
				OT2301.DivisionID,
                OT2301.VoucherNo, OT2302.ReSPVoucherID AS SOrderID, 
                OT2301.ObjectID, NULL AS CurrencyID, OT2302.InventoryID, 
                CASE WHEN ISNULL(OT2302.InventoryCommonName, '''') = '''' THEN AT1302.InventoryName ELSE OT2302.InventoryCommonName END AS InventoryName, 
                CASE WHEN ISNULL(OT2302.InventoryCommonName, '''') = '''' THEN 0 ELSE 1 END AS IsInventoryCommonName, 
                AT1302.UnitID, 
                OT2302.ActualQuantity AS Quantity, 
                1 AS ConversionFactor, 
                OT2302.UnitPrice, 
                OT2302.OriginalAmount, 
                OT2302.ConvertedAmount, 
                NULL AS DiscountPercent, NULL AS DiscountConvertedAmount, 
                AT1302.IsSource, AT1302.IsLocation, AT1302.SalesAccountID, AT1302.IsLimitDate, 
                AT1302.AccountID, AT1302.PrimeCostAccountID, AT1302.MethodID, AT1302.IsStocked, 
                OT2302.Ana01ID, OT2302.Ana02ID, OT2302.Ana03ID, OT2302.Ana04ID, OT2302.Ana05ID, OT2302.Orders, 
                OT2302.DeRefNo1, OT2302.DeRefNo2, 
                OT2302.TransactionID AS ReSPTransactionID, OT2302.VoucherID AS ReSPVoucherID, 
                CASE WHEN OT2302.TransactionID IN (SELECT ReSPTransactionID FROM AT2007 WHERE ReSPVoucherID IN (' + @OrderIDList + ') AND VoucherID = ''' + @VoucherID + ''' ) 
                        THEN 1 ELSE 0
                    END AS IsCheck
            FROM OT2302 INNER JOIN OT2301 ON OT2301.VoucherID = OT2302.VoucherID                INNER JOIN AT1302 ON AT1302.InventoryID = OT2302.InventoryID
                LEFT JOIN AT1304 ON AT1304.UnitID = OT2302.UnitID
                LEFT JOIN AT1309 ON AT1309.InventoryID = OT2302.InventoryID 
                    AND AT1309.UnitID = OT2302.OriginalUnitID
            WHERE (OT2301.DivisionID = ''' + @DivisionID + ''' 
                AND OT2301.ObjectID LIKE ''' + @ObjectID + ''' 
                AND OT2301.Status IN (1) 
                AND OT2302.TransactionID NOT IN (SELECT ISNULL(ReSPTransactionID, '''') FROM AT2007 WHERE DivisionID = ''' + @DivisionID + '''    ' + @sOrderIDList + '  ) AND ' + @sTimeWhere + ')
        ' 
    END        

 -- Print @sSQL
IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'WV2027' + @ConnID )
    EXEC('CREATE VIEW WV2027' + @ConnID + ' AS ' + @sSQL)
ELSE
    EXEC('ALTER VIEW WV2027' + @ConnID + ' AS ' + @sSQL)