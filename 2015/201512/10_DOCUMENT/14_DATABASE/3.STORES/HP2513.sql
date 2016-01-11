/****** Object: StoredProcedure [dbo].[HP2513] Script Date: 07/30/2010 16:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-----Created by Vo Thanh Huong, date: 25/08/2004
-----purpose: Xu lý so lieu IN luong san pham ( Mau 1: chi tiet theo tung san pham)

/********************************************
'* Edited by: [GS] [Việt Khánh] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2513] 
    @DivisionID NVARCHAR(50), 
    @DepartmentID NVARCHAR(50), 
    @TeamID NVARCHAR(50), 
    @EmployeeID NVARCHAR(50), 
    @TranYear INT, 
    @TranMonth INT, 
    @lstPayrollMethodID NVARCHAR(4000)
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @cur CURSOR, 
    @Order TINYINT

SET @lstPayrollMethodID = CASE WHEN @lstPayrollMethodID = '%' THEN ' LIKE ''' + @lstPayrollMethodID + '''' ELSE ' IN (''' + replace(@lstPayrollMethodID, ', ', ''', ''') + ''')' END 

SET @sSQL = '
    SELECT HT1.DivisionID, HT1.EmployeeID, FullName, HT1.DepartmentID, HV.DepartmentName, HV.Orders AS Orders, DutyName, ProductName, HV.Birthday, 
        HT5.Orders AS POrders, HT2.ProductID, SUM(HT2.ProductQuantity) AS ProductQuantity, SUM(HT2.ProductSalary) AS ProductSalary
    FROM HT3402 HT2 INNER JOIN HT3401 HT1 ON HT2.TransactionID = HT1.TransactionID and HT2.DivisionID = HT1.DivisionID 
        INNER JOIN HV1400 HV ON HV.EmployeeID = HT1.EmployeeID and HV.DivisionID = HT1.DivisionID 
        INNER JOIN AT1102 AT ON AT.DivisionID = HT1.DivisionID AND AT.DepartmentID = HT1.DepartmentID 
        INNER JOIN HT1015 HT5 ON HT5.ProductID = HT2.ProductID and HT5.DivisionID = HT2.DivisionID 
    WHERE HT1.DivisionID = ''' + @DivisionID + ''' AND
        HT1.DepartmentID LIKE ''' + @DepartmentID + ''' AND 
        ISNULL(HT1.TeamID, '''') LIKE ''' + @TeamID + ''' AND 
        HT1.EmployeeID LIKE ''' + @EmployeeID + ''' AND 
        HT1.TranMonth = ' + STR(@TranMonth) + ' AND
        HT1.TranYear = ' + STR(@TranYear) + ' AND 
        HT1.PayrollMethodID ' + @lstPayrollMethodID + '
    GROUP BY HT1.DivisionID, HT1.EmployeeID, FullName, HT1.DepartmentID, HV.DepartmentName, HV.Orders, DutyName, ProductName, HV.Birthday, 
        HT5.Orders, HT2.ProductID
' 

IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV3402')
    EXEC('---- tao boi HP2513
        CREATE VIEW HV3402 AS ' + @sSQL)
ELSE
    EXEC('---- tao boi HP2513
        ALTER VIEW HV3402 AS ' + @sSQL)