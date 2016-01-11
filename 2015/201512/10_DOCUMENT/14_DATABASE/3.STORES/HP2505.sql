/****** Object:  StoredProcedure [dbo].[HP2505]    Script Date: 11/18/2011 16:14:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2505]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2505]
GO
/****** Object:  StoredProcedure [dbo].[HP2505]    Script Date: 11/18/2011 16:14:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
----Created by: Vo Thanh Huong
----Created date: 06/07/2004
----purpose: In bao cao BHXH
----Edited by Le Hoai Minh
----Edit by: Dang Le Bao Quynh; Date: 01/09/2006
----Edit by Huynh Trung Dung ,date 16/12/2010 --- Them tham so @ToDepartmentID
----Edit by Trần Quốc Tuấn , date 06/02/2015 --- bổ sung thêm trường SoInsurBeginDate lấy báo cáo SOFA
----Edit by Nguyen Thanh Thịnh , date 10/08/2015 --- Bổ sung thêm trường ghi chú

CREATE PROCEDURE [dbo].[HP2505] 	@ReportType tinyint,  ---0: T?ng c?ng, 1: BHXH, 2: BHYT, 3: KPCD, 4-BHXH+BHYT
				@IsMonth tinyint,
				@FromMonth int,
				@FromYear int,
				@ToMonth int,
				@ToYear int,
				@TranQuater int,
				@TranYear int,
				@DivisionID nvarchar(50),	
				@DepartmentID nvarchar(50),
				@ToDepartmentID nvarchar(50),
				@TeamID nvarchar(50),
				@IsDetail tinyint

AS 

DECLARE @sSQL nvarchar(4000),
		@sSQL1 nvarchar(4000),
	@FromMonth1 int,
	@ToMonth1 int

if @IsMonth = 1
BEGIN

----purpose: In báo cáo danh sách lao dong nop BHXH thang

SET @sSQL = 'SELECT T00.DivisionID ,T00.EmployeeID, V00.Orders, FullName, Birthday, sum(isnull(T00.BaseSalary,0)) as BaseSalary, 
	isnull(T03.SNo,'''') as SNo,isnull(T03.CNo,'''') as CNo,isnull(T03.HospitalName,'''') as HospitalName,V00.IsMale,isnull(V00.CityName,'''') as CityName,isnull(V00.Dutyname,'''') as DutyName,
	isnull(V00.ArmyJoinDate,'''') as ArmyJoinDate,isnull(V00.ArmyEndDate,'''') as ArmyEndDate,isnull(V00.ArmyLevel,'''') as ArmyLevel,
	sum(isnull(T04.SalaryCoefficient,0)) as SalaryCoefficient,sum(isnull(T04.DutyCoefficient,0)) as DutyCoefficient,sum(isnull(V00.InsuranceSalary,0)) as InsuranceSalary,
	sum(isnull(GeneralCo, 0)) as GeneralCo, sum(isnull(T00.BaseSalary*GeneralCo,0)) as ISalary,
	 T00.DepartmentID, T01.DepartmentName, isnull(T00.TeamID, '''') as TeamID ,  T02.TeamName,V00.SoInsurBeginDate,  avg(isnull(T00.SRate,0)) as SRate ,  avg(isnull(T00.HRate,0)) as HRate , 
	avg(isnull(T00.TRate, 0)) as TRate ,  avg(isnull(T00.SRate2,0)) as SRate2 , avg(isnull(T00.HRate2,0)) as HRate2 , avg(isnull(T00.TRate2,0)) as TRate2 , 
	sum(isnull(T00.SAmount,0)) as SAmount , sum(isnull(T00.HAmount, 0)) as HAmount  , sum(isnull(T00.TAmount,0)) as TAmount,
	sum(isnull(SAmount2,0)) as SAmount2 , sum(isnull(T00.HAmount2, 0)) as HAmount2 , sum(isnull(T00.TAmount2, 0)) as TAmount2 , 		
	sum(L.SalaryAmount) as SalaryAmount, sum(L.TaxAmount) as TaxAmount,T03.Notes,
	'+  CASE 
	WHEN @ReportType = 1 THEN  'avg(isnull(SRate,0))  AS Rate, avg(isnull(SRate2, 0))  AS Rate2, sum(isnull(SAmount, 0))  AS Amount, 
		sum(isnull(SAmount2,0)) AS Amount2  '
	WHEN @ReportType = 2 THEN  'avg(isnull(HRate,0))  AS Rate, avg(isnull(HRate2,0)) AS Rate2, sum(isnull(HAmount,0)) AS Amount, 
		sum(isnull(HAmount2,0)) AS Amount2  '
	WHEN @ReportType = 3 THEN  'avg(isnull(TRate,0)) AS Rate, avg(isnull(TRate2,0))  AS Rate2, sum(isnull(TAmount,0)) AS Amount, 
		sum(isnull(TAmount2,0))	 AS Amount2  '
	WHEN @ReportType = 4 THEN  'avg(isnull(SRate + HRate, 0)) AS Rate, 
		avg(isnull(SRate2 + HRate2, 0)) AS Rate2, sum(isnull(SAmount + HAmount,0))  AS Amount,  
		sum(isnull(SAmount2 + HAmount2,0))   AS Amount2  '
	ELSE 'sum(isnull(HRate + SRate + TRate,0)) AS Rate, sum(isnull(HRate2 + SRate2 + TRate2,0)) AS Rate2,
		sum(isnull(HAmount + SAmount + TAmount, 0)) AS Amount, sum(isnull(HAmount2 + SAmount2 + TAmount2, 0)) AS Amount2  '
	END 


SET @sSQL = @sSQL +  ' FROM HT2461 T00  inner join  HV1400 V00 on T00.EmployeeID = V00.EmployeeID and T00.DivisionID = V00.DivisionID 
inner join AT1102 T01  on T00.DepartmentID = T01.DepartmentID and T00.DivisionID = T01.DivisionID

inner join 
(
	Select HT2460.DivisionID, EmployeeID,SNo,CNo,HospitalName,Notes From HT2460 left outer join HT1009 on HT2460.HospitalID=HT1009.HospitalID and HT2460.DivisionID=HT1009.DivisionID
	Where  HT2460.DivisionID = '''+@DivisionID+''' And TranMonth + TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + ' and ' + 
	cast(@ToMonth + @ToYear*100 as nvarchar(10)) 	+ '
) T03 
On T00.EmployeeID=T03.EmployeeID and T00.DivisionID=T03.DivisionID
left outer join 
(
	Select HT2400.DivisionID ,HT2400.EmployeeID,HT2400.SalaryCoefficient,HT2400.DutyCoefficient from HT2400 
	inner Join ht2461 on ht2400.departmentid=ht2461.departmentid and ht2400.employeeid=ht2461.employeeid and ht2400.DivisionID=ht2461.DivisionID  
	and ht2400.tranmonth=ht2461.tranmonth and ht2400.tranyear=ht2461.tranyear
	Where HT2400.DivisionID = '''+@DivisionID+''' And HT2400.TranMonth + HT2400.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + ' and ' + 
	cast(@ToMonth + @ToYear*100 as nvarchar(10)) 	+ '
) T04 
On T00.EmployeeID=T04.EmployeeID and T00.DivisionID=T04.DivisionID '


SET @sSQL1 = 'left join 
(
	Select DivisionID,  EmployeeID, TranMonth, TranYear, 
	sum(isnull(Income01, 0) + isnull(Income02, 0) + isnull(Income03, 0) + isnull(Income04, 0)
	+ isnull(Income05, 0) + isnull(Income06, 0) +  isnull(Income07, 0) + isnull(Income08, 0) + 
	isnull(Income09, 0) + isnull(Income10, 0) - isnull(SubAmount01, 0) -  isnull(SubAmount02, 0) 
	- isnull(SubAmount03, 0) - isnull(SubAmount04,0) - isnull(SubAmount05, 0) - 
	isnull(SubAmount06,0)-isnull(SubAmount07,0) -isnull(SubAmount08,0)-
	isnull(SubAmount09,0)-isnull(SubAmount10,0)) as SalaryAmount, sum(isnull(TaxAmount,0)) as TaxAmount						
	From HT3400 Where DivisionID = '''+@DivisionID+'''
	Group by DivisionID,  EmployeeID, TranMonth, TranYear
) L
on L.EmployeeID =  T00.EmployeeID and L.TranMonth = T00.TranMonth  and L.TranYear = T00.TranYear and L.DivisionID = T00.DivisionID		
left join HT1101 T02 on T02.TeamID = T00.TeamID and T02.DivisionID = T00.DivisionID and T02.DepartmentID = T02.DepartmentID  
WHERE T00.DivisionID = ''' + @DivisionID + ''' and 
	T00.DepartmentID between ''' +@DepartmentID +  ''' and  ''' +@ToDepartmentID +  ''' and 
	Isnull(T00.TeamID, ''' + ''') like ''' + isnull(@TeamID,'') + ''' and
	T00.TranMonth + T00.TranYear*100 between  ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + ' and ' + 
	cast(@ToMonth + @ToYear*100 as nvarchar(10)) 	+ '	
Group by 	T00.DivisionID,T00.EmployeeID, V00.Orders, FullName, Birthday,	 T00.DepartmentID, T01.DepartmentName, isnull(T00.TeamID, '''') , T02.TeamName,V00.SoInsurBeginDate,
		isnull(T03.SNo,''''),isnull(T03.CNo,''''),isnull(T03.HospitalName,''''),V00.IsMale,isnull(V00.CityName,''''),isnull(V00.Dutyname,''''),isnull(V00.ArmyJoinDate,''''),isnull(V00.ArmyEndDate,''''),isnull(V00.ArmyLevel,''''),T03.Notes'

IF not exists (SELECT TOP 1 1 FROM SysObjects WHERE Xtype ='V' AND Name = 'HV2505')
	EXEC (' Create View HV2505

 ---tao boi HP2505
				 as ' + @sSQL + @sSQL1)
ELSE 
	EXEC(' Alter View HV2505  ---tao boi HP2505
				 as ' + @sSQL + @sSQL1)
END

ELSE

begin
----purpose: In báo cáo danh sách lao dong nop BHXH (quý) 

SET 	@FromMonth1 = @TranQuater*3 - 2 
SET 	@ToMonth1 = @TranQuater*3 

SET @sSQL =  'Select HT00.DivisionID,HV.Orders, HT00.EmployeeID, FullName, Birthday, MAX(Isnull(SNo,''' + ''')) AS SNo,
			SUM(ISNULL(CASE WHEN HT00.TranMonth = '+ ltrim(rtrim(STR( @FromMonth1))) + ' THEN HT00.BaseSalary*GeneralCo ELSE 0 END,0))  AS BaseSalary1,
			SUM(ISNULL(CASE WHEN HT00.TranMonth = ' +ltrim(rtrim(STR(@FromMonth1 + 1)))  + ' THEN HT00.BaseSalary*GeneralCo ELSE 0 END,0))  AS BaseSalary2,	
			SUM(ISNULL(CASE WHEN HT00.TranMonth = ' + ltrim(rtrim(STR(@ToMonth1)))  + ' THEN HT00.BaseSalary*GeneralCo ELSE 0 END,0))  AS BaseSalary3,
			AVG(HT00.BaseSalary) AS AvgBaseSalary,T01.DepartmentName,T02.TeamName,HT00.DepartmentID,HT00.TeamID,	

'+  
CASE 
	WHEN @ReportType = 1 THEN  ' 
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 as nvarchar(20)) + ' then SAmount else 0 end,0)) as Insurance1,
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 + 1 as nvarchar(20))  + ' then SAmount else 0 end,0)) as Insurance2,
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 + 2 as nvarchar(20))  + ' then SAmount else 0 end,0)) as Insurance3,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 as nvarchar(20)) +'then SAmount2 else 0 end,0)) as C_Insurance1,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 +1 as nvarchar(20)) +'then SAmount2 else 0 end,0)) as C_Insurance2,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 +2 as nvarchar(20)) +'then SAmount2 else 0 end,0)) as C_Insurance3'


	WHEN @ReportType = 2 THEN  '
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 as nvarchar(20)) + ' then HAmount else 0 end,0)) as Insurance1,
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 + 1 as nvarchar(20))  + ' then HAmount else 0 end,0)) as Insurance2,
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 + 2 as nvarchar(20))  + ' then HAmount else 0 end,0)) as Insurance3,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 as nvarchar(20)) +'then HAmount2 else 0 end,0)) as C_Insurance1,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 +1 as nvarchar(20)) +'then HAmount2 else 0 end,0)) as C_Insurance2,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 +2 as nvarchar(20)) +'then HAmount2 else 0 end,0)) as C_Insurance3'

	WHEN @ReportType = 3 THEN  '
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 as nvarchar(20)) + ' then TAmount else 0 end,0)) as Insurance1,
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 + 1 as nvarchar(20))  + ' then TAmount else 0 end,0)) as Insurance2,
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 + 2 as nvarchar(20))  + ' then TAmount else 0 end,0)) as Insurance3,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 as nvarchar(20)) +'then TAmount2 else 0 end,0)) as C_Insurance1,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 +1 as nvarchar(20)) +'then TAmount2 else 0 end,0)) as C_Insurance2,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 +2 as nvarchar(20)) +'then TAmount2 else 0 end,0)) as C_Insurance3'

	WHEN @ReportType = 4 THEN  '
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 as nvarchar(20)) + ' then HAmount+SAmount else 0 end,0)) as Insurance1,
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 + 1 as nvarchar(20))  + ' then HAmount+SAmount else 0 end,0)) as Insurance2,
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 + 2 as nvarchar(20))  + ' then HAmount+SAmount else 0 end,0)) as Insurance3,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 as nvarchar(20)) +'then HAmount2+SAmount2 else 0 end,0)) as C_Insurance1,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 +1 as nvarchar(20)) +'then HAmount2+SAmount2 else 0 end,0)) as C_Insurance2,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 +2 as nvarchar(20)) +'then HAmount2+SAmount2 else 0 end,0)) as C_Insurance3'

	ELSE '
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 as nvarchar(20)) + ' then HAmount + SAmount + TAmount else 0 end,0)) as Insurance1,
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 + 1 as nvarchar(20))  + ' then HAmount + SAmount + TAmount else 0 end,0)) as Insurance2,
		sum(Isnull(case when HT00.TRanmonth = ' + cast(@FromMonth1 + 2 as nvarchar(20))  + ' then HAmount + SAmount + TAmount else 0 end,0)) as Insurance3,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 as nvarchar(20)) +'then HAmount2 + SAmount2 + TAmount2 else 0 end,0)) as C_Insurance1,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 +1 as nvarchar(20)) +'then HAmount2 + SAmount2 + TAmount2 else 0 end,0)) as C_Insurance2,
		sum(Isnull(case when HT00.Tranmonth ='+cast(@FromMonth1 +2 as nvarchar(20)) +'then HAmount2 + SAmount2 + TAmount2 else 0 end,0)) as C_Insurance3'
	END 


SET @sSQL = @sSQL + '
		From HT2461 HT00 inner join HV1400 HV on HV.EmployeeID = HT00.EmployeeID and HV.DivisionID = HT00.DivisionID 
			inner join HT2460 HT01 on HT00.EmployeeID = HT01.EmployeeID and
				HT00.TranMonth = HT01.TranMonth  and  HT00.TranYear = HT01.TranYear and HT00.DivisionID = HT01.DivisionID
			inner join AT1102 T01 on HT00.DepartmentID = T01.DepartmentID and HT00.DivisionID = T01.DivisionID
			left join HT1101 T02 on T02.TeamID = HT00.TeamID and T02.DivisionID = HT00.DivisionID and T02.DepartmentID = HT00.DepartmentID
		Where HT00.DivisionID = ''' + @DivisionID + ''' and 
			HT00.TranYear = ' +ltrim(rtrim( STR(@TranYear))) + ' and
			(HT00.Tranmonth between  ' + ltrim(rtrim(STR(@FromMonth1))) + ' and ' + ltrim(rtrim(STR(@ToMonth1))) + ') and
			HT00.DepartmentID between ''' +@DepartmentID +  ''' and  ''' +@ToDepartmentID +  ''' and
			Isnull(HT00.TeamID, ''' + ''') like Isnull(''' + @TeamID+ ''', ''' + ''')
			
			GROUP BY HT00.DivisionID,HT00.DepartmentID,HT00.TeamID,T01.DepartmentName,T02.TeamName,HV.Orders, HT00.EmployeeID, FullName, Birthday'


--print @sSql
If not exists (Select name from sysObjects Where id = Object_ID(N'[dbo].[HV2506]') and OBJECTPROPERTY(id,N'IsView')=1)
	Exec (' Create View HV2506 ---tao boi HP2506
		 as ' + @sSQL)
Else
	Exec (' Alter  View HV2506 ---tao boi HP2506
		as ' + @sSQL)


end


GO


