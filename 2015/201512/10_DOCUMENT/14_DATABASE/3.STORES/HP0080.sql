IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0080]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0080]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







-- <Summary>
---- Do nguon danh sach nhan vien
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- 
---- Create On 09/08/2013 by Le Thu Thu Hien
---- 
---- Modified On 09/08/2013 by Thanh Son : 
---- Modified On 27/12/2014 by Le Thi Thu Hien : Bo sung 10 cot ghi chu, chuc danh  
-- <Example>
---- EXEC HP0080 'AS', '', 4, 2013, 9 , 'BKS', 'SX', '%',  'ASOFTADMIN'

CREATE PROCEDURE HP0080
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@TranMonth AS INT,
	@TranYear AS INT,
	@Status AS NVARCHAR(2),
	@FromDepartment AS NVARCHAR(50),
	@ToDepartment AS NVARCHAR(50),
	@TeamID AS NVARCHAR(50),
	@GroupID AS NVARCHAR(50)
) 
AS 

DECLARE @sSQL AS NVARCHAR(MAX)
DECLARE @sSQL1 AS NVARCHAR(MAX),
		@Condition NVARCHAR(4000)
SET NOCOUNT OFF
If @UserID<>''
EXEC AP1409 @DivisionID,'ASOFTHRM','DE','DE',@UserID,@GroupID,0,@Condition OUTPUT , 1
   
SET NOCOUNT ON
SET @sSQL = N'      
SELECT YEAR(Birthday) AS Year,
		Cast(Birthday AS DateTime) as Birthday,
		DATEDIFF(YEAR, HT03.WorkDate, GETDATE()) AS YearTime ,
		HT00.DivisionID, HT00.EmployeeID, 
		HT00.Orders,HT00.S1,HT00.S2,HT00.S3,
		Ltrim(RTrim(isnull(HT00.LastName,'''')))+ '' '' + LTrim(RTrim(isnull(HT00.MiddleName,''''))) + '' '' + LTrim(RTrim(Isnull(HT00.FirstName,''''))) AS FullName,
		HT00.LastName, HT00.MiddleName, HT00.FirstName,
		HT00.ShortName, HT00.Alias, HT00.BornPlace,
		HT1001.EthnicName,
		HT1002.ReligionName,
		HT01.EducationLevelID,HT01.PoliticsID,
		HT02.BankAccountNo, A.AssociationID,
        HT02.PersonalTaxID,HT02.SoInsuranceNo,
		HT00.IsMale,HT03.CompanyDate,
		(Case When HT00.IsMale=1 then N''Nam'' else N''Nữ'' End) as IsMaleName, 

		HT00.NativeCountry, HT00.PassportNo, HT00.PassportDate, 
		HT00.PassportEnd, HT00.IdentifyCardNo, HT00.IdentifyDate, HT00.IdentifyPlace, 

		HT00.IsSingle,
		(Case When HT00.IsSingle=1 then N''Độc thân'' else N''Đã lập gia đình'' End) as IsSingleName, 
		(Case HT00.EmployeeStatus
				when 0 then N''Tuyển dụng''
				when 1 then N''Đang làm''
				when 2 then N''Thử việc''
				when 3 then N''Tạm nghỉ''
				else N''Nghỉ việc'' end) as StatusName,
	
		HT00.CountryID, AT01.CountryName, 
		LTrim(RTrim(Isnull(HT00.PermanentAddress,''''))) + '' '' + LTrim(RTrim(Isnull(HT00.DistrictID,''''))) + '' '' +
		(Case when isnull(HT00.CityID,'''') <> '''' then  LTrim(RTrim(isnull(AT02.CityName,'''')))  else  ''''  End  ) AS FullAddress,
		--LTrim(RTrim(isnull(HT00.CityID,'''')))  AS FullAddress, 
		HT00.CityID, AT02.CityName, HT00.DistrictID, HT00.PermanentAddress, HT00.TemporaryAddress,
		HT00.Notes, HT00.HealthStatus, HT00.HomePhone, 
		HT00.HomeFax, HT00.MobiPhone, HT00.Email,
		HT00.CreateDate, HT00.CreateUserID, HT00.LastModifyDate, HT00.LastModifyUserID, HT03.IsOtherDayPerMonth,
		HT00.IsForeigner,HT00.RecruitTimeID,

		-- Thong tin ve he so chi tieu
		HT03.SalaryCoefficient, HT03.DutyCoefficient, HT03.TimeCoefficient, HT00.DepartmentID, A03.DepartmentName,
		ISNULL(HT00.TeamID,'''') AS TEAMID,T01.TeamName, 
		HT03.DutyID, DutyName, HT03.TitleID, HT1106.TitleName, HT1106.TitleNameE,
		HT03.TaxObjectID, HT00.EmployeeStatus, HT03.Experience,
		HT03.SuggestSalary, HT03.RecruitDate, HT03.RecruitPlace, HT03.WorkDate,HT03.LeaveDate, HT07.QuitJobID, HT07.QuitJobName,
		HT03.C01, HT03.C02, HT03.C03, HT03.C04, HT03.C05, HT03.C06, HT03.C07,
		HT03.C08, HT03.C09, HT03.C10, HT03.C11, HT03.C12, HT03.C13, HT03.BaseSalary, HT03.InsuranceSalary,
		HT03.Salary01, HT03.Salary02, HT03.Salary03, HT03.Target01ID, HT03.Target02ID,
		HT03.Target03ID, HT03.Target04ID, HT03.Target05ID, HT03.Target06ID, HT03.Target07ID,
		HT03.Target08ID, HT03.Target09ID, HT03.Target10ID, HT03.TargetAmount01, 
		HT03.TargetAmount02, HT03.TargetAmount03, HT03.TargetAmount04, HT03.TargetAmount05,
		HT03.TargetAmount06, HT03.TargetAmount07, HT03.TargetAmount08, HT03.TargetAmount09, HT03.TargetAmount10, HT03.LoaCondID, HT06.LoaCondName, 
		HT03.ApplyDate, HT03.BeginProbationDate, HT03.EndProbationDate, HT03.ProbationNote, HT03. FileID, HT03.ExpenseAccountID,HT03.PayableAccountID, HT03.PerInTaxID,
		HT00.EthnicID,HT00.ReligionID,
		HT1413.N01,HT1413.N02,HT1413.N03,HT1413.N04,HT1413.N05,
		HT1413.N06,HT1413.N07,HT1413.N08,HT1413.N09,HT1413.N10
'
SET @sSQL1 = N'
FROM HT1400 AS HT00 
LEFT JOIN HT1401 AS HT01 ON HT00.EmployeeID = HT01.EmployeeID AND  HT00.DivisionID = HT01.DivisionID
LEFT JOIN HT1402 AS HT02 ON HT00.EmployeeID = HT02.EmployeeID AND  HT00.DivisionID = HT02.DivisionID
LEFT JOIN HT1403 AS HT03 ON HT00.EmployeeID = HT03.EmployeeID AND  HT00.DivisionID = HT03.DivisionID
LEFT JOIN HT1413 AS HT1413 ON HT1413.DivisionID = HT00.DivisionID AND HT1413.EmployeeID = HT00.EmployeeID
LEFT JOIN (SELECT DivisionID,EmployeeID, MAX(AssociationID)AS AssociationID  FROM HT1405 GROUP BY DivisionID,EmployeeID)A ON A.DivisionID=HT00.DivisionID AND A.EmployeeID = HT00.EmployeeID
--LEFT JOIN HT1405 AS T05 ON HT00.EmployeeID = T05.EmployeeID AND HT00.DivisionID = T05.DivisionID 
LEFT JOIN HT1101 AS T01 ON HT00.TeamID = T01.TeamID AND HT00.DepartmentID =T01.DepartmentID AND  HT00.DivisionID = T01.DivisionID
LEFT JOIN HT1107 HT07 ON HT03.QuitJobID = HT07.QuitJobID AND  HT03.DivisionID = HT07.DivisionID
LEFT JOIN HT1001  ON HT00.EthnicID = HT1001.EthnicID  AND  HT00.DivisionID = HT1001.DivisionID
LEFT JOIN HT1002  ON HT00.ReligionID = HT1002.ReligionID AND  HT00.DivisionID = HT1002.DivisionID
LEFT JOIN HT1102 ON HT03.DutyID = HT1102.DutyID  AND  HT03.DivisionID = HT1102.DivisionID
LEFT JOIN HT1005 HT05 ON HT05.EducationLevelID = HT01.EducationLevelID AND  HT05.DivisionID = HT01.DivisionID
--		LEFT JOIN HT1007 HT07 ON HT07.LanguageLevelID = HT01.LanguageLevel1ID
LEFT JOIN AT1001 AT01 ON HT00.CountryID = AT01.CountryID AND  HT00.DivisionID = AT01.DivisionID
LEFT JOIN AT1002 AT02 ON isnull(HT00.CityID,'''') = isnull(AT02.CityID,'''')  AND  HT00.DivisionID = AT02.DivisionID
LEFT JOIN AT1102 A03 ON A03.DivisionID = HT00.DivisionID AND A03.DepartmentID = HT00.DepartmentID  AND  HT00.DivisionID = A03.DivisionID
LEFT JOIN HT2806 HT06 ON  HT03.LoaCondID = HT06.LoaCondID  AND  HT03.DivisionID = HT06.DivisionID
LEFT JOIN HT1106 AS HT1106 ON HT1106.DivisionID = HT00.DivisionID AND HT1106.TitleID = HT03.TitleID

WHERE	HT00.DivisionID = '''+@DivisionID+'''
		And HT00.DepartmentID between '''+@FromDepartment+''' And '''+@ToDepartment+'''
		'+ CASE WHEN @UserID<>'' AND ISNULL (@Condition, '')  <> ''Then ' AND ISNULL(HT00.DepartmentID,''#'') In ' + @Condition Else '' END +'
		AND ISNULL(HT00.TeamID, '''') LIKE '''+@TeamID+'''
		AND HT00.EmployeeStatus LIKE '''+@Status+'''

ORDER BY EmployeeID
     
      '
EXEC (@sSQL +@sSQL1)
PRINT(@sSQL)
PRINT(@sSQL1)






GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

