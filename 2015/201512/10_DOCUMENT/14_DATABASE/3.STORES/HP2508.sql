/****** Object:  StoredProcedure [dbo].[HP2508]    Script Date: 11/19/2011 10:30:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2508]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2508]
GO
/****** Object:  StoredProcedure [dbo].[HP2508]    Script Date: 11/19/2011 10:30:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
----Created by: Vo Thanh Huong
----Created date: 22/07/2004
----purpose: X? lý s? li?u IN báo cáo danh sách lao d?ng, qu? ti?n luong di?u ch?nh m?c n?p BHXH

/********************************************
'* Edited by: [GS] [Việt Khánh] [02/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2508] 
    @DivisionID NVARCHAR(50), 
    @DepartmentID NVARCHAR(50), 
    @TeamID NVARCHAR(50), 
    @TranQuater INT, 
    @TranYear INT
AS 

DECLARE 
    @FromMonth INT, 
    @ToMonth INT, 
    @FromMonth0 INT, 
    @ToMonth0 INT, 
    @TranYear0 INT, 
    @sSQL1 NVARCHAR(4000), 
    @sSQL2 NVARCHAR(4000), 
    @sSQL3 NVARCHAR(4000) 

SET @FromMonth = @TranQuater*3 - 2
SET @ToMonth = @TranQuater*3

IF @TranQuater = 1 
    BEGIN
        SET @TranYear0 = @TranYear - 1 
        SET @FromMonth0 = 10
        SET @ToMonth0 = 12 
    END
ELSE
    BEGIN
        SET @TranYear0 = @TranYear 
        SET @FromMonth0 = (@TranQuater - 1)*3 - 2
        SET @ToMonth0 = (@TranQuater - 1)*3 
    END

---Danh sach nhan vien nop BHXH quy nay
SET @sSQL1 = '
    SELECT HT00.DivisionID , HT00.EmployeeID, MAX(ISNULL(SNo, '''')) AS SNo, MAX(ISNULL(CNo, '''')) AS CNo, MAX(ISNULL(HospitalID, '''' )) AS HospitalID, 
        MAX(ISNULL(HT01.BaseSalary*GeneralCo, 0)) AS BaseSalary, 
        MAX(ISNULL(HT01.BaseSalary*GeneralCo, 0)) AS MaxBS, 
        SUM(ISNULL(CASE WHEN HT00.TranMonth = ' + STR(@FromMonth) + ' THEN (HT01.BaseSalary*GeneralCo) ELSE 0 END, 0)) AS BS1, 
        SUM(ISNULL(CASE WHEN HT00.TranMonth = ' + STR(@FromMonth + 1) + ' THEN HT01.BaseSalary*GeneralCo ELSE 0 END, 0)) AS BS2, 
        SUM(ISNULL(CASE WHEN HT00.TranMonth = ' + STR(@ToMonth) + ' THEN HT01.BaseSalary*GeneralCo ELSE 0 END, 0)) AS BS3
    FROM HT2460 HT00 INNER JOIN HT2461 HT01 ON HT00.EmployeeID = HT01.EmployeeID AND 
        HT00.TranMonth = HT01.TranMonth AND HT01.TranYear = HT01.TranYear and HT01.DivisionID = HT01.DivisionID
    WHERE HT00.DivisionID = ''' + @DivisionID + ''' AND
        HT00.DepartmentID LIKE ''' + @DepartmentID + ''' AND
        ISNULL(HT00.TeamID, '''') LIKE ISNULL(''' + @TeamID + ''', '''') AND 
        (HT00.TranMonth BETWEEN ' + STR(@FromMonth) + ' AND ' + STR(@ToMonth) + ') AND
        HT00.TranYear = ' + STR(@TranYear) + '
    GROUP BY HT00.DivisionID , HT00.EmployeeID
' 

---Danh sach nhan vien nop BHXH quy truoc
SET @sSQL2 = '
    SELECT HT00.DivisionID , HT00.EmployeeID, MAX(ISNULL(SNo, '''')) AS SNo, MAX(ISNULL(CNo, '''')) AS CNo, MAX(ISNULL(HospitalID, '''')) AS HospitalID, 
        MAX(ISNULL(HT01.BaseSalary*GeneralCo, 0)) AS BaseSalary, 
        SUM(ISNULL(CASE WHEN HT01.TranMonth = ' + STR(@ToMonth0) + ' THEN HT01.BaseSalary*GeneralCo ELSE 0 END, 0)) AS BS0
    FROM HT2460 HT00 INNER JOIN HT2461 HT01 ON HT00.EmployeeID = HT01.EmployeeID AND
        HT00.TranMonth = HT01.TranMonth AND HT00.TranYear = HT01.TranYear and HT00.DivisionID = HT01.DivisionID 
    WHERE HT00.DivisionID = ''' + @DivisionID + ''' AND
        HT00.DepartmentID LIKE ''' + @DepartmentID + ''' AND
        ISNULL(HT00.TeamID, '''') LIKE ISNULL(''' + @TeamID + ''', '''' ) AND
        (HT00.TranMonth BETWEEN ' + STR(@FromMonth0) + ' AND ' + STR(@ToMonth0) + ') AND
        HT00.TranYear = ' + STR(@TranYear0) + '
    GROUP BY HT00.DivisionID , HT00.EmployeeID
'

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'HV2507' )
    EXEC('---tao boi HP2507
        CREATE VIEW HV2507 AS ' + @sSQL1)
ELSE
    EXEC('---tao boi HP2507
        ALTER VIEW HV2507 AS ' + @sSQL1)

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'HV2508' )
    EXEC('---tao boi HP2508
        CREATE VIEW HV2508 AS ' + @sSQL2)
ELSE
    EXEC('---tao boi HP2508
        ALTER VIEW HV2508 AS ' + @sSQL2)
        
SET @sSQL1 = 
---tang moi
CASE 
    WHEN EXISTS(SELECT TOP 1 1 FROM HV2507 Where DivisionID = @DivisionID) THEN
        '
        SELECT HV00.DivisionID , HV00.EmployeeID, Status = 1, 
            0 AS BaseSalary1, HV00.BaseSalary AS BaseSalary2, 
            ISNULL(''' + 'HÑ T''' + ' + LTRIM(RTRIM(Month(SignDate))) + LTRIM(RTRIM(year(SignDate))), '''') AS Notes, 
            HV01.Orders, CNo, SNo, IsMale, Birthday, FullName, HT00.HospitalName, FullAddress, DutyName 
        FROM HV2507 HV00 INNER JOIN HV1400 HV01 ON HV00.EmployeeID = HV01.EmployeeID and HV00.DivisionID = HV01.DivisionID
            LEFT JOIN HT1009 HT00 ON HV00.HospitalID = HT00.HospitalID and HV00.DivisionID = HT00.DivisionID
            LEFT JOIN (SELECT DivisionID,EmployeeID, min(ISNULL(SignDate, '''')) AS SignDate FROM HT1360 Where DivisionID = '''+@DivisionID+''' GROUP BY DivisionID,EmployeeID) HT01
            ON HV00.EmployeeID = HT01.EmployeeID and HV00.DivisionID = HT01.DivisionID
        WHERE HV00.DivisionID = ''' + @DivisionID + ''' AND HV00.EmployeeID not IN (SELECT EmployeeID FROM HV2508 WHERE DivisionID = '''+@DivisionID+''')
        UNION 
        ' 
    ELSE ''
END

SET @sSQL1 = @sSQL1 +
-----giam
CASE 
    WHEN EXISTS(SELECT TOP 1 1 FROM HV2508 Where DivisionID = @DivisionID) THEN
        '
        SELECT HV00.DivisionID , HV00.EmployeeID, Status = 3, 
            HV00.BaseSalary AS BaseSalary1, 0 AS BaseSalary2, CASE WHEN EmployeeStatus = 9 THEN ''' + 'Nghæ vieäc''' + ' ELSE ''''
            END AS Notes, 
            HV01.Orders, CNo, SNo, IsMale, Birthday, FullName, HT.HospitalName, FullAddress, DutyName
        FROM HV2508 HV00 INNER JOIN HV1400 HV01 ON HV00.EmployeeID = HV01.EmployeeID and HV00.DivisionID = HV01.DivisionID
            LEFT JOIN HT1009 HT ON HV00.HospitalID = HT.HospitalID and HV00.DivisionID = HT.DivisionID
        WHERE HV00.DivisionID = ''' + @DivisionID + ''' AND HV00.EmployeeID not IN (SELECT EmployeeID FROM HV2507 Where DivisionID = '''+@DivisionID+''') 
        UNION
        '
    ELSE ''
END

SET @sSQL2 =
CASE 
    WHEN EXISTS (SELECT TOP 1 1 FROM HV2507 Where DivisionID = @DivisionID) THEN 
        ------tang luong
        '
        SELECT HV00.DivisionID , HV00.EmployeeID, 5 AS Status, 
            CASE WHEN (BS0 < MaxBS AND BS1 = MaxBS AND BS0 <> 0) THEN BS0
            WHEN (BS1 < BS2 AND BS2 = MaxBS AND BS1 <> 0) THEN BS1
            ELSE BS2 END AS BaseSalary1, 
            MaxBS AS BaseSalay2, ''' + 'Taêng löông''' + ' AS Notes, 
            HV02.Orders, HV00.CNo, HV00.SNo, IsMale, Birthday, FullName, HT.HospitalName, FullAddress, DutyName
        FROM HV2507 HV00 INNER JOIN HV2508 Hv01 ON HV00.EmployeeID = HV01.EmployeeID and HV00.DivisionID = HV01.DivisionID
            INNER JOIN HV1400 HV02 ON HV02.EmployeeID = HV00.EmployeeID and HV02.DivisionID = HV00.DivisionID 
            LEFT JOIN HT1009 HT ON HT.HospitalID = HV00.HospitalID and HT.DivisionID = HV00.DivisionID
        WHERE HV00.DivisionID = ''' + @DivisionID + ''' AND 
			HV00.EmployeeID IN (SELECT EmployeeID FROM HV2508 WHERE DivisionID = '''+@DivisionID+''') AND
            ((BS0 < MaxBS AND BS1 = MaxBS AND BS0 <> 0) OR 
            (BS1 < BS2 AND BS2 = MaxBS AND BS1 <> 0) OR
            (BS2 < BS3 AND BS3 = MaxBS AND BS2 <> 0) )
        UNION        
        ' 
    ELSE ''
END

SET @sSQL2 = @sSQL2 + 
CASE 
    WHEN EXISTS (SELECT TOP 1 1 FROM HV2508 Where DivisionID = @DivisionID) THEN 
        ----giam luong
        ' SELECT HV00.DivisionID , HV00.EmployeeID, 5 AS Status, 
            CASE WHEN (BS0 > BS1 AND BS1 = MaxBS AND BS1 <> 0) THEN BS0 
            WHEN (BS1 > BS2 AND BS1 = MaxBS AND BS2 <> 0) THEN BS1
            ELSE BS2 END AS BaseSalary1, 
            CASE WHEN (BS0 > BS1 AND BS1 = MaxBS AND BS1<> 0) THEN BS1 
            WHEN (BS1 > BS2 AND BS1 = MaxBS AND BS2 <> 0) THEN BS2 
            ELSE BS3 END AS BaseSalary2, 
            ''' + 'Giaûm löông''' + ' AS Notes, 
            HV02.Orders, HV00.CNo, HV00.SNo, IsMale, Birthday, FullName, HT.HospitalName, FullAddress, DutyName
        FROM HV2507 HV00 INNER JOIN HV2508 HV01 ON HV00.EmployeeID = HV01.EmployeeID and HV00.DivisionID = HV01.DivisionID
            INNER JOIN HV1400 HV02 ON HV02.EmployeeID = HV00.EmployeeID and HV02.DivisionID = HV00.DivisionID 
            LEFT JOIN HT1009 HT ON HT.HospitalID = HV00.HospitalID and HT.DivisionID = HV00.DivisionID
        WHERE HV00.DivisionID = ''' + @DivisionID + ''' AND 
			HV00.EmployeeID IN (SELECT EmployeeID FROM HV2508 WHERE DivisionID = '''+@DivisionID+''' ) AND
            ((BS0 > BS1 AND BS1 = MaxBS AND BS1 <> 0) OR 
            (BS1 > BS2 AND BS1 = MaxBS AND BS2 <> 0) OR
            (BS2 > BS3 AND BS2 = MaxBS AND BS3 <> 0))
        UNION ' 
    ELSE ''
END

SET @sSQL3 = 
--- tinh tong so lao dong, luong quy truoc
'
    SELECT ''' + @DivisionID + '''AS DivisionID, '''' AS EmployeeID, 6 AS Status, COUNT(EmployeeID) AS BaseSalary1, SUM(BS0) AS BaseSalary2, 
        '''' AS Notes, 0 AS Orders, '''' AS CNo, '''' AS SNo, '''' AS IsMale, '''' AS Birthday, ''''
        AS FullName, '''' AS HospitalName, '''' AS FullAddress, '''' AS DutyName
    FROM HV2508 Where DivisionID = '''+@DivisionID+'''
    UNION ' + 
    --- tinh tong so lao dong, luong quy nay
    ' SELECT ''' + @DivisionID + '''AS DivisionID, '''' AS EmployeeID, 7 AS Status, COUNT(EmployeeID) AS BaseSalary1, SUM(BS3) AS BaseSalary2, 
        '''' AS Notes, 0 AS Orders, '''' AS CNo, '''' AS SNo, '''' AS IsMale, '''' AS Birthday, '''' 
        AS FullName, '''' AS HospitalName, '''' FullAddress, '''' AS DutyName
    FROM HV2507  Where DivisionID = '''+@DivisionID+'''
    UNION ' + 
    --- INSERT dong de IN bao cao 
    ' SELECT ''' + @DivisionID + '''AS DivisionID, '''' AS EmployeeID, 0 AS Status, 0 AS BaseSalary1, 0 AS BaseSalary2, 
        '''' AS Notes, 0 AS Orders, '''' AS CNo, '''' AS SNo, '''' AS IsMale, '''' AS Birthday, '''' 
        AS FullName, '''' AS HospitalName, '''' FullAddress, '''' AS DutyName
    FROM HV2507 Where DivisionID = '''+@DivisionID+'''
    UNION ' + 
    --- INSERT dong de IN bao cao 
    ' SELECT ''' + @DivisionID + '''AS DivisionID, '''' AS EmployeeID, 2 AS Status, 0 AS BaseSalary1, 0 AS BaseSalary2, 
        '''' AS Notes, 0 AS Orders, '''' AS CNo, '''' AS SNo, '''' AS IsMale, '''' AS Birthday, '''' 
        AS FullName, '''' AS HospitalName, '''' FullAddress, '''' AS DutyName
    FROM HV2507  Where DivisionID = '''+@DivisionID+'''
    UNION ' + 
    --- INSERT dong de IN bao cao 
    ' SELECT ''' + @DivisionID + '''AS DivisionID, '''' AS EmployeeID, 4 AS Status, 0 AS BaseSalary1, 0 AS BaseSalary2, 
        '''' AS Notes, 0 AS Orders, '''' AS CNo, '''' AS SNo, '''' AS IsMale, '''' AS Birthday, '''' 
        AS FullName, '''' AS HospitalName, '''' FullAddress, '''' AS DutyName
    FROM HV2507 Where DivisionID = '''+@DivisionID+'''
'

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'HV2509' )
    EXEC('---tao boi HP2508
        CREATE VIEW HV2509 AS ' + @sSQL1 + @sSQL2 + @sSQL3)
ELSE
    EXEC('---tao boi HP2508
        ALTER VIEW HV2509 AS ' + @sSQL1 + @sSQL2 + @sSQL3)

PRINT @sSQL1 + @sSQL2 + @sSQL3

GO


