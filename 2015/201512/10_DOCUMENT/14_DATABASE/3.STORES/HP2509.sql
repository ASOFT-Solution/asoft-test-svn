/****** Object: StoredProcedure [dbo].[HP2509] Script Date: 07/30/2010 16:08:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created by: Vo Thanh Huong
----Created date: 27/07/2004
----purpose: X? lý s? li?u IN báo cáo luong (t?ng PP)

/********************************************
'* Edited by: [GS] [Việt Khánh] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2509] 
    @DivisionID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT, 
    @PayrollMethodID NVARCHAR(50)
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @DayperMonth INT

SELECT @DayPerMonth = ISNULL(DayPerMonth, 24) FROM HT0000 Where DivisionID = @DivisionID

SET @sSQL = '
    SELECT HT34.DivisionID
		HT34.EmployeeID, 
        FullName, LTRIM(RTRIM(LastName)) + ''' + ' ''' + ' + LTRIM(RTRIM( MiddleName)) AS LMName, FirstName, 
        HT34.DivisionID, 
        HT34.TranMonth, 
        HT34.TranYear, 
        HT34.DepartmentID, 
        AT11.DepartmentName, 
        HT34.TeamID, 
        HT24.BaseSalary, 
        (HT24.BaseSalary/' + STR(@DayPerMonth) + ') AS AvgBaseSalary, 
        HT24.SalaryCoefficient, 
        HT24.DutyCoefficient, 
        HT24.TimeCoefficient, 
        (HT24.TimeCoefficient*HT24.BaseSalary/' + STR(@DayPerMonth) + ') AS TimeSalary, 
        (HT24.DutyCoefficient*HT24.BaseSalary/' + STR(@DayPerMonth) + ') AS DutySalary, 
        SUM(ISNULL(Income01, 0)) AS Income01, 
        SUM(ISNULL(Income02, 0)) AS Income02, 
        SUM(ISNULL(Income03, 0)) AS Income03, 
        SUM(ISNULL(Income04, 0)) AS Income04, 
        SUM(ISNULL(Income05, 0)) AS Income05, 
        SUM(ISNULL(Income06, 0)) AS Income06, 
        SUM(ISNULL(Income07, 0)) AS Income07, 
        SUM(ISNULL(Income08, 0)) AS Income08, 
        SUM(ISNULL(Income09, 0)) AS Income09, 
        SUM(ISNULL(Income10, 0)) AS Income10, 
        InsAmount, 
        HeaAmount, 
        TempAmount, 
        TraAmount, 
        TaxAmount, 
        SUM(ISNULL(SubAmount01, 0)) AS SubAmount01, 
        SUM(ISNULL(SubAmount02, 0)) AS SubAmount02, 
        SUM(ISNULL(SubAmount03, 0)) AS SubAmount03, 
        SUM(ISNULL(SubAmount04, 0)) AS SubAmount04, 
        SUM(ISNULL(SubAmount05, 0)) AS SubAmount05, 
        SUM(ISNULL(HT24.C01, 0)*HT24.BaseSalary/' + STR(@DayPerMonth) + ') AS C01, 
        SUM(ISNULL(HT24.C02, 0)*HT24.BaseSalary/' + STR(@DayPerMonth) + ') AS C02, 
        SUM(ISNULL(HT24.C03, 0)*HT24.BaseSalary/' + STR(@DayPerMonth) + ') AS C03, 
        SUM(ISNULL(HT24.C04, 0)*HT24.BaseSalary/' + STR(@DayPerMonth) + ') AS C04, 
        SUM(ISNULL(HT24.C05, 0)*HT24.BaseSalary/' + STR(@DayPerMonth) + ') AS C05, 
        SUM(ISNULL(HT24.C06, 0)*HT24.BaseSalary/' + STR(@DayPerMonth) + ') AS C06, 
        SUM(ISNULL(HT24.C07, 0)*HT24.BaseSalary/' + STR(@DayPerMonth) + ') AS C07, 
        SUM(ISNULL(HT24.C08, 0)*HT24.BaseSalary/' + STR(@DayPerMonth) + ') AS C08, 
        SUM(ISNULL(HT24.C09, 0)*HT24.BaseSalary/' + STR(@DayPerMonth) + ') AS C09, 
        SUM(ISNULL(HT24.C10, 0)*HT24.BaseSalary/' + STR(@DayPerMonth) + ') AS C10, 
        HV14.Orders 
    FROM HT3400 HT34 INNER JOIN HV1400 HV14 ON HV14.EmployeeID = HT34.EmployeeID and HV14.DivisionID = HT34.DivisionID
        INNER JOIN HT2400 HT24 ON HT24.EmployeeID = HT34.EmployeeID AND
        HT24.TranMonth = HT34.TranMonth AND
        HT24.TranYear = HT34.TranYear and HT24.DivisionID = HT34.DivisionID 
        INNER JOIN AT1102 AT11 ON AT11.DivisionID = HT34.DivisionID AND AT11.DepartmentID = HT34.DepartmentID 
    WHERE HT34.DivisionID = ''' + @DivisionID + ''' AND 
        HT34.TranMonth = ' + STR(@TranMonth) + ' AND
        HT34.TranYear = ' + STR(@TranYear) + ' AND 
        PayrollMethodID LIKE ''' + @PayrollMethodID + ''' 
    GROUP BY HT34.EmployeeID, FullName, FirstName, MiddleName, LastName, 
        HT34.DivisionID, HT34.TranMonth, HT34.TranYear, HT34.DepartmentID, AT11.Departmentname, 
        HT34.TeamID, HT24.BaseSalary, HT24.SalaryCoefficient, HT24.DutyCoefficient, HT24.TimeCoefficient, 
        InsAmount, HeaAmount, TempAmount, 
        TraAmount, TaxAmount, HV14.Orders
'

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'HV2510' )
    EXEC('---tao boi HP2509
        CREATE VIEW HV2510 AS ' + @sSQL)
ELSE
    EXEC('---tao boi HP2509
        ALTER VIEW HV2510 AS ' + @sSQL)