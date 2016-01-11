
IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0286]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0286]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load danh sách nhân viên
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 27/08/2013 by Thanh Sơn
-- <Example>
---- EXEC HP0286 'CTY', 'Admin',9, 2013,'LAN01', 'PQS','%', 1,'2013-09-23 00:00:00',1,'CA1'

CREATE PROCEDURE HP0286
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@TimesID AS NVARCHAR(50),
		@DepartmentID AS NVARCHAR(50),
		@TeamID AS NVARCHAR(50),
        @CheckDate AS TINYINT,
        @TrackingDate AS DATETIME,
        @CheckShift AS TINYINT,
        @ShiftID AS NVARCHAR(50)
)
AS
DECLARE @sWhere AS NVARCHAR (MAX),
        @sSQL AS NVARCHAR(MAX),
        @sSQL1 AS NVARCHAR(2000)

SET @sWhere = '' 
SET @sSQL1=N' )
ORDER BY EmployeeID'  
  
IF @CheckDate = 1
SET @sWhere=@sWhere +     
N'    AND convert(nvarchar(10),isnull(TrackingDate,''1900-01-01 00:00:00''), 101)='''+convert(nvarchar(10),@TrackingDate, 101)+'''
'
ELSE SET @sWhere=@sWhere +    
N'    AND TrackingDate IS NULL
'    
IF @CheckShift = 1
SET @sWhere=@sWhere + 
N'    AND ShiftID = '''+@ShiftID+'''  
'
ELSE SET @sWhere=@sWhere + 
N'    AND ShiftID IS NULL
'   
SET @sSQL=N'
SELECT
H24.EmployeeID,
Ltrim(RTrim(isnull(H14.LastName,'''')))+ '' '' + LTrim(RTrim(isnull(H14.MiddleName,''''))) + '' '' + LTrim(RTrim(Isnull(H14.FirstName,''''))) AS EmployeeName
FROM HT2400 H24
LEFT JOIN HT1400 H14 ON H14.DivisionID = H24.DivisionID AND H14.EmployeeID=H24.EmployeeID  
WHERE H24.DivisionID ='''+@DivisionID+'''
AND H24.DepartmentID = '''+@DepartmentID+'''
AND ISNULL(H24.TeamID, '''') LIKE ISNULL('''+@TeamID+''', '''')
AND H24.TranMonth='+LTRIM(STR(@TranMonth))+'
AND H24.TranYear='+LTRIM(STR(@TranYear))+'
AND H24.EmployeeStatus = 1
AND H24.EmployeeID NOT IN
 (
    SELECT EmployeeID 
    FROM  HT0287 
    WHERE DivisionID='''+@DivisionID+'''
    AND  TranMonth= '+LTRIM(STR(@TranMonth))+'
    AND  TranYear= '+LTRIM(STR(@TranYear))+' 
'
PRINT (@sSQL)
PRINT(@sWhere)
PRINT(@sSQL1)

EXEC (@sSQL+@sWhere+@sSQL1)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

