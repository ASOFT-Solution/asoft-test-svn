/****** Object:  StoredProcedure [dbo].[AP7025]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Created BY Nguyen Thi Ngoc Minh, Date 25/10/2004
--Purpose: In bao cao xuat kho theo bo

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7025] 
    @DivisionID NVARCHAR(50), 
    @FromMonth INT, 
    @ToMonth INT, 
    @FromYear INT, 
    @ToYear INT, 
    @FromDate DATETIME, 
    @ToDate DATETIME, 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @WareHouseID NVARCHAR(50), 
    @FromApportionID NVARCHAR(50), 
    @ToApportionID NVARCHAR(50), 
    @IsMaterial TINYINT, 
    @IsDetail TINYINT, 
    @IsDate TINYINT 
AS

DECLARE 
    @sSQL AS NVARCHAR(4000), 
    @sSELECT AS NVARCHAR(4000), 
    @sGROUPBY AS NVARCHAR(4000), 
    @sFROM AS NVARCHAR(4000), 
    @sWHERE AS NVARCHAR(4000), 
    @AT7025_Cur AS CURSOR, 
    @VoucherID AS NVARCHAR(50), 
    @ProductID AS NVARCHAR(50), 
    @MaterialID AS NVARCHAR(50), 
    @Quantity AS DECIMAL(28, 8), 
    @VoucherDate AS DATETIME, 
    @EndQuantity AS DECIMAL(28, 8)

SET @sSELECT = ''
SET @sGROUPBY = ''
SET @sFROM = ''
SET @sWHERE = ''

EXEC AP7016 @DivisionID, @WareHouseID, @WareHouseID, '%', '%', '%', @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate, @IsDate, 1

IF @IsDate = 0
    SET @sWHERE = @sWHERE + ' AND (T27.TranMonth + T27.TranYear * 100  BETWEEN ' + LTRIM(str(@FromMonth + @FromYear * 100)) + ' AND ' + LTRIM(str(@ToMonth + @ToYear * 100)) + ') '
ELSE
    SET @sWHERE = @sWHERE + ' AND (T26.VoucherDate BETWEEN ''' + CONVERT(NVARCHAR(10), @FromDate, 101) + ''' AND ''' + CONVERT(NVARCHAR(10), @ToDate, 101) + ''')'

IF @IsMaterial = 1    ---- Chi tiet theo tung linh kien trong bo
    BEGIN
        SET @sSELECT = @sSELECT + '
            M03.MaterialID, T22.InventoryName AS MaterialName, 
            CASE 
                WHEN M03.QuantityUnit IS NULL THEN ISNULL(T27.ActualQuantity, 0) 
                ELSE ISNULL(T27.ActualQuantity, 0) * ISNULL(M03.QuantityUnit, 1) 
            END AS Quantity, 
        '
        
        SET @sGROUPBY = @sGROUPBY + ' M03.MaterialID, T22.InventoryName, M03.QuantityUnit, '
        
        SET @sFROM = @sFROM + '
            LEFT JOIN MT1603 M03 ON (M03.ApportionID = T27.ApportionID AND M03.DivisionID = T27.DivisionID and M03.ProductID = T27.InventoryID)
            LEFT JOIN AT1302 T22 ON T22.InventoryID = M03.MaterialID and T22.DivisionID = M03.DivisionID
        '
        
        SET @sWHERE = @sWHERE + ' AND T26.WareHouseID LIKE ''' + @WareHouseID + ''' '
    END
ELSE
    SET @sSELECT = @sSELECT + ' SUM(ISNULL(T27.ActualQuantity, 0)) AS Quantity, '

IF @IsDetail = 1         --- Chi tiet theo tung chung tu
    BEGIN
        SET @sSELECT = @sSELECT + ' T26.VoucherNo, T26.VoucherDate, T26.Description, '
            
        SET @sGROUPBY = @sGROUPBY + ' T26.VoucherNo, T26.VoucherDate, T26.Description, T27.TransactionID, '
    END

SET @sSQL = '
        SELECT T27.DivisionID, T27.VoucherID, T27.InventoryID AS ProductID, T02.InventoryName AS ProductName, 
            ''' + @WareHouseID + ''' AS WareHouseID, 
            (CASE WHEN ''' + @WareHouseID + ''' = ''%'' THEN ''Taát caû kho haøng'' ELSE T03.WareHouseName END) AS WareHouseName, 
            T27.UnitID, T04.UnitName, 
            ' + @sSELECT + ' 
            T27.Ana01ID, T27.Ana02ID, T27.Ana03ID, T27.ApportionID, M02.Description AS ApportionName, T27.Orders
        FROM AT2027 T27 INNER JOIN AT2026 T26 ON T26.VoucherID = T27.VoucherID and T26.DivisionID = T27.DivisionID
            LEFT JOIN AT1302 T02 ON T02.InventoryID = T27.InventoryID AND T02.DivisionID = T27.DivisionID
            LEFT JOIN AT1303 T03 ON T03.WareHouseID = ''' + @WareHouseID + ''' AND T03.DivisionID = T27.DivisionID
            LEFT JOIN AT1304 T04 ON T04.UnitID = ISNULL(T27.UnitID, T02.UnitID) AND T04.DivisionID = T27.DivisionID
            LEFT JOIN MT1602 M02 ON M02.ApportionID = T27.ApportionID AND M02.DivisionID = T27.DivisionID
            ' + @sFROM + '
        WHERE T27.DivisionID = ''' + @DivisionID + '''' + @sWHERE + ' 
            AND (T27.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''') 
            AND (T27.ApportionID BETWEEN ''' + @FromApportionID + ''' AND ''' + @ToApportionID + ''') 
        GROUP BY T27.DivisionID, T27.InventoryID, T02.InventoryName, T26.WareHouseID, T27.UnitID, T04.UnitName, 
            ' + @sGROUPBY + '
            T27.Ana01ID, T27.Ana02ID, T27.Ana03ID, T27.ApportionID, M02.Description, 
            T27.ActualQuantity, T03.WareHouseName, T27.Orders, T27.VoucherID
    '

--print @sSQL

IF NOT EXISTS (SELECT 1 FROM  sysObjects WHERE Xtype = 'V' AND Name = 'AV7025')
    EXEC('--created BY AP7025
        CREATE VIEW AV7025 AS ' + @sSQL)
ELSE
    EXEC('--created BY AP7025
        ALTER VIEW AV7025 AS ' + @sSQL)

IF NOT EXISTS (SELECT TOP 1 1  FROM SysObjects WHERE Name = 'AT7025' AND Xtype = 'U')
CREATE TABLE [dbo].[AT7025] (
	[DivisionID] [NVARCHAR] (50) NOT NULL,
    [VoucherID] [NVARCHAR] (50) NULL, 
    [Orders] [NVARCHAR] (50) NULL, 
    [VoucherNo] [NVARCHAR] (50) NULL, 
    [VoucherDate] [DATETIME] NULL, 
    [Description] [NVARCHAR] (250) NULL, 
    [ProductID] [NVARCHAR] (50) NULL, 
    [ProductName] [NVARCHAR] (250) NULL, 
    [WareHouseID] [NVARCHAR] (50) NULL, 
    [WareHouseName] [NVARCHAR] (250) NULL, 
    [UnitID] [NVARCHAR] (50) NULL, 
    [UnitName] [NVARCHAR] (250) NULL, 
    [MaterialID] [NVARCHAR] (50) NULL, 
    [MaterialName] [NVARCHAR] (250) NULL, 
    [Quantity] [DECIMAL](28, 8) NULL, 
    [EndQuantity] [DECIMAL](28, 8) NULL, 
    [Ana01ID] [NVARCHAR] (50) NULL, 
    [Ana02ID] [NVARCHAR] (50) NULL, 
    [Ana03ID] [NVARCHAR] (50) NULL, 
    [ApportionID] [NVARCHAR] (50) NULL, 
    [ApportionName] [NVARCHAR] (250) NULL
) ON [PRIMARY]
ELSE
    DELETE  AT7025
    
IF @IsDetail = 1 AND @IsMaterial = 1 
    BEGIN
        EXEC('INSERT INTO AT7025 (DivisionID, VoucherID, Orders, VoucherNo, VoucherDate, Description, ProductID, ProductName, WareHouseID, WareHouseName, UnitID, UnitName, MaterialID, MaterialName, Quantity, Ana01ID, Ana02ID, Ana03ID, ApportionID, ApportionName)
              SELECT DivisionID, VoucherID, Orders, VoucherNo, VoucherDate, Description, ProductID, ProductName, WareHouseID, WareHouseName, UnitID, UnitName, MaterialID, MaterialName, Quantity, Ana01ID, Ana02ID, Ana03ID, ApportionID, ApportionName 
              FROM AV7025 ORDER BY VoucherDate, VoucherID, Orders, MaterialID')
              
        SET @AT7025_Cur = CURSOR SCROLL KEYSET FOR
            SELECT VoucherID, ProductID, MaterialID, Quantity, VoucherDate
            FROM AT7025 WHERE MaterialID IS NOT NULL AND DivisionID = @DivisionID

        OPEN @AT7025_Cur
        FETCH NEXT FROM @AT7025_Cur INTO @VoucherID, @ProductID, @MaterialID, @Quantity, @VoucherDate

        WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @EndQuantity = (SELECT SUM(CASE WHEN V70.D_C in ('C', 'BC') THEN -ISNULL(V70.ActualQuantity, 0) ELSE ISNULL(V70.ActualQuantity, 0) END)
                FROM AV7000 V70
                WHERE V70.InventoryID = @MaterialID 
                    AND (V70.VoucherDate <@VoucherDate OR (V70.VoucherDate = @VoucherDate AND V70.VoucherID < = @VoucherID))AND DivisionID = @DivisionID)
                    
                UPDATE AT7025 
                SET EndQuantity = @EndQuantity
                WHERE ProductID = @ProductID 
                    AND MaterialID = @MaterialID 
                    AND VoucherDate = @VoucherDate 
                    AND VoucherID = @VoucherID 
                    AND Quantity = @Quantity
                    AND DivisionID = @DivisionID

                FETCH NEXT FROM @AT7025_Cur INTO @VoucherID, @ProductID, @MaterialID, @Quantity, @VoucherDate 
            END

        CLOSE @AT7025_Cur
    END

IF @IsMaterial = 1 AND @IsDetail = 0
    BEGIN
        EXEC ('INSERT INTO AT7025 (DivisionID, ProductID, ProductName, WareHouseID, WareHouseName, UnitID, UnitName, MaterialID, MaterialName, Quantity, Ana01ID, Ana02ID, Ana03ID, ApportionID, ApportionName)
               SELECT DivisionID, ProductID, ProductName, WareHouseID, WareHouseName, UnitID, UnitName, MaterialID, MaterialName, Quantity, Ana01ID, Ana02ID, Ana03ID, ApportionID, ApportionName
               FROM AV7025 ORDER BY ProductID, ApportionID, MaterialID')

        SET @AT7025_Cur = CURSOR SCROLL KEYSET FOR
            SELECT ProductID, MaterialID
            FROM AT7025
            WHERE MaterialID IS NOT NULL AND DivisionID = @DivisionID

        OPEN @AT7025_Cur
        FETCH NEXT FROM @AT7025_Cur INTO @ProductID, @MaterialID

        WHILE @@FETCH_STATUS = 0
            BEGIN
                IF @IsDate = 1
                    SET @EndQuantity = (SELECT SUM(CASE WHEN V70.D_C in ('C', 'BC') THEN -ISNULL(V70.ActualQuantity, 0) ELSE ISNULL(V70.ActualQuantity, 0) END)
                    FROM AV7000 V70
                    WHERE V70.InventoryID = @MaterialID 
                        AND V70.VoucherDate < = @ToDate AND DivisionID = @DivisionID)
                ELSE 
                    SET @EndQuantity = (SELECT SUM(CASE WHEN V70.D_C in ('C', 'BC') THEN -ISNULL(V70.ActualQuantity, 0) ELSE ISNULL(V70.ActualQuantity, 0) END)
                    FROM AV7000 V70
                    WHERE V70.InventoryID = @MaterialID 
                        AND V70.TranMonth + V70.TranYear * 100 < = @ToMonth + @ToYear * 100 AND DivisionID = @DivisionID)

                UPDATE AT7025 
                SET EndQuantity = @EndQuantity
                WHERE ProductID = @ProductID 
                    AND MaterialID = @MaterialID 
                    AND DivisionID = @DivisionID

                FETCH NEXT FROM @AT7025_Cur INTO @ProductID, @MaterialID
            END

        CLOSE @AT7025_Cur
    END
    
IF  @IsMaterial = 0 AND @IsDetail = 1
    EXEC('INSERT INTO AT7025 (DivisionID, VoucherID, Orders, VoucherNo, VoucherDate, Description, ProductID, ProductName, WareHouseID, WareHouseName, UnitID, UnitName, Quantity, Ana01ID, Ana02ID, Ana03ID, ApportionID, ApportionName)
          SELECT DivisionID, VoucherID, Orders, VoucherNo, VoucherDate, Description, ProductID, ProductName, WareHouseID, WareHouseName, UnitID, UnitName, Quantity, Ana01ID, Ana02ID, Ana03ID, ApportionID, ApportionName
          FROM AV7025 ORDER BY VoucherDate, VoucherID, Orders')
ELSE
    EXEC ('INSERT INTO AT7025 (DivisionID, ProductID, ProductName, WareHouseID, WareHouseName, UnitID, UnitName, Quantity, Ana01ID, Ana02ID, Ana03ID, ApportionID, ApportionName)
           SELECT DivisionID, ProductID, ProductName, WareHouseID, WareHouseName, UnitID, UnitName, Quantity, Ana01ID, Ana02ID, Ana03ID, ApportionID, ApportionName
           FROM AV7025 ORDER BY ProductID, ApportionID')
GO
