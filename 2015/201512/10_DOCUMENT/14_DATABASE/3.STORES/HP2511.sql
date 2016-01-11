
/****** Object:  StoredProcedure [dbo].[HP2511]    Script Date: 01/13/2012 10:19:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2511]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2511]
GO

/****** Object:  StoredProcedure [dbo].[HP2511]    Script Date: 01/13/2012 10:19:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

-----Created by Vo Thanh Huong, date: 24/08/2004
-----purpose: X? lý s? li?u in h? so luong
---Edit by Huynh Trung Dung date 14/12/2010 --- Them tham so @ToDepartmentID

CREATE PROCEDURE [dbo].[HP2511] @DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@ToDepartmentID nvarchar(50),
				@TranYear int,
				@TranMonth int,
				@ConnID nvarchar(100) ='00'

AS
Declare @sSQL1 nvarchar(4000),
	@sSQL2 nvarchar(4000), 
	@cur cursor,	
	@FieldID nvarchar(50),
	@Description nvarchar(250),
	@Orders int,
	@i int		
	
Select @sSQL1 = '', @sSQL2 = '', @i = 1

Set @sSQL1 = '
Select 		HT.DivisionID,
		HT.EmployeeID, 
		FullName, 
		HT.DepartmentID, 
		AT.DepartmentName, 
		isnull(HT.TeamID,'''') as TeamID, 
		HT1101.TeamName,
		HV.Orders as Orders, 
		isnull(DutyName,'''') as DutyName, 
		isnull(HT.BaseSalary,0) as BaseSalary, 
		isnull(HT.InsuranceSalary, 0) as InsuranceSalary, 
		isnull(HT.Salary01, 0) as Salary01,
		isnull(HT.Salary02, 0) as Salary02, 
		isnull(HT.Salary03,0) as Salary03, 
		isnull(HT.SalaryCoefficient,0) as SalaryCoefficient,  
		isnull(HT.TimeCoefficient,0) as TimeCoefficient, 
		isnull(HT.DutyCoefficient,0) as DutyCoefficient,
	 	isnull(HT.C01,0) as C01, 
		isnull(HT.C02,0) as C02, 
		isnull(HT.C03,0) as C03, 
		isnull(HT.C04,0) as C04, 
		isnull(HT.C05,0) as C05,
		isnull(HT.C06,0) as C06, 
		isnull(HT.C07,0) as C07, 
		isnull(HT.C08,0) as C08, 
		isnull(HT.C09,0) as C09, 
		isnull(HT.C10,0) as C10,
		isnull(HT.C11,0) as C11,
		isnull(HT.C12,0) as C12,
		isnull(HT.C13,0) as C13,
		isnull(HT.C14,0) as C14,
		isnull(HT.C15,0) as C15,
		isnull(HT.C16,0) as C16,
		isnull(HT.C17,0) as C17,
		isnull(HT.C18,0) as C18,
		isnull(HT.C19,0) as C19,
		isnull(HT.C20,0) as C20,
		isnull(HT.C21,0) as C21,
		isnull(HT.C22,0) as C22,
		isnull(HT.C23,0) as C23,
		isnull(HT.C24,0) as C24,
		isnull(HT.C25,0) as C25
From HT2400 HT inner join HV1400 HV on  HV.EmployeeID = HT.EmployeeID and HV.DivisionID = HT.DivisionID 
	inner join AT1102 AT on AT.DivisionID = HT.DivisionID and AT.DepartmentID = HT.DepartmentID 
	left  JOIN HT1101 on HT1101.TeamID = HT.TeamID and HT1101.DivisionID = HT.DivisionID and 
				HT1101.DepartmentID = HT.DepartmentID 
Where HT.DivisionID = ''' + @DivisionID + ''' and
	HT.DepartmentID between ''' + @DepartmentID + ''' and  ''' + @ToDepartmentID + ''' and 
	HT.TranMonth = ' + str(@TranMonth) + ' and
	HT.TranYear = ' + str(@TranYear)  


--print @sSQL1
if not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2406')
	exec('Create view HV2406 ---- tao boi HP2511
				as ' + @sSQL1)	
else
	exec('Alter view HV2406 ---- tao boi HP2511
				as ' + @sSQL1)
if not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2406' + @ConnID)
	exec('Create view HV2406' + @ConnID + ' ---- tao boi HP2511
				as ' + @sSQL1)	
else
	exec('Alter view HV2406' + @ConnID + ' ---- tao boi HP2511
				as ' + @sSQL1)

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[HT2407' + @ConnID + ']') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	exec ('Drop table [dbo].[HT2407' + @ConnID + ']' )

Set @cur = Cursor scroll keyset for
		Select CoefficientID as FieldID, Caption as Description
			From HV1111
		Where DivisionID = @DivisionID And CoefficientID not in('C11','C12','C13')
		Union
		Select BaseSalaryFieldID as FieldID, Description
		From HV1112
		Where DivisionID = @DivisionID And BaseSalaryFieldID In ('BaseSalary', 'InsuranceSalary')
	--	Order by Orders
Open @cur
Fetch next from @cur into @FieldID, @Description
While @@FETCH_STATUS = 0
Begin	
	SET @FieldID = ISNULL(@FieldID,'');
	SET @Description = ISNULL(@Description,'');
	
	Set @sSQL2 = ' Select DivisionID,EmployeeID, FullName, DepartmentID, DepartmentName,  TeamID, Orders, DutyName, 
	' +@FieldID + ' as Amount, N''' + @FieldID + '''  as FieldID, N''' + @Description + ''' as  Description, '+ 
		str(@i) + ' as FOrders
	  From HV2406' + @ConnID + '
	 Where DivisionID = '''+@DivisionID+''' And	' + @FieldID + ' <> 0' 
	
	if @i=1
		begin
			set @sSQL1 = 'Select A.DivisionID, cast(A.EmployeeID as nvarchar(50)) as EmployeeID,cast(A.FullName as nvarchar(150)) as FullName,cast(A.DepartmentID as nvarchar(50)) as DepartmentID,
			cast(A.DepartmentName as nvarchar(150)) as DepartmentName,cast(A.TeamID as nvarchar(50)) as TeamID,cast(A.Orders as nvarchar(50)) as Orders, cast(A.DutyName as nvarchar(150)) as DutyName,
			cast(A.Amount as money) as Amount, cast(A.FieldID as nvarchar(50)) as FieldID,cast(A.Description as nvarchar(150)) as Description,cast(A.FOrders as int) as FOrders into HT2407' + @ConnID + ' from (' + @sSQL2 +') as A'
			
			exec (@sSQL1)
		end
	else			
		exec ('Insert into HT2407' + @ConnID + @sSQL2 )
	Set @i = @i + 1
	Fetch next from @cur into @FieldID, @Description	
	
	--print @sSQL1

End
--Set @sSQL2 = left(@sSQL2, len(@sSQL2) - 5)
Set @sSQL2 ='Select * from [dbo].[HT2407' + @ConnID + ']'

If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2407')
	exec('Create view HV2407 ---- tao boi HP2511
				as ' + @sSQL2)
else
	exec('Alter view HV2407 ---- tao boi HP2511
				as ' + @sSQL2)	
If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2407' + @ConnID)
	exec('Create view HV2407' + @ConnID + ' ---- tao boi HP2511
				as ' + @sSQL2)
else
	exec('Alter view HV2407' + @ConnID + ' ---- tao boi HP2511
				as ' + @sSQL2)


GO


