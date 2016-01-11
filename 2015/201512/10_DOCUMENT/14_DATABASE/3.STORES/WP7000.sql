/****** Object:  StoredProcedure [dbo].[WP7000]    Script Date: 08/03/2010 15:02:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

 -- Create by: Dang Le Bao Quynh; Date: 06/03/2009
 -- Purpose: IN bao cao nhap xuat ton theo mat hang chi tiet theo kho 

/********************************************
* Edited by: [GS] [Việt Khánh] [04/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[WP7000]     
    @DivisionID NVARCHAR(50), 
    @FromMonth INT, 
    @ToMonth INT, 
    @FromYear INT, 
    @ToYear INT, 
    @FromDate DATETIME, 
    @ToDate DATETIME, 
    @FromWareHouseID NVARCHAR(50), 
    @ToWareHouseID NVARCHAR(50), 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @IsDate TINYINT
AS

DECLARE @sSQL NVARCHAR(4000)

IF @IsDate = 0 
    BEGIN
        SET @sSQL = '
            SELECT T0.DivisionID, T0.WareHouseID, T2.WareHouseName, 
                T0.WareHouseID2, T3.WareHouseName AS WareHouseName2, 
                T0.InventoryID, T1.InventoryName, 
                SUM(BeginQuantity) AS BeginQuantity, 
                SUM(BeginAmount) AS BeginAmount, 
                SUM(ImQuantity) AS ImQuantity, 
                SUM(ImAmount) AS ImAmount, 
                SUM(ExQuantity) AS ExQuantity, 
                SUM(ExAmount) AS ExAmount, 
                (SUM(BeginQuantity) + SUM(ImQuantity) - SUM(ExQuantity)) AS EndQuantity, 
                (SUM(BeginAmount) + SUM(ImAmount) - SUM(ExAmount)) AS EndAmount
            FROM 
            (
                SELECT WQ8.DivisionID, WQ8.WareHouseID, WQ8.WareHouseID2, WQ8.InventoryID, 
                    SUM(WQ8.SignQuantity) AS BeginQuantity, SUM(WQ8.SignAmount) AS BeginAmount, 
                    0 AS ImQuantity, 
                    0 AS ImAmount, 
                    0 AS ExQuantity, 
                    0 AS ExAmount
                FROM WQ7000 WQ8 
                WHERE WQ8.DivisionID = ''' + @DivisionID + ''' 
                    AND WQ8.TranMonth + 12*WQ8.TranYear < ' + LTRIM(@FromMonth + 12 *@FromYear) + ' 
                    AND WQ8.WareHouseID BETWEEN ''' + @FromWareHouseID + ''' AND ''' + @ToWareHouseID + ''' AND WQ8.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 
                GROUP BY WQ8.DivisionID, WQ8.WareHouseID, WQ8.WareHouseID2, WQ8.InventoryID

                UNION ALL

                SELECT WQ7.DivisionID, WQ7.WareHouseID, WQ7.WareHouseID2, WQ7.InventoryID, 
                    0 AS BeginQuantity, 
                    0 AS BeginAmount, 
                    SUM(CASE WHEN KindVoucherID IN (1, 3) THEN ActualQuantity ELSE 0 END) AS ImQuantity, 
                    SUM(CASE WHEN KindVoucherID IN (1, 3) THEN ConvertedAmount ELSE 0 END) AS ImAmount, 
                    SUM(CASE WHEN KindVoucherID IN (2, 4) THEN ActualQuantity ELSE 0 END) AS ExQuantity, 
                    SUM(CASE WHEN KindVoucherID IN (2, 4) THEN ConvertedAmount ELSE 0 END) AS ExAmount
                FROM WQ7000 WQ7 
                WHERE WQ7.DivisionID = ''' + @DivisionID + ''' 
                    AND WQ7.TranMonth + 12*WQ7.TranYear BETWEEN ' + LTRIM(@FromMonth + 12 *@FromYear) + ' AND ' + LTRIM(@ToMonth + 12 *@ToYear) + ' 
                    AND WQ7.WareHouseID BETWEEN ''' + @FromWareHouseID + ''' AND ''' + @ToWareHouseID + ''' AND WQ7.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 
                GROUP BY WQ7.DivisionID, WQ7.WareHouseID, WQ7.WareHouseID2, WQ7.InventoryID
            ) AS T0 LEFT JOIN AT1302 T1 ON T0.InventoryID = T1.InventoryID
                LEFT JOIN AT1303 T2 ON T0.WareHouseID = T2.WareHouseID
                LEFT JOIN AT1303 T3 ON T0.WareHouseID2 = T3.WareHouseID
            GROUP BY T0.DivisionID, T0.WareHouseID, T2.WareHouseName, T0.WareHouseID2, T3.WareHouseName, T0.InventoryID, T1.InventoryName'        
    END
ELSE
    BEGIN
        SET @sSQL = '
            SELECT T0.DivisionID, 
                T0.WareHouseID, T2.WareHouseName, 
                T0.WareHouseID2, T3.WareHouseName AS WareHouseName2, 
                T0.InventoryID, T1.InventoryName, 
                SUM(BeginQuantity) AS BeginQuantity, 
                SUM(BeginAmount) AS BeginAmount, 
                SUM(ImQuantity) AS ImQuantity, 
                SUM(ImAmount) AS ImAmount, 
                SUM(ExQuantity) AS ExQuantity, 
                SUM(ExAmount) AS ExAmount, 
                (SUM(BeginQuantity) + SUM(ImQuantity) - SUM(ExQuantity)) AS EndQuantity, 
                (SUM(BeginAmount) + SUM(ImAmount) - SUM(ExAmount)) AS EndAmount
            FROM 
            (
                SELECT Q8.DivisionID, Q8.WareHouseID, WQ8.WareHouseID2, WQ8.InventoryID, 
                    SUM(WQ8.SignQuantity) AS BeginQuantity, SUM(WQ8.SignAmount) AS BeginAmount, 
                    0 AS ImQuantity, 
                    0 AS ImAmount, 
                    0 AS ExQuantity, 
                    0 AS ExAmount
                FROM WQ7000 WQ8 
                WHERE WQ8.DivisionID = ''' + @DivisionID + ''' 
                    AND WQ8.VoucherDate < ''' + LTRIM(@FromDate) + ''' 
                    AND WQ8.WareHouseID BETWEEN ''' + @FromWareHouseID + ''' AND ''' + @ToWareHouseID + ''' AND WQ8.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 
                GROUP BY WQ8.DivisionID, WQ8.WareHouseID, WQ8.WareHouseID2, WQ8.InventoryID

                UNION ALL

                SELECT WQ7.DivisionID, WQ7.WareHouseID, WQ7.WareHouseID2, WQ7.InventoryID, 
                    0 AS BeginQuantity, 
                    0 AS BeginAmount, 
                    SUM(CASE WHEN KindVoucherID IN (1, 3) THEN ActualQuantity ELSE 0 END) AS ImQuantity, 
                    SUM(CASE WHEN KindVoucherID IN (1, 3) THEN ConvertedAmount ELSE 0 END) AS ImAmount, 
                    SUM(CASE WHEN KindVoucherID IN (2, 4) THEN ActualQuantity ELSE 0 END) AS ExQuantity, 
                    SUM(CASE WHEN KindVoucherID IN (2, 4) THEN ConvertedAmount ELSE 0 END) AS ExAmount
                FROM WQ7000 WQ7 
                WHERE WQ7.DivisionID = ''' + @DivisionID + ''' 
                    AND WQ7.VoucherDate BETWEEN ''' + LTRIM(@FromDate) + ''' AND ''' + LTRIM(@ToDate) + ''' 
                    AND WQ7.WareHouseID BETWEEN ''' + @FromWareHouseID + ''' AND ''' + @ToWareHouseID + ''' AND WQ7.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 
                GROUP BY WQ7.DivisionID, WQ7.WareHouseID, WQ7.WareHouseID2, WQ7.InventoryID
            ) AS T0 LEFT JOIN AT1302 T1 ON T0.InventoryID = T1.InventoryID
                LEFT JOIN AT1303 T2 ON T0.WareHouseID = T2.WareHouseID
                LEFT JOIN AT1303 T3 ON T0.WareHouseID2 = T3.WareHouseID
            GROUP BY T0.DivisionID, T0.WareHouseID, T2.WareHouseName, T0.WareHouseID2, T3.WareHouseName, T0.InventoryID, T1.InventoryName'
    END
    
IF EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE id = Object_id('WV7001') AND xType = 'V')
    DROP VIEW WV7001

EXEC('CREATE VIEW WV7001 -- Create by WP7000
 AS ' + @sSQL)
 