/****** Object:  StoredProcedure [dbo].[WP0013]    Script Date: 08/03/2010 15:02:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

 ---- Created by Nguyen Quoc Huy, Date: 20/07/2009
 ---- Purpose: Loc ra cac phieu Nhap kho mua hang, xuât kho ban hang de len man hinh truy van

/********************************************
'* Edited by: [GS] [Việt Khánh] [04/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[WP0013]
    @DivisionID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT, 
    @WareHouseID NVARCHAR(50) = '', 
    @ConnID NVARCHAR(100) = ''
AS

DECLARE 
    @sSQL1 NVARCHAR(4000), 
    @sSQL2 NVARCHAR(4000), 
    @sSQL3 NVARCHAR(4000)

 ----- Buoc  1 : Tra ra thong tin Master View WV0013
SET @sSQL1 = '
    SELECT AT2006.ReDeTypeID, 
        AT2006.VoucherTypeID, 
        VoucherNo, 
        VoucherDate, 
        AT2006.RefNo01, 
        AT2006.RefNo02, 
        ConvertedAmount = (SELECT SUM(ConvertedAmount) FROM AT2007 WHERE voucherID = AT2006.VoucherID), 
        AT2006.ObjectID + '' - '' + CASE WHEN ISNULL(AT2006.VATObjectName, '''') = '''' THEN ObjectName ELSE VATObjectName END AS ObjectID, 
        AT2006.ObjectID AS ObjectIDFind, 
        AT1202.ObjectName, 
        AT1202.Address, 
        AT2006.TableID, 
        AT2006.ContactPerson, 
        AT2006.RDAddress AS DEAddress, 
        AT2006.EmployeeID, AT1103.FullName, 
        (CASE WHEN KindVoucherID IN (15, 17) THEN AT2006.WareHouseID ELSE '''' END) AS ImWareHouseID, 
        (CASE WHEN KindVoucherID IN (14, 20) THEN AT2006.WareHouseID ELSE '''' END) AS ExWareHouseID, 
        AT2006.Description, AT2006.VoucherID, AT2006.OrderID, AT2006.ProjectID, AT2006.Status, AT2006.DivisionID, AT2006.TranMonth, 
        AT2006.TranYear, AT2006.CreateDate, AT2006.CreateUserID, AT2006.LastModifyUserID, AT2006.LastModifyDate, 
        AT2006.KindVoucherID, AT2004.OrderNo AS OrderNo, AT1303.WareHouseName AS WareHouseName, 
        WE.WareHouseName AS ExWareHouseName
    FROM AT2006 LEFT JOIN AT1202 ON AT1202.ObjectID = AT2006.ObjectID
            LEFT JOIN AT2004 ON AT2004.OrderID = AT2006.OrderID
            LEFT JOIN AT1303 ON AT2006.WareHouseID = AT1303.WarehouseID AND AT2006.DivisionID = AT1303.DivisionID
            LEFT JOIN AT1303 AS WE ON AT2006.WareHouseID2 = WE.WarehouseID AND AT2006.DivisionID = WE.DivisionID
            LEFT JOIN AT1103 ON AT1103.EmployeeID = AT2006.EmployeeID AND AT1103.DivisionID = AT2006.DivisionID
    WHERE AT2006.DivisionID = ''' + @DivisionID + ''' AND
        AT2006.TranMonth = ' + STR(@TranMonth) + ' AND
        AT2006.TranYear = ' + STR(@TranYear) + ' 
'

 -- print @sSQL
IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'WV0013' + @ConnID)
    EXEC('CREATE VIEW  WV0013' + @ConnID + ' AS ' + @sSQL1)
ELSE
    EXEC('ALTER VIEW WV0013' + @ConnID + ' AS ' + @sSQL1)

 ----- Buoc  2 : Tra ra thong tin Detail View WV0014
SET @sSQL1 = '
    SELECT AT2006.ReDeTypeID, AT2006.VoucherTypeID, AT2006.VoucherNo, 
        AT2006.VoucherDate, 
        AT2006.RefNo01, 
        AT2006.RefNo02, 
        AT2006.RDAddress, 
        AT2006.ContactPerson, 
        AT1302.InventoryTypeID, 
        AT2006.ObjectID, 
        AT2006.VATObjectName, 
        (CASE WHEN AT2006.KindVoucherID IN (15, 17) THEN AT2006.WareHouseID ELSE '''' END) AS ImWareHouseID, 
        (CASE WHEN AT2006.KindVoucherID IN (14, 20) THEN AT2006.WareHouseID ELSE '''' END) AS ExWareHouseID, 
        AT2006.EmployeeID, AT2007.TransactionID, AT2006.VoucherID, AT2006.BatchID, 
        AT2007.InventoryID, AT1302.InventoryName, AT2007.UnitID, AT1304.UnitName, 
        AT2007.ActualQuantity, AT2007.UnitPrice, 
        AT2007.OriginalAmount, AT2007.ConvertedAmount, AT2006.Description, AT2006.TranMonth, AT2006.TranYear, AT2006.DivisionID, 
        AT2007.SaleUnitPrice, AT2007.SaleAmount, AT2007.DiscountAmount, AT2007.SourceNo, 
        AT2007.DebitAccountID, AT2007.CreditAccountID, AT2007.LocationID, 
        AT2007.ImLocationID, 
        AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID, 
        AT1.AnaName AS Ana01Name, 
        AT2.AnaName AS Ana02Name, 
        AT3.AnaName AS Ana03Name, 
        AT4.AnaName AS Ana04Name, 
        AT5.AnaName AS Ana05Name, 
        AT2007.Orders, AT2007.LimitDate, AT2007.Notes AS Notes, 
        AT2007.ConversionFactor, AT2007.ReVoucherID, AT2007.ReTransactionID, 
        AT2007.OrderID, 
        AT1302.IsSource, AT1302.IsLimitDate, AT1302.IsLocation, 
        AT1302.MethodID, 
        V06.VoucherNo AS ReVoucherNo, 
        AT1302.AccountID, 
        AT1302.Specification, 
        AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, 
        AT2007.PeriodID, 
        AT2007.ReSPVoucherID, 
        AT2007.ReSPTransactionID, 
        OT3001.OrderDate AS PurchaseOrderDate, 
        M01.Description AS PeriodName, 
        AT2007.ProductID, 
        AT02.InventoryName AS ProductName, 
'

SET @sSQL2 = '
    CASE WHEN WV0114.InventoryID IS NULL THEN 1 ELSE 0 END AS isEdit, 
    ActEndQty = 
    (
     -- Ton dau
        ISNULL((SELECT SUM(ISNULL(T17.ActualQuantity, 0)) FROM At2016 T16, At2017 T17
                WHERE T16.VoucherID = T17.VoucherID
                    AND T16.DivisionID = ''' + @DivisionID + ''' 
                    AND T16.WareHouseID = ''' + @WareHouseID + ''' 
                    AND T17.InventoryID = AT2007.InventoryID), 0) 
        + 
-- Nhap trong ky
        ISNULL((SELECT SUM(ISNULL(T07.ActualQuantity, 0)) FROM At2006 T06, At2007 T07
                WHERE T06.VoucherID = T07.VoucherID
                    AND T06.KindVoucherID IN (1, 3, 5, 7, 15, 17)
                    AND T06.DivisionID = ''' + @DivisionID + ''' 
                    AND T06.WareHouseID = ''' + @WareHouseID + ''' 
                    AND T06.TranYear*12 + T06.TranMonth <= ' + LTRIM(@TranYear*12 + @TranMonth) + ' 
                    AND T06.VoucherDate <= AT2006.VoucherDate 
                    AND T06.VoucherID NOT IN (SELECT sT06.VoucherID FROM AT2006 sT06 WHERE VoucherDate = AT2006.VoucherDate AND sT06.CreateDate >= AT2006.CreateDate) 
                    AND T07.InventoryID = AT2007.InventoryID), 0) 
        - 
        (
-- Xuat thuong trong ky
            ISNULL((SELECT SUM(ISNULL(T07.ActualQuantity, 0)) FROM AT2006 T06, At2007 T07
                    WHERE T06.VoucherID = T07.VoucherID
                        AND T06.KindVoucherID IN (2, 4, 6, 8, 14, 20)
                        AND T06.DivisionID = ''' + @DivisionID + ''' 
                        AND T06.WareHouseID = ''' + @WareHouseID + ''' 
                        AND T06.TranYear*12 + T06.TranMonth <= ' + LTRIM(@TranYear*12 + @TranMonth) + ' 
                        AND T06.VoucherDate <= AT2006.VoucherDate 
                        AND T06.VoucherID NOT IN (SELECT sT06.VoucherID FROM AT2006 sT06 WHERE VoucherDate = AT2006.VoucherDate AND sT06.CreateDate >= AT2006.CreateDate) 
                        AND T07.InventoryID = AT2007.InventoryID), 0)
                + 
-- Xuat VCNB trong ky
            ISNULL((SELECT SUM(ISNULL(T07.ActualQuantity, 0)) FROM AT2006 T06, At2007 T07
                    WHERE T06.VoucherID = T07.VoucherID
                        AND T06.KindVoucherID IN (3)
                        AND T06.DivisionID = ''' + @DivisionID + ''' 
                        AND T06.WareHouseID2 = ''' + @WareHouseID + ''' 
                        AND T06.TranYear*12 + T06.TranMonth <= ' + LTRIM(@TranYear*12 + @TranMonth) + ' 
                        AND T06.VoucherDate <= AT2006.VoucherDate 
                        AND T06.VoucherID NOT IN (SELECT sT06.VoucherID FROM AT2006 sT06 WHERE VoucherDate = AT2006.VoucherDate AND sT06.CreateDate >= At2006.CreateDate) 
                        AND T07.InventoryID = AT2007.InventoryID), 0)
        )
    )
'

SET @sSQL3 = '     
    FROM AT2007 INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID
        LEFT JOIN AT1304 ON AT1304.UnitID = AT2007.UnitID
        INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID
        LEFT JOIN AV2006 V06 ON V06.VoucherID = AT2007.ReVoucherID 
            AND V06.TransactionID = AT2007.ReTransactionID
        LEFT JOIN MT1601 M01 ON M01.PeriodID = AT2007.PeriodID
        LEFT JOIN AT1302 AS AT02 ON  AT02.InventoryID = AT2007.ProductID
        LEFT JOIN OT3001 ON OT3001.POrderID = AT2007.ReSPVoucherID
        LEFT JOIN WV0114 ON WV0114.InventoryID = AT2007.InventoryID 
            AND WV0114.ReVoucherID = AT2007.VoucherID 
            AND WV0114.ReTransactionID = AT2007.TransactionID 
            AND WV0114.DeQuantity <> 0  
        LEFT JOIN AT1011 AT1 ON AT2007.Ana01ID = AT1.AnaID AND AT1.AnaTypeID = ''A01''
        LEFT JOIN AT1011 AT2 ON AT2007.Ana02ID = AT2.AnaID AND AT2.AnaTypeID = ''A02''
        LEFT JOIN AT1011 AT3 ON AT2007.Ana03ID = AT3.AnaID AND AT3.AnaTypeID = ''A03''
        LEFT JOIN AT1011 AT4 ON AT2007.Ana04ID = AT4.AnaID AND AT4.AnaTypeID = ''A04''
        LEFT JOIN AT1011 AT5 ON AT2007.Ana05ID = AT5.AnaID AND AT5.AnaTypeID = ''A05''
    WHERE AT2007.DivisionID = ''' + @DivisionID + ''' AND
        AT2007.TranMonth = ' + STR(@TranMonth) + ' AND
        AT2007.TranYear = ' + STR(@TranYear) + '
'

 -- Print @sSQL
IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'WV0014' + @ConnID )
    EXEC('CREATE VIEW WV0014' + @ConnID + ' AS ' + @sSQL1 + @sSQL2 + @sSQL3)
ELSE
    EXEC('ALTER VIEW WV0014' + @ConnID + ' AS ' + @sSQL1 + @sSQL2 + @sSQL3)