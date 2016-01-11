IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0339]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0339]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Load Grid Lịch sử thôi việc của nhân viên
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 06/12/2013 by Thanh Sơn
---- 
-- <Example>
---- EXEC HP0339 'SAS','0006'
CREATE PROCEDURE HP0339
( 
		@DivisionID VARCHAR(50),
		@EmployeeID VARCHAR (50)		
) 
AS 
SELECT H80.EmployeeID, H80.DutyName, H80.WorkDate, H80.LeaveDate,H80.DecidingNo, H07.QuitJobName,
       H80.Allowance, H80.Subsidies, LTRIM(RTRIM(ISNULL(H00.LastName,'')))+' '+
       LTRIM(RTRIM(ISNULL(H00.MiddleName,'')))+' '+LTRIM(RTRIM(ISNULL(H00.FirstName,''))) AS EmployeeName,
       A02.DepartmentName, H01.TeamName, LTRIM(RTRIM(ISNULL(H001.LastName,'')))+' '+
       LTRIM(RTRIM(ISNULL(H001.MiddleName,'')))+' '+LTRIM(RTRIM(ISNULL(H001.FirstName,''))) AS DecidingPerson
FROM HT1380 H80
LEFT JOIN HT1107 H07 ON H07.DivisionID = H80.DivisionID AND H07.QuitJobID = H80.QuitJobID
LEFT JOIN HT1400 H001 ON H001.DivisionID = H80.DivisionID AND H001.EmployeeID = H80.DecidingPerson
LEFT JOIN HT1400 H00 ON H00.DivisionID = H80.DivisionID AND H00.EmployeeID = H80.EmployeeID
LEFT JOIN HT1101 H01 ON H01.DivisionID = H00.DivisionID AND H01.TeamID = H00.TeamID
LEFT JOIN AT1102 A02 ON A02.DivisionID = H00.DivisionID AND A02.DepartmentID = H00.DepartmentID
WHERE H80.DivisionID = @DivisionID
AND H80.EmployeeID = @EmployeeID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

