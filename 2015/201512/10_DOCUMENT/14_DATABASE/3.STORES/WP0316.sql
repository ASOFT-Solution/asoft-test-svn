/****** Object:  StoredProcedure [dbo].[WP0316]    Script Date: 08/03/2010 15:02:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

 ---- Created by Nguyen Quoc Huy
 ---- Date 11/09/2008.
 ---- purpose: IN bao cao phan tich tuoi hang ton kho

/********************************************
'* Edited by: [GS] [Việt Khánh] [04/08/2010]
'********************************************/
--- Edited by Bao Anh	Date: 11/07/2012
--- Purpose: Sua loi bao cao khong len du lieu (do truong MonthYear hien thi sai)

ALTER PROCEDURE [dbo].[WP0316] 
    @DivisionID NVARCHAR(50), 
    @ReportCode NVARCHAR(50), 
    @FromWareHouseID NVARCHAR(50), 
    @ToWareHouseID NVARCHAR(50), 
    @Filter1IDFrom NVARCHAR(50), 
    @Filter1IDTo NVARCHAR(50), 
    @Filter2IDFrom NVARCHAR(50), 
    @Filter2IDTo NVARCHAR(50), 
    @Filter3IDFrom NVARCHAR(50), 
    @Filter3IDTo NVARCHAR(50), 
    @ReportDate DATETIME, 
    @IsBefore TINYINT
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @sSQL1 NVARCHAR(4000), 
    @FromPeriod INT, 
    @ToPeriod INT, 
    @SQLwhere NVARCHAR(4000), 
    @sSELECT NVARCHAR(4000), 
    @sSELECT1 NVARCHAR(4000), 
    @sFROM NVARCHAR(4000), 
    @sWHERE NVARCHAR(4000), 
    @sGROUPBY NVARCHAR(4000), 
    @sGROUPBY1 NVARCHAR(4000), 
    @DateType NVARCHAR(50), 
    @IsDetail TINYINT, 
    @GetColumnTitle TINYINT, 
    @AgeStepID NVARCHAR(50), 
    @ReportName1 NVARCHAR(250), 
    @ReportName2 NVARCHAR(250), 
    @GroupName1 NVARCHAR(250), 
    @GroupName2 NVARCHAR(250), 
    @GroupName3 NVARCHAR(250), 
    @Group1ID NVARCHAR(50), 
    @Group2ID NVARCHAR(50), 
    @Group3ID NVARCHAR(50), 
    @Field1ID NVARCHAR(50), 
    @Field2ID NVARCHAR(50), 
    @Field3ID NVARCHAR(50), 
    @Filter1 NVARCHAR(50), 
    @Filter2 NVARCHAR(50), 
    @Filter3 NVARCHAR(50), 
    @AT1317Cursor CURSOR, 
    @Description NVARCHAR(250), 
    @Orders TINYINT, 
    @FromDay INT, 
    @ToDay INT, 
    @Title NVARCHAR(250), 
    @ColumnCount INT, 
    @MaxDate INT, 
    @TableTemp NVARCHAR(50), 
    @Voucher NVARCHAR(50), 
    @Selection01ID NVARCHAR(50), 
    @Selection02ID NVARCHAR(50), 
    @Selection03ID NVARCHAR(50), 
    @SelectionName1 NVARCHAR(50), 
    @SelectionName2 NVARCHAR(50), 
    @SelectionName3 NVARCHAR(50),
    @ReportDateText NVARCHAR(10)

SET @sWHERE = ''
SET @sSELECT = ''
SET @sSELECT1 = ''
SET @sGROUPBY = ''
SET @sGROUPBY1 = ''
SET @sFROM = ''
SET @Voucher = ''

SET @ReportDateText = CONVERT(NVARCHAR(10), @ReportDate, 101)

 -------------------------- Lay thong tin thiet lap bao cao tu bang WT4710 ----------------------------- 
SELECT @ReportName1 = REPLACE(ReportName1, '''', ''''''), 
    @ReportName2 = REPLACE(ReportName2, '''', ''''''), 
    @DateType = (CASE DateType WHEN 0 THEN 'VoucherDate'
                               WHEN 1 THEN 'LimitDate' END),
    @IsDetail = IsDetail, 
    @GetColumnTitle = GetColumnTitle, 
    @AgeStepID = REPLACE(AgeStepID, '''', ''''''), 
    @Group1ID = ISNULL(Group1ID, ''), 
    @Group2ID = ISNULL(Group2ID, ''), 
    @Group3ID = ISNULL(Group3ID, ''), 
    @Selection01ID = ISNULL(Selection01ID, ''), 
    @Selection02ID = ISNULL(Selection02ID, ''), 
    @Selection03ID = ISNULL(Selection03ID, '')        
FROM WT4710
WHERE ReportCode = @ReportCode 

 ------------------------ Tao view lay so luong hang con ton kho ---------------------------- 
SET @sSQL = ' 
SELECT 
ISNULL(AT2006.VoucherTypeID, AT2016.VoucherTypeID) VoucherTypeID,
AT0114.InventoryID, 
AT1302.S1 AS CI1ID, 
AT1302.S2 AS CI2ID, 
AT1302.S3 AS CI3ID, 
AT1302.I01ID, 
AT1302.I02ID, 
AT1302.I03ID, 
AT1302.I04ID, 
AT1302.I05ID, 
AT0114.DivisionID, 
AT0114.WareHouseID, 
AT0114.ReVoucherID, 
AT0114.ReTransactionID, 
AT0114.ReVoucherNo, 
AT0114.ReVoucherDate AS VoucherDate, 
AT0114.ReTranMonth,
RIGHT(''00'' + LTRIM(STR(AT0114.ReTranMonth)), 2) + ''/'' + RIGHT(''0000'' + LTRIM(STR(AT0114.ReTranYear)), 4) AS MonthYear,
AT0114.ReTranYear AS Year, 
AT0114.ReSourceNo, 
AT0114.LimitDate, 
AT0114.ReQuantity, 
AT0114.UnitPrice, 
AT0114.DeVoucherID, 
AT0114.DeTransactionID, 
AT0114.DeVoucherNo, 
AT0114.DeVoucherDate, 
AT0114.DeLocationNo, 
AT0114.DeQuantity, 
AT0114.EndQuantity
FROM AT0114 
LEFT JOIN AT1302 ON AT1302.DivisionID = AT0114.DivisionID AND AT1302.InventoryID = AT0114.InventoryID
LEFT JOIN AT2006 ON AT2006.DivisionID = AT0114.DivisionID AND AT2006.VoucherNo = AT0114.ReVoucherNo
LEFT JOIN AT2016 ON AT2016.DivisionID = AT0114.DivisionID AND AT2016.VoucherNo = AT0114.ReVoucherNo
WHERE AT0114.DivisionID = ''' + @DivisionID + ''' 
AND (AT0114.WareHouseID BETWEEN ''' + @FromWareHouseID + ''' AND ''' + @ToWareHouseID + ''') 
'

IF NOT EXISTS (SELECT name FROM sysobjects WHERE id = Object_id(N'[dbo].[WV0317]') AND OBJECTPROPERTY(id, N'IsView') = 1)
    EXEC('CREATE VIEW WV0317 -- Tạo bởi WP0316
AS ' + @sSQL)
 ELSE
    EXEC('ALTER VIEW WV0317 -- Tạo bởi WP0316
AS ' + @sSQL)

 ------------------------- Xu ly nhom du lieu ----------------------------- 
IF @Group1ID != ''
    BEGIN
        EXEC AP4700  @Group1ID, @GroupName1 OUTPUT
        SET @sSELECT1 = @sSELECT1 + '
WV0317.' + @GroupName1 + ' AS Group1,
V1.SelectionName AS Group1Name, '
        SET @sFROM = @sFROM + ' 
LEFT JOIN AV6666 V1 ON V1.SelectionType = ''' + @Group1ID + ''' AND V1.SelectionID = WV0317.' + @GroupName1
        SET @sGROUPBY = @sGROUPBY + ', 
WV0317.' + @GroupName1 + ', 
V1.SelectionName '
        SET @sGROUPBY1 = @sGROUPBY1 + ', 
WV0317.Group1, Group1Name'   
    END


IF @Group2ID != ''
    BEGIN
        EXEC AP4700  @Group2ID, @GroupName2 OUTPUT
        SET @sSELECT1 = @sSELECT1 + ' 
WV0317.' + @GroupName2 + ' AS Group2, 
V2.SelectionName AS Group2Name, '
        SET @sFROM = @sFROM + ' 
LEFT JOIN AV6666 V2 ON V2.SelectionType = ''' + @Group2ID + ''' AND V2.SelectionID = WV0317.' + @GroupName2
        SET @sGROUPBY = @sGROUPBY + ', 
WV0317.' + @GroupName2 + ', 
V2.SelectionName ' 
        SET @sGROUPBY1 = @sGROUPBY1 + ', 
WV0317.Group2, 
Group2Name'
    END

IF @Group3ID != ''
    BEGIN
        EXEC AP4700  @Group3ID, @GroupName3 OUTPUT
        SET @sSELECT1 = @sSELECT1 + ' 
WV0317.' + @GroupName3 + ' AS Group3, 
V3.SelectionName AS Group3Name, '
        SET @sFROM = @sFROM + ' 
LEFT JOIN AV6666 V3 ON V3.SelectionType = ''' + @Group3ID + ''' AND V3.SelectionID = WV0317.' + @GroupName3
        SET @sGROUPBY = @sGROUPBY + ', 
WV0317.' + @GroupName3 + ', 
V3.SelectionName '   
        SET @sGROUPBY1 = @sGROUPBY1 + ', 
WV0317.Group3, 
Group3Name'
    END

 -------------------------------- Xu ly loc du lieu ----------------------------------------- 
IF @Selection01ID != ''
    BEGIN
        EXEC AP4700  @Selection01ID, @SelectionName1  OUTPUT
        SET @sWHERE = @sWHERE + '
AND (WV0317.' + @SelectionName1 + ' BETWEEN ''' + @Filter1IDFrom + ''' AND ''' + @Filter1IDTo + ''') '
    END
    
IF @Selection02ID != ''
    BEGIN
        EXEC AP4700  @Selection02ID, @SelectionName2  OUTPUT
        SET @sWHERE = @sWHERE + '
AND (WV0317.' + @SelectionName2 + ' BETWEEN ''' + @Filter2IDFrom + ''' AND ''' + @Filter2IDTo + ''') '
    END

IF @Selection03ID != ''
    BEGIN
        EXEC AP4700  @Selection03ID, @SelectionName3  OUTPUT
        SET @sWHERE = @sWHERE + '
AND (WV0317.' + @SelectionName3 + ' BETWEEN ''' + @Filter3IDFrom + ''' AND ''' + @Filter3IDTo + ''') '
    END
    
 --------------------------------- Xu ly lay du lieu tu moc tro ve truoc hay tro ve sau -------------------------------------- 
SET @MaxDate = 
CASE 
    WHEN ISNULL((SELECT ToDay 
                 FROM AT1317 
                 WHERE REPLACE(AgeStepID, '''', '''''') = @AgeStepID 
                    AND Orders = (SELECT MAX(Orders)
                                  FROM AT1317 
                                  WHERE REPLACE(AgeStepID, '''', '''''') = @AgeStepID 
                                      AND DivisionID = @DivisionID)), 0) <> - 1 
        THEN ISNULL((SELECT ToDay
                     FROM AT1317
                     WHERE REPLACE(AgeStepID, '''', '''''') = @AgeStepID 
                        AND Orders = (SELECT MAX(Orders)
                                      FROM AT1317
                                      WHERE REPLACE(AgeStepID, '''', '''''') = @AgeStepID 
                                        AND DivisionID = @DivisionID)), 0)
    ELSE 10000 
END

IF @MaxDate > 10000 SET @MaxDate = 10000

IF @IsBefore = 0
	BEGIN
		SET @sWHERE = @sWHERE + ' 
AND WV0317.' + @DateType + ' >= ''' + @ReportDateText + ''''
		IF @MaxDate <> 0
			SET @sWHERE = @sWHERE + ' AND WV0317.' + @DateType + ' <= ''' + CONVERT(NVARCHAR(10), @ReportDate + @MaxDate, 101) + ''''
	END
ELSE
	BEGIN
		SET @sWHERE = @sWHERE + '
AND WV0317.' + @DateType + ' <= ''' + @ReportDateText + ''''
			IF @MaxDate <> 0
				SET @sWHERE = @sWHERE + ' AND WV0317.' + @DateType + ' >= ''' + CONVERT(NVARCHAR(10), @ReportDate - @MaxDate, 101) + ''''
	END


 ---------------------------- Xu ly lay chi tiet chung tu hay tong hop theo doi tuong -------------------------------- 

IF @IsDetail = 1
	BEGIN
		SET @sSELECT1 = @sSELECT1 + ' 
WV0317.VoucherDate, 
WV0317.ReVoucherNo, 
DATEDIFF(DAY, WV0317.' + @DateType + ', ''' + @ReportDateText + ''') AS Days, 
WV0317.InventoryID, 
WV0317.WareHouseID, 
WV0317.MonthYear,                                                                 
WV0317.Year, 
WV0317.ReSourceNo, 
WV0317.LimitDate, 
WV0317.ReQuantity, 
WV0317.UnitPrice, 
WV0317.DeQuantity, 
WV0317.EndQuantity, 
WV0317.ReVoucherID, WV0317.ReTransactionID, '
		SET @sGROUPBY = @sGROUPBY + ', 
WV0317.DivisionID, 
WV0317.VoucherDate, 
WV0317.ReVoucherNo, 
WV0317.InventoryID, 
WV0317.WareHouseID, 
WV0317.MonthYear, 
WV0317.Year, 
WV0317.ReSourceNo, 
WV0317.LimitDate, 
WV0317.ReQuantity, 
WV0317.UnitPrice, 
WV0317.DeQuantity, 
WV0317.EndQuantity, 
WV0317.ReVoucherID, 
WV0317.ReTransactionID
'
	END
ELSE
	BEGIN    
		SET @sSELECT1 = @sSELECT1 + '  0 AS Days, WV0317.InventoryID, WV0317.WareHouseID, '
		SET @sGROUPBY = @sGROUPBY + ', WV0317.InventoryID, WV0317.WareHouseID '
	END

 ------------------------ Lay du lieu --------------------------- 
SET @ColumnCount = (SELECT Count(Orders) FROM AT1317  WHERE REPLACE(AgeStepID, '''', '''''') = @AgeStepID AND DivisionID = @DivisionID )

DECLARE @i AS TINYINT
SET @i = @ColumnCount
IF @ColumnCount < 5    
	BEGIN
		WHILE @i < 5
			BEGIN
				SET @i = @i + 1
				SET @sSELECT1 = @sSELECT1 + ' 
'''' AS Title' + LTRIM(STR(@i)) + ', 0 AS EndQuantity' + LTRIM(STR(@i)) + ', '
			END
	END

SET @AT1317Cursor = CURSOR SCROLL KEYSET FOR
	SELECT 
	Description, 
	Orders, 
	FromDay, 
	ToDay, 
	REPLACE(Title, '''', '''''') AS Title
	FROM AT1317 
	WHERE REPLACE(AgeStepID, '''', '''''') = @AgeStepID 
	AND DivisionID = @DivisionID
	ORDER BY Orders
	
DECLARE
@FromDayText NVARCHAR(10),
@ToDayText NVARCHAR(10),
@OrdersText NVARCHAR(10)

OPEN @AT1317Cursor
FETCH NEXT FROM @AT1317Cursor INTO  @Description, @Orders, @FromDay, @ToDay, @Title

WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ToDay > @MaxDate SET @ToDay = @MaxDate

		SET @FromDayText = LTRIM(STR(@FromDay))
		SET @ToDayText = LTRIM(STR(@ToDay))
		SET @OrdersText = LTRIM(STR(@Orders))

		IF @ToDay = - 1
			IF @IsBefore = 0
				SET @sSELECT1 = @sSELECT1 + 
					(CASE WHEN @GetColumnTitle = 0 THEN  ''' >= ' + @FromDayText + ' ngày'' AS Title' + @OrdersText + ', '
						ELSE '''' + LTRIM(RTRIM(@Title)) + ''' AS Title' + @OrdersText + ', ' END) + '
(CASE WHEN (WV0317.' + @DateType + ' - ''' + @ReportDateText + ''' + 1 >= ' + @FromDayText + ') 
THEN SUM(ISNULL(WV0317.EndQuantity, 0)) ELSE 0 END) AS EndQuantity' + @OrdersText + ',
'
			ELSE
				SET @sSELECT1 = @sSELECT1 + 
					(CASE WHEN @GetColumnTitle = 0 THEN  ''' >= ' + @FromDayText + ' ngày'' AS Title' + @OrdersText + ', '
						ELSE '''' + LTRIM(RTRIM(@Title)) + ''' AS Title' + @OrdersText + ', ' END) + '
(CASE WHEN (''' + @ReportDateText + ''' - WV0317.' + @DateType + ' >= ' + @FromDayText + ')
THEN SUM(ISNULL(WV0317.EndQuantity, 0)) ELSE 0 END) AS EndQuantity' + @OrdersText + ',
'
		ELSE IF @IsBefore = 0
			SET @sSELECT1 = @sSELECT1 + 
				(CASE WHEN @GetColumnTitle = 0 THEN  '''' + @FromDayText + ' - ' + @ToDayText + ' ngày'' AS Title' + @OrdersText + ', '
					ELSE '''' + LTRIM(RTRIM(@Title)) + ''' AS Title' + @OrdersText + ', ' END) + '
(CASE WHEN (WV0317.' + @DateType + ' - ''' + @ReportDateText + ''' + 1 >= ' + @FromDayText + ' AND WV0317.' + @DateType + ' - ''' + @ReportDateText + ''' + 1 < ' + @ToDayText + ')
THEN SUM(ISNULL(WV0317.EndQuantity, 0)) ELSE 0 END) AS EndQuantity' + @OrdersText + ', '
		ELSE
			SET @sSELECT1 = @sSELECT1 + 
				(CASE WHEN @GetColumnTitle = 0 THEN  '''' + @FromDayText + ' - ' + @ToDayText + ' ngày'' AS Title' + @OrdersText + ', '
					ELSE '''' + LTRIM(RTRIM(@Title)) + ''' AS Title' + @OrdersText + ', ' END) + '
(CASE WHEN (''' + @ReportDateText + ''' - WV0317.' + @DateType + ' >= ' + @FromDayText + ' AND ''' + @ReportDateText + ''' - WV0317.' + @DateType + ' < ' + @ToDayText + ')
THEN SUM(ISNULL(WV0317.EndQuantity, 0)) ELSE 0 END) AS EndQuantity' + @OrdersText + ', '
    
    FETCH NEXT FROM @AT1317Cursor INTO  @Description, @Orders, @FromDay, @ToDay, @Title

   END
CLOSE @AT1317Cursor
DEALLOCATE @AT1317Cursor  

SET @sSQL = 'SELECT ' + @sSELECT1 + ' WV0317.DivisionID
        
FROM WV0317
    ' + @sFROM + '
WHERE (WV0317.WareHouseID BETWEEN  ''' + @FromWareHouseID + ''' AND ''' + @ToWareHouseID + ''') AND
    WV0317.DivisionID = ''' + @DivisionID + ''''
 + @sWHERE + '
GROUP BY WV0317.DivisionID ' + @sGROUPBY + ', WV0317.' + @DateType + '
'


IF NOT EXISTS (SELECT name FROM sysobjects WHERE id = Object_id(N'[dbo].[WV0318]') AND OBJECTPROPERTY(id, N'IsView') = 1)
	exec('CREATE VIEW WV0318 --- Created by WP0316
AS ' + @sSQL)
ELSE
	exec('ALTER VIEW WV0318 --- Created by WP0316
AS ' + @sSQL)


 ----------------- 
IF @IsDetail = 1
	BEGIN    
		SET @sSQL = '
SELECT 
Days, 
DivisionID, 
VoucherDate, 
ReVoucherNo, 
InventoryID, 
WareHouseID, 
MonthYear, 
Year, 
ReSourceNo, 
LimitDate, 
ReQuantity, 
UnitPrice, 
DeQuantity, 
WV0318.Title1, SUM(WV0318.EndQuantity1) AS EndQuantity1, 
WV0318.Title2, SUM(WV0318.EndQuantity2) AS EndQuantity2, 
WV0318.Title3, SUM(WV0318.EndQuantity3) AS EndQuantity3, 
WV0318.Title4, SUM(WV0318.EndQuantity4) AS EndQuantity4, 
WV0318.Title5, SUM(WV0318.EndQuantity5) AS EndQuantity5
    
FROM WV0318 
WHERE EndQuantity1 + EndQuantity2 + EndQuantity3 + EndQuantity4 + EndQuantity5 <> 0 
GROUP BY Days, DivisionID, VoucherDate, ReVoucherNo, InventoryID, WareHouseID, 
MonthYear, Year, ReSourceNo, LimitDate, ReQuantity, UnitPrice, DeQuantity, 
WV0318.Title1, WV0318.Title2, WV0318.Title3, WV0318.Title4, WV0318.Title5
'
		IF NOT EXISTS (SELECT name FROM sysobjects WHERE id = Object_id(N'[dbo].[WV0316]') AND OBJECTPROPERTY(id, N'IsView') = 1)
			EXEC('CREATE VIEW WV0316 --- created by WP0316, Chi tiet
AS ' + @sSQL)
		ELSE
			EXEC('ALTER VIEW WV0316 --- created by WP0336, Chi tiet
AS ' + @sSQL)
	END
ELSE --- Tong hop
    BEGIN
		SET @sSQL1 = '
SELECT 
Days, 
DivisionID, 
InventoryID, 
WareHouseID, 
WV0318.Title1, SUM(WV0318.EndQuantity1) AS EndQuantity1, 
WV0318.Title2, SUM(WV0318.EndQuantity2) AS EndQuantity2, 
WV0318.Title3, SUM(WV0318.EndQuantity3) AS EndQuantity3, 
WV0318.Title4, SUM(WV0318.EndQuantity4) AS EndQuantity4, 
WV0318.Title5, SUM(WV0318.EndQuantity5) AS EndQuantity5
    
FROM WV0318 
WHERE EndQuantity1 + EndQuantity2 + EndQuantity3 + EndQuantity4 + EndQuantity5 <> 0 
GROUP BY Days, DivisionID, InventoryID, WareHouseID, 
WV0318.Title1, WV0318.Title2, WV0318.Title3, WV0318.Title4, WV0318.Title5
'
		IF NOT EXISTS (SELECT name FROM sysobjects WHERE id = Object_id(N'[dbo].[WV0326]') AND OBJECTPROPERTY(id, N'IsView') = 1)
			EXEC('CREATE VIEW WV0326 --- created by WP0316, Tong hop
AS ' + @sSQL1)
		ELSE
			EXEC('ALTER VIEW WV0326 --- created by WP0336, Tong hop
AS ' + @sSQL1)
	END