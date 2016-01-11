/****** Object:  StoredProcedure [dbo].[HP2534]    Script Date: 01/06/2012 10:18:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2534]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2534]
GO

/****** Object:  StoredProcedure [dbo].[HP2534]    Script Date: 01/06/2012 10:18:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


-----Created by Vo Thanh Huong, date: 27/04/2005
-----purpose: Xu ly so lieu in ngay cong thang + luong cong thang 

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2534] 
				@DivisionID NVARCHAR(50),
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
				@Allowance NVARCHAR(50), -- Phụ cấp
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
	Where AT1101.DivisionID = '''+@DivisionID+''' And AT1102.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
	isnull(HT1101.TeamID,'''') like isnull(''' + @TeamID + ''', '''')' 
--print @sDepartment

If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2575')
	exec('Create view HV2575 ---- tao boi HP2534
				as ' +@sDepartment)
else
	exec('Alter view HV2575 ---- tao boi HP2534
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
			LEFT join HV2575 T01 on T01.DivisionID = T00.DivisionID and T01.DepartmentID = T00.DepartmentID and isnull(T00.TeamID,'''') = isnull(T01.TeamID,'''')
			inner join HT2400 T02 on T02.DivisionID = T00.DivisionID  And T02.EmployeeID = T00.EmployeeID and T02.TranMonth = T00.TranMonth and
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

If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2576')
	Drop view HV2576
exec('Create view HV2576 ---- tao boi HP2534
			as ' + @sSQL)

Set @sSQL = ''
Set @cur = Cursor scroll keyset for
	Select T00.PayrollMethodID, T00.IncomeID , right(T00.IncomeID,2) as Orders , 1 as Signs, 1 as Displayed,
		--Case @gnLang When 0 Then 'Tieàn löông' Else 'Gross Pay' End as Notes,
		--Case @gnLang When 0 Then  'Tieàn löông' Else 'Gross Pay' End as Note1, T01.Caption
		@GrossPay as Notes,
		--Case @gnLang When 0 Then  'Tieàn löông' Else 'Gross Pay' End as Note1, T01.Caption
		@GrossPay as Note1, T01.Caption
	From HT5005  T00 inner join HT0002 T01 on T00.IncomeID = T01.IncomeID and T00.DivisionID = T01.DivisionID
	Where T00.DivisionID = @DivisionID And T00.PayrollMethodID in (Select Distinct PayrollMethodID From HV2576) 
	Union 	
	Select  T00.PayrollMethodID, T00.SubID as IncomeID, right(T00.SubID,2) as Orders , 1 as Signs,  2 as Displayed,
		--Case @gnLang When 0 Then 'Tieàn löông' Else 'Gross Pay' End as Notes,
		--Case @gnLang When 0 Then  'Giaûm tröø' Else 'Deduction' End as Note1, T01.Caption
		@GrossPay as Notes,
		@Deduction as Note1, T01.Caption
	From HT5006  T00 inner join HT0005 T01 on T00.SubID = T01.SubID and T00.DivisionID = T01.DivisionID
	Where T00.DivisionID = @DivisionID And T00.PayrollMethodID in (Select Distinct PayrollMethodID From HV2576) 	
	Union 
	Select Distinct T00.PayrollMethodID, 'S00' as IncomeID, 0 as Orders, 1 as Signs, 2 as Displayed,
		--Case @gnLang When 0 Then 'Tieàn löông' Else 'Gross Pay' End as Notes,
		--Case @gnLang When 0 Then  'Giaûm tröø' Else 'Deduction' End as Note1,
		--Case @gnLang When 0 Then 'Thueá TN' Else 'Income Tax' End as Caption
		@GrossPay as Notes,
		@Deduction as Note1,
		@IncomeTax as Caption
	From HT5006  T00 
	Where T00.DivisionID = @DivisionID And T00.PayrollMethodID in (Select Distinct PayrollMethodID From HV2576) 

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
		From HV2576   Where PayrollMethodID =''' + @PayrollMethodID + '''
		Union all' 		

	Fetch next from @cur into @PayrollMethodID, @IncomeID,  @Orders,@Signs ,@Displayed, @Notes,  @Note1, @Caption
End

--print @sSQL
--print 'a'
Set @sSQL = left(@sSQL, len(@sSQL) - 9)

set nocount off

If not Exists (Select top 1 1  From SysObjects Where Name ='HT2539' and Xtype ='U')

CREATE TABLE [dbo].[HT2539]  (
	[APK] [uniqueidentifier] NOT NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmployeeID] [nvarchar] (50) NOT NULL,
	[FullName] [nvarchar] (250) NULL, 
	[DepartmentID] [nvarchar] (50)  NULL,
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
	[Notes] [nvarchar] (250) NULL,
	[Note1] [nvarchar] (250) NULL,
	[IncomeID] [nvarchar] (50) NULL,
	[Signs]  [int] NULL,
	[Displayed] [int] NULL,
	[Amount] [decimal] (28, 8) NULL,
	[Caption] [nvarchar] (250) NULL,
	[FOrders]  [int] NULL,
	[a] [nvarchar] (50) NULL
		
	
) ON [PRIMARY]
Else
  Delete  HT2539


Exec ( 'Insert into HT2539  ( DivisionID, EmployeeID, FullName, DepartmentID, DepartmentName,  InsuranceSalary, 
				BaseSalary, Salary01, Salary02, Salary03,
				Orders, DutyName, TeamID, TeamName, WorkDate, Notes,  Note1, IncomeID, Signs,  Displayed,  Amount,  Caption,  FOrders , a)' + @sSQL)


/*

If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2595')
	Drop view HV2595
exec('Create view HV2595 ---- tao boi HP2534
			as ' + @sSQL)*/


--BUOC 2 
------------------------------------------------------------------------------------------------------TINH NGAY CONG THANG-----------------------------------------------------------------------------------------

Declare @sSQL6 as nvarchar(4000)
Set @sSQL6='SELECT HT5003.DivisionID, HT5003.GeneralAbsentID, HT5003.AbsentTypeID, Caption,  HT1013.Orders
	FROM ht5003 INNER JOIN ht5005 ON ht5005.GeneralAbsentID = ht5003.GeneralAbsentID and ht5005.DivisionID = ht5003.DivisionID 
	AND ht5005.PayrollMethodID ' + @lstPayrollMethodID + ' 
	 INNER JOIN HT1013 ON HT1013.AbsentTypeID = HT5003.AbsentTypeID and HT1013.DivisionID = HT5003.DivisionID
	
	UNION
	SELECT HT5003.DivisionID, HT5003.GeneralAbsentID, HT5003.AbsentTypeID, Caption, 
    	HT1013.Orders
	FROM ht5003 INNER JOIN ht5006 ON  ht5006.DivisionID = ht5003.DivisionID and ht5006.GeneralAbsentID = ht5003.GeneralAbsentID AND 
    	ht5006.PayrollMethodID ' + @lstPayrollMethodID + '  
    	INNER JOIN HT1013 ON HT1013.DivisionID = HT5003.DivisionID '

If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2577')
	Drop view HV2577
exec('Create view HV2577 ---- tao boi HP2534
			as ' + @sSQL6)


Set @sSQL=''
Set @sSQL='SELECT HT02.EmployeeID, HT02.DivisionID, v.FullName, v.DepartmentID,  v.DepartmentName, 
		avg(isnull(V.InsuranceSalary, 0)) as InsuranceSalary, avg(isnull(V.BaseSalary, 0)) as BaseSalary, 
		avg(isnull(V.Salary01, 0)) as Salary01, avg(isnull(V.Salary02, 0)) as Salary02, avg(isnull(V.Salary03, 0)) as Salary03,

		3 AS Orders, v.DutyName, v.TeamID, v.TeamName, v.WorkDate, N''' + @WorkingTime+ ''''
		--+ Case @gnLang When 0 Then '''Soá coâng'''  Else '''Working Time'''  End  
		+' AS Notes, N''' + @WorkingTime+ ''''
		--+ Case @gnLang  When 0 Then  '''Soá coâng'''   Else   '''Working Time'''   End 
		+' AS Note1, HT02.AbsentTypeID AS IncomeID, 
    		0 AS Signs, -1 AS Displayed, H2.Caption, 
    		21 AS FOrders, V.A AS PayrollMethodID , avg(HT02.AbsentAmount) as Amount

	FROM HT2402 HT02 INNER JOIN HT2539 V ON HT02.DivisionID = v.DivisionID AND HT02.DepartmentID = v.DepartmentID AND 
    	ISNULL (HT02.TeamID, '''') = ISNULL (V.TeamID, '''') AND HT02.EmployeeID = v.EmployeeID
	INNER JOIN HV2577  H2 ON HT02.DivisionID = H2.DivisionID  And HT02.AbsentTypeID = H2.AbsentTypeID 
	
	
	WHERE HT02.DivisionID = ''' + @DivisionID + ''' and
		HT02.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		isnull(HT02.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
		HT02.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
		HT02.TranMonth + ht02.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + ' and ' +  
		cast(@ToMonth + @ToYear*100 as nvarchar(10)) + '
	
	GROUP BY HT02.EmployeeID, HT02.DivisionID, v.FullName, v.DepartmentID, 
    	v.DepartmentName, v.DutyName, v.TeamID, 
   	 v.TeamName, v.WorkDate,HT02.AbsentTypeID, H2.Caption, H2.Orders, v.a   
	Having avg(HT02.AbsentAmount)<100            
	
	

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
    		22 AS FOrders, ''Basic Salary'' AS PayrollMethodID , avg(isnull(HV.BaseSalary, 0)) as Amount
		
	From HV2576 HV
		GROUP BY HV.EmployeeID, Hv.DivisionID, Hv.FullName, Hv.DepartmentID, 
    	Hv.DepartmentName,  Hv.DutyName, Hv.TeamID, 
   	 Hv.TeamName, Hv.WorkDate 

	Union SELECT distinct HV.EmployeeID, HV.DivisionID, HV.FullName, HV.DepartmentID,  HV.DepartmentName, 
		avg(isnull(HV.InsuranceSalary, 0)) as InsuranceSalary, avg(isnull(HV.BaseSalary, 0)) as BaseSalary, 
		avg(isnull(HV.Salary01, 0)) as Salary01, avg(isnull(HV.Salary02, 0)) as Salary02, avg(isnull(HV.Salary03, 0)) as Salary03,
		
		3 AS Orders, Hv.DutyName, Hv.TeamID, Hv.TeamName, hv.WorkDate,N''' + @Salary+ '''' 
		--+Case   @gnLang When 0 Then  '''Möùc löông'''    Else  ''' Salary'''   End
		+ ' AS Notes, N''' + @Salary+ '''' 
		--+Case   @gnLang  When 0 Then   '''Möùc löông'''    Else  '''Insur Salary'''   End
		+ '  AS Note1, N''' + @Allowance+ '''' 
		--+Case   @gnLang  When 0 Then   '''LBHXH'''   Else  '''Insur Salary'''   End 
		+ '  AS IncomeID, 
    		-1 AS Signs, -1 AS Displayed, N''' + @Allowance+ '''' 
		--+Case   @gnLang  When 0 Then   '''LBHXH'''   Else  '''Insur Salary'''   End 
		+ ' as Caption, 
		22 AS FOrders, ''Basic Salary'' AS PayrollMethodID , avg(isnull(HV.Salary01, 0)) as Amount
	From HV2576 HV
	GROUP BY HV.EmployeeID, Hv.DivisionID, Hv.FullName, Hv.DepartmentID, 
    	Hv.DepartmentName,  Hv.DutyName, Hv.TeamID, 
   	 Hv.TeamName, Hv.WorkDate
	 '

	
--print @sSQL


If not Exists (Select top 1 1  From SysObjects Where Name ='HT2540' and Xtype ='U')

CREATE TABLE [dbo].[HT2540]  (
	[APK] [uniqueidentifier] NOT NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmployeeID] [nvarchar] (50) NOT NULL,
	[FullName] [nvarchar] (250) NULL, 
	[DepartmentID] [nvarchar] (50)  NULL,
	[DepartmentName] [nvarchar] (250)  NULL, 
	[InsuranceSalary] [decimal] (28, 8)  NULL,	
	[BaseSalary] [decimal] (28, 8)  NULL,
	[Salary01] [decimal] (28, 8)  NULL,
	[Salary02]  [decimal] (28, 8) NULL ,
	[Salary03] [decimal] (28, 8) NULL ,
	[Orders] [int] NULL,
	[DutyName] [nvarchar] (250) NULL,
	[TeamID] [nvarchar] (50) NULL,
	[TeamName] [nvarchar] (250) NULL,
	[WorkDate] [datetime] NULL,
	[Notes] [nvarchar] (250) NULL,
	[Note1] [nvarchar] (250) NULL,
	[IncomeID] [nvarchar] (50) NULL,
	[Signs]  [int] NULL,
	[Displayed] [int] NULL,
	[Caption] [nvarchar] (250) NULL,
	[FOrders]  [int] NULL,
	[PayrollMethodID] [nvarchar] (50) NULL,
	[Amount] [decimal] (28, 8) NULL
		
	
) ON [PRIMARY]
Else
  Delete  HT2540


Exec ( 'Insert into HT2540  ( EmployeeID, DivisionID, FullName, DepartmentID, DepartmentName, InsuranceSalary, 
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
	FROM HT2539 Where DivisionID = '''+@DivisionID+'''
	
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
	
	FROM HT2539 Where DivisionID = '''+@DivisionID+'''

	GROUP BY DivisionID, EmployeeID  , FullName ,DepartmentID ,DepartmentName  ,InsuranceSalary , 
 		BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID , TeamName, WorkDate, A
	


	UNION 
		SELECT DivisionID, EmployeeID  , FullName ,DepartmentID ,DepartmentName ,  InsuranceSalary , 
	BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID ,TeamName,   WorkDate, Notes , Note1,
	IncomeID ,Signs , Displayed, Caption  , FOrders , PayrollMethodID  ,  Amount   
	FROM HT2540 Where DivisionID = '''+@DivisionID+''''

--print @sSQL2

If @IsChangeCurrency = 0----Neu khong doi ra loai tien khac

	Begin 
		If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2578')
			exec('Create view HV2578 ---- tao boi HP2534
				as ' + @sSQL2)
		else
			exec('Alter view HV2578 ---- tao boi HP2534
				as ' + @sSQL2)
	End
Else --doi ra loai tien khac

	Begin
	
		If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2579')
			exec('Create view HV2579 ---- tao boi HP2534
				as ' + @sSQL2)
		else
			exec('Alter view HV2579 ---- tao boi HP2534
				as ' + @sSQL2)

		Set @sSQL1='SELECT DivisionID, EmployeeID  , FullName ,DepartmentID ,DepartmentName ,   InsuranceSalary , 
				 BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID ,TeamName,  WorkDate, Notes , Note1,
 				IncomeID ,Signs , Displayed, Caption  , FOrders , PayrollMethodID  ,  Amount   
				FROM HV2579
				
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
				
 				HV2579
				Where IncomeID=''I21'' 
				GROUP BY DivisionID, EmployeeID  , FullName ,DepartmentID ,DepartmentName  ,InsuranceSalary , 
 				BaseSalary,Salary01,  Salary02 , Salary03   ,  Orders ,  DutyName  , TeamID , TeamName,  WorkDate, PayrollMethodID' 

	--Print @sSQL1
		If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2578')
			exec('Create view HV2578 ---- tao boi HP2534
				as ' + @sSQL1)
		else
			exec('Alter view HV2578 ---- tao boi HP2534
				as ' + @sSQL1)

	End
GO


