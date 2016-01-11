
/****** Object:  StoredProcedure [dbo].[HP2815]    Script Date: 07/30/2010 10:42:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2815]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2815]
GO

/****** Object:  StoredProcedure [dbo].[HP2815]    Script Date: 07/30/2010 10:42:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



---------Create Date: 23/06/2005
---------Purpose: In thong tin nhan su cua nhan vien

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/

CREATE PROCEDURE [dbo].[HP2815] 	@DivisionID nvarchar(50),				
				@EmployeeID nvarchar(50)			
AS
DECLARE @sSQL nvarchar(4000) 

--------------------------------------------------------------------THONG TIN CA NHAN---------------------------------------
Set @sSQL='Select DISTINCT HV00.DivisionID,HV00.EmployeeID,HV00.Orders,HV00.LeaveDate,HV00.FullName ,
		HV00.Birthday,HV00.BornPlace ,HV00.IsMale ,HV00.IdentifyCardNo,HV00.IdentifyDate,
		HV00.IdentifyPlace,HV00.IsSingle,HV00.Status ,HV00.FullAddress ,
		HV00.CityID,HV00.DistrictID ,HV00.PermanentAddress ,
		HV00.TemporaryAddress ,HV00.EthnicID,HV00.EthnicName ,HV00.ReligionID,   
		HV00.ReligionName ,HV00.Notes ,HV00.HealthStatus ,HV00.HomePhone,HV00.HomeFax,
		HV00.MobiPhone ,HV00.Email ,HV00.EducationLevelName ,HV00.Language1ID,
		HV00.Language2ID ,HV00.Language3ID ,HV00.LanguageLevel1ID,HV00.LanguageLevel2ID ,
		HV00.LanguageLevel3ID  ,HV00.SoInsuranceNo,HV00.SoInsurBeginDate,HV00.HeInsuranceNo,
		HV00.Hobby,HV00.HospitalID,HV00.SalaryCoefficient,HV00.DutyCoefficient,
		HV00.TimeCoefficient,HV00.DepartmentID,HV00.TeamID ,HV00.DutyID,HV00.DutyName ,
		HV00.TaxObjectID ,HV00.EmployeeStatus,HV00.Experience ,HV00.RecruitDate,HV00.RecruitPlace ,
		HV00.WorkDate ,HV00.C01 ,HV00.C02,HV00.C03 ,HV00.C04 ,HV00.C05 ,HV00.C06 ,HV00.C07 ,
		HV00.C08 ,HV00.C09 ,HV00.C10 ,HV00.BaseSalary ,HV00.InsuranceSalary ,
		HV00.Salary01,HV00.Salary02,HV00.Salary03,HV00.ImageID,T02.DepartmentName, 0 as PrintStatus

		From HV1400 HV00 
		Left Join AT1102 T02 on HV00.DivisionID=T02.DivisionID and HV00.DepartmentID=T02.DepartmentID

		Where HV00.DivisionID=  ''' + @DivisionID+ '''  and HV00.EmployeeID=''' + @EmployeeID+ ''' '

If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'HV2815')
	Drop view HV2815
EXEC('Create view HV2815 ---tao boi HP2815
			as ' + @sSQL)

-------------------------------------------------------------------KHEN THUONG KY LUAT--------------------------------------------------

Set @sSQL= 'Select DISTINCT HT06.DivisionID, HT06.DepartmentID,HT06.TeamID, HT06.EmployeeID, HT06.RetributionID,HT06.IsReward ,HT06.DecisionNo ,
		HT06.RetributeDate ,HT06.Rank ,HT06.SuggestedPerson, HT06.Reason ,HT06.Form ,HT06.Value ,HT06.DutyID As Promotion,
		1 as PrintStatus
	From HT1406 HT06
	Where DivisionID=  ''' + @DivisionID+ ''' and EmployeeID= ''' + @EmployeeID + ''' '

If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'HV2816')
	Drop view HV2816
EXEC('Create view HV2816 ---tao boi HP2815
			as ' + @sSQL)

---------------------------------------------------------------------QUA TRINH CONG TAC------------------------------------------

Set @sSQL = 'Select DISTINCT HistoryID,  T00.DivisionID, T00.DepartmentID, T00.TeamID, T00.EmployeeID, T00.IsPast, T00.IsBeforeTranfer, 
	T00.FromMonth, T00.FromYear, T00.ToMonth, T00.ToYear,  T00.DutyID, Works, 
	case when IsPast = 1 then T00.DivisionName else T01.DivisionName end as DivisionName,  
	case when IsPast = 1  then T00.DepartmentName else T02.DepartmentName end as DepartmentName, 
	case when IsPast = 1  then T00.TeamName else T03.TeamName end as TeamName,
	case when IsPast = 1 then T00.DutyName else T04.DutyName end as DutyName,
	T00.SalaryAmounts, T00.SalaryCoefficient, T00.Description, T00.Notes, 
	T00.DivisionIDOld, T00.DepartmentIDOld, T00.TeamIDOld, T00.DutyIDOld,  T00.WorksOld, T00.ContactTelephone,
	T00.Contactor, T00.ContactAddress, 2 as PrintStatus
From HT1302 T00 left join AT1101 T01 on T00.DivisionID = T01.DivisionID
	left join AT1102  T02 on T02.DivisionID = T00.DivisionID and T02.DepartmentID = T00.DepartmentID
	left join HT1101 T03 on T03.DivisionID = T00.DivisionID and T03.DepartmentID = T00.DepartmentID and  T03.TeamID = T00.TeamID
	left join  HT1102 T04 on T04.DutyID = T00.DutyName and T04.DivisionID = T00.DivisionID 
	inner join HV1400 V00 on V00.EmployeeID = T00.EmployeeID AND V00.DivisionID = T00.DivisionID

	Where T00.EmployeeID= ''' + @EmployeeID+ ''' AND Too.DivisionID = ''' + @DivisionID + ''''

if exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'HV2817')
	Drop view HV2817
EXEC('Create view HV2817 ---tao boi HP2815
			as ' + @sSQL)

-------------------------------------------------------------------------HOP DONG LAO DONG------------------------------------------------

Set @sSQL=' Select H00.*,H02.DutyName,HV00.FullName, HV01.FullName as SignPersonName,ContractTypeName , 3 as PrintStatus
	From HT1360 H00 left join HT1102 H02 on H02.DutyID = H00.DutyID AND H02.DivisionID = H00.DivisionID
		Left join HV1400 HV00 on HV00.EmployeeID= H00.EmployeeID AND HV00.DivisionID= H00.DivisionID
		left join HV1400 HV01 on HV01.EmployeeID=H00.SignPersonID AND HV01.DivisionID=H00.DivisionID 
		left join HT1105 HT05 on HT05.ContractTypeID=H00.ContractTypeID AND HT05.DivisionID=H00.DivisionID
		Where H00.DivisionID=  ''' + @DivisionID+ '''  and H00.EmployeeID =  ''' + @EmployeeID+ ''' '

if exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'HV2818')
	Drop view HV2818
EXEC('Create view HV2818 ---tao boi HP2815
			as ' + @sSQL)



---------------------------------------------------------------------------QUA TRINH HOC TAP---------------------------------------------------------

Set @sSQL='Select HT01.DivisionID, HT01.EmployeeID, HT01.HistoryID, 
		HT01.SchoolID, HT03.SchoolName,
		HT01.MajorID, HT04.MajorName, 
		TypeName = Case  HT01.TypeID When  1 then ''Chính quy taäp chung''
						 When  2 then ''Taïi chöùc''
						 When  3 then ''Cöû tuyeån''
						 When  4 then ''Boå tuùc''
						 When  9 then ''Khaùc''
			         End,
		HT01.FromMonth, HT01.FromYear,
		HT01.ToMonth,HT01.ToYear,
  		HT01.Description, HT01.Notes, 4 as PrintStatus
From HT1301 as HT01 
		Left Join HT1003 HT03 On HT03.SchoolID = HT01.SchoolID AND HT03.DivisionID = HT01.DivisionID
		Left Join HT1004 HT04 On HT04.MajorID = HT01.MajorID AND HT04.DivisionID = HT01.DivisionID
Where HT01.EmployeeID = '''+@EmployeeID+''' AND HT01.DivisionID = ''' + @DivisionID + ''''

if exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'HV2819')
	Drop view HV2819
EXEC('Create view HV2819 ---tao boi HP2815
			as ' + @sSQL)
GO

