IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7085]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7085]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bao Anh	Date: 04/10/2012 
--- Purpose: View lay so du so chi tiet vat tu theo quy cach giong AP7015 (2T)
-- <Example>
---- 

CREATE PROCEDURE [dbo].[AP7085] 
    @DivisionID NVARCHAR(50), 
    @WareHouseID NVARCHAR(50), 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @FromDate DATETIME, 
    @ToDate DATETIME, 
    @IsDate TINYINT
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @WareHouseID2 NVARCHAR(50), 
    @WareHouseName NVARCHAR(250)


IF @WareHouseID = '%'
    BEGIN
        SET @WareHouseID2 = '''%'''
        SET @WareHouseName = '''WFML000110'''        
    END    
ELSE
    BEGIN
        SET @WareHouseID2 = 'AT2888.WareHouseID'
        SET @WareHouseName = 'AT1303.WareHouseName'
    END


IF @IsDate = 0 --- Theo ky
    BEGIN 
        SET @Ssql = N'
            SELECT	AT2888.DivisionID,' + @WareHouseID2 + ' AS WareHouseID, 
					' + @WareHouseName + ' AS WareHouseName, 
					AT2888.InventoryID, 
					AT1302.InventoryName, 
					AT1302.UnitID, 
					AT1304.UnitName,
					AT2888.Parameter01, AT2888.Parameter02, AT2888.Parameter03, AT2888.Parameter04, AT2888.Parameter05,  
					SUM(BeginQuantity) AS BeginQuantity, 
					SUM(EndQuantity) AS EndQuantity, 
					SUM(BeginAmount) AS BeginAmount, 
					SUM(EndAmount) AS EndAmount
            FROM	AT2888 
            INNER JOIN AT1302 ON AT1302.InventoryID = AT2888.InventoryID and  AT1302.DivisionID = AT2888.DivisionID
            INNER JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID and  AT1304.DivisionID = AT2888.DivisionID
            INNER JOIN AT1303 ON AT1303.WareHouseID = AT2888.WareHouseID  and  AT1303.DivisionID = AT2888.DivisionID
            WHERE AT2888.DivisionID = N''' + @DivisionID + ''' 
					AND AT2888.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
					AND (CASE WHEN N''' + @WareHouseID + ''' = ''%'' THEN AT1303.IsTemp ELSE 0 END = 0) 
					AND AT2888.WareHouseID LIKE N''' + @WareHouseID + ''' 
					AND TranMonth + TranYear * 100 = ' + STR(@FromMonth) + ' + 100 * ' + STR(@FromYear) + ' 
            GROUP BY AT2888.DivisionID,AT2888.InventoryID, AT1302.InventoryName, AT1302.UnitID, AT1304.UnitName,
					AT2888.Parameter01, AT2888.Parameter02, AT2888.Parameter03, AT2888.Parameter04, AT2888.Parameter05
        '

        IF @WareHouseID <> '%'
            SET @sSQL = @sSQL + N', AT2888.WareHouseID, AT1303.WareHouseName '
    END 
ELSE
    BEGIN
        IF @WareHouseID <> '%'
            SET @sSQL = N'    
                SELECT	DivisionID, WareHouseID, 
						WareHouseName, 
						InventoryID, 
						InventoryName, 
						UnitID, UnitName,
						Parameter01, Parameter02, Parameter03, Parameter04, Parameter05, 
						SUM(SignQuantity) AS BeginQuantity, 
						SUM(SignAmount) AS BeginAmount, 
						0 AS EndQuantity, 
						0 AS EndAmount
                FROM	AV7011
                WHERE	DivisionID LIKE N''' + @DivisionID + ''' 
						AND ((D_C in (''D'', ''C'') AND CONVERT(DATETIME, CONVERT(VARCHAR(10), VoucherDate, 101), 101) < ''' + Convert(NVARCHAR(10), @FromDate, 101) + ''') 
								OR D_C = ''BD'') 
						AND WareHouseID LIKE N''' + @WareHouseID + ''' 
						AND InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
                GROUP BY DivisionID, InventoryID, InventoryName, UnitID, UnitName,
						Parameter01, Parameter02, Parameter03, Parameter04, Parameter05, WareHouseID, WareHouseName
                ---Having SUM(SignQuantity) <> 0 OR SUM(SignAmount) <> 0 
            '
        ELSE
            SET @sSQL = N'
				SELECT	DivisionID, 
						' + @WareHouseID2 + ' AS WareHouseID, 
						' + @WareHouseName + ' AS WareHouseName, 
						InventoryID, 
						InventoryName, 
						UnitID, UnitName,
						Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
						SUM(SignQuantity) AS BeginQuantity, 
						SUM(SignAmount) AS BeginAmount, 
						0 AS EndQuantity, 
						0 AS EndAmount
                FROM	AV7011
                WHERE	DivisionID LIKE N''' + @DivisionID + ''' 
						AND ((D_C in (''D'', ''C'') 
								AND CONVERT(DATETIME, CONVERT(VARCHAR(10), VoucherDate, 101), 101) < ''' + CONVERT(NVARCHAR(10), @FromDate, 101) + ''') 
								OR D_C = ''BD'') 
						AND WareHouseID LIKE N''' + @WareHouseID + ''' 
						AND InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
                GROUP BY DivisionID, InventoryID, InventoryName, UnitID, UnitName,
						Parameter01, Parameter02, Parameter03, Parameter04, Parameter05 
                ---Having SUM(SignQuantity) <> 0 OR SUM(SignAmount) <> 0 
            '
    END
    
--PRINT @sSQL    
IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV7015')
    EXEC('CREATE VIEW AV7015 	--CREATED BY AP7085
    AS ' + @sSQL)
ELSE
    EXEC('ALTER VIEW AV7015 	--CREATED BY AP7085
    AS ' + @sSQL)
---- Lay so phat sinh



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

