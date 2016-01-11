IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP2501]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP2501]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Chi tiet tinh hinh ton kho
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 28/08/2004 by Nguyen Van Nhan
---- 
---- Edited by: Vo Thanh  Huong, date : 11/04/2005
---- Last Edit : NGuyen Thi Thuy Tuyen Date:30/10/2006
---- Edit By : Thuy Tuyen, them cac thong tin loc theo mat hang. theo thoi gian, date 19/05/2010
---- Modified on 18/11/2011 by Le Thi Thu Hien : Chinh sua so ton cuoi ky 
---- Modified on 14/12/2011 by Le Thi Thu Hien : Them dieu kien DivisionID
---- Modified on 03/01/2012 by Nguyễn Bình Minh : Sửa điều kiện kết tại phần mã hàng vì không lấy được tên do không kết đúng Division 
---- Modified on 30/01/2012 by Le Thi Thu Hien : Sua dieu kien CONVERT theo ngay
---- Modified on 09/09/2013 by Le Thi Thu Hien : Số tồn cuối phải lấy theo Đến ngày
---- Modified on 14/07/2014 by Bảo Anh: Bổ sung WarehouseName
-- <Example>
---- 

CREATE PROCEDURE [dbo].[OP2501]
(
    @DivisionID NVARCHAR(50), 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @FromDate DATETIME, 
    @ToDate DATETIME, 
    @IsDate TINYINT, 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @FromWareHouseID NVARCHAR(50), 
    @ToWareHouseID NVARCHAR(50)
)    
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @IsColumn TINYINT, 
    @RowField NVARCHAR(50), 
    @Caption NVARCHAR(150), 
    @AmountType1 NVARCHAR(50), 
    @AmountType2 NVARCHAR(50), 
    @AmountType3 NVARCHAR(50), 
    @AmountType4 NVARCHAR(50), 
    @AmountType5 NVARCHAR(50), 
    @ColumnID NVARCHAR(50), 
    @Sign1 NVARCHAR(50), 
    @Sign2 NVARCHAR(50), 
    @Sign3 NVARCHAR(50), 
    @Sign4 NVARCHAR(50), 
    @Sign5 NVARCHAR(50), 
    @SQL NVARCHAR(4000), 
    @cur CURSOR, 
    @Index TINYINT, 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

SET @sSQL = '
SELECT 
DivisionID, 
InventoryID, 
WareHouseID, 
SUM(CASE WHEN TypeID <> ''PO'' AND Finish <> 1 THEN OrderQuantity - ActualQuantity ELSE 0 END) AS SQuantity, 
SUM(CASE WHEN TypeID = ''PO'' AND Finish <> 1 THEN OrderQuantity - ActualQuantity ELSE 0 END) AS PQuantity
FROM OV2800
WHERE DivisionID = ''' + @DivisionID + ''' 
AND WareHouseID BETWEEN ''' + @FromWareHouseID + ''' AND ''' + @ToWareHouseID + ''' 
AND InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 
' + 
CASE WHEN @IsDate = 1 THEN 'AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),ISNULL(Orderdate, ''''),101),101) BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''''
                      ELSE 'AND TranMonth + TranYear * 100 BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText 
END + 
' GROUP BY DivisionID, InventoryID, WareHouseID
'

IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV2801')
    EXEC('CREATE VIEW OV2801 -- Tạo bởi OP2501
        AS ' + @sSQL)
ELSE 
    EXEC('ALTER VIEW OV2801 -- Tạo bởi OP2501
        AS ' + @sSQL)


SET @sSQL = ' 
SELECT 
ISNULL(V00.DivisionID, V01.DivisionID) AS DivisionID, 
ISNULL(V00.InventoryID, V01.InventoryID) AS InventoryID, 
InventoryName, 
AT1310_S1.SName AS SName1, 
AT1310_S2.SName AS SName2, 
T00.Notes01 AS InNotes01, 
T00.Notes02 AS InNotes02, 
T00.Specification, 
T00.UnitID, UnitName, 
ISNULL(V00.WareHouseID, V01.WareHouseID) AS WareHouseID, 
CASE WHEN EndQuantity = 0 THEN NULL ELSE EndQuantity END AS EndQuantity, 
CASE WHEN SQuantity = 0 THEN NULL ELSE SQuantity END AS SQuantity, 
CASE WHEN PQuantity = 0 THEN NULL ELSE PQuantity END AS PQuantity, 
ISNULL(EndQuantity, 0) - ISNULL(SQuantity, 0) + ISNULL(PQuantity, 0) AS ReadyQuantity, 
CASE WHEN ISNULL(MaxQuantity, 0) = 0 THEN NULL ELSE MaxQuantity END AS MaxQuantity, 
CASE WHEN ISNULL(MinQuantity, 0) = 0 THEN NULL ELSE MinQuantity END AS MinQuantity, 
CASE WHEN ISNULL(ReOrderQuantity, 0) = 0 THEN NULL ELSE ReOrderQuantity END AS ReOrderQuantity, 
T00.InventoryTypeID,
Isnull(T31.WareHouseName, T32.WareHouseName) as WareHouseName
FROM OV2801 V00 
FULL JOIN 
(
    SELECT TOP 100 Percent 
    DivisionID, 
    WareHouseID, 
    InventoryID, 
    SUM(ISNULL(EndQuantity, 0)) AS EndQuantity
    FROM OV2411 
    WHERE DivisionID = ''' + @DivisionID + ''' 
    AND WareHouseID BETWEEN ''' + @FromWareHouseID + ''' AND ''' + @ToWareHouseID + ''' 
    AND InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 
    AND ' + 
    CASE WHEN @IsDate = 1 THEN ' CONVERT(DATETIME,CONVERT(NVARCHAR(10),VoucherDate,101),101) < = ''' + @ToDateText + '''' 
                          ELSE ' TranMonth + TranYear * 100 < = ' + @FromMonthYearText + '' END + '
    GROUP BY DivisionID, WareHouseID, InventoryID
    HAVING SUM(ISNULL(EndQuantity, 0)) <> 0
    ORDER BY DivisionID, WareHouseID, InventoryID 
) V01 -- Lay so ton cuoi
    ON V00.DivisionID = V01.DivisionID AND V00.InventoryID = V01.InventoryID AND V00.WareHouseID = V01.WareHouseID
LEFT JOIN AT1302 T00 ON T00.InventoryID = ISNULL(V00.InventoryID, V01.InventoryID) AND T00.DivisionID = ISNULL(V00.DivisionID, V01.DivisionID)
LEFT JOIN AT1304 T02 ON T02.UnitID = T00.UnitID AND T02.DivisionID = T00.DivisionID
LEFT JOIN AT1314 T01 ON T01.InventoryID = ISNULL(V00.InventoryID, V01.InventoryID) 
        AND ISNULL(V00.WareHouseID, V01.WareHouseID) LIKE T01.WareHouseID AND T01.DivisionID = ISNULL(V00.DivisionID, V01.DivisionID)
LEFT JOIN AT1310 AT1310_S1 ON AT1310_S1.STypeID = ''I01'' AND AT1310_S1.S = T00.S1 
LEFT JOIN AT1310 AT1310_S2 ON AT1310_S2.STypeID = ''I02'' AND AT1310_S2.S = T00.S2
LEFT JOIN AT1303 T31 ON V00.DivisionID = T31.DivisionID AND V00.WareHouseID = T31.WareHouseID
LEFT JOIN AT1303 T32 ON V01.DivisionID = T32.DivisionID AND V01.WareHouseID = T32.WareHouseID

WHERE (ISNULL(EndQuantity, 0) <> 0 OR ISNULL(SQuantity, 0) <> 0 OR PQuantity <> 0) 
AND ISNULL(V00.DivisionID, V01.DivisionID) = ''' + @DivisionID + ''' 
AND ISNULL(V00.WareHouseID, V01.WareHouseID) BETWEEN ''' + @FromWareHouseID + ''' AND ''' + @ToWareHouseID + ''' 
AND ISNULL (V00.InventoryID, V01.InventoryID) BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
'

IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV2501')
    EXEC('CREATE VIEW OV2501 -- Tạo bởi OP2501
        AS ' + @sSQL)
ELSE 
    EXEC('ALTER VIEW OV2501 -- Tạo bởi OP2501
        AS ' + @sSQL)
        
-- Xu ly cot dong --
SET @sSQL = '
SELECT ''' + @Caption + ''' AS Caption01, '
SET @Index = 1 
SET @SQL = ''
SET @cur = CURSOR SCROLL KEYSET FOR 
SELECT ColumnID, Caption, IsColumn, Sign1, AmountType1, Sign2, AmountType2, Sign3, AmountType3
FROM OT4010 ORDER BY ColumnID

OPEN @cur
FETCH NEXT FROM @cur INTO @ColumnID, @Caption, @IsColumn, @Sign1, @AmountType1, @Sign2, @AmountType2, @Sign3, @AmountType3
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = @SQL + '('
    IF ISNULL(@Sign1, '') <> ''
        BEGIN
            IF ISNULL(@AmountType1, '') = 'DV'                              -- hang dang ve
                SET @SQL = @SQL + @Sign1 + ' ISNULL (PQuantity, 0) '
            ELSE IF ISNULL(@AmountType1, '') = 'GC'                         -- Hang giu cho 
                SET @SQL = @SQL + @Sign1 + ' ISNULL(SQuantity, 0) '
            ELSE IF ISNULL(@AmountType1, '') = 'TT'                         -- Ton kho thuc te
                SET @SQL = @SQL + @Sign1 + ' ISNULL (EndQuantity, 0) '
            ELSE IF ISNULL(@AmountType1, '') = 'MIN'                        -- Ton kho thuc te
                SET @SQL = @SQL + @Sign1 + ' ISNULL (MinQuantity, 0) '
            ELSE IF ISNULL(@AmountType1, '') = 'MAX'                        -- Ton kho thuc te
                SET @SQL = @SQL + @Sign1 + ' ISNULL (MaxQuantity, 0) '
        END
        
    IF ISNULL(@Sign2, '') <> ''
        BEGIN 
            IF ISNULL(@AmountType2, '') = 'DV'                              -- Hang dang ve
                SET @SQL = @SQL + @Sign2 + ' ISNULL(PQuantity, 0) '
            ELSE IF ISNULL(@AmountType2, '') = 'GC'                         -- Hang giu cho
                SET @SQL = @SQL + @Sign2 + ' ISNULL(SQuantity, 0) '
            ELSE IF ISNULL(@AmountType2, '') = 'TT'                         -- Ton kho thuc te
                SET @SQL = @SQL + @Sign2 + ' ISNULL(EndQuantity, 0)'
            ELSE IF ISNULL(@AmountType2, '') = 'MIN'                        -- Ton kho thuc te
                SET @SQL = @SQL + @Sign2 + ' ISNULL (MinQuantity, 0) '
            ELSE IF ISNULL(@AmountType2, '') = 'MAX'                        -- Ton kho thuc te
                SET @SQL = @SQL + @Sign2 + ' ISNULL (MaxQuantity, 0) '
        END 

    IF ISNULL(@Sign3, '') <> ''
        BEGIN
            IF ISNULL(@AmountType3, '') = 'DV'                              -- Hang dang ve
                SET @SQL = @SQL + @Sign3 + ' ISNULL(PQuantity, 0) '
            ELSE IF ISNULL(@AmountType3, '') = 'GC'                         -- Hang giu cho
                SET @SQL = @SQL + @Sign3 + ' ISNULL(SQuantity, 0) '
            ELSE IF ISNULL(@AmountType3, '') = 'TT'                         -- Ton kho thuc te
                SET @SQL = @SQL + @Sign3 + ' ISNULL(EndQuantity, 0)'
            ELSE IF ISNULL(@AmountType3, '') = 'MIN'                        -- Ton kho thuc te
                SET @SQL = @SQL + @Sign3 + ' ISNULL (MinQuantity, 0) '
            ELSE IF ISNULL(@AmountType3, '') = 'MAX'                        -- Ton kho thuc te
                SET @SQL = @SQL + @Sign3 + ' ISNULL (MaxQuantity, 0) '
        END
    
    IF ISNULL(@Sign4, '') <> ''
        BEGIN
            IF ISNULL(@AmountType4, '') = 'DV'                              -- Hang dang ve
                SET @SQL = @SQL + @Sign4 + ' ISNULL(PQuantity, 0) '
            ELSE IF ISNULL(@AmountType4, '') = 'GC'                         -- Hang giu cho
                SET @SQL = @SQL + @Sign4 + ' ISNULL(SQuantity, 0) '
            ELSE IF ISNULL(@AmountType4, '') = 'TT'                         -- Ton kho thuc te
                SET @SQL = @SQL + @Sign4 + ' ISNULL(EndQuantity, 0)'
            ELSE IF ISNULL(@AmountType4, '') = 'MIN'                        -- Ton kho thuc te
                SET @SQL = @SQL + @Sign4 + ' ISNULL (MinQuantity, 0) '
            ELSE IF ISNULL(@AmountType4, '') = 'MAX'                        -- Ton kho thuc te
                SET @SQL = @SQL + @Sign4 + ' ISNULL (MaxQuantity, 0) '
        END
        
    IF ISNULL(@Sign5, '') <> ''
        BEGIN
            IF ISNULL(@AmountType5, '') = 'DV'                              -- Hang dang ve
                SET @SQL = @SQL + @Sign5 + ' ISNULL(PQuantity, 0) '
            ELSE IF ISNULL(@AmountType5, '') = 'GC'                         -- Hang giu cho
                SET @SQL = @SQL + @Sign5 + ' ISNULL(SQuantity, 0) '
            ELSE IF ISNULL(@AmountType5, '') = 'TT'                         -- Ton kho thuc te
                SET @SQL = @SQL + @Sign5 + ' ISNULL(EndQuantity, 0)'
            ELSE IF ISNULL(@AmountType5, '') = 'MIN'                        -- Ton kho thuc te
                SET @SQL = @SQL + @Sign5 + ' ISNULL (MinQuantity, 0) '
            ELSE IF ISNULL(@AmountType5, '') = 'MAX'                        -- Ton kho thuc te
                SET @SQL = @SQL + @Sign5 + ' ISNULL (MaxQuantity, 0) '
        END
        
    SET @SQL = @SQL + ') AS ColumnValue' + LTrim(@Index) + ', '
    SET @Index = @Index + 1
    -- PRINT @SQL
    FETCH NEXT FROM @cur INTO @ColumnID, @Caption, @IsColumn, @Sign1, @AmountType1, @Sign2, @AmountType2, @Sign3, @AmountType3
END
CLOSE @cur

SET @sSQL = '
SELECT ' + @SQL + ' * 
FROM OV2501 
WHERE DivisionID = ''' + @DivisionID + '''
'

-- PRINT @sSQL
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV2505')
    EXEC('CREATE VIEW OV2505 -- Tạo bởi OP2501
        AS ' + @sSQL)
ELSE 
    EXEC('ALTER VIEW OV2505 -- Tạo bởi OP2501
        AS ' + @sSQL)
        

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

