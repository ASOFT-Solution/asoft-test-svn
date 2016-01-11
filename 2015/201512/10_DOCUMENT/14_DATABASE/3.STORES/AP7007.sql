IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7007]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7007]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by Phuong Loan AND Van Nhan
---- Date 17/03/2005
---- Purpose: In bao cao phan tich hang ton kho
---- Edit by : Dang Le Bao Quynh; Date 22/07/2008
---- Purpose: Cho phep xu ly dieu kien like
---- Edit by Bao Anh, date 11/04/2010 Lay cac truong DVT quy doi
---- Modified by on 03/01/2013 by Lê Thị Thu Hiền : Bổ sung thêm strDivisionID
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [01/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP7007] 
	@DivisionID NVARCHAR(50), 
	@ReportCode NVARCHAR(50), 
	@FromMonth INT, 
	@FromYear INT, 
	@ToMonth INT, 
	@ToYear INT, 
	@FromDate DATETIME, 
	@ToDate DATETIME, 
	@IsDate TINYINT, 
	@Filter1IDFrom NVARCHAR(50), 
	@Filter1IDTo NVARCHAR(50), 
	@Filter2IDFrom NVARCHAR(50), 
	@Filter2IDTo NVARCHAR(50), 
	@Filter3IDFrom NVARCHAR(50), 
	@Filter3IDTo NVARCHAR(50), 
	@Filter4IDFrom NVARCHAR(50), 
	@Filter4IDTo NVARCHAR(50), 
	@Filter5IDFrom NVARCHAR(50), 
	@Filter5IDTo NVARCHAR(50),
	@StrDivisionID AS NVARCHAR(4000) = ''
AS

DECLARE 
	@AT4712_cur CURSOR, 
	@Count INT, 
	@ColumnID INT, 
	@CaculatedType NVARCHAR(2), 
	@ColumnName NVARCHAR(250), 
	@AmountType NVARCHAR(2), 
	@FilterType NVARCHAR(50), 
	@ConditionType NVARCHAR(2), 
	@ConditionFrom NVARCHAR(50), 
	@ConditionTo NVARCHAR(50), 
	@Condition NVARCHAR(50), 
	@Filter1ID NVARCHAR(50), 
	@Filter2ID NVARCHAR(50), 
	@Filter3ID NVARCHAR(50), 
	@Filter4ID NVARCHAR(50), 
	@Filter5ID NVARCHAR(50), 
	@GroupID NVARCHAR(50), 
	@LevelColumn NVARCHAR(50), 
	@ColumnAmount NVARCHAR(4000), 
	@strFilter NVARCHAR(4000), 
	@sSQL NVARCHAR(MAX), 
	@strTime NVARCHAR(4000), 
	@FieldGroup NVARCHAR(50), 
	@FromMonthYearText NVARCHAR(20), 
	@ToMonthYearText NVARCHAR(20), 
	@FromDateText NVARCHAR(20), 
	@ToDateText NVARCHAR(20)
--------------->>>> Chuỗi DivisionID
DECLARE @StrDivisionID_New AS NVARCHAR(4000)
	
IF ISNULL(@StrDivisionID,'') <> ''
	SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
	@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END
ELSE
	SELECT @StrDivisionID_New = CASE WHEN @DivisionID = '%' THEN ' LIKE ''' + 
	@DivisionID + '''' ELSE ' IN (''' + replace(@DivisionID, ',',''',''')+ ''')' END

---------------------<<<<<<<<<< Chuỗi DivisionID

SET @FromMonthYearText = LTRIM(RTRIM(STR(@FromMonth + @FromYear * 100)))
SET @ToMonthYearText = LTRIM(RTRIM(STR(@ToMonth + @ToYear * 100)))
SET @FromDateText = LTRIM(RTRIM(CONVERT(NVARCHAR(20), @FromDate, 101)))
SET @ToDateText = LTRIM(RTRIM(CONVERT(NVARCHAR(20), @ToDate, 101))) + ' 23:59:59'

IF @IsDate =0 
	SET @strTime = '
WHERE (V7.TranMonth + 100 * V7.TranYear BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText + ' ) '
ELSE
	SET @strTime = '
WHERE (V7.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''' ) '

DECLARE ---- Cac Dieu kien cua cac cot
@strCol01 NVARCHAR(500), @strCol02 NVARCHAR(500), @strCol03 NVARCHAR(500), @strCol04 AS NVARCHAR(500), @strCol05 AS NVARCHAR(500), 
@strCol06 NVARCHAR(500), @strCol07 NVARCHAR(500), @strCol08 NVARCHAR(500), @strCol09 AS NVARCHAR(500), @strCol10 AS NVARCHAR(500), 
@strCol11 NVARCHAR(500), @strCol12 NVARCHAR(500), @strCol13 NVARCHAR(500), @strCol14 AS NVARCHAR(500), @strCol15 AS NVARCHAR(500), 
@strCol16 NVARCHAR(500), @strCol17 NVARCHAR(500), @strCol18 NVARCHAR(500), @strCol19 AS NVARCHAR(500), @strCol20 AS NVARCHAR(500)

--Print @strTime 
SELECT @Count = Max(ColumnID) FROM AT4712 WHERE ReportCode = @ReportCode AND DivisionID = @DivisionID

SELECT 
@Filter1ID = Filter1ID, @Filter2ID = Filter2ID, @Filter3ID= Filter3ID, @Filter4ID = Filter4ID, @Filter5ID = Filter5ID, @GroupID = GroupID 
FROM AT4711 WHERE ReportCode = @ReportCode AND DivisionID = @DivisionID

SET @strFilter = ''

IF ISNULL(@Filter1ID, '') <> ''
	BEGIN
		EXEC AP4700 @Filter1ID, @LevelColumn OUTPUT
		SET @strFilter = @strFilter + '
AND ( V7.' + @LevelColumn + ' BETWEEN N''' + @Filter1IDFrom + ''' AND N''' + @Filter1IDTo + ''') '
	END
	
IF ISNULL(@Filter2ID, '') <> ''
	BEGIN
		EXEC AP4700 @Filter2ID, @LevelColumn OUTPUT
		SET @strFilter = @strFilter + '
AND ( V7.' + @LevelColumn + ' BETWEEN N''' + @Filter2IDFrom + ''' AND N''' + @Filter2IDTo + ''') '
	END

IF ISNULL(@Filter3ID, '') <> ''
	BEGIN
		EXEC AP4700 @Filter3ID, @LevelColumn OUTPUT
		SET @strFilter = @strFilter + '
AND ( V7.' + @LevelColumn + ' BETWEEN N''' + @Filter3IDFrom + ''' AND N''' + @Filter3IDTo + ''') '
	END

IF ISNULL(@Filter4ID, '') <> ''
	BEGIN
		EXEC AP4700 @Filter4ID, @LevelColumn OUTPUT
		SET @strFilter = @strFilter + '
AND ( V7.' + @LevelColumn + ' BETWEEN N''' + @Filter4IDFrom + ''' AND N''' + @Filter4IDTo + ''') '
	END

IF ISNULL(@Filter5ID, '') <> ''
	BEGIN
		EXEC AP4700 @Filter5ID, @LevelColumn OUTPUT
		SET @strFilter = @strFilter + '
AND ( V7.' + @LevelColumn + ' BETWEEN N''' + @Filter5IDFrom + ''' AND N''' + @Filter5IDTo + ''') '
	END

SET @sSQL = N'
SELECT	'''+@DivisionID +''' AS DivisionID, 
		InventoryID, InventoryName, UnitID, 
		S1, S2, S3, CI1ID, CI2ID, CI3ID, 
		S1Name, S2Name, S3Name, 
		I01ID, I02ID, I03ID, I04ID, I05ID, 
		InAnaName1, InAnaName2, InAnaName3, InAnaName4, InAnaName5, 
		Specification, Notes01, Notes02, Notes03, 
		UnitName, ConvertedUnitID, ConvertedUnitName '

IF ISNULL(@GroupID, '') <> ''
	BEGIN 
		EXEC AP4700 @GroupID, @FieldGroup OUTPUT
		SET @sSQL = @sSQL + ', V7.' + @FieldGroup + ' AS GroupID '
	END 
ELSE 
	BEGIN
		SET @FieldGroup =''
		SET @sSQL = @sSQL + ', '''' AS GroupID '
	END
	
SET @AT4712_cur = CURSOR SCROLL KEYSET FOR 
SELECT ColumnID, CaculatedType, ColumnName, AmountType, ConditionType, ISNULL(ConditionFrom, ''), ISNULL(ConditionTo, ''), FilterType, ISNULL(Condition, '%')
FROM AT4712 WHERE ReportCode = @ReportCode AND DivisionID = @DivisionID

OPEN @AT4712_cur
FETCH NEXT FROM @AT4712_cur INTO @ColumnID, @CaculatedType, @ColumnName, @AmountType, @ConditionType, @ConditionFrom, @ConditionTo, @FilterType, @Condition

WHILE @@Fetch_Status = 0
	BEGIN 
		EXEC AP7006 @AmountType, @CaculatedType, @ColumnAmount OUTPUT, @ConditionType, @ConditionFrom, @ConditionTo, 
		@FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate, @IsDate, @DivisionID, @FilterType, @Condition
		
		SET @sSQL = @sSQL + ',
' + @ColumnAmount + ' AS ColumnAmount' + (CASE WHEN @ColumnID < 10 then '0' ELSE '' END) + LTRIM(RTRIM(STR(@ColumnID))) 

		FETCH NEXT FROM @AT4712_cur INTO @ColumnID, @CaculatedType, @ColumnName, @AmountType, @ConditionType, @ConditionFrom, @ConditionTo, @FilterType, @Condition
	END
CLOSE @AT4712_cur

WHILE @Count + 1 <= 20
	BEGIN
		SET @sSQL = @sSQL + ',
0 AS ColumnAmount' + (CASE WHEN @Count + 1 <10 then '0' ELSE '' END ) + LTRIM(RTRIM(STR(@Count + 1)))
		SET @Count= @Count + 1
	END
	
SET @sSQL = @sSQL + ' 
FROM AV7000 V7
WHERE V7.DivisionID '+@StrDivisionID_New+' '

IF @strFilter <> '' 
	SET @sSQL = @sSQL + ' ' + @strFilter 
	
SET @sSQL = @sSQL + '
GROUP BY InventoryID, InventoryName, UnitID, S1, S2, S3, CI1ID, CI2ID, CI3ID, S1Name, S2Name, S3Name, I01ID, I02ID, I03ID, I04ID, I05ID, InAnaName1, InAnaName2, InAnaName3, InAnaName4, InAnaName5, Specification, Notes01, Notes02, Notes03, UnitName, ConvertedUnitID, ConvertedUnitName '

IF @FieldGroup <> '' 
	SET @sSQL = @sSQL + ', ' + @FieldGroup

IF EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV7006')
	DROP VIEW AV7006 
EXEC('CREATE VIEW AV7006 -- tao boi AP7007
		AS ' + @sSQL)
		
IF @FieldGroup <> ''
	SET @sSQL = '
SELECT 
V6.*, AT1309.UnitID AS ConversionUnitID, AT1309.ConversionFactor, V66.SelectionName AS GroupName
FROM AV7006 V6 
LEFT JOIN AT1309 ON AT1309.InventoryID = V6.InventoryID AND AT1309.DivisionID = V6.InventoryID
LEFT JOIN AV6666 V66 ON V66.SelectionType = N''' + @GroupID + ''' AND
V66.SelectionID = V6.GroupID AND V66.DivisionID = V6.DivisionID
' 
ELSE
	SET @sSQL = '
SELECT 
V6.*, AT1309.UnitID AS ConversionUnitID, AT1309.ConversionFactor, '''' AS GroupName
FROM AV7006 V6 
LEFT JOIN AT1309 ON AT1309.InventoryID = V6.InventoryID AND AT1309.DivisionID = V6.DivisionID 
' 

IF EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV7007')
	DROP VIEW AV7007 
EXEC('CREATE VIEW AV7007 -- tao boi AP7007
	AS ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

