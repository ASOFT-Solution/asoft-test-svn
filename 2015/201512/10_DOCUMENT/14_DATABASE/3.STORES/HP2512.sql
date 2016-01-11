IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2512]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2512]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-----Created by Vo Thanh Huong, date: 25/08/2004
-----purpose: Xu lý so lieu IN luong cong thang 
-----Edited by: Pham Thi Phuong Loan : Thue thu nhap
-----Edit by: Dang Le Bao Quynh, Date 18/08/2006
-----Purpose: Xu ly tinh trang tran chuoi.
-----Edit by: Dang Le Bao Quynh; Date: 19/06/2009
-----Purpose: Bo sung truong DivisionID vao view HV2409
---Edit by Hoang Trong Khanh, date 14/12/2011 -- Add @GrossPay,@Deduction,@IncomeTax : Sử dụng đa ngôn ngữ
---Edit by Trần Quốc Tuấn, date 06/02/2015 -- Add ISNULL cho các trường IGAbsentAmount01-30

/********************************************
'* Edited by: [GS] [Việt Khánh] [02/08/2010]
'********************************************/
---- Modified on 20/12/2012 by Lê Thị Thu Hiền : Bổ sung kiểm tra @Condition 
---- Modified on 16/08/2013 by Lê Thị Thu Hiền : Chỉnh sửa thiếu dấu nháy 0020735
---- Modified on 11/11/2013 by Bảo Anh : Bổ sung lương tháng 13 (customize Unicare) và 10 khoản thu nhập cho chấm công theo công trình
---- Modified on 19/11/2013 by Bảo Anh : Bổ sung số ngày công lớn nhất và số công trình của từng nhân viên (customize Unicare)
---- Modified on 01/12/2013 by Bảo Anh : Bổ sung số TK ngân hàng
---- Modified on 03/12/2013 by Thanh Sơn: Cập nhật in lỗi font
---- Modified on 23/12/2013 by Bảo Anh : Bổ sung ngày bắt đầu tham gia công trình và ngày của công trình được chuyển sau cùng (Unicare)
---- Modified on 25/12/2013 by Thanh Sơn: Bổ sung lấy thêm một số trường (Customize CSG = 19) (EXEC HP5410CSG)
---- Modified on 30/12/2013 by Bảo Anh : Sửa tên field BeginDate thành BeginJoinDate, Where thêm tháng năm khi lấy BeginJoinDate (Unicare)
---- Modified on 02/01/2014 by Bảo Anh : Where thêm tháng, năm khi lấy CountOfProjects, MaxAbsentAmounts (Unicare)
---- Modified on 07/01/2014 by Bảo Anh : Sửa cách tính lương tháng 13 (Unicare)
---- Modified on 08/01/2014 by Bảo Anh : Bổ sung WorkDate
---- Modified on 09/01/2014 by Bảo Anh : Cải thiện tốc độ (dùng HT5411 thay HV2408, bỏ join một số bảng khi tạo view HV240901)
---- Modified on 13/01/2014 by Bảo Anh : Bổ sung CountOfPayrollMethodID
---- Modified on 15/01/2014 by Bảo Anh : Where thêm PayrollMethodID khi tính CountOfProjects
---- Modified on 06/03/2014 by Bảo Anh : Bổ sung DutyID vào HV240901
---- Modified on 11/03/2014 by Bảo Anh : Bổ sung các trường STT cong trình của 1 nhân viên, STT từng công trình
---- Modified on 10/04/2014 by Bảo Anh : Bổ sung mã cong trình tính trừ các khoản BHXH - InsuranceProjectID (Unicare)
---- Modified on 12/05/2015 by Mai Duyen : Fix loi field BeginDate tra ra nhieu dong   (Van khanh)

CREATE PROCEDURE [dbo].[HP2512] 
	@DivisionID nvarchar(20),      
    @FromDepartmentID nvarchar(50),  
    @ToDepartmentID nvarchar(50),  
    @TeamID nvarchar(50),  
    @FromEmployeeID nvarchar(50),   
    @ToEmployeeID nvarchar(50),   
    @FromYear int,  
    @FromMonth int,      
    @ToYear int,  
    @ToMonth int,      
    @lstPayrollMethodID nvarchar(4000),  
    @GrossPay nvarchar(50),
	@Deduction nvarchar(50), 
	@IncomeTax nvarchar(50),
    @gnLang int,  
    @Condition nvarchar(1000)
AS

DECLARE 
    @sSQL NVARCHAR(MAX), 
    @sSQL2 NVARCHAR(max), 
    @sSQL3 NVARCHAR(MAX), 
    @cur CURSOR, 
    @FieldID NVARCHAR(50), 
    @Caption NVARCHAR(100), 
    @Signs DECIMAL, 
    @Notes NVARCHAR(50), 
    @Orders TINYINT, 
    @IncomeID NVARCHAR(50), 
    @PayrollMethodID NVARCHAR(50),
    @CustomerName INT,
    @sSQL1 NVARCHAR(2000),
    @sFrom NVARCHAR(2000),
    @sGroup NVARCHAR(2000)
    
--Tao bang tam de kiem tra day co phai la khach hang Unicare khong (CustomerName = 21)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

SET @sSQL1 = ''
SET @sFrom = ''
SET @sGroup = ''
/*IF @CustomerName = 19  
BEGIN 
	EXEC HP5410CSG @DivisionID,@FromMonth, @FromYear,@ToMonth,@ToYear
	SET @sSQL1 = ',CSG.SumTon, CSG.SalaryTon,CSG.SumCont, CSG.SalaryCont,CSG.SumKien, CSG.SalaryKien,CSG.SumXe, CSG.SalaryXe, CSG.JobWage'
	SET @sFrom = 'LEFT JOIN HT5401CSG CSG ON CSG.EmployeeID = HV2410.EmployeeID'
	SET @sGroup= ',CSG.SumTon, CSG.SalaryTon,CSG.SumCont, CSG.SalaryCont,CSG.SumKien, CSG.SalaryKien,CSG.SumXe, CSG.SalaryXe, CSG.JobWage'
END*/

IF EXISTS (SELECT * FROM sysobjects WHERE name = 'HT5401' AND xtype = 'U') ---Table tam 
    DROP TABLE HT5401
    
CREATE TABLE HT5401(
	DivisionID NVARCHAR(50), 
    EmployeeID NVARCHAR(50), 
    DepartmentID NVARCHAR(50), 
    DepartmentName NVARCHAR(100), 
    InsuranceSalary DECIMAL, 
    Orders NVARCHAR(50), 
    TeamID NVARCHAR(50), 
    Notes NVARCHAR(100), 
    IncomeID NVARCHAR(50), 
    Signs numeric, 
    Amount DECIMAL, 
    Caption NVARCHAR(100), 
    FOrders INT
)

--- tạo bảng HT5411 thay cho view HV2408 để cải thiện tốc độ
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'HT5411' AND xtype = 'U') ---Table tam 
    DROP TABLE HT5411
    
CREATE TABLE HT5411(
	DivisionID nvarchar(50),
	EmployeeID nvarchar(50),
	FullName nvarchar(250),
	DepartmentID nvarchar(50),
	DepartmentName nvarchar(250),
	Birthday datetime,
	PayrollMethodID nvarchar(50),
	Orders int,
	DutyName nvarchar(250),
	TeamID nvarchar(50),
	InsuranceSalary decimal(28,8),
	Income01 decimal(28,8),
	Income02 decimal(28,8),
	Income03 decimal(28,8),
	Income04 decimal(28,8),
	Income05 decimal(28,8),
	Income06 decimal(28,8),
	Income07 decimal(28,8),
	Income08 decimal(28,8),
	Income09 decimal(28,8),
	Income10 decimal(28,8),
	Income11 decimal(28,8),
	Income12 decimal(28,8),
	Income13 decimal(28,8),
	Income14 decimal(28,8),
	Income15 decimal(28,8),
	Income16 decimal(28,8),
	Income17 decimal(28,8),
	Income18 decimal(28,8),
	Income19 decimal(28,8),
	Income20 decimal(28,8),
	Income21 decimal(28,8),
	Income22 decimal(28,8),
	Income23 decimal(28,8),
	Income24 decimal(28,8),
	Income25 decimal(28,8),
	Income26 decimal(28,8),
	Income27 decimal(28,8),
	Income28 decimal(28,8),
	Income29 decimal(28,8),
	Income30 decimal(28,8),
	SubAmount01 decimal(28,8),
	SubAmount02 decimal(28,8),
	SubAmount03 decimal(28,8),
	SubAmount04 decimal(28,8),
	SubAmount05 decimal(28,8),
	SubAmount06 decimal(28,8),
	SubAmount07 decimal(28,8),
	SubAmount08 decimal(28,8),
	SubAmount09 decimal(28,8),
	SubAmount10 decimal(28,8),
	SubAmount11 decimal(28,8),
	SubAmount12 decimal(28,8),
	SubAmount13 decimal(28,8),
	SubAmount14 decimal(28,8),
	SubAmount15 decimal(28,8),
	SubAmount16 decimal(28,8),
	SubAmount17 decimal(28,8),
	SubAmount18 decimal(28,8),
	SubAmount19 decimal(28,8),
	SubAmount20 decimal(28,8),
	SubAmount00 decimal(28,8)
)

SET @lstPayrollMethodID = 
CASE 
    WHEN @lstPayrollMethodID = '%' THEN ' LIKE ''' + 
        @lstPayrollMethodID + '''' 
    ELSE ' IN (''' + replace(@lstPayrollMethodID, ', ', ''', ''') + ''')' 
END 
    
SELECT @sSQL = '', @sSQL2 = '', @Orders = 1

---Neu don vi co tinh thue thu nhap

IF EXISTS (SELECT TOP 1 1 FROM HT2400 WHERE DivisionID = @DivisionID And TranMonth + 100* TranYear BETWEEN CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)) AND CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)) AND ISNULL(TaxObjectID, '') <> '')
    BEGIN 
        SET @sSQL = 'INSERT INTO HT5411
            SELECT T00.DivisionID, T00.EmployeeID, FullName, T00.DepartmentID, V00.DepartmentName, V00.Birthday, PayrollMethodID, 
                V00.Orders AS Orders, ISNULL(DutyName, '''') AS DutyName, ISNULL(T00.TeamID, '''') AS TeamID, 
                ISNULL(T02.InsuranceSalary, 0) AS InsuranceSalary, 
                ISNULL(Income01, 0) AS Income01, ISNULL(Income02, 0) AS Income02, ISNULL(Income03, 0) AS Income03, 
                ISNULL(Income04, 0) AS Income04, 
                ISNULL(Income05, 0) AS Income05, ISNULL(Income06, 0) AS Income06, ISNULL(Income07, 0) AS Income07, 
                ISNULL(Income08, 0) AS Income08, ISNULL(Income09, 0) AS Income09, ISNULL(Income10, 0) AS Income10, 
                ISNULL(Income11, 0) AS Income11, ISNULL(Income12, 0) AS Income12, ISNULL(Income13, 0) AS Income13, 
                ISNULL(Income14, 0) AS Income14, 
                ISNULL(Income15, 0) AS Income15, ISNULL(Income16, 0) AS Income16, ISNULL(Income17, 0) AS Income17, 
                ISNULL(Income18, 0) AS Income18, ISNULL(Income19, 0) AS Income19, ISNULL(Income20, 0) AS Income20,
                ISNULL(Income21, 0) AS Income21, ISNULL(Income22, 0) AS Income22, ISNULL(Income23, 0) AS Income23,
                ISNULL(Income24, 0) AS Income24, ISNULL(Income25, 0) AS Income25, ISNULL(Income26, 0) AS Income26,
                ISNULL(Income27, 0) AS Income27, ISNULL(Income28, 0) AS Income28, ISNULL(Income29, 0) AS Income29, ISNULL(Income30, 0) AS Income30,
                ISNULL(SubAmount01, 0) AS SubAmount01, ISNULL(SubAmount02, 0) AS SubAmount02, 
                ISNULL(SubAmount03, 0) AS SubAmount03, ISNULL(SubAmount04, 0) AS SubAmount04, 
                ISNULL(SubAmount05, 0) AS SubAmount05, ISNULL(SubAmount06, 0) AS SubAmount06, 
                ISNULL(SubAmount07, 0) AS SubAmount07, ISNULL(SubAmount08, 0) AS SubAmount08, 
                ISNULL(SubAmount09, 0) AS SubAmount09, ISNULL(SubAmount10, 0) AS SubAmount10, 
                ISNULL(SubAmount11, 0) AS SubAmount11, ISNULL(SubAmount12, 0) AS SubAmount12, 
                ISNULL(SubAmount13, 0) AS SubAmount13, ISNULL(SubAmount14, 0) AS SubAmount14, 
                ISNULL(SubAmount15, 0) AS SubAmount15, ISNULL(SubAmount16, 0) AS SubAmount16, 
                ISNULL(SubAmount17, 0) AS SubAmount17, ISNULL(SubAmount18, 0) AS SubAmount18, 
                ISNULL(SubAmount19, 0) AS SubAmount19, ISNULL(SubAmount20, 0) AS SubAmount20, 
                ISNULL(TaxAmount, 0) AS SubAmount00
            FROM HT3400 T00 INNER JOIN HV1400 V00 ON V00.EmployeeID = T00.EmployeeID and V00.DivisionID = T00.DivisionID 
                INNER JOIN AT1102 T01 ON T01.DivisionID = T00.DivisionID AND T01.DepartmentID = T00.DepartmentID 
                INNER JOIN HT2400 T02 ON T02.DivisionID = T00.DivisionID And T02.EmployeeID = T00.EmployeeID AND T02.TranMonth = T00.TranMonth AND
                T02.TranYear = T00.TranYear AND T02.DepartmentID = T00.DepartmentID AND 
                ISNULL(T02.TeamID, '''') = ISNULL(T00.TeamID, '''')
            WHERE T00.DivisionID = ''' + @DivisionID + ''' AND
                T00.DepartmentID BETWEEN ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''' 
                '+CASE WHEN ISNULL(@Condition,'') <> '' THEN 'AND isnull(T00.DepartmentID,''#'') in ('+@Condition+')' ELSE '' END +' 
                AND ISNULL(T00.TeamID, '''') LIKE ISNULL(''' + @TeamID + ''', '''') AND
                T00.EmployeeID BETWEEN ''' + @FromEmployeeID + ''' AND ''' + @ToEmployeeID + ''' AND
                T00.TranMonth + T00.TranYear*100 BETWEEN ' + CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)) + ' AND ' + 
                CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)) + ' AND
                PayrollMethodID ' + @lstPayrollMethodID
        EXEC(@sSQL)     
		/*
        IF EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV2408')
            DROP VIEW HV2408
            
        EXEC ('---- tao boi HP2512
            CREATE VIEW HV2408 AS ' + @sSQL)
		*/
        SET @sSQL = ''
        
        SET @cur = CURSOR SCROLL KEYSET FOR
            SELECT T00.PayrollMethodID, T00.IncomeID, RIGHT(T00.IncomeID, 2) AS Orders, 1 AS Signs, 
               -- CASE @gnLang WHEN 0 THEN 'Tieàn löông' ELSE 'Gross Pay' END AS Notes, 
               @GrossPay AS Notes, 
                CASE @gnLang WHEN 0 THEN T01.Caption ELSE T01.CaptionE END AS Caption
            FROM HT5005 T00 INNER JOIN HT0002 T01 ON T00.IncomeID = T01.IncomeID and T00.DivisionID = T01.DivisionID
            WHERE T00.DivisionID = @DivisionID And T00.PayrollMethodID IN (SELECT DISTINCT PayrollMethodID FROM HT5411 Where DivisionID = @DivisionID )
            UNION 
            SELECT T00.PayrollMethodID, T00.SubID AS IncomeID, RIGHT(T00.SubID, 2) AS Orders, -1 AS Signs, 
                --CASE @gnLang WHEN 0 THEN 'Caùc khoaûn giaûm tröø' ELSE 'Deduction' END AS Notes, 
                @Deduction AS Notes,
                CASE @gnLang WHEN 0 THEN T01.Caption ELSE T01.CaptionE END AS Caption
            FROM HT5006 T00 INNER JOIN HT0005 T01 ON T00.SubID = T01.SubID and T00.DivisionID = T01.DivisionID
            WHERE T00.DivisionID = @DivisionID And T00.PayrollMethodID IN (SELECT DISTINCT PayrollMethodID FROM HT5411  Where DivisionID = @DivisionID) 
            UNION 
            SELECT DISTINCT T00.PayrollMethodID, 'S00' AS IncomeID, 0 AS Orders, -1 AS Signs, 
                --CASE @gnLang WHEN 0 THEN 'Caùc khoaûn giaûm tröø' ELSE 'Deduction' END AS Notes, 
                --CASE @gnLang WHEN 0 THEN 'Thueá TN' ELSE 'Income Tax' END AS Caption
                @Deduction AS Notes,@IncomeTax AS Caption
            FROM HT5006 T00 
            WHERE T00.DivisionID = @DivisionID And T00.PayrollMethodID IN (SELECT DISTINCT PayrollMethodID FROM HT5411 Where DivisionID = @DivisionID) 

        OPEN @cur
        FETCH NEXT FROM @cur INTO @PayrollMethodID, @IncomeID, @Orders, @Signs, @Notes, @Caption

        WHILE @@FETCH_STATUS = 0 
            BEGIN
                SET @sSQL = '
                    INSERT INTO HT5401 
                    SELECT DivisionID, EmployeeID, DepartmentID, HV2408.DepartmentName, InsuranceSalary, 
                        Orders, TeamID, N''' + @Notes + ''' AS Notes, ''' + @IncomeID + ''' AS IncomeID, ' + 
                        CAST(@Signs AS NVARCHAR(50)) + ' AS Signs, ' + CASE WHEN @Signs = 1 THEN 'Income' ELSE '-SubAmount' END + 
                        CASE WHEN @Orders < 10 THEN '0' ELSE '' END + CAST(@Orders AS NVARCHAR(50)) + ' AS Amount, N''' + @Caption + ''' AS Caption, '
                        + CAST(@Orders AS NVARCHAR(50)) + ' AS FOrders
                    FROM HT5411 HV2408 WHERE HV2408.DivisionID = '''+@DivisionID+''' And PayrollMethodID = ''' + @PayrollMethodID + '''
                '
--PRINT(@sSQL)
                EXEC (@sSQL)

                FETCH NEXT FROM @cur INTO @PayrollMethodID, @IncomeID, @Orders, @Signs, @Notes, @Caption
            END

        SET @sSQL = '
            SELECT HV1400.DivisionID, HV2410.EmployeeID, HV1400.FullName, HV2410.DepartmentID, HV2410.DepartmentName, 
                HV1400.Birthday, avg( HV2410.InsuranceSalary) AS InsuranceSalary, 
                HV2410.Orders, HV1400.DutyName, HV2410.TeamID, HV2410.Notes, HV2410.IncomeID, 
                HV2410.Signs, HV2410.Caption, HV2410.FOrders, SUM(HV2410.Amount) AS Amount, 
                HV1400.Notes AS Note2, BankAccountNo '+@sSQL1+'
            FROM HT5401 HV2410 
            INNER JOIN HV1400 ON HV1400.EmployeeID = HV2410.EmployeeID and HV1400.DivisionID = HV2410.DivisionID
            '+@sFrom+'
            Where HV2410.DivisionID = '''+@DivisionID+'''
            GROUP BY HV1400.DivisionID, HV2410.EmployeeID, HV1400.FullName, HV2410.DepartmentID, HV2410.DepartmentName, HV1400.Birthday, 
                HV2410.Orders, HV1400.DutyName, HV2410.TeamID, HV2410.Notes, HV2410.IncomeID, HV2410.Signs, 
                HV2410.Caption, HV2410.FOrders, HV1400.Notes, BankAccountNo '+@sGroup+' '

--PRINT(@sSQL)
        IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV2409')
            EXEC('---- tao boi HP2512
                CREATE VIEW HV2409 AS ' + @sSQL)
        ELSE 
            EXEC('---- tao boi HP2512
                ALTER VIEW HV2409 AS ' + @sSQL)
    END
ELSE -----Neu don vi khong tinh thue thu nhap
    BEGIN 
        SET @sSQL = 'INSERT INTO HT5411
            SELECT T00.DivisionID, T00.EmployeeID, FullName, T00.DepartmentID, V00.DepartmentName, V00.Birthday, PayrollMethodID, 
                V00.Orders AS Orders, ISNULL(DutyName, '''') AS DutyName, ISNULL(T00.TeamID, '''') AS TeamID, ISNULL(T02.InsuranceSalary, 0) AS InsuranceSalary, 
                ISNULL(Income01, 0) AS Income01, ISNULL(Income02, 0) AS Income02, ISNULL(Income03, 0) AS Income03, 
                ISNULL(Income04, 0) AS Income04, 
                ISNULL(Income05, 0) AS Income05, ISNULL(Income06, 0) AS Income06, ISNULL(Income07, 0) AS Income07, 
                ISNULL(Income08, 0) AS Income08, ISNULL(Income09, 0) AS Income09, ISNULL(Income10, 0) AS Income10, 
                ISNULL(Income11, 0) AS Income11, ISNULL(Income12, 0) AS Income12, ISNULL(Income13, 0) AS Income13, 
                ISNULL(Income14, 0) AS Income14, 
                ISNULL(Income15, 0) AS Income15, ISNULL(Income16, 0) AS Income16, ISNULL(Income17, 0) AS Income17, 
                ISNULL(Income18, 0) AS Income18, ISNULL(Income19, 0) AS Income19, ISNULL(Income20, 0) AS Income20,
                ISNULL(Income21, 0) AS Income21, ISNULL(Income22, 0) AS Income22, ISNULL(Income23, 0) AS Income23,
                ISNULL(Income24, 0) AS Income24, ISNULL(Income25, 0) AS Income25, ISNULL(Income26, 0) AS Income26,
                ISNULL(Income27, 0) AS Income27, ISNULL(Income28, 0) AS Income28, ISNULL(Income29, 0) AS Income29, ISNULL(Income30, 0) AS Income30,
                ISNULL(SubAmount01, 0) AS SubAmount01, ISNULL(SubAmount02, 0) AS SubAmount02, ISNULL(SubAmount03, 0) AS SubAmount03, 
                ISNULL(SubAmount04, 0) AS SubAmount04, ISNULL(SubAmount05, 0) AS SubAmount05, ISNULL(SubAmount06, 0) AS SubAmount06, 
                ISNULL(SubAmount07, 0) AS SubAmount07, ISNULL(SubAmount08, 0) AS SubAmount08, ISNULL(SubAmount09, 0) AS SubAmount09, 
                ISNULL(SubAmount10, 0) AS SubAmount10, 
                ISNULL(SubAmount11, 0) AS SubAmount11, ISNULL(SubAmount12, 0) AS SubAmount12, ISNULL(SubAmount13, 0) AS SubAmount13, 
                ISNULL(SubAmount14, 0) AS SubAmount14, ISNULL(SubAmount15, 0) AS SubAmount15, ISNULL(SubAmount16, 0) AS SubAmount16, 
                ISNULL(SubAmount17, 0) AS SubAmount17, ISNULL(SubAmount18, 0) AS SubAmount18, ISNULL(SubAmount19, 0) AS SubAmount19, 
                ISNULL(SubAmount20, 0) AS SubAmount20, ISNULL(TaxAmount, 0) AS SubAmount00
            FROM HT3400 T00 INNER JOIN HV1400 V00 ON V00.EmployeeID = T00.EmployeeID and V00.DivisionID = T00.DivisionID 
                INNER JOIN AT1102 T01 ON T01.DivisionID = T00.DivisionID AND T01.DepartmentID = T00.DepartmentID 
                INNER JOIN HT2400 T02 ON T02.DivisionID = T00.DivisionID  and T02.EmployeeID = T00.EmployeeID AND T02.TranMonth = T00.TranMonth AND
                T02.TranYear = T00.TranYear AND T02.DepartmentID = T00.DepartmentID AND 
                ISNULL(T02.TeamID, '''') = ISNULL(T00.TeamID, '''')
            WHERE T00.DivisionID = ''' + @DivisionID + ''' AND
                T00.DepartmentID BETWEEN ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''' 
                '+CASE WHEN ISNULL(@Condition,'') <> '' THEN ' AND isnull(T00.DepartmentID,''#'') in ('+@Condition+')' ELSE '' END +' 
                AND ISNULL(T00.TeamID, '''') LIKE ISNULL(''' + @TeamID + ''', '''') AND
                T00.EmployeeID BETWEEN ''' + @FromEmployeeID + ''' AND ''' + @ToEmployeeID + ''' AND
                T00.TranMonth + T00.TranYear*100 BETWEEN ' + CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)) + ' AND ' + 
                CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)) + ' AND
                PayrollMethodID ' + @lstPayrollMethodID
        EXEC(@sSQL)
		/*
        IF EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV2408') 
        DROP VIEW HV2408
        EXEC('---- tao boi HP2512
            CREATE VIEW HV2408 AS ' + @sSQL)
        */  

        SET @sSQL = ''
        SET @cur = CURSOR SCROLL KEYSET FOR
            SELECT T00.PayrollMethodID, T00.IncomeID, RIGHT(T00.IncomeID, 2) AS Orders, 1 AS Signs, 
                --CASE @gnLang WHEN 0 THEN 'Tieàn löông' ELSE 'Gross Pay' END AS Notes, 
                 @GrossPay AS Notes,
               CASE @gnLang WHEN 0 THEN T01.Caption ELSE T01.CaptionE END AS Caption               
            FROM HT5005 T00 INNER JOIN HT0002 T01 ON T00.IncomeID = T01.IncomeID and T00.DivisionID = T01.DivisionID
            WHERE T00.DivisionID = @DivisionID And T00.PayrollMethodID IN (SELECT DISTINCT PayrollMethodID FROM HT5411 Where DivisionID = @DivisionID) 
            UNION 
            SELECT T00.PayrollMethodID, T00.SubID AS IncomeID, RIGHT(T00.SubID, 2) AS Orders, -1 AS Signs, 
                --CASE @gnLang WHEN 0 THEN 'Caùc khoaûn giaûm tröø' ELSE 'Deduction' END AS Notes, 
                @Deduction AS Notes,
                CASE @gnLang WHEN 0 THEN T01.Caption ELSE T01.CaptionE END AS Caption
            FROM HT5006 T00 INNER JOIN HT0005 T01 ON T00.SubID = T01.SubID and T00.DivisionID = T01.DivisionID
            WHERE T00.DivisionID = @DivisionID And T00.PayrollMethodID IN (SELECT DISTINCT PayrollMethodID FROM HT5411 Where DivisionID = @DivisionID) 

        OPEN @cur FETCH NEXT FROM @cur INTO @PayrollMethodID, @IncomeID, @Orders, @Signs, @Notes, @Caption

        WHILE @@FETCH_STATUS = 0 
            BEGIN
                SET @sSQL = N'
                    INSERT INTO HT5401 SELECT DivisionID,EmployeeID, DepartmentID, HV2408.DepartmentName, InsuranceSalary, 
                        Orders, TeamID, N''' + @Notes + ''' AS Notes, ''' + @IncomeID + ''' AS IncomeID, ' + 
                        CAST(@Signs AS NVARCHAR(50)) + ' AS Signs, ' + CASE WHEN @Signs = 1 THEN 'Income' ELSE '-SubAmount' END + 
                        CASE WHEN @Orders < 10 THEN '0' ELSE '' END + CAST(@Orders AS NVARCHAR(50)) + ' AS Amount, N''' + @Caption + ''' AS Caption, '
                        + CAST(@Orders AS NVARCHAR(50)) + ' AS FOrders
                    FROM HT5411 HV2408 WHERE HV2408.DivisionID = '''+@DivisionID+''' And PayrollMethodID = ''' + @PayrollMethodID + ''''

              EXEC (@sSQL)

                FETCH NEXT FROM @cur INTO @PayrollMethodID, @IncomeID, @Orders, @Signs, @Notes, @Caption
            END

        SET @sSQL = '
            SELECT HV1400.DivisionID, HV2410.EmployeeID, HV1400.FullName, HV2410.DepartmentID, HV2410.DepartmentName, 
                HV1400.Birthday, avg( HV2410.InsuranceSalary) AS InsuranceSalary, 
                HV2410.Orders, HV1400.DutyName, HV2410.TeamID, HV2410.Notes, HV2410.IncomeID, 
                HV2410.Signs, HV2410.Caption, HV2410.FOrders, SUM(HV2410.Amount) AS Amount, 
                HV1400.Notes AS Note2, BankAccountNo '+@sSQL1+'
            FROM HT5401 HV2410 INNER JOIN HV1400 ON HV1400.EmployeeID = HV2410.EmployeeID and HV1400.DivisionID = HV2410.DivisionID
            '+@sFrom+'
            Where HV2410.DivisionID = '''+@DivisionID+'''
            GROUP BY HV1400.DivisionID, HV2410.EmployeeID, HV1400.FullName, HV2410.DepartmentID, HV2410.DepartmentName, HV1400.Birthday, 
                HV2410.Orders, HV1400.DutyName, HV2410.TeamID, HV2410.Notes, HV2410.IncomeID, HV2410.Signs, 
                HV2410.Caption, HV2410.FOrders, HV1400.Notes, BankAccountNo '+@sGroup+ ''

        -------------------------------------------------------------------------------------------------------------------------------
        --PRINT(@sSQL)
        IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV2409')
            EXEC('---- tao boi HP2512
                CREATE VIEW HV2409 AS ' + @sSQL)
        ELSE 
            EXEC('---- tao boi HP2512
                ALTER VIEW HV2409 AS ' + @sSQL)
    END
    
-------------------------------------
-- Tao view in lương theo công trình.
-------------------------------------
SET @sSQL = '
            SELECT T00.DivisionID, T00.EmployeeID, FullName, T00.DepartmentID, V00.DepartmentName, V00.Birthday, PayrollMethodID, 
                V00.Orders AS Orders, V00.DutyID, ISNULL(DutyName, '''') AS DutyName, ISNULL(T00.TeamID, '''') AS TeamID, ---T02.BaseSalary,
                (select BaseSalary From HT2400 Where DivisionID = T00.DivisionID And EmployeeID = T00.EmployeeID AND TranMonth = T00.TranMonth
                AND TranYear = T00.TranYear AND DepartmentID = T00.DepartmentID AND ISNULL(TeamID, '''') = ISNULL(T00.TeamID, '''')) as BaseSalary,
                ISNULL(T00.Income01, 0) AS Income01, ISNULL(T00.Income02, 0) AS Income02, ISNULL(T00.Income03, 0) AS Income03, ISNULL(T00.Income04, 0) AS Income04, 
                ISNULL(T00.Income05, 0) AS Income05, ISNULL(T00.Income06, 0) AS Income06, ISNULL(T00.Income07, 0) AS Income07, ISNULL(T00.Income08, 0) AS Income08, 
                ISNULL(T00.Income09, 0) AS Income09, ISNULL(T00.Income10, 0) AS Income10, 
                ISNULL(T00.Income11, 0) AS Income11, ISNULL(T00.Income12, 0) AS Income12, ISNULL(T00.Income13, 0) AS Income13, ISNULL(T00.Income14, 0) AS Income14, 
                ISNULL(T00.Income15, 0) AS Income15, ISNULL(T00.Income16, 0) AS Income16, ISNULL(T00.Income17, 0) AS Income17, ISNULL(T00.Income18, 0) AS Income18, 
                ISNULL(T00.Income19, 0) AS Income19, ISNULL(T00.Income20, 0) AS Income20,
                ISNULL(T00.Income21, 0) AS Income21, ISNULL(T00.Income22, 0) AS Income22, ISNULL(T00.Income23, 0) AS Income23,
                ISNULL(T00.Income24, 0) AS Income24, ISNULL(T00.Income25, 0) AS Income25, ISNULL(T00.Income26, 0) AS Income26,
                ISNULL(T00.Income27, 0) AS Income27, ISNULL(T00.Income28, 0) AS Income28, ISNULL(T00.Income29, 0) AS Income29, ISNULL(T00.Income30, 0) AS Income30,
                ISNULL(T00.SubAmount01, 0) AS SubAmount01, ISNULL(T00.SubAmount02, 0) AS SubAmount02, 
                ISNULL(T00.SubAmount03, 0) AS SubAmount03, ISNULL(T00.SubAmount04, 0) AS SubAmount04, 
                ISNULL(T00.SubAmount05, 0) AS SubAmount05, ISNULL(T00.SubAmount06, 0) AS SubAmount06, 
                ISNULL(T00.SubAmount07, 0) AS SubAmount07, ISNULL(T00.SubAmount08, 0) AS SubAmount08, 
                ISNULL(T00.SubAmount09, 0) AS SubAmount09, ISNULL(T00.SubAmount10, 0) AS SubAmount10, 
                ISNULL(T00.SubAmount11, 0) AS SubAmount11, ISNULL(T00.SubAmount12, 0) AS SubAmount12, 
                ISNULL(T00.SubAmount13, 0) AS SubAmount13, ISNULL(T00.SubAmount14, 0) AS SubAmount14, 
                ISNULL(T00.SubAmount15, 0) AS SubAmount15, ISNULL(T00.SubAmount16, 0) AS SubAmount16, 
                ISNULL(T00.SubAmount17, 0) AS SubAmount17, ISNULL(T00.SubAmount18, 0) AS SubAmount18, 
                ISNULL(T00.SubAmount19, 0) AS SubAmount19, ISNULL(T00.SubAmount20, 0) AS SubAmount20, 
                ISNULL(H34.Income01, 0) AS CT_Income01, ISNULL(H34.Income02, 0) AS CT_Income02, ISNULL(H34.Income03, 0) AS CT_Income03, ISNULL(H34.Income04, 0) AS CT_Income04, 
                ISNULL(H34.Income05, 0) AS CT_Income05, ISNULL(H34.Income06, 0) AS CT_Income06, ISNULL(H34.Income07, 0) AS CT_Income07, ISNULL(H34.Income08, 0) AS CT_Income08, 
                ISNULL(H34.Income09, 0) AS CT_Income09, ISNULL(H34.Income10, 0) AS CT_Income10, 
                ISNULL(H34.Income11, 0) AS CT_Income11, ISNULL(H34.Income12, 0) AS CT_Income12, ISNULL(H34.Income13, 0) AS CT_Income13, ISNULL(H34.Income14, 0) AS CT_Income14, 
                ISNULL(H34.Income15, 0) AS CT_Income15, ISNULL(H34.Income16, 0) AS CT_Income16, ISNULL(H34.Income17, 0) AS CT_Income17, ISNULL(H34.Income18, 0) AS CT_Income18, 
                ISNULL(H34.Income19, 0) AS CT_Income19, ISNULL(H34.Income20, 0) AS CT_Income20, ISNULL(H34.Income21, 0) AS CT_Income21, ISNULL(H34.Income22, 0) AS CT_Income22,
                ISNULL(H34.Income23, 0) AS CT_Income23, ISNULL(H34.Income24, 0) AS CT_Income24, ISNULL(H34.Income25, 0) AS CT_Income25, ISNULL(H34.Income26, 0) AS CT_Income26,
                ISNULL(H34.Income27, 0) AS CT_Income27, ISNULL(H34.Income28, 0) AS CT_Income28, ISNULL(H34.Income29, 0) AS CT_Income29, ISNULL(H34.Income30, 0) AS CT_Income30,                
                H34.ProjectID, HT1120.ProjectName, HT1120.BeginDate, HT1120.EndDate, T00.TranMonth, T00.TranYear, V00.IdentifyCardNo, V00.FullAddress, V00.BankAccountNo, V00.WorkDate,
                '
           SET @sSQL2 = '     
				ISNULL(H34.IGAbsentAmount01, 0) IGAbsentAmount01, ISNULL(H34.IGAbsentAmount02, 0) IGAbsentAmount02, ISNULL(H34.IGAbsentAmount03, 0) IGAbsentAmount03, ISNULL(H34.IGAbsentAmount04, 0) IGAbsentAmount04, ISNULL(H34.IGAbsentAmount05, 0) IGAbsentAmount05, 
				ISNULL(H34.IGAbsentAmount06, 0) IGAbsentAmount06, ISNULL(H34.IGAbsentAmount07, 0) IGAbsentAmount07, ISNULL(H34.IGAbsentAmount08, 0) IGAbsentAmount08, ISNULL(H34.IGAbsentAmount09, 0) IGAbsentAmount09, ISNULL(H34.IGAbsentAmount10, 0) IGAbsentAmount10, 
				ISNULL(H34.IGAbsentAmount11, 0) IGAbsentAmount11, ISNULL(H34.IGAbsentAmount12, 0) IGAbsentAmount12, ISNULL(H34.IGAbsentAmount13, 0) IGAbsentAmount13, ISNULL(H34.IGAbsentAmount14, 0) IGAbsentAmount14, ISNULL(H34.IGAbsentAmount15, 0) IGAbsentAmount15, 
				ISNULL(H34.IGAbsentAmount16, 0) IGAbsentAmount16, ISNULL(H34.IGAbsentAmount17, 0) IGAbsentAmount17, ISNULL(H34.IGAbsentAmount18, 0) IGAbsentAmount18, ISNULL(H34.IGAbsentAmount19, 0) IGAbsentAmount19, ISNULL(H34.IGAbsentAmount20, 0) IGAbsentAmount20,
				ISNULL(H34.IGAbsentAmount21, 0) IGAbsentAmount21, ISNULL(H34.IGAbsentAmount22, 0) IGAbsentAmount22, ISNULL(H34.IGAbsentAmount23, 0) IGAbsentAmount23, ISNULL(H34.IGAbsentAmount24, 0) IGAbsentAmount24, ISNULL(H34.IGAbsentAmount25, 0) IGAbsentAmount25,
				ISNULL(H34.IGAbsentAmount26, 0) IGAbsentAmount26, ISNULL(H34.IGAbsentAmount27, 0) IGAbsentAmount27, ISNULL(H34.IGAbsentAmount28, 0) IGAbsentAmount28, ISNULL(H34.IGAbsentAmount29, 0) IGAbsentAmount29, ISNULL(H34.IGAbsentAmount30, 0) IGAbsentAmount30,
				ISNULL(H34.SubAmount01, 0) AS CT_SubAmount01, ISNULL(H34.SubAmount02, 0) AS CT_SubAmount02, 																																						    
                ISNULL(H34.SubAmount03, 0) AS CT_SubAmount03, ISNULL(H34.SubAmount04, 0) AS CT_SubAmount04, 
                ISNULL(H34.SubAmount05, 0) AS CT_SubAmount05, ISNULL(H34.SubAmount06, 0) AS CT_SubAmount06, 
                ISNULL(H34.SubAmount07, 0) AS CT_SubAmount07, ISNULL(H34.SubAmount08, 0) AS CT_SubAmount08, 
                ISNULL(H34.SubAmount09, 0) AS CT_SubAmount09, ISNULL(H34.SubAmount10, 0) AS CT_SubAmount10, 
                ISNULL(H34.SubAmount11, 0) AS CT_SubAmount11, ISNULL(H34.SubAmount12, 0) AS CT_SubAmount12, 
                ISNULL(H34.SubAmount13, 0) AS CT_SubAmount13, ISNULL(H34.SubAmount14, 0) AS CT_SubAmount14, 
                ISNULL(H34.SubAmount15, 0) AS CT_SubAmount15, ISNULL(H34.SubAmount16, 0) AS CT_SubAmount16, 
                ISNULL(H34.SubAmount17, 0) AS CT_SubAmount17, ISNULL(H34.SubAmount18, 0) AS CT_SubAmount18, 
                ISNULL(H34.SubAmount19, 0) AS CT_SubAmount19, ISNULL(H34.SubAmount20, 0) AS CT_SubAmount20'
                
			IF @CustomerName in (21,39)--- Bổ sung lương tháng 13 và số ngày công lớn nhất của từng nhân viên (Unicare)
			BEGIN
				IF @ToMonth = 12
				BEGIN
					Declare @SQL_TAM varchar(max)
					--- Tạo bảng tạm lưu phụ cấp cũ, phụ cấp mới, ngày quy định, hệ số thâm niên của các nhân viên theo từng tháng
					IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT34001]') AND type in (N'U'))
					BEGIN
						CREATE TABLE HT34001 (EmployeeID nvarchar(50),
											TranMonth int,
											TranYear int,
											OldExAmount decimal(28,8),
											NewExAmount decimal(28,8),										
											TimeAmount decimal(28,8))
											
						IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[HT3400]') AND name = N'HT3400_Index1')
							DROP INDEX [HT3400_Index1] ON [dbo].[HT3400] WITH ( ONLINE = OFF )			
						
						CREATE NONCLUSTERED INDEX [HT34001_Index1] ON [dbo].[HT34001] 
						(
							[EmployeeID] ASC,
							[TranYear] ASC							
						)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
					END
					
					DELETE HT34001
					SET @SQL_TAM = 'INSERT INTO HT34001 (EmployeeID,TranMonth,TranYear,OldExAmount,NewExAmount,TimeAmount)
					SELECT T00.EmployeeID,T00.TranMonth,T00.TranYear,
							case when Isnull(T00.Income22,0) = 0 then 0 else (Isnull(T00.Income03,0) * Isnull(T00.IGAbsentAmount17,0) * (Select Count(ProjectID) From HT340001 Where DivisionID = ''' + @DivisionID + '''
																						And TransactionID in (Select TransactionID From HT3400 Where DivisionID = ''' + @DivisionID + '''
																						and TranMonth = T00.TranMonth and TranYear = T00.TranYear And EmployeeID = T00.EmployeeID))
																			/ Isnull(T00.Income22,0)) end,
							case when Isnull(T00.Income22,0) = 0 then 0 else (Isnull(T00.Income20,0) * Isnull(T00.IGAbsentAmount18,0) * (Select Count(ProjectID) From HT340001 Where DivisionID = ''' + @DivisionID + '''
																						And TransactionID in (Select TransactionID From HT3400 Where DivisionID = ''' + @DivisionID + '''
																						and TranMonth = T00.TranMonth and TranYear = T00.TranYear And EmployeeID = T00.EmployeeID))
																			/ Isnull(T00.Income22,0)) end,
							(case when (Select Count(ProjectID) From HT340001 Where DivisionID = ''' + @DivisionID + '''
																						And TransactionID in (Select TransactionID From HT3400 Where DivisionID = ''' + @DivisionID + '''
																						and TranMonth = T00.TranMonth and TranYear = T00.TranYear And EmployeeID = T00.EmployeeID)) > 1
							then T00.Income17/(Select Count(ProjectID) From HT340001 Where DivisionID = ''' + @DivisionID + '''
																						And TransactionID in (Select TransactionID From HT3400 Where DivisionID = ''' + @DivisionID + '''
																						and TranMonth = T00.TranMonth and TranYear = T00.TranYear And EmployeeID = T00.EmployeeID))
							else 0 end)
							
					FROM HT3400 T00
					WHERE T00.DivisionID = ''' + @DivisionID + ''' AND T00.DepartmentID BETWEEN ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''' 
					'+CASE WHEN ISNULL(@Condition,'') <> '' THEN ' AND isnull(T00.DepartmentID,''#'') in ('+@Condition+')' ELSE '' END +' 
					AND ISNULL(T00.TeamID, '''') LIKE ISNULL(''' + @TeamID + ''', '''') AND
					T00.EmployeeID BETWEEN ''' + @FromEmployeeID + ''' AND ''' + @ToEmployeeID + ''' AND
					T00.TranYear = ' + str(@ToYear) + ' AND PayrollMethodID ' + @lstPayrollMethodID   
	               
					EXEC(@SQL_TAM)
				
					SET @sSQL2 = @sSQL2 + ',
						(((Select Sum(OldExAmount) From HT34001 Where EmployeeID = T00.EmployeeID And TranYear = ' + str(@ToYear) + ')
						+ (Select Sum(NewExAmount) From HT34001 Where EmployeeID = T00.EmployeeID And TranYear = ' + str(@ToYear) + ')
						- (Select Sum(TimeAmount) From HT34001 Where EmployeeID = T00.EmployeeID And TranYear = ' + str(@ToYear) + ')
						+
						(Select sum(BaseSalary) From HT2400 Where DivisionID = ''' + @DivisionID + ''' And EmployeeID = T00.EmployeeID
							And TranYear = ' + str(@ToYear) + '))/12) as ThirteenSalary'
				END
				ELSE
				BEGIN
					SET @sSQL2 = @sSQL2 + ',0 as ThirteenSalary'
				END
				
				SET @sSQL2 = @sSQL2 + ',
				(Select Max(BeginDate) From HT2421 Where DivisionID = ''' + @DivisionID + ''' And TranMonth = T00.TranMonth And TranYear = T00.TranYear And ProjectID = H34.ProjectID And EmployeeID = T00.EmployeeID
				) as BeginJoinDate,
				
				(Select max(Isnull(IGAbsentAmount02,0) + Isnull(IGAbsentAmount04,0) + Isnull(IGAbsentAmount19,0) + Isnull(IGAbsentAmount14,0) + Isnull(IGAbsentAmount15,0))
					From HT340001 Where DivisionID = ''' + @DivisionID + '''
					And TransactionID in (Select TransactionID From HT3400 Where DivisionID = ''' + @DivisionID + '''
											and TranMonth = T00.TranMonth and TranYear = T00.TranYear and PayrollMethodID = T00.PayrollMethodID And EmployeeID = T00.EmployeeID)
				) as MaxAbsentAmounts,
				
				(Select max(BeginDate) From HT2421 Where DivisionID = ''' + @DivisionID + ''' And TranMonth = T00.TranMonth
					And TranYear = T00.TranYear And EmployeeID = T00.EmployeeID
				) as MaxBeginDate,
				
				(Select Count(ProjectID) From HT340001 Where DivisionID = ''' + @DivisionID + '''
					And TransactionID in (Select TransactionID From HT3400 Where DivisionID = ''' + @DivisionID + '''
											and TranMonth = T00.TranMonth and TranYear = T00.TranYear and PayrollMethodID = T00.PayrollMethodID And EmployeeID = T00.EmployeeID)
				) as CountOfProjects,
				
				(Select count(*) From (Select distinct PayrollMethodID From HT3400 Where DivisionID = ''' + @DivisionID + '''
										And DepartmentID BETWEEN ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + '''
										And ISNULL(T00.TeamID, '''') LIKE ISNULL(''' + @TeamID + ''', '''') AND
										EmployeeID BETWEEN ''' + @FromEmployeeID + ''' AND ''' + @ToEmployeeID + ''' AND
										(TranMonth + T00.TranYear*100 BETWEEN ' + CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)) + ' AND ' + 
										CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)) + ')) A) as CountOfPayrollMethodID,
				
				ROW_NUMBER() over (partition by T00.EmployeeID order by (select 1)) as ProjectOrders,
				DENSE_RANK() over (order by H34.ProjectID) as ProjectNumber,
				
				(Select top 1 ProjectID From HT340001
				Where TransactionID in (Select TransactionID From HT3400 Where DivisionID = ''' + @DivisionID + '''
										and TranMonth = T00.TranMonth and TranYear = T00.TranYear and PayrollMethodID = T00.PayrollMethodID And EmployeeID = T00.EmployeeID)
				Order by Isnull(IGAbsentAmount02,0) + Isnull(IGAbsentAmount04,0) + Isnull(IGAbsentAmount19,0) + Isnull(IGAbsentAmount14,0) + Isnull(IGAbsentAmount15,0) DESC, ProjectID)
				as InsuranceProjectID'
            END
            
			SET @sSQL3 = '    	
            FROM HT3400 T00 INNER JOIN HV1400 V00 ON V00.EmployeeID = T00.EmployeeID and V00.DivisionID = T00.DivisionID 
				LEFT JOIN HT340001 H34 ON T00.DivisionID = H34.DivisionID AND T00.TransactionID = H34.TransactionID
				LEFT JOIN HT1120 ON H34.DivisionID = HT1120.DivisionID AND H34.ProjectID = HT1120.ProjectID
            --- INNER JOIN AT1102 T01 ON T01.DivisionID = T00.DivisionID AND T01.DepartmentID = T00.DepartmentID 
            --- INNER JOIN HT2400 T02 ON T02.DivisionID = T00.DivisionID And T02.EmployeeID = T00.EmployeeID AND T02.TranMonth = T00.TranMonth AND
            --- T02.TranYear = T00.TranYear AND T02.DepartmentID = T00.DepartmentID AND ISNULL(T02.TeamID, '''') = ISNULL(T00.TeamID, '''')
            
            WHERE T00.DivisionID = ''' + @DivisionID + ''' AND
                T00.DepartmentID BETWEEN ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''' 
                '+CASE WHEN ISNULL(@Condition,'') <> '' THEN ' AND isnull(T00.DepartmentID,''#'') in ('+@Condition+')' ELSE '' END +' 
			AND ISNULL(T00.TeamID, '''') LIKE ISNULL(''' + @TeamID + ''', '''') AND
                T00.EmployeeID BETWEEN ''' + @FromEmployeeID + ''' AND ''' + @ToEmployeeID + ''' AND
                T00.TranMonth + T00.TranYear*100 BETWEEN ' + CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)) + ' AND ' + 
                CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)) + ' AND H34.ProjectID Is Not Null AND
                PayrollMethodID ' + @lstPayrollMethodID                
		
        IF EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV240901')
            EXEC ('---- tao boi HP2512
            ALTER VIEW HV240901 AS ' + @sSQL + @sSQL2 + @sSQL3)
        ELSE    
			EXEC ('---- tao boi HP2512
            CREATE VIEW HV240901 AS ' + @sSQL + @sSQL2 + @sSQL3)

--DROP TABLE HT5401
--DROP TABLE HT5411

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON