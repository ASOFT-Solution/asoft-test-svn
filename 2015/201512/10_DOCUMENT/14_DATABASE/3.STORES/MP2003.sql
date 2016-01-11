
/****** Object:  StoredProcedure [dbo].[MP2003]    Script Date: 08/02/2010 09:11:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created by: Vo Thanh Huong, date: 26/10/2004
----purpose: In  ke hoach san xuat

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP2003] @DivisionID as nvarchar(50),				
				@PlanID as nvarchar(50)

				
AS
Declare @sSQL as nvarchar(4000), 
		@Times as int,	
		@Dates as datetime, 
		@cur as cursor,
		@Date01 as datetime, 
		@Date02 as datetime, 
		@Date03 as datetime, 
		@Date04 as datetime, 
		@Date05 as datetime, 
		@Date06 as datetime, 
		@Date07 as datetime, 
		@Date08 as datetime, 
		@Date09 as datetime, 
		@Date10 as datetime, 
		@Date11 as datetime, 
		@Date12 as datetime, 
		@Date13 as datetime, 
		@Date14 as datetime, 
		@Date15 as datetime, 
		@Date16 as datetime, 
		@Date17 as datetime, 
		@Date18 as datetime, 
		@Date19 as datetime, 
		@Date20 as datetime, 
		@Date21 as datetime, 
		@Date22 as datetime, 
		@Date23 as datetime, 
		@Date24 as datetime, 
		@Date25 as datetime, 
		@Date26 as datetime, 
		@Date27 as datetime, 
		@Date28 as datetime, 
		@Date29 as datetime, 
		@Date30 as datetime,
		@Date31 as datetime, 
		@Date32 as datetime, 
		@Date33 as datetime, 
		@Date34 as datetime, 
		@Date35 as datetime, 
		@Date36 as datetime, 
		@Date37 as datetime, 
		@Date38 as datetime, 
		@Date39 as datetime, 
		@Date40 as datetime

Select @sSQL = ''
Select    @Date01 = Date01,  @Date02 = Date02, @Date03 = Date03, @Date04 = Date04, @Date05 = Date05,
		  @Date06 = Date06,  @Date07 = Date07, @Date08 = Date08, @Date09 = Date09, @Date10 = Date10,
		  @Date11 = Date11,  @Date12 = Date12, @Date13 = Date13, @Date14 = Date14, @Date15 = Date15,
		  @Date16 = Date16,  @Date17 = Date17, @Date18 = Date18, @Date19 = Date19, @Date20 = Date20,
		  @Date21 = Date21,  @Date22 = Date22, @Date23 = Date23, @Date24 = Date24, @Date25 = Date25,
		  @Date26 = Date26,  @Date27 = Date27, @Date28 = Date28, @Date29 = Date29, @Date30 = Date30,
		  @Date31 = Date31,  @Date32 = Date32, @Date33 = Date33, @Date34 = Date34, @Date35 = Date35,
		  @Date36 = Date36,  @Date37 = Date37, @Date38 = Date38, @Date39 = Date39, @Date40 = Date40		
From MT2003 Where PlanID = @PlanID

Set @sSQL =  case when isnull(@Date01, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date01, 120) + ''' as datetime) as Dates, 1 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date02, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date02, 120) + ''' as datetime) as Dates, 2 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date03, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date03, 120) + ''' as datetime) as Dates, 3 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date04, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date04, 120) + ''' as datetime) as Dates, 4 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date05, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date05, 120) + ''' as datetime) as Dates, 5 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date06, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date06, 120) + ''' as datetime) as Dates, 6 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date07, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date07, 120) + ''' as datetime) as Dates, 7 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date08, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date08, 120) + ''' as datetime) as Dates, 8 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date09, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date09, 120) + ''' as datetime) as Dates, 9 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date10, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date10, 120) + ''' as datetime) as Dates, 10 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date11, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date11, 120) + ''' as datetime) as Dates, 11 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date12, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date12, 120) + ''' as datetime) as Dates, 12 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date13, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date13, 120) + ''' as datetime) as Dates, 13 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date14, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date14, 120) + ''' as datetime) as Dates, 14 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date15, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date15, 120) + ''' as datetime) as Dates, 15 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date16, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date16, 120) + ''' as datetime) as Dates, 16 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date17, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date17, 120) + ''' as datetime) as Dates, 17 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date18, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date18, 120) + ''' as datetime) as Dates, 18 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date19, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date19, 120) + ''' as datetime) as Dates, 19 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date20, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date20, 120) + ''' as datetime) as Dates, 20 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date21, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date21, 120) + ''' as datetime) as Dates, 21 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date22, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date22, 120) + ''' as datetime) as Dates, 22 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date23, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date23, 120) + ''' as datetime) as Dates, 23 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date24, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date24, 120) + ''' as datetime) as Dates, 24 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date25, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date25, 120) + ''' as datetime) as Dates, 25 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date26, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date26, 120) + ''' as datetime) as Dates, 26 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date27, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date27, 120) + ''' as datetime) as Dates, 27 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date28, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date28, 120) + ''' as datetime) as Dates, 28 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date29, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date29, 120) + ''' as datetime) as Dates, 29 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date30, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date30, 120) + ''' as datetime) as Dates, 30 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date31, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date31, 120) + ''' as datetime) as Dates, 21 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date32, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date32, 120) + ''' as datetime) as Dates, 22 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date33, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date33, 120) + ''' as datetime) as Dates, 23 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date34, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date34, 120) + ''' as datetime) as Dates, 24 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date35, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date35, 120) + ''' as datetime) as Dates, 25 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date36, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date36, 120) + ''' as datetime) as Dates, 26 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date37, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date37, 120) + ''' as datetime) as Dates, 27 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date38, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date38, 120) + ''' as datetime) as Dates, 28 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date39, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date39, 120) + ''' as datetime) as Dates, 29 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
			 case when isnull(@Date40, '') = '' then '' else ' Select cast(''' + convert(nvarchar(20), @Date40, 120) + ''' as datetime) as Dates, 30 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end 
Set @sSQL = left(@sSQL, len(@sSQL) - 5)

If  Exists (Select 1 From sysObjects Where Name ='MV2003' and XType = 'V')
	DROP VIEW MV2003
Exec ('Create view MV2003  ---tao boi MP2003
		as '+@sSQL)

Set @sSQL = 'Select  PlanDetailID, VoucherTypeID, VoucherNo, VoucherDate, M01.SOderID, Description, LinkNo, 
			M01.EmployeeID, AT1103.FullName, M01.DepartmentID, DepartmentName,
			M00.InventoryID, InventoryName, UnitName, PlanQuantity, 
			M00.DivisionID,
			Quantity01, Quantity02, Quantity03, Quantity04, Quantity05,
			Quantity06, Quantity07, Quantity08, Quantity09, Quantity10,
			Quantity11, Quantity12, Quantity13, Quantity14, Quantity15,
			Quantity16, Quantity17, Quantity18, Quantity19, Quantity20,
			Quantity21, Quantity22, Quantity23, Quantity24, Quantity25,
			Quantity26, Quantity27, Quantity28, Quantity29, Quantity30	
		From MT2002 M00 left join AT1302 A00 on A00.InventoryID= M00.InventoryID		
			inner join MT2001 M01 on M01.PlanID = M00.PlanID
			left join AT1304 on AT1304.UnitID = M00.UnitID
			inner join AT1102 on M01.DepartmentID = AT1102.DepartmentID  and AT1102.DivisionID = M01.DivisionID 
			left join AT1103 on AT1103.EmployeeID = M01.EmployeeID
		Where M01.DivisionID = ''' + @DivisionID + ''' and 
			 M01.PlanID = ''' + @PlanID + ''''	
		

If  Exists (Select 1 From sysObjects Where Name ='MV2004' and XType = 'V')
	DROP VIEW MV2004
Exec ('Create view MV2004  ---tao boi MP2003
		as '+@sSQL)

Set @sSQL = ''
Set @cur = cursor scroll keyset for 
		Select Distinct Dates, Times From MV2003
		Order by Times

Open @cur
Fetch next from @cur into @Dates, @Times

While @@Fetch_Status = 0
Begin					
	Set @sSQL= @sSQL + ' Select PlanDetailID, cast(''' + convert(nvarchar(20), @Dates, 120) + '''  as Datetime) as Dates, Quantity' +
			case when @Times < 10 then '0' else '' end  + cast(@Times as nvarchar(2)) + ' as Quantity From MV2004 Union '
	Fetch next from @cur into @Dates, @Times
End 
Close @cur
Set @sSQL = left(@sSQL, len(@sSQL) - 5)

If Exists (Select 1 From sysObjects Where Name ='MV2005' and XType = 'V')
	DROP view MV2005
Exec( 'Create view MV2005  ---tao boi MP2003
		as '+@sSQL)

Set @sSQL = 'Select VoucherNo, VoucherDate,  EmployeeID, FullName, SOderID, DepartmentID, DepartmentName,	 Description, LinkNo,
			V00.PlanDetailID, InventoryID, InventoryName, UnitName, PlanQuantity, Dates, Quantity
		From MV2005 V00 inner join MV2004 V01 on V00.PlanDetailID = V01.PlanDetailID'
	
If Exists (Select 1 From sysObjects Where Name ='MV2006' and XType = 'V')
	Drop view MV2006
Exec ('Create view MV2006  ---tao boi MP2003
		as '+ @sSQL)
