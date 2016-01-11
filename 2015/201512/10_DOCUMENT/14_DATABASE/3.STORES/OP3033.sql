IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3033]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3033]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Bao cao chao gia theo ma phan tich
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 05/07/2005  by Vo Thanh Huong
---- 
---- Modified on 20/01/2012 by Le Thi Thu Hien : Sua dieu kien CONVERT theo ngay
-- <Example>
---- 


CREATE PROCEDURE [dbo].[OP3033] 
				@DivisionID  nvarchar(50),
				@Group01ID  nvarchar(50),
				@Group02ID  nvarchar(50),
				@Group03ID  nvarchar(50),
				@Group04ID  nvarchar(50),					
				@Filter01ID nvarchar(50),  --tieu  thuc 1
				@FromValue01ID nvarchar(50),
				@ToValue01ID nvarchar(50),	
				@Filter02ID nvarchar(50),  --tieu  thuc 2
				@FromValue02ID nvarchar(50),
				@ToValue02ID nvarchar(50),							
				@Filter03ID nvarchar(50),  --tieu  thuc 3
				@FromValue03ID nvarchar(50),
				@ToValue03ID nvarchar(50),							
				@Filter04ID nvarchar(50),  --tieu  thuc 4
				@FromValue04ID nvarchar(50),
				@ToValue04ID nvarchar(50),			
				@Unit int,	---0: 1, 1: 1.000, 2: 1.000.000					
				@IsDate tinyint, --0: Theo ky, 1: Thao ngay
				@FromMonth  int,
				@FromYear  int,
				@ToMonth  int,
				@ToYear  int,
				@FromDate  datetime,
				@ToDate  datetime,
				@FromObjectID  nvarchar(50),
				@ToObjectID  nvarchar(50),
				@FromInventoryID  nvarchar(50),
				@ToInventoryID  nvarchar(50)								
AS
DECLARE 	@sSQL  nvarchar(4000),
			@sWHERE  nvarchar(4000),
			@sSELECT  nvarchar(4000),
			@sGROUPBY  nvarchar(4000),
			@sFROM nvarchar(4000),
			@ConversionAmountUnit  nvarchar(20),
			@GroupField01ID nvarchar(50),
			@GroupField02ID nvarchar(50),
			@GroupField03ID nvarchar(50),
			@GroupField04ID nvarchar(50),
			@FilterField01ID  nvarchar(50),
			@FilterField02ID  nvarchar(50),
			@FilterField03ID  nvarchar(50),
			@FilterField04ID  nvarchar(50), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'
		
				
Select	@ConversionAmountUnit = cast((case when @Unit = 0 then 1 when @Unit = 1 then 1000 else 1000000 end) as nvarchar(20)),
	@sSELECT = '', 
	@sGROUPBY = '',
	@sWHERE = CASE WHEN @IsDate = 1 then ' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101),101) BETWEEN ''' + @FromDateText + ''' and ''' + @ToDateText + ''''  ELSE 
											'  AND TranMonth + TranYear*100 BETWEEN ' + @FromMonthYearText + ' and ' + @ToMonthYearText end,
	@sFROM = ''

---------------------------------------Nhom 
IF isnull(@Group01ID, '') <> '' 
	BEGIN
	Exec AP4700  	@Group01ID,	@GroupField01ID OUTPUT
	Select @sFROM = @sFROM + ' LEFT JOIN AV6666 V1 on V1.DivisionID = OV2200.DivisionID AND V1.SelectionType = ''' + @Group01ID + ''' and V1.SelectionID = OV2200.' + @GroupField01ID,
		@sSELECT = @sSELECT + ', 
		V1.SelectionID as Group01ID, V1.SelectionName as Group01Name',
		
		@sGROUPBY =  @sGROUPBY  +  ', 
		V1.SelectionID,  V1.SelectionName'
	END
ELSE
	Set @sSELECT = @sSELECT +  ', 
		'''' as Group01ID, '''' as Group01Name'	

IF isnull(@Group02ID, '') <> '' 
	BEGIN
	Exec AP4700  	@Group02ID,	@GroupField02ID OUTPUT
	Select @sFROM = @sFROM + ' LEFT JOIN AV6666 V2 on V2.DivisionID = OV2200.DivisionID AND V2.SelectionType = ''' + @Group02ID + ''' and V2.SelectionID = OV2200.' + @GroupField02ID,
		@sSELECT = @sSELECT + ', 
		V2.SelectionID as Group02ID, V2.SelectionName as Group02Name',
		
		@sGROUPBY =  @sGROUPBY  +  ', 
		V2.SelectionID,  V2.SelectionName'
	END
ELSE
	Set @sSELECT = @sSELECT + ', 
		'''' as Group02ID, '''' as Group02Name'	

IF isnull(@Group03ID, '') <> '' 
	BEGIN
	Exec AP4700  	@Group03ID,	@GroupField03ID OUTPUT
	Select @sFROM = @sFROM + ' LEFT JOIN AV6666 V3 on V3.DivisionID = OV2200.DivisionID AND V3.SelectionType = ''' + @Group03ID + ''' and V3.SelectionID = OV2200.' + @GroupField03ID,
		@sSELECT = @sSELECT + ', 
		V3.SelectionID as Group03ID, V3.SelectionName as Group03Name',
		
		@sGROUPBY =  @sGROUPBY  +  ', 
		V3.SelectionID,  V3.SelectionName'
	END
ELSE
	Set @sSELECT = @sSELECT + ', 
		'''' as Group03ID, '''' as Group03Name'	

IF isnull(@Group04ID, '') <> '' 
	BEGIN
	Exec AP4700  	@Group04ID,	@GroupField04ID OUTPUT
	Select @sFROM = @sFROM + '
		left join AV6666 V4 on V4.DivisionID = OV2200.DivisionID AND V4.SelectionType = ''' + @Group04ID + ''' and V4.SelectionID = OV2200.' + @GroupField04ID,
		@sSELECT = @sSELECT + ', 
		V4.SelectionID as Group04ID, V4.SelectionName as Group04Name', 
		
		@sGROUPBY =  @sGROUPBY  +  ', 
		V4.SelectionID, V4.SelectionName'
	END
ELSE
	Set @sSELECT = @sSELECT + ', 
		'''' as Group04ID, '''' as Group04Name'	

---------------------------------------------Loc 
If isnull(@Filter01ID, '') <> ''If isnull(@Filter01ID, '') <> '' and ( isnull(@FromValue01ID,'') <> '' or  isnull(@ToValue01ID, '') <> '')
  Begin
	Exec AP4700	  @Filter01ID, 	@FilterField01ID OUTPUT
	Select @sWHERE = @sWHERE + ' and 
					(' + @FilterField01ID + ' between ''' + @FromValue01ID + ''' and ''' + @ToValue01ID  + ''') ',
	
		 @sSELECT = @sSELECT +  ', '+ 
	 	@FilterField01ID + ' as Filter01ID ',
		@sGROUPBY = @sGROUPBY +   ', 
		'+   @FilterField01ID
  End

If isnull(@Filter02ID, '') <> '' and ( isnull(@FromValue02ID,'') <> '' or  isnull(@ToValue02ID, '') <> '')
  Begin
	Exec AP4700	  @Filter02ID, 	@FilterField02ID OUTPUT
	Select @sWHERE = @sWHERE + ' and 
					(' + @FilterField02ID + ' between ''' + @FromValue02ID + ''' and ''' + @ToValue02ID  + ''') ',
	
		 @sSELECT = @sSELECT +  ', 
		'+   @FilterField02ID + ' as Filter02ID ',
		@sGROUPBY = @sGROUPBY +  ', 
		' + @FilterField02ID
  End

If isnull(@Filter03ID, '') <> '' and ( isnull(@FromValue03ID,'') <> '' or  isnull(@ToValue03ID, '') <> '')
  Begin
	Exec AP4700	  @Filter03ID, 	@FilterField03ID OUTPUT
	Select @sWHERE = @sWHERE + ' and 
					(' + @FilterField03ID + ' between ''' + @FromValue03ID + ''' and ''' + @ToValue03ID  + ''') ',
	
		 @sSELECT = @sSELECT +  ', 
		'+  @FilterField03ID + ' as Filter03ID ',

		@sGROUPBY = @sGROUPBY +  ', 
		'+  @FilterField03ID
  End

If isnull(@Filter04ID, '') <> '' and ( isnull(@FromValue04ID,'') <> '' or  isnull(@ToValue04ID, '') <> '')
  Begin
	Exec AP4700	  @Filter04ID, 	@FilterField04ID OUTPUT
	Select @sWHERE = @sWHERE + ' and 
					(' + @FilterField04ID + ' between ''' + @FromValue04ID + ''' and ''' + @ToValue04ID  + ''') ',
	
		 @sSELECT = @sSELECT +  ', 
		'+  @FilterField04ID + ' as Filter04ID ',
		@sGROUPBY = @sGROUPBY +  ', 
		'+  @FilterField04ID
  End

Set @sSQL = 
'SELECT OV2200.DivisionID,	
		InventoryID, 
		InventoryName, 
		UnitName, 
		Specification,
		InventoryTypeID,
		sum(OrderQuantity) as OrderQuantity,
		sum(OriginalAmount)/' + @ConversionAmountUnit + ' as OriginalAmount, 
		sum(ConvertedAmount)/' + @ConversionAmountUnit +' as ConvertedAmount,
		sum(VATOriginalAmount)/' + @ConversionAmountUnit  + ' as VATOriginalAmount,   
		sum(VATConvertedAmount)/' + @ConversionAmountUnit + ' as VATConvertedAmount,
		sum(DiscountOriginalAmount)/' +  @ConversionAmountUnit + ' as DiscountOriginalAmount,
		sum(DiscountConvertedAmount)/' + @ConversionAmountUnit + ' as DiscountConvertedAmount,
		sum(TotalOriginalAmount)/' +  @ConversionAmountUnit + ' as TotalOriginalAmount,
		sum(TotalConvertedAmount)/' + @ConversionAmountUnit + ' as TotalConvertedAmount' + 
		@sSELECT + ' 
FROM	OV2200 ' + @sFROM + '
WHERE	OV2200.DivisionID = ''' + @DivisionID + ''' and 
		InventoryID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID +  ''' and 
		ObjectID between ''' + @FromObjectID + ''' and ''' + @ToObjectID +  '''' 	
		+ @sWhere + ' 
GROUP BY  InventoryID, InventoryName, UnitName, Specification, OV2200.DivisionID,
		InventoryTypeID' + @sGROUPBY 

If exists (SELECT TOP 1 1 FROM sysObjects WHERE XTYPE = 'V' and NAME = 'OV3033')
	DROP VIEW OV3033
EXEC('Create view OV3033 ---tao boi OP3033
		as ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

