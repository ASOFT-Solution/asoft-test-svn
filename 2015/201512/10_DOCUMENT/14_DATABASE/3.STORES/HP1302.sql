

/****** Object:  StoredProcedure [dbo].[HP1302]    Script Date: 11/19/2011 14:40:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1302]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1302]
GO



/****** Object:  StoredProcedure [dbo].[HP1302]    Script Date: 11/19/2011 14:40:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



---Created by: Vo Thanh Huong
---Created date: 13/08/2004
---purpose: X? lý s? li?u in báp cáo qu?n lý khen thu?ng, k? lu?t
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/

CREATE PROCEDURE [dbo].[HP1302]  @DivisionID nvarchar(50),
				@DepartmentID nvarchar(50), 
				 @EmployeeID nvarchar(50)				 
 AS

Declare  @strSQL as nvarchar(4000)

Set @strSQL = 'Select HT00.*, HT01.DutyName, FullName
	From HT1406 HT00 
	left join HT1102 HT01 on HT00.DutyID = HT01.DutyID and HT00.DivisionID = HT01.DivisionID
	inner join HV1400 HV on HV.EmployeeID = HT00.EmployeeID and HV.DivisionID = HT00.DivisionID
	Where HT00.DivisionID =''' + @DivisionID + ''' 
	and HT00.DepartmentID like  ''' + @DepartmentID + ''' 
	and HT00.EmployeeID like ''' + @EmployeeID + ''''

If not exists (Select name from sysObjects Where id = Object_ID(N'[dbo].[HV1302]') and OBJECTPROPERTY(id,N'IsView')=1)
	Exec (' Create View HV1302  ---tao boi HP1302
		as ' + @strSQL)
Else
	Exec (' Alter  View HV1302 ---tao boi HP1302
		as ' + @strSQL)











GO


