

/****** Object:  StoredProcedure [dbo].[HP2533]    Script Date: 12/15/2011 14:50:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2533]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2533]
GO



/****** Object:  StoredProcedure [dbo].[HP2533]    Script Date: 12/15/2011 14:50:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


-----Created by Vo Thanh Huong, date: 27/04/2005
-----purpose: Xu ly so lieu in ngay cong thang + luong cong thang 

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2533] @DivisionID NVARCHAR(50),
				@FromDepartmentID NVARCHAR(50),
				@ToDepartmentID NVARCHAR(50),
				@TeamID NVARCHAR(50),
				@FromEmployeeID NVARCHAR(50), 
				@ToEmployeeID NVARCHAR(50), 
				@FromYear int,
				@FromMonth int,				
				@ToYear int,
				@ToMonth int,				
				@PayrollMethodID1 nvarchar(4000),
				@GrossPay NVARCHAR(50),
				@Deduction NVARCHAR(50),
				@IncomeTax NVARCHAR(50),
				@WorkingTime NVARCHAR(50),
				@Salary NVARCHAR(50),
				@BasicSalary NVARCHAR(50),
				@InsurSalary NVARCHAR(50),
				@NetPay NVARCHAR(50),
				@gnLang int,				
				@IsChangeCurrency int
				
				-- ,	@ProductPayrollMethodID as nvarchar(500)
AS
Declare @sSQL nvarchar(4000), 
	@cur cursor,
	@FieldID NVARCHAR(50),
	@Caption nvarchar(100),
	@Signs  decimal (28, 8),
	@Notes  nvarchar(50), 
	@Orders int,
	@IncomeID NVARCHAR(50),
	@lstPayrollMethodID nvarchar(4000),
	@PayrollMethodID NVARCHAR(50),
	@Displayed decimal (28, 8),
	@Note1 as nvarchar(50),
	@sDepartment nvarchar(4000), 
	@Type as decimal (28, 8),
	@Pos int,
	@RateExchange decimal (28, 8),
	@Currency NVARCHAR(50),
	@Currency1 NVARCHAR(50)
	


-----------------------------------------------PHONG BAN, TO NHOM CAN IN LUONG---------------------------------------------------------------------

Set @sDepartment='SELECT AT1101.DivisionID, AT1102.DepartmentID, AT1102.DepartmentName, HT1101.TeamID, HT1101.TeamName
	FROM AT1101 LEFT JOIN AT1102 ON AT1101.DivisionID = AT1102.DivisionID 
	LEFT JOIN HT1101 ON AT1102.DepartmentID = HT1101.DepartmentID and AT1102.DivisionID = HT1101.DivisionID
	Where AT1102.DivisionID = '''+@DivisionID+''' And AT1102.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
	isnull(HT1101.TeamID,'''') like isnull(''' + @TeamID + ''', '''')' 
--print @sDepartment

If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2547')
	exec('Create view HV2547 ---- tao boi HP2533
				as ' +@sDepartment)
else
	exec('Alter view HV2547 ---- tao boi HP2533
				as ' + @sDepartment)
---BUOC 1		
----------------------------------------------------------------------------------------------------------------------TINH LUONG THANG-------------------------------------------------------------------------------------------
	
Set @lstPayrollMethodID = case when @PayrollMethodID1 = '%' then  ' like ''' + @PayrollMethodID1 + ''''  else ' in (''' + replace(@PayrollMethodID1, ',',''',''') + ''')' end 

Set @Pos=PATINDEX('%,%', @lstPayrollMethodID)

If @Pos <>0 Or  @PayrollMethodID1 = '%'-----neu in theo nhieu PP tinh luong 
	Begin
	Set @RateExchange=1
	Set @Currency='VND'
	Set @Currency1='USD'
	End
	
Else
	Begin
		Select @RateExchange= RateExchange From HT0000 Where DivisionID=@DivisionID
		Select @Currency= CurrencyID From HT5000 Where DivisionID = @DivisionID And PayrollMethodID=@PayrollMethodID1 
		If  @Currency='VND' 
			Set @Currency1='USD' 
		else 
			Set @Currency1='VND'
	End

Select @sSQL = '',  @Orders = 1

Set @sSQL = 'Select T00.DivisionID, T00.EmployeeID, FullName, T00.DepartmentID, V00.DepartmentName, PayrollMethodID, 
		V00.Orders as Orders, isnull(DutyName,'''') as DutyName, isnull(T00.TeamID,'''') as TeamID, isnull(T01.TeamName,'''') as TeamName, V00.WorkDate,
		avg(isnull(T02.InsuranceSalary, 0)) as InsuranceSalary, avg(isnull(T02.BaseSalary, 0)) as BaseSalary, 
		avg(isnull(T02.Salary01, 0)) as Salary01, avg(isnull(T02.Salary02, 0)) as Salary02, avg(isnull(T02.Salary03, 0)) as Salary03,
		
		avg(isnull(Income01,0)) as Income01,  avg(isnull(Income02, 0)) as Income02, avg(isnull(Income03, 0)) as Income03, 
		avg(isnull(Income04, 0)) as Income04, 
		avg(isnull(Income05, 0)) as Income05, avg(isnull(Income06, 0)) as Income06, avg(isnull(Income07, 0)) as Income07,
		avg(isnull(Income08, 0)) as Income08, avg(isnull(Income09, 0)) as Income09, avg(isnull(Income10, 0)) as Income10,
		avg(isnull(Income11,0)) as Income11,  avg(isnull(Income12, 0)) as Income12, avg(isnull(Income13, 0)) as Income13, 
		avg(isnull(Income14, 0)) as Income14, 
		avg(isnull(Income15, 0)) as Income15, avg(isnull(Income16, 0)) as Income16, avg(isnull(Income17, 0)) as Income17,
		avg(isnull(Income18, 0)) as Income18, avg(isnull(Income19, 0)) as Income19, avg(isnull(Income20, 0)) as Income20,
		avg(isnull(SubAmount01, 0)) as SubAmount01,  avg(isnull(SubAmount02, 0)) as SubAmount02,  avg(isnull(SubAmount03, 0)) as SubAmount03, 
		avg(isnull(SubAmount04, 0)) as SubAmount04, avg(isnull(SubAmount05, 0)) as SubAmount05,  avg(isnull(SubAmount06, 0)) as SubAmount06, 
		avg(isnull(SubAmount07, 0)) as SubAmount07, avg(isnull(SubAmount08, 0)) as SubAmount08,  avg(isnull(SubAmount09, 0)) as SubAmount09, 
		avg(isnull(SubAmount10, 0)) as SubAmount10 , 
		avg(isnull(SubAmount11, 0)) as SubAmount11,  avg(isnull(SubAmount12, 0)) as SubAmount12,  avg(isnull(SubAmount13, 0)) as SubAmount13, 
		avg(isnull(SubAmount14, 0)) as SubAmount14, avg(isnull(SubAmount15, 0)) as SubAmount15,  avg(isnull(SubAmount16, 0)) as SubAmount16, 
		avg(isnull(SubAmount17, 0)) as SubAmount17, avg(isnull(SubAmount18, 0)) as SubAmount18,  avg(isnull(SubAmount19, 0)) as SubAmount19, 
		avg(isnull(SubAmount20, 0)) as SubAmount20 ,avg(isnull(TaxAmount, 0)) as SubAmount00

		
	From HT3400 T00  inner join HV1400 V00 on  V00.EmployeeID = T00.EmployeeID and T00.DivisionID=V00.DivisionID
			left join HV2547 T01 on T01.DivisionID = T00.DivisionID and T01.DepartmentID = T00.DepartmentID and isnull(T00.TeamID,'''') = isnull(T01.TeamID,'''')
			inner join HT2400 T02 on T02.DivisionID = T00.DivisionID And T02.EmployeeID = T00.EmployeeID and T02.TranMonth = T00.TranMonth and
						T02.TranYear = T00.TranYear 
	Where T00.DivisionID = ''' + @DivisionID + ''' and
		T00.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		isnull(T00.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
		T00.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
		T00.TranMonth + T00.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + ' and ' +  
		cast(@ToMonth + @ToYear*100 as nvarchar(10)) + ' and
		PayrollMethodID ' + @lstPayrollMethodID + ' 
	Group by T00.DivisionID, T00.EmployeeID, FullName, T00.DepartmentID, V00.DepartmentName, PayrollMethodID, 
		V00.Orders, isnull(DutyName,''''), isnull(T00.TeamID,''''), isnull(T01.TeamName,'''') , V00.WorkDate'
--print @sSQL

If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2571')
	Drop view HV2571
exec('Create view HV2571 ---- tao boi HP2533
			as ' + @sSQL)

Set @sSQL = ''
Set @cur = Cursor scroll keyset for
	Select T00.PayrollMethodID, T00.IncomeID , right(T00.IncomeID,2) as Orders , 1 as Signs, 1 as Displayed,
		--Case @gnLang When 0 Then 'Tieàn löông' Else 'Gross Pay' End as Notes,
		--Case @gnLang When 0 Then  'Tieàn löông' Else 'Gross Pay' End as Note1, T01.Caption
		@GrossPay as Notes,
		@GrossPay as Note1, T01.Caption
	From HT5005  T00 inner join HT0002 T01 on T00.IncomeID = T01.IncomeID and T00.DivisionID = T01.DivisionID
	Where T00.DivisionID = @DivisionID And T00.PayrollMethodID in (Select Distinct PayrollMethodID From HV2571) 
	Union 	
	Select  T00.PayrollMethodID, T00.SubID as IncomeID, right(T00.SubID,2) as Orders , 1 as Signs,  2 as Displayed,
		--Case @gnLang When 0 Then 'Tieàn löông' Else 'Gross Pay' End as Notes,
		--Case @gnLang When 0 Then  'Giaûm tröø' Else 'Deduction' End as Note1, T01.Caption
		@GrossPay as Notes,
		@Deduction as Note1, T01.Caption
	From HT5006  T00 inner join HT0005 T01 on T00.SubID = T01.SubID and T00.DivisionID = T01.DivisionID
	Where T00.DivisionID = @DivisionID And T00.PayrollMethodID in (Select Distinct PayrollMethodID From HV2571) 	
	Union 
	Select Distinct T00.PayrollMethodID, 'S00' as IncomeID, 0 as Orders, 1 as Signs, 2 as Displayed,
		--Case @gnLang When 0 Then 'Tieàn löông' Else 'Gross Pay' End as Notes,
		--Case @gnLang When 0 Then  'Giaûm tröø' Else 'Deduction' End as Note1,
		--Case @gnLang When 0 Then 'Thueá TN' Else 'Income Tax' End as Caption
		@GrossPay as Notes,
		@Deduction as Note1,
		@IncomeTax as Caption
	From HT5006  T00 
	Where T00.DivisionID = @DivisionID And T00.PayrollMethodID in (Select Distinct PayrollMethodID From HV2571) 

Open @cur
Fetch next from @cur into @PayrollMethodID, @IncomeID, @Orders, @Signs, @Displayed, @Notes,  @Note1, @Caption

While @@FETCH_STATUS = 0 
Begin
	Set @sSQL = @sSQL + ' Select DivisionID, EmployeeID, FullName, DepartmentID, DepartmentName,   InsuranceSalary, 
				BaseSalary, Salary01, Salary02, Salary03,
				Orders, DutyName, TeamID, TeamName, WorkDate, N''' + @Notes + ''' as Notes,  N'''  + @Note1 + ''' as Note1, ''' + @IncomeID + ''' as IncomeID,' + 
			cast(@Signs as nvarchar(50)) + ' as Signs, '  +
			cast(@Displayed as nvarchar(50)) + ' as Displayed, ' +
			+ case when @Displayed  = 1 then 'Income'  else '-SubAmount' end + 
			case when @Orders < 10 then '0' else '' end + cast(@Orders as NVARCHAR(50)) + '  as Amount,  N'''+  @Caption + ''' as  Caption, '
			+ cast(@Orders as nvarchar(2)) + ' as FOrders  , ''' +  @PayrollMethodID + ''' as a
		From HV2571   Where PayrollMethodID =''' + @PayrollMethodID + '''
		Union all' 		

	Fetch next from @cur into @PayrollMethodID, @IncomeID,  @Orders,@Signs ,@Displayed, @Notes,  @Note1, @Caption
End
Set @sSQL = left(@sSQL, len(@sSQL) - 9)

--print @sSQL

set nocount off

If not Exists (Select top 1 1  From SysObjects Where Name ='HT2537' and Xtype ='U')

CREATE TABLE [dbo].[HT2537]  (
	[APK] [uniqueidentifier] NOT NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmployeeID] [nvarchar] (20) NOT NULL,
	[FullName] [nvarchar] (200) NULL, 
	[DepartmentID] [nvarchar] (20)  NULL,
	[DepartmentName] [nvarchar] (100)  NULL, 
	[InsuranceSalary] [decimal] (28, 8)  NULL,	
	[BaseSalary] [decimal] (28, 8)  NULL,
	[Salary01] [decimal] (28, 8)  NULL,
	[Salary02]  [decimal] (28, 8) NULL ,
	[Salary03] [decimal] (28, 8) NULL ,
	[Orders] [int] NULL,
	[DutyName] [nvarchar] (250) NULL,
	[TeamID] [nvarchar] (20) NULL,
	[TeamName] [nvarchar] (200) NULL,
	[WorkDate] [datetime] NULL,
	[Notes] [nvarchar] (200) NULL,
	[Note1] [nvarchar] (200) NULL,
	[IncomeID] [nvarchar] (20) NULL,
	[Signs]  [int] NULL,
	[Displayed] [int] NULL,
	[Amount] [decimal] (28, 8) NULL,
	[Caption] [nvarchar] (200) NULL,
	[FOrders]  [int] NULL,
	[a] [nvarchar] (20) NULL
		
	
) ON [PRIMARY]
Else
  Delete  HT2537


Exec ( 'Insert into HT2537  ( DivisionID, EmployeeID, FullName, DepartmentID, DepartmentName,  InsuranceSalary, 
				BaseSalary, Salary01, Salary02, Salary03,
				Orders, DutyName, TeamID, TeamName, WorkDate, Notes,  Note1, IncomeID, Signs,  Displayed,  Amount,  Caption,  FOrders , a)' + @sSQL)

--BUOC 2
------------------------------------------------------------------------------------------------------TINH NGAY CONG THANG-----------------------------------------------------------------------------------------

Declare @sSQL6 as nvarchar(4000)
Set @sSQL6='SELECT HT5003.DivisionID, HT5003.GeneralAbsentID, HT5003.AbsentTypeID, Caption,  HT1013.Orders
	FROM ht5003 INNER JOIN ht5005 ON ht5005.GeneralAbsentID = ht5003.GeneralAbsentID and ht5005.DivisionID = ht5003.DivisionID 
	AND ht5005.PayrollMethodID ' + @lstPayrollMethodID + ' 
	 INNER JOIN HT1013 ON HT1013.AbsentTypeID = HT5003.AbsentTypeID and HT1013.DivisionID = HT5003.DivisionID
	 And ht5003.DivisionID = '''+@DivisionID+'''
	
	UNION
	SELECT HT5003.DivisionID, HT5003.GeneralAbsentID, HT5003.AbsentTypeID, Caption, 
    	HT1013.Orders
	FROM ht5003 INNER JOIN ht5006 ON ht5006.GeneralAbsentID = ht5003.GeneralAbsentID and ht5006.DivisionID = ht5003.DivisionID 
	AND ht5006.PayrollMethodID ' + @lstPayrollMethodID + '  
	INNER JOIN HT1013 ON HT1013.AbsentTypeID = HT5003.AbsentTypeID and HT1013.DivisionID = HT5003.DivisionID 
	Where ht5003.DivisionID = '''+@DivisionID+''' '

If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2572')
	Drop view HV2572
exec('Create view HV2572 ---- tao boi HP2533
			as ' + @sSQL6)


Set @sSQL=''
Set @sSQL='SELECT HT02.EmployeeID, HT02.DivisionID, v.FullName, v.DepartmentID,  v.DepartmentName, 
		avg(isnull(V.InsuranceSalary, 0)) as InsuranceSalary, avg(isnull(V.BaseSalary, 0)) as BaseSalary, 
		avg(isnull(V.Salary01, 0)) as Salary01, avg(isnull(V.Salary02, 0)) as Salary02, avg(isnull(V.Salary03, 0)) as Salary03,

		3 AS Orders, v.DutyName, v.TeamID, v.TeamName, v.WorkDate, N''' + @WorkingTime+ ''''
		--+ Case @gnLang When 0 Then '''Soá coâng'''  Else '''Working Time'''  End  		
		--+ Case @gnLang  When 0 Then  '''Soá coâng'''   Else   '''Working Time'''   End 
		+' AS Notes, N''' + @WorkingTime+ ''''
		+' AS Note1, HT02.AbsentTypeID AS IncomeID, 
    		0 AS Signs, -1 AS Displayed, H2.Caption, 
    		21 AS FOrders, V.A AS PayrollMethodID , avg(HT02.AbsentAmount) as Amount

	FROM HT2402 HT02 INNER JOIN HT2537 V ON HT02.DepartmentID = v.DepartmentID AND HT02.DivisionID = v.DivisionID
	 AND ISNULL (HT02.TeamID, '''') = ISNULL (V.TeamID, '''') AND HT02.EmployeeID = v.EmployeeID
	INNER JOIN HV2572  H2 ON HT02.AbsentTypeID = H2.AbsentTypeID and HT02.DivisionID = H2.DivisionID 
	
	
	WHERE HT02.DivisionID = ''' + @DivisionID + ''' and
		HT02.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		isnull(HT02.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
		HT02.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
		HT02.TranMonth + ht02.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + ' and ' +  
		cast(@ToMonth + @ToYear*100 as nvarchar(10)) + '
	
	GROUP BY HT02.EmployeeID, HT02.DivisionID, v.FullName, v.DepartmentID, 
    	v.DepartmentName, v.DutyName, v.TeamID, 
   	 v.TeamName, v.WorkDate,HT02.AbsentTypeID, H2.Caption, H2.Orders, v.a               
	
	
	Union SELECT distinct HV.EmployeeID, HV.DivisionID, HV.FullName, HV.DepartmentID,  HV.DepartmentName, 
		avg(isnull(HV.InsuranceSalary, 0)) as InsuranceSalary, avg(isnull(HV.BaseSalary, 0)) as BaseSalary, 
		avg(isnull(HV.Salary01, 0)) as Salary01, avg(isnull(HV.Salary02, 0)) as Salary02, avg(isnull(HV.Salary03, 0)) as Salary03,

		3 AS Orders, Hv.DutyName, Hv.TeamID, Hv.TeamName, hv.WorkDate, N''' + @Salary+ '''' 
		--+Case   @gnLang When 0 Then  '''Möùc löông'''    Else  '''Basic Salary'''   End
		+ ' AS Notes, N''' + @Salary+ '''' 
		--+Case   @gnLang  When 0 Then   '''Möùc löông'''    Else  '''Basic Salary'''   End
		+ '  AS Note1, N''' + @BasicSalary+ '''' 
		--+Case   @gnLang  When 0 Then   '''LCB'''   Else  '''Basic Salary'''   End 
		+ '  AS IncomeID, 
    		-1 AS Signs, -2 AS Displayed, N''' + @BasicSalary+ '''' 
    	--+Case   @gnLang  When 0 Then   '''LCB'''   Else  '''Basic Salary'''   End 
		+ ' as Caption, 
    		22 AS FOrders, N''' + @BasicSalary + ' AS PayrollMethodID , avg(isnull(HV.BaseSalary, 0)) as Amount
	From HV2571 HV
		GROUP BY HV.EmployeeID, HV.DivisionID, Hv.FullName, Hv.DepartmentID, 
    	Hv.DepartmentName,  Hv.DutyName, Hv.TeamID, 
   	 Hv.TeamName, Hv.WorkDate

	Union SELECT distinct HV.EmployeeID, HV.DivisionID, HV.FullName, HV.DepartmentID,  HV.DepartmentName, 
		avg(isnull(HV.InsuranceSalary, 0)) as InsuranceSalary, avg(isnull(HV.BaseSalary, 0)) as BaseSalary, 
		avg(isnull(HV.Salary01, 0)) as Salary01, avg(isnull(HV.Salary02, 0)) as Salary02, avg(isnull(HV.Salary03, 0)) as Salary03,

		3 AS Orders, Hv.DutyName, Hv.TeamID, Hv.TeamName, hv.WorkDate, N''' + @Salary+ '''' 
		--+Case   @gnLang When 0 Then  '''Möùc löông'''    Else  ''' Salary'''   End
		+ ' AS Notes, N''' + @Salary+ '''' 
		--+Case   @gnLang  When 0 Then   '''Möùc löông'''    Else  '''Insur Salary'''   End
		+ '  AS Note1, N''' + @InsurSalary+ '''' 
		--+Case   @gnLang  When 0 Then   '''LBHXH'''   Else  '''Insur Salary'''   End 
		+ '  AS IncomeID, 
    		-1 AS Signs, -1 AS Displayed, N''' + @InsurSalary+ '''' 
		--+Case   @gnLang  When 0 Then   '''LBHXH'''   Else  '''Insur Salary'''   End 
		+ ' as Caption, 
    		22 AS FOrders, N''' + @BasicSalary + ' AS PayrollMethodID , avg(isnull(HV.InsuranceSalary, 0)) as Amount
	From HV2571 HV
	GROUP BY HV.EmployeeID, HV.DivisionID, Hv.FullName, Hv.DepartmentID, 
    	Hv.DepartmentName,  Hv.DutyName, Hv.TeamID, 
   	 Hv.TeamName, Hv.WorkDate '
--print @sSQL


If not Exists (Select top 1 1  From SysObjects Where Name ='HT2538' and Xtype ='U')

CREATE TABLE [dbo].[HT2538]  (
	[APK] [uniqueidentifier] NOT NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmployeeID] [nvarchar] (50) NOT NULL,
	[FullName] [nvarchar] (200) NULL, 
	[DepartmentID] [nvarchar] (50)  NULL,
	[DepartmentName] [nvarchar] (100)  NULL, 
	[InsuranceSalary] [decimal] (28, 8)  NULL,	
	[BaseSalary] [decimal] (28, 8)  NULL,
	[Salary01] [decimal] (28, 8)  NULL,
	[Salary02]  [decimal] (28, 8) NULL ,
	[Salary03] [decimal] (28, 8) NULL ,
	[Orders] [int] NULL,
	[DutyName] [nvarchar] (250) NULL,
	[TeamID] [nvarchar] (50) NULL,
	[TeamName] [nvarchar] (200) NULL,
	[WorkDate] [datetime] NULL,
	[Notes] [nvarchar] (200) NULL,
	[Note1] [nvarchar] (200) NULL,
	[IncomeID] [nvarchar] (50) NULL,
	[Signs]  [int] NULL,
	[Displayed] [int] NULL,
	[Caption] [nvarchar] (200) NULL,
	[FOrders]  [int] NULL,
	[PayrollMethodID] [nvarchar] (50) NULL,
	[Amount] [decimal] (28, 8) NULL
		
	
) ON [PRIMARY]
Else
  Delete  HT2538


Exec ( 'Insert into HT2538  ( DivisionID, EmployeeID, FullName, DepartmentID, DepartmentName, InsuranceSalary, 
				BaseSalary, Salary01, Salary02, Salary03,
				Orders, DutyName, TeamID, TeamName, WorkDate, Notes, Note1,IncomeID, Signs,  Displayed,  Caption,  FOrders , PayrollMethodID, Amount)' + @sSQL)






----BUOC 4
----------------------------------------------------------------------------- KET HOP LUONG THANG VA NGAY CONG THANG--------------------------------------------
Declare @sSQL1 nvarchar(4000),
	@sSQL2 nvarchar(4000)
	
	
set @sSQL2='SELECT DivisionID, EmployeeID  , FullName ,DepartmentID ,DepartmentName ,  InsuranceSalary , 
	BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID , TeamName, WorkDate,
 	Notes , Note1, IncomeID ,Signs , Displayed,
 	Caption  , FOrders , A AS PayrollMethodID , Amount      
	FROM HT2537 Where DivisionID = '''+@DivisionID+'''
	
	UNION Select DivisionID, EmployeeID  , FullName ,DepartmentID ,DepartmentName ,  InsuranceSalary , 
		 BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID ,TeamName, WorkDate, N''' + @NetPay+ ''' '''+ @Currency + ''' '
		 --+ Case  @gnLang  When 0 Then '''Thöïc laõnh ' +  @Currency + ''' ' Else '''Net Pay  ' +  @Currency + ''' 'End  
		 
		 + ' as Notes , N''' + @NetPay+ ''' '
		 +  ' ''' + @Currency + ''' '
		 --+Case  @gnLang  When 0 Then '''Thöïc laõnh ' +  @Currency + ''' '  Else '''Net Pay ' +  @Currency + ''' ' End  
		+ ' as Note1, ''I21'' as IncomeID , 2 as Signs , 0 as Displayed, N''' + @NetPay+ ''''
		+  ' ''' + @Currency + ''' '
		--+Case  @gnLang  When 0 Then '''Thöïc laõnh ' +  @Currency + ''' '  Else '''Net Pay ' +  @Currency + ''' ' End  
		+' as Caption  , 15 as FOrders , A as PayrollMethodID  ,  sum(Amount) as Amount   
	
	FROM HT2537 Where DivisionID = '''+@DivisionID+'''

	GROUP BY DivisionID, EmployeeID  , FullName ,DepartmentID ,DepartmentName  ,InsuranceSalary , 
 		BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID , TeamName, WorkDate, A
	


	UNION 
		SELECT DivisionID, EmployeeID  , FullName ,DepartmentID ,DepartmentName ,  InsuranceSalary , 
	BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID ,TeamName,   WorkDate, Notes , Note1,
	IncomeID ,Signs , Displayed, Caption  , FOrders , PayrollMethodID  ,  Amount   
	FROM HT2538 Where DivisionID = '''+@DivisionID+''' '

--print @sSQL2

If @IsChangeCurrency = 0----Neu khong doi ra loai tien khac

	Begin 
		If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2573')
			exec('Create view HV2573 ---- tao boi HP2533
				as ' + @sSQL2)
		else
			exec('Alter view HV2573 ---- tao boi HP2533
				as ' + @sSQL2)
	End
Else --doi ra loai tien khac

	Begin
	
		If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2574')
			exec('Create view HV2574 ---- tao boi HP2533
				as ' + @sSQL2)
		else
			exec('Alter view HV2574 ---- tao boi HP2533
				as ' + @sSQL2)

		Set @sSQL1='SELECT DivisionID, EmployeeID  , FullName ,DepartmentID ,DepartmentName ,   InsuranceSalary , 
				 BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID ,TeamName,  WorkDate, Notes , Note1,
 				IncomeID ,Signs , Displayed, Caption  , FOrders , PayrollMethodID  ,  Amount   
				FROM HV2574
				
				UNION 
				SELECT DivisionID, EmployeeID  , FullName ,DepartmentID ,DepartmentName ,   InsuranceSalary , 
				 BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID ,
				 TeamName, WorkDate, N''' + @NetPay+ ''' ''' + @Currency + ''' '
				--+ Case  @gnLang  When 0 Then '''Thöïc laõnh'''   Else '''Net Pay ' +  @Currency + ''' '  End 
				+ '   as Notes , N''' + @NetPay+ '''' 
				+  ' ''' + @Currency + ''' '
				--+Case  @gnLang  When 0 Then '''Thöïc laõnh'''  Else '''Net Pay ' +  @Currency + ''' '  End  
				+ ' as Note1, ''I22'' as IncomeID , 3 as Signs , 0 as Displayed, N''' + @NetPay+ ''''
				+  ' ''' + @Currency + ''' '
				--+Case  @gnLang  When 0 Then '''Thöïc laõnh'''  Else '''Net Pay ' +  @Currency + ''' ' End  
				+ ' as Caption  , 16 as FOrders ,  PayrollMethodID  , ' 
				+ Case @Currency When 'USD' Then  + Str(@RateExchange)+ '* sum(Amount)  ' 
				Else 'sum(Amount) /' + Str(@RateExchange)  End +' As Amount
				From
 				HV2574
				Where IncomeID=''I21'' 
				GROUP BY DivisionID, EmployeeID  , FullName ,DepartmentID ,DepartmentName  ,InsuranceSalary , 
 				BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID , TeamName,  WorkDate, PayrollMethodID' 

	--Print @sSQL1
		If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2573')
			exec('Create view HV2573 ---- tao boi HP2533
				as ' + @sSQL1)
		else
			exec('Alter view HV2573 ---- tao boi HP2533
				as ' + @sSQL1)

	End


--''' + @Currency +'''   ' + Case @Currency When '''USD''' Then  + Str(@RateExchange)* 'Amount ' Else 'Amount ' End +' As Amount
-----------------------------------------------------------------------------------------------THE END-----------------------------------------------------------------------------------------------------------------

/*
--BUOC 3
------------------------------------------------------------------------------------------------TINH LUONG SAN PHAM------------------------------------------------------------------------------------------------------

Declare @sSQL1 nvarchar(4000),
	@sSQL2 nvarchar(4000), 
	--@cur cursor,
	@Order tinyint,
	@NoteCaption NVARCHAR(50)

Set @NoteCaption='Tieàn löông'
	
Select @sSQL1 = '', @sSQL2 = ''
Set @ProductPayrollMethodID = case when @ProductPayrollMethodID = '%' then  ' like ''' + @ProductPayrollMethodID + ''''  else ' in (''' + replace(@ProductPayrollMethodID, ',',''',''') + ''')' end 


Set @sSQL1 ='Select HT1.EmployeeID, FullName, HT1.DepartmentID, DepartmentName, 
		 avg(isnull(T02.InsuranceSalary, 0)) as InsuranceSalary, avg(isnull(T02.BaseSalary, 0)) as BaseSalary, 
		avg(isnull(T02.Salary01, 0)) as Salary01, avg(isnull(T02.Salary02, 0)) as Salary02, avg(isnull(T02.Salary03, 0)) as Salary03,
		HV.Orders as Orders, DutyName,  isnull(HT1.TeamID,'''') as TeamID, isnull(T01.TeamName,'''') as TeamName,
		''Tieàn löông'' as Notes , ''Löông saûn phaåm''  as Note1, ''SP'' as IncomeID, 1 as Signs, 0 as Displayed,  HT2.ProductID as Caption,
		HT5.Orders as FOrders, HT1.PayrollMethodID, sum(HT2.ProductSalary) as Amount 

		From HT3402 HT2  inner join HT3401 HT1 on HT2.TransactionID = HT1.TransactionID 
			inner join HV1400 HV on  HV.EmployeeID = HT1.EmployeeID 
			LEFT join HV2547 T01 on T01.DivisionID = HT1.DivisionID and T01.DepartmentID = HT1.DepartmentID and isnull(HT1.TeamID,'''') = isnull(T01.TeamID,'''')
			inner join HT1015 HT5 on HT5.ProductID = HT2.ProductID 
			inner join HT2400 T02 on T02.EmployeeID = HT1.EmployeeID and T02.DivisionID=HT1.DivisionID 
			AND T02.DepartmentID = HT1.DepartmentID AND
			T02.TranMonth = HT1.TranMonth and
			T02.TranYear = HT1.TranYear 	
	
		Where HT1.DivisionID = ''' + @DivisionID + ''' and
		HT1.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		isnull(HT1.TeamID, '''') like  isnull(''' + @TeamID + ''', '''')  and 
		HT1.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
		HT1.TranMonth + HT1.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + ' and ' +  
		cast(@ToMonth + @ToYear*100 as nvarchar(10)) + ' and
		HT1.PayrollMethodID ' + @ProductPayrollMethodID + ' 
		
	
	Group by HT1.EmployeeID, FullName, HT1.DepartmentID, DepartmentName, 
		HV.Orders , DutyName,  isnull(HT1.TeamID,''''), isnull(T01.TeamName,''''),
		HT5.Orders , HT1.PayrollMethodID ,HT2.ProductID 	
	Having sum(HT2.ProductSalary)>0'


--print @sSQL1

If not Exists (Select top 1 1  From SysObjects Where Name ='HT2536' and Xtype ='U')

CREATE TABLE [dbo].[HT2536]  (
	[EmployeeID] [nvarchar] (50) NOT NULL,
	[FullName] [nvarchar] (200) NULL, 
	[DepartmentID] [nvarchar] (50)  NULL,
	[DepartmentName] [nvarchar] (100)  NULL,
	[InsuranceSalary] [decimal] (28, 8)  NULL,	
	[BaseSalary] [decimal] (28, 8)  NULL,
	[Salary01] [decimal] (28, 8)  NULL,
	[Salary02]  [decimal] (28, 8) NULL ,
	[Salary03] [decimal] (28, 8) NULL ,
	[Orders] [int] NULL,
	[DutyName] [nvarchar] (50) NULL,
	[TeamID] [nvarchar] (50) NULL,
	[TeamName] [nvarchar] (200) NULL,
	[Notes] [nvarchar] (200) NULL,
	[Note1] [nvarchar] (200) NULL,
	[IncomeID] [nvarchar] (50) NULL,
	[Signs]  [int] NULL,
	[Displayed] [int] NULL,
	[Caption] [nvarchar] (200) NULL,
	[FOrders]  [int] NULL,
	[PayrollMethodID] [nvarchar] (50) NULL,
	[Amount] [decimal] (28, 8) NULL
		
	
) ON [PRIMARY]
Else
  Delete  HT2536


Exec ( 'Insert into HT2536  ( EmployeeID, FullName, DepartmentID, DepartmentName, InsuranceSalary, 
				BaseSalary, Salary01, Salary02, Salary03,
				Orders, DutyName, TeamID, TeamName, Notes, Note1,IncomeID, Signs,  Displayed,  Caption,  FOrders , PayrollMethodID, Amount)' + @sSQL1)

If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2549')
	exec('Create view HV2549 ---- tao boi HP2532
				as ' + @sSQL1)
else
	exec('Alter view HV2549 ---- tao boi HP2532
				as ' + @sSQL1)

----BUOC 4
----------------------------------------------------------------------------- KET HOP LUONG THANG VA LUONG SAN PHAM--------------------------------------------

set @sSQL2='SELECT EmployeeID  , FullName ,DepartmentID ,DepartmentName ,  InsuranceSalary , 
	BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID , TeamName, 
 	Notes , Note1, IncomeID ,Signs , Displayed,
 	Caption  , FOrders , A AS PayrollMethodID ,Amount      
	FROM HT2534
	
	UNION Select EmployeeID  , FullName ,DepartmentID ,DepartmentName ,  InsuranceSalary , 
		 BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID ,TeamName,  
 		''Tieàn löông'' as Notes , ''Löông TG'' as Note1, ''I11'' as IncomeID , 1 as Signs , 2 as Displayed, ''Löông TG'' as Caption  , 15 as FOrders , A as PayrollMethodID  ,  sum(Amount) as Amount   
	
	FROM HT2534

	GROUP BY EmployeeID  , FullName ,DepartmentID ,DepartmentName ,  ,InsuranceSalary , 
 		BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID , TeamName, A
	


	UNION 

	SELECT EmployeeID  , FullName ,DepartmentID ,DepartmentName ,   InsuranceSalary , 
		 BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID ,TeamName,   Notes , Note1,
 		IncomeID ,Signs , Displayed, Caption  , FOrders , PayrollMethodID  ,  Amount   
	FROM HT2536

	UNION 


	SELECT EmployeeID  , FullName ,DepartmentID ,DepartmentName ,   InsuranceSalary , 
		 BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID ,TeamName,  
 		''Tieàn löông'' as Notes , ''Löông SP'' as Note1, ''I11'' as IncomeID , 1 as Signs , 0 as Displayed, ''Löông SP'' as Caption  , 16 as FOrders , PayrollMethodID  ,  sum(Amount) as Amount   
	
	FROM HT2536

	GROUP BY EmployeeID  , FullName ,DepartmentID ,DepartmentName ,  InsuranceSalary , 
 		BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID , TeamName, PayrollMethodID'

--print @sSQL2
If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2551')
	exec('Create view HV2551 ---- tao boi HP2532
				as ' + @sSQL2)
else
	exec('Alter view HV2551 ---- tao boi HP2532
				as ' + @sSQL2)
Declare @sSQL3 as nvarchar(8000)

Set @sSQL3=' SELECT EmployeeID  , FullName ,DepartmentID ,DepartmentName ,  InsuranceSalary , 
	BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID ,TeamName,   Notes , Note1,
	IncomeID ,Signs , Displayed, Caption  , FOrders , PayrollMethodID  ,  Amount   
	FROM HT2535
	
	UNION
	
	SELECT EmployeeID  , FullName ,DepartmentID ,DepartmentName ,   InsuranceSalary , 
		 BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID ,TeamName,   Notes , Note1,
 		IncomeID ,Signs , Displayed, Caption  , FOrders , PayrollMethodID  ,  Amount   
	FROM Hv2551

	UNION 

	SELECT EmployeeID  , FullName ,DepartmentID ,DepartmentName ,   InsuranceSalary , 
	BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID ,TeamName, 
	''Thöïc laõnh'' as   Notes , ''Thöïc laõnh'' as Note1,
	''I13'' as IncomeID , 2 as Signs , 1 as Displayed, '''' as Caption  , 13 as FOrders , 
	''chung'' as PayrollMethodID  ,  sum(Amount) as Amount    
	FROM Hv2551
	where IncomeID  in (''I11'')  ----not  in (''I11'')
	
	Group by EmployeeID  , FullName ,DepartmentID ,DepartmentName ,   InsuranceSalary , 
	BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID ,TeamName

	
	Union SELECT distinct EmployeeID  , FullName ,DepartmentID ,DepartmentName ,   InsuranceSalary , 
	BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID ,TeamName,  ''Kyù nhaän'' as  Notes , ''Kyù nhaän'' as Note1,
	''I14'' as IncomeID , 3 as Signs , 1 as Displayed, '''' as Caption  ,14 as  FOrders , ''r'' as PayrollMethodID  , 0 as  Amount   
	FROM HT2535 '


If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2555')
	exec('Create view HV2555 ---- tao boi HP2532
				as ' + @sSQL3)
else
	exec('Alter view HV2555 ---- tao boi HP2532
				as ' + @sSQL3)
 

Set @sSQL3='Select HV. *, ISNULL( Case When Signs  >=0 then ABS(HV. Amount) else 0 end , 0) AS TOTAL, 
		ISNULL(Case When Signs >=0  then abs(HV.Amount) else 0 end,0) AS ProductSalary from HV2555 HV'
		
--print @sSQL3
If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2550')
	exec('Create view HV2550 ---- tao boi HP2532
				as ' + @sSQL3)
else
	exec('Alter view HV2550 ---- tao boi HP2532
				as ' + @sSQL3)

*/
GO


