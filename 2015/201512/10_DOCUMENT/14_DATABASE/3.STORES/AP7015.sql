IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7015]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7015]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- So du  so chi tiet vat tu
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 17/02/2004 by Nguyen Van Nhan
---- 
---- Edit BY Nguyen Quoc Huy, Date 12/07/2006
---- Modified on 25/10/2010 by Hoang Phuoc : Them N''
---- Modified on 11/01/2012 by Le Thi Thu Hien : Sua dieu kien theo ngay
---- Modified on 09/11/2015 by Tieu Mai: Bổ sung trường hợp có thiết lập quản lý theo quy cách hàng.
-- <Example>
---- 


CREATE PROCEDURE [dbo].[AP7015] 
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
    	IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
    	BEGIN
    		SET @WareHouseID2 = 'AT2008_QC.WareHouseID'
    	END
        else SET @WareHouseID2 = 'AT2008.WareHouseID'
        SET @WareHouseName = 'AT1303.WareHouseName'
    END


IF @IsDate = 0 --- Theo ky
    BEGIN 
        SET @Ssql = N'
            SELECT	AT2008.DivisionID,' + @WareHouseID2 + ' AS WareHouseID, 
					' + @WareHouseName + ' AS WareHouseName, 
					AT2008.InventoryID, 
					AT1302.InventoryName, 
					AT1302.UnitID, 
					AT1304.UnitName, 
					SUM(BeginQuantity) AS BeginQuantity, 
					SUM(EndQuantity) AS EndQuantity, 
					SUM(BeginAmount) AS BeginAmount, 
					SUM(EndAmount) AS EndAmount
            FROM	AT2008 
            INNER JOIN AT1302 ON AT1302.InventoryID = AT2008.InventoryID and  AT1302.DivisionID = AT2008.DivisionID
            INNER JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID and  AT1304.DivisionID = AT2008.DivisionID
            INNER JOIN AT1303 ON AT1303.WareHouseID = AT2008.WareHouseID  and  AT1303.DivisionID = AT2008.DivisionID
            WHERE AT2008.DivisionID = N''' + @DivisionID + ''' 
					AND AT2008.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
					AND (CASE WHEN N''' + @WareHouseID + ''' = ''%'' THEN AT1303.IsTemp ELSE 0 END = 0) 
					AND AT2008.WareHouseID LIKE N''' + @WareHouseID + ''' 
					AND TranMonth + TranYear * 100 = ' + STR(@FromMonth) + ' + 100 * ' + STR(@FromYear) + ' 
            GROUP BY AT2008.DivisionID,AT2008.InventoryID, AT1302.InventoryName, AT1302.UnitID, AT1304.UnitName
        '

        IF @WareHouseID <> '%'
            SET @sSQL = @sSQL + N', AT2008.WareHouseID, AT1303.WareHouseName '
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
                GROUP BY DivisionID, InventoryID, InventoryName, UnitID, UnitName, WareHouseID, WareHouseName
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
                GROUP BY DivisionID, InventoryID, InventoryName, UnitID, UnitName 
                ---Having SUM(SignQuantity) <> 0 OR SUM(SignAmount) <> 0 
            '
    END
    
IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	IF @IsDate = 0 --- Theo ky
    BEGIN 
        SET @Ssql = N'
            SELECT	AT2008.DivisionID,' + @WareHouseID2 + ' AS WareHouseID, 
					' + @WareHouseName + ' AS WareHouseName, 
					AT2008.InventoryID, 
					AT1302.InventoryName, 
					AT1302.UnitID, 
					AT1304.UnitName, 
					SUM(BeginQuantity) AS BeginQuantity, 
					SUM(EndQuantity) AS EndQuantity, 
					SUM(BeginAmount) AS BeginAmount, 
					SUM(EndAmount) AS EndAmount,
					AT2008.S01ID, AT2008.S02ID, AT2008.S03ID, AT2008.S04ID, AT2008.S05ID, AT2008.S06ID, AT2008.S07ID, AT2008.S08ID, AT2008.S09ID, AT2008.S10ID,
					AT2008.S11ID, AT2008.S12ID, AT2008.S13ID, AT2008.S14ID, AT2008.S15ID, AT2008.S16ID, AT2008.S17ID, AT2008.S18ID, AT2008.S19ID, AT2008.S20ID
            FROM	AT2008_QC AT2008 
            INNER JOIN AT1302 ON AT1302.InventoryID = AT2008.InventoryID and  AT1302.DivisionID = AT2008.DivisionID
            INNER JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID and  AT1304.DivisionID = AT2008.DivisionID
            INNER JOIN AT1303 ON AT1303.WareHouseID = AT2008.WareHouseID  and  AT1303.DivisionID = AT2008.DivisionID
            WHERE AT2008.DivisionID = N''' + @DivisionID + ''' 
					AND AT2008.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
					AND (CASE WHEN N''' + @WareHouseID + ''' = ''%'' THEN AT1303.IsTemp ELSE 0 END = 0) 
					AND AT2008.WareHouseID LIKE N''' + @WareHouseID + ''' 
					AND TranMonth + TranYear * 100 = ' + STR(@FromMonth) + ' + 100 * ' + STR(@FromYear) + ' 
            GROUP BY AT2008.DivisionID,AT2008.InventoryID, AT1302.InventoryName, AT1302.UnitID, AT1304.UnitName,
					AT2008.S01ID, AT2008.S02ID, AT2008.S03ID, AT2008.S04ID, AT2008.S05ID, AT2008.S06ID, AT2008.S07ID, AT2008.S08ID, AT2008.S09ID, AT2008.S10ID,
					AT2008.S11ID, AT2008.S12ID, AT2008.S13ID, AT2008.S14ID, AT2008.S15ID, AT2008.S16ID, AT2008.S17ID, AT2008.S18ID, AT2008.S19ID, AT2008.S20ID
        '

        IF @WareHouseID <> '%'
            SET @sSQL = @sSQL + N', AT2008.WareHouseID, AT1303.WareHouseName '
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
						SUM(SignQuantity) AS BeginQuantity, 
						SUM(SignAmount) AS BeginAmount, 
						0 AS EndQuantity, 
						0 AS EndAmount,
						AV7002.S01ID, AV7002.S02ID, AV7002.S03ID, AV7002.S04ID, AV7002.S05ID, AV7002.S06ID, AV7002.S07ID, AV7002.S08ID, AV7002.S09ID, AV7002.S10ID,
						AV7002.S11ID, AV7002.S12ID, AV7002.S13ID, AV7002.S14ID, AV7002.S15ID, AV7002.S16ID, AV7002.S17ID, AV7002.S18ID, AV7002.S19ID, AV7002.S20ID
						
                FROM	AV7002
                WHERE	DivisionID LIKE N''' + @DivisionID + ''' 
						AND ((D_C in (''D'', ''C'') AND CONVERT(DATETIME, CONVERT(VARCHAR(10), VoucherDate, 101), 101) < ''' + Convert(NVARCHAR(10), @FromDate, 101) + ''') 
								OR D_C = ''BD'') 
						AND WareHouseID LIKE N''' + @WareHouseID + ''' 
						AND InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
                GROUP BY DivisionID, InventoryID, InventoryName, UnitID, UnitName, WareHouseID, WareHouseName,
						AV7002.S01ID, AV7002.S02ID, AV7002.S03ID, AV7002.S04ID, AV7002.S05ID, AV7002.S06ID, AV7002.S07ID, AV7002.S08ID, AV7002.S09ID, AV7002.S10ID,
						AV7002.S11ID, AV7002.S12ID, AV7002.S13ID, AV7002.S14ID, AV7002.S15ID, AV7002.S16ID, AV7002.S17ID, AV7002.S18ID, AV7002.S19ID, AV7002.S20ID
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
						SUM(SignQuantity) AS BeginQuantity, 
						SUM(SignAmount) AS BeginAmount, 
						0 AS EndQuantity, 
						0 AS EndAmount,
						AV7002.S01ID, AV7002.S02ID, AV7002.S03ID, AV7002.S04ID, AV7002.S05ID, AV7002.S06ID, AV7002.S07ID, AV7002.S08ID, AV7002.S09ID, AV7002.S10ID,
						AV7002.S11ID, AV7002.S12ID, AV7002.S13ID, AV7002.S14ID, AV7002.S15ID, AV7002.S16ID, AV7002.S17ID, AV7002.S18ID, AV7002.S19ID, AV7002.S20ID
                FROM	AV7002
                WHERE	DivisionID LIKE N''' + @DivisionID + ''' 
						AND ((D_C in (''D'', ''C'') 
								AND CONVERT(DATETIME, CONVERT(VARCHAR(10), VoucherDate, 101), 101) < ''' + CONVERT(NVARCHAR(10), @FromDate, 101) + ''') 
								OR D_C = ''BD'') 
						AND WareHouseID LIKE N''' + @WareHouseID + ''' 
						AND InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
                GROUP BY DivisionID, InventoryID, InventoryName, UnitID, UnitName,
						AV7002.S01ID, AV7002.S02ID, AV7002.S03ID, AV7002.S04ID, AV7002.S05ID, AV7002.S06ID, AV7002.S07ID, AV7002.S08ID, AV7002.S09ID, AV7002.S10ID,
						AV7002.S11ID, AV7002.S12ID, AV7002.S13ID, AV7002.S14ID, AV7002.S15ID, AV7002.S16ID, AV7002.S17ID, AV7002.S18ID, AV7002.S19ID, AV7002.S20ID 
                ---Having SUM(SignQuantity) <> 0 OR SUM(SignAmount) <> 0 
            '
    END
END
ELSE
	BEGIN
		IF @IsDate = 0 --- Theo ky
		BEGIN 
			SET @Ssql = N'
            SELECT	AT2008.DivisionID,' + @WareHouseID2 + ' AS WareHouseID, 
					' + @WareHouseName + ' AS WareHouseName, 
					AT2008.InventoryID, 
					AT1302.InventoryName, 
					AT1302.UnitID, 
					AT1304.UnitName, 
					SUM(BeginQuantity) AS BeginQuantity, 
					SUM(EndQuantity) AS EndQuantity, 
					SUM(BeginAmount) AS BeginAmount, 
					SUM(EndAmount) AS EndAmount
            FROM	AT2008 
            INNER JOIN AT1302 ON AT1302.InventoryID = AT2008.InventoryID and  AT1302.DivisionID = AT2008.DivisionID
            INNER JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID and  AT1304.DivisionID = AT2008.DivisionID
            INNER JOIN AT1303 ON AT1303.WareHouseID = AT2008.WareHouseID  and  AT1303.DivisionID = AT2008.DivisionID
            WHERE AT2008.DivisionID = N''' + @DivisionID + ''' 
					AND AT2008.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
					AND (CASE WHEN N''' + @WareHouseID + ''' = ''%'' THEN AT1303.IsTemp ELSE 0 END = 0) 
					AND AT2008.WareHouseID LIKE N''' + @WareHouseID + ''' 
					AND TranMonth + TranYear * 100 = ' + STR(@FromMonth) + ' + 100 * ' + STR(@FromYear) + ' 
            GROUP BY AT2008.DivisionID,AT2008.InventoryID, AT1302.InventoryName, AT1302.UnitID, AT1304.UnitName
        '

        IF @WareHouseID <> '%'
            SET @sSQL = @sSQL + N', AT2008.WareHouseID, AT1303.WareHouseName '
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
                GROUP BY DivisionID, InventoryID, InventoryName, UnitID, UnitName, WareHouseID, WareHouseName
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
                GROUP BY DivisionID, InventoryID, InventoryName, UnitID, UnitName 
                ---Having SUM(SignQuantity) <> 0 OR SUM(SignAmount) <> 0 
            '
		END
 
	END     
    
--PRINT @sSQL    
IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV7015')
    EXEC('CREATE VIEW AV7015 	--CREATED BY AP7015
    AS ' + @sSQL)
ELSE
    EXEC('ALTER VIEW AV7015 	--CREATED BY AP7015
    AS ' + @sSQL)
---- Lay so phat sinh



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

