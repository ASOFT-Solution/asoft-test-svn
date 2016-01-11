IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0328]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0328]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load dữ liệu Grid danh sách nhân viên nghỉ phép (HF0325)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Nguyễn Thanh Sơn, date: 19/11/2013
-- <Example>
---- EXEC HP0328 'SAS','',12,2013,12,2013,'2013-08-24 23:00:00.000','2013-10-25 00:00:00.000','%','%','%',1

CREATE PROCEDURE HP0328
(
  @DivisionID VARCHAR (50),
  @UserID VARCHAR (50),
  @FromMonth INT,
  @FromYear INT,
  @ToMonth INT,  
  @ToYear INT,
  @FromDate DATETIME,
  @ToDate DATETIME,
  @DepartmentID VARCHAR (50),
  @TeamID VARCHAR (50),
  @EmployeeID VARCHAR (50),
  @IsDate TINYINT
)    
AS 
DECLARE @sSQL NVARCHAR (MAX), @sWhere NVARCHAR (MAX)
SET @sWhere = N''
SET @sSQL = N'
SELECT H26.VoucherID,H26.EmployeeID, LTRIM(RTRIM(ISNULL(H00.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H00.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H00.FirstName,''''))) AS EmployeeName,
H26.DepartmentID,A02.DepartmentName,H26.TeamID,H01.TeamName,H26.FromDate,H26.ToDate,H26.SabbaticalAmount,H26.SabbaticalReason
FROM HT0326 H26
LEFT JOIN HT1101 H01 ON H01.DivisionID = H26.DivisionID AND H01.TeamID = H26.TeamID
LEFT JOIN AT1102 A02 ON A02.DivisionID = H26.DivisionID AND A02.DepartmentID = H26.DepartmentID
LEFT JOIN HT1400 H00 ON H00.DivisionID = H26.DivisionID AND H00.EmployeeID = H26.EmployeeID
WHERE H26.DivisionID = '''+@DivisionID+'''
AND H26.DepartmentID LIKE '''+@DepartmentID+'''
AND ISNULL(H26.TeamID,'''') LIKE ISNULL('''+@TeamID+''','''')
AND H26.EmployeeID LIKE ISNULL('''+@EmployeeID+''','''')   '

IF @IsDate = 1 SET @sWhere = N'
AND (CONVERT(VARCHAR(10),H26.FromDate,111) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,111)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,111)+'''
  OR CONVERT(VARCHAR(10),H26.ToDate,111) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,111)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,111)+'''
  OR '''+CONVERT(VARCHAR(10),@FromDate,111)+''' BETWEEN CONVERT(VARCHAR(10),H26.FromDate,111) AND CONVERT(VARCHAR(10),H26.ToDate,111))  '
ELSE SET @sWhere = N'
AND (YEAR(H26.FromDate) * 100 + MONTH(H26.FromDate) BETWEEN '''+STR(@FromYear * 100 + @FromMonth)+''' AND '''+STR(@ToYear * 100 + @ToMonth)+''' 
  OR YEAR(H26.ToDate) * 100 + MONTH(H26.ToDate) BETWEEN '''+STR(@FromYear * 100 + @FromMonth)+''' AND '''+STR(@ToYear * 100 + @ToMonth)+''' 
  OR '''+STR(@FromYear * 100 + @FromMonth)+''' BETWEEN YEAR(H26.FromDate) * 100 + MONTH(H26.FromDate) AND YEAR(H26.ToDate) * 100 + MONTH(H26.ToDate) )  '
  
EXEC (@sSQL + @sWhere)
PRINT (@sSQL + @sWhere)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

