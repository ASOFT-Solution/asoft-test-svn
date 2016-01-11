IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2470]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2470]
GO
/****** Object:  StoredProcedure [dbo].[HP2470]    Script Date: 10/31/2011 15:58:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--------- Created date : August 16 2005
--------- Purpose: Kiem tra luu dieu chuyen tam thoi

/********************************************
'* Edited by: [GS] [Việt Khánh] [02/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2470] 
    @DivisionID NVARCHAR(50), 
    @FromDepartmentID NVARCHAR(50), 
    @FromTeamID NVARCHAR(50), 
    @EmployeeID NVARCHAR(50), 
    @TaxObjectID NVARCHAR(50), 
    @ToDepartmentID NVARCHAR(50), 
    @ToTeamID NVARCHAR(50), 
    @CBaseSalary DECIMAL, 
    @CInsuranceSalary DECIMAL, 
    @CSalary01 DECIMAL, 
    @CSalary02 DECIMAL, 
    @CSalary03 DECIMAL, 
    @SalaryCo DECIMAL, 
    @TimeCo DECIMAL, 
    @DutyCo DECIMAL, 
    @CC01 DECIMAL, 
    @CC02 DECIMAL, 
    @CC03 DECIMAL, 
    @CC04 DECIMAL, 
    @CC05 DECIMAL, 
    @CC06 DECIMAL, 
    @CC07 DECIMAL, 
    @CC08 DECIMAL, 
    @CC09 DECIMAL, 
    @CC10 DECIMAL, 
    @CC11 DECIMAL, 
    @CC12 DECIMAL, 
    @CC13 DECIMAL, 
    @TranMonth INT, 
    @TranYear INT, 
    @CreateUserID NVARCHAR(50), 
    @FromDateTranfer DATETIME, 
    @ToDateTranfer DATETIME
AS

DECLARE 
    @Status TINYINT, 
    @VietMess NVARCHAR(4000), 
    @EngMess NVARCHAR(4000), 
    @BeginDate DATETIME, 
    @EndDate DATETIME

SELECT @Status = 0, @BeginDate = BeginDate, @EndDate = EndDate
FROM HT9999 
WHERE TranMonth = @TranMonth 
    AND TranYear = @TranYear 
    AND DivisionID = @DivisionID

IF EXISTS (SELECT EmployeeID FROM HT2400 
            WHERE EmployeeID = @EmployeeID 
                AND DivisionID = @DivisionID
                AND DepartmentID = @ToDepartmentID 
                AND ISNULL(TeamID, '') = ISNULL(@ToTeamID, '')
                AND TranMonth = @TranMonth 
                AND TranYear = @TranYear
                AND (ISNULL(FromDateTranfer, @BeginDate) BETWEEN @FromDateTranfer AND @ToDateTranfer
                    OR ISNULL(ToDateTranfer, @EndDate) BETWEEN @FromDateTranfer AND @ToDateTranfer
                    OR (@FromDateTranfer < = ISNULL(FromDateTranfer, @BeginDate) 
                        AND @ToDateTranfer > = ISNULL(ToDateTranfer, @EndDate))))
    BEGIN
        SET @Status = 1
        SET @VietMess = "HFML000355"--'Kh«ng thÓ ®iÒu chuyÓn nh©n viªn ' + @EmployeeID + ' trong th¸ng ' + CAST(@TranMonth AS NVARCHAR(2)) + ' n¨m ' + CAST(@TranYear AS NVARCHAR(4)) + ' sang phßng ban tæ nhãm míi v× ®· ®iÒu chuyÓn råi'
        SET @EngMess = "HFML000355"--'Unsuccessfully temporary transfering employee with ID of ' + @EmployeeID + ' to this department AND this team ''s salary file of this month because this employee has been transferred'
        GOTO Return_Values
    END 

Return_Values:
SELECT @Status AS Status, @VietMess AS VieMessage, @EngMess AS EngMessage

--AND DepartmentID = @FromDepartmentID 
--AND ISNULL(TeamID, '') = ISNULL(@FromTeamID, '')
---AND ((DepartmentID = @FromDepartmentID AND ISNULL(TeamID, '') = ISNULL(@FromTeamID, '') ) OR
-- (DepartmentID = @ToDepartmentID AND ISNULL(TeamID, '') = ISNULL(@ToTeamID, '') ))