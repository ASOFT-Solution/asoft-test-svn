IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0081]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP0081]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- IN BÁO CÁO DANH SÁCH CON NHÂN VIÊN THEO ĐỘ TUỔI
-- <History>
---- Create on 02/10/2014 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
 HP0081 @DivisionID = 'AP', @EmployeeStatus = 0, @FromDepartmentID ='AC', @ToDepartmentID = 'VP', @TeamID ='%',
@FromYear ='1990', @ToYear = '2014', @FromAge = 1, @ToAge = 24, @IsAge = 1,
@PrintDate = '2014-02-13'
 
*/
CREATE PROCEDURE [dbo].[HP0081] 	
	@DivisionID NVARCHAR(50),
	@EmployeeStatus TINYINT,
	@FromDepartmentID NVARCHAR(50),
	@ToDepartmentID NVARCHAR(50),
	@TeamID NVARCHAR(50),
	@FromYear INT,
	@ToYear INT,
	@FromAge INT,
	@ToAge INT,
	@IsAge TINYINT, -- 0: Theo năm sinh, 1: Theo độ tuổi
	@PrintDate DATETIME -- Ngày chọn in ra báo cáo

AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sWHERE NVARCHAR(MAX)

IF LTRIM(STR(@IsAge)) = 1	
	SET @sWHERE = 'AND YEAR('''+CONVERT(VARCHAR,@PrintDate,112)+''') - YEAR(HT04.RelationDate) BETWEEN '+LTRIM(STR(@FromAge))+' AND '+LTRIM(STR(@ToAge))+' '
IF LTRIM(STR(@IsAge)) = 0	
	SET @sWHERE = 'AND YEAR(HT04.RelationDate) BETWEEN '+LTRIM(STR(@FromYear))+' AND '+LTRIM(STR(@ToYear))+' '
	
SET @sSQL1 = '
SELECT HT04.EmployeeID, HT04.RelationID,  
       LTRIM(RTRIM(ISNULL(HT14.LastName,''''))) + '' '' + LTRIM(RTRIM(ISNULL(HT14.MiddleName,'''')))+ '' '' + LTRIM(RTRIM(ISNULL(HT14.FirstName,''''))) AS EmployeeName, 
       HT04.RelationName, HT04.RelationDate, HT14.EmployeeStatus, 
       HV12.[Description] AS DEmployeeStatus
FROM HT1404 HT04 
INNER JOIN HT1400 HT14 ON HT14.DivisionID = HT04.DivisionID AND HT14.EmployeeID = HT04.EmployeeID
LEFT JOIN HV1012 HV12 ON HV12.EmployeeStatus = HT14.EmployeeStatus
WHERE HT04.DivisionID = '''+@DivisionID+''' 
      '+@sWHERE+'
      AND HT04.RelationType = 1 AND HT14.EmployeeStatus = '+LTRIM(STR(@EmployeeStatus))+'
      AND HT14.DepartmentID BETWEEN '''+@FromDepartmentID+''' AND '''+@ToDepartmentID+'''
      AND ISNULL(HT14.TEAMID,'''') LIKE '''+@TeamID+'''
'
EXEC (@sSQL1)
--PRINT @sSQL1



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

