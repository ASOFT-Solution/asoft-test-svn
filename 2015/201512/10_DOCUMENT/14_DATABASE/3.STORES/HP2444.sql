/****** Object:  StoredProcedure [dbo].[HP2444]    Script Date: 08/02/2010 15:14:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------Created by : Vo Thanh Huong
-----Created date: 02/06/2004
----purpose: Bao cao cham cong ngay
/********************************************
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]
'********************************************/
		
ALTER PROCEDURE [dbo].[HP2444] @DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@TeamID nvarchar(50),
				@FromDate datetime,
				@ToDate datetime	
 AS 
DECLARE @cur as cursor,
	@AbsentTypeID as nvarchar(50),
	@strExec as nvarchar(4000),
   	@strExec1 as nvarchar(4000),
	@strView as nvarchar(4000),
    @strView1 as nvarchar(4000)


SET @strExec = '  SELECT DivisionID, DepartmentID, TeamID, EmployeeID, AbsentDate, '
SET @strView = ' SELECT HV00.DivisionID, HV00.DepartmentID, HV00.TeamID, HV00.EmployeeID, FullName, AbsentDate, '

SET @cur =  CURSOR SCROLL KEYSET FOR
	Select AbsentTypeID  FROM HT1013 WHERE DivisionID = @DivisionID And IsMonth = 0
OPEN @cur
FETCH NEXT FROM @cur INTO @AbsentTypeID

WHILE @@FETCH_STATUS = 0
	BEGIN

		SET @strExec = @strExec  + 'SUM(Case when AbsenTtypeID = N''' + @AbsentTypeID +
			 '''  then AbsentAmount else 0 end)  AS ' + @AbsentTypeID + ', ' 
		SET @strView = @strView + 'SUM(' + @AbsentTypeID + ')  AS ' +  @AbsentTypeID 	+ ', '

		FETCH NEXT FROM @cur INTO @AbsentTypeID
	END

CLOSE @cur
SET @strExec =  LEFT(@strExec, LEN(@strExec) - 1)  
set @strExec1 = 
	N' From HT2401' +
	' Where DivisionID =N''' + @DivisionID + ''' and
		 DepartmentID like N''' +  @DepartmentID + ''' and
		Isnull(TeamID,'''''+ ') like N''' + @TeamID + '''  and
		 (AbsentDate between CAST(''' +  CONVERT(nvarchar(50),@FromDate,101)  + '''  AS DateTime ) 
		and CAST(''' +CONVERT(nvarchar(50),@ToDate,101)+ ''' AS DateTime) ) ' +
' GROUP BY DivisionID, DepartmentID, TeamID, EmployeeID, AbsentDate, AbsentTypeID ' ---+
---'ORDER BY DepartmentID, TeamID, EmployeeID, AbsentTypeID'

If not exists (Select name from sysObjects Where id = Object_ID(N'[dbo].[HV2443]') and OBJECTPROPERTY(id,N'IsView')=1)
	Exec (' Create View HV2443 as --tao boi HP2444
		 ' + @strExec + @strExec1)
Else
	Exec (' Alter  View HV2443 as --tao boi HP2444
		' + @strExec + @strExec1)


SET @strView =  LEFT(@strView, LEN(@strView) - 1) 
set @strView1 =  
	N' FROM HV2443 HV00 INNER JOIN HV1400 HV01 ON HV00.EmployeeID = HV01.EmployeeID and HV00.DivisionID = HV01.DivisionID' + 
	' GROUP BY HV00.DivisionID, HV00.DepartmentID, HV00.TeamID, HV00.EmployeeID, FullName, AbsentDate'

If not exists (Select name from sysObjects Where id = Object_ID(N'[dbo].[HV2444]') and OBJECTPROPERTY(id,N'IsView')=1)
	Exec (' Create View HV2444 as --tao boi HP2444
		 ' + @strView + @strView1)
Else
	Exec (' Alter  View HV2444 as --tao boi HP2444
		' + @strView + @strView1)
GO
