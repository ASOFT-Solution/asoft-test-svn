
/****** Object:  StoredProcedure [dbo].[HP1404]    Script Date: 01/09/2012 10:46:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1404]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1404]
GO

/****** Object:  StoredProcedure [dbo].[HP1404]    Script Date: 01/09/2012 10:46:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--- Created by: Nguyen Van Nhan and Vo Thanh Huong
-- Created date: 25/05/2004
-- Purpose:  Nhom theo nhan chi tieu thong ke, du lieu duoc tra ra HV1404
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/

CREATE PROCEDURE [dbo].[HP1404]  @DivisionID nvarchar(50),
				 @TablesName nvarchar(50),
				 @FieldID nvarchar(100),
				 @Type tinyint

 AS

Declare  @strSQL as nvarchar(4000),
	@TypeID as nvarchar(50)

Set @TablesName = Ltrim(Rtrim(@TablesName))
Set @FieldID = Ltrim(Rtrim(@FieldID))
If  @Type =0 or @Type =99
Set @strSQL ='
Select 
	-- C¸ nh©n
	HT00.'+@FieldID+' as GroupID,
	T.'+left(@FieldID, len(@FieldID) - 2) +'Name as  GroupName,
	T.EmployeeAmount as EmployeeAmount,
	HT00.DivisionID, HT00.EmployeeID, 
	Ltrim(RTrim(isnull(HT00.LastName,'''')))+ '' '' + LTrim(RTrim(isnull(HT00.MiddleName,''''))) + '' '' + LTrim(RTrim(Isnull(HT00.FirstName,''''))) As FullName,
	HT00.LastName, HT00.MiddleName, HT00.FirstName,
	HT00.ShortName, HT00.Alias, HT00.Birthday, year(HT00.Birthday) as Year, HT00.BornPlace, 

	--(Case when HT00.IsMale =0 then 1 else 0 end) as IsMale, 
	HT00.IsMale,
	HT00.NativeCountry, HT00.PassportNo, HT00.PassportDate, 
	HT00.PassportEnd, HT00.IdentifyCardNo, HT00.IdentifyDate, HT00.IdentifyPlace, 

	HT00.IsSingle,
	
	HT00.ImageID, HT00.CountryID, 
	LTrim(RTrim(Isnull(HT00.PermanentAddress,''''))) + '' '' + LTrim(RTrim(Isnull(HT00.DistrictID,''''))) + '' '' +  LTrim(RTrim(isnull(HT00.CityID,'''')))  As FullAddress, 
	HT00.CityID, HT00.DistrictID, HT00.PermanentAddress, HT00.TemporaryAddress,

	HT00.EthnicID, HT00.EthnicName, HT00.ReligionID, HT00.ReligionName, 

	HT00.Notes, HT00.HealthStatus, HT00.HomePhone, 
	HT00.HomeFax, HT00.MobiPhone, HT00.Email,
	HT00.CreateDate, HT00.CreateUserID, HT00.LastModifyDate, HT00.LastModifyUserID,

	-- Gia ®×nh
	HT00.FatherName, HT00.FatherYear, HT00.FatherJob, HT00.FatherAddress, HT00.FatherNote,
	HT00.IsFatherDeath, 
	HT00.MotherName, HT00.MotherYear, HT00.MotherJob,HT00.MotherAddress, HT00.MotherNote,
	HT00.IsMotherDeath,
	HT00.SpouseName, HT00.SpouseYear, HT00.SpouseAddress, HT00.SpouseNote,
	HT00.SpouseJob, HT00.IsSpouseDeath, 
	HT00.EducationLevelID, HT00.PoliticsID, 
	HT00.Language1ID, HT00.Language2ID, HT00.Language3ID, HT00.LanguageLevel1ID,
	HT00.LanguageLevel2ID, HT00.LanguageLevel3ID,

	-- Th«ng tin x· héi
	HT00.BankID, HT00.BankAccountNo, HT00.SoInsuranceNo, HT00.SoInsurBeginDate,
	HT00.HeInsuranceNo, HT00.ArmyJoinDate, HT00.ArmyEndDate, HT00.ArmyLevel,
	HT00.Hobby, HT00.HospitalID, HT00.Height, HT00.Weight, HT00.BloodGroup,

	-- Thong tin ve he so chi tieu
	HT00.SalaryCoefficient, HT00.DutyCoefficient, HT00.TimeCoefficient, HT00.DepartmentID,
	isnull(HT00.TeamID,'''') as TeamID, HT00.TeamName,HT00.DutyID, HT00.TaxObjectID, HT00.EmployeeStatus, HT00.Experience,
	HT00.SuggestSalary, HT00.RecruitDate, HT00.RecruitPlace, HT00.WorkDate,
	HT00.C01, HT00.C02, HT00.C03, HT00.C04, HT00.C05, HT00.C06, HT00.C07,
	HT00.C08, HT00.C09, HT00.C10, HT00.BaseSalary, HT00.InsuranceSalary,
	HT00.Salary01, HT00.Salary02, HT00.Salary03, HT00.Target01ID, HT00.Target02ID,
	HT00.Target03ID, HT00.Target04ID, HT00.Target05ID, HT00.Target06ID, HT00.Target07ID,
	HT00.Target08ID, HT00.Target09ID, HT00.Target10ID, HT00.TargetAmount01, 
	HT00.TargetAmount02, HT00.TargetAmount03, HT00.TargetAmount04, HT00.TargetAmount05,
	HT00.TargetAmount06, HT00.TargetAmount07, HT00.TargetAmount08, HT00.TargetAmount09, HT00.TargetAmount10
From HV1405 HT00  Left join  HV2222  T on T.'+@FieldID+' = HT00.'+@FieldID+'
Where HT00.EmployeeStatus=1  and HT00.DivisionID = '''+@DivisionID+''' '
Else
Set @strSQL ='
Select 
	-- C¸ nh©n
	HT00.'+@FieldID+' as GroupID,
	T.Description  as  GroupName,
	T.EmployeeAmount as EmployeeAmount,
	HT00.DivisionID, HT00.EmployeeID, 
	Ltrim(RTrim(isnull(HT00.LastName,'''')))+ '' '' + LTrim(RTrim(isnull(HT00.MiddleName,''''))) + '' '' + LTrim(RTrim(Isnull(HT00.FirstName,''''))) As FullName,
	HT00.LastName, HT00.MiddleName, HT00.FirstName,
	HT00.ShortName, HT00.Alias, HT00.Birthday, year(HT00.Birthday) as Year, HT00.BornPlace, 

	--(Case when HT00.IsMale =0 then 1 else 0 end) as IsMale, 
	HT00.IsMale,
	HT00.NativeCountry, HT00.PassportNo, HT00.PassportDate, 
	HT00.PassportEnd, HT00.IdentifyCardNo, HT00.IdentifyDate, HT00.IdentifyPlace, 

	HT00.IsSingle,
	
	HT00.ImageID, HT00.CountryID, 
	LTrim(RTrim(Isnull(HT00.PermanentAddress,''''))) + '' '' + LTrim(RTrim(Isnull(HT00.DistrictID,''''))) + '' '' +  LTrim(RTrim(isnull(HT00.CityID,'''')))  As FullAddress, 
	HT00.CityID, HT00.DistrictID, HT00.PermanentAddress, HT00.TemporaryAddress,

	HT00.EthnicID, HT00.EthnicName, HT00.ReligionID, HT00.ReligionName, 

	HT00.Notes, HT00.HealthStatus, HT00.HomePhone, 
	HT00.HomeFax, HT00.MobiPhone, HT00.Email,
	HT00.CreateDate, HT00.CreateUserID, HT00.LastModifyDate, HT00.LastModifyUserID,

	-- Gia ®×nh
	HT00.FatherName, HT00.FatherYear, HT00.FatherJob, HT00.FatherAddress, HT00.FatherNote,
	HT00.IsFatherDeath, 
	HT00.MotherName, HT00.MotherYear, HT00.MotherJob,HT00.MotherAddress, HT00.MotherNote,
	HT00.IsMotherDeath,
	HT00.SpouseName, HT00.SpouseYear, HT00.SpouseAddress, HT00.SpouseNote,
	HT00.SpouseJob, HT00.IsSpouseDeath, 
	HT00.EducationLevelID, HT00.PoliticsID, 
	HT00.Language1ID, HT00.Language2ID, HT00.Language3ID, HT00.LanguageLevel1ID,
	HT00.LanguageLevel2ID, HT00.LanguageLevel3ID,

	-- Th«ng tin x· héi
	HT00.BankID, HT00.BankAccountNo, HT00.SoInsuranceNo, HT00.SoInsurBeginDate,
	HT00.HeInsuranceNo, HT00.ArmyJoinDate, HT00.ArmyEndDate, HT00.ArmyLevel,
	HT00.Hobby, HT00.HospitalID, HT00.Height, HT00.Weight, HT00.BloodGroup,

	-- Thong tin ve he so chi tieu
	HT00.SalaryCoefficient, HT00.DutyCoefficient, HT00.TimeCoefficient, HT00.DepartmentID,
	isnull(HT00.TeamID,'''') as TeamID, HT00.TeamName, HT00.DutyID, HT00.TaxObjectID, HT00.EmployeeStatus, HT00.Experience,
	HT00.SuggestSalary, HT00.RecruitDate, HT00.RecruitPlace, HT00.WorkDate,
	HT00.C01, HT00.C02, HT00.C03, HT00.C04, HT00.C05, HT00.C06, HT00.C07,
	HT00.C08, HT00.C09, HT00.C10, HT00.BaseSalary, HT00.InsuranceSalary,
	HT00.Salary01, HT00.Salary02, HT00.Salary03, HT00.Target01ID, HT00.Target02ID,
	HT00.Target03ID, HT00.Target04ID, HT00.Target05ID, HT00.Target06ID, HT00.Target07ID,
	HT00.Target08ID, HT00.Target09ID, HT00.Target10ID, HT00.TargetAmount01, 
	HT00.TargetAmount02, HT00.TargetAmount03, HT00.TargetAmount04, HT00.TargetAmount05,
	HT00.TargetAmount06, HT00.TargetAmount07, HT00.TargetAmount08, HT00.TargetAmount09, HT00.TargetAmount10
From HV1405 HT00  Left join  HV2222  T on T.'+@FieldID+' = HT00.'+@FieldID+' 
Where HT00.EmployeeStatus=1 and HT00.DivisionID = '''+@DivisionID+''' '


Print @strSQL
If not exists (Select name from sysObjects Where id = Object_ID(N'[dbo].[HV1404]') and OBJECTPROPERTY(id,N'IsView')=1)
	Exec (' Create View HV1404 as ' + @strSQL)
Else
	Exec (' Alter  View HV1404 as ' + @strSQL)

GO


