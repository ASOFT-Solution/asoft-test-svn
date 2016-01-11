
/****** Object:  StoredProcedure [dbo].[HP2425]    Script Date: 12/29/2011 09:08:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2425]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2425]
GO


/****** Object:  StoredProcedure [dbo].[HP2425]    Script Date: 12/29/2011 09:08:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


---- Created by Vo Thanh Huong
-----Created date 20/08/2004
----- purpose: Xu ly In cham cong ngay, Mau2: (C?t: AbsentType)
---Edit Huynh Trung Dung ,date 14/12/2010 --- Them tham so @ToDepartmentID
CREATE PROCEDURE [dbo].[HP2425]		@DivisionID nvarchar(50),
					@DepartmentID	nvarchar(50),	
					@ToDepartmentID	nvarchar(50),	
					@TeamID nvarchar(50),
					@EmployeeID nvarchar(50),					
					@FromDate Datetime, 
					@ToDate Datetime					
AS
Declare @sSQL1 nvarchar(4000),
	@sSQL2 nvarchar(4000),	
	@AbsentTypeID nvarchar(20),
	@DateAmount int,
	@i int,
	@AbsentTypeName nvarchar(20)

Set @sSQL1 = 'Select Distinct H00.DivisionID ,H00.AbsentTypeID, Caption, Orders, UnitID
		From HT2401 H00 inner join HT1013 H01 on H00.AbsentTypeID = H01.AbsentTypeID and H00.DivisionID = H01.DivisionID
		Where H00.DivisionID = ''' + @DivisionID + ''' and
			DepartmentID between ''' + @DepartmentID + ''' and ''' + @ToDepartmentID + ''' and
			Isnull(TeamID, '''') like Isnull(''' + @TeamID + ''', '''') and
			AbsentDate between ''' + convert(nvarchar(25), @FromDate, 101) + ''' and ''' + convert(nvarchar(25), @ToDate, 101) + ''''
			 

If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2414')
	exec('Create view HV2414  ----tao boi HP2425
			as ' + @sSQL1)
else
	exec('Alter view HV2414 ----tao boi HP2425
			as ' + @sSQL1)

Set @sSQL2 = 'Select  HT00.DivisionID, HT00.DepartmentID,  AT00.DepartmentName, HT01.TeamID, HT01.TeamName, HT00.EmployeeID, FullName, 
		Birthday, HT00.AbsentTypeID,  sum(AbsentAmount) as AbsentAmount, HV00.Orders
	From HT2401  HT00  inner join HV1400 HV00 on HV00.EmployeeID = HT00.EmployeeID and HV00.DivisionID = HT00.DivisionID 
		inner join AT1102  AT00 on AT00.DepartmentID = HT00.DepartmentID and AT00.DivisionID = HT00.DivisionID 
		left join HT1101  HT01 on HT01.TeamID = HT00.TeamID and HT01.DivisionID = HT00.DivisionID 
	Where HT00.DivisionID = ''' + @DivisionID + ''' and
		HT00.DepartmentID between ''' + @DepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		Isnull(HT00.TeamID, ''' + ''') like Isnull(''' + @TeamID + ''', ''' + ''') and  
		HT00.EmployeeID like ''' + @EmployeeID + ''' and 	
		(HT00.AbsentDate between ''' +  convert(nvarchar(25), @FromDate, 101) + '''  and ''' + convert(nvarchar(25), @ToDate, 101) + ''')
	Group by  HT00.DivisionID, HT00.DepartmentID,  AT00.DepartmentName, HT01.TeamID, HT01.TeamName, HT00.EmployeeID, FullName, 
		Birthday, HT00.AbsentTypeID, HV00.Orders
Union
Select  HT00.DivisionID, ''zzzzzzzz'' as DepartmentID, ''TỔNG CỘNG'' as DepartmentName, ''zzzzzzzz'' as TeamID, ''TỔNG CỘNG'' as TeamName, '''' as EmployeeID, '''' as FullName, 
		NULL as Birthday,  HT00.AbsentTypeID, sum( AbsentAmount) as AbsentAmount, 
		0 as Orders
	From HT2401  HT00  
	Where HT00.DivisionID = ''' + @DivisionID + ''' and
		HT00.DepartmentID between ''' + @DepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		Isnull(HT00.TeamID, ''' + ''') like Isnull(''' + @TeamID + ''', ''' + ''') and  
		HT00.EmployeeID like ''' + @EmployeeID + ''' and 	
		(HT00.AbsentDate between ''' +  convert(nvarchar(25), @FromDate, 101) + '''  and ''' + convert(nvarchar(25), @ToDate, 101) + ''')
	Group by HT00.DivisionID, HT00.AbsentTypeID'


If not exists (Select  1 From sysObjects Where XType = 'V' and Name = 'HV2425')
	exec('Create view HV2425 ----tao boi HP2425
			as '+ @sSQL2)
else
	exec('Alter view HV2425 ----tao boi HP2425
			as ' + @sSQL2)