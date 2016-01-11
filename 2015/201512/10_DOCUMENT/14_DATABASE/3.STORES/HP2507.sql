/****** Object: StoredProcedure [dbo].[HP2507] Script Date: 07/30/2010 16:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created by: Vo Thanh Huong
----Created date: 26/07/2004
----purpose: X? lý s? li?u IN báo cáo danh sách lao d?ng, qu? ti?n luong di?u ch?nh phi?u KCB

/********************************************
'* Edited by: [GS] [Việt Khánh] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2507] 
    @DivisionID NVARCHAR(50), 
    @DepartmentID NVARCHAR(50), 
    @TeamID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT
AS 

DECLARE 
    @FromMonth INT, 
    @TranMonth0 INT, 
    @TranYear0 INT, 
    @sSQL1 NVARCHAR(4000), 
    @sSQL2 NVARCHAR(4000), 
    @sSQL3 NVARCHAR(4000) 

IF @TranMonth = 1 
    BEGIN
        SET @TranYear0 = @TranYear - 1 
        SET @TranMonth0 = 12
    END
ELSE
    BEGIN
        SET @TranYear0 = @TranYear 
        SET @TranMonth0 = @TranMonth - 1
    END

---Danh sach nhan vien nop BHXH quy nay
SET @sSQL1 = '
    SELECT HT00.DivisionID, HT00.EmployeeID, SNo, CNo, HT00.CFromDate, CToDate, HospitalID, 
        ISNULL(HT01.BaseSalary*GeneralCo, 0) AS BaseSalary 
    FROM HT2460 HT00 INNER JOIN HT2461 HT01 ON HT00.EmployeeID = HT01.EmployeeID AND 
        HT00.TranMonth = HT01.TranMonth AND HT01.TranYear = HT01.TranYear AND HT01.DivisionID = HT01.DivisionID
    WHERE HT00.DivisionID = ''' + @DivisionID + ''' AND
        HT00.DepartmentID LIKE ''' + @DepartmentID + ''' AND
        ISNULL(HT00.TeamID, '''') LIKE ISNULL(''' + @TeamID + ''', '''') AND 
        HT00.TranMonth = ' + STR(@TranMonth) + ' AND
        HT00.TranYear = ' + STR(@TranYear) 

---Danh sach nhan vien nop BHXH quy truoc
SET @sSQL2 = '
    SELECT HT00.DivisionID, HT00.EmployeeID, SNo, CNo, HT00.CFromDate, CToDate, HospitalID, 
        ISNULL(HT01.BaseSalary*GeneralCo, 0) AS BaseSalary 
    FROM HT2460 HT00 INNER JOIN HT2461 HT01 ON HT00.EmployeeID = HT01.EmployeeID AND 
        HT00.TranMonth = HT01.TranMonth AND HT01.TranYear = HT01.TranYear AND HT01.DivisionID = HT01.DivisionID
    WHERE HT00.DivisionID = ''' + @DivisionID + ''' AND
        HT00.DepartmentID LIKE ''' + @DepartmentID + ''' AND
        ISNULL(HT00.TeamID, '''') LIKE ISNULL(''' + @TeamID + ''', '''') AND 
        HT00.TranMonth = ' + STR(@TranMonth0) + ' AND
        HT00.TranYear = ' + STR(@TranYear0) 

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'HV2501' )
    EXEC('---tao boi HP2509
        CREATE VIEW HV2501 AS ' + @sSQL1)
ELSE
    EXEC('---tao boi HP2509
        ALTER VIEW HV2501 AS ' + @sSQL1)

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'HV2502' )
    EXEC('---tao boi HP2509
        CREATE VIEW HV2502 AS ' + @sSQL2)
ELSE
    EXEC('---tao boi HP2509
        ALTER VIEW HV2502 AS ' + @sSQL2)

SET @sSQL1 = 
CASE 
    WHEN NOT EXISTS(SELECT TOP 1 1 FROM HV2502 Where DivisionID = @DivisionID ) THEN
        ''
    ELSE 
        ---tang moi
        '
        SELECT HV00.DivisionID, HV00.EmployeeID, Status = 1, '''' AS Notes, 
            HV01.Orders, CNo, HV00.CFromDate, CToDate, SNo, IsMale, Birthday, FullName, 
            HT00.HospitalName, FullAddress, DutyName, HV00.BaseSalary 
        FROM HV2501 HV00 INNER JOIN HV1400 HV01 ON HV00.EmployeeID = HV01.EmployeeID and HV00.DivisionID = HV01.DivisionID
            LEFT JOIN HT1009 HT00 ON HV00.HospitalID = HT00.HospitalID and HV00.DivisionID = HT00.DivisionID
        WHERE HV00.DivisionID = '''+@DivisionID+''' And HV00.EmployeeID not IN (SELECT EmployeeID FROM HV2502 Where DivisionID = '''+@DivisionID+''') 
        UNION ' 
END
-----giam
SET @sSQL2 = 
CASE 
    WHEN NOT EXISTS(SELECT TOP 1 1 FROM HV2501 Where DivisionID = @DivisionID) THEN
        ''
    ELSE
        '
        SELECT HV00.DivisionID, HV00.EmployeeID, Status = 3, CASE WHEN EmployeeStatus = 9 THEN ''' + 'Nghæ vieäc''' + ' ELSE '''' END AS Notes, 
            HV01.Orders, CNo, HV00.CFromDate, CToDate, SNo, IsMale, Birthday, FullName, 
            HT.HospitalName, FullAddress, DutyName, HV00.BaseSalary
        FROM HV2502 HV00 INNER JOIN HV1400 HV01 ON HV00.EmployeeID = HV01.EmployeeID and HV00.DivisionID = HV01.DivisionID
            LEFT JOIN HT1009 HT ON HV00.HospitalID = HT.HospitalID and HV00.DivisionID = HT.DivisionID
        WHERE HV00.DivisionID = '''+@DivisionID+''' And HV00.EmployeeID not IN (SELECT EmployeeID FROM HV2501 Where DivisionID = '''+@DivisionID+''') 
        UNION ' 
END 
--- INSERT dong de IN bao cao 
SET @sSQL3 = '
    SELECT ''' + @DivisionID + ''' AS DivisionID , '''' AS EmployeeID, 0 AS Status, '''' AS Notes, 
        0 AS Orders, '''' AS CNo, '''' AS CFromDate, '''' AS CToDate, '''' AS SNo, '''' AS IsMale, '''' AS Birthday, '''' 
        AS FullName, '''' AS HospitalName, '''' FullAddress, '''' AS DutyName, 0 AS BaseSalary
    FROM HV2501 Where DivisionID = '''+@DivisionID+'''
    UNION ' + 
    --- INSERT dong de IN bao cao 
    '    SELECT ''' + @DivisionID + ''' AS DivisionID ,'''' AS EmployeeID, 2 AS Status, '''' AS Notes, 
        0 AS Orders, '''' AS CNo, '''' AS CFromDate, '''' AS CToDate, '''' AS SNo, '''' AS IsMale, '''' AS Birthday, '''' 
        AS FullName, '''' AS HospitalName, '''' FullAddress, '''' AS DutyName, 0 AS BaseSalary
    FROM HV2501  Where DivisionID = '''+@DivisionID+'''
    UNION ' + 
    --- INSERT dong de IN bao cao 
    '
    SELECT ''' + @DivisionID + ''' AS DivisionID ,'''' AS EmployeeID, 4 AS Status, '''' AS Notes, 
        0 AS Orders, '''' AS CNo, '''' AS CFromDate, '''' AS CToDate, '''' AS SNo, '''' AS IsMale, '''' AS Birthday, '''' 
        AS FullName, '''' AS HospitalName, '''' FullAddress, '''' AS DutyName, 0 AS BaseSalary
    FROM HV2501 Where DivisionID = '''+@DivisionID+'''
' 

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'HV2503' )
    EXEC('---tao boi HP2509
        CREATE VIEW HV2503 AS ' + @sSQL1 + @sSQL2 + @sSQL3)
ELSE
    EXEC('---tao boi HP2509 
        ALTER VIEW HV2503 AS ' + @sSQL1 + @sSQL2 + @sSQL3)