IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HV1400]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HV1400]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Edited by Bao Anh	Date: 19/12/2012 Bo sung truong MajorID
---- Edited by Bao Anh	Date: 31/07/2013 Bo sung cac he so C14 -> C25
---- Edited by Bao Anh	Date: 26/08/2013 Bo sung HFromDate, HToDate
---- Modified by Thanh Sơn on 04/11/2013: Bổ sung thêm 2 trường HT03.IsJobWage,HT03.IsPiecework
---- Modified on 13/12/2013 by Le Thi Thu Hien : Bo sung them StatusID
---- Modified on 19/12/2013 by Thanh Sơn : Bo sung them SalaryLevel, SalaryLevelDate
---- Modified on 23/12/2013 by Bảo Anh : Bổ sung IdentifyCityID
---- Modified on 03/01/2013 by Bảo Anh : Bổ sung MidEmployeeID
---- Modified on 17/06/2014 by Bảo Anh : Bổ sung HospitalName
---- Modified on 30/09/2014 by Bảo Anh : Bổ sung LeaveToDate, StatusNotes
---- Modified on 12/11/2015 by Thanh Thịnh : Bổ sung 
---- Modified on 14/12/2015 by Phương Thảo : Bổ sung IsManager

CREATE  View [dbo].[HV1400] As 
Select 
	-- Ca nhan
	HT00.DivisionID, HT00.EmployeeID, 
	HT00.Orders,HT00.S1,HT00.S2,HT00.S3,
	Ltrim(RTrim(isnull(HT00.LastName,'')))+ ' ' + LTrim(RTrim(isnull(HT00.MiddleName,''))) + ' ' + LTrim(RTrim(Isnull(HT00.FirstName,''))) As FullName,
	HT00.LastName, HT00.MiddleName, HT00.FirstName,
	HT00.ShortName, HT00.Alias, HT00.Birthday, HT00.BornPlace, 
    HT03.IsJobWage,HT03.IsPiecework,
	HT00.IsMale,
	(Case When HT00.IsMale=1 then N'Nam' else N'Nữ' End) as IsMaleName, 
	
	HT00.NativeCountry, HT00.PassportNo, HT00.PassportDate, 
	HT00.PassportEnd, HT00.IdentifyCardNo, HT00.IdentifyDate, HT00.IdentifyPlace, HT00.IdentifyEnd, 

	HT00.DrivingLicenceNo, HT00.DrivingLicenceDate, HT00.DrivingLicenceEnd, HT00.DrivingLicencePlace, 

	HT00.IsSingle,
	(Case When HT00.IsSingle=1 then N'Độc thân' else N'Đã lập gia đình' End) as IsSingleName, 
	HT00.EmployeeStatus AS StatusID ,
	(Case HT00.EmployeeStatus
		when 0 then N'Tuyển dụng'
		when 1 then N'Đang làm'
		when 2 then N'Thử việc'
		when 3 then N'Tạm nghỉ'
		else N'Nghỉ việc' end) as Status,
	
	HT00.ImageID, HT00.CountryID, AT01.CountryName, 
	LTrim(RTrim(Isnull(HT00.PermanentAddress,''))) + ' ' + LTrim(RTrim(Isnull(HT00.DistrictID,''))) + ' ' +
	(Case when isnull(HT00.CityID,'') <> '' then  LTrim(RTrim(isnull(AT02.CityName,'')))  else  ''  End  ) As FullAddress,
	--LTrim(RTrim(isnull(HT00.CityID,'')))  As FullAddress, 
	HT00.CityID, AT02.CityName, HT00.DistrictID, HT00.PermanentAddress, HT00.TemporaryAddress,

	HT00.EthnicID, HT1001.EthnicName, HT00.ReligionID, HT1002.ReligionName, 

	HT00.Notes, HT00.HealthStatus, HT00.HomePhone, 
	HT00.HomeFax, HT00.MobiPhone, HT00.Email,
	HT00.CreateDate, HT00.CreateUserID, HT00.LastModifyDate, HT00.LastModifyUserID, HT03.IsOtherDayPerMonth,
	HT00.IsMale as IsMaleID, HT00.IsSingle as IsSingleID,HT00.IsForeigner,HT00.RecruitTimeID, HT00.IdentifyCityID,
	
	-- Gia Dinh
	HT01.FatherName, HT01.FatherYear, HT01.FatherJob, HT01.FatherAddress, HT01.FatherNote,
	HT01.IsFatherDeath, 
	HT01.MotherName, HT01.MotherYear, HT01.MotherJob,HT01.MotherAddress, HT01.MotherNote,
	HT01.IsMotherDeath,
	HT01.SpouseName, HT01.SpouseYear, HT01.SpouseAddress, HT01.SpouseNote,
	HT01.SpouseJob, HT01.IsSpouseDeath, 
	HT01.EducationLevelID, HT05.EducationLevelName, 
	HT01.PoliticsID, 
	HT01.Language1ID, HT01.Language2ID, HT01.Language3ID, HT01.LanguageLevel1ID,
	HT01.LanguageLevel2ID, HT01.LanguageLevel3ID, --HT07.LanguageLevelName as LanguageLevelName1,
	(select top 1 MajorID From HT1301 Where HT1301.DivisionID = HT00.DivisionID And HT1301.EmployeeID = HT00.EmployeeID) as MajorID,
	
	-- Thong tin xa hoi
	HT02.BankID, HT02.BankAccountNo, HT02.PersonalTaxID,HT02.SoInsuranceNo, HT02.SoInsurBeginDate,
	HT02.HeInsuranceNo, HT02.ArmyJoinDate, HT02.ArmyEndDate, HT02.ArmyLevel,
	HT02.Hobby, HT02.HospitalID, HT1009.HospitalName, HT02.Height, HT02.Weight, HT02.BloodGroup,-- T05.AssociationID,
	HT02.HFromDate, HT02.HToDate,
	
	-- Thong tin ve he so chi tieu
	HT03.SalaryCoefficient, HT03.DutyCoefficient, HT03.TimeCoefficient, HT00.DepartmentID, A03.DepartmentName,
	ISNULL(HT00.TeamID,'') AS TEAMID,T01.TeamName, HT03.DutyID, DutyName, HT03.TaxObjectID, HT00.EmployeeStatus, HT03.Experience,
	HT03.SuggestSalary, HT03.RecruitDate, HT03.RecruitPlace, HT03.WorkDate,HT03.LeaveDate, HT07.QuitJobID, HT07.QuitJobName,
	HT03.C01, HT03.C02, HT03.C03, HT03.C04, HT03.C05, HT03.C06, HT03.C07, HT03.C08, HT03.C09, HT03.C10, HT03.C11, HT03.C12, HT03.C13,
	HT03.C14, HT03.C15, HT03.C16, HT03.C17, HT03.C18, HT03.C19, HT03.C20, HT03.C21, HT03.C22, HT03.C23, HT03.C24, HT03.C25,
	HT03.BaseSalary, HT03.InsuranceSalary, HT03.SalaryLevel, HT03.SalaryLevelDate, HT03.CompanyDate,
	HT03.Salary01, HT03.Salary02, HT03.Salary03, HT03.Target01ID, HT03.Target02ID,
	HT03.Target03ID, HT03.Target04ID, HT03.Target05ID, HT03.Target06ID, HT03.Target07ID,
	HT03.Target08ID, HT03.Target09ID, HT03.Target10ID, HT03.TargetAmount01, 
	HT03.TargetAmount02, HT03.TargetAmount03, HT03.TargetAmount04, HT03.TargetAmount05,
	HT03.TargetAmount06, HT03.TargetAmount07, HT03.TargetAmount08, HT03.TargetAmount09, HT03.TargetAmount10, HT03.LoaCondID, HT06.LoaCondName, 
	HT03.ApplyDate, HT03.BeginProbationDate, HT03.EndProbationDate, HT03.ProbationNote, HT03. FileID, HT03.ExpenseAccountID,HT03.PayableAccountID, HT03.PerInTaxID,
	HT03.MidEmployeeID, HT03.LeaveToDate, HT03.Notes as StatusNotes,
	HT03.IsManager

From HT1400 As HT00 
LEFT JOIN HT1401 As HT01 On HT00.EmployeeID = HT01.EmployeeID and  HT00.DivisionID = HT01.DivisionID
LEFT JOIN HT1402 As HT02 On HT00.EmployeeID = HT02.EmployeeID and  HT00.DivisionID = HT02.DivisionID
LEFT JOIN HT1403 As HT03 On HT00.EmployeeID = HT03.EmployeeID and  HT00.DivisionID = HT03.DivisionID
--	LEFT JOIN HT1405 As T05 On HT00.EmployeeID = T05.EmployeeID and HT00.DivisionID = T05.DivisionID 
LEFT JOIN HT1101 As T01 On HT00.TeamID = T01.TeamID and HT00.DepartmentID =T01.DepartmentID and  HT00.DivisionID = T01.DivisionID
LEFT JOIN HT1107 HT07 On HT03.QuitJobID = HT07.QuitJobID and  HT03.DivisionID = HT07.DivisionID
LEFT JOIN HT1001  On HT00.EthnicID = HT1001.EthnicID  and  HT00.DivisionID = HT1001.DivisionID
LEFT JOIN HT1002  On HT00.ReligionID = HT1002.ReligionID and  HT00.DivisionID = HT1002.DivisionID
LEFT JOIN HT1102 on HT03.DutyID = HT1102.DutyID  and  HT03.DivisionID = HT1102.DivisionID
LEFT JOIN HT1005 HT05 on HT05.EducationLevelID = HT01.EducationLevelID and  HT05.DivisionID = HT01.DivisionID
--		LEFT JOIN HT1007 HT07 on HT07.LanguageLevelID = HT01.LanguageLevel1ID
LEFT JOIN AT1001 AT01 on HT00.CountryID = AT01.CountryID and  HT00.DivisionID = AT01.DivisionID
LEFT JOIN AT1002 AT02 on isnull(HT00.CityID,'') = isnull(AT02.CityID,'')  and  HT00.DivisionID = AT02.DivisionID
LEFT JOIN AT1102 A03 on A03.DivisionID = HT00.DivisionID and A03.DepartmentID = HT00.DepartmentID  and  HT00.DivisionID = A03.DivisionID
LEFT JOIN HT2806 HT06 on  HT03.LoaCondID = HT06.LoaCondID  and  HT03.DivisionID = HT06.DivisionID
LEFT JOIN HT1009 On HT02.DivisionID = HT1009.DivisionID and HT02.HospitalID = HT1009.HospitalID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

