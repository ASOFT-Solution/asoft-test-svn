
/****** Object:  StoredProcedure [dbo].[HP2535]    Script Date: 01/06/2012 10:58:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2535]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2535]
GO


/****** Object:  StoredProcedure [dbo].[HP2535]    Script Date: 01/06/2012 10:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


-----Created by Vo Thanh Huong, date: 27/04/2005
-----purpose: Xu ly so lieu in ngay cong thang + luong cong thang theo phong ban

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2535] @DivisionID NVARCHAR(50),
				@FromDepartmentID NVARCHAR(50),
				@ToDepartmentID NVARCHAR(50),
				@TeamID NVARCHAR(50),
				@FromEmployeeID NVARCHAR(50), 
				@ToEmployeeID NVARCHAR(50), 
				@GrossPay NVARCHAR(50),
				@Deduction NVARCHAR(50),
				@IncomeTax NVARCHAR(50),
				@WorkingTime NVARCHAR(50),
				@Salary NVARCHAR(50),
				@BasicSalary NVARCHAR(50),
				@InsurSalary NVARCHAR(50),
				@NetPay NVARCHAR(50),
				@FromYear int,
				@FromMonth int,				
				@ToYear int,
				@ToMonth int,				
				@PayrollMethodID1 nvarchar(4000),
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
	LEFT JOIN HT1101 ON AT1102.DepartmentID = HT1101.DepartmentID And AT1102.DivisionID = HT1101.DivisionID
	Where AT1102.DivisionID = '''+@DivisionID+''' And AT1102.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
	isnull(HT1101.TeamID,'''') like isnull(''' + @TeamID + ''', '''')' 
--print @sDepartment

If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2580')
	exec('Create view HV2580 ---- tao boi HP2535
				as ' +@sDepartment)
else
	exec('Alter view HV2580 ---- tao boi HP2535
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
		Select @Currency= CurrencyID From HT5000 Where PayrollMethodID=@PayrollMethodID1 and DivisionID=@DivisionID
		If  @Currency='VND' 
			Set @Currency1='USD' 
		else 
			Set @Currency1='VND'

	End

Select @sSQL = '',  @Orders = 1

Set @sSQL = 'Select COUNT(T00.EmployeeID) as Num, T00.DivisionID, T00.DepartmentID, V00.DepartmentName, PayrollMethodID, 
		isnull(T00.TeamID,'''') as TeamID, isnull(T01.TeamName,'''') as TeamName,
		sum(isnull(T02.InsuranceSalary, 0)) as InsuranceSalary, sum(isnull(T02.BaseSalary, 0)) as BaseSalary, 
		sum(isnull(T02.Salary01, 0)) as Salary01, sum(isnull(T02.Salary02, 0)) as Salary02, sum(isnull(T02.Salary03, 0)) as Salary03,
		
		sum(isnull(Income01,0)) as Income01,  sum(isnull(Income02, 0)) as Income02, sum(isnull(Income03, 0)) as Income03, 
		sum(isnull(Income04, 0)) as Income04, 
		sum(isnull(Income05, 0)) as Income05, sum(isnull(Income06, 0)) as Income06, sum(isnull(Income07, 0)) as Income07,
		sum(isnull(Income08, 0)) as Income08, sum(isnull(Income09, 0)) as Income09, sum(isnull(Income10, 0)) as Income10,
		sum(isnull(SubAmount01, 0)) as SubAmount01,  sum(isnull(SubAmount02, 0)) as SubAmount02,  sum(isnull(SubAmount03, 0)) as SubAmount03, 
		sum(isnull(SubAmount04, 0)) as SubAmount04, sum(isnull(SubAmount05, 0)) as SubAmount05,  sum(isnull(SubAmount06, 0)) as SubAmount06, 
		sum(isnull(SubAmount07, 0)) as SubAmount07, sum(isnull(SubAmount08, 0)) as SubAmount08,  sum(isnull(SubAmount09, 0)) as SubAmount09, 

		sum(isnull(SubAmount10, 0)) as SubAmount10 , sum(isnull(TaxAmount, 0)) as SubAmount00

		
	From HT3400 T00  inner join HV1400 V00 on  V00.EmployeeID = T00.EmployeeID and T00.DivisionID=V00.DivisionID
			LEFT join HV2575 T01 on T01.DivisionID = T00.DivisionID and T01.DepartmentID = T00.DepartmentID and isnull(T00.TeamID,'''') = isnull(T01.TeamID,'''')
			inner join HT2400 T02 on T02.DivisionID = T00.DivisionID And T02.EmployeeID = T00.EmployeeID and T02.TranMonth = T00.TranMonth and
						T02.TranYear = T00.TranYear 
	Where T00.DivisionID = ''' + @DivisionID + ''' and
		T00.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		isnull(T00.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
		T00.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
		T00.TranMonth + T00.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + ' and ' +  
		cast(@ToMonth + @ToYear*100 as nvarchar(10)) + ' and
		PayrollMethodID ' + @lstPayrollMethodID + ' 
	Group by T00.DivisionID, T00.DepartmentID, V00.DepartmentName, PayrollMethodID, 
		 isnull(T00.TeamID,''''), isnull(T01.TeamName,'''') '
---print @sSQL

If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2581')
	Drop view HV2581
exec('Create view HV2581 ---- tao boi HP2535
			as ' + @sSQL)

Set @sSQL = ''
Set @cur = Cursor scroll keyset for
	Select T00.PayrollMethodID, T00.IncomeID , right(T00.IncomeID,2) as Orders , 1 as Signs, 1 as Displayed,
		--Case @gnLang When 0 Then 'Tieàn löông' Else 'Gross Pay' End as Notes,
		--Case @gnLang When 0 Then  'Tieàn löông' Else 'Gross Pay' End as Note1, T01.Caption
		@GrossPay as Notes,
		@GrossPay as Note1, T01.Caption
	From HT5005  T00 inner join HT0002 T01 on T00.IncomeID = T01.IncomeID and T00.DivisionID = T01.DivisionID
	Where T00.DivisionID = @DivisionID And T00.PayrollMethodID in (Select Distinct PayrollMethodID From HV2581) 
	Union 	
	Select  T00.PayrollMethodID, T00.SubID as IncomeID, right(T00.SubID,2) as Orders , 1 as Signs,  2 as Displayed,
		--Case @gnLang When 0 Then 'Tieàn löông' Else 'Gross Pay' End as Notes,
		--Case @gnLang When 0 Then  'Giaûm tröø' Else 'Deduction' End as Note1, T01.Caption
		@GrossPay as Notes,
		@Deduction as Note1, T01.Caption
	From HT5006  T00 inner join HT0005 T01 on T00.SubID = T01.SubID and T00.DivisionID = T01.DivisionID
	Where T00.DivisionID = @DivisionID And T00.PayrollMethodID in (Select Distinct PayrollMethodID From HV2581) 	
	Union 
	Select Distinct T00.PayrollMethodID, 'S00' as IncomeID, 0 as Orders, 1 as Signs, 2 as Displayed,
		--Case @gnLang When 0 Then 'Tieàn löông' Else 'Gross Pay' End as Notes,
		--Case @gnLang When 0 Then  'Giaûm tröø' Else 'Deduction' End as Note1,
		--Case @gnLang When 0 Then 'Thueá TN' Else 'Income Tax' End as Caption
		@GrossPay as Notes,
		@Deduction as Note1,
		@IncomeTax as Caption
	From HT5006  T00 
	Where T00.DivisionID = @DivisionID And T00.PayrollMethodID in (Select Distinct PayrollMethodID From HV2581) 

Open @cur
Fetch next from @cur into @PayrollMethodID, @IncomeID, @Orders, @Signs, @Displayed, @Notes,  @Note1, @Caption

While @@FETCH_STATUS = 0 
Begin
	Set @sSQL = @sSQL + ' Select  Num, DivisionID, DepartmentID, DepartmentName,   InsuranceSalary, 
				BaseSalary, Salary01, Salary02, Salary03,
				TeamID, TeamName,  N''' + @Notes + ''' as Notes,  N'''  + @Note1 + ''' as Note1, N''' + @IncomeID + ''' as IncomeID,' + 
			cast(@Signs as nvarchar(50)) + ' as Signs, '  +
			cast(@Displayed as nvarchar(50)) + ' as Displayed, ' +
			+ case when @Displayed  = 1 then 'Income'  else '-SubAmount' end + 
			case when @Orders < 10 then '0' end + cast(@Orders as NVARCHAR(50)) + '  as Amount,  N'''+  @Caption + ''' as  Caption, '
			+ cast(@Orders as nvarchar(2)) + ' as FOrders  , ''' +  @PayrollMethodID + ''' as a
		From HV2581   Where PayrollMethodID =''' + @PayrollMethodID + '''
		Union all' 		

	Fetch next from @cur into @PayrollMethodID, @IncomeID,  @Orders,@Signs ,@Displayed, @Notes,  @Note1, @Caption
End
Set @sSQL = left(@sSQL, len(@sSQL) - 9)

---print @sSQL

set nocount off

If not Exists (Select top 1 1  From SysObjects Where Name ='HT2541' and Xtype ='U')

CREATE TABLE [dbo].[HT2541]  (
	[APK] [uniqueidentifier] NOT NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[Num] [decimal] (28, 8) NULL,
	[DepartmentID] [varchar] (20)  NULL,
	[DepartmentName] [varchar] (100)  NULL, 
	[InsuranceSalary] [decimal] (28, 8)  NULL,	
	[BaseSalary] [decimal] (28, 8)  NULL,
	[Salary01] [decimal] (28, 8)  NULL,
	[Salary02]  [decimal] (28, 8) NULL ,
	[Salary03] [decimal] (28, 8) NULL ,
	[TeamID] [varchar] (20) NULL,
	[TeamName] [varchar] (200) NULL,
	[Notes] [varchar] (200) NULL,
	[Note1] [varchar] (200) NULL,
	[IncomeID] [varchar] (20) NULL,
	[Signs]  [int] NULL,
	[Displayed] [int] NULL,
	[Amount] [decimal] (28, 8) NULL,
	[Caption] [varchar] (200) NULL,
	[FOrders]  [int] NULL,
	[a] [varchar] (20) NULL
		
	
) ON [PRIMARY]
Else
  Delete  HT2541


Exec ( 'Insert into HT2541  (  Num, DivisionID, DepartmentID, DepartmentName,  InsuranceSalary, 
				BaseSalary, Salary01, Salary02, Salary03,
				 TeamID, TeamName,  Notes,  Note1, IncomeID, Signs,  Displayed,  Amount,  Caption,  FOrders , a)' + @sSQL)

--BUOC 2
------------------------------------------------------------------------------------------------------TINH NGAY CONG THANG-----------------------------------------------------------------------------------------

Declare @sSQL6 as nvarchar(4000)
Set @sSQL6='SELECT HT5003.DivisionID, HT5003.GeneralAbsentID, HT5003.AbsentTypeID, Caption,  HT1013.Orders
	FROM ht5003 INNER JOIN ht5005 ON ht5005.GeneralAbsentID = ht5003.GeneralAbsentID and ht5005.DivisionID = ht5003.DivisionID 
	AND ht5005.PayrollMethodID ' + @lstPayrollMethodID + ' 
	 INNER JOIN HT1013 ON HT1013.AbsentTypeID = HT5003.AbsentTypeID and HT1013.DivisionID = HT5003.DivisionID
	 Where ht5003.DivisionID = '''+@DivisionID+'''
	
	UNION
	SELECT HT5003.DivisionID, HT5003.GeneralAbsentID, HT5003.AbsentTypeID, Caption, 
    	HT1013.Orders
	FROM ht5003 INNER JOIN ht5006 ON ht5006.DivisionID = ht5003.DivisionID And ht5006.GeneralAbsentID = ht5003.GeneralAbsentID AND ht5006.PayrollMethodID ' + @lstPayrollMethodID + '  
    	INNER JOIN HT1013 ON HT1013.AbsentTypeID = HT5003.AbsentTypeID and HT1013.DivisionID = HT5003.DivisionID 
    	Where ht5003.DivisionID = '''+@DivisionID+''' '

If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2582')
	Drop view HV2582
exec('Create view HV2582 ---- tao boi HP2535
			as ' + @sSQL6)


Set @sSQL=''
Set @sSQL='SELECT V.Num, V.DivisionID, v.DepartmentID,  v.DepartmentName, 
		sum(isnull(V.InsuranceSalary, 0)) as InsuranceSalary, sum(isnull(V.BaseSalary, 0)) as BaseSalary, 
		sum(isnull(V.Salary01, 0)) as Salary01, sum(isnull(V.Salary02, 0)) as Salary02, sum(isnull(V.Salary03, 0)) as Salary03,

		 v.TeamID, v.TeamName, N''' + @WorkingTime+ ''''
		--+ Case @gnLang When 0 Then '''Soá coâng'''  Else '''Working Time'''  End  		
		--+ Case @gnLang  When 0 Then  '''Soá coâng'''   Else   '''Working Time'''   End 
		+' AS Notes, N''' + @WorkingTime+ ''''
		+' AS Note1, HT02.AbsentTypeID AS IncomeID, 
    		0 AS Signs, -1 AS Displayed, H2.Caption, 
    		21 AS FOrders, V.A AS PayrollMethodID , avg(HT02.AbsentAmount) as Amount

	FROM HT2402 HT02 INNER JOIN HT2541 V ON HT02.DivisionID = v.DivisionID And HT02.DepartmentID = v.DepartmentID AND ISNULL (HT02.TeamID, '''') = ISNULL (V.TeamID, '''') 
	INNER JOIN HV2577  H2 ON HT02.AbsentTypeID = H2.AbsentTypeID and HT02.DivisionID = H2.DivisionID 
	
	
	WHERE HT02.DivisionID = ''' + @DivisionID + ''' and
		HT02.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		isnull(HT02.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
		HT02.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
		HT02.TranMonth + ht02.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + ' and ' +  
		cast(@ToMonth + @ToYear*100 as nvarchar(10)) + '
	
	GROUP BY  V. Num,V.DivisionID, v.DepartmentID, 
    	v.DepartmentName, v.TeamID, 
   	 v.TeamName,HT02.AbsentTypeID, H2.Caption, v.a               
	
	
	Union SELECT HV.Num,  HV.DivisionID, HV.DepartmentID,  HV.DepartmentName, 
		sum(isnull(HV.InsuranceSalary, 0)) as InsuranceSalary, sum(isnull(HV.BaseSalary, 0)) as BaseSalary, 
		sum(isnull(HV.Salary01, 0)) as Salary01, sum(isnull(HV.Salary02, 0)) as Salary02, sum(isnull(HV.Salary03, 0)) as Salary03,

		 Hv.TeamID, Hv.TeamName,, N''' + @Salary+ '''' 
		--+Case   @gnLang When 0 Then  '''Möùc löông'''    Else  '''Basic Salary'''   End
		+ ' AS Notes, N''' + @Salary+ '''' 
		--+Case   @gnLang  When 0 Then   '''Möùc löông'''    Else  '''Basic Salary'''   End
		+ '  AS Note1, N''' + @BasicSalary+ '''' 
		--+Case   @gnLang  When 0 Then   '''LCB'''   Else  '''Basic Salary'''   End 
		+ '  AS IncomeID, 
    		-1 AS Signs, -2 AS Displayed, N''' + @BasicSalary+ '''' 
    	--+Case   @gnLang  When 0 Then   '''LCB'''   Else  '''Basic Salary'''   End 
		+ ' as Caption, 
    		22 AS FOrders, N''' + @BasicSalary + ' AS PayrollMethodID , sum(isnull(HV.BaseSalary, 0)) as Amount
	From HV2581 HV
		
	GROUP BY HV.Num, Hv.DivisionID, Hv.DepartmentID, Hv.DepartmentName, Hv.TeamID,  Hv.TeamName

	Union SELECT HV.Num, HV.DivisionID, HV.DepartmentID,  HV.DepartmentName, 
		avg(isnull(HV.InsuranceSalary, 0)) as InsuranceSalary, avg(isnull(HV.BaseSalary, 0)) as BaseSalary, 
		avg(isnull(HV.Salary01, 0)) as Salary01, avg(isnull(HV.Salary02, 0)) as Salary02, avg(isnull(HV.Salary03, 0)) as Salary03,

		 Hv.TeamID, Hv.TeamName, N''' + @Salary+ '''' 
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
	From HV2581 HV
	
	GROUP BY HV.Num, HV.DivisionID, Hv.DepartmentID, Hv.DepartmentName,   Hv.TeamID,  Hv.TeamName '

--print @sSQL


If not Exists (Select top 1 1  From SysObjects Where Name ='HT2542' and Xtype ='U')

CREATE TABLE [dbo].[HT2542]  (
	[APK] [uniqueidentifier] NOT NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[Num] [decimal] (28, 8) NULL,
	[DepartmentID] [varchar] (20)  NULL,
	[DepartmentName] [varchar] (100)  NULL, 
	[InsuranceSalary] [decimal] (28, 8)  NULL,	
	[BaseSalary] [decimal] (28, 8)  NULL,
	[Salary01] [decimal] (28, 8)  NULL,
	[Salary02]  [decimal] (28, 8) NULL ,
	[Salary03] [decimal] (28, 8) NULL ,
	[TeamID] [varchar] (20) NULL,
	[TeamName] [varchar] (200) NULL,
	[Notes] [varchar] (200) NULL,
	[Note1] [varchar] (200) NULL,
	[IncomeID] [varchar] (20) NULL,
	[Signs]  [int] NULL,
	[Displayed] [int] NULL,
	[Caption] [varchar] (200) NULL,
	[FOrders]  [int] NULL,
	[PayrollMethodID] [varchar] (20) NULL,
	[Amount] [decimal] (28, 8) NULL
		
	
) ON [PRIMARY]
Else
  Delete  HT2542


Exec ( 'Insert into HT2542  ( Num, DivisionID, DepartmentID, DepartmentName, InsuranceSalary, 
				BaseSalary, Salary01, Salary02, Salary03,
				 TeamID, TeamName, Notes, Note1,IncomeID, Signs,  Displayed,  Caption,  FOrders , PayrollMethodID, Amount)' + @sSQL)




----BUOC 4
----------------------------------------------------------------------------- KET HOP LUONG THANG VA NGAY CONG THANG--------------------------------------------
Declare @sSQL1 nvarchar(4000),
	@sSQL2 nvarchar(4000)
	
	
set @sSQL2='SELECT Num, DivisionID, DepartmentID ,DepartmentName ,  InsuranceSalary , 
	BaseSalary,Salary01,  Salary02 , Salary03   ,  TeamID , TeamName,
 	Notes , Note1, IncomeID ,Signs , Displayed,
 	Caption  , FOrders , A AS PayrollMethodID , Amount      
	FROM HT2541 Where DivisionID = '''+@DivisionID+'''
	
	UNION Select Num,DivisionID, DepartmentID ,DepartmentName ,  InsuranceSalary , 
		 BaseSalary,Salary01,  Salary02 , Salary03   ,    TeamID ,TeamName, N''' + @NetPay+ ''' '''+ @Currency + ''' '
		 --+ Case  @gnLang  When 0 Then '''Thöïc laõnh ' +  @Currency + ''' ' Else '''Net Pay  ' +  @Currency + ''' 'End  
		 
		 + ' as Notes , N''' + @NetPay+ ''' '
		 +  ' ''' + @Currency + ''' '
		 --+Case  @gnLang  When 0 Then '''Thöïc laõnh ' +  @Currency + ''' '  Else '''Net Pay ' +  @Currency + ''' ' End  
		+ ' as Note1, ''I21'' as IncomeID , 2 as Signs , 0 as Displayed, N''' + @NetPay+ ''''
		+  ' ''' + @Currency + ''' '
		--+Case  @gnLang  When 0 Then '''Thöïc laõnh ' +  @Currency + ''' '  Else '''Net Pay ' +  @Currency + ''' ' End  
		+' as Caption  , 15 as FOrders , A as PayrollMethodID  ,  sum(Amount) as Amount   
	
	FROM HT2541 Where DivisionID = '''+@DivisionID+'''

	GROUP BY Num, DivisionID, DepartmentID ,DepartmentName  ,InsuranceSalary , 
 		BaseSalary,Salary01,  Salary02 , Salary03   , TeamID , TeamName,  A
	


	UNION 
		SELECT Num, DivisionID, DepartmentID ,DepartmentName ,  InsuranceSalary , 
	BaseSalary,Salary01,  Salary02 , Salary03   ,  TeamID ,TeamName,   Notes , Note1,
	IncomeID ,Signs , Displayed, Caption  , FOrders , PayrollMethodID  ,  Amount   
	FROM HT2542 Where DivisionID = '''+@DivisionID+''''

--print @sSQL2

If @IsChangeCurrency = 0----Neu khong doi ra loai tien khac

	Begin 
		If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2582')
			exec('Create view HV2582 ---- tao boi HP2535
				as ' + @sSQL2)
		else
			exec('Alter view HV2582 ---- tao boi HP2535
				as ' + @sSQL2)
	End
Else --doi ra loai tien khac

	Begin
	
		If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2583')
			exec('Create view HV2583 ---- tao boi HP2535
				as ' + @sSQL2)
		else
			exec('Alter view HV2583 ---- tao boi HP2535
				as ' + @sSQL2)

		Set @sSQL1='SELECT Num, DivisionID, DepartmentID ,DepartmentName ,   InsuranceSalary , 
				 BaseSalary,Salary01,  Salary02 , Salary03  , TeamID ,TeamName,  Notes , Note1,
 				IncomeID ,Signs , Displayed, Caption  , FOrders , PayrollMethodID  ,  Amount   
				FROM HV2583
				
				UNION 
				SELECT Num, DivisionID, DepartmentID ,DepartmentName ,   InsuranceSalary , 
				 BaseSalary,Salary01,  Salary02 , Salary03   , TeamID ,TeamName,   N''' + @NetPay+ ''' ''' + @Currency + ''' '
				--+ Case  @gnLang  When 0 Then '''Thöïc laõnh'''   Else '''Net Pay ' +  @Currency + ''' '  End 
				+ '   as Notes , N''' + @NetPay+ '''' 
				+  ' ''' + @Currency + ''' '
				--+Case  @gnLang  When 0 Then '''Thöïc laõnh'''  Else '''Net Pay ' +  @Currency + ''' '  End  
				+ ' as Note1, ''I22'' as IncomeID , 3 as Signs , 0 as Displayed, N''' + @NetPay+ ''''
				+  ' ''' + @Currency + ''' '
				--+Case  @gnLang  When 0 Then '''Thöïc laõnh'''  Else '''Net Pay ' +  @Currency + ''' ' End  
				+ ' as Caption  , 16 as FOrders ,  PayrollMethodID  , '  + 
				Case @Currency When 'USD' Then  + Str(@RateExchange)+ '* sum(Amount)  ' Else 'sum(Amount) ' End +' As Amount
				From HV2583
				Where IncomeID=''I21'' 
				GROUP BY Num,  DivisionID, DepartmentID ,DepartmentName  ,InsuranceSalary , 
 				BaseSalary,Salary01,  Salary02 , Salary03    , TeamID , TeamName,   PayrollMethodID' 

	--Print @sSQL1
		If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2582')
			exec('Create view HV2582 ---- tao boi HP2535
				as ' + @sSQL1)
		else
			exec('Alter view HV2582 ---- tao boi HP2535
				as ' + @sSQL1)

	End
GO


