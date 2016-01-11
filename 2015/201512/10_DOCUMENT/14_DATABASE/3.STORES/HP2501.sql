  
----Created by: Vo Thanh Huong, date: 03/09/2004  
----purpose: Luu cham cong ngay khi them moi, hieu chinh  
  
/********************************************  
'* Edited by: [GS] [Vi?t Khánh] [02/08/2010]  
'********************************************/  
  
ALTER PROCEDURE [dbo].[HP2501]   
    @DivisionID NVARCHAR(50),   
    @DepartmentID NVARCHAR(50),   
    @TeamID NVARCHAR(50),   
    @EmployeeID NVARCHAR(50),   
    @TranMonth INT,   
    @TranYear INT,   
    @AbsentDate DATETIME,   
    @AbsentTypeID NVARCHAR(50),   
    @AbsentAmount DECIMAL(28,8),   
    @CreateUserID NVARCHAR(50)  
AS  
  
IF (NOT EXISTS(SELECT TOP 1 1   
                FROM HT2401   
                WHERE DivisionID = @DivisionID   
                    AND DepartmentID = @DepartmentID   
                    AND ISNULL(TeamID, '') = ISNULL(@TeamID, '')   
                    AND EmployeeID = @EmployeeID   
                    AND TranMonth = @TranMonth   
                    AND TranYear = @TranYear   
                    AND AbsentTypeID = @AbsentTypeID   
                    AND AbsentDate = @AbsentDate) )  
    INSERT HT2401(DivisionID, DepartmentID, TeamID, EmployeeID, TranMonth, TranYear, AbsentDate, AbsentTypeID, AbsentAmount, CreateUserID, CreateDate, LastModifyUserID, LastModifydate )   
    VALUES (@DivisionID, @DepartmentID, @TeamID, @EmployeeID, @TranMonth, @TranYear, @AbsentDate, @AbsentTypeID, @AbsentAmount, @CreateUserID, GETDATE(), @CreateUserID, GETDATE())   