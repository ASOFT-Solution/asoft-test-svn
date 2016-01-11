IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1313]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1313]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

------- Created by Nguyen Thi Ngoc Minh, Date 18/08/2004
------- Bao cao hang ton kho theo muc toi thieu, toi da, so luong hien co
------- Edit by Nguyen Quoc Huy, Date 25/01/2007

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/
---- Modified on 29/07/2013 : Bổ sung hàng đang về, hàng giữ chỗ giống như báo cáo OR2501 (màn hình OF0100) 
---- Modified on 16/07/2014: Lấy dữ liệu trực tiếp từ store, không sinh view AV1313

CREATE PROCEDURE [dbo].[AP1313] 
    @DivisionID NVARCHAR(50), 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @WareHouseID NVARCHAR(50), 
    @NormID NVARCHAR(50), 
    @ReportDate DATETIME, 
    @IsGeneral TINYINT,     --: Tong hop cac kho
    @IsNormGroup TINYINT    --0: Nhom theo ma loai dinh muc 
                            --1: Nhom theo ma kho
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
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

IF @IsGeneral = 1 AND @WareHouseID = '%'
    BEGIN
        EXEC AP7016 @DivisionID, '%', '%', @FromInventoryID, @ToInventoryID, '%', 1, 2004, 1, 2004, @ReportDate, @ReportDate, 1, 1
        
        SET @sSQL = N'
            SELECT DISTINCT AT1314.InventoryID, 
                AT1302.InventoryName, 
                AT1302.UnitID, 
                AT1309.UnitID AS ConversionUnitID, 
                ISNULL(AT1309.ConversionFactor, 1) AS ConversionFactor, 
                AT1314.NormID, AT1313.Description, 
                ''%'' AS WareHouseID, 
                ''WFML000110'' AS WareHouseName, 
                ' + ltrim(str(@IsNormGroup)) + ' AS GroupTitle, 
                ' + CASE WHEN @IsNormGroup = 0 THEN 'AT1314.NormID' ELSE '''%''' END + ' AS GroupID, 
                ' + CASE WHEN @IsNormGroup = 0 THEN 'AT1313.Description' ELSE '''WFML000110''' END + ' AS GroupName, 
                ' + CASE WHEN @IsNormGroup = 1 THEN 'AT1314.NormID' ELSE '''%''' END + ' AS DetailID, 
                ' + CASE WHEN @IsNormGroup = 1 THEN 'AT1313.Description' ELSE '''WFML000110''' END + ' AS DetailName, 
                sum(ISNULL(AV7016.BeginQuantity, 0)) AS QuantityOnHand, 
                AT1314.MaxQuantity, 
                AT1314.MinQuantity, 
                AT1314.ReOrderQuantity,
                AT1314.DivisionID,
                A.SQuantity , A.PQuantity
            FROM AT1314 
            LEFT JOIN AV7016 ON AV7016.InventoryID = AT1314.InventoryID and AV7016.DivisionID = AT1314.DivisionID
            LEFT JOIN AT1302 ON AT1302.InventoryID = AT1314.InventoryID and AT1302.DivisionID = AT1314.DivisionID
            LEFT JOIN AT1313 ON AT1313.NormID = AT1314.NormID and AT1313.DivisionID = AT1314.DivisionID
            LEFT JOIN AT1309 ON AT1309.InventoryID = AT1314.InventoryID and AT1309.DivisionID = AT1314.DivisionID
            LEFT JOIN (
            	SELECT 	DivisionID, InventoryID,
						SUM(CASE WHEN TypeID <> ''PO'' AND Finish <> 1 THEN OrderQuantity - ActualQuantity ELSE 0 END) AS SQuantity, 
						SUM(CASE WHEN TypeID = ''PO'' AND Finish <> 1 THEN OrderQuantity - ActualQuantity ELSE 0 END) AS PQuantity
				FROM	OV2800
            	WHERE	OV2800.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + '''
            			AND  OV2800.DivisionID = '''+@DivisionID+'''
				GROUP BY DivisionID, InventoryID
					)A
				ON	A.DivisionID = AT1314.DivisionID AND A.InventoryID = AT1314.InventoryID
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
                AT1314.DivisionID,
                A.SQuantity , A.PQuantity
        '
        
        IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE Name = 'AV1314')
            EXEC ('--Created by AP1313
                CREATE VIEW AV1314 AS ' + @sSQL)
        ELSE
            EXEC('--Created by AP1313
                ALTER VIEW AV1314 AS ' + @sSQL)

        EXEC AP7016 @DivisionID, @FromWareHouseID, @ToWareHouseID, @FromInventoryID, @ToInventoryID, '%', 1, 2004, 1, 2004, @ReportDate, @ReportDate, 1, 1
        
        SET @sSQL = N'
            SELECT * FROM AV1314
            UNION ALL
            SELECT DISTINCT AT1314.InventoryID, 
                AT1302.InventoryName, 
                AT1302.UnitID, 
                AT1309.UnitID AS ConversionUnitID, 
                ISNULL(AT1309.ConversionFactor, 1) AS ConversionFactor, 
                AT1314.NormID, AT1313.Description, 
                ISNULL(AT1314.WareHouseID, AV7016.WareHouseID) AS WareHouseID, 
                AT1303.WareHouseName, 
                ' + ltrim(str(@IsNormGroup)) + ' AS GroupTitle, 
                ' + CASE WHEN @IsNormGroup = 0 THEN 'AT1314.NormID' ELSE 'AT1314.WareHouseID' END + ' AS GroupID, 
                ' + CASE WHEN @IsNormGroup = 0 THEN 'AT1313.Description' ELSE 'AT1303.WareHouseName' END + ' AS GroupName, 
                ' + CASE WHEN @IsNormGroup = 1 THEN 'AT1314.NormID' ELSE 'AT1314.WareHouseID' END + ' AS DetailID, 
                ' + CASE WHEN @IsNormGroup = 1 THEN 'AT1313.Description' ELSE 'AT1303.WareHouseName' END + ' AS DetailName, 
                sum(ISNULL(AV7016.BeginQuantity, 0)) AS QuantityOnHand, 
                AT1314.MaxQuantity, 
                AT1314.MinQuantity, 
                AT1314.ReOrderQuantity,
                AT1314.DivisionID,
                A.SQuantity , A.PQuantity
            FROM AT1314 
            INNER JOIN AV7016 ON AV7016.InventoryID = AT1314.InventoryID AND AV7016.WareHouseID = AT1314.WareHouseID AND AV7016.DivisionID = AT1314.DivisionID
            LEFT JOIN AT1302 ON AT1302.InventoryID = AT1314.InventoryID AND AT1302.DivisionID = AT1314.DivisionID
            LEFT JOIN AT1303 ON AT1303.WareHouseID = AT1314.WareHouseID AND AT1303.DivisionID = AT1314.DivisionID
            LEFT JOIN AT1313 ON AT1313.NormID = AT1314.NormID AND AT1313.DivisionID = AT1314.DivisionID
            LEFT JOIN AT1309 ON AT1309.InventoryID = AT1314.InventoryID AND AT1309.DivisionID = AT1314.DivisionID
            LEFT JOIN (
            	SELECT 	DivisionID, InventoryID, WareHouseID,
						SUM(CASE WHEN TypeID <> ''PO'' AND Finish <> 1 THEN OrderQuantity - ActualQuantity ELSE 0 END) AS SQuantity, 
						SUM(CASE WHEN TypeID = ''PO'' AND Finish <> 1 THEN OrderQuantity - ActualQuantity ELSE 0 END) AS PQuantity
				FROM	OV2800
            	WHERE	OV2800.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + '''
            			AND  OV2800.DivisionID = '''+@DivisionID+'''
				GROUP BY DivisionID, InventoryID,WareHouseID
					)A
				ON	A.DivisionID = AT1314.DivisionID AND A.InventoryID = AT1314.InventoryID AND A.WareHouseID = AT1314.WareHouseID
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
                AT1314.DivisionID,
                A.SQuantity , A.PQuantity
        '
    END
ELSE
    BEGIN
        EXEC AP7016 @DivisionID, @FromWareHouseID, @ToWareHouseID, @FromInventoryID, @ToInventoryID, '%', 1, 2004, 1, 2004, @ReportDate, @ReportDate, 1, 1

        EXEC AP1312 @DivisionID, @FromInventoryID, @ToInventoryID

        SET @sSQL = N'
            SELECT AV1312.WareHouseID, 
                AT1303.WareHouseName, 
                AV1312.InventoryID, 
                AT1302.InventoryName, 
                AT1302.UnitID, 
                AT1309.UnitID AS ConversionUnitID, 
                ISNULL(AT1309.ConversionFactor, 1) AS ConversionFactor, 
                AV1312.NormID, AT1313.Description, 
                ' + ltrim(str(@IsNormGroup)) + ' AS GroupTitle, 
                ' + CASE WHEN @IsNormGroup = 0 THEN 'AV1312.NormID' ELSE 'AV1312.WareHouseID' END + ' AS GroupID, 
                ' + CASE WHEN @IsNormGroup = 0 THEN 'AT1313.Description' ELSE 'AT1303.WareHouseName' END + ' AS GroupName, 
     ' + CASE WHEN @IsNormGroup = 1 THEN 'AV1312.NormID' ELSE 'AV1312.WareHouseID' END + ' AS DetailID, 
                ' + CASE WHEN @IsNormGroup = 1 THEN 'AT1313.Description' ELSE 'AT1303.WareHouseName' END + ' AS DetailName, 
                Sum(ISNULL(AV7016.BeginQuantity, 0)) AS QuantityOnHand, 
                AV1312.MaxQuantity, 
                AV1312.MinQuantity, 
                AV1312.ReOrderQuantity,
                AV1312.DivisionID,
                A.SQuantity , A.PQuantity
            FROM AV1312 
            INNER JOIN AV7016 ON AV7016.InventoryID = AV1312.InventoryID AND AV7016.WareHouseID = AV1312.WareHouseID AND AV7016.DivisionID = AV1312.DivisionID
            LEFT JOIN AT1302 ON AT1302.InventoryID = AV1312.InventoryID AND AT1302.DivisionID = AV1312.DivisionID
            LEFT JOIN AT1303 ON AT1303.WareHouseID = AV1312.WareHouseID AND AT1303.DivisionID = AV1312.DivisionID
            LEFT JOIN AT1313 ON AT1313.NormID = AV1312.NormID AND AT1313.DivisionID = AV1312.DivisionID
            LEFT JOIN AT1309 ON AT1309.InventoryID = AV1312.InventoryID AND AT1309.DivisionID = AV1312.DivisionID
            LEFT JOIN (
            	SELECT 	DivisionID, InventoryID, WareHouseID,
						SUM(CASE WHEN TypeID <> ''PO'' AND Finish <> 1 THEN OrderQuantity - ActualQuantity ELSE 0 END) AS SQuantity, 
						SUM(CASE WHEN TypeID = ''PO'' AND Finish <> 1 THEN OrderQuantity - ActualQuantity ELSE 0 END) AS PQuantity
				FROM	OV2800
            	WHERE	OV2800.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + '''
            			AND  OV2800.DivisionID = '''+@DivisionID+'''
				GROUP BY DivisionID, InventoryID,WareHouseID
					)A
				ON	A.DivisionID = AV1312.DivisionID AND A.InventoryID = AV1312.InventoryID AND A.WareHouseID = AV1312.WareHouseID
            WHERE AV1312.WareHouseID like N''' + @WareHouseID + ''' 
                AND AV1312.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
                AND AV1312.NormID like N''' + @NormID + '''
            GROUP BY AV1312.InventoryID, 
                AT1302.InventoryName, 
                AT1302.UnitID, 
                AT1309.UnitID, 
                AT1309.ConversionFactor, 
                AV1312.WareHouseID, 
                AT1303.WareHouseName, 
                AV1312.NormID, 
                AT1313.Description, 
                AV1312.MaxQuantity, 
                AV1312.MinQuantity, 
                AV1312.ReOrderQuantity,
                AV1312.DivisionID,
                A.SQuantity , A.PQuantity
        '
    END

EXEC (@sSQL)
--PRINT @sSQL
--IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE Name = 'AV1313')
--    EXEC ('--Created by AP1313
--        CREATE VIEW AV1313 AS ' + @sSQL)
--ELSE
--    EXEC('--Created by AP1313
--        ALTER VIEW AV1313 AS ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

