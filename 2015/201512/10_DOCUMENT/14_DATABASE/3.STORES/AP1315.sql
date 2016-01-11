IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1315]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1315]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----Created by Nguyen Thi Ngoc Minh, Date 18/08/2004
----Bao cao hang ton kho duoi muc toi thieu
----Edit by Nguyen Quoc Huy, Date 25/01/2007
----Edited by: [GS] [Việt Khánh] [29/07/2010] [Hoang Phuoc] [25/10/2010] Them N''
----Edited by: [GS] [Việt Khánh] [29/07/2010] [Hoang Phuoc] [25/10/2010] Them N''
----Modified by Thanh Sơn on 17/07/2014: Lấy dữ liệu từ store, không sinh ra view AV1315

CREATE PROCEDURE [dbo].[AP1315] 
    @DivisionID NVARCHAR(50), 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @WareHouseID NVARCHAR(50), 
    @NormID NVARCHAR(50), 
    @ReportDate DATETIME, 
    @IsNormGroup TINYINT, 
    @IsMin TINYINT          --0: Duoi muc toi thieu
                            --1: Duoi muc dat hang lai 
                            --2: Tren muc toi da
AS

DECLARE 
    @sSQL1 NVARCHAR(4000), 
    @sSQL2 NVARCHAR(4000), 
    @sHAVING NVARCHAR(4000), 
    @FromWareHouseID NVARCHAR(50), 
    @ToWareHouseID NVARCHAR(50)

SET @ReportDate = @ReportDate + 1

IF @WareHouseID = '%'
    BEGIN
        SET @FromWareHouseID = (SELECT TOP 1 WareHouseID FROM AT1303 Where DivisionID = @DivisionID)
        SET @ToWareHouseID = (SELECT TOP 1 WareHouseID FROM AT1303  Where DivisionID = @DivisionID ORDER BY WareHouseID DESC)
    END
ELSE 
    BEGIN
        SET @FromWareHouseID = @WareHouseID
        SET @ToWareHouseID = @WareHouseID
    END

IF @IsMin = 0 
    SET @sHAVING = ' Having AT1314.MinQuantity > SUM(ISNULL(AV7016.BeginQuantity, 0)) '
ELSE IF @IsMin = 1 
    SET @sHAVING = ' Having AT1314.ReOrderQuantity > SUM(ISNULL(AV7016.BeginQuantity, 0)) '
ELSE
    SET @sHAVING = ' Having AT1314.MaxQuantity < SUM(ISNULL(AV7016.BeginQuantity, 0)) '

EXEC AP7016 @DivisionID, '%', '%', @FromInventoryID, @ToInventoryID, '%', 1, 2004, 1, 2004, @ReportDate, @ReportDate, 1, 1

SET @sSQL1 = N'
    SELECT DISTINCT AT1314.InventoryID,
        AT1302.InventoryName, 
        AT1302.UnitID, 
        AT1309.UnitID AS ConversionUnitID, 
        ISNULL(AT1309.ConversionFactor, 1) AS ConversionFactor, 
        AT1314.NormID, AT1313.Description, 
        ''%'' AS WareHouseID, 
        ''WFML000110'' AS WareHouseName, 
        ' + LTRIM(STR(@IsNormGroup)) + ' AS GroupTitle, 
        ' + CASE WHEN @IsNormGroup = 0 THEN 'AT1314.NormID' ELSE '''%''' END + ' AS GroupID, 
        ' + CASE WHEN @IsNormGroup = 0 THEN 'AT1313.Description' ELSE '''WFML000110''' END + ' AS GroupName, 
        ' + CASE WHEN @IsNormGroup = 1 THEN 'AT1314.NormID' ELSE '''%''' END + ' AS DetailID, 
        ' + CASE WHEN @IsNormGroup = 1 THEN 'AT1313.Description' ELSE '''WFML000110''' END + ' AS DetailName, 
        ' + LTRIM(STR(@IsMin)) + ' AS Compare, 
        SUM(ISNULL(AV7016.BeginQuantity, 0)) AS QuantityOnHand, 
        AT1314.MaxQuantity, 
        AT1314.MinQuantity, 
        AT1314.ReOrderQuantity, 
        AT1314.DivisionID,
        ' + LTRIM(STR(@IsMin)) + ' AS IsMin
    FROM AT1314 INNER JOIN AV7016 ON AV7016.InventoryID = AT1314.InventoryID and AV7016.DivisionID = AT1314.DivisionID 
        LEFT JOIN AT1302 ON AT1302.InventoryID = AT1314.InventoryID and AT1302.DivisionID = AT1314.DivisionID
        LEFT JOIN AT1313 ON AT1313.NormID = AT1314.NormID and AT1313.DivisionID = AT1314.DivisionID
        LEFT JOIN AT1309 ON AT1309.InventoryID = AT1314.InventoryID and AT1309.DivisionID = AT1314.DivisionID
    WHERE AT1314.WareHouseID = ''%'' 
        AND AT1314.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
        AND AT1314.NormID like N''' + @NormID + ''' 
        AND ISNULL(AV7016.BeginQuantity, 0) <> 0
    GROUP BY AT1314.InventoryID, 
        AT1302.InventoryName, 
        AT1302.UnitID, 
        AT1309.UnitID, 
        AT1309.ConversionFactor, 
        AT1314.NormID, 
        AT1313.Description, 
        AT1314.MaxQuantity, 
        AT1314.MinQuantity, 
        AT1314.ReOrderQuantity,
        AT1314.DivisionID
'

EXEC AP7016 @DivisionID, @FromWareHouseID, @ToWareHouseID, @FromInventoryID, @ToInventoryID, '%', 1, 2004, 1, 2004, @ReportDate, @ReportDate, 1, 1

SET @sSQL2 = N'
    UNION ALL
    SELECT DISTINCT AT1314.InventoryID, 
        AT1302.InventoryName, 
        AT1302.UnitID, 
        AT1309.UnitID AS ConversionUnitID, 
        ISNULL(AT1309.ConversionFactor, 1) AS ConversionFactor, 
        AT1314.NormID, AT1313.Description, 
        ISNULL(AT1314.WareHouseID, AV7016.WareHouseID) AS WareHouseID, 
        AT1303.WareHouseName, 
        ' + LTRIM(STR(@IsNormGroup)) + ' AS GroupTitle, 
        ' + CASE WHEN @IsNormGroup = 0 THEN 'AT1314.NormID' ELSE 'AT1314.WareHouseID' END + ' AS GroupID, 
        ' + CASE WHEN @IsNormGroup = 0 THEN 'AT1313.Description' ELSE 'AT1303.WareHouseName' END + ' AS GroupName, 
        ' + CASE WHEN @IsNormGroup = 1 THEN 'AT1314.NormID' ELSE 'AT1314.WareHouseID' END + ' AS DetailID, 
        ' + CASE WHEN @IsNormGroup = 1 THEN 'AT1313.Description' ELSE 'AT1303.WareHouseName' END + ' AS DetailName, 
        ' + LTRIM(STR(@IsMin)) + ' AS Compare, 
        SUM(ISNULL(AV7016.BeginQuantity, 0)) AS QuantityOnHand, 
        AT1314.MaxQuantity, 
        AT1314.MinQuantity, 
        AT1314.ReOrderQuantity, 
        AT1314.DivisionID,
        ' + LTRIM(STR(@IsMin)) + ' AS IsMin
    FROM AT1314 INNER JOIN AV7016 ON (AV7016.InventoryID = AT1314.InventoryID 
        AND AV7016.WareHouseID = AT1314.WareHouseID AND AV7016.DivisionID = AT1314.DivisionID)
        LEFT JOIN AT1302 ON AT1302.InventoryID = AT1314.InventoryID AND AT1302.DivisionID = AT1314.DivisionID        LEFT JOIN AT1303 ON AT1303.WareHouseID = AT1314.WareHouseID AND AT1303.DivisionID = AT1314.DivisionID
        LEFT JOIN AT1313 ON AT1313.NormID = AT1314.NormID AND AT1313.DivisionID = AT1314.DivisionID
        LEFT JOIN AT1309 ON AT1309.InventoryID = AT1314.InventoryID AND AT1309.DivisionID = AT1314.DivisionID
    WHERE AT1314.WareHouseID <> ''%'' 
        AND AT1314.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
        AND AT1314.NormID like N''' + @NormID + ''' 
        AND ISNULL(AV7016.BeginQuantity, 0) <> 0
    GROUP BY AT1314.InventoryID, 
        AT1302.InventoryName, 
        AT1302.UnitID, 
        AT1309.UnitID, 
        AT1309.ConversionFactor, 
        AT1314.WareHouseID, 
        AV7016.WareHouseID, 
        AT1303.WareHouseName, 
        AV7016.WareHouseName, 
        AT1314.NormID, 
        AT1313.Description, 
        AT1314.MaxQuantity, 
        AT1314.MinQuantity, 
        AT1314.ReOrderQuantity,
        AT1314.DivisionID
'
EXEC (@sSQL1 + @sHAVING + @sSQL2 + @sHAVING)

--PRINT @sSQL
--IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE Name = 'AV1315')
--    EXEC ('--Created by AP1315
--        CREATE VIEW AV1315 AS ' + @sSQL1 + @sHAVING + @sSQL2 + @sHAVING)
--ELSE
--    EXEC('--Created by AP1315
--        ALTER VIEW AV1315 AS ' + )

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
