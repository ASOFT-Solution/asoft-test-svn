IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0211]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0211]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- <Summary>
---- Danh sách hệ số lương theo ca của nhân viên
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 15/08/2013 by Thanh Sơn
-- <Example>
---- EXEC HP0211 'CTY', 'Admin', 10, 2013, 'PQS', '%','%',''

CREATE PROCEDURE HP0211
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@DepartmentID AS NVARCHAR(50),
		@TeamID AS NVARCHAR(50),
		@EmployeeID AS NVARCHAR(50),
		@ShiftID AS NVARCHAR(50)	
		
)
AS
DECLARE @sWhere AS NVARCHAR (MAX),
        @sSQL AS NVARCHAR(MAX),
        @Order AS NVARCHAR (MAX)
 
SET @sWhere=''
        
IF @DepartmentID <> '' AND @DepartmentID <> '%'
   SET @sWhere=@sWhere +  N'
   AND ISNULL(HT.DepartmentID, '''') = ISNULL('''+@DepartmentID+''','''')  '
   
IF @TeamID <>'' AND @TeamID <>'%'
   SET @sWhere=@sWhere + N'
   AND ISNULL(HT1.TeamID, '''') = ISNULL('''+@TeamID+''', '''') '

IF @EmployeeID <>'' AND @EmployeeID <>'%'
   SET @sWhere=@sWhere+N'
   and H.EmployeeID='''+@EmployeeID+'''   '
   
IF @ShiftID<>'' AND @ShiftID<>'%'
   SET @sWhere=@sWhere+N'
   AND ISNULL ('''+@ShiftID+''','''') BETWEEN ISNULL(H.FromShiftID,'''') AND ISNULL(H.ToShiftID,'''') '
   
SET @sSQL=N'
SELECT H.APK,
H.DivisionID,
H.EmployeeID,
Ltrim(RTrim(isnull(HT.LastName,'''')))+ '' '' + LTrim(RTrim(isnull(HT.MiddleName,''''))) + '' '' + LTrim(RTrim(Isnull(HT.FirstName,''''))) As EmployeeName,
H.FromDate,
H.ToDate,
H.FromShiftID,
H.ToShiftID,
H.DayCoefficient as Salary,
H.Notes, 
HT.DepartmentID,
AT.DepartmentName,
HT.TeamID,
HT1.TeamName
FROM  HT0281 H
INNER JOIN HT1400 HT ON HT.DivisionID=H.DivisionID AND HT.EmployeeID = H.EmployeeID 
INNER JOIN AT1102 AT ON HT.DivisionID=AT.DivisionID AND HT.DepartmentID=AT.DepartmentID
LEFT JOIN HT1101 HT1 ON HT.DivisionID = HT1.DivisionID AND HT.TeamID=HT1.TeamID  
WHERE H.DivisionID= '''+@DivisionID+'''  
AND   H.TranMonth= '''+STR(@TranMonth)+'''
AND   H.TranYear= '''+STR(@TranYear)+'''  '

SET @Order=N'
ORDER BY AT.DepartmentID, H.EmployeeID '

PRINT (@sSQL)
PRINT (@sWhere)
PRINT (@Order)

EXEC (@sSQL+@sWhere+@Order)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

