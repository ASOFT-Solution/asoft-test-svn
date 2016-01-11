IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0282]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0282]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load dữ liệu cho grid chấm công nhân viên theo ca
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Nguyễn Thanh Sơn, date: 21/08/2013
-- <Example>
---- 
/*
EXEC HP0282 'CTY','BKS','SX','','VR.0002','2013-03-01 00:00:00','2013-03-31 00:00:00','%',3,2013
SELECT * FROM HV0282
*/

CREATE PROCEDURE HP0282
(
   @DivisionID AS NVARCHAR(50),
   @DepartmentID AS NVARCHAR(50),
   @ToDepartmentID AS NVARCHAR(50),
   @TeamID AS NVARCHAR(50),
   @EmployeeID AS NVARCHAR(50),
   @FromDate AS DATETIME,
   @Todate AS DATETIME, 
   @ShiftID AS NVARCHAR (50),
   @TranMonth AS INT,
   @TranYear AS INT
 )

AS
DECLARE @sSQL NVARCHAR(MAX),
	@cur CURSOR,
	@Column INT,
	@AbsentTypeID NVARCHAR(50)

Select @Column = 1, @sSQL = '' 
Set @sSQL = 
'
SELECT HT.DivisionID,       
       HT.EmpFileID,
       HT.DepartmentID,   
       AT.DepartmentName,
       ISNULL(HT.TeamID,'''') AS TeamID,
       HT3.TeamName,
       HT.EmployeeID,
       Ltrim(RTrim(isnull(HT2.LastName,'''')))+'' ''+LTrim(RTrim(isnull(HT2.MiddleName,'''')))+'' ''+LTrim(RTrim(Isnull(HT2.FirstName,''''))) As EmployeeName,
       HT1.AbsentDate,
       HT1.ShiftID,
       HT4.ShiftName,
       HT2.Notes,' 	
Set @cur = Cursor scroll keyset for
		Select AbsentTypeID From HT1013 Where DivisionID = @DivisionID And IsMonth = 0
		Order by Orders, AbsentTypeID
Open @cur
Fetch next from @cur into @AbsentTypeID




While @@Fetch_Status = 0
Begin	
	Set @sSQL = @sSQL + '
	
	sum(case when AbsentTypeID = N''' + @AbsentTypeID +
	 ''' then (case when AbsentAmount = 0 then NULL else AbsentAmount end)  else NULL end) as C' + right('0' + convert(varchar(2), @Column),2) +', '	
	Set @Column = @Column + 1
	Fetch next from @cur into @AbsentTypeID
End

Set @sSQL = left(@sSQL, len(@sSQl) - 1) +  
' 
FROM HT2400 HT
LEFT JOIN HT0284 HT1 ON HT.DivisionID=HT1.DivisionID       
      AND HT.DepartmentID=HT1.DepartmentID
      AND ISNULL(HT.TeamID,'''')=ISNULL(HT1.TeamID,'''')
      AND HT.EmployeeID=HT1.EmployeeID
      AND HT.TranMonth=HT1.TranMonth
      AND HT.TranYear=HT1.TranYear
LEFT JOIN HT1400 HT2 ON HT.DivisionID=HT2.DivisionID 
      AND HT.EmployeeID=HT2.EmployeeID
LEFT JOIN AT1102 AT ON HT.DivisionID=AT.DivisionID AND HT.DepartmentID=AT.DepartmentID
LEFT JOIN HT1101 HT3 ON HT.DivisionID=HT3.DivisionID AND HT.DepartmentID=HT3.DepartmentID AND HT.TeamID=HT3.TeamID
inner join HT1020 HT4 on HT.DivisionID=HT4.DivisionID and HT1.ShiftID=HT4.ShiftID


Where HT.DivisionID = ''' + @DivisionID + ''' 
  and HT.DepartmentID between ''' + @DepartmentID + ''' and ''' + @ToDepartmentID + ''' 
  and isnull(HT.TeamID, '''') like isnull(''' + @TeamID + ''', '''')  
  and HT.EmployeeID like ''' + @EmployeeID + ''' 
  and HT.TranMonth = ' + cast(@TranMonth as nvarchar(2)) + ' 
  and HT.TranYear = ' + cast(@TranYear as nvarchar(4)) + ' 
  and convert(nvarchar(10), AbsentDate, 101) between ''' + convert(nvarchar(10), @FromDate, 101) + ''' and ''' + convert(nvarchar(10), @ToDate, 101) + ''' 
  and HT1.ShiftID like '''+@ShiftID+'''

Group by HT.EmpFileID, HT.DivisionID,HT.DepartmentID, AT.DepartmentName,isnull(HT.TeamID,''''),HT3.TeamName,HT.EmployeeID,
Ltrim(RTrim(isnull(HT2.LastName,'''')))+'' ''+LTrim(RTrim(isnull(HT2.MiddleName,'''')))+'' ''+LTrim(RTrim(Isnull(HT2.FirstName,''''))),
       HT1.AbsentDate,
       HT1.ShiftID,HT4.ShiftName,
       HT2.Notes
'

Close @cur
PRINT @sSQL


If  exists(Select  1 From sysObjects Where XType = 'V' and Name = 'HV0282')
	Drop view HV0282
	exec('Create view HV0282

 --tao boi HP0282
		as ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

