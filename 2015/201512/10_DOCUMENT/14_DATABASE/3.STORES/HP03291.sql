IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP03291]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP03291]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load dữ liệu màn hình Cảnh báo nhân viên được nâng bậc lương
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 19/12/2013 by Thanh Sơn
---- 
-- <Example>
---- EXEC HP03291 'SAS', ''

CREATE PROCEDURE HP03291
( 
		@DivisionID VARCHAR(50),
		@UserID VARCHAR(50)
		
) 
AS 
DECLARE @sSQL NVARCHAR(MAX),
        @sWhere NVARCHAR(MAX)

SELECT A.*, DATEADD(YEAR,H27.Years,A.SalaryLevelDate ) AS NextSalaryLevelDate,
DATEDIFF(MONTH,A.SalaryLevelDate,GETDATE()) AS Months, H27.Years * 12 - H27.[Time]
FROM (
SELECT H00.DivisionID, H00.EmployeeID, H00.Birthday,H00.DepartmentID, A02.DepartmentName, H00.TeamID, H01.TeamName,
LTRIM(RTRIM(ISNULL(H00.LastName,'')))+' '+LTRIM(RTRIM(ISNULL(H00.MiddleName,'')))+' '+LTRIM(RTRIM(ISNULL(H00.FirstName,''))) AS EmployeeName,
H03.TitleID, H06.TitleName, H03.SalaryLevel AS NowSalaryLevelID, V00.[Description] AS NowSalaryLevel,
(CASE WHEN CONVERT(INT,SUBSTRING(H03.SalaryLevel,4,2)) + 1 < 10 
THEN 'BAC0'+ CONVERT(VARCHAR(1),CONVERT(INT,SUBSTRING(H03.SalaryLevel,4,2)) + 1) 
ELSE 'BAC'+ CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(H03.SalaryLevel,4,2)) + 1) END) AS NextSalaryLevelID,
V01.[Description] AS NextSalaryLevel,V00.DescriptionE AS NowSalaryLevelE, H03.SalaryLevelDate
FROM HT1400 H00
LEFT JOIN HT1403 H03 ON H03.DivisionID = H00.DivisionID AND H03.EmployeeID = H00.EmployeeID
LEFT JOIN HV0100 V01 ON V01.CodeID = (CASE WHEN CONVERT(INT,SUBSTRING(H03.SalaryLevel,4,2)) + 1 < 10 
THEN 'BAC0'+ CONVERT(VARCHAR(1),CONVERT(INT,SUBSTRING(H03.SalaryLevel,4,2)) + 1) 
ELSE 'BAC'+ CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(H03.SalaryLevel,4,2)) + 1) END) AND V01.TypeID = 'SalaryLevel'
LEFT JOIN HV0100 V00 ON V00.CodeID = H03.SalaryLevel AND V00.TypeID = 'SalaryLevel'
LEFT JOIN HT1106 H06 ON H06.DivisionID = H03.DivisionID AND H06.TitleID = H03.TitleID
LEFT JOIN HT1101 H01 ON H01.DivisionID = H00.DivisionID AND H01.TeamID = H00.TeamID
LEFT JOIN AT1102 A02 ON A02.DivisionID = H00.DivisionID AND A02.DepartmentID = H00.DepartmentID
WHERE H00.DivisionID = @DivisionID
)A LEFT JOIN HT0327 H27 ON H27.DivisionID = A.DivisionID AND H27.TitleID = A.TitleID
WHERE DATEDIFF(MONTH,A.SalaryLevelDate,GETDATE()) >= H27.Years * 12 - H27.[Time]
AND A.NextSalaryLevelID >= H27.FromSalaryLevel 
AND A.NextSalaryLevelID <= H27.ToSalaryLevel
AND GETDATE() BETWEEN H27.BeginDate AND H27.EndDate
ORDER BY A.EmployeeID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

