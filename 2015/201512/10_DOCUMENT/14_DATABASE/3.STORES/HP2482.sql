IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2482]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2482]
GO
--Create By : Dang Le Bao Quynh; Date: 25/09/2006  
--Purpose: Kiem tra du lieu quan he truoc khi xoa trong bang cham cong thang  
  
/********************************************  
'* Edited by: [GS] [Việt Khánh] [02/08/2010]  
'********************************************/  

CREATE PROCEDURE [dbo].[HP2482]  
    @DivisionID NVARCHAR(50),   
    @DepartmentID NVARCHAR(50),
    @ToDepartmentID nvarchar(50),     
    @TeamID NVARCHAR(50),   
    @EmployeeID NVARCHAR(50),   
    @TranMonth INT,   
    @TranYear INT,   
    @PeriodID NVARCHAR(50)  
AS   
  
DECLARE @Status INT  
  
IF EXISTS   
(  
    SELECT PeriodID FROM HT2402   
    WHERE 
    (PeriodID IN 
		(
			SELECT PeriodID FROM HT5002 WHERE GeneralAbsentID IN 
			(
				SELECT GeneralAbsentID FROM HT5005 WHERE PayrollMethodID IN 
				(
					SELECT PayrollMethodID FROM HT3400 WHERE TranMonth = 3 AND Tranyear = 2006
				)
			)    
			OR GeneralAbsentID IN 
			(
				SELECT GeneralAbsentID FROM HT5006 WHERE PayrollMethodID IN 
				(
					SELECT PayrollMethodID FROM HT3400 WHERE TranMonth = 3 AND Tranyear = 2006
				)
			)
		)
    )
    AND PeriodID = @PeriodID  
    AND TranMonth = @TranMonth  
    AND TranYear = @TranYear  
    AND DivisionID = @DivisionID  
    AND DepartmentID like @DepartmentID  
    AND ISNULL(TeamID, '%') Like @TeamID  
    AND EmployeeID Like @EmployeeID  
)  
    SET @Status = 1  
ELSE  
    SET @Status = 0  
  
SELECT @Status AS Status