IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP1380]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP1380]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Create VIEW HV1380 để in quyết định thôi việc
-- <History>
----Create on 23/10/2013 by Thanh Sơn
-- <Example>
---- EXEC HP1380 'SAS',8,2013

CREATE PROCEDURE HP1380
( 
	@DivisionID AS NVARCHAR(50),
	@TranMonth INT,
	@TranYear INT
) 
AS 
DECLARE @sSQL1 NVARCHAR (MAX)
SET @sSQL1 = N'
SELECT HT1380.DecidingNo, HT1380.DecidingDate, HT1380.DecidingPerson,
(SELECT Fullname FROM HV1400 WHERE HV1400.EmployeeID = HT1380.DecidingPerson And HV1400.DivisionID = HT1380.DivisionID ) AS DecidingPersonName, 
HT1380.DecidingPersonDuty, HT1380.Proposer,
(SELECT Fullname FROM HV1400 WHERE HV1400.EmployeeID = HT1380.Proposer And HV1400.DivisionID = HT1380.DivisionID) AS ProposerName, 
HT1380.ProposerDuty, HT1380.EmployeeID, UPPER (HV1400.FullName) AS FullName, HV1400.IsMaleID, HT1380.DutyName,
HT03.DepartmentID,A02.DepartmentName,
HT1380.WorkDate, HT1380.LeaveDate, HT1380.QuitJobID, HT1107.QuitJobName, HT1380.Allowance, HT1380.Notes,
HT1380.DivisionID,
HV1400.Birthday, HV1400.IdentifyCardNo, HV1400.IdentifyDate , HV1400.IdentifyPlace,
(ISNULL(ISNULL(HT13.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT14.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT15.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT16.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT17.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT18.SalaryAmounts,HT03.BaseSalary),0))/6 AS BaseSalaryAverage,HT03.SalaryCoefficient,
(CASE WHEN DATEDIFF(MONTH, HT03.WorkDate, ''2008-12-31'') - (12 * (DATEDIFF(YEAR, HT03.WorkDate, ''2008-12-31'')))+ 1 >= 6 
     THEN DATEDIFF(YEAR, HT03.WorkDate, ''2008-12-31'') + 1 
     ELSE DATEDIFF(YEAR, HT03.WorkDate, ''2008-12-31'') END) AS YearsNo,
LTRIM(STR(MONTH(HT1380.WorkDate))) + ''/''+LTRIM(STR(YEAR(HT1380.WorkDate))) AS FromMonth,HT1380.Subsidies
FROM HT1380
LEFT JOIN HT1403 HT03 ON HT03.DivisionID = HT1380.DivisionID AND HT03.EmployeeID = HT1380.EmployeeID
LEFT JOIN AT1102 A02 ON A02.DivisionID = HT03.DivisionID AND A02.DepartmentID = HT03.DepartmentID
LEFT JOIN HT1302 HT13 ON HT13.DivisionID = HT1380.DivisionID AND HT13.EmployeeID = HT1380.EmployeeID 
   AND '''+STR(@TranYear*100+@TranMonth)+''' BETWEEN HT13.FromYear*100+HT13.FromMonth AND HT13.ToYear*100+HT13.ToMonth
LEFT JOIN HT1302 HT14 ON HT14.DivisionID = HT1380.DivisionID AND HT14.EmployeeID = HT1380.EmployeeID 
   AND '''+STR(@TranYear*100+@TranMonth - 1)+''' BETWEEN HT14.FromYear*100+HT14.FromMonth AND HT14.ToYear*100+HT14.ToMonth
LEFT JOIN HT1302 HT15 ON HT15.DivisionID = HT1380.DivisionID AND HT15.EmployeeID = HT1380.EmployeeID 
   AND '''+STR(@TranYear*100+@TranMonth - 2)+''' BETWEEN HT15.FromYear*100+HT15.FromMonth AND HT15.ToYear*100+HT15.ToMonth
LEFT JOIN HT1302 HT16 ON HT16.DivisionID = HT1380.DivisionID AND HT16.EmployeeID = HT1380.EmployeeID 
   AND '''+STR(@TranYear*100+@TranMonth - 3)+''' BETWEEN HT16.FromYear*100+HT16.FromMonth AND HT16.ToYear*100+HT16.ToMonth
LEFT JOIN HT1302 HT17 ON HT17.DivisionID = HT1380.DivisionID AND HT17.EmployeeID = HT1380.EmployeeID 
   AND '''+STR(@TranYear*100+@TranMonth - 4)+''' BETWEEN HT17.FromYear*100+HT17.FromMonth AND HT17.ToYear*100+HT17.ToMonth
LEFT JOIN HT1302 HT18 ON HT18.DivisionID = HT1380.DivisionID AND HT18.EmployeeID = HT1380.EmployeeID 
   AND '''+STR(@TranYear*100+@TranMonth - 5)+''' BETWEEN HT18.FromYear*100+HT18.FromMonth AND HT18.ToYear*100+HT18.ToMonth	
INNER JOIN HV1400 ON HT1380.EmployeeID = HV1400.EmployeeID AND HT1380.DivisionID = HV1400.DivisionID	
INNER JOIN HT1107 ON HT1380.QuitJobID = HT1107.QuitJobID AND HT1380.DivisionID = HT1107.DivisionID '

IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HV1380]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HV1380]

EXEC('CREATE VIEW HV1380 --Tạo bởi HP1380
AS'+ @sSQL1)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

