/****** Object:  View [dbo].[HV1405]    Script Date: 11/16/2011 11:45:25 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[HV1405]'))
DROP VIEW [dbo].[HV1405]
go
CREATE  View [dbo].[HV1405] as   
Select   
 -- C¸ nh©n  
 HT00.DivisionID, HT00.EmployeeID,   
 Ltrim(RTrim(isnull(HT00.LastName,'')))+ ' ' + LTrim(RTrim(isnull(HT00.MiddleName,''))) + ' ' + LTrim(RTrim(Isnull(HT00.FirstName,''))) As FullName,  
 HT00.LastName, HT00.MiddleName, HT00.FirstName,  
 HT00.ShortName, HT00.Alias, HT00.Birthday, HT00.BornPlace,   
  
 --(Case when HT00.IsMale =0 then 1 else 0 end) as IsMale,   
 HT00.IsMale,  
 HT00.NativeCountry, HT00.PassportNo, HT00.PassportDate,   
 HT00.PassportEnd, HT00.IdentifyCardNo, HT00.IdentifyDate, HT00.IdentifyPlace,   
  
 HT00.IsSingle,  
   
 HT00.ImageID, HT00.CountryID,   
 LTrim(RTrim(Isnull(HT00.PermanentAddress,''))) + ' ' + LTrim(RTrim(Isnull(HT00.DistrictID,''))) + ' ' +  LTrim(RTrim(isnull(HT00.CityID,'')))  As FullAddress,   
 HT00.CityID, HT00.DistrictID, HT00.PermanentAddress, HT00.TemporaryAddress,  
  
 HT00.EthnicID, HT1001.EthnicName, HT00.ReligionID, HT1002.ReligionName,   
  
 HT00.Notes, HT00.HealthStatus, HT00.HomePhone,   
 HT00.HomeFax, HT00.MobiPhone, HT00.Email,  
 HT00.CreateDate, HT00.CreateUserID, HT00.LastModifyDate, HT00.LastModifyUserID,  
  
 -- Gia ®×nh  
 HT01.FatherName, HT01.FatherYear, HT01.FatherJob, HT01.FatherAddress, HT01.FatherNote,  
 HT01.IsFatherDeath,   
 HT01.MotherName, HT01.MotherYear, HT01.MotherJob,HT01.MotherAddress, HT01.MotherNote,  
 HT01.IsMotherDeath,  
 HT01.SpouseName, HT01.SpouseYear, HT01.SpouseAddress, HT01.SpouseNote,  
 HT01.SpouseJob, HT01.IsSpouseDeath,   
 HT01.EducationLevelID, HT01.PoliticsID,   
 HT01.Language1ID, HT01.Language2ID, HT01.Language3ID, HT01.LanguageLevel1ID,  
 HT01.LanguageLevel2ID, HT01.LanguageLevel3ID,  
  
 -- Th«ng tin x· héi  
 HT02.BankID, HT02.BankAccountNo, HT02.SoInsuranceNo, HT02.SoInsurBeginDate,  
 HT02.HeInsuranceNo, HT02.ArmyJoinDate, HT02.ArmyEndDate, HT02.ArmyLevel,  
 HT02.Hobby, HT02.HospitalID, HT02.Height, HT02.Weight, HT02.BloodGroup,  
  
 -- Thong tin ve he so chi tieu  
 HT03.SalaryCoefficient, HT03.DutyCoefficient, HT03.TimeCoefficient, HT03.DepartmentID,  
 isnull(HT03.TeamID,'') as TeamID, HT04.TeamName,HT03.DutyID, HT03.TaxObjectID, HT03.EmployeeStatus, HT03.Experience,  
 HT03.SuggestSalary, HT03.RecruitDate, HT03.RecruitPlace, HT03.WorkDate,  
 HT03.C01, HT03.C02, HT03.C03, HT03.C04, HT03.C05, HT03.C06, HT03.C07,  
 HT03.C08, HT03.C09, HT03.C10, HT03.BaseSalary, HT03.InsuranceSalary,  
 HT03.Salary01, HT03.Salary02, HT03.Salary03, HT03.Target01ID, HT03.Target02ID,  
 HT03.Target03ID, HT03.Target04ID, HT03.Target05ID, HT03.Target06ID, HT03.Target07ID,  
 HT03.Target08ID, HT03.Target09ID, HT03.Target10ID, HT03.TargetAmount01,   
 HT03.TargetAmount02, HT03.TargetAmount03, HT03.TargetAmount04, HT03.TargetAmount05,  
 HT03.TargetAmount06, HT03.TargetAmount07, HT03.TargetAmount08, HT03.TargetAmount09, HT03.TargetAmount10  
From HT1400 As HT00   
  Left Join HT1401 As HT01 On HT00.EmployeeID = HT01.EmployeeID  
     and  HT00.DivisionID = HT01.DivisionID  
  Left Join HT1402 As HT02 On HT00.EmployeeID = HT02.EmployeeID   
     and  HT00.DivisionID = HT02.DivisionID  
  Left Join HT1403 As HT03 On HT00.EmployeeID = HT03.EmployeeID   
     and  HT00.DivisionID = HT03.DivisionID  
  Left Join HT1001  On HT00.EthnicID = HT1001.EthnicID  and HT00.DivisionID = HT1001.DivisionID  
  Left Join HT1002  On HT00.ReligionID = HT1002.ReligionID  and HT00.DivisionID = HT1002.DivisionID  
  Left Join HT1101 As HT04 On HT04.TeamID = HT00.TeamID  and HT04.DivisionID = HT00.DivisionID  
Where HT03.EmployeeStatus=1 