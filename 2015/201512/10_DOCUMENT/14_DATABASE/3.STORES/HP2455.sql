IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2455]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2455]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Tính sản phẩm theo phương pháp phân bổ theo từng nhân viên
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 23/08/2013 by Lê Thị Thu Hiền
---- 
---- Modified on 12/12/2013 by Le Thi Thu Hien : Lay Max(UnitPrice) lam nhieu san pham trong 1 ca
-- <Example>
---- DELETE HT2415
---- EXEC HP2455 'CTY', 9, 2013, 'PP2013.SP3', 'TH.13'
---- DELETE FROM HT2415
---- SELECT * FROM HT2415 order by EmployeeID, AbsentDate, ShiftID

CREATE PROCEDURE HP2455
( 
		@DivisionID nvarchar(50), 
		@TranMonth int, 
		@TranYear int, 
		@PayrollMethodID nvarchar(50), 
		@GeneralAbsentID as nvarchar(50)  
)  
As
DECLARE @BeginDate datetime, 
		@EndDate datetime,
		@TimeConvert decimal(28,8), 
		@AbsentDecimals tinyint

DELETE	HT2415
WHERE	DivisionID = @DivisionID 
		AND TranMonth = @TranMonth 
		AND TranYear = @TranYear 
		AND PayrollMethodID = @PayrollMethodID

SELECT	@BeginDate=BeginDate, @EndDate = EndDate 
FROM	HT9999 
WHERE	DivisionID = @DivisionID 
		AND TranMonth = @TranMonth 
		AND TranYear = @TranYear
		
SELECT	@TimeConvert=TimeConvert, 
		@AbsentDecimals=AbsentDecimals 
FROM	HT0000 
WHERE	DivisionID = @DivisionID

SELECT * FROM HT0000
DELETE HT2415
		
WHILE @BeginDate <= @EndDate
BEGIN

DECLARE @cursor CURSOR , 
		@ShiftID AS NVARCHAR(50)
		
SET @cursor = CURSOR FORWARD_ONLY FOR
SELECT	ShiftID
FROM	HT1020 
WHERE	DivisionID = @DivisionID
		AND [Disabled] = 0

OPEN @cursor

FETCH NEXT FROM @cursor INTO @ShiftID

WHILE @@FETCH_STATUS = 0
BEGIN
	
	INSERT INTO HT2415
	(APK,DivisionID, TranMonth, TranYear,
	PayrollMethodID, DepartmentID, TeamID,	EmployeeID,	
	AbsentDate,ShiftID,	AbsentHour,	AbsentDay, Coefficient, PersonAmount)
	
	SELECT	NewID(), DivisionID, TranMonth, TranYear,
			@PayrollMethodID, DepartmentID, TeamID, EmployeeID,
			CONVERT(VARCHAR(10),CONVERT(DATETIME,@BeginDate,121),121), H.ShiftID, 
			ROUND(SUM(ISNULL(AbsentAmount,0)), @AbsentDecimals) AS AbsentHour,
			ROUND(SUM(ISNULL(AbsentAmount,0))/@TimeConvert, @AbsentDecimals) AS AbsentDay,
			(	SELECT ISNULL(ISNULL(HT0281.DayCoefficient,HT2400.SalaryCoefficient),1)
				FROM	HT2400 
				LEFT JOIN HT0281  
					On	HT2400.DivisionID = HT0281.DivisionID 
					AND HT2400.TranMonth = HT0281.TranMonth
					AND HT2400.TranYear = HT0281.TranYear 
					AND HT2400.EmployeeID = HT0281.EmployeeID
					AND @BeginDate BETWEEN HT0281.FromDate AND HT0281.ToDate
					AND @ShiftID BETWEEN HT0281.FromShiftID AND HT0281.ToShiftID
				WHERE HT2400.DivisionID = @DivisionID 
						AND HT2400.TranMonth = @TranMonth 
						AND HT2400.TranYear = @TranYear
						AND HT2400.EmployeeID = H.EmployeeID
			) AS Coefficient,
			0 AS PersonAmount
	FROM HT0284 H
	WHERE DivisionID = @DivisionID 
	AND TranMonth = @TranMonth 
	AND TranYear = @TranYear 
	AND AbsentDate = CONVERT(DATETIME,@BeginDate,121)
	AND ShiftID = @ShiftID 
	AND AbsentTypeID In (SELECT AbsentTypeID 
						 FROM	HT5003 
						 WHERE	DivisionID = @DivisionID 
								AND GeneralAbsentID = @GeneralAbsentID)
	AND @PayrollMethodID + ' _' + TeamID  NOT IN (SELECT PayrollMethodID + '_' + TeamID
																	FROM HT2415 
																	WHERE DivisionID = @DivisionID 
																	AND TranMonth = @TranMonth 
																	AND TranYear = @TranYear 
																	AND AbsentDate = @BeginDate
																	AND HT2415.ShiftID = @ShiftID
																	) 
	GROUP BY DivisionID, TranMonth, TranYear,
			DepartmentID, TeamID, EmployeeID,  H.ShiftID
			
			 
  FETCH NEXT FROM @cursor INTO @ShiftID
END 


CLOSE @cursor
DEALLOCATE @cursor
	
	SET @BeginDate = DATEADD(d,1,@BeginDate)
END


----------Tong tien theo ca
SELECT	SUM(ISNULL(H.Quantity,0)*ISNULL(H2.UnitPrice ,0)) AS TeamAmount,
		SUM(ISNULL(H.Quantity,0)) AS TeamQuantity,
		MAX(H2.UnitPrice) AS UnitPrice,
		CONVERT(VARCHAR(10),CONVERT(DATETIME,H.TrackingDate,121),121) AS TrackingDate,
		H.ShiftID,
		H.AllocationID,
		H.DivisionID, H.TranMonth, H.TranYear,
		H4.DepartmentID, H.TeamID AS Team, H4.TeamID, H4.EmployeeID,
		CONVERT(DECIMAL(28,8),0) AS CoAbsentHour,
		CONVERT(DECIMAL(28,8),0)AS AbsentHour,
		CONVERT(DECIMAL(28,8),0) AS Coefficient,
		CONVERT(DECIMAL(28,8),0) AS TotalHour,
		CONVERT(DECIMAL(28,8),0) AS PersonAmount
INTO	#Employee
FROM		HT0289 H
LEFT JOIN	HT1015 H2
	ON		H.DivisionID = H2.DivisionID	
			AND H.ProductID = H2.ProductID 
LEFT JOIN	HT0291 H4
	ON		H4.DivisionID = H.DivisionID
			AND H4.AllocationID = H.AllocationID
WHERE	H.DivisionID = @DivisionID
		AND H.TranYear = @TranYear
		AND H.TranMonth = @TranMonth		
GROUP BY H.TrackingDate,
		H.ShiftID,
		H.AllocationID,
		H.DivisionID, H.TranMonth, H.TranYear,
		H4.DepartmentID, H4.TeamID, H4.EmployeeID, 
		H.TeamID

		
		
------- Tong gio theo EmployeeID theo tung Ca
DECLARE @Date AS DATETIME
DECLARE @Shift AS VARCHAR(50)
SET @Date = (SELECT TOP 1 TrackingDate FROM #Employee )
SET @Shift = (SELECT TOP 1 ShiftID FROM #Employee )
IF ISNULL(@Date, '') <> '' AND ISNULL(@Shift, '') <> ''
BEGIN
	UPDATE	H
	SET 	H.AbsentHour = ISNULL(H1.AbsentHour,0),
			H.Coefficient = ISNULL(H1.Coefficient,1),
			H.CoAbsentHour = ISNULL(H1.AbsentHour,0)*ISNULL(H1.Coefficient,1)
	FROM	#Employee H
	LEFT JOIN	HT2415 H1	
		ON		H1.EmployeeID = H.EmployeeID
				AND H1.AbsentDate = H.TrackingDate
				AND H1.ShiftID = H.ShiftID
	WHERE	H1.DivisionID = @DivisionID
			AND H1.TranYear = @TranYear
			AND H1.TranMonth = @TranMonth
		
END
IF ISNULL(@Date, '') <> '' AND ISNULL(@Shift, '') = ''
BEGIN
	UPDATE	H
	SET 	H.AbsentHour = ISNULL(H1.AbsentHour,0),
			H.Coefficient = ISNULL(H1.Coefficient,1),
			H.CoAbsentHour = ISNULL(H1.AbsentHour,0)*ISNULL(H1.Coefficient,1)
	FROM	#Employee H
	LEFT JOIN	HT2415 H1	
		ON		H1.EmployeeID = H.EmployeeID
				AND H1.AbsentDate = H.TrackingDate

	WHERE	H1.DivisionID = @DivisionID
			AND H1.TranYear = @TranYear
			AND H1.TranMonth = @TranMonth
END
IF ISNULL(@Date, '') = '' AND ISNULL(@Shift, '') = ''
BEGIN
	UPDATE	H
	SET 	H.AbsentHour = ISNULL(H1.AbsentHour,0),
			H.Coefficient = ISNULL(H1.Coefficient,1),
			H.CoAbsentHour = ISNULL(H1.AbsentHour,0)*ISNULL(H1.Coefficient,1)
	FROM	#Employee H
	LEFT JOIN	HT2415 H1	
		ON		H1.EmployeeID = H.EmployeeID

	WHERE	H1.DivisionID = @DivisionID
			AND H1.TranYear = @TranYear
			AND H1.TranMonth = @TranMonth
END
------- Tong tien , tong gio theo ca
SELECT	AllocationID, SUM(AbsentHour) AS TotalHour, TeamAmount AS TeamAmount, TeamAmount/SUM(CoAbsentHour) AS Amount
INTO	#ShiftMoney
FROM	#Employee 
WHERE	AbsentHour <> 0
GROUP BY AllocationID,TeamAmount

UPDATE	H
SET		H.TotalHour = ISNULL(H1.TotalHour,0),
		H.PersonAmount = ISNULL(ROUND(H1.Amount*H.CoAbsentHour,0),0)
FROM	#Employee H
LEFT JOIN #ShiftMoney H1
	ON		H1.AllocationID = H.AllocationID


DELETE FROM HT2415 
INSERT INTO HT2415
(
	APK,
	DivisionID,
	TranMonth,
	TranYear,
	PayrollMethodID,
	DepartmentID,
	Team,
	TeamID,
	EmployeeID,
	AbsentDate,
	ShiftID,
	AbsentHour,
	AbsentDay,
	PersonAmount,
	TeamAmount,
	TeamQuantity,
	UnitPrice,
	Coefficient
)
SELECT NewID(),
	DivisionID,
	TranMonth,
	TranYear,
	@PayrollMethodID,
	DepartmentID,
	Team,
	TeamID,
	EmployeeID,
	TrackingDate AS AbsentDate,
	ShiftID,
	ROUND(ISNULL(AbsentHour ,0), @AbsentDecimals) AS AbsentHour,
	ROUND(ISNULL(AbsentHour ,0)/@TimeConvert, @AbsentDecimals) AS AbsentDay,
	ISNULL(PersonAmount,0) AS PersonAmount,
	ISNULL(TeamAmount,0) AS TeamAmount,
	TeamQuantity,
	UnitPrice,
	Coefficient
FROM #Employee
WHERE 	ISNULL(EmployeeID,'') <> ''
		AND AbsentHour <> 0



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

