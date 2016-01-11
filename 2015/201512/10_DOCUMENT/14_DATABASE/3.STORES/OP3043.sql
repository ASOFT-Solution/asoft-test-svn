/****** Object:  StoredProcedure [dbo].[OP3043]    Script Date: 12/17/2010 13:57:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, 	date:  18/03/2005
---purpose:  In bao cao chi tiet du tru NVL

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'--- Modify 08/01/2015 by Quốc Tuấn bổ sung thêm dịnh danh
'********************************************/

ALTER PROCEDURE [dbo].[OP3043] 	 @DivisionID as nvarchar(50),
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
				@GroupID nvarchar(50)	 --GroupID: CI1, CI2, CI3, I01, I02, I03, I04, I05									`			
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
Set @sSQL =  'Select T01.DivisionID, '''' as GroupID, 	'''' as GroupName,  	T01.VoucherNo, 	T01.VoucherDate, 
	T05.EDetailID, T05.ProductID, 	T06.InventoryName as ProductName, T06.UnitID as ProductUnitID, T07.UnitName as ProductUnitName, 
	T05.ApportionID, 	isnull(ProductQuantity, 0) as ProductQuantity, T00.MaterialID, 	T02.InventoryName  as MaterialName, T02.Specification,
		 T02.InventoryTypeID,
	T02.UnitID as MaterialUnitID, 	T04.UnitName as MaterialUnitName,  isnull(MaterialQuantity, 0) as MaterialQuantity,
	isnull(T05.LinkNo, '''') as LinkNo
From OT2203  T00  inner join OT2201 T01 on T00.EstimateID = T01.EstimateID and T00.DivisionID = T01.DivisionID
	left join OT2202 T05 on T00.EDetailID = T05.EDetailID and T05.EstimateID = T00.EstimateID  and T00.DivisionID = T05.DivisionID
	left join AT1302 T02 on T02.InventoryID =  T00.MaterialID and T02.DivisionID =  T00.DivisionID
	left  join AT1302 T06 on T06.InventoryID =  T05.ProductID and T06.DivisionID =  T05.DivisionID
	left join  OT2001 T03 on T03.SOrderID = T01.SOrderID and T03.DivisionID = T01.DivisionID
	left join AT1304 T04 on T04.UnitID = T02.UnitID and T04.DivisionID = T02.DivisionID
	left join AT1304 T07 on T07.UnitID = T06.UnitID and T07.DivisionID = T06.DivisionID
Where T01.DivisionID = ''' + @DivisionID + ''' and		
	T00.MaterialID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''' and ' +   
	case when @TypeDate = 0 and @IsDate = 0 then ' T01.TranMonth + T01.TranYear*100 between  ' + @FromMonthYearText  + ' and ' + @ToMonthYearText
	 when @TypeDate = 0 and @IsDate = 1 then ' T01.VoucherDate between ''' + @FromDateText + ''' and '''  + @ToDateText + ''''  
	 when @TypeDate = 1 and @IsDate = 0 then ' T03.TranMonth + T03.TranYear*100 between ' + @FromMonthYearText + ' and ' + @ToMonthYearText
	else ' T03.OrderDate between ''' + @FromDateText + ''' and ''' + @ToDateText + '''' end 


ELSE
BEGIN
Set @GroupField = (Select Case @GroupID when 'CI1' then 'S1' when 'CI2' then 'S2' when 'CI3' then 'S3' 
				when 'I01' then 'I01ID' when 'I02' then 'I02ID' when 'I03' then 'I03ID' when 'I04' then 'I04ID' when 'I05' then 'I05ID'  end)				

Set @sSQL =  'Select T01.DivisionID, T01.VoucherNo, 	T01.VoucherDate, 
	T05.EDetailID, T05.ProductID, 	T06.InventoryName as ProductName, T06.UnitID as ProductUnitID, T07.UnitName as ProductUnitName, 
	T05.ApportionID, 	Isnull(ProductQuantity, 0)  as ProductQuantity, T00.MaterialID, 	T02.Specification,
		 T02.InventoryTypeID, T02.InventoryName  as MaterialName, 
	T02.UnitID as MaterialUnitID, 	T04.UnitName as MaterialUnitName,  isnull(MaterialQuantity, 0)  as MaterialQuantity,
	T02.S1, T02.S2, T02.S3, T02.I01ID, T02.I02ID, T02.I03ID, T02.I04ID, T02.I05ID,
	isnull(T05.LinkNo, '''') as LinkNo
From OT2203  T00  inner join OT2201 T01 on T00.EstimateID = T01.EstimateID and T00.DivisionID = T01.DivisionID
	left join OT2202 T05 on T00.EDetailID = T05.EDetailID and T05.EstimateID = T00.EstimateID and T00.DivisionID = T05.DivisionID
	left join AT1302 T02 on T02.InventoryID =  T00.MaterialID and T02.DivisionID =  T00.DivisionID
	left join AT1302 T06 on T02.InventoryID =  T00.ProductID and T02.DivisionID =  T00.DivisionID
	left join  OT2001 T03 on T03.SOrderID = T01.SOrderID and T03.DivisionID = T01.DivisionID
	left join AT1304 T04 on T04.UnitID = T02.UnitID and T04.DivisionID = T02.DivisionID
	left join AT1304 T07 on T07.UnitID = T06.UnitID and T07.DivisionID = T06.DivisionID
Where T01.DivisionID = ''' + @DivisionID + ''' and		
	T00.MaterialID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''' and ' +   
	case when @TypeDate = 0 and @IsDate = 0 then ' T01.TranMonth + T01.TranYear*100 between  ' + @FromMonthYearText  + ' and ' + @ToMonthYearText
	 when @TypeDate = 0 and @IsDate = 1 then ' T01.VoucherDate between ''' + @FromDateText + ''' and '''  + @ToDateText + ''''  
	 when @TypeDate = 1 and @IsDate = 0 then ' T03.TranMonth + T03.TranYear*100 between ' + @FromMonthYearText + ' and ' + @ToMonthYearText
	else ' T03.OrderDate between ''' + @FromDateText + ''' and ''' + @ToDateText + '''' end  

If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV3143')
	Drop view OV3143
EXEC('Create view OV3143---tao boi OP3043
		as ' + @sSQL)

Set @sSQL = 'Select V00.* , V01.ID as GroupID,	V01.SName  as GroupName
	From OV3143 V00  left join OV1200  V01 on V01.DivisionID = V00.DivisionID AND V01.ID = V00.' + @GroupField + ' and V01.TypeID ='''+@GroupID+'''' 

END

If  exists (Select Top 1 1 From SysObjects Where XType = 'V' and Name = 'OV3043')
	DROP VIEW OV3043
EXEC('Create view OV3043 ---tao boi OP3043
		as ' + @sSQL)