IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP2047]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[WP2047]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-----Create by Nguyen Quoc Huy, Date 11/07/2007
-----Purpose: Nhat ky kiem ke hang hoa.
-----Edited by: [GS] [Việt Khánh] [04/08/2010]
-----Edited by Thanh Sơn: Lấy dữ liệu trực tiếp từ store, không sinh ra view WV2047

CREATE PROCEDURE [dbo].[WP2047] 
    @DivisionID NVARCHAR(50), 
    @FromWareHouseID NVARCHAR(50), 
    @ToWareHouseID NVARCHAR(50), 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @FromDate DATETIME, 
    @ToDate DATETIME, 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @IsDate TINYINT
AS

SET NOCOUNT ON
DECLARE @sSQL NVARCHAR(4000), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

IF @IsDate = 1 -- Theo ngay 
    SET @sSQL = '
        SELECT 
			AT2037.DivisionID,
			AT2036.WareHouseID, 
            AT1303.WareHouseName, 
            AT2036.VoucherID, 
            AT2037.TransactionID, 
            CAST(DAY(AT2036.VoucherDate) + MONTH(AT2036.VoucherDate)* 100 + YEAR(AT2036.VoucherDate)*10000 AS NCHAR(8)) + CAST(AT2036.VoucherNo AS NCHAR(50)) + CAST(AT2037.TransactionID AS NCHAR(50)) + CAST(AT2037.InventoryID AS NCHAR(50)) AS Orders, 
            AT2036.VoucherDate, 
            AT2036.VoucherNo, 
            AT2037.SourceNo, 
            AT2037.Quantity, 
            AT2037.UnitPrice, 
            AT2037.OriginalAmount, 
            AT2037.AdjustQuantity, 
            AT2037.AdjustUnitPrice, 
            AT2037.AdjutsOriginalAmount, 
            AT2036.VoucherTypeID, 
            AT2036.Description, 
            AT2037.InventoryID, 
            AT1302.InventoryName, 
            AT2037.UnitID, 
            T07.ACCQuantity, 
            T07.ACCOriginalAmount, 
            T07.ACCConvertedAmount, 
            T08.DesQuantity, 
            T08.DesOriginalAmount, 
            T08.DesConvertedAmount
        FROM AT2037 INNER JOIN AT1302 ON AT1302.InventoryID = AT2037.InventoryID and AT1302.DivisionID = AT2037.DivisionID
            INNER JOIN AT2036 ON AT2036.VoucherID = AT2037.VoucherID and AT2036.DivisionID = AT2037.DivisionID
            INNER JOIN AT1303 ON AT1303.WarehouseID = AT2036.WarehouseID and AT1303.DivisionID = AT2037.DivisionID
            LEFT JOIN (SELECT AT2007.DivisionID,InventoryID, SUM(ISNULL(ActualQuantity, 0)) AS ACCQuantity, UnitPrice AS ACCUnitPrice, SUM(ISNULL(OriginalAmount, 0)) AS ACCOriginalAmount, SUM(ISNULL(ConvertedAmount, 0)) AS ACCConvertedAmount
                       FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID and AT2007.DivisionID = AT2006.DivisionID
                       WHERE KindVoucherID = 9 GROUP BY AT2007.DivisionID,InventoryID, UnitPrice)AS T07 ON T07.InventoryID = AT2037.InventoryID  and T07.DivisionID = AT2037.DivisionID
            LEFT JOIN (SELECT AT2007.DivisionID,InventoryID, SUM(ISNULL(ActualQuantity, 0)) AS DesQuantity, UnitPrice AS DesUnitPrice, SUM(ISNULL(OriginalAmount, 0)) AS DesOriginalAmount, SUM(ISNULL(ConvertedAmount, 0)) AS DesConvertedAmount
                       FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID and AT2007.DivisionID = AT2006.DivisionID
                       WHERE KindVoucherID = 8  GROUP BY AT2007.DivisionID,InventoryID, UnitPrice)AS T08 ON T08.InventoryID = AT2037.InventoryID and T08.DivisionID = AT2037.DivisionID 
        WHERE AT2037.DivisionID = ''' + @DivisionID + ''' 
            AND (AT2036.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''') 
            AND (AT2037.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''') 
            AND (AT2036.WareHouseID BETWEEN N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')
    '
ELSE
    IF @IsDate = 0 -- Theo ky 
        SET @sSQL = '
            SELECT 
				AT2037.DivisionID,
				AT2036.WareHouseID, 
                AT1303.WareHouseName, 
                AT2036.VoucherID, 
                AT2037.TransactionID, 
                CAST(DAY(AT2036.VoucherDate) + MONTH(AT2036.VoucherDate)* 100 + YEAR(AT2036.VoucherDate)*10000 AS NCHAR(8)) + CAST(AT2036.VoucherNo AS NCHAR(50)) + CAST(AT2037.TransactionID AS NCHAR(50)) + CAST(AT2037.InventoryID AS NCHAR(50)) AS Orders, 
                AT2036.VoucherDate, 
                AT2036.VoucherNo, 
                AT2037.SourceNo, 
                AT2037.Quantity, 
                AT2037.UnitPrice, 
                AT2037.OriginalAmount, 
                AT2037.AdjustQuantity, 
                AT2037.AdjustUnitPrice, 
                AT2037.AdjutsOriginalAmount, 
                AT2036.VoucherTypeID, 
                AT2036.Description, 
                AT2037.InventoryID, 
                AT1302.InventoryName, 
                AT2037.UnitID, 
                T07.ACCQuantity, 
                T07.ACCOriginalAmount, 
                T07.ACCConvertedAmount, 
                T08.DesQuantity, 
                T08.DesOriginalAmount, 
                T08.DesConvertedAmount    
            FROM AT2037 INNER JOIN AT1302 ON AT1302.InventoryID = AT2037.InventoryID and  AT1302.DivisionID = AT2037.DivisionID
                INNER JOIN AT2036 ON AT2036.VoucherID = AT2037.VoucherID and  AT2036.DivisionID = AT2037.DivisionID
                INNER JOIN AT1303 ON AT1303.WarehouseID = AT2036.WarehouseID and  AT1303.DivisionID = AT2037.DivisionID
                LEFT JOIN (SELECT AT2007.DivisionID,InventoryID, SUM(ISNULL(ActualQuantity, 0)) AS ACCQuantity, UnitPrice AS ACCUnitPrice, SUM(ISNULL(OriginalAmount, 0)) AS ACCOriginalAmount, SUM(ISNULL(ConvertedAmount, 0)) AS ACCConvertedAmount
                           FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID and  AT2007.DivisionID = AT2006.DivisionID
                           WHERE KindVoucherID = 9 GROUP BY AT2007.DivisionID,InventoryID, UnitPrice)AS T07 ON T07.InventoryID = AT2037.InventoryID  and  T07.DivisionID = AT2037.DivisionID
                LEFT JOIN (SELECT AT2007.DivisionID,InventoryID, SUM(ISNULL(ActualQuantity, 0)) AS DesQuantity, UnitPrice AS DesUnitPrice, SUM(ISNULL(OriginalAmount, 0)) AS DesOriginalAmount, SUM(ISNULL(ConvertedAmount, 0)) AS DesConvertedAmount
                           FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID and  AT2007.DivisionID = AT2006.DivisionID
                           WHERE KindVoucherID = 8 GROUP BY AT2007.DivisionID,InventoryID, UnitPrice)AS T08 ON T08.InventoryID = AT2037.InventoryID  and  T08.DivisionID = AT2037.DivisionID
            WHERE AT2037.DivisionID = ''' + @DivisionID + ''' 
                AND (AT2036.TranMonth + AT2036.TranYear*100   BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText + ') 
                AND (AT2037.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''') 
                AND (AT2036.WareHouseID BETWEEN N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')
'

EXEC (@sSQL)
 -- PRINT @sSQL
--IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'WV2047')
--    EXEC('----- tao boi WP2047
--        CREATE VIEW WV2047 AS ' + @sSQL)
--ELSE
--    EXEC('----- tao boi WP2047
--        ALTER VIEW WV2047 AS ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
