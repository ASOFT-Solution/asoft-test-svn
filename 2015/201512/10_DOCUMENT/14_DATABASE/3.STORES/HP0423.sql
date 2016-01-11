IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP0423]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP0423]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---- Create on 11/03/2014 by Bảo Anh
---- In danh sách lao động tham gia BHXH, BHYT (mẫu D02-TS)
---- HP0423 'UN',2,2014,'480c6b4a-c68e-4c9d-a4d1-7afca148fcce'
---- Modify on 11/05/2015 by Bảo Anh: Bổ sung các trường VoucherNo, DecSheetCount, IsIBIssue, IsHIssue, HFromDate, HToDate

CREATE PROCEDURE [dbo].[HP0423]
( 
	@DivisionID as nvarchar(50),
	@TranMonth as int,
	@TranYear AS int,
	@VoucherID as nvarchar(50)
) 
AS  

--- Phần 1 & 2
Select	HV1400.DutyName, ---(CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(VoucherDate)-1),VoucherDate),103)) AS FromMonth,
	---	(CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,VoucherDate))),DATEADD(mm,RemainMonth,VoucherDate)),103)) as ToMonth,
		HT0323.MonthYearFrom as FromMonth, HT0323.MonthYearTo as ToMonth,
		HT0323.EmployeeID, FullName, DepartmentName, Birthday, isMale, HT0323.Status, HT0323.StatusName, HT0323.OldInsuranceSalary,
		0 as oldSalary01, 0 as oldSalary02,0 as oldSalary03, 0 as OldOtherSalary, HT0323.InsuranceSalary, HV1400.SoInsuranceNo,
		HT0323.Salary01, HT0323.Salary02, HT0323.Salary03, HT0323.OrtherSalary, HT0323.Description, RemainMonth, IsHStatus,
		(Isnull(HT2461.SRate,0) + Isnull(HT2461.SRate2,0) + Isnull(HT2461.HRate,0) + Isnull(HT2461.HRate2,0) + Isnull(HT2461.TRate,0) + Isnull(HT2461.TRate2,0)) as TotalRate,
		(Isnull(T61.SRate,0) + Isnull(T61.SRate2,0) + Isnull(T61.HRate,0) + Isnull(T61.HRate2,0) + Isnull(T61.TRate,0) + Isnull(T61.TRate2,0)) as TotalRate_Dec,
		@TranMonth as TranMonth, @TranYear as TranYear,
		Isnull((Select COUNT(EmployeeID) From HT0323 A Where A.DivisionID = @DivisionID And A.VoucherID = @VoucherID And A.Status = HT0323.Status),0) as StatusCount,
		HT0322.VoucherNo,
		(Select count(EmployeeID) From HT0305 Where DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear) as DecSheetCount,
		HT0323.IsIBIssue, HT0323.IsHIssue, HT0323.HFromDate, HT0323.HToDate


From HT0323  
inner join HV1400 on HV1400.DivisionID = HT0323.DivisionID and HV1400.EmployeeID = HT0323.EmployeeID
inner join HT0322 on HT0322.DivisionID = HT0323.DivisionID and HT0322.VoucherID = HT0323.VoucherID
left join HT2461 on HT2461.DivisionID = HT0323.DivisionID and HT2461.EmployeeID = HT0323.EmployeeID and HT2461.TranMonth = @TranMonth and HT2461.TranYear = @TranYear
left join HT2461 T61 on T61.DivisionID = HT0323.DivisionID and T61.EmployeeID = HT0323.EmployeeID and T61.TranMonth + T61.TranYear * 100 = (@TranMonth + @TranYear * 100) -1

Where	HT0322.DivisionID = @DivisionID
		and HT0322.TranMonth = @TranMonth 
		and HT0322.TranYear = @TranYear 
		and HT0322.VoucherID =@VoucherID
		
--- UNION thêm các chỉ tiêu không phát sinh
UNION
Select NULL as DutyName, NULL AS FromMonth,	NULL as ToMonth, NULL as EmployeeID, NULL as FullName, NULL as DepartmentName, NULL as Birthday, NULL as isMale,
		1 as Status, NULL as StatusName, NULL as OldInsuranceSalary, NULL as oldSalary01, NULL as oldSalary02, NULL as oldSalary03, NULL as InsuranceSalary, NULL as SoInsuranceNo,
		NULL as Salary01, NULL as Salary02, NULL as Salary03, NULL as OldOtherSalary, NULL as OrtherSalary, NULL as Description, NULL as RemainMonth, NULL as IsHStatus,
		NULL as TotalRate, NULL as TotalRate_Dec, @TranMonth as TranMonth, @TranYear as TranYear,
		Isnull((Select COUNT(EmployeeID) From HT0323 A Where A.DivisionID = @DivisionID And A.VoucherID = @VoucherID And A.Status = 1),0) as StatusCount,
		NULL as VoucherNo, NULL as DecSheetCount, NULL as IsIBIssue, NULL as IsHIssue, NULL as HFromDate, NULL as HToDate
		
UNION
Select NULL as DutyName, NULL AS FromMonth,	NULL as ToMonth, NULL as EmployeeID, NULL as FullName, NULL as DepartmentName, NULL as Birthday, NULL as isMale,
		2 as Status, NULL as StatusName, NULL as OldInsuranceSalary, NULL as oldSalary01, NULL as oldSalary02, NULL as oldSalary03, NULL as InsuranceSalary, NULL as SoInsuranceNo,
		NULL as Salary01, NULL as Salary02, NULL as Salary03, NULL as OldOtherSalary, NULL as OrtherSalary, NULL as Description, NULL as RemainMonth, NULL as IsHStatus,
		NULL as TotalRate, NULL as TotalRate_Dec, @TranMonth as TranMonth, @TranYear as TranYear,
		Isnull((Select COUNT(EmployeeID) From HT0323 A Where A.DivisionID = @DivisionID And A.VoucherID = @VoucherID And A.Status = 2),0) as StatusCount,
		NULL as VoucherNo, NULL as DecSheetCount, NULL as IsIBIssue, NULL as IsHIssue, NULL as HFromDate, NULL as HToDate

UNION
Select NULL as DutyName, NULL AS FromMonth,	NULL as ToMonth, NULL as EmployeeID, NULL as FullName, NULL as DepartmentName, NULL as Birthday, NULL as isMale,
		3 as Status, NULL as StatusName, NULL as OldInsuranceSalary, NULL as oldSalary01, NULL as oldSalary02, NULL as oldSalary03, NULL as InsuranceSalary, NULL as SoInsuranceNo,
		NULL as Salary01, NULL as Salary02, NULL as Salary03, NULL as OldOtherSalary, NULL as OrtherSalary, NULL as Description, NULL as RemainMonth, NULL as IsHStatus,
		NULL as TotalRate, NULL as TotalRate_Dec, @TranMonth as TranMonth, @TranYear as TranYear,
		Isnull((Select COUNT(EmployeeID) From HT0323 A Where A.DivisionID = @DivisionID And A.VoucherID = @VoucherID And A.Status = 3),0) as StatusCount,
		NULL as VoucherNo, NULL as DecSheetCount, NULL as IsIBIssue, NULL as IsHIssue, NULL as HFromDate, NULL as HToDate
		
UNION
Select NULL as DutyName, NULL AS FromMonth,	NULL as ToMonth, NULL as EmployeeID, NULL as FullName, NULL as DepartmentName, NULL as Birthday, NULL as isMale,
		4 as Status, NULL as StatusName, NULL as OldInsuranceSalary, NULL as oldSalary01, NULL as oldSalary02, NULL as oldSalary03, NULL as InsuranceSalary, NULL as SoInsuranceNo,
		NULL as Salary01, NULL as Salary02, NULL as Salary03, NULL as OldOtherSalary, NULL as OrtherSalary, NULL as Description, NULL as RemainMonth, NULL as IsHStatus,
		NULL as TotalRate, NULL as TotalRate_Dec, @TranMonth as TranMonth, @TranYear as TranYear,
		Isnull((Select COUNT(EmployeeID) From HT0323 A Where A.DivisionID = @DivisionID And A.VoucherID = @VoucherID And A.Status = 4),0) as StatusCount,
		NULL as VoucherNo, NULL as DecSheetCount, NULL as IsIBIssue, NULL as IsHIssue, NULL as HFromDate, NULL as HToDate
		
UNION
Select NULL as DutyName, NULL AS FromMonth,	NULL as ToMonth, NULL as EmployeeID, NULL as FullName, NULL as DepartmentName, NULL as Birthday, NULL as isMale,
		5 as Status, NULL as StatusName, NULL as OldInsuranceSalary, NULL as oldSalary01, NULL as oldSalary02, NULL as oldSalary03, NULL as InsuranceSalary, NULL as SoInsuranceNo,
		NULL as Salary01, NULL as Salary02, NULL as Salary03, NULL as OldOtherSalary, NULL as OrtherSalary, NULL as Description, NULL as RemainMonth, NULL as IsHStatus,
		NULL as TotalRate, NULL as TotalRate_Dec, @TranMonth as TranMonth, @TranYear as TranYear,
		Isnull((Select COUNT(EmployeeID) From HT0323 A Where A.DivisionID = @DivisionID And A.VoucherID = @VoucherID And A.Status = 5),0) as StatusCount,
		NULL as VoucherNo, NULL as DecSheetCount, NULL as IsIBIssue, NULL as IsHIssue, NULL as HFromDate, NULL as HToDate
		
UNION
Select NULL as DutyName, NULL AS FromMonth,	NULL as ToMonth, NULL as EmployeeID, NULL as FullName, NULL as DepartmentName, NULL as Birthday, NULL as isMale,
		6 as Status, NULL as StatusName, NULL as OldInsuranceSalary, NULL as oldSalary01, NULL as oldSalary02, NULL as oldSalary03, NULL as InsuranceSalary, NULL as SoInsuranceNo,
		NULL as Salary01, NULL as Salary02, NULL as Salary03, NULL as OldOtherSalary, NULL as OrtherSalary, NULL as Description, NULL as RemainMonth, NULL as IsHStatus,
		NULL as TotalRate, NULL as TotalRate_Dec, @TranMonth as TranMonth, @TranYear as TranYear,
		Isnull((Select COUNT(EmployeeID) From HT0323 A Where A.DivisionID = @DivisionID And A.VoucherID = @VoucherID And A.Status = 6),0) as StatusCount,
		NULL as VoucherNo, NULL as DecSheetCount, NULL as IsIBIssue, NULL as IsHIssue, NULL as HFromDate, NULL as HToDate
		
UNION
Select NULL as DutyName, NULL AS FromMonth,	NULL as ToMonth, NULL as EmployeeID, NULL as FullName, NULL as DepartmentName, NULL as Birthday, NULL as isMale,
		7 as Status, NULL as StatusName, NULL as OldInsuranceSalary, NULL as oldSalary01, NULL as oldSalary02, NULL as oldSalary03, NULL as InsuranceSalary, NULL as SoInsuranceNo,
		NULL as Salary01, NULL as Salary02, NULL as Salary03, NULL as OldOtherSalary, NULL as OrtherSalary, NULL as Description, NULL as RemainMonth, NULL as IsHStatus,
		NULL as TotalRate, NULL as TotalRate_Dec, @TranMonth as TranMonth, @TranYear as TranYear,
		Isnull((Select COUNT(EmployeeID) From HT0323 A Where A.DivisionID = @DivisionID And A.VoucherID = @VoucherID And A.Status = 7),0) as StatusCount,
		NULL as VoucherNo, NULL as DecSheetCount, NULL as IsIBIssue, NULL as IsHIssue, NULL as HFromDate, NULL as HToDate
		
UNION
Select NULL as DutyName, NULL AS FromMonth,	NULL as ToMonth, NULL as EmployeeID, NULL as FullName, NULL as DepartmentName, NULL as Birthday, NULL as isMale,
		8 as Status, NULL as StatusName, NULL as OldInsuranceSalary, NULL as oldSalary01, NULL as oldSalary02, NULL as oldSalary03, NULL as InsuranceSalary, NULL as SoInsuranceNo,
		NULL as Salary01, NULL as Salary02, NULL as Salary03, NULL as OldOtherSalary, NULL as OrtherSalary, NULL as Description, NULL as RemainMonth, NULL as IsHStatus,
		NULL as TotalRate, NULL as TotalRate_Dec, @TranMonth as TranMonth, @TranYear as TranYear,
		Isnull((Select COUNT(EmployeeID) From HT0323 A Where A.DivisionID = @DivisionID And A.VoucherID = @VoucherID And A.Status = 8),0) as StatusCount,
		NULL as VoucherNo, NULL as DecSheetCount, NULL as IsIBIssue, NULL as IsHIssue, NULL as HFromDate, NULL as HToDate
		
ORDER BY HT0323.Status ASC, HV1400.SoInsuranceNo DESC

--- Phần 3
/*
SELECT	HT24.EmployeeID, HV00.FullName, HV00.SoInsuranceNo, HV00.Birthday, HV00.IsMale, HV00.DutyName, HT24.DepartmentID as NewDepartmentID, AT1102.DepartmentName as NewDepartmentName,
		(Select DepartmentID From HT2400 Where DivisionID = @DivisionID And TranMonth + TranYear * 100 = @TranMonth + @TranYear * 100 - 1 And EmployeeID = HT24.EmployeeID) as OldDepartmentID,
		(Select DepartmentName From AT1102 Where DivisionID = @DivisionID And DepartmentID = (Select DepartmentID From HT2400 Where DivisionID = @DivisionID And TranMonth + TranYear * 100 = @TranMonth + @TranYear * 100 - 1 And EmployeeID = HT24.EmployeeID)) as OldDepartmentName,
		HT24.TeamID as NewTeamID, HT1101.TeamName as NewTeamName,
		(Select TeamID From HT2400 Where DivisionID = @DivisionID And TranMonth + TranYear * 100 = @TranMonth + @TranYear * 100 - 1 And EmployeeID = HT24.EmployeeID) as OldTeamID,
		(Select TeamName from HT1101 Where DivisionID = @DivisionID And TeamID = (Select TeamID From HT2400 Where DivisionID = @DivisionID And TranMonth + TranYear * 100 = @TranMonth + @TranYear * 100 - 1 And EmployeeID = HT24.EmployeeID)) as OldTeamName,
		HT24.FromDateTranfer, HT24.ToDateTranfer,
		(Isnull(HT2461.SRate,0) + Isnull(HT2461.SRate2,0) + Isnull(HT2461.HRate,0) + Isnull(HT2461.HRate2,0) + Isnull(HT2461.TRate,0) + Isnull(HT2461.TRate2,0)) as TotalRate

FROM HT2400 HT24
INNER JOIN HV1400 HV00 On HT24.DivisionID = HV00.DivisionID And HT24.EmployeeID = HV00.EmployeeID
LEFT JOIN AT1102 On HT24.DivisionID = AT1102.DivisionID And HT24.DepartmentID = AT1102.DepartmentID
LEFT JOIN HT1101 On HT24.DivisionID = HT1101.DivisionID And HT24.TeamID = HT1101.TeamID
LEFT JOIN HT2461 on HT2461.DivisionID = HT24.DivisionID and HT2461.EmployeeID = HT24.EmployeeID and HT2461.TranMonth = @TranMonth and HT2461.TranYear = @TranYear

WHERE HT24.DivisionID = @DivisionID And HT24.TranMonth = @TranMonth And HT24.TranYear = @TranYear
And HT24.Appointed <> 0

ORDER BY SoInsuranceNo DESC
*/

/* Thay đổi thông tin chức danh, nghề, điều kiện làm việc
SELECT	HT24.EmployeeID, HV00.FullName, HV00.SoInsuranceNo, HV00.Birthday, HV00.IsMale, HV00.DutyName, HT24.DepartmentID as NewDepartmentID, A01.DepartmentName as NewDepartmentName,
		HT24.DepartmentIDOld as OldDepartmentID, AT1102.DepartmentName as OldDepartmentName,
		HT24.TeamID as NewTeamID, H01.TeamName as NewTeamName,
		HT24.TeamIDOld as OldTeamID, HT1101.TeamName as OldTeamName,
		HT24.FromDate as FromDateTranfer, (case when HT24.FromDate = HT24.ToDate then NULL else HT24.ToDate end) as ToDateTranfer,
		(Isnull(HT2461.SRate,0) + Isnull(HT2461.SRate2,0) + Isnull(HT2461.HRate,0) + Isnull(HT2461.HRate2,0) + Isnull(HT2461.TRate,0) + Isnull(HT2461.TRate2,0)) as TotalRate

FROM HT1302 HT24
INNER JOIN HV1400 HV00 On HT24.DivisionID = HV00.DivisionID And HT24.EmployeeID = HV00.EmployeeID
LEFT JOIN AT1102 On HT24.DivisionID = AT1102.DivisionID And HT24.DepartmentIDOld = AT1102.DepartmentID
LEFT JOIN HT1101 On HT24.DivisionID = HT1101.DivisionID And HT24.TeamIDOld = HT1101.TeamID
LEFT JOIN AT1102 A01 On HT24.DivisionID = A01.DivisionID And HT24.DepartmentID = A01.DepartmentID
LEFT JOIN HT1101 H01 On HT24.DivisionID = H01.DivisionID And HT24.TeamID = H01.TeamID
LEFT JOIN HT2461 on HT2461.DivisionID = HT24.DivisionID and HT2461.EmployeeID = HT24.EmployeeID and HT2461.TranMonth = @TranMonth and HT2461.TranYear = @TranYear

WHERE HT24.DivisionID = @DivisionID And HT24.FromMonth = @TranMonth And HT24.FromYear = @TranYear
And HT24.IsPast = 0

ORDER BY SoInsuranceNo DESC
*/