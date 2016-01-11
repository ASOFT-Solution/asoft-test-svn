/****** Object:  StoredProcedure [dbo].[HP2541]    Script Date: 12/23/2011 14:14:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2541]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2541]
GO



/****** Object:  StoredProcedure [dbo].[HP2541]    Script Date: 12/23/2011 14:14:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--- Modify on 23/06/2014 by Bảo Anh: Bổ sung alias cho các trường
/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2541] @DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@ToDepartmentID nvarchar(50),
				@TranYear int,
				@TranMonth int
AS
Declare @sSQL1 nvarchar(4000)
		
Select @sSQL1 = ''

Set @sSQL1 = 'Select HT.DivisionID, HT.EmployeeID, FullName, HV.IdentifyCardNo, HT.DepartmentID, HV.DepartmentName, isnull(HT.TeamID,'''') as TeamID, HV.Orders as Orders, isnull(DutyName,'''') as DutyName, 
		isnull(HT.BaseSalary,0) as BaseSalary, isnull(HT.InsuranceSalary, 0) as InsuranceSalary, isnull(HT.Salary01, 0) as Salary01,
		isnull(HT.Salary02, 0) as Salary02, isnull(HT.Salary03,0) as Salary03, SNo, SBeginDate, HNo, HT.HFromDate, HT.HToDate, CNo, CFromDate, 
		CToDate, HT.HospitalID, HT1009.HospitalName

		
	From HT2460 HT inner join HV1400 HV on  HV.EmployeeID = HT.EmployeeID and HV.DivisionID = HT.DivisionID 
			inner join AT1102 AT on AT.DivisionID = HT.DivisionID and AT.DepartmentID = HT.DepartmentID 
			left join HT1009 on HT.DivisionID = HT1009.DivisionID And IsNull(HT.HospitalID,'''')= IsNull(HT1009.HospitalID,'''')
	Where HT.DivisionID = ''' + @DivisionID + ''' and
		HT.DepartmentID between ''' + @DepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		HT.TranMonth = ' + str(@TranMonth) + ' and
		HT.TranYear = ' + str(@TranYear)  

if not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2541')
	exec('Create view HV2541 ---- tao boi HP2541
				as ' + @sSQL1)
else
	exec('Alter view HV2541 ---- tao boi HP2541
				as ' + @sSQL1)
GO


