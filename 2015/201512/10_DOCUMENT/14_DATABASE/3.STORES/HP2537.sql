
/****** Object:  StoredProcedure [dbo].[HP2537]    Script Date: 01/06/2012 11:57:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2537]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2537]
GO


/****** Object:  StoredProcedure [dbo].[HP2537]    Script Date: 01/06/2012 11:57:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


-----Date: 25/08/2005
-----Purpose: Xu ly so lieu in luong cong thang + luong san pham khong su dung report crosstab cho SITC, Thinh Phat
-----Notes: Col01 den Col20 al cac khoan thu nhap; Col21 den Col40 la cac khoan giam tru; Col41 den Col54 la ngay cong; Col55 la luong san pham
---Caption HV2590 gom ten cac khoan thu nhap giam tru, ten ngay cong dong bo voi so lieu HV2589 (view ket qua cuoi cung)

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2537] @DivisionID NVARCHAR(50),
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
				@gnLang int,
				@IsChangeCurrency int		
AS
Declare @sSQL nvarchar(4000), 
	@ssSQL as nvarchar(4000),
	@cur cursor,
	@Caption nvarchar(100),
	@Orders int,
	@IncomeID NVARCHAR(50),
	@PayrollMethodID nvarchar(500),
	@Column int,
	@A as NVARCHAR(50),
	@TOrders as int,
	@Payroll as NVARCHAR(50),
	@sDepartment nvarchar(4000),
	@Counter as nvarchar(200),
	@Currency NVARCHAR(50),
	@Currency1 NVARCHAR(50),
	@RateExchange decimal (28, 8),
	@Pos as tinyint

-----------------------------------------------PHONG BAN, TO NHOM CAN IN LUONG---------------------------------------------------------------------

Set @sDepartment='SELECT AT1101.DivisionID, AT1102.DepartmentID, AT1102.DepartmentName, HT1101.TeamID, HT1101.TeamName
	FROM AT1101 LEFT JOIN AT1102 ON AT1101.DivisionID = AT1102.DivisionID 
	LEFT JOIN HT1101 ON AT1102.DepartmentID = HT1101.DepartmentID and AT1102.DivisionID = HT1101.DivisionID
	Where AT1101.DivisionID = '''+@DivisionID+''' And AT1102.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
	isnull(HT1101.TeamID,'''') like isnull(''' + @TeamID + ''', '''')' 
--print @sDepartment

If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2584')
	exec('Create view HV2584 ---- tao boi HP2537
				as ' +@sDepartment)
else
	exec('Alter view HV2584 ---- tao boi HP2537
				as ' + @sDepartment)
		
---------------------------------------------------------------------------------------------IN LUONG THANG----------------------------------------------------------------------------------------------------------

Set @Payroll= @lstPayrollMethodID
Set @lstPayrollMethodID = case when @lstPayrollMethodID = '%' then  ' like ''' + @lstPayrollMethodID + ''''  else ' in (''' + replace(@lstPayrollMethodID, ',',''',''') + ''')' end 
Set @Pos=PATINDEX('%,%', @Payroll)

If @Pos <>0 --Or  @Payroll = '%'-----neu in theo nhieu PP tinh luong 
	Begin
	Set @RateExchange=1
	Set @Currency='VND'
	Set @Currency1='USD'
	End
	
Else
	Begin
		Select @RateExchange= RateExchange From HT0000 Where DivisionID=@DivisionID
		Select @Currency= CurrencyID From HT5000 Where PayrollMethodID=@Payroll  and DivisionID=@DivisionID
		If  @Currency='VND'  
			Set @Currency1='USD' 
		else 
			Set @Currency1='VND'
		
	End

Select @sSQL=''

Set @sSQL= 'Select T00.DivisionID, T00.EmployeeID, FullName, T00.DepartmentID, V00.DepartmentName, 
		avg(isnull(T02.InsuranceSalary, 0)) as InsuranceSalary, avg(isnull(T02.BaseSalary, 0)) as BaseSalary, 
		avg(isnull(T02.Salary01, 0)) as Salary01, avg(isnull(T02.Salary02, 0)) as Salary02, avg(isnull(T02.Salary03, 0)) as Salary03, 
		V00.Orders as Orders, isnull(DutyName,'''') as DutyName, isnull(T00.TeamID,'''') as TeamID, 
		isnull(T01.TeamName,'''') as TeamName,PayrollMethodID, 
		
		 avg(isnull(TaxAmount,0)) as Col00,avg(isnull(Income01,0)) as Col01,  avg(isnull(Income02, 0)) as Col02, avg(isnull(Income03, 0)) as Col03, 
		avg(isnull(Income04, 0)) as Col04, 
		avg(isnull(Income05, 0)) as Col05, avg(isnull(Income06, 0)) as Col06, avg(isnull(Income07, 0)) as Col07,
		avg(isnull(Income08, 0)) as Col08, avg(isnull(Income09, 0)) as Col09, avg(isnull(Income10, 0)) as Col10,

		avg(isnull(Income11,0)) as Col11,  avg(isnull(Income12, 0)) as Col12, avg(isnull(Income13, 0)) as Col13, 
		avg(isnull(Income14, 0)) as Col14, 
		avg(isnull(Income15, 0)) as Col15, avg(isnull(Income16, 0)) as Col16, avg(isnull(Income17, 0)) as Col17,
		avg(isnull(Income18, 0)) as Col18, avg(isnull(Income09, 0)) as Col19, avg(isnull(Income20, 0)) as Col20,


		avg(isnull(SubAmount01, 0)) as Col21,  avg(isnull(SubAmount02, 0)) as Col22,  avg(isnull(SubAmount03, 0)) as Col23, 
		avg(isnull(SubAmount04, 0)) as Col24, avg(isnull(SubAmount05, 0)) as Col25,  avg(isnull(SubAmount06, 0)) as Col26, 
		avg(isnull(SubAmount07, 0)) as Col27, avg(isnull(SubAmount08, 0)) as Col28,  avg(isnull(SubAmount09, 0)) as Col29, 
		avg(isnull(SubAmount10, 0)) as Col30,
		
		avg(isnull(SubAmount11, 0)) as Col31,  avg(isnull(SubAmount12, 0)) as Col32,  avg(isnull(SubAmount13, 0)) as Col33, 
		avg(isnull(SubAmount14, 0)) as Col34, avg(isnull(SubAmount15, 0)) as Col35,  avg(isnull(SubAmount16, 0)) as Col36, 
		avg(isnull(SubAmount17, 0)) as Col37, avg(isnull(SubAmount18, 0)) as Col38,  avg(isnull(SubAmount19, 0)) as Col39, 
		avg(isnull(SubAmount20, 0)) as Col40, '

		
Set @ssSQL='avg(IsNull(Income01,0)+ IsNull(Income02,0) + IsNull(Income03,0) + IsNull(Income04,0) + IsNull(Income05,0) + IsNull(Income06,0) +
		IsNull(Income07,0) + IsNull(Income08,0) + IsNull(Income09,0) + IsNull(Income10,0)  + 
		IsNull(Income11,0)+ IsNull(Income12,0) + IsNull(Income13,0) + IsNull(Income14,0) + IsNull(Income15,0) + IsNull(Income16,0) +
		IsNull(Income17,0) + IsNull(Income18,0) + IsNull(Income19,0) + IsNull(Income20,0)  -IsNull(TaxAmount,0)-
		IsNull(SubAmount11,0)- IsNull(SubAmount12,0) - IsNull(SubAmount13,0) - IsNull(SubAmount14,0) - IsNull(SubAmount15,0) -
		 IsNull(SubAmount16,0) - IsNull(SubAmount17,0) - IsNull(SubAmount18,0) - IsNull(SubAmount19,0) - IsNull(SubAmount20,0)  -
		IsNull(SubAmount01,0)- IsNull(SubAmount02,0) - IsNull(SubAmount03,0) - IsNull(SubAmount04,0) - IsNull(SubAmount05,0) -
		 IsNull(SubAmount06,0) - IsNull(SubAmount07,0) - IsNull(SubAmount08,0) - IsNull(SubAmount09,0) - IsNull(SubAmount10,0) ) as Totals

	From HT3400 T00  inner join HV1400 V00 on  V00.EmployeeID = T00.EmployeeID and V00.DivisionID = T00.DivisionID 
			left join HV2584 T01 on T01.DivisionID = T00.DivisionID and T01.DepartmentID = T00.DepartmentID and isnull(T00.TeamID,'''') = isnull(T01.TeamID,'''')
			inner join HT2400 T02 on T02.DivisionID = T00.DivisionID And T02.EmployeeID = T00.EmployeeID and T02.TranMonth = T00.TranMonth and
						T02.TranYear = T00.TranYear 
	Where T00.DivisionID = ''' + @DivisionID + ''' and
		T00.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		isnull(T00.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
		T00.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
		T00.TranMonth + T00.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + ' and ' +  
		cast(@ToMonth + @ToYear*100 as nvarchar(10)) + ' and
		PayrollMethodID ' + @lstPayrollMethodID + ' 
	Group by T00.DivisionID, T00.EmployeeID, FullName, T00.DepartmentID, V00.DepartmentName,PayrollMethodID, 
		V00.Orders, isnull(DutyName,''''), isnull(T00.TeamID,''''), isnull(T01.TeamName,'''')   '



--View tong hop cac khoan thu nhap giam tru HV2591
--print @sSQL+@ssSQL


If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2591')
	exec('Create view HV2591 ---- tao boi HP2537
				as ' + @sSQL+@ssSQL)
else
	exec('Alter view HV2591 ---- tao boi HP2537
				as ' + @sSQL+@ssSQL)
/*

If not Exists (Select top 1 1  From SysObjects Where Name ='HT2543' and Xtype ='U')

CREATE TABLE [dbo].[HT2543]  (
	[EmployeeID] [varchar] (20) NOT NULL,
	[FullName] [varchar] (200) NULL, 
	[DepartmentID] [varchar] (20)  NULL,
	[DepartmentName] [varchar] (100)  NULL,
	[InsuranceSalary] [decimal] (28, 8)  NULL,	
	[BaseSalary] [decimal] (28, 8)  NULL,
	[Salary01] [decimal] (28, 8)  NULL,
	[Salary02]  [decimal] (28, 8) NULL ,
	[Salary03] [decimal] (28, 8) NULL ,
	[Orders] [int] NULL,
	[DutyName] [varchar] (20) NULL,
	[TeamID] [varchar] (20) NULL,
	[TeamName] [varchar] (200) NULL,
	[PayrollMethodID] [varchar] (20) NULL,	
	[Col01] [decimal] (28, 8) NULL,
	[Col02] [decimal] (28, 8) NULL,
	[Col03] [decimal] (28, 8) NULL,
	[Col04] [decimal] (28, 8) NULL,
	[Col05] [decimal] (28, 8) NULL,
	[Col06] [decimal] (28, 8) NULL,
	[Col07] [decimal] (28, 8) NULL,
	[Col08] [decimal] (28, 8) NULL,
	[Col09] [decimal] (28, 8) NULL,
	[Col10] [decimal] (28, 8) NULL,
	[Col11] [decimal] (28, 8) NULL,
	[Col12] [decimal] (28, 8) NULL,
	[Col13] [decimal] (28, 8) NULL,
	[Col14] [decimal] (28, 8) NULL,
	[Col15] [decimal] (28, 8) NULL,
	[Col16] [decimal] (28, 8) NULL,
	[Col17] [decimal] (28, 8) NULL,
	[Col18] [decimal] (28, 8) NULL,
	[Col19] [decimal] (28, 8) NULL,
	[Col20] [decimal] (28, 8) NULL,
	[Col21] [decimal] (28, 8) NULL,
	[Col22] [decimal] (28, 8) NULL,
	[Col23] [decimal] (28, 8) NULL,
	[Col24] [decimal] (28, 8) NULL,
	[Col25] [decimal] (28, 8) NULL,
	[Col26] [decimal] (28, 8) NULL,
	[Col27] [decimal] (28, 8) NULL,
	[Col28] [decimal] (28, 8) NULL,
	[Col29] [decimal] (28, 8) NULL,
	[Col30] [decimal] (28, 8) NULL,
	[Col31] [decimal] (28, 8) NULL,
	[Col32] [decimal] (28, 8) NULL,
	[Col33] [decimal] (28, 8) NULL,
	[Col34] [decimal] (28, 8) NULL,
	[Col35] [decimal] (28, 8) NULL,
	[Col36] [decimal] (28, 8) NULL,
	[Col37] [decimal] (28, 8) NULL,
	[Col38] [decimal] (28, 8) NULL,
	[Col39] [decimal] (28, 8) NULL,
	[Col40] [decimal] (28, 8) NULL,
	[Totals] [decimal] (28, 8) NULL
		
	
) ON [PRIMARY]
Else
  Delete  HT2543


Exec ( 'Insert into HT2543  ( EmployeeID, FullName, DepartmentID, DepartmentName, InsuranceSalary, 
				BaseSalary, Salary01, Salary02, Salary03,
				Orders, DutyName, TeamID, TeamName,  PayrollMethodID, 
				Col01,  Col02,  Col03,  Col04,  Col05,  Col06,  Col07,  Col08,  Col09,  Col10,  
				Col11,  Col12,  Col13,  Col14,  Col15,  Col16,  Col17,  Col18,  Col19,  Col20, 
				--Col21,  Col22,  Col23,  Col24,  Col25,  Col26,  Col27,  Col28,  Col29,  Col30,  
				--Col31,  Col32,  Col33,  Col34,  Col35,  Col36,  Col37,  Col38,  Col39,  Col40,
				Totals )' + @sSQL+ @ssSQL)
*/


-------------------------------------------Lay Caption cac khoan thu nhap, giam tru HV2585

Set @sSQL='Select  HT0002.DivisionID, HT0002.IncomeID,Caption,  left(HT0002.IncomeID,1) as A, right(HT0002.IncomeID,2) AS Orders
		From HT0002 inner JOIN HT5005 ON HT0002.IncomeID=HT5005.IncomeID and HT0002.DivisionID=HT5005.DivisionID 
		AND  HT5005.PayrollMethodID ' + @lstPayrollMethodID + ' 
		Where HT0002.DivisionID = '''+@DivisionID+'''
		
		Union
		
		Select HT0005.DivisionID, HT0005.SubID,Caption, left(HT0005.SubID,1) as A, cast(right(HT0005.SubID,2) +20 as nvarchar(2)) AS Orders
		From HT0005 inner JOIN  HT5006 ON HT0005.SubID=HT5006.SubID  and HT0005.DivisionID=HT5006.DivisionID 
		AND HT5006.PayrollMethodID' + @lstPayrollMethodID + '
		Where HT0005.DivisionID = '''+@DivisionID+'''
 		Union
		
		Select ''S00'' as SubID,''PIT'' as Caption, ''S'' , 00 AS Orders'

If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2592')
	exec('Create view HV2592 ---- tao boi HP2537
				as ' + @sSQL)
else
	exec('Alter view HV2592 ---- tao boi HP2537
				as ' + @sSQL)

	Set @cur = Cursor scroll keyset for

		Select IncomeID,Caption,  A,  Orders
		From HV2592
		Order by A,Orders,Caption 
		
	Open @cur
	Fetch next from @cur into @IncomeID,@Caption,@A,@TOrders

Set @Column=1
Set @Counter=''
Set @ssSQL='Select '

While @@Fetch_Status = 0

Begin	
	
	Set @ssSQL= @ssSQL + N''''+  @Caption +''''  + ' as Col' +  (Case when @TOrders <10 then '0' else '' End )+ltrim(rtrim(str(@TOrders))) + ','
	Set @Counter=@Counter + (Case when @TOrders <10 then '0' else '' End )+ltrim(rtrim(str(@TOrders))) + ','
	Fetch next from @cur into @IncomeID,@Caption, @A, @TOrders
	
End

Declare @i as nvarchar(6)
While @Column<41
 Begin
		Set @i='%' + cast(@Column as nvarchar(2)) +  ',%'
		
		Set @Pos=PATINDEX(@i, @Counter)
		If @Pos =0 
 			Set @ssSQL= @ssSQL + ' NULL as Col' +  (Case when @Column <10 then '0' else '' End )+ltrim(rtrim(str(@Column))) + ', '
		Set @Column = @Column + 1
End



Set @ssSQL = left(@ssSQL, len(@ssSQL) - 1)



If not  exists(Select  1 From sysObjects Where XType = 'V' and Name = 'HV2585')	
	exec('Create view HV2585 ---tao boi HP2537
		as ' + @ssSQL)
Else
	exec('Alter view HV2585 ---tao boi HP2537
		as ' + @ssSQL)

Close @cur 

-----------------------------------------------------------------------------------------------------IN  NGAY CONG THANG--------------------------------------------------------------------------------------------

Declare @sSQL1 nvarchar(4000),
	@ssSQL1 nvarchar(4000),
	@cur1 cursor,
	@AbsentTypeID NVARCHAR(50),
	@ProductID NVARCHAR(50),
	@O as tinyint,
	@B as nvarchar(10)

Select @Column = 41, @sSQL1 = '' 

Set @sSQL1 = 'Select HT.DivisionID, HT.DepartmentID, HT.TeamID, HT.EmployeeID, FullName, TranMonth, TranYear,(Case When  TranMOnth <10 then ''0''+rtrim(ltrim(str(TranMonth)))+''/''+ltrim(Rtrim(str(TranYear))) 
	Else rtrim(ltrim(str(TranMonth)))+''/''+ltrim(Rtrim(str(TranYear))) End) as MonthYear, ' 	


Set @sSQL='SELECT HT13.DivisionID, HT13.AbsentTypeID, right(HT05.IncomeID,2)  +40 as O , LEFT(HT05.IncomeID,1) AS B 
		FROM HT1013 HT13 inner join ht5003 HT03 
		on HT13. AbsentTypeID = HT03.AbsentTypeID and HT13. DivisionID = HT03.DivisionID
		inner join HT5005 HT05 on  HT05.GeneralAbsentID=HT03.GeneralAbsentID and HT05.DivisionID=HT03.DivisionID
		and HT05.PayrollMethodID ' + @lstPayrollMethodID + ' 
		Where HT13.DivisionID = '''+@DivisionID+'''

		union 
		SELECT HT13.DivisionID, HT13.AbsentTypeID, cast(right(HT06.SubID,2) +40 as nvarchar(2)) as O , LEFT(HT06.SubID,1) AS B 
		FROM HT1013 HT13 inner join ht5003 HT03 
		on HT13. AbsentTypeID = HT03.AbsentTypeID and HT13. DivisionID = HT03.DivisionID
		inner join HT5006 HT06 on HT06.GeneralAbsentID=HT03.GeneralAbsentID and HT06.DivisionID=HT03.DivisionID
		and HT06.PayrollMethodID ' + @lstPayrollMethodID + ' 
		Where HT13.DivisionID = '''+@DivisionID+''' '

If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2593')
	exec('Create view HV2593 ---- tao boi HP2537
				as ' + @sSQL)
else
	exec('Alter view HV2593 ---- tao boi HP2537
				as ' + @sSQL)

Set @cur1 = Cursor scroll keyset for
		SELECT AbsentTypeID, O, B
		From HV2593
		Order by B,O

Open @cur1
Fetch next from @cur1 into @AbsentTypeID, @O, @B

Set @ssSQL1='Select '
Set @Counter=''
While @@Fetch_Status = 0
Begin	
	Set @sSQL1 = @sSQL1 + 'sum(case when AbsentTypeID = ''' + @AbsentTypeID +
			 ''' then AbsentAmount else 0 end) as Col' + cast(@Column  as nvarchar(2)) +   ', '	
	Set @ssSQL1=@ssSQL1 + '''' + @AbsentTypeID+ '''' + 'as Col' + cast(@Column  as nvarchar(2)) +   ', '	
	Set @Column = @Column + 1
	Fetch next from @cur1 into @AbsentTypeID,@O, @B
End

--print @ssSQL1;

While @Column<=54
 Begin

		
 	Set @sSQL1 = @sSQL1+ ' CONVERT (decimal (28, 8), 0)  as Col'+ (Case when @Column <10 then '0' else '' End )+ltrim(rtrim(str(@Column))) + ' , '
	Set @ssSQL1=@ssSQL1 +  'NULL as Col' + cast(@Column as nvarchar(2)) +   ', '	
	Set @Column = @Column + 1
			
End


Set @sSQL1 = left(@sSQL1, len(@sSQL1) - 1) +  ' From HT2402 HT inner join HV1400 HV on HT.EmployeeID = HV.EmployeeID and HT.DivisionID = HV.DivisionID
			Where HT.DivisionID = ''' + @DivisionID + ''' and
				HT.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
				isnull(HT.TeamID, '''') like isnull(''' + @TeamID + ''', '''')  and 
				HT.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
				HT.TranMonth + HT.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + ' and ' +
				cast(@ToMonth + @ToYear*100 as nvarchar(10)) + '
			Group by  HT.DivisionID, HT.DepartmentID, HT.TeamID, HT.EmployeeID, FullName, HT.TranMonth, HT.TranYear '

---View tong hop ngay cong HV2586
--print @ssSQL1

If not  exists(Select  1 From sysObjects Where XType = 'V' and Name = 'HV2586')	
	exec('Create view HV2586 ---tao boi HP2537
		as ' + @sSQL1)
Else
	exec('Alter view HV2586 ---tao boi HP2537
		as ' + @sSQL1)

---View lay Caption ngay cong HV2587

Set @ssSQL1 = left(@ssSQL1, len(@ssSQL1) - 1)
If not  exists(Select  1 From sysObjects Where XType = 'V' and Name = 'HV2587')	
	exec('Create view HV2587 ---tao boi HP2537
		as ' + @ssSQL1)
Else
	exec('Alter view HV2587 ---tao boi HP2537
		as ' + @ssSQL1)
  
Close @cur1 

/*


-----------------------------------------------------------------------------------------------------------IN LUONG SAN PHAM------------------------------------------------------------------------------------------------------

Set @sSQL=''
Set @ProductPayrollMethodID = case when @ProductPayrollMethodID = '%' then  ' like ''' + @ProductPayrollMethodID + ''''  else ' in (''' + replace(@ProductPayrollMethodID, ',',''',''') + ''')' end 


Set @sSQL =  'Select HT1.EmployeeID as EmpID, FullName as FName, HT1.DepartmentID as DepID, DepartmentName as DepName, 
	HV.Orders as Orders, DutyName as Duty,  isnull(HT1.TeamID,'''') as Team,   isnull(T01.TeamName,'''') as TeamN,
	HT2.ProductID,sum(HT2.ProductQuantity) as ProductQuantity, 
	sum(HT2.ProductSalary) as ProductAmount , HT1.PayrollMethodID as PMethodID
	
	From HT3402 HT2  inner join HT3401 HT1 on HT2.TransactionID = HT1.TransactionID 
			inner join HV1400 HV on  HV.EmployeeID = HT1.EmployeeID 
			inner join HV2546 T01 on T01.DivisionID = HT1.DivisionID and T01.DepartmentID = HT1.DepartmentID and isnull(HT1.TeamID,'''') = isnull(T01.TeamID,'''')
			inner join HT2400 T02 on T02.EmployeeID = HT1.EmployeeID and T02.DivisionID=HT1.DivisionID 
			AND T02.DepartmentID = HT1.DepartmentID AND isnull(T02.TeamID,'''') = isnull(HT1.TeamID,'''') and
			T02.TranMonth = HT1.TranMonth and
			T02.TranYear = HT1.TranYear 
	Where HT1.DivisionID = ''' + @DivisionID + ''' and
		HT1.DepartmentID between '''+ @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		isnull(HT1.TeamID, '''') like  isnull(''' + @TeamID + ''', '''')  and  
		HT1.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
		HT1.TranMonth + HT1.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + ' and ' +
				cast(@ToMonth + @ToYear*100 as nvarchar(10)) + '   and
		HT1.PayrollMethodID ' + @ProductPayrollMethodID + '
		
	
	Group by HT1.EmployeeID, FullName, HT1.DepartmentID, DepartmentName,
		HV.Orders , DutyName,   isnull(HT1.TeamID,''''),   isnull(T01.TeamName,'''') , 
		 HT2.ProductID,HT1.PayrollMethodID  '
--print @sSQL
--View HV2537 phuc vu cho HV2538
If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2537')
	exec('Create view HV2537 ---- tao boi HP2531
				as ' + @sSQL)
else
	exec('Alter view HV2537 ---- tao boi HP2531
				as ' + @sSQL)

Set @sSQL=''
Set @sSQL='SELECT EmpID,FName,DepID, DepName, Orders, Duty,Team,TeamN,sum(isnull(ProductAmount,0)) as Col35  FROM HV2537
		group by EmpID,FName  , DepID,DepName,Orders,Duty,Team,TeamN'

If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2538')
	exec('Create view HV2538 ---- tao boi HP2531
				as ' + @sSQL)
else
	exec('Alter view HV2538 ---- tao boi HP2531
				as ' + @sSQL)
*/

-----------------------------------------------------------TONG HOP LUONG THANG, NGAY CONG THANG-------------------------------------------------------------------------

Declare @sSQL2 as nvarchar(4000)
Select @sSQL2=''

Set @sSQL2='Select HV35.DivisionID, HV35.EmployeeID  ,HV35.FullName ,HV35.DepartmentID,HV35.DepartmentName,HV35.PayrollMethodID,
		HV35.DutyName ,HV35.TeamID, HV35.TeamName, InsuranceSalary ,BaseSalary,Salary01 , Salary02 , Salary03 , 
		Col00,Col01, Col02,  Col03, Col04, Col05, Col06, Col07, Col08, Col09, Col10,
		Col11, Col12, Col13, Col14, Col15, Col16, Col17, Col18, Col19, Col20, 
		Col21, Col22,  Col23, Col24, Col25, Col26, Col27, Col28, Col29, Col30,
		Col31, Col32, Col33, Col34, Col35, Col36, Col37, Col38, Col39, Col40, 
		isnull(HV36. Col41,0) as Col41, isnull(HV36. Col42,0) as Col42, isnull(HV36. Col43,0) as Col43, isnull(HV36. Col44,0) as Col44, 
		isnull(HV36. Col45,0) as Col45, isnull(HV36. Col46,0) as Col46 , isnull(HV36. Col47,0) as Col47, isnull(HV36. Col48,0) as Col48, 
		isnull(HV36. Col49,0) as Col49, isnull(HV36. Col50,0) as Col50, isnull(HV36. Col51,0) as Col51, 
		isnull(HV36. Col52,0) as Col52, isnull(HV36. Col53,0) as Col53, isnull(HV36. Col54,0) as Col54, Totals,---HV38.Col35,

		' + Case @Currency When 'USD' Then  + Str(@RateExchange)+ '* Totals  ' 
			Else 'Totals/' + Str(@RateExchange)   End +' As TotalConverted

		--isnull(HV38.Col35,0) as ProductSalary
	
		From HV2591 HV35
		
		Left Join HV2586 HV36 on HV35.DepartmentID=HV35.DepartmentID and
		isnull(HV35.TeamID,'''')= isnull(HV36.TeamID,'''') and HV35.EmployeeID=HV36.EmployeeID'
		
		--Left  Join HV2538 HV38 on HV35.DepartmentID=HV38.DepID and
		--isnull(HV35.TeamID,'''')= isnull(HV38.Team,'''') and HV35.EmployeeID=HV38.EmpID'---luong san pham
--PRINT @sSQL2

If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2589')
	exec('Create view HV2589 ---- tao boi HP2537

				as ' + @sSQL2)
else
	exec('Alter view HV2589 ---- tao boi HP2537
				as ' + @sSQL2)
-------Lay Caption tong hop
Set @sSQL2='Select HV2585.*, HV2587.*----, ''Löông saûn phaåm'' as Col35
		from HV2585, HV2587' 

If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2590')
	exec('Create view HV2590 ---- tao boi HP2537

				as ' + @sSQL2)
else
	exec('Alter view HV2590 ---- tao boi HP2537
				as ' + @sSQL2)
 --------------------------------------------------------------------------------------------------------------THE END------------------------------------------------------------------------------------------------------------------
GO


