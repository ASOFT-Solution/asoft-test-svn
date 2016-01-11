/****** Object: StoredProcedure [dbo].[HP2515] Script Date: 07/30/2010 16:08:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 24/09/2004
---purpose: Xu ly so lieu IN bao phieu luong san pham tung nguoi

/********************************************
'* Edited by: [GS] [Việt Khánh] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2515] 
    @DivisionID NVARCHAR(50), 
    @DepartmentID NVARCHAR(50), 
    @TeamID NVARCHAR(50), 
    @EmployeeID NVARCHAR(50), 
    @TranYear INT, 
    @TranMonth INT, 
    @lstPayrollMethodID NVARCHAR(4000)
AS 

DECLARE @sSQL NVARCHAR(4000) 

SET @lstPayrollMethodID = CASE WHEN @lstPayrollMethodID = '%' THEN ' LIKE ''' + 
@lstPayrollMethodID + '''' ELSE ' IN (''' + replace(@lstPayrollMethodID, ', ', ''', ''') + ''')' END 

SET @sSQL = '
    SELECT T01.DivisionID , T01.DepartmentID, A01.DepartmentName, T00.EmployeeID, V01.FullName, V01.Birthday, 
        T00.ProductID, ProductName, T02.Orders, SUM(T00.ProductSalary) AS ProductSalary 
    FROM HT3402 T00 INNER JOIN HT3401 T01 ON T00.TransactionID = T01.TransactionID and T00.DivisionID = T01.DivisionID
        INNER JOIN HV1400 V01 ON V01.EmployeeID = T01.EmployeeID And V01.DivisionID = T01.DivisionID 
        INNER JOIN AT1102 A01 ON A01.DivisionID = T01.DivisionID AND A01.DepartmentID = T01.DepartmentID 
        INNER JOIN HT1015 T02 ON T00.ProductID = T02.ProductID and T00.DivisionID = T02.DivisionID 
    WHERE T01.DivisionID = ''' + @DivisionID + ''' AND 
        T01.DepartmentID LIKE ''' + @DepartmentID + ''' AND 
        ISNULL(T01.TeamID, '''') LIKE ISNULL(''' + @TeamID + ''', '''') AND 
        T01.EmployeeID LIKE ''' + @EmployeeID + ''' AND
        T01.TranMonth = ' + CAST(@TranMonth AS NVARCHAR(2)) + ' AND
        T01.TranYear = ' + CAST(@TranYear AS NVARCHAR(4)) + ' AND 
        PayrollMethodID ' + @lstPayrollMethodID + '
    GROUP BY T01.DivisionID , T01.DepartmentID, A01.DepartmentName, T00.EmployeeID, V01.FullName, V01.Birthday, 
        T00.ProductID, ProductName, T02.Orders
'

IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV3404')
    EXEC('----tao boi HP2515
        CREATE VIEW HV3404 AS ' + @sSQL)
ELSE
    EXEC('----tao boi HP2515
        ALTER VIEW HV3404 AS ' + @sSQL)