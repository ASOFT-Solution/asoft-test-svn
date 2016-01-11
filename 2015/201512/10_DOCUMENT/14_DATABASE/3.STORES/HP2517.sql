
/****** Object:  StoredProcedure [dbo].[HP2517]    Script Date: 12/15/2011 14:24:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2517]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2517]
GO



/****** Object:  StoredProcedure [dbo].[HP2517]    Script Date: 12/15/2011 14:24:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


-----Created by Vo Thanh Huong, date: 25/08/2004
-----purpose: Xu ly so lieu in luong cong thang tong hop

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2517] @DivisionID NVARCHAR(50),
				@FromDepartmentID NVARCHAR(50),
				@ToDepartmentID NVARCHAR(50),
				@TeamID NVARCHAR(50),
				@FromEmployeeID NVARCHAR(50), 
				@ToEmployeeID NVARCHAR(50), 
				@FromYear int,
				@FromMonth int,				
				@ToYear int,
				@ToMonth int,				
				@lstPayrollMethodID nvarchar(4000),
				@GrossPay NVARCHAR(50),
				@Deduction NVARCHAR(50),
				@IncomeTax NVARCHAR(50),
				@gnLang int			
AS
Declare @sSQL nvarchar(4000), 
	@cur cursor,
	@FieldID NVARCHAR(50),
	@Caption nvarchar(100),
	@Signs  decimal (28, 8),
	@Notes  nvarchar(50), 
	@Orders as tinyint,
	@IncomeID NVARCHAR(50),
	@PayrollMethodID NVARCHAR(50)

			

Set @lstPayrollMethodID = case when @lstPayrollMethodID = '%' then  ' like ''' + @lstPayrollMethodID + ''''  else ' in (''' + replace(@lstPayrollMethodID, ',',''',''') + ''')' end 

Select @sSQL = '',  @Orders = 1

---Neu don vi co tinh thue thu nhap

If exists (select top 1 1 from HT2400 where DivisionID = @DivisionID And TranMonth+ 100* TranYear
			between  cast(@FromMonth + @FromYear*100 as nvarchar(10))  and  
			cast(@ToMonth + @ToYear*100 as nvarchar(10))  and TaxObjectID is not null)

Begin 

Set @sSQL = 'Select T00.DivisionID, T00.DepartmentID, V00.DepartmentName,  PayrollMethodID, 
		 isnull(T00.TeamID,'''') as TeamID,
		sum(isnull(T02.BaseSalary, 0)) as BaseSalary,
		sum(isnull(T02.InsuranceSalary, 0)) as InsuranceSalary,
		sum(isnull(Income01,0)) as Income01,  sum(isnull(Income02, 0)) as Income02, sum(isnull(Income03, 0)) as Income03, 
		sum(isnull(Income04, 0)) as Income04, 
		sum(isnull(Income05, 0)) as Income05, sum(isnull(Income06, 0)) as Income06, sum(isnull(Income07, 0)) as Income07,
		sum(isnull(Income08, 0)) as Income08, sum(isnull(Income09, 0)) as Income09, sum(isnull(Income10, 0)) as Income10,
		sum(isnull(Income11,0)) as Income11,  sum(isnull(Income12, 0)) as Income12, sum(isnull(Income13, 0)) as Income13, 
		sum(isnull(Income14, 0)) as Income14, 
		sum(isnull(Income15, 0)) as Income15, sum(isnull(Income16, 0)) as Income16, sum(isnull(Income17, 0)) as Income17,
		sum(isnull(Income18, 0)) as Income18, sum(isnull(Income19, 0)) as Income19, sum(isnull(Income20, 0)) as Income20,
		sum(isnull(SubAmount01, 0)) as SubAmount01,  sum(isnull(SubAmount02, 0)) as SubAmount02,  sum(isnull(SubAmount03, 0)) as SubAmount03, 
		sum(isnull(SubAmount04, 0)) as SubAmount04, sum(isnull(SubAmount05, 0)) as SubAmount05,  sum(isnull(SubAmount06, 0)) as SubAmount06, 
		sum(isnull(SubAmount07, 0)) as SubAmount07, sum(isnull(SubAmount08, 0)) as SubAmount08,  sum(isnull(SubAmount09, 0)) as SubAmount09, 
		sum(isnull(SubAmount10, 0)) as SubAmount10 , 
		sum(isnull(SubAmount11, 0)) as SubAmount11,  sum(isnull(SubAmount12, 0)) as SubAmount12,  sum(isnull(SubAmount13, 0)) as SubAmount13, 
		sum(isnull(SubAmount14, 0)) as SubAmount14, sum(isnull(SubAmount15, 0)) as SubAmount15,  sum(isnull(SubAmount16, 0)) as SubAmount16, 
		sum(isnull(SubAmount17, 0)) as SubAmount17, sum(isnull(SubAmount18, 0)) as SubAmount18,  sum(isnull(SubAmount19, 0)) as SubAmount19, 
		sum(isnull(SubAmount20, 0)) as SubAmount20 ,sum(isnull(TaxAmount, 0)) as SubAmount00
	From HT3400 T00  inner join HV1400 V00 on  V00.EmployeeID = T00.EmployeeID and V00.DivisionID = T00.DivisionID 
			inner join AT1102 T01 on T01.DivisionID = T00.DivisionID and T01.DepartmentID = T00.DepartmentID 
			inner join HT2400 T02 on T02.DivisionID = T00.DivisionID And T02.EmployeeID = T00.EmployeeID and T02.TranMonth = T00.TranMonth and
						T02.TranYear = T00.TranYear 
	Where T00.DivisionID = ''' + @DivisionID + ''' and
		T00.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		isnull(T00.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
		T00.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
		T00.TranMonth + T00.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + ' and ' +  
		cast(@ToMonth + @ToYear*100 as nvarchar(10)) + ' and
		PayrollMethodID ' + @lstPayrollMethodID + ' 
	Group by T00.DivisionID, T00.DepartmentID, V00.DepartmentName, PayrollMethodID,  isnull(T00.TeamID,'''') '
	
--print @sSQL;

If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2517')
	Drop view HV2517
exec('Create view HV2517 ---- tao boi HP2517
			as ' + @sSQL)


Set @sSQL = ''
Set @cur = Cursor scroll keyset for
	Select T00.PayrollMethodID, T00.IncomeID , right(T00.IncomeID,2) as Orders , 1 as Signs, 
		--Case @gnLang When 0 Then 'Tieàn löông'  Else  'Gross Pay' End as Notes, T01.Caption
		@GrossPay as Notes, T01.Caption
	From HT5005  T00 inner join HT0002 T01 on T00.IncomeID = T01.IncomeID and T00.DivisionID = T01.DivisionID
	Where T00.DivisionID = @DivisionID And T00.PayrollMethodID in (Select Distinct PayrollMethodID From HV2517) 
	Union 	
	Select  T00.PayrollMethodID, T00.SubID as IncomeID,  right(T00.SubID,2) as Orders , 2 as Signs, 
		--Case @gnLang When 0 Then 'Caùc khoaûn giaûm tröø'  Else 'Deduction' End as Notes, T01.Caption
	@Deduction as Notes, T01.Caption
	From HT5006  T00 inner join HT0005 T01 on T00.SubID = T01.SubID and T00.DivisionID = T01.DivisionID
	Where T00.DivisionID = @DivisionID And T00.PayrollMethodID in (Select Distinct PayrollMethodID From HV2517) 	
	Union 
	Select Distinct T00.PayrollMethodID, 'S00' as IncomeID, 0 as Orders, 2 as Signs,
		--Case @gnLang When 0 Then 'Caùc khoaûn giaûm tröø' Else 'Deduction' End as Notes, 
		@Deduction as Notes, 
		--Case @gnLang When 0 Then 'Thueá TN' Else 'Income Tax' End as Caption
		@IncomeTax as Caption
	From HT5006  T00 
	Where T00.DivisionID = @DivisionID And T00.PayrollMethodID in (Select Distinct PayrollMethodID From HV2517) 

Open @cur
Fetch next from @cur into @PayrollMethodID, @IncomeID, @Orders, @Signs, @Notes,  @Caption

While @@FETCH_STATUS = 0 
Begin
	Set @sSQL = @sSQL + ' Select DivisionID, DepartmentID, DepartmentName,  TeamID, BaseSalary,  InsuranceSalary,
			 N''' + @Notes + ''' as Notes, ''' + @IncomeID + ''' as IncomeID,' + 
			cast(@Signs as nvarchar(50)) + ' as Signs, ' + case when @Signs  = 1 then 'Income'  else '-SubAmount' end  +
			case when @Orders < 10 then '0' else '' end + cast(@Orders as NVARCHAR(50)) + ' as Amount, N''' +  @Caption + ''' as  Caption, '
			+ cast(@Orders as NVARCHAR(50)) + ' as FOrders  , ''' +  @PayrollMethodID + ''' as a
		From HV2517   Where PayrollMethodID = ''' + @PayrollMethodID + ''' 
		Union all  ' 		

	Fetch next from @cur into @PayrollMethodID, @IncomeID,  @Orders, @Signs, @Notes,  @Caption
End

--print @sSQL;

Set @sSQL = left(@sSQL, len(@sSQL) - 9)

If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2518')
	DROP view HV2518
exec('Create view HV2518 ---- tao boi HP2517
				as ' + @sSQL)

Set @sSQL = ' Select DivisionID, DepartmentID, DepartmentName, TeamID, avg( BaseSalary) as BaseSalary, avg( InsuranceSalary) as InsuranceSalary,
			 Notes, IncomeID, Signs, Caption, FOrders, sum(Amount) as Amount
		From HV2518
		Group by  DepartmentID, DepartmentName, TeamID,  Notes, IncomeID, Signs, Caption, FOrders '

--print @sSQL;

If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2519')
	DROP view HV2519
exec('Create view HV2519 ---- tao boi HP2517
				as ' + @sSQL)

End

Else -----Neu don vi khong tinh thue thu nhap

Begin

Set @sSQL = 'Select T00.DivisionID, T00.DepartmentID, T01.DepartmentName,  PayrollMethodID, 
		 isnull(T00.TeamID,'''') as TeamID,
		sum(isnull(T02.BaseSalary, 0)) as BaseSalary,
		sum(isnull(T02.InsuranceSalary, 0)) as InsuranceSalary,
		sum(isnull(Income01,0)) as Income01,  sum(isnull(Income02, 0)) as Income02, sum(isnull(Income03, 0)) as Income03, 
		sum(isnull(Income04, 0)) as Income04, 
		sum(isnull(Income05, 0)) as Income05, sum(isnull(Income06, 0)) as Income06, sum(isnull(Income07, 0)) as Income07,
		sum(isnull(Income08, 0)) as Income08, sum(isnull(Income09, 0)) as Income09, sum(isnull(Income10, 0)) as Income10,
		sum(isnull(Income11,0)) as Income11,  sum(isnull(Income12, 0)) as Income12, sum(isnull(Income13, 0)) as Income13, 
		sum(isnull(Income14, 0)) as Income14, 
		sum(isnull(Income15, 0)) as Income15, sum(isnull(Income16, 0)) as Income16, sum(isnull(Income17, 0)) as Income17,
		sum(isnull(Income18, 0)) as Income18, sum(isnull(Income19, 0)) as Income19, sum(isnull(Income20, 0)) as Income20,
		sum(isnull(SubAmount01, 0)) as SubAmount01,  sum(isnull(SubAmount02, 0)) as SubAmount02,  sum(isnull(SubAmount03, 0)) as SubAmount03, 
		sum(isnull(SubAmount04, 0)) as SubAmount04, sum(isnull(SubAmount05, 0)) as SubAmount05,  sum(isnull(SubAmount06, 0)) as SubAmount06, 
		sum(isnull(SubAmount07, 0)) as SubAmount07, sum(isnull(SubAmount08, 0)) as SubAmount08,  sum(isnull(SubAmount09, 0)) as SubAmount09, 
		sum(isnull(SubAmount10, 0)) as SubAmount10 , 
		sum(isnull(SubAmount11, 0)) as SubAmount11,  sum(isnull(SubAmount12, 0)) as SubAmount12,  sum(isnull(SubAmount13, 0)) as SubAmount13, 
		sum(isnull(SubAmount14, 0)) as SubAmount14, sum(isnull(SubAmount15, 0)) as SubAmount15,  sum(isnull(SubAmount16, 0)) as SubAmount16, 
		sum(isnull(SubAmount17, 0)) as SubAmount17, sum(isnull(SubAmount18, 0)) as SubAmount18,  sum(isnull(SubAmount19, 0)) as SubAmount19, 
		sum(isnull(SubAmount20, 0)) as SubAmount20 
	From HT3400 T00  inner join HV1400 V00 on  V00.EmployeeID = T00.EmployeeID and V00.DivisionID = T00.DivisionID 
			inner join AT1102 T01 on T01.DivisionID = T00.DivisionID and T01.DepartmentID = T00.DepartmentID 
			inner join HT2400 T02 on T02.DivisionID = T00.DivisionID And T02.EmployeeID = T00.EmployeeID and T02.TranMonth = T00.TranMonth and
						T02.TranYear = T00.TranYear 
	Where T00.DivisionID = ''' + @DivisionID + ''' and
		T00.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		isnull(T00.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
		T00.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
		T00.TranMonth + T00.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + ' and ' +  
		cast(@ToMonth + @ToYear*100 as nvarchar(10)) + ' and
		PayrollMethodID ' + @lstPayrollMethodID + ' 
	Group by T00.DivisionID, T00.DepartmentID, T01.DepartmentName, PayrollMethodID,  isnull(T00.TeamID,'''') '
	
--print @sSQL;

If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2517')
	Drop view HV2517
exec('Create view HV2517 ---- tao boi HP2517
			as ' + @sSQL)



Set @sSQL = ''
Set @cur = Cursor scroll keyset for
	Select T00.PayrollMethodID, T00.IncomeID , right(T00.IncomeID,2) as Orders , 1 as Signs, 
		--Case @gnLang When 0 Then 'Tieàn löông'  Else  'Gross Pay' End as Notes, T01.Caption
		@GrossPay as Notes, T01.Caption
	From HT5005  T00 inner join HT0002 T01 on T00.IncomeID = T01.IncomeID and T00.DivisionID = T01.DivisionID
	Where T00.DivisionID = @DivisionID And T00.PayrollMethodID in (Select Distinct PayrollMethodID From HV2517) 
	Union 	
	Select  T00.PayrollMethodID, T00.SubID as IncomeID,  right(T00.SubID,2) as Orders , 2 as Signs, 
		--Case @gnLang When 0 Then 'Caùc khoaûn giaûm tröø'  Else 'Deduction' End as Notes, T01.Caption
	@Deduction as Notes, T01.Caption
	From HT5006  T00 inner join HT0005 T01 on T00.SubID = T01.SubID and T00.DivisionID = T01.DivisionID
	Where T00.DivisionID = @DivisionID and T00.PayrollMethodID in (Select Distinct PayrollMethodID From HV2517) 	
	

Open @cur
Fetch next from @cur into @PayrollMethodID, @IncomeID, @Orders, @Signs, @Notes,  @Caption

While @@FETCH_STATUS = 0 
Begin
	Set @sSQL = @sSQL + ' Select DivisionID, DepartmentID, DepartmentName,  TeamID, BaseSalary,  InsuranceSalary,
			 N''' + @Notes + ''' as Notes, ''' + @IncomeID + ''' as IncomeID,' + 
			cast(@Signs as nvarchar(50)) + ' as Signs, ' + case when @Signs  = 1 then 'Income'  else '-SubAmount' end  +
			case when @Orders < 10 then '0' else '' end + cast(@Orders as NVARCHAR(50)) + ' as Amount, N''' +  @Caption + ''' as  Caption, '
			+ cast(@Orders as NVARCHAR(50)) + ' as FOrders  , ''' +  @PayrollMethodID + ''' as a
		From HV2517   Where PayrollMethodID = ''' + @PayrollMethodID + ''' 
		Union all  ' 		

	Fetch next from @cur into @PayrollMethodID, @IncomeID,  @Orders, @Signs, @Notes,  @Caption
End
Set @sSQL = left(@sSQL, len(@sSQL) - 9)
--print @sSQL;

If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2518')
	DROP view HV2518
exec('Create view HV2518 ---- tao boi HP2517
				as ' + @sSQL)

Set @sSQL = ' Select DivisionID, DepartmentID, DepartmentName, TeamID, avg( BaseSalary) as BaseSalary, avg( InsuranceSalary) as InsuranceSalary,
			 Notes, IncomeID, Signs, Caption, FOrders, sum(Amount) as Amount
		From HV2518
		Group by  DepartmentID, DepartmentName, TeamID,  Notes, IncomeID, Signs, Caption, FOrders '

If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2519')
	DROP view HV2519
exec('Create view HV2519 ---- tao boi HP2517
				as ' + @sSQL)
End
GO


