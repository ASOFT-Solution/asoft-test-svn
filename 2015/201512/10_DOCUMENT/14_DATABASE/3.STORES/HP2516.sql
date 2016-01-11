IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2516]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2516]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---Created by: Vo Thanh Huong, date: 24/09/2004
---purpose: Xu ly so lieu IN phieu luong cong thang tung nguoi
---Added by: Phuong Loan, them phan tinh thue thu nhap

/********************************************
'* Edited by: [GS] [Việt Khánh] [02/08/2010]
'********************************************/
--Edited by: [GS] [Trọng Khánh] [02/08/2010]
---- Modified on 20/12/2012 by Lê Thị Thu Hiền : Kiểm tra @Condition = ''
---- Modified on 14/08/2013 by Bảo Anh : Sửa lỗi câu lệnh tạo view HV3405 (mantis 0020446)

CREATE PROCEDURE [dbo].[HP2516] 
    @DivisionID NVARCHAR(50), 
    @FromDepartmentID NVARCHAR(50), 
    @ToDepartmentID NVARCHAR(50), 
    @TeamID NVARCHAR(50), 
    @FromEmployeeID NVARCHAR(50), 
    @ToEmployeeID NVARCHAR(50), 
    @FromYear INT, 
    @FromMonth INT, 
    @ToYear INT, 
    @ToMonth INT, 
    @lstPayrollMethodID NVARCHAR(4000),   
    @GrossPay nvarchar(50),
	@Deduction nvarchar(50), 
	@IncomeTax nvarchar(50),
	@gnLang int,
	@Condition nvarchar(1000)
AS 

DECLARE 
    @sSQL NVARCHAR(max), 
    @sSQL2 NVARCHAR(max), 
    @cur CURSOR, 
    @IncomeID NVARCHAR(50), 
    @Signs DECIMAL, 
    @Notes NVARCHAR(250), 
    @Caption NVARCHAR(250), 
    @Orders INT, 
    @lstPayrollMethodID_new NVARCHAR(500), 
    @PayrollMethodID NVARCHAR(50)

SELECT @lstPayrollMethodID_new = CASE WHEN @lstPayrollMethodID = '%' THEN ' LIKE ''' + 
@lstPayrollMethodID + '''' ELSE ' IN (''' + replace(@lstPayrollMethodID, ',',''',''') + ''')' END, @Orders = 1

IF EXISTS (SELECT * FROM sysobjects WHERE name = 'HT5402' AND xtype = 'U') ---Table tam 
    DROP TABLE HT5402

SELECT @sSQL = '', @sSQL2 = '' 
---Neu don vi co tinh thue thu nhap

IF EXISTS (SELECT TOP 1 1 FROM HT2400 WHERE DivisionID = @DivisionID AND TranMonth + 100* TranYear BETWEEN CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)) AND  CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)) AND TaxObjectID is not null)
    BEGIN 
        SET @sSQL = '
        SELECT T01.DivisionID, T01.DepartmentID, ISNULL(T01.TeamID, '''') AS TeamID, T01.EmployeeID, V01.FullName, V01.Birthday, PayrollMethodID, 
            AVG(ISNULL(T02.InsuranceSalary, 0)) AS InsuranceSalary, 
            SUM(ISNULL(Income01, 0)) AS Income01, SUM(ISNULL(Income02, 0)) AS Income02, SUM(ISNULL(Income03, 0)) AS Income03, 
            SUM(ISNULL(Income04, 0)) AS Income04, 
            SUM(ISNULL(Income05, 0)) AS Income05, SUM(ISNULL(Income06, 0)) AS Income06, SUM(ISNULL(Income07, 0)) AS Income07, 
            SUM(ISNULL(Income08, 0)) AS Income08, SUM(ISNULL(Income09, 0)) AS Income09, SUM(ISNULL(Income10, 0)) AS Income10, 
            SUM(ISNULL(Income11, 0)) AS Income11, SUM(ISNULL(Income12, 0)) AS Income12, SUM(ISNULL(Income13, 0)) AS Income13, 
            SUM(ISNULL(Income14, 0)) AS Income14, 
            SUM(ISNULL(Income15, 0)) AS Income15, SUM(ISNULL(Income16, 0)) AS Income16, SUM(ISNULL(Income17, 0)) AS Income17, 
            SUM(ISNULL(Income18, 0)) AS Income18, SUM(ISNULL(Income19, 0)) AS Income19, SUM(ISNULL(Income20, 0)) AS Income20, 
            SUM(ISNULL(SubAmount01, 0)) AS SubAmount01, SUM(ISNULL(SubAmount02, 0)) AS SubAmount02, SUM(ISNULL(SubAmount03, 0)) AS SubAmount03, 
            SUM(ISNULL(SubAmount04, 0)) AS SubAmount04, SUM(ISNULL(SubAmount05, 0)) AS SubAmount05, SUM(ISNULL(SubAmount06, 0)) AS SubAmount06, 
            SUM(ISNULL(SubAmount07, 0)) AS SubAmount07, SUM(ISNULL(SubAmount08, 0)) AS SubAmount08, SUM(ISNULL(SubAmount09, 0)) AS SubAmount09, 
            SUM(ISNULL(SubAmount10, 0)) AS SubAmount10, 
            SUM(ISNULL(SubAmount11, 0)) AS SubAmount11, SUM(ISNULL(SubAmount12, 0)) AS SubAmount12, SUM(ISNULL(SubAmount13, 0)) AS SubAmount13, 
            SUM(ISNULL(SubAmount14, 0)) AS SubAmount14, SUM(ISNULL(SubAmount15, 0)) AS SubAmount15, SUM(ISNULL(SubAmount16, 0)) AS SubAmount16, 
            SUM(ISNULL(SubAmount17, 0)) AS SubAmount17, SUM(ISNULL(SubAmount18, 0)) AS SubAmount18, SUM(ISNULL(SubAmount19, 0)) AS SubAmount19, 
            SUM(ISNULL(SubAmount20, 0)) AS SubAmount20, SUM(ISNULL(TaxAmount, 0)) AS SubAmount00
        FROM HT3400 T01 INNER JOIN HV1400 V01 ON V01.EmployeeID = T01.EmployeeID And V01.DivisionID = T01.DivisionID 
            INNER JOIN HT2400 T02 ON T02.EmployeeID = T01.EmployeeID And T02.DivisionID = T01.DivisionID 
            AND T02.TranMonth = T01.TranMonth AND T02.TranYear = T01.TranYear AND 
            T02.DepartmentID = T01.DepartmentID AND ISNULL(T02.TeamID, '''') = ISNULL(T01.TeamID, '''') 
        WHERE T01.DivisionID = ''' + @DivisionID + ''' AND 
            T01.DepartmentID BETWEEN ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''' 
            '+CASE WHEN ISNULL(@Condition,'') <> '' THEN ' AND ISNULL(T01.DepartmentID,''#'') in ('+@Condition+')' ELSE '' END +' 
            AND ISNULL(T01.TeamID, '''') LIKE ISNULL(''' + @TeamID + ''', '''') AND 
            T01.EmployeeID BETWEEN ''' + @FromEmployeeID + ''' AND ''' + @ToEmployeeID + ''' AND 
            T01.TranMonth + T01.TranYear*100 BETWEEN ' + CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)) + ' AND ' + 
            CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)) + ' AND
            PayrollMethodID ' + @lstPayrollMethodID_new + '
        GROUP BY T01.DivisionID, T01.DepartmentID, ISNULL(T01.TeamID, ''''), T01.EmployeeID, V01.FullName, V01.Birthday, PayrollMethodID'

  
        IF EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV3405')
            DROP VIEW HV3405
            
        EXEC('----tao boi HP2516
            CREATE VIEW HV3405 AS ' + @sSQL)

        SET @sSQL = ''
        SET @cur = CURSOR SCROLL KEYSET FOR
            SELECT T00.PayrollMethodID, T00.IncomeID, RIGHT(T00.IncomeID, 2) AS Orders, 1 AS Signs, 
                --CASE @gnLang WHEN 0 THEN 'Tieàn löông' ELSE 'Gross Pay' END AS Notes, 
                --CASE @gnLang WHEN 0 THEN T01.Caption ELSE T01.CaptionE END AS Caption
                @GrossPay as Notes,
                Case @gnLang When 0 Then T01.Caption Else T01.CaptionE end as Caption
            FROM HT5005 T00 INNER JOIN HT0002 T01 ON T00.IncomeID = T01.IncomeID And T00.DivisionID = T01.DivisionID
            WHERE T00.DivisionID = @DivisionID And T00.PayrollMethodID IN (SELECT DISTINCT PayrollMethodID FROM HV3405) 
            UNION 
            SELECT T00.PayrollMethodID, T00.SubID AS IncomeID, RIGHT(T00.SubID, 2) AS Orders, -1 AS Signs, 
                --CASE @gnLang WHEN 0 THEN 'Caùc khoaûn giaûm tröø' ELSE 'Deduction' END AS Notes,
                @Deduction as Notes, 
                CASE @gnLang WHEN 0 THEN T01.Caption ELSE T01.CaptionE END AS Caption
            FROM HT5006 T00 INNER JOIN HT0005 T01 ON T00.SubID = T01.SubID And T00.DivisionID = T01.DivisionID
            WHERE T00.DivisionID = @DivisionID And T00.PayrollMethodID IN (SELECT DISTINCT PayrollMethodID FROM HV3405) 
            UNION 
            SELECT DISTINCT T00.PayrollMethodID, 'S00' AS IncomeID, 0 AS Orders, -1 AS Signs, 
                --CASE @gnLang WHEN 0 THEN 'Caùc khoaûn giaûm tröø' ELSE 'Deduction' END AS Notes, 
                --CASE @gnLang WHEN 0 THEN 'Thueá TN' ELSE 'Income Tax' END AS Caption
                @Deduction as Notes,@IncomeTax as Caption
            FROM HT5006 T00 
            WHERE T00.DivisionID = @DivisionID And T00.PayrollMethodID IN (SELECT DISTINCT PayrollMethodID FROM HV3405) 

        OPEN @cur
        FETCH NEXT FROM @cur INTO @PayrollMethodID, @IncomeID, @Orders, @Signs, @Notes, @Caption
        WHILE @@FETCH_STATUS = 0 
            BEGIN
                IF @sSQL = ''
                    SET @sSQL = @sSQL + ' SELECT DivisionID, DepartmentID, TeamID, EmployeeID, InsuranceSalary, N''' + @Caption + ''' AS Caption, N''' + 
                        @Notes + ''' AS Notes, ''' + @IncomeID + ''' AS IncomeID, ' + 
                        CAST(@Signs AS NVARCHAR(50)) + ' AS Signs, ' + CASE WHEN @Signs = 1 THEN 'Income' ELSE '-SubAmount' END + 
                        CASE WHEN @Orders < 10 THEN '0' ELSE '' END + CAST(@Orders AS NVARCHAR(50)) + ' AS SalaryAmount, ' + 
                        CAST(@Orders AS NVARCHAR(50)) + ' AS Orders 
                        INTO HT5402
                    FROM HV3405 WHERE PayrollMethodID = ''' + @PayrollMethodID + '''
                    UNION ALL '
                ELSE 
                    IF LEN(@sSQL)>= 3000
                        SET @sSQL2 = @sSQL2 + ' SELECT DivisionID, DepartmentID, TeamID, EmployeeID, InsuranceSalary, N''' + @Caption + ''' AS Caption, N''' + 
                            @Notes + ''' AS Notes, ''' + @IncomeID + ''' AS IncomeID, ' + 
                            CAST(@Signs AS NVARCHAR(50)) + ' AS Signs, ' + CASE WHEN @Signs = 1 THEN 'Income' ELSE '-SubAmount' END + 
                            CASE WHEN @Orders < 10 THEN '0' ELSE '' END + CAST(@Orders AS NVARCHAR(50)) + ' AS SalaryAmount, ' + 
                            CAST(@Orders AS NVARCHAR(50)) + ' AS Orders 
                        FROM HV3405 WHERE PayrollMethodID = ''' + @PayrollMethodID + '''
                        UNION ALL '
                    ELSE 
                        SET @sSQL = @sSQL + ' SELECT DivisionID, DepartmentID, TeamID, EmployeeID, InsuranceSalary, N''' + @Caption + ''' AS Caption, N''' + 
                            @Notes + ''' AS Notes, ''' + @IncomeID + ''' AS IncomeID, ' + 
                            CAST(@Signs AS NVARCHAR(50)) + ' AS Signs, ' + CASE WHEN @Signs = 1 THEN 'Income' ELSE '-SubAmount' END + 
                            CASE WHEN @Orders < 10 THEN '0' ELSE '' END + CAST(@Orders AS NVARCHAR(50)) + ' AS SalaryAmount, ' + 
                            CAST(@Orders AS NVARCHAR(50)) + ' AS Orders 
                            FROM HV3405 WHERE PayrollMethodID = ''' + @PayrollMethodID + '''
                        UNION ALL '

                FETCH NEXT FROM @cur INTO @PayrollMethodID, @IncomeID, @Orders, @Signs, @Notes, @Caption
            END
        Close @cur
        Deallocate @cur

        IF LEN(@sSQL2)>5
            SET @sSQL2 = LEFT(@sSQL2, LEN(@sSQL2) - 9)
        ELSE IF LEN(@sSQL) > 5
            SET @sSQL = LEFT(@sSQL, LEN(@sSQL) - 9)
        ELSE
            SET @sSQL = 'CREATE TABLE HT5402(DivisionID NVARCHAR(50),DepartmentID NVARCHAR(50),TeamID  NVARCHAR(50), EmployeeID NVARCHAR(250),
						InsuranceSalary Decimal(28,8),Caption NVARCHAR(250),Notes NVARCHAR(250),IncomeID NVARCHAR(50),
						Signs int,	SalaryAmount Decimal(28,8),	Orders int )'		
	         
        EXEC(@sSQL + @sSQL2)
        /*IF EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV3407')
        DROP VIEW HV3407
        EXEC('CREATE VIEW HV3407 ---tao boi HP2516
        AS ' + @sSQL) */

        SET @sSQL = '
            SELECT HV3407.DivisionID, HV3407.DepartmentID, HV3407.TeamID, HV3407.EmployeeID, HV1400.FullName, HV3407.Caption, HV3407.Notes, HV3407.IncomeID, 
                HV3407.Signs, HV3407.Orders, SUM(HV3407.SalaryAmount) AS SalaryAmount, 
                AVG(HV3407.InsuranceSalary) AS InSuranceSalary, HV1400.Notes AS Note2, BankAccountNo 
            FROM HT5402 HV3407 LEFT JOIN HV1400 ON HV1400.EmployeeID = HV3407.EmployeeID
            GROUP BY HV3407.DivisionID, HV3407.DepartmentID, HV3407.TeamID, HV3407.EmployeeID, HV1400.FullName, HV3407.Caption, HV3407.Notes, HV3407.IncomeID, HV3407.Signs, 
                HV3407.Orders, HV1400.Notes, BankAccountNo'


        IF EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV3406')
            DROP VIEW HV3406
            
        EXEC('---tao boi HP2516
            CREATE VIEW HV3406 AS ' + @sSQL)
    END

ELSE ---don vi khong tinh thue thu nhap
    BEGIN   
        SET @sSQL = '
            SELECT T01.DivisionID, T01.DepartmentID, ISNULL(T01.TeamID, '''') AS TeamID, T01.EmployeeID, V01.FullName, V01.Birthday, PayrollMethodID, 
                AVG(ISNULL(T02.InsuranceSalary, 0)) AS InsuranceSalary, 
                SUM(ISNULL(Income01, 0)) AS Income01, SUM(ISNULL(Income02, 0)) AS Income02, SUM(ISNULL(Income03, 0)) AS Income03, 
                SUM(ISNULL(Income04, 0)) AS Income04, 
                SUM(ISNULL(Income05, 0)) AS Income05, SUM(ISNULL(Income06, 0)) AS Income06, SUM(ISNULL(Income07, 0)) AS Income07, 
                SUM(ISNULL(Income08, 0)) AS Income08, SUM(ISNULL(Income09, 0)) AS Income09, SUM(ISNULL(Income10, 0)) AS Income10, 
                SUM(ISNULL(Income11, 0)) AS Income11, SUM(ISNULL(Income12, 0)) AS Income12, SUM(ISNULL(Income13, 0)) AS Income13, 
                SUM(ISNULL(Income14, 0)) AS Income14, 
                SUM(ISNULL(Income15, 0)) AS Income15, SUM(ISNULL(Income16, 0)) AS Income16, SUM(ISNULL(Income17, 0)) AS Income17, 
                SUM(ISNULL(Income18, 0)) AS Income18, SUM(ISNULL(Income19, 0)) AS Income19, SUM(ISNULL(Income20, 0)) AS Income20, 
                SUM(ISNULL(SubAmount01, 0)) AS SubAmount01, SUM(ISNULL(SubAmount02, 0)) AS SubAmount02, SUM(ISNULL(SubAmount03, 0)) AS SubAmount03, 
                SUM(ISNULL(SubAmount04, 0)) AS SubAmount04, SUM(ISNULL(SubAmount05, 0)) AS SubAmount05, SUM(ISNULL(SubAmount06, 0)) AS SubAmount06, 
                SUM(ISNULL(SubAmount07, 0)) AS SubAmount07, SUM(ISNULL(SubAmount08, 0)) AS SubAmount08, SUM(ISNULL(SubAmount09, 0)) AS SubAmount09, 
                SUM(ISNULL(SubAmount10, 0)) AS SubAmount10, 
                SUM(ISNULL(SubAmount11, 0)) AS SubAmount11, SUM(ISNULL(SubAmount12, 0)) AS SubAmount12, SUM(ISNULL(SubAmount13, 0)) AS SubAmount13, 
                SUM(ISNULL(SubAmount14, 0)) AS SubAmount14, SUM(ISNULL(SubAmount15, 0)) AS SubAmount15, SUM(ISNULL(SubAmount16, 0)) AS SubAmount16, 
                SUM(ISNULL(SubAmount17, 0)) AS SubAmount17, SUM(ISNULL(SubAmount18, 0)) AS SubAmount18, SUM(ISNULL(SubAmount19, 0)) AS SubAmount19, 
                SUM(ISNULL(SubAmount20, 0)) AS SubAmount20 
            FROM HT3400 T01 INNER JOIN HV1400 V01 ON V01.EmployeeID = T01.EmployeeID And V01.DivisionID = T01.DivisionID 
                INNER JOIN HT2400 T02 ON T02.EmployeeID = T01.EmployeeID And T02.DivisionID = T01.DivisionID
                AND T02.TranMonth = T01.TranMonth AND T02.TranYear = T02.TranYear AND 
                T02.DepartmentID = T01.DepartmentID AND ISNULL(T02.TeamID, '''') = ISNULL(T01.TeamID, '''') 
            WHERE T01.DivisionID = ''' + @DivisionID + ''' AND 
                T01.DepartmentID BETWEEN ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''' 
                '+CASE WHEN ISNULL(@Condition,'') <> '' THEN ' AND ISNULL(T01.DepartmentID,''#'') in ('+@Condition+')' ELSE '' END + '
                AND ISNULL(T01.TeamID, '''') LIKE ISNULL(''' + @TeamID + ''', '''') AND 
                T01.EmployeeID BETWEEN ''' + @FromEmployeeID + ''' AND ''' + @ToEmployeeID + ''' AND 
                T01.TranMonth + T01.TranYear*100 BETWEEN ' + CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)) + ' AND ' + 
                CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)) + ' AND
                PayrollMethodID ' + @lstPayrollMethodID_new + '
            GROUP BY T01.DivisionID, T01.DepartmentID, ISNULL(T01.TeamID, ''''), T01.EmployeeID, V01.FullName, V01.Birthday, PayrollMethodID'


        IF EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV3405')
            DROP VIEW HV3405
            
        EXEC('----tao boi HP2516
            CREATE VIEW HV3405 AS ' + @sSQL)

        SET @sSQL = ''

        SET @cur = CURSOR SCROLL KEYSET FOR
            SELECT T00.PayrollMethodID, T00.IncomeID, RIGHT(T00.IncomeID, 2) AS Orders, 1 AS Signs, 
                --CASE @gnLang WHEN 0 THEN 'Tieàn löông' ELSE 'Gross Pay' END AS Notes, 
                @GrossPay as Notes,
                CASE @gnLang WHEN 0 THEN T01.Caption ELSE T01.CaptionE END AS Caption
            FROM HT5005 T00 INNER JOIN HT0002 T01 ON T00.IncomeID = T01.IncomeID And T00.DivisionID = T01.DivisionID
            WHERE T00.DivisionID = @DivisionID And T00.PayrollMethodID IN (SELECT DISTINCT PayrollMethodID FROM HV3405) 
            UNION 
            SELECT T00.PayrollMethodID, T00.SubID AS IncomeID, RIGHT(T00.SubID, 2) AS Orders, -1 AS Signs, 
                --CASE @gnLang WHEN 0 THEN 'Caùc khoaûn giaûm tröø' ELSE 'Deduction' END AS Notes, 
                @Deduction as Notes,
                CASE @gnLang WHEN 0 THEN T01.Caption ELSE T01.CaptionE END AS Caption
            FROM HT5006 T00 INNER JOIN HT0005 T01 ON T00.SubID = T01.SubID And T00.DivisionID = T01.DivisionID
            WHERE T00.DivisionID = @DivisionID And T00.PayrollMethodID IN (SELECT DISTINCT PayrollMethodID FROM HV3405) 

        OPEN @cur
        FETCH NEXT FROM @cur INTO @PayrollMethodID, @IncomeID, @Orders, @Signs, @Notes, @Caption
        WHILE @@FETCH_STATUS = 0 
            BEGIN
                IF @sSQL = '' 
					
                    SET @sSQL = @sSQL + '
                        SELECT DivisionID, DepartmentID, TeamID, EmployeeID, InsuranceSalary, N''' + @Caption + ''' AS Caption, N''' + 
                        @Notes + ''' AS Notes, ''' + @IncomeID + ''' AS IncomeID, ' + 
                        CAST(@Signs AS NVARCHAR(50)) + ' AS Signs, ' + CASE WHEN @Signs = 1 THEN 'Income' ELSE '-SubAmount' END + 
                        CASE WHEN @Orders < 10 THEN '0' ELSE '' END + CAST(@Orders AS NVARCHAR(50)) + ' AS SalaryAmount, ' + 
                        CAST(@Orders AS NVARCHAR(50)) + ' AS Orders 
                        INTO HT5402
                        FROM HV3405 WHERE PayrollMethodID = ''' + @PayrollMethodID + '''
                        UNION ALL '
                ELSE 
                    IF LEN(@sSQL)>= 3000
                        SET @sSQL2 = @sSQL2 + ' SELECT DivisionID, DepartmentID, TeamID, EmployeeID, InsuranceSalary, N''' + @Caption + ''' AS Caption, N''' + 
                            @Notes + ''' AS Notes, ''' + @IncomeID + ''' AS IncomeID, ' + 
                            CAST(@Signs AS NVARCHAR(50)) + ' AS Signs, ' + CASE WHEN @Signs = 1 THEN 'Income' ELSE '-SubAmount' END + 
                            CASE WHEN @Orders < 10 THEN '0' ELSE '' END + CAST(@Orders AS NVARCHAR(50)) + ' AS SalaryAmount, ' + 
                            CAST(@Orders AS NVARCHAR(50)) + ' AS Orders 
                        FROM HV3405 WHERE PayrollMethodID = ''' + @PayrollMethodID + '''
                        UNION ALL '
                    ELSE
                        SET @sSQL = @sSQL + ' SELECT DivisionID, DepartmentID, TeamID, EmployeeID, InsuranceSalary, N''' + @Caption + ''' AS Caption, N''' + 
                            @Notes + ''' AS Notes, ''' + @IncomeID + ''' AS IncomeID, ' + 
                            CAST(@Signs AS NVARCHAR(50)) + ' AS Signs, ' + CASE WHEN @Signs = 1 THEN 'Income' ELSE '-SubAmount' END + 
                            CASE WHEN @Orders < 10 THEN '0' ELSE '' END + CAST(@Orders AS NVARCHAR(50)) + ' AS SalaryAmount, ' + 
                            CAST(@Orders AS NVARCHAR(50)) + ' AS Orders 
                        FROM HV3405 WHERE PayrollMethodID = ''' + @PayrollMethodID + '''
                        UNION ALL '
                FETCH NEXT FROM @cur INTO @PayrollMethodID, @IncomeID, @Orders, @Signs, @Notes, @Caption
            END
        Close @cur
        Deallocate @cur

        IF LEN(@sSQL2) > 5 
            SET @sSQL2 = LEFT(@sSQL2, LEN(@sSQL2) - 9)
        ELSE IF LEN(@sSQL) > 5
            SET @sSQL = LEFT(@sSQL, LEN(@sSQL) - 9)
        ELSE
			SET @sSQL = 'CREATE TABLE HT5402(DivisionID NVARCHAR(50),DepartmentID NVARCHAR(50),TeamID  NVARCHAR(50), EmployeeID NVARCHAR(250),
					InsuranceSalary Decimal(28,8),Caption NVARCHAR(250),Notes NVARCHAR(250),IncomeID NVARCHAR(50),
					Signs int,	SalaryAmount Decimal(28,8),	Orders int )'

        EXEC(@sSQL + @sSQL2)
        /*
        IF EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV3407')
        DROP VIEW HV3407
        EXEC('CREATE VIEW HV3407 ---tao boi HP2516
        AS ' + @sSQL) */

        SET @sSQL = '
            SELECT HV3407.DivisionID, HV3407.DepartmentID, HV3407.TeamID, HV3407.EmployeeID, HV1400.FullName, HV3407.Caption, HV3407.Notes, HV3407.IncomeID, 
                HV3407.Signs, HV3407.Orders, 
                SUM(HV3407.SalaryAmount) AS SalaryAmount, AVG(HV3407.InsuranceSalary) AS InSuranceSalary, HV1400.Notes AS Note2, 
                BankAccountNo 
            FROM HT5402 HV3407 LEFT JOIN HV1400 ON HV1400.EmployeeID = HV3407.EmployeeID GROUP BY HV3407.DivisionID,HV3407.DepartmentID, HV3407.TeamID, HV3407.EmployeeID, HV1400.FullName, HV3407.Caption, HV3407.Notes, HV3407.IncomeID, HV3407.Signs, 
                HV3407.Orders, HV1400.Notes, BankAccountNo'

        IF EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV3406')
            DROP VIEW HV3406
            
        EXEC('---tao boi HP2516
            CREATE VIEW HV3406 AS ' + @sSQL)

    END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON