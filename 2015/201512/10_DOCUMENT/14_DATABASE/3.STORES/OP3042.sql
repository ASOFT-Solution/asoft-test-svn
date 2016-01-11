
/****** Object:  StoredProcedure [dbo].[OP3042]    Script Date: 12/17/2010 13:55:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, 	date:  18/03/2005
---purpose:  In bao cao tong hop du tru nguyen vat lieu ---danh sach thanh pham

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP3042] 	 @DivisionID as nvarchar(50),
				@IsDate as tinyint,
				@TypeDate int,    -- Loai 0 : theo ngay du tru, 1: Theo ngay don hang
				@FromMonth as int,
				@ToMonth as int,
				@FromYear as int,
				@ToYear as int,
				@FromDate as datetime,
				@ToDate as datetime,
				@InventoryTypeID nvarchar(50),
				@FromInventoryID as nvarchar(50),
				@ToInventoryID as nvarchar(50),				
				@IsGroup as tinyint,
				@GroupID nvarchar(50) --GroupID: CI1, CI2, CI3, I01, I02, I03, I04, I05						

 AS
DECLARE @sSQL nvarchar(4000),
	@GroupField nvarchar(20), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

IF @IsGroup = 0 
Set @sSQL =  'Select T01.DivisionID, '''' as GroupID, '''' as GroupName, T00.ProductID,  InventoryName as ProductName,  T02.UnitID, UnitName, ApportionID, 
			Sum(isnull(ProductQuantity, 0)) as ProductQuantity
	From OT2202  T00  inner join OT2201 T01 on T00.EstimateID = T01.EstimateID And T00.DivisionID = T01.DivisionID 
		inner join AT1302 T02 on T02.InventoryID =  T00.ProductID And T02.DivisionID =  T00.DivisionID
		left join  OT2001 T03 on T03.SOrderID = T01.SOrderID And T03.DivisionID = T01.DivisionID
		inner join AT1304 T04 on T04.UnitID = T02.UnitID And T04.DivisionID = T02.DivisionID
	Where T01.DivisionID = ''' + @DivisionID + ''' and		
		T00.ProductID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''' and ' +   
		case when @TypeDate = 0 and @IsDate = 0 then ' T01.TranMonth + T01.TranYear*100 between  ' + @FromMonthYearText  + ' and ' + @ToMonthYearText
		 when @TypeDate = 0 and @IsDate = 1 then ' T01.VoucherDate between ''' + @FromDateText + ''' and '''  + @ToDateText + ''''  
		 when @TypeDate = 1 and @IsDate = 0 then ' T03.TranMonth + T03.TranYear*100 between ' + @FromMonthYearText + ' and ' + @ToMonthYearText
		else ' T03.OrderDate between ''' + @FromDateText + ''' and ''' + @ToDateText + '''' end + ' 
	 Group by T01.DivisionID, ProductID, InventoryName,  T02.UnitID, UnitName, ApportionID'
ELSE
BEGIN
Set @GroupField = (Select Case @GroupID when 'CI1' then 'S1' when 'CI2' then 'S2' when 'CI3' then 'S3' 
				when 'I01' then 'I01ID' when 'I02' then 'I02ID' when 'I03' then 'I03ID' when 'I04' then 'I04ID' when 'I05' then 'I05ID'  end)				

Set @sSQL =  'Select  T01.DivisionID, T00.ProductID, InventoryName as ProductName,T02. UnitID, UnitName,  ApportionID,
		sum(isnull(ProductQuantity, 0)) as ProductQuantity, 
		T02.S1, T02.S2, T02.S3, T02.I01ID, T02.I02ID, T02.I03ID, T02.I04ID, T02.I05ID
	From OT2202  T00  inner join OT2201 T01 on T00.EstimateID = T01.EstimateID And T00.DivisionID = T01.DivisionID 
		inner join AT1302 T02 on T02.InventoryID =  T00.ProductID And T02.DivisionID =  T00.DivisionID
		left join  OT2001 T03 on T03.SOrderID = T01.SOrderID And T03.DivisionID = T01.DivisionID
		inner join AT1304 T04 on T04.UnitID = T02.UnitID And T04.DivisionID = T02.DivisionID
	Where T01.DivisionID = ''' + @DivisionID + ''' and		
		T00.ProductID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''' and ' +   
		case when @TypeDate = 0 and @IsDate = 0 then ' T01.TranMonth + T01.TranYear*100 between  ' + @FromMonthYearText  + ' and ' + @ToMonthYearText
		 when @TypeDate = 0 and @IsDate = 1 then ' T01.VoucherDate between ''' + @FromDateText + ''' and '''  + @ToDateText + ''''  
		 when @TypeDate = 1 and @IsDate = 0 then ' T03.TranMonth + T03.TranYear*100 between ' + @FromMonthYearText + ' and ' + @ToMonthYearText
		else ' T03.OrderDate between ''' + @FromDateText + ''' and ''' + @ToDateText + '''' end + ' 
	 Group by T01.DivisionID, ProductID, InventoryName, T02. UnitID, UnitName,  ApportionID,  
		T02.S1, T02.S2, T02.S3, T02.I01ID, T02.I02ID, T02.I03ID, T02.I04ID, T02.I05ID'
	
If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV3142')
	Drop view OV3142
EXEC('Create view OV3142---tao boi OP3042
		as ' + @sSQL)

Set @sSQL = 'Select V00.* , V01.ID as GroupID,	V01.SName  as GroupName
		From OV3142 V00  left join OV1200  V01 on V01.ID = V00.' + @GroupField + ' and V01.TypeID ='''+@GroupID+'''' 
END

If  exists (Select Top 1 1 From SysObjects Where XType = 'V' and Name = 'OV3042')
	DROP VIEW OV3042
EXEC('Create view OV3042 ---tao boi OP3042
		as ' + @sSQL)