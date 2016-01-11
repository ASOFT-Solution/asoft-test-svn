/****** Object:  StoredProcedure [dbo].[HP1304]    Script Date: 07/29/2010 14:03:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



---Created by: Vo Thanh Huong, date: 06/12/2004
---purpose: Quan ly lich su cong tac
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[HP1304] @DivisionID nvarchar(50),				
				@EmployeeID nvarchar(50)			
AS
DECLARE @sSQL nvarchar(4000) 
Set @sSQL = 'Select  HistoryID,  T00.DivisionID, T00.DepartmentID, T00.TeamID, T00.EmployeeID, V00.FullName,T00.IsPast, T00.IsBeforeTranfer, 
	T00.FromMonth, T00.FromYear, T00.ToMonth, T00.ToYear, T00.FromDate, T00.ToDate,  T00.DutyID, Works, 
	case when IsPast = 1 then T00.DivisionName else T01.DivisionName end as DivisionName,  
	case when IsPast = 1  then T00.DepartmentName else T02.DepartmentName end as DepartmentName, 
	case when IsPast = 1  then T00.TeamName else T03.TeamName end as TeamName,
	case when IsPast = 1 then T00.DutyName else T04.DutyName end as DutyName,
	T00.SalaryAmounts, T00.SalaryCoefficient, T00.Description, T00.Notes, 
	T00.DivisionIDOld, T00.DepartmentIDOld,	T00.TeamIDOld, T00.DutyIDOld, T00.WorksOld,
	T00.ContactTelephone, T00.Contactor, T00.ContactAddress
From HT1302 T00 left join AT1101 T01 on T00.DivisionID = T01.DivisionID
	left join AT1102  T02 on T02.DivisionID = T00.DivisionID and T02.DepartmentID = T00.DepartmentID
	left join HT1101 T03 on T03.DivisionID = T00.DivisionID and T03.DepartmentID = T00.DepartmentID and  T03.TeamID = T00.TeamID
	left join  HT1102 T04 on T04.DutyID = T00.DutyID and T04.DivisionID = T00.DivisionID
	inner join HV1400 V00 on V00.EmployeeID = T00.EmployeeID and V00.DivisionID = T00.DivisionID
	Where T00.DivisionID = '''+@DivisionID+''' '

if exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'HV1304')
	Drop view HV1304
EXEC('Create view HV1304 ---tao boi HP1304
			as ' + @sSQL)