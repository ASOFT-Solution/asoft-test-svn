/****** Object:  StoredProcedure [dbo].[HP2421]    Script Date: 08/02/2010 15:14:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created by Vo Thanh Huong, 
----Created date 09/06/2004
----- purpose: Xu ly In cham cong ngay
/********************************************
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]
'********************************************/


ALTER PROCEDURE [dbo].[HP2421] 		@DivisionID nvarchar(50),
					@DepartmentID nvarchar(50),
					@TeamID as nvarchar(50),
					@FromDate Datetime, @ToDate Datetime					

 AS
	Declare @Em_cur as cursor,
		@EmployeeID as nvarchar(50),
		@sSQL as nvarchar(4000),
        @sSQL1 as nvarchar(4000),
        @sSQL2 as nvarchar (4000),
        @sSQL3 as nvarchar (4000),
		@sDateName as nvarchar(4000), 
		@i as int,
		@Date as datetime,
		@sView as nvarchar(4000)
/*

	Delete HT2411
	 Insert HT2411 ( EmployeeID,  DivisionID, DepartmentID,TeamID)
	Select EmployeeID,  DivisionID, DepartmentID,TeamID
	From HT2400 Where 	DivisionID = @DivisionID and
				DepartmentID like @DepartmentID and
				isnull(TeamID,'')  like @TeamID

*/
SET @sDateName = 'UPDATE HT2411 SET '
SET @i = DAY(@FromDate)
SET @Date = @FromDate

WHILE @i <= DAY(@ToDate)
	BEGIN
		SET @sDateName = @sDateName + 'T' + CASE WHEN @i <= 9 THEN  '0' ELSE ''  END + ltrim(STR(@i)) + ' = '''
						+  CASE WHEN DATENAME(dw, @Date) = 'Monday' THEN '2'
							 WHEN DATENAME(dw, @Date) = 'Tuesday' THEN '3'						
							 WHEN DATENAME(dw, @Date) = 'Wednesday' THEN '4'		
							  WHEN DATENAME(dw, @Date) = 'Thursday' THEN '5'						
							  WHEN DATENAME(dw, @Date) = 'Friday' THEN '6'						
						  	 WHEN DATENAME(dw, @Date) = 'Saturday' THEN '7'						
  							 ELSE 'CN'						
						     END	 + ''',' 			
		
	SET @i = @i + 1
	SET @Date = DATEADD(DAY, 1, @Date) 

	CONTINUE
	END

SET @sDateName = LEFT(@sDateName, LEN(@sDateName) - 1)  +'  WHERE ID = 1 And DivisionID = '''+@DivisionID+''' ' 
EXEC (@sDateName) 

Set @sSQL  ='Select  1 as Status, HT2401.DivisionID,  HT2401.DepartmentID, AT1102.DepartmentName, HT2401.TeamID, HT2401.EmployeeID, 
	HV1400.FullName, 
	HT2401.AbsentTypeID,   DutyID, UnitID, AbsentName,
	Sum(Case when Day(AbsentDate) = 1 then AbsentAmount else 0 End)  as Col01,
	Sum(Case when Day(AbsentDate) = 2 then AbsentAmount else 0 End)  as Col02,
	Sum(Case when Day(AbsentDate) = 3 then AbsentAmount else 0 End)  as Col03,
	Sum(Case when Day(AbsentDate) = 4 then AbsentAmount else 0 End)  as Col04,
	Sum(Case when Day(AbsentDate) = 5 then AbsentAmount else 0 End)  as Col05,
	Sum(Case when Day(AbsentDate) = 6 then AbsentAmount else 0 End)  as Col06,
	Sum(Case when Day(AbsentDate) = 7 then AbsentAmount else 0 End)  as Col07,
	Sum(Case when Day(AbsentDate) = 8 then AbsentAmount else 0 End)  as Col08,
	Sum(Case when Day(AbsentDate) = 9 then AbsentAmount else 0 End)  as Col09,
	Sum(Case when Day(AbsentDate) = 10 then AbsentAmount else 0 End)  as Col10,
	Sum(Case when Day(AbsentDate) = 11 then AbsentAmount else 0 End)  as Col11,
	Sum(Case when Day(AbsentDate) = 12 then AbsentAmount else 0 End)  as Col12,
	Sum(Case when Day(AbsentDate) = 13 then AbsentAmount else 0 End)  as Col13,
	Sum(Case when Day(AbsentDate) = 14 then AbsentAmount else 0 End)  as Col14,
	Sum(Case when Day(AbsentDate) = 15 then AbsentAmount else 0 End)  as Col15,
	Sum(Case when Day(AbsentDate) = 16 then AbsentAmount else 0 End)  as Col16,
	Sum(Case when Day(AbsentDate) = 17 then AbsentAmount else 0 End)  as Col17,
	Sum(Case when Day(AbsentDate) = 18 then AbsentAmount else 0 End)  as Col18,
	Sum(Case when Day(AbsentDate) = 19 then AbsentAmount else 0 End)  as Col19,
	Sum(Case when Day(AbsentDate) = 20 then AbsentAmount else 0 End)  as Col20,
	Sum(Case when Day(AbsentDate) = 21 then AbsentAmount else 0 End)  as Col21,
	Sum(Case when Day(AbsentDate) = 22 then AbsentAmount else 0 End)  as Col22,
	Sum(Case when Day(AbsentDate) = 23 then AbsentAmount else 0 End)  as Col23,
	Sum(Case when Day(AbsentDate) = 24 then AbsentAmount else 0 End)  as Col24,
	Sum(Case when Day(AbsentDate) = 24 then AbsentAmount else 0 End)  as Col25,
	Sum(Case when Day(AbsentDate) = 26 then AbsentAmount else 0 End)  as Col26,
	Sum(Case when Day(AbsentDate) = 27 then AbsentAmount else 0 End)  as Col27,
	Sum(Case when Day(AbsentDate) = 28 then AbsentAmount else 0 End)  as Col28,
	Sum(Case when Day(AbsentDate) = 29 then AbsentAmount else 0 End)  as Col29,
	Sum(Case when Day(AbsentDate) = 30 then AbsentAmount else 0 End)  as Col30,
	Sum(Case when Day(AbsentDate) = 31 then AbsentAmount else 0 End)  as Col31,
	HT2411.*, HV1400.Orders
'
set @sSQL1 = 
N'From  HT2401 
		left join HT2411 on HT2411.ID =1 and HT2401.DivisionID = HT2411.DivisionID
		inner join HT1013 on HT1013.AbsentTypeID = HT2401.AbsentTypeID and HT1013.DivisionID = HT2401.DivisionID

		inner join HV1400 on HV1400.EmployeeID = HT2401.EmployeeID and HV1400.DivisionID = HT2401.DivisionID
		inner join AT1102 on HT2401.DivisionID = AT1102.DivisionID and HT2401.DepartmentID  = AT1102.DepartmentID
Where HT2401.DivisionID =N''' + @DivisionID + ''' and 
		HT2401.DepartmentID like N''' + @DepartmentID + ''' and
		IsNull(HT2401.TeamID, ''' + ''') like N''' + @TeamID +   ''' and	
		 AbsentDate Between '''+ Convert(varchar(10), @FromDate, 21)+''' and '''+Convert(varchar(10), @ToDate, 21)+'''
Group by  ID, T01, T02, T03, T04, T05, T06, T07, T08, T09, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20,
	T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
	HT2401.DivisionID,
	HT2401.DepartmentID, AT1102.DepartmentName, HT2401.TeamID, HT2401.EmployeeID , 
	HT2401.AbsentTypeID, DutyID, UnitID, HV1400.FullName, AbsentName, HV1400.Orders
'
set @sSQL2 = 
N'Union 	
Select 	2 as Status,  HT2401.DivisionID as DivisionID,  N''' +N'zzzz'''  + ' as DepartmentID, ''' +  ''' as DepartmentName, ''' + '''  as TeamID, ''' + ''' as EmployeeID, 
	N''' + N'TOÅNG COÄNG''' + ' as FullName,
	HT2401.AbsentTypeID,  ''' + ''' as  DutyID, UnitID, AbsentName,
	Sum(Case when Day(AbsentDate) = 1 then AbsentAmount else 0 End)  as Col01,
	Sum(Case when Day(AbsentDate) = 2 then AbsentAmount else 0 End)  as Col02,
	Sum(Case when Day(AbsentDate) = 3 then AbsentAmount else 0 End)  as Col03,
	Sum(Case when Day(AbsentDate) = 4 then AbsentAmount else 0 End)  as Col04,
	Sum(Case when Day(AbsentDate) = 5 then AbsentAmount else 0 End)  as Col05,
	Sum(Case when Day(AbsentDate) = 6 then AbsentAmount else 0 End)  as Col06,
	Sum(Case when Day(AbsentDate) = 7 then AbsentAmount else 0 End)  as Col07,
	Sum(Case when Day(AbsentDate) = 8 then AbsentAmount else 0 End)  as Col08,
	Sum(Case when Day(AbsentDate) = 9 then AbsentAmount else 0 End)  as Col09,
	Sum(Case when Day(AbsentDate) = 10 then AbsentAmount else 0 End)  as Col10,
	Sum(Case when Day(AbsentDate) = 11 then AbsentAmount else 0 End)  as Col11,
	Sum(Case when Day(AbsentDate) = 12 then AbsentAmount else 0 End)  as Col12,
	Sum(Case when Day(AbsentDate) = 13 then AbsentAmount else 0 End)  as Col13,
	Sum(Case when Day(AbsentDate) = 14 then AbsentAmount else 0 End)  as Col14,
	Sum(Case when Day(AbsentDate) = 15 then AbsentAmount else 0 End)  as Col15,
	Sum(Case when Day(AbsentDate) = 16 then AbsentAmount else 0 End)  as Col16,
	Sum(Case when Day(AbsentDate) = 17 then AbsentAmount else 0 End)  as Col17,
	Sum(Case when Day(AbsentDate) = 18 then AbsentAmount else 0 End)  as Col18,
	Sum(Case when Day(AbsentDate) = 19 then AbsentAmount else 0 End)  as Col19,
	Sum(Case when Day(AbsentDate) = 20 then AbsentAmount else 0 End)  as Col20,
	Sum(Case when Day(AbsentDate) = 21 then AbsentAmount else 0 End)  as Col21,
	Sum(Case when Day(AbsentDate) = 22 then AbsentAmount else 0 End)  as Col22,
	Sum(Case when Day(AbsentDate) = 23 then AbsentAmount else 0 End)  as Col23,
	Sum(Case when Day(AbsentDate) = 24 then AbsentAmount else 0 End)  as Col24,
	Sum(Case when Day(AbsentDate) = 24 then AbsentAmount else 0 End)  as Col25,
	Sum(Case when Day(AbsentDate) = 26 then AbsentAmount else 0 End)  as Col26,
	Sum(Case when Day(AbsentDate) = 27 then AbsentAmount else 0 End)  as Col27,
	Sum(Case when Day(AbsentDate) = 28 then AbsentAmount else 0 End)  as Col28,
	Sum(Case when Day(AbsentDate) = 29 then AbsentAmount else 0 End)  as Col29,
	Sum(Case when Day(AbsentDate) = 30 then AbsentAmount else 0 End)  as Col30,
	Sum(Case when Day(AbsentDate) = 31 then AbsentAmount else 0 End)  as Col31,
	HT2411.*, 0 as Orders
'
set @sSQL3 = 
N'From  HT2401 	left join HT2411 on HT2411.ID =1 and HT2401.DivisionID = HT2411.DivisionID
		inner join HT1013 on HT1013.AbsentTypeID = HT2401.AbsentTypeID and HT1013.DivisionID = HT2401.DivisionID
Where HT2401.DivisionID =N''' + @DivisionID + ''' and 
		HT2401.DepartmentID like N''' + @DepartmentID + ''' and
		IsNull(HT2401.TeamID, ''' + ''') like N''' + @TeamID +   ''' and	
		 AbsentDate Between '''+ Convert(varchar(10), @FromDate, 21)+''' and '''+Convert(varchar(10), @ToDate, 21)+'''
Group by  ID, T01, T02, T03, T04, T05, T06, T07, T08, T09, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20,
	T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
	HT2401.DivisionID,	
	HT2401.AbsentTypeID, UnitID, AbsentName'


if not Exists (Select top 1 1 From SysObjects Where Xtype ='V' and Name = 'HV2421')
	Exec (' Create View HV2421  ---tao boi HP2421
				as '+ @sSQL + @sSQL1 + @sSQL2 + @sSQL3)
Else
	Exec (' Alter  View HV2421  ---tao boi HP2421
				as '+ @sSQL + @sSQL1 + @sSQL2 + @sSQL3)
GO
