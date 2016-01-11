/****** Object:  StoredProcedure [dbo].[HP2422]    Script Date: 08/02/2010 15:14:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created by Vo Thanh Huong, Date 09/06/2004
----- In cham cong thang
/********************************************
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2422] 		@DivisionID nvarchar(50),
					@DepartmentID nvarchar(50),
					@TeamID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int

 AS
	Declare @Em_cur as cursor,
		@EmployeeID as nvarchar(50),
		@sSQL as nvarchar(4000)

Set @sSQL  ='
Select 	HT2402.DivisionID,  HT2402.DepartmentID, HT2402.TeamID, HT2402.EmployeeID, 
	HV1400.FullName,
	HT2402.AbsentTypeID,  UnitID, AbsentName,  DutyID, Birthday,
	Sum( AbsentAmount) AS AbsentAmount
From HT2402 	inner join HT1013 on HT1013.AbsentTypeID = HT2402.AbsentTypeID and HT1013.DivisionID = HT2402.DivisionID
		inner join HV1400 on HV1400.EmployeeID = HT2402.EmployeeID and HV1400.DivisionID = HT2402.DivisionID
Where HT2402.DivisionID = N''' + @DivisionID + ''' and 
	HT2402.DepartmentID like N''' + @DepartmentID + ''' and 
	ISNULL(HT2402.TeamID, ''' +  ''') like N''' + @TeamID + ''' and  
	TranMonth  = ' + STR(@TranMonth) + ' and 
	TranYear = ' + STR(@TranYear) +  
' Group by HT2402.DivisionID,  HT2402.DepartmentID,  HT2402.TeamID, HT2402.EmployeeID , HT2402.AbsentTypeID, UnitID, DutyID, Birthday, HV1400.FullName, AbsentName'

--Print @sSQL 
if not Exists (Select top 1 1 From SysObjects Where Xtype ='V' and Name = 'HV2422')
	Exec (' Create View HV2422  ---tao boi HP2422
			as '+@sSQL)
Else
	Exec (' Alter  View HV2422  ---tao boi HP2422
			as '+@sSQL)
GO
