IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0349]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP0349]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- IN BÁO CÁO QUÁ TRÌNH CÔNG TÁC
-- <History>
---- Create on 02/10/2014 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
 HP0349 @DivisionID = 'AP', @EmployeeStatus = 1, @FromDepartmentID ='AC', @ToDepartmentID = 'VP', @TeamID ='%',
@FromEmployeeID = 'AP-HR-TD-00001', @ToEmployeeID = 'AP-PKD-TD-0001', @FromDate = '2014-07-01', @ToDate = '2014-10-05',
@FromMonth = 7, @FromYear = 2010, @ToMonth = 10, @ToYear = 2014, @IsDate = 0 
*/
CREATE PROCEDURE [dbo].[HP0349] 	
	@DivisionID NVARCHAR(50),
	@EmployeeStatus TINYINT,
	@FromDepartmentID NVARCHAR(50),
	@ToDepartmentID NVARCHAR(50),
	@TeamID NVARCHAR(50),
	@FromEmployeeID NVARCHAR(50),
	@ToEmployeeID NVARCHAR(50),
	@FromDate DATETIME,
	@ToDate DATETIME,
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@IsDate TINYINT -- 0: Theo tháng, 1: Theo ngày

AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sWHERE NVARCHAR(MAX)

IF LTRIM(STR(@IsDate)) = 1	
	SET @sWHERE = 
'AND ('''+CONVERT(VARCHAR(10),@FromDate,112)+''' BETWEEN CONVERT(VARCHAR,HT13.FromDate,112) AND CONVERT(VARCHAR,HT13.ToDate,112)
    OR 
     '''+CONVERT(VARCHAR,@ToDate,112)+''' BETWEEN CONVERT(VARCHAR,HT13.FromDate,112) AND CONVERT(VARCHAR,HT13.ToDate,112))'
IF LTRIM(STR(@IsDate)) = 0	
	SET @sWHERE = 
'AND ('+LTRIM(STR(@FromMonth + @FromYear*12))+' BETWEEN (HT13.FromMonth + HT13.FromYear*12) AND (HT13.ToMonth + HT13.ToYear*12)
    OR
      '+LTRIM(STR(@ToMonth + @ToYear*12))+' BETWEEN (HT13.FromMonth + HT13.FromYear*12) AND (HT13.ToMonth + HT13.ToYear*12))'
	
SET @sSQL1 = '
SELECT HT14.EmployeeID, 
       LTRIM(RTRIM(ISNULL(HT14.LastName,''''))) + '' '' + LTRIM(RTRIM(ISNULL(HT14.MiddleName,'''')))+ '' '' + LTRIM(RTRIM(ISNULL(HT14.FirstName,''''))) AS EmployeeName, 
       HT13.DivisionIDOld, AT11.DivisionName AS DivisionOldName,  
       HT13.DepartmentIDOld, AT12.DepartmentName AS DepartmentOldName, 
       HT13.TeamIDOld, HT11.TeamName AS TeamOldName,
       HT13.DutyIDOld, HT12.DutyName AS DutyOldName, HT13.WorksOld, 
       HT13.FromDate, HT13.ToDate, HT13.FromMonth, HT13.FromYear, HT13.ToMonth, HT13.ToYear, 
       HT13.DepartmentID, AT02.DepartmentName,
       HT13.TeamID, HT01.TeamName, HT13.DutyID, HT02.DutyName, HT13.Works, 
       ISNULL(HT13.SalaryAmounts,0) AS SalaryAmounts, ISNULL(HT13.SalaryCoefficient,0) AS SalaryCoefficient, 
       HT13.[Description], HT13.Notes
FROM HT1302 HT13
LEFT JOIN HT1400 HT14 ON HT14.DivisionID = HT13.DivisionID AND HT14.EmployeeID = HT13.EmployeeID
LEFT JOIN AT1101 AT11 ON AT11.DivisionID = HT13.DivisionIDOld
LEFT JOIN AT1102 AT12 ON AT12.DivisionID = HT13.DivisionIDOld AND AT12.DepartmentID = HT13.DepartmentIDOld
LEFT JOIN HT1101 HT11 ON HT11.DivisionID = HT13.DivisionIDOld AND HT11.DepartmentID = HT13.DepartmentIDOld AND HT11.TeamID = HT13.TeamIDOld
LEFT JOIN HT1102 HT12 ON HT12.DivisionID = HT13.DivisionIDOld AND HT12.DutyID = HT13.DutyIDOld
LEFT JOIN AT1102 AT02 ON AT02.DivisionID = HT13.DivisionID AND AT02.DepartmentID = HT13.DepartmentID
LEFT JOIN HT1101 HT01 ON HT01.DivisionID = HT13.DivisionID AND HT01.DepartmentID = HT13.DepartmentID AND HT01.TeamID = HT13.TeamID
LEFT JOIN HT1102 HT02 ON HT02.DivisionID = HT13.DivisionID AND HT02.DutyID = HT13.DutyID
WHERE HT14.DivisionID = '''+@DivisionID+''' 
    AND HT14.EmployeeID BETWEEN '''+@FromEmployeeID+''' AND '''+@ToEmployeeID+'''
    AND HT13.IsPast = 0
    AND HT14.DepartmentID BETWEEN '''+@FromDepartmentID+''' AND '''+@ToDepartmentID+'''
    AND ISNULL(HT14.TeamID,'''') LIKE ISNULL('''+@TeamID+''','''')
    AND HT14.EmployeeStatus = '+LTRIM(STR(@EmployeeStatus))+'
    '+@sWHERE+'
'
EXEC (@sSQL1)
PRINT @sSQL1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
