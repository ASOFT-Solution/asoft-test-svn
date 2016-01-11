
/****** Object:  StoredProcedure [dbo].[HP2504]    Script Date: 12/02/2011 17:15:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2504]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2504]
GO


/****** Object:  StoredProcedure [dbo].[HP2504]    Script Date: 12/02/2011 17:15:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----Created by: Vo Thanh Huong  
----Created date: 30/07/2004  
----purpose: In báo cáo danh sach lao d?ng - l?c theo lo?i h?p d?ng lao d?ng  
----Edit by: Dang Le Bao Quynh; Date: 30/09/2006  
----Purpose: Sua lai cau lenh  len(Works) = 0 thay cho isnull(Works,'') like ''  
----Edit by: Trung Dung; Date: 27/09/2012 - Them truong ExpireDays
  
CREATE PROCEDURE [dbo].[HP2504] @DivisionID nvarchar(50),  
  @DepartmentID nvarchar(50),  
  @ToDepartmentID nvarchar(50),  
  @TeamID nvarchar(50),  
  @ContractTypeID nvarchar(50)    
AS  
  
Declare @sSQL as nvarchar(4000)  
Set @sSQL = 'Select Orders, HT03.DivisionID, DepartmentID, TeamID, HV.EmployeeID, FullName, IsMale, Birthday, IdentifyCardNo,EducationLevelName, 
FullAddress, RecruitDate, Notes,  
case when len(ltrim(Works)) = 0 then DutyName else Works end as Works,    
case When HT02.BaseSalary = 0 then isnull(HV.BaseSalary,0) else HT02.BaseSalary  end as BaseSalary,  
isnull(HT03.ContractTypeID, ''' + ''') as ContractTypeID, isnull(HT03.ContractTypeName,''' + ''') as ContractTypeName,
datediff(day,getdate(),dateadd(month,HT03.Months,HT02.SignDate)) AS ExpireDays,
HT02.WorkDate,HT02.WorkEndDate,
HT02.TestFromDate,HT02.TestEndDate
From HV1400 HV  inner  join 
(
	Select HT00.EmployeeID, HT01.SignDate,HT01.WorkDate,HT01.WorkEndDate,
	HT01.TestFromDate,HT01.TestEndDate,
	Max(isnull(ContractTypeID, ''' + ''')) as ContractTypeID, Max(isnull(Works,''' + ''')) as Works, Max(isnull(HT00.BaseSalary, 0)) as BaseSalary     
	From HT1360  HT00 inner join    
	(
		Select EmployeeID, Max(SignDate) as SignDate , 
		Max(WorkDate ) as WorkDate  , Max(WorkEndDate ) as WorkEndDate,
		Max(TestFromDate ) as TestFromDate  , Max(TestEndDate ) as TestEndDate
		From HT1360 
		Where DivisionID = '''+ @DivisionID +'''
		group by EmployeeID
	)HT01 
	on HT00.EmployeeID = HT01.EmployeeID and HT00.SignDate = HT01.SignDate and HT00.DivisionID = '''+@DivisionID+'''
	group by HT00.EmployeeID,HT01.SignDate,HT01.WorkDate,HT01.WorkEndDate,
	HT01.TestFromDate,HT01.TestEndDate
) HT02 
on HT02.EmployeeID = HV.EmployeeID and HV.DivisionID = '''+@DivisionID+'''
inner join HT1105 HT03 on HT03.ContractTypeID = HT02.ContractTypeID and HT03.DivisionID = '''+@DivisionID+'''
 Where HT03.DivisionID = ''' + @DivisionID + ''' and  
  DepartmentID between ''' + @DepartmentID + ''' and ''' + @ToDepartmentID + ''' and  
  Isnull(TeamID, ''' + ''') like Isnull(''' + @TeamID + ''' ,''' + ''') and    
  Isnull(HT03.ContractTypeID, ''' + ''') like ''' + @ContractTypeID + ''''  
    
  
  
if not exists(Select Top 1 1 from sysObjects where Xtype = 'V' and Name = 'HV2504')  
 EXEC('Create View HV2504 --- tao boi HP2504  
   as ' + @sSQL)  
else  
 EXEC('Alter View HV2504 --- tao boi HP2504  
   as ' + @sSQL)
GO


