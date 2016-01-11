IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2490]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2490]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Create By : Dang Le Bao Quynh; Date 03/11/2008
--Purpose: Bao cao bien dong luong
--- Edited by:[Thanh Thịnh] [02/11/2015] : Thêm Mức lương cố định (Basesalary) trên hồ sơ lương
-- Tỉ lệ % thực hiện/kế hoạch: Hệ số trên hồ sơ lương (liên hệ CON khi gắp trường), Mã chức vụ, Ngày vào làm

/********************************************
'* Edited by: [GS] [Việt Khánh] [02/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2490] 
    @DivisionID NVARCHAR(50), 
    @FromDepartmentID NVARCHAR(50), 
    @ToDepartmentID NVARCHAR(50), 
    @TeamID NVARCHAR(50), 
    @FromEmployeeID NVARCHAR(50), 
    @ToEmployeeID NVARCHAR(50), 
    @FromTranMonth INT, 
    @FromTranYear INT, 
    @ToTranMonth INT, 
    @ToTranYear INT, 
    @SalaryList NVARCHAR(4000), 
    @BaseSalary NVARCHAR(50),
    @InsuranceSalary NVARCHAR(50),
    @Salary01 NVARCHAR(50),
    @Salary02 NVARCHAR(50),
    @Salary03 NVARCHAR(50),
    @SalaryCoefficient NVARCHAR(50),
    @TimeCoefficient NVARCHAR(50),
    @Coefficient NVARCHAR(50),
    @gnLang INT = 0 --0: tieng Viet, 1: tieng Anh 
AS

DECLARE 
    @TranMonth INT, 
    @TranYear INT, 
    @sSQL NVARCHAR(max), 
    @SalaryCur CURSOR, 
    @SalID NVARCHAR(50), 
    @SalName NVARCHAR(250), 
    @SalCount INT, 
    @SalIndex INT, 
    @PeriodCur CURSOR, 
    @PeriodID NVARCHAR(50), 
    @PeriodIndex INT

SET @sSQL = '
    SELECT ''BaseSalary'' AS SalID, N'''+ @BaseSalary + '''' 
    --+ CASE WHEN @gnLang = 0 THEN 'Löông cô baûn' ELSE 'Base Salary' END 
    + ' AS SalName , '''+@DivisionID+''' AS DivisionID
    UNION ALL
    SELECT ''InsuranceSalary'' AS SalID, N''' + @InsuranceSalary + '''' 
    --+ CASE WHEN @gnLang = 0 THEN 'Löông BHXH' ELSE 'Insurance Salary' END 
    + ' AS SalName  , '''+@DivisionID+''' AS DivisionID
    UNION ALL
    SELECT ''Salary01'' AS SalID, N'''  + @Salary01 + ''''
    --+ CASE WHEN @gnLang = 0 THEN 'Löông 01' ELSE 'Salary 01' END 
    + ' AS SalName  , '''+@DivisionID+''' AS DivisionID
    UNION ALL
    SELECT ''Salary02'' AS SalID, N''' + @Salary02 + ''''
    --+ CASE WHEN @gnLang = 0 THEN 'Löông 02' ELSE 'Salary 02' END 
    + ' AS SalName  , '''+@DivisionID+''' AS DivisionID
    UNION ALL
    SELECT ''Salary03'' AS SalID, N''' + @Salary03 + ''''
    --+ CASE WHEN @gnLang = 0 THEN 'Löông 03' ELSE 'Salary 03' END 
    + ' AS SalName  , '''+@DivisionID+''' AS DivisionID
    UNION ALL
    SELECT ''SalaryCoefficient'' AS SalID, N''' + @SalaryCoefficient + ''''
    --+ CASE WHEN @gnLang = 0 THEN 'Heä soá löông' ELSE 'Salary Coefficient' END 
    + ' AS SalName  , '''+@DivisionID+''' AS DivisionID
    UNION ALL
    SELECT ''TimeCoefficient'' AS SalID, N''' + @TimeCoefficient + ''''
    --+ CASE WHEN @gnLang = 0 THEN 'Heä soá thaâm nieân' ELSE 'Time Coefficient' END 
    + ' AS SalName  , '''+@DivisionID+''' AS DivisionID
    UNION ALL
    SELECT ''DutyCoefficient'' AS SalID, N''' + @Coefficient + ''''
    --+ CASE WHEN @gnLang = 0 THEN 'Heä soá chöùc vuï' ELSE 'Duty Coefficient' END 
    + ' AS SalName  , '''+@DivisionID+''' AS DivisionID
    UNION ALL
    SELECT CoefficientID AS SalID, Caption AS SalName  , '''+@DivisionID+''' AS DivisionID
    FROM HT0003 WHERE DivisionID = '''+@DivisionID+''' And IsConstant = 0 AND IsUsed = 1
'

--print @sSQL
IF EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Id = Object_ID('HV2490') AND xType = 'V')
    DROP VIEW HV2490

--PRINT '====================' PRINT ('-- Create by HP2490
--    CREATE VIEW HV2490 AS ' + @sSQL)
EXEC ('-- Create by HP2490
    CREATE VIEW HV2490 AS ' + @sSQL)
    
SET @sSQL = '
SELECT SalID, SalName 
FROM HV2490 
WHERE DivisionID = '''+@DivisionID+'''
AND SalID ' + CASE WHEN @SalaryList = '%' THEN 'LIKE ''' + @SalaryList + '''' ELSE 'IN (' + @SalaryList + ')' END

IF EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Id = Object_ID('HV2491') AND xType = 'V')
    DROP VIEW HV2491

--PRINT '====================' PRINT ('CREATE VIEW HV2491 -- Create by HP2490
--    AS ' + @sSQL)
EXEC ('CREATE VIEW HV2491 -- Create by HP2490
    AS ' + @sSQL)
    
SET @sSQL = ''
SELECT @SalCount = COUNT(*) FROM HV2491
SET @SalIndex = 1

SET @SalaryCur = CURSOR STATIC FOR
SELECT SalID, SalName FROM HV2491

OPEN @SalaryCur

FETCH NEXT FROM @SalaryCur INTO @SalID, @SalName
WHILE @@Fetch_Status = 0
    BEGIN
        SET @sSQL = @sSQL + '
            SELECT CASE WHEN TranMonth <10 THEN ''0'' + LTRIM(TranMonth) + ''/'' + LTRIM(TranYear) ELSE LTRIM(TranMonth) + ''/'' + LTRIM(TranYear) END AS PeriodID, 
					TranMonth, TranYear, HT2400.DivisionID, EmployeeID, ''' + @SalID + ''' AS SalID,
					N''' + @SalName + ''' AS SalName, ISNULL(' + @SalID + ', 0) AS Amount ,
					ISNULL(BaseSalary, 0) AS BaseSalary, Isnull(C01,0) as HS01, IsNull(C02,0) as HS02 
            FROM HT2400 
            WHERE DivisionID = '''+@DivisionID+''' And TranMonth + 12*TranYear BETWEEN ' + LTRIM(@FromTranMonth + 12*@FromTranYear) + ' AND ' + LTRIM(@ToTranMonth + 12*@ToTranYear) + char(13) + char(10) 
        
        IF @SalIndex < @SalCount 
        SET @sSQL = @sSQL + ' UNION ALL ' + char(13) + char(10)
        
        SET @SalIndex = @SalIndex + 1
        FETCH NEXT FROM @SalaryCur INTO @SalID, @SalName
    END
PRINT (@sSQL)
IF EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Id = Object_ID('HV2492') AND xType = 'V')
    DROP VIEW HV2492
--print @sSQL

EXEC ('CREATE VIEW HV2492 -- Create by HP2490
    AS ' + @sSQL)

SET @sSQL = 'SELECT HV2492.DivisionID, EmployeeID, SalID, SalName, '
SET @PeriodIndex = 1

SET @PeriodCur = CURSOR STATIC FOR 
SELECT DISTINCT Top 24 PeriodID, TranMonth, TranYear 
FROM HV2492  WHERE DivisionID = @DivisionID
ORDER BY TranYear, TranMonth

OPEN @PeriodCur

FETCH NEXT FROM @PeriodCur INTO @PeriodID, @TranMonth, @TranYear
WHILE @@Fetch_Status = 0
     BEGIN
        SET @sSQL = @sSQL + 'SUM(CASE WHEN PeriodID = ''' + @PeriodID + ''' THEN Amount ELSE 0 END) AS P' + CASE WHEN @PeriodIndex<10 THEN '0' + LTRIM(@PeriodIndex) ELSE LTRIM(@PeriodIndex) END + ', ''' + @PeriodID + ''' AS P' + CASE WHEN @PeriodIndex<10 THEN '0' + LTRIM(@PeriodIndex) ELSE LTRIM(@PeriodIndex) END + 'Name, '
		+ 'SUM(CASE WHEN PeriodID = ''' + @PeriodID + ''' THEN HV2492.BaseSalary ELSE 0 END) as BaseSalary' + CASE WHEN @PeriodIndex<10 THEN '0' + LTRIM(@PeriodIndex) ELSE LTRIM(@PeriodIndex) END +
		 ',SUM(CASE WHEN PeriodID = ''' + @PeriodID + ''' THEN HV2492.HS01 ELSE 0 END)as HS01P' + CASE WHEN @PeriodIndex<10 THEN '0' + LTRIM(@PeriodIndex) ELSE LTRIM(@PeriodIndex) END
		+',SUM(CASE WHEN PeriodID = ''' + @PeriodID + ''' THEN HV2492.HS02 ELSE 0 END)as HS02P' + CASE WHEN @PeriodIndex<10 THEN '0' + LTRIM(@PeriodIndex) ELSE LTRIM(@PeriodIndex) END + ','
        SET @PeriodIndex = @PeriodIndex + 1
        FETCH NEXT FROM @PeriodCur INTO @PeriodID, @TranMonth, @TranYear
    END

WHILE @PeriodIndex < 25
    BEGIN
        SET @sSQL = @sSQL + 'Null AS P' + CASE WHEN @PeriodIndex<10 THEN '0' + LTRIM(@PeriodIndex) ELSE LTRIM(@PeriodIndex) END + ', Null AS P' + CASE WHEN @PeriodIndex<10 THEN '0' + LTRIM(@PeriodIndex) ELSE LTRIM(@PeriodIndex) END + 'Name, '
		+ 'NULL as BaseSalary' + CASE WHEN @PeriodIndex<10 THEN '0' + LTRIM(@PeriodIndex) ELSE LTRIM(@PeriodIndex) END + 
		', NULL as HS01P' + CASE WHEN @PeriodIndex<10 THEN '0' + LTRIM(@PeriodIndex) ELSE LTRIM(@PeriodIndex) END
		+ ',NULL as HS02P' + CASE WHEN @PeriodIndex<10 THEN '0' + LTRIM(@PeriodIndex) ELSE LTRIM(@PeriodIndex) END + ','
        SET @PeriodIndex = @PeriodIndex + 1
    END

SET @sSQL = left(@sSQL, LEN(@sSQL)-1)
SET @sSQL = @sSQL + ' FROM HV2492 WHERE DivisionID = '''+@DivisionID+''' GROUP BY HV2492.DivisionID, EmployeeID, SalID, SalName'

IF EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Id = Object_ID('HV2493') AND xType = 'V')
    DROP VIEW HV2493

--PRINT '====================' PRINT ('CREATE VIEW HV2493 -- Create by HP2490
  --  AS ' + @sSQL)
EXEC ('CREATE VIEW HV2493 -- Create by HP2490
    AS ' + @sSQL)

SET @sSQL = '
    SELECT HV14.DepartmentID, HV14.DepartmentName, HV14.TeamID, HV14.TeamName, HV14.FullName, HV14.DutyID,HV14.WorkDate , HV93.*
    FROM HV2493 HV93 
		INNER JOIN HV1400 HV14 
			ON HV93.EmployeeID = HV14.EmployeeID 
				and HV93.DivisionID = HV14.DivisionID 		
    WHERE HV14.EmployeeStatus = 1 
        AND HV93.DivisionID = ''' + @DivisionID + ''' 
        AND (HV14.DepartmentID BETWEEN ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''') 
        AND ISNULL(HV14.TeamID, '''') LIKE ''' + @TeamID + ''' 
        AND (HV14.EmployeeID BETWEEN ''' + @FromEmployeeID + ''' AND ''' + @ToEmployeeID + ''')'

IF EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Id = Object_ID('HV2494') AND xType = 'V')
    DROP VIEW HV2494

--PRINT '====================' PRINT ('CREATE VIEW HV2494 -- Create by HP2490
  --  AS ' + @sSQL)
EXEC ('CREATE VIEW HV2494 -- Create by HP2490
    AS ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

