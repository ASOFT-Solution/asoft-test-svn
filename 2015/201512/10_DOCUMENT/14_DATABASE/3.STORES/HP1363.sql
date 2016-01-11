/****** Object:  StoredProcedure [dbo].[HP1363]    Script Date: 12/28/2011 11:53:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1363]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1363]
GO

/****** Object:  StoredProcedure [dbo].[HP1363]    Script Date: 12/28/2011 11:53:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


----Created by: Vo Thanh Huong
-----Created date: 02/07/2004
-----purpose: In hop dong lao dong
---- Modify on 26/02/2014 by Bao Anh: Bo sung Ngay den han hop dong ReSignDate 
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/
CREATE PROCEDURE [dbo].[HP1363] 	@DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@EmployeeID nvarchar(50),
				@Man nvarchar(20),
				@Woman nvarchar(20)			

 AS 

DECLARE @sSQL as nvarchar(4000)

SET @sSQL = ' SELECT HT13.*, HV01.FullName,  HV01.Birthday, HV01.IdentifyCardNo, HV01.IdentifyPlace, 
			HV01.FullAddress, HV01.EducationLevelName, AT02.DepartmentName,
			CASE HV01.IsMale when 1 THEN N'''+@Man+''' ELSE N'''+@Woman+''' END AS IsMale,  
			CASE HV02.IsMale when 1 THEN N'''+@Man+''' ELSE N'''+@Woman+''' END AS SPIsMale,  
			HV01.DistrictID, HV01.IdentifyDate , HT03.DutyName,
			HV02.FullName as SPName, HT04.DutyName as SPDutyName, HT05.ContractTypeName, HT05.Months as ContractMonths,
			(case when HT05.Months = 0 then NULL else dateadd(month,HT05.Months,HT13.SignDate) end) as ReSignDate
		FROM HT1360 HT13 	
			inner join HV1400 HV01 on HT13.EmployeeID = HV01.EmployeeID and HT13.DivisionID=HV01.DivisionID
			left join HT1102 HT03 on HT13.DutyID = HT03.DutyID and HT13.DivisionID = HT03.DivisionID 
			left join AT1102 AT02 on HT13.DepartmentID=AT02.DepartmentID and HT13.DivisionID=AT02.DivisionID
  			left join HV1400 HV02 on HV02.EmployeeID = HT13.SignPersonID and HV02.DivisionID = HT13.DivisionID
			left join HT1102 HT04 on HV02.DutyID = HT04.DutyID and 	HV02.DivisionID = HT04.DivisionID			
			left join HT1105 HT05 on HT05.ContractTypeID = HT13.ContractTypeID and HT05.DivisionID = HT13.DivisionID
		WHERE HT13.DivisionID =''' +  @DivisionID +'''  and HT13.DepartmentID like '''+ @DepartmentID + ''' 
		and HT13.EmployeeID like ''' + @EmployeeID + ''' '

IF not exists (SELECT name FROM sysObjects WHERE id = Object_ID(N'[dbo].[HV1361]') and OBJECTPROPERTY(id, N'IsView') = 1)
	EXEC ('Create View HV1361 -- tao boi HP1363
			  as '  +  @sSQL)
ELSE
	EXEC('Alter View HV1361 -- tao boi HP1363
		as ' + @sSQL )


