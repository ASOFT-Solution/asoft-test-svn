IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0335]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0335]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kết chuyển công phép
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 09/12/2013 by Thanh Sơn
---- 
-- <Example>
---- EXEC HP0335 'SAS', 'ADMIN', 10,2013,'P01'

CREATE PROCEDURE HP0335
( 
		@DivisionID VARCHAR(50),
		@UserID VARCHAR(50),
		@TranMonth INT,
		@TranYear INT,
		@PeriodID VARCHAR(50)
) 
AS 
DECLARE @FromDate DATETIME,
        @ToDate DATETIME,
        @Cur CURSOR,
        @Cur1 CURSOR,
        @EmployeeID VARCHAR(50),
        @DepartmentID VARCHAR(50),
        @TeamID VARCHAR(50),
        @AbsentAmount INT,
        @AbsentTypeID VARCHAR(50)
SELECT @AbsentTypeID = VacationAbsentID FROM HT0007 WHERE DivisionID = @DivisionID
SET @Cur1 = CURSOR SCROLL KEYSET FOR
            SELECT DISTINCT EmployeeID FROM HT0326 WHERE DivisionID = @DivisionID
            AND YEAR(FromDate)*100 + MONTH(FromDate) <= @TranYear*100 + @TranMonth
            AND @TranYear*100 + @TranMonth<= YEAR(ToDate)*100 + MONTH(ToDate)
OPEN @Cur1
FETCH NEXT FROM @Cur1 INTO @EmployeeID
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @AbsentAmount = 0
	SET @Cur = CURSOR SCROLL KEYSET FOR
           SELECT FromDate, ToDate FROM HT0326 WHERE DivisionID = @DivisionID AND EmployeeID = @EmployeeID
           AND YEAR(FromDate)*100 + MONTH(FromDate) <= @TranYear*100 + @TranMonth
           AND @TranYear*100 + @TranMonth<= YEAR(ToDate)*100 + MONTH(ToDate)
    OPEN @Cur
    FETCH NEXT FROM @Cur INTO @FromDate, @ToDate
    WHILE @@FETCH_STATUS = 0
    BEGIN
    	WHILE (@FromDate <= @ToDate)
        BEGIN
        	IF(MONTH(@FromDate) = @TranMonth AND DATEPART(DW,@FromDate) <> 7 AND DATEPART(DW,@FromDate) <> 1
           	AND @FromDate NOT IN (SELECT HoliDay FROM HT1026 WHERE TranYear = @TranYear)) SET @AbsentAmount = @AbsentAmount + 1
           	SET @FromDate = DATEADD(DAY,1,@FromDate)
        END
        FETCH NEXT FROM @Cur INTO @FromDate, @ToDate
    END
    CLOSE @Cur
    IF EXISTS (SELECT TOP 1 1 FROM HT2402 WHERE EmployeeID = @EmployeeID AND AbsentTypeID = @AbsentTypeID
               AND TranMonth = @TranMonth AND TranYear = @TranYear AND PeriodID = @PeriodID)
    BEGIN
    	UPDATE HT2402 SET AbsentAmount = @AbsentAmount
        WHERE EmployeeID = @EmployeeID AND AbsentTypeID = @AbsentTypeID 
        AND TranMonth = @TranMonth AND TranYear = @TranYear AND PeriodID = @PeriodID
    END
    ELSE
    BEGIN
    	IF EXISTS (SELECT EmployeeID FROM HT2400 WHERE DivisionID = @DivisionID AND EmployeeID = @EmployeeID AND TranMonth = @TranMonth AND TranYear = @TranYear)
    	BEGIN
    		SELECT @DepartmentID = DepartmentID, @TeamID = TeamID FROM HT1400
    		WHERE DivisionID = @DivisionID AND EmployeeID = @EmployeeID
    		INSERT HT2402 (DivisionID, EmployeeID, TranMonth, TranYear,
    		       DepartmentID, TeamID, AbsentTypeID, AbsentAmount, PeriodID)
    		VALUES (@DivisionID,@EmployeeID,@TranMonth,@TranYear,@DepartmentID,@TeamID,@AbsentTypeID,@AbsentAmount,@PeriodID)   
    	END    		 		
    END
    
    FETCH NEXT FROM @Cur1 INTO @EmployeeID
END
CLOSE @Cur1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

