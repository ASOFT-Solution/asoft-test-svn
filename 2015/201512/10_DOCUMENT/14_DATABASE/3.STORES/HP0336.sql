IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0336]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0336]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Kết chuyển công bộ phận trực tiếp
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 10/12/2013 by Thanh Sơn
---- 
-- <Example>
	---- EXEC HP0336 'SAS', 'ADMIN', 10,2013,'P01'

CREATE PROCEDURE HP0336
( 
		@DivisionID VARCHAR(50),
		@UserID VARCHAR(50),
		@TranMonth INT,
		@TranYear INT,
		@PeriodID VARCHAR(50)		
) 
AS 
DECLARE @EmployeeID VARCHAR(50),
        @DepartmentID VARCHAR(50),
        @TeamID VARCHAR(50),
        @AbsentTypeID VARCHAR(50),
        @AbsentAmount INT,
	    @Cur CURSOR
SET @AbsentAmount = 0
SELECT @AbsentTypeID = ProductAbsentID FROM HT0007 WHERE DivisionID =  @DivisionID
SET @Cur = CURSOR SCROLL KEYSET FOR
           SELECT A.EmployeeID, COUNT(A.EmployeeID)
           FROM( 
           	SELECT DISTINCT P50.VoucherDate, P50.ShiftID,P52.EmployeeID
           	FROM PST2051 P51
           	LEFT JOIN PST2050 P50 ON P50.DivisionID = P51.DivisionID AND P50.VoucherID = P51.VoucherID
           	LEFT JOIN PST2052 P52 ON P52.DivisionID = P51.DivisionID AND P52.RefAPK = P51.APK
           	WHERE P51.DivisionID = @DivisionID
           	AND P50.TranMonth = @TranMonth
           	AND P50.TranYear = @TranYear)A
           GROUP BY A.EmployeeID
 
OPEN @Cur
FETCH NEXT FROM @Cur INTO @EmployeeID,@AbsentAmount
WHILE @@FETCH_STATUS = 0
BEGIN
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
    FETCH NEXT FROM @Cur INTO @EmployeeID,@AbsentAmount 
END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

