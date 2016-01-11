IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3031]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3031]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Bao cao don hang ban theo ma phan tich
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 05/07/2005  by Vo Thanh Huong
---- 
---Edit Tuyen, date 26/01/2009 lay cac thong tin lien quan den DVT qui doi.
---- Modified on 30/01/2012 by Le Thi Thu Hien : Sua dieu kien CONVERT theo ngay
---- Modified on 28/02/2014 by Le Thi Thu Hien : Bo sung phan quyen xem du lieu cua nguoi khac
---- Modified on 10/12/2015 by Kim Vũ: Bổ sung nvarchar01 - nvarchar20 (ABA)
-- <Example>
---- 

CREATE PROCEDURE [dbo].[OP3031] 
    @DivisionID NVARCHAR(50), 
    @Group01ID NVARCHAR(50), 
    @Group02ID NVARCHAR(50), 
    @Group03ID NVARCHAR(50), 
    @Group04ID NVARCHAR(50), 
    @Filter01ID NVARCHAR(50), --tieu thuc 1
    @FromValue01ID NVARCHAR(50), 
    @ToValue01ID NVARCHAR(50), 
    @Filter02ID NVARCHAR(50), --tieu thuc 2
    @FromValue02ID NVARCHAR(50), 
    @ToValue02ID NVARCHAR(50), 
    @Filter03ID NVARCHAR(50), --tieu thuc 3
    @FromValue03ID NVARCHAR(50), 
    @ToValue03ID NVARCHAR(50), 
    @Filter04ID NVARCHAR(50), --tieu thuc 4
    @FromValue04ID NVARCHAR(50), 
    @ToValue04ID NVARCHAR(50), 
    @Unit INT, ---0: 1, 1: 1.000, 2: 1.000.000 
    @IsDate tinyint, --0: Theo ky, 1: Thao ngay
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @FromDate DATETIME, 
    @ToDate DATETIME, 
    @FromObjectID NVARCHAR(50), 
    @ToObjectID NVARCHAR(50), 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50) ,
    @UserID AS VARCHAR(50) = ''
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @sWHERE NVARCHAR(4000), 
    @sSELECT NVARCHAR(4000), 
    @sGROUPBY NVARCHAR(4000), 
    @sFROM NVARCHAR(4000), 
    @ConversionAmountUnit NVARCHAR(20), 
    @GroupField01ID NVARCHAR(50), 
    @GroupField02ID NVARCHAR(50), 
    @GroupField03ID NVARCHAR(50), 
    @GroupField04ID NVARCHAR(50), 
    @FilterField01ID NVARCHAR(50), 
    @FilterField02ID NVARCHAR(50), 
    @FilterField03ID NVARCHAR(50), 
    @FilterField04ID NVARCHAR(50), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
DECLARE @sSQLPer AS NVARCHAR(MAX),
		@sWHEREPer AS NVARCHAR(MAX)
SET @sSQLPer = ''
SET @sWHEREPer = ''		

IF EXISTS (SELECT TOP 1 1 FROM OT0001 WHERE DivisionID = @DivisionID AND IsPermissionView = 1 ) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = OV2300.DivisionID 
											AND AT0010.AdminUserID = '''+@UserID+''' 
											AND AT0010.UserID = OV2300.CreateUserID '
		SET @sWHEREPer = ' AND (OV2300.CreateUserID = AT0010.UserID
								OR  OV2300.CreateUserID = '''+@UserID+''') '		
	END

-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác	

SELECT 
@ConversionAmountUnit = CAST((CASE WHEN @Unit = 0 THEN 1 WHEN @Unit = 1 THEN 1000 ELSE 1000000 END) AS NVARCHAR(20)), 
@sSELECT = '', 
@sGROUPBY = '', 
@sWHERE = CASE WHEN @IsDate = 1 THEN ' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101),101) BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + '''' 
ELSE ' AND TranMonth + TranYear * 100 BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText END, 
@sFROM = ''

---------------------------------------Nhom 
IF ISNULL(@Group01ID, '') <> '' 
    BEGIN
        EXEC AP4700 @Group01ID, @GroupField01ID OUTPUT
        SELECT @sFROM = @sFROM + '
LEFT JOIN AV6666 V1 ON V1.DivisionID = OV2300.DivisionID AND V1.SelectionType = ''' + @Group01ID + ''' AND RTRIM(LTRIM(V1.SelectionID)) = CAST(OV2300.' + @GroupField01ID + ' AS NVARCHAR(50))', 
                @sSELECT = @sSELECT + '
, RTRIM(LTRIM(V1.SelectionID)) AS Group01ID, RTRIM(LTRIM(V1.SelectionName)) AS Group01Name', 
                @sGROUPBY = @sGROUPBY + '
, RTRIM(LTRIM(V1.SelectionID)), RTRIM(LTRIM(V1.SelectionName))'
    END
ELSE
    SET @sSELECT = @sSELECT + '
, '''' AS Group01ID, '''' AS Group01Name' 

IF ISNULL(@Group02ID, '') <> '' 
    BEGIN
        EXEC AP4700 @Group02ID, @GroupField02ID OUTPUT
        SELECT @sFROM = @sFROM + '
LEFT JOIN AV6666 V2 ON V2.DivisionID = OV2300.DivisionID AND V2.SelectionType = ''' + @Group02ID + ''' AND RTRIM(LTRIM(V2.SelectionID)) = CAST(OV2300.' + @GroupField02ID + ' AS NVARCHAR(50))',   
                @sSELECT = @sSELECT + '
, RTRIM(LTRIM(V2.SelectionID)) AS Group02ID, RTRIM(LTRIM(V2.SelectionName)) AS Group02Name', 
                @sGROUPBY = @sGROUPBY + '
, RTRIM(LTRIM(V2.SelectionID)), RTRIM(LTRIM(V2.SelectionName))'
    END
ELSE
    SET @sSELECT = @sSELECT + '
, '''' AS Group02ID, '''' AS Group02Name' 

IF ISNULL(@Group03ID, '') <> '' 
    BEGIN
        EXEC AP4700 @Group03ID, @GroupField03ID OUTPUT
        SELECT @sFROM = @sFROM + '
LEFT JOIN AV6666 V3 ON V3.DivisionID = OV2300.DivisionID AND V3.SelectionType = ''' + @Group03ID + ''' AND RTRIM(LTRIM(V3.SelectionID)) = CAST(OV2300.' + @GroupField03ID + ' AS NVARCHAR(50))',   
                @sSELECT = @sSELECT + '
, RTRIM(LTRIM(V3.SelectionID)) AS Group03ID, RTRIM(LTRIM(V3.SelectionName)) AS Group03Name', 
                @sGROUPBY = @sGROUPBY + '
, RTRIM(LTRIM(V3.SelectionID)), RTRIM(LTRIM(V3.SelectionName))'
    END
ELSE
    SET @sSELECT = @sSELECT + '
, '''' AS Group03ID, '''' AS Group03Name' 

IF ISNULL(@Group04ID, '') <> '' 
    BEGIN
        EXEC AP4700 @Group04ID, @GroupField04ID OUTPUT
        SELECT @sFROM = @sFROM + '
LEFT JOIN AV6666 V4 ON V4.DivisionID = OV2300.DivisionID AND V4.SelectionType = ''' + @Group04ID + ''' AND RTRIM(LTRIM(V4.SelectionID)) = CAST(OV2300.' + @GroupField04ID + ' AS NVARCHAR(50))',   
                @sSELECT = @sSELECT + '
, RTRIM(LTRIM(V4.SelectionID)) AS Group04ID, RTRIM(LTRIM(V4.SelectionName)) AS Group04Name', 
                @sGROUPBY = @sGROUPBY + '
, RTRIM(LTRIM(V4.SelectionID)), RTRIM(LTRIM(V4.SelectionName))'
    END
ELSE
    SET @sSELECT = @sSELECT + '
, '''' AS Group04ID, '''' AS Group04Name' 

---------------------------------------------Loc 
IF ISNULL(@Filter01ID, '') <> '' AND ( ISNULL(@FromValue01ID, '') <> '' or ISNULL(@ToValue01ID, '') <> '')
    BEGIN
        EXEC AP4700 @Filter01ID, @FilterField01ID OUTPUT
        SELECT @sWHERE = @sWHERE + ' AND (' + @FilterField01ID + ' BETWEEN ''' + @FromValue01ID + ''' AND ''' + @ToValue01ID + ''') ', 
                @sSELECT = @sSELECT + ', '+ @FilterField01ID + ' AS Filter01ID ', 
                @sGROUPBY = @sGROUPBY + ', '+ @FilterField01ID
    END

IF ISNULL(@Filter02ID, '') <> '' AND ( ISNULL(@FromValue02ID, '') <> '' or ISNULL(@ToValue02ID, '') <> '')
    BEGIN
        EXEC AP4700 @Filter02ID, @FilterField02ID OUTPUT
        SELECT @sWHERE = @sWHERE + ' AND (' + @FilterField02ID + ' BETWEEN ''' + @FromValue02ID + ''' AND ''' + @ToValue02ID + ''') ', 
                @sSELECT = @sSELECT + ', '+ @FilterField02ID + ' AS Filter02ID ', 
                @sGROUPBY = @sGROUPBY + ', ' + @FilterField02ID
    END

IF ISNULL(@Filter03ID, '') <> '' AND ( ISNULL(@FromValue03ID, '') <> '' or ISNULL(@ToValue03ID, '') <> '')
    BEGIN
        EXEC AP4700 @Filter03ID, @FilterField03ID OUTPUT
        SELECT @sWHERE = @sWHERE + ' AND (' + @FilterField03ID + ' BETWEEN ''' + @FromValue03ID + ''' AND ''' + @ToValue03ID + ''') ', 
                @sSELECT = @sSELECT + ', '+ @FilterField03ID + ' AS Filter03ID ', 
                @sGROUPBY = @sGROUPBY + ', '+ @FilterField03ID
    END

IF ISNULL(@Filter04ID, '') <> '' AND ( ISNULL(@FromValue04ID, '') <> '' or ISNULL(@ToValue04ID, '') <> '')
    BEGIN
        EXEC AP4700 @Filter04ID, @FilterField04ID OUTPUT
        SELECT @sWHERE = @sWHERE + ' AND (' + @FilterField04ID + ' BETWEEN ''' + @FromValue04ID + ''' AND ''' + @ToValue04ID + ''') ', 
                @sSELECT = @sSELECT + ', '+ @FilterField04ID + ' AS Filter04ID ', 
                @sGROUPBY = @sGROUPBY + ', '+ @FilterField04ID
    END

SET @sSQL = '
SELECT 
OV2300.DivisionID, 
OV2300.InventoryID, 
OV2300.InventoryName, 
OV2300.UnitName, 
OV2300.ConversionUnitID, 
OV2300.ConversionUnitName, 
SUM(ISNULL(OV2300.ConvertedQuantity, 0)) AS ConvertedQuantity, 
OV2300.Specification, 
OV2300.InventoryTypeID, 
SUM(OV2300.OrderQuantity) AS OrderQuantity, 
SUM(OV2300.OriginalAmount) / ' + @ConversionAmountUnit + ' AS OriginalAmount, 
SUM(OV2300.ConvertedAmount) / ' + @ConversionAmountUnit +' AS ConvertedAmount, 
SUM(OV2300.VATOriginalAmount) / ' + @ConversionAmountUnit + ' AS VATOriginalAmount, 
SUM(OV2300.VATConvertedAmount) / ' + @ConversionAmountUnit + ' AS VATConvertedAmount, 
SUM(OV2300.DiscountOriginalAmount) / ' + @ConversionAmountUnit + ' AS DiscountOriginalAmount, 
SUM(OV2300.DiscountConvertedAmount) / ' + @ConversionAmountUnit + ' AS DiscountConvertedAmount, 
SUM(OV2300.TotalOriginalAmount) / ' + @ConversionAmountUnit + ' AS TotalOriginalAmount, 
SUM(OV2300.TotalConvertedAmount) / ' + @ConversionAmountUnit + ' AS TotalConvertedAmount,
OV2300.nvarchar01, OV2300.nvarchar02, OV2300.nvarchar03, OV2300.nvarchar04, OV2300.nvarchar05,
		OV2300.nvarchar06, OV2300.nvarchar07, OV2300.nvarchar08, OV2300.nvarchar09, OV2300.nvarchar10, 
		OV2300.nvarchar11, OV2300.nvarchar12, OV2300.nvarchar13, OV2300.nvarchar14, OV2300.nvarchar15, 
		OV2300.nvarchar16, OV2300.nvarchar17, OV2300.nvarchar18, OV2300.nvarchar19, OV2300.nvarchar20
' + 
@sSELECT + ' 
FROM OV2300 
' + @sFROM + ' 
' + @sSQLPer + '
WHERE OV2300.DivisionID = ''' + @DivisionID + ''' 
AND OV2300.OrderType = 0 
AND OV2300.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 
AND OV2300.ObjectID BETWEEN ''' + @FromObjectID + ''' AND ''' + @ToObjectID + '''
' + @sWhere + ' 
' + @sWHEREPer + '
GROUP BY OV2300.InventoryID, OV2300.InventoryName, OV2300.UnitName, OV2300.Specification, 
OV2300.ConversionUnitID, OV2300.ConversionUnitName, OV2300.DivisionID, OV2300.InventoryTypeID ,
OV2300.nvarchar01, OV2300.nvarchar02, OV2300.nvarchar03, OV2300.nvarchar04, OV2300.nvarchar05,
		OV2300.nvarchar06, OV2300.nvarchar07, OV2300.nvarchar08, OV2300.nvarchar09, OV2300.nvarchar10, 
		OV2300.nvarchar11, OV2300.nvarchar12, OV2300.nvarchar13, OV2300.nvarchar14, OV2300.nvarchar15, 
		OV2300.nvarchar16, OV2300.nvarchar17, OV2300.nvarchar18, OV2300.nvarchar19, OV2300.nvarchar20
' + @sGROUPBY 

--Print @sSQL

IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XTYPE = 'V' AND NAME = 'OV3031')
    DROP VIEW OV3031
EXEC('CREATE VIEW OV3031 -- tao boi OP3031
    AS ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

