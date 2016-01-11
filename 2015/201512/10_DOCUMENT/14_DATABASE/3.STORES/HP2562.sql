/****** Object:  StoredProcedure [dbo].[HP2562]    Script Date: 08/02/2010 14:26:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


----Created date: 20/07/2005
----purpose: In bao cao danh sach lao dong, quy tien luong bo sung muc nop BHXH theo thang, ap dung cho Thinh Phat

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2562] 
				@DivisionID NVARCHAR(50),
				@DepartmentID NVARCHAR(50),	
				@TeamID NVARCHAR(50),
				@FromMonth int,
				@FromYear int,
				@ToMonth as int,
				@ToYear as int, 
				@ReportType int
				

AS 
DECLARE 
	@MonthYear as int,
	@sSQL1 nvarchar(4000),
	@sSQL3 nvarchar(4000),
	@From as nvarchar(10),
	@To as nvarchar(10)

Set @From= ( case when @FromMonth <10 then '0' else '' end) + ltrim(rtrim(str(@FromMonth))) +'/' + ltrim(rtrim(str(@FromYear)))
Set @To= ( case when @ToMonth <10 then '0' else '' end) + ltrim(rtrim(str(@ToMonth))) +'/' + ltrim(rtrim(str(@ToYear)))
	
			
	

---Danh sach nhan vien nop BHXH va da nghi trong khoang thoi gian @FromMonth, @FromYear den @ToMonth, @ToYear

Set @sSQL1 = 'Select HT00.DivisionID, HT00.EmployeeID, Max(Isnull(SNo, ''' + ''')) as SNo, Max(Isnull(CNo, ''' + ''')) as CNo,
		Max(Isnull(HT00.HospitalID, ''' + ''' )) as HospitalID, 
		Max(Isnull(ISNull(HT01.BaseSalary,0)*IsNull(GeneralCo,0) ,0)) as BaseSalary,   
		Max(HT00.TranMonth+100*HT00.TranYear) as MonthYear

		
		From HT2460 HT00 inner join HT2461 HT01 on HT00.EmployeeID = HT01.EmployeeID and HT00.DivisionID = HT01.DivisionID 
		and HT00.TranMonth = HT01.TranMonth and HT01.TranYear = HT01.TranYear
		Inner join ( Select EmployeeID, DivisionID From HV1400
		Where DivisionID = '''+@DivisionID+''' And Month(LeaveDate)+ 100*Year(LeaveDate) between ' +STR(@FromMonth+100*@FromYear) + ' and ' + Str(@ToMonth+100*@ToYear)+ ') HV 
		on HV.EmployeeID=HT00.EmployeeID and HV.DivisionID=HT00.DivisionID

	Where HT00.DivisionID = ''' + @DivisionID + ''' and
		HT00.DepartmentID like ''' + @DepartmentID + ''' and
		Isnull(HT00.TeamID, ''' + ''') like Isnull('''+ @TeamID + ''', ''' + ''') and 
		HT00.TranMonth + 100* HT00.TranYear between  ' +STR(@FromMonth+100*@FromYear) + ' and ' + Str(@ToMonth+100*@ToYear)+' 
	Group by HT00.DivisionID, HT00.EmployeeID'

If not exists (Select Top 1 1 From SysObjects Where Xtype = 'V' and Name = 'HV2565' )
	EXEC('Create View HV2565 ---tao boi HP2562
			as ' + @sSQL1)
else
	EXEC('Alter View HV2565 ---tao boi HP2562
			as ' + @sSQL1)

--Lay so lieu dong BHXH thang gan nhat cua nhan vien nghi viec

Set @sSQL3 = 
	' Select HV00.DivisionID, HV00.EmployeeID, '+ str(@ToMonth+100*@ToYear) +' - HV00.MonthYear +1 as Months, 
			max(HV00.BaseSalary) as BaseSalary,
			HV02.Orders, HV00.CNo, HV00.SNo, IsMale, Birthday, FullName, HT.HospitalName, FullAddress, DutyName, 
			LeaveDate, HV02.Notes, T00.TranMonth, T00.TranYear, '+ str(@ToMonth) + ' as ToMonth, '+ str(@ToYear)+ ' as ToYear,
			' +Str(@ReportType)+ ' as ReportType,

			avg(isnull(T00.SRate,0)) as SRate ,  avg(isnull(T00.HRate,0)) as HRate , avg(isnull(T00.TRate, 0)) as TRate ,  
			avg(isnull(T00.SRate2,0)) as SRate2 , avg(isnull(T00.HRate2,0)) as HRate2 , avg(isnull(T00.TRate2,0)) as TRate2 , 
			sum(isnull(T00.SAmount,0)) as SAmount , sum(isnull(T00.HAmount, 0)) as HAmount  , sum(isnull(T00.TAmount,0)) as TAmount,
			sum(isnull(SAmount2,0)) as SAmount2 , sum(isnull(T00.HAmount2, 0)) as HAmount2 , sum(isnull(T00.TAmount2, 0)) as TAmount2 , 		
			
	'+  CASE 
	WHEN @ReportType = 1 THEN  'avg(isnull(SRate,0))  AS Rate, avg(isnull(SRate2, 0))  AS Rate2, sum(isnull(SAmount, 0))  AS Amount, 
		sum(isnull(SAmount2,0)) AS Amount2  '
	WHEN @ReportType = 2 THEN  'avg(isnull(HRate,0))  AS Rate, avg(isnull(HRate2,0)) AS Rate2, sum(isnull(HAmount,0)) AS Amount, 
		sum(isnull(HAmount2,0)) AS Amount2  '
	WHEN @ReportType = 3 THEN  'avg(isnull(TRate,0)) AS Rate, avg(isnull(TRate2,0))  AS Rate2, sum(isnull(TAmount,0)) AS Amount, 
		sum(isnull(TAmount2,0))	 AS Amount2  '
	WHEN @ReportType = 4 THEN  'avg(isnull(SRate + HRate, 0)) AS Rate,  avg(isnull(SRate2 + HRate2, 0)) AS Rate2, 
		sum(isnull(SAmount + HAmount,0))  AS Amount,  sum(isnull(SAmount2 + HAmount2,0))   AS Amount2  '
	ELSE 'avg(isnull(HRate + SRate + TRate,0)) AS Rate, avg(isnull(HRate2 + SRate2 + TRate2,0)) AS Rate2,
		sum(isnull(HAmount + SAmount + TAmount, 0)) AS Amount, sum(isnull(HAmount2 + SAmount2 + TAmount2, 0)) AS Amount2  '
	END + '
		From HV2565 HV00
			inner join HV1400 HV02 on HV02.EmployeeID = HV00.EmployeeID and HV02.DivisionID = HV00.DivisionID 
			inner join HT2461 T00 on HV00.EmployeeID = T00.EmployeeID and HV02.DivisionID= T00.DivisionID 
			left  join HT1009 HT on HT.HospitalID = HV00.HospitalID and HT.DivisionID = HV00.DivisionID

		Where 
		HV00.DivisionID = '''+@DivisionID+'''
		And HV00.MonthYear=T00.TranMonth+T00.TranYear*100 and
		T00.TranMonth + 100*TranYear  between ' +STR(@FromMonth+100*@FromYear) + ' and ' + Str(@ToMonth+100*@ToYear)+ ' 
		Group by HV00.DivisionID, HV00.EmployeeID,  HV00.MonthYear, HV02.Orders, HV00.CNo, HV00.SNo, IsMale, Birthday, 
		FullName, HT.HospitalName, FullAddress, DutyName, LeaveDate, HV02.Notes, T00.TranMonth, T00.TranYear'
	
If not exists (Select Top 1 1 From SysObjects Where Xtype = 'V' and Name = 'HV2567' )
	EXEC('Create View HV2567 ---tao boi HP2562
			as ' + @sSQL3)
else
	EXEC('Alter View HV2567 ---tao boi HP2562
			as ' + @sSQL3)








