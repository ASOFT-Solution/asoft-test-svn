/****** Object:  StoredProcedure [dbo].[HP1403]    Script Date: 07/29/2010 14:27:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
---Created by: Vo Thanh Huong, date: 20/09/2004
---purpose: Xu ly so lieu in SYLL
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[HP1403]  @DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@TeamID nvarchar(50),	
				@EmployeeID nvarchar(50)			
AS
DECLARE @sSQL nvarchar(4000)

Set @sSQL = 'Select HV00.DivisionID, HV00.FullName, HV00.Alias, HV00.Birthday, HV00.BornPlace, HV00.IsMale, HV00.NativeCountry , 
		HV00.PermanentAddress, HV00.TemporaryAddress,  HV00.EthnicName, HV00.ReligionName, HV00.HomePhone, 
		HV00.MobiPhone, isnull(HV00.FatherName,'''') as FatherName, HV00.FatherJob,HV00.FatherYear, HV00.FatherAddress,
		isnull(HV00.MotherName, '''') as MotherName, HV00.MotherJob,HV00.MotherYear, HV00.MotherAddress,
		HT01.HistoryID, 	HT01.SchoolID, HT03.SchoolName, 
		HT01.MajorID, HT04.MajorName, 
		TypeName = Case  HT01.TypeID When  1 then ''Chính quy taäp chung''
						 When  2 then ''Taïi chöùc''
						 When  3 then ''Cöû tuyeån''
						 When  4 then ''Boå tuùc''
						 When  9 then ''Khaùc''
			         End,
		cast(HT01.FromMonth as nvarchar(2)) + ''/'' + cast( HT01.FromYear as nvarchar(4)) as FromDate ,
		cast(HT01.ToMonth as nvarchar(2)) + ''/'' + cast( HT01.ToYear as nvarchar(4)) as ToDate 
From HV1400 HV00 left join HT1301 as HT01  on HV00.EmployeeID = HT01.EmployeeID and HV00.DivisionID = HT01.DivisionID
		left Join HT1003 HT03 On HT03.SchoolID = HT01.SchoolID and HT03.DivisionID = HT01.DivisionID
		left Join HT1004 HT04 On HT04.MajorID = HT01.MajorID and HT04.DivisionID = HT01.DivisionID
Where HV00.EmployeeID like ''' + @EmployeeID + ''' and
	DivisionID like ''' + @DivisionID + ''' and
	DepartmentID like ''' + @DepartmentID + ''' and
	isnull(TeamID, '''') like ''' +  isnull(@TeamID, '''') + ''''

If not exists(Select 1 From sysObjects Where XType = 'V' and Name = 'HV1403')
	exec('Create view HV1403 ----tao boi HP1403
			as ' + @sSQL)
else
	exec('Alter view HV1403 ----tao boi HP1403
			as ' + @sSQL)





