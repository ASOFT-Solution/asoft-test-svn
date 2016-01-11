IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP03451]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP03451]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- In danh sách tạm hoãn hợp đồng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 30/12/2013
---- 
-- <Example>
---- EXEC HP03451 'SAS', ''

CREATE PROCEDURE HP03451
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
AND H00.EmployeeID IN 
(
	SELECT EmployeeID FROM HT1360 H60
	LEFT JOIN HT1105 H05 ON H05.DivisionID = H60.DivisionID AND H05.ContractTypeID = H60.ContractTypeID
	WHERE H60.DivisionID = @DivisionID
	AND DATEDIFF(DAY,H60.SignDate, DATEADD(MONTH,H05.Months,H60.SignDate)) - 
	DATEDIFF(DAY,H60.SignDate, GETDATE()) <= H05.WarningDays
)
AND H03.EmployeeStatus = 1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

