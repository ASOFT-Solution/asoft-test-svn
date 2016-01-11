/****** Object:  StoredProcedure [dbo].[HP2506]    Script Date: 11/19/2011 12:17:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2506]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2506]
GO
/****** Object:  StoredProcedure [dbo].[HP2506]    Script Date: 11/19/2011 12:17:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
----Created by: Vo Thanh Huong
----Created date: 18/07/2004
----purpose: IN báo cáo danh sách lao d?ng n?p BHXH (quý) 

/********************************************
'* Edited by: [GS] [Việt Khánh] [02/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2506]
    @TranQuater INT, 
    @TranYear INT, 
    @DivisionID NVARCHAR(50), 
    @DepartmentID NVARCHAR(50), 
    @TeamID NVARCHAR(50) 
AS 

DECLARE 
    @sSQL NVARCHAR(4000), 
    @FromMonth INT, 
    @ToMonth INT

SET @FromMonth = @TranQuater*3 - 2 
SET @ToMonth = @TranQuater*3 

SET @sSQL = '
    SELECT HT00.DivisionID, HV.Orders, HT00.EmployeeID, FullName, Birthday, MAX(ISNULL(SNo, ''' + ''')) AS SNo, 
        SUM(ISNULL(CASE WHEN HT00.TranMonth = ' + LTRIM(RTRIM(STR( @FromMonth))) + ' THEN HT00.BaseSalary*GeneralCo ELSE 0 END, 0)) AS BaseSalary1, 
        SUM(ISNULL(CASE WHEN HT00.TranMonth = ' + LTRIM(RTRIM(STR(@FromMonth + 1))) + ' THEN HT00.BaseSalary*GeneralCo ELSE 0 END, 0)) AS BaseSalary2, 
        SUM(ISNULL(CASE WHEN HT00.TranMonth = ' + LTRIM(RTRIM(STR(@ToMonth))) + ' THEN HT00.BaseSalary*GeneralCo ELSE 0 END, 0)) AS BaseSalary3, 
        AVG(HT00.BaseSalary) AS AvgBaseSalary 
    FROM HT2461 HT00 INNER JOIN HV1400 HV ON HV.EmployeeID = HT00.EmployeeID and HV.DivisionID = HT00.DivisionID 
        INNER JOIN HT2460 HT01 ON HT00.EmployeeID = HT01.EmployeeID AND
        HT00.TranMonth = HT01.TranMonth AND HT00.TranYear = HT01.TranYear and HT00.DivisionID = HT01.DivisionID
    WHERE HT00.DivisionID = ''' + @DivisionID + ''' AND 
        HT00.TranYear = ' + LTRIM(RTRIM( STR(@TranYear))) + ' AND
        (HT00.Tranmonth BETWEEN ' + LTRIM(RTRIM(STR(@FromMonth))) + ' AND ' + LTRIM(RTRIM(STR(@ToMonth))) + ') AND
        HT00.DepartmentID LIKE ''' + @DepartmentID + ''' AND
        ISNULL(HT00.TeamID, ''' + ''') LIKE ISNULL(''' + @TeamID + ''', ''' + ''') 
    GROUP BY HT00.DivisionID, HV.Orders, HT00.EmployeeID, FullName, Birthday'


IF NOT EXISTS (SELECT name FROM sysObjects WHERE id = Object_ID(N'[dbo].[HV2506]') AND OBJECTPROPERTY(id, N'IsView') = 1)
    EXEC ('---tao boi HP2506
        CREATE VIEW HV2506 AS ' + @sSQL)
ELSE
    EXEC ('---tao boi HP2506
        Alter View HV2506 AS ' + @sSQL)
GO


