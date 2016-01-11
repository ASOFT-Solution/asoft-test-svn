IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0345]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0345]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Load dữ liệu màn hình Danh sách nhân viên sắp hết hạn hợp đồng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 27/12/2013
---- 
-- <Example>
---- EXEC HP0345 'SAS', ''

CREATE PROCEDURE HP0345
( 
		@DivisionID VARCHAR(50),
		@UserID VARCHAR(50)
		
) 
AS 
        
SELECT H00.EmployeeID,
LTRIM(RTRIM(ISNULL(H00.LastName,''))) + ' '+ LTRIM(RTRIM(ISNULL(H00.MiddleName,''))) + ' ' +LTRIM(RTRIM(ISNULL(H00.FirstName,''))) AS EmployeeName,
H00.Birthday, A02.DepartmentName, H01.TeamName,
(CASE WHEN H00.IsMale = 1 THEN 'Nam' ELSE N'Nữ' END),
H03.DutyID, H02.DutyName, H03.TitleID, H06.TitleName, H03.WorkDate, H60.ContractTypeID, H05.ContractTypeName, 
H60.SignDate AS BeginDate, DATEADD(MONTH,H05.Months,H60.SignDate) AS EndDate,
H05.Months, H05.IsWarning, H05.WarningDays,
DATEDIFF(DAY,H60.SignDate, DATEADD(MONTH,H05.Months,H60.SignDate)) - 
DATEDIFF(DAY,H60.SignDate, GETDATE()), H03.EmployeeStatus
FROM HT1400 H00
LEFT JOIN HT1360 H60 ON H60.DivisionID = H00.DivisionID AND H60.EmployeeID = H00.EmployeeID
LEFT JOIN HT1105 H05 ON H05.DivisionID = H60.DivisionID AND H05.ContractTypeID = H60.ContractTypeID
LEFT JOIN HT1403 H03 ON H03.DivisionID = H00.DivisionID AND H03.EmployeeID = H00.EmployeeID
LEFT JOIN HT1106 H06 ON H06.DivisionID = H03.DivisionID AND H06.TitleID = H03.TitleID
LEFT JOIN HT1102 H02 ON H02.DivisionID = H03.DivisionID AND H02.DutyID = H03.DutyID
LEFT JOIN HT1101 H01 ON H01.DivisionID = H00.DivisionID AND H01.TeamID = H00.TeamID
LEFT JOIN AT1102 A02 ON A02.DivisionID = H00.DivisionID AND A02.DepartmentID = H00.DepartmentID
WHERE H00.DivisionID = @DivisionID
AND H05.IsWarning = 1
AND H05.Months <> 0
AND DATEDIFF(DAY,H60.SignDate, DATEADD(MONTH,H05.Months,H60.SignDate)) - 
DATEDIFF(DAY,H60.SignDate, GETDATE()) <= H05.WarningDays
AND H03.EmployeeStatus = 1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

