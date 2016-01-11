/****** Object:  StoredProcedure [dbo].[HP1303]    Script Date: 07/29/2010 13:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---Created by: Vo Thanh Huong
---Created date: 13/08/2004
---purpose: X? lý s? li?u in báo cáo t?m ?ng
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[HP1303]  @DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@EmployeeID nvarchar(50),				
				@TranMonth int,
				@TranYear int							 
 AS
Declare  @strSQL as nvarchar(4000)

Set @strSQL =  ' Select HT00.*, FullName, HT01.EmployeeID, HT01.DepartmentID, HT01.DepartmentName 
	From HT2405 HT00  inner join HT2404 HT01 on HT00.AdvanceID = HT01.AdvanceID and HT00.DivisionID = HT01.DivisionID
			inner join HV1400 HV on HV.EmployeeID = HT01.EmployeeID and HV.DivisionID = HT01.DivisionID
			left join AT1102 AT on  AT.DepartmentID = HT01.DepartmentID and AT.DivisionID = HT01.DivisionID
	Where HT01.DivisionID =''' + @DivisionID + ''' and 
			HT01.DepartmentID  like ''' + @DepartmentID + ''' and
			HT01.EmployeeID like ''' + @EmployeeID + ''' and 
			HT01.TranMonth = ' + STR(@TranMonth) + ' and 
			HT01.TranYear = ' + STR(@TranYear)

print @strSQL
If not exists (Select name from sysObjects Where id = Object_ID(N'[dbo].[HV1303]') and OBJECTPROPERTY(id,N'IsView')=1)
	Exec (' Create View HV1303  ---tao boi HP1303
		as ' + @strSQL)
Else
	Exec (' Alter  View HV1303 ---tao boi HP1303
		as ' + @strSQL)