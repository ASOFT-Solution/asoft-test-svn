
/****** Object:  StoredProcedure [dbo].[HP5108]    Script Date: 08/05/2010 10:04:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


--Create by: Dang Le Bao Quynh; Date 20/07/2006
--Purpose: Tao view cho bao cao luong san pham
/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP5108]
       @TranMonth int ,
       @TranYear int ,
       @DivisionID nvarchar(50) ,
       @DepartmentID nvarchar(50) ,
       @TeamID nvarchar(50) ,
       @EmployeeID nvarchar(50) ,
       @lstPayrollMethodID nvarchar(4000)
AS
DECLARE
        @PayrollMethodCon nvarchar(4000) ,
        @sSQL nvarchar(4000)
IF @lstPayrollMethodID = '%'
   BEGIN
         SET @PayrollMethodCon = 'Like ' + '''%'''
   END
ELSE
   BEGIN
         SET @PayrollMethodCon = 'IN (''' + replace(@lstPayrollMethodID , ',' , ''',''') + ''')'
   END

IF EXISTS ( SELECT
                id
            FROM
                sysobjects
            WHERE
                id = object_id('HV5108') AND xtype = 'V' )
   BEGIN
         DROP VIEW HV5108
   END

SET @sSQL = 'CREATE VIEW HV5108 --Tao boi HP5108
AS
SELECT TOP 100 PERCENT HT2.DivisionID, HT2.DepartmentID, AT1.DepartmentName,HT2.TeamID,HT11.TeamName,
HT2.EmployeeID,HV1.FullName,HV1.FirstName,HT2.GeneralCo,HT2.GeneralAbsentAmount,HT2.ProductSalary 
FROM HT3404 HT2 
INNER JOIN AT1102 AT1 ON HT2.DepartmentID=AT1.DepartmentID AND HT2.DivisionID=AT1.DivisionID
INNER JOIN HT1101 HT11 ON HT2.TeamID=HT11.TeamID AND HT2.DivisionID=HT11.DivisionID
INNER JOIN HV1400 HV1 ON HT2.EmployeeID=HV1.EmployeeID AND HT2.DivisionID=HV1.DivisionID
WHERE TranMonth=' + ltrim(@TranMonth) + ' and TranYear=' + ltrim(@TranYear) + ' and HT2.DivisionID=''' + @DivisionID + ''' and HT2.DepartmentID like ''' + @DepartmentID + ''' and HT2.TeamID like ''' + @TeamID + ''' and HT2.EmployeeID Like ''' + @EmployeeID + ''' and HT2.PayrollMethodID ' + @PayrollMethodCon + ' ORDER BY AT1.DepartmentID,HT11.TeamID,HV1.FirstName'
--PRINT @sSQL
EXEC ( @sSQL )