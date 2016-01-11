IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0350]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0350]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- kết chuyển chấm công ca 
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 09/10/2014 by Lê Thị Thu Hiền
---- 
---- Modified on 09/10/2014 by 
-- <Example>
---- EXEC HP0350 'UN', 'ADMIN', 3, 2013, '2013-03-01', '2013-03-31', 'CT2', 'P01'
CREATE PROCEDURE HP0350
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@FromDate AS DATETIME,
		@ToDate AS DATETIME,
		@ProjectID AS NVARCHAR(50),
		@Period AS NVARCHAR(50)
) 
AS
DECLARE @AbsentDecimals AS TINYINT

SET @AbsentDecimals = (SELECT TOP 1 ISNULL(AbsentDecimals,0) FROM HT0000 WHERE DivisionID = @DivisionID )

DELETE FROM HT2432 WHERE DivisionID = @DivisionID 
							AND TranMonth = @TranMonth 
							AND TranYear = @TranYear 
							AND ProjectID = @ProjectID
							AND PeriodID = @Period
IF EXISTS ( SELECT TOP 1 1 FROM HT2416 WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TranMonth = @TranMonth AND Tranyear = @TranYear AND PeriodID = @Period)
BEGIN
		
INSERT INTO HT2432
(	DivisionID,	TranMonth,	TranYear, 
	ProjectID,	PeriodID,	
	DepartmentID,	TeamID,	AbsentTypeID,
	EmployeeID,AbsentAmount,	
	CreateDate,	CreateUserID,	LastModifyDate,	LastModifyUserID
)

SELECT	HT.DivisionID, HT.TranMonth, HT.Tranyear,
		HT.ProjectID, HT.PeriodID,
		HT.DepartmentID, HT.TeamID,	HT.AbsentTypeID,
		HT.EmployeeID, 
		CASE 
			WHEN ISNULL(HT.UnitID, '') = 'H' 
			THEN ROUND(SUM(HT.AbsentTime), @AbsentDecimals) 
			ELSE ROUND(SUM(HT.AbsentTime)/8, @AbsentDecimals) 
		END AS AbsentAmount,
		GETDATE(), @UserID, GETDATE(), @UserID
FROM (		
SELECT	DISTINCT HT2416.DivisionID, HT2416.TranMonth, HT2416.Tranyear,
		HT2416.ProjectID, HT2416.PeriodID, HT1021.UnitID,
		HT2400.DepartmentID, HT2400.TeamID,	HT1021.AbsentTypeID,
		HT2416.EmployeeID, HT2416.ShiftCode, HT2416.AbsentDate,
		ISNULL(HT2416.AbsentTime,0) AS AbsentTime

FROM HT2416 HT2416
LEFT JOIN HT2400 HT2400 
		ON HT2400.DivisionID = HT2416.DivisionID 
	AND HT2400.EmployeeID = HT2416.EmployeeID AND HT2400.TranMonth = HT2416.TranMonth AND HT2400.Tranyear = HT2416.Tranyear
LEFT JOIN (		SELECT	H.DivisionID, H.ShiftID, H1.ParentID AS AbsentTypeID, H1.UnitID,
				CASE WHEN H.DateTypeID = 'SUN' THEN 1
						WHEN H.DateTypeID = 'MON' THEN 2
						WHEN H.DateTypeID = 'TUE' THEN 3
						WHEN H.DateTypeID = 'WED' THEN 4
						WHEN H.DateTypeID = 'THU' THEN 5
						WHEN H.DateTypeID = 'FRI' THEN 6
						WHEN H.DateTypeID = 'SAT' THEN 7
						END DateType
				FROM	HT1021 H 
				INNER JOIN HT1013 H1 ON H1.DivisionID = H.DivisionID AND H1.AbsentTypeID = H.AbsentTypeID AND H1.TypeID = 'N'
           		WHERE	H.DivisionID = @DivisionID) HT1021 
	ON HT1021.DivisionID = HT2416.DivisionID AND HT1021.ShiftID = HT2416.ShiftCode AND DATEPART(DW ,HT2416.AbsentDate) =  HT1021.DateType
WHERE HT2416.DivisionID = @DivisionID
AND HT2416.TranMonth = @TranMonth 
AND HT2416.Tranyear = @TranYear
AND HT2416.ProjectID = @ProjectID
AND HT2416.PeriodID = @Period
) HT
WHERE HT.DepartmentID IS NOT NULL
GROUP BY	HT.DivisionID, HT.TranMonth, HT.Tranyear, 
			HT.DepartmentID, HT.TeamID,	HT.AbsentTypeID,
			HT.EmployeeID, HT.ProjectID, HT.PeriodID, HT.UnitID	

DELETE FROM HT1121 WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID			
INSERT INTO HT1121 (DivisionID, ProjectID, EmployeeID)
SELECT		DISTINCT HT2432.DivisionID, HT2432.ProjectID, HT2432.EmployeeID
FROM		HT2432 HT2432
WHERE		HT2432.DivisionID = @DivisionID
			AND HT2432.ProjectID = @ProjectID
			--AND HT2432.ProjectID+HT2432.EmployeeID NOT IN ( SELECT	DISTINCT ProjectID+EmployeeID 
   --  													   FROM		HT1121 
   --  													   WHERE	HT1121.DivisionID = @DivisionID
   --  																AND HT1121.ProjectID = @ProjectID

			--												)
DELETE FROM HT2421 WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TranMonth = @TranMonth AND TranYear = @TranYear			
INSERT INTO HT2421 (DivisionID, ProjectID, EmployeeID, DepartmentID, TeamID,
            TranMonth, TranYear, BaseSalary, InsuranceSalary, Salary01, Salary02,
            Salary03, SalaryCoefficient, DutyCoefficient, TimeCoefficient,

            CreateDate, LastModifyDate, CreateUserID, LastModifyUserID)
SELECT		DISTINCT HT2432.DivisionID, HT2432.ProjectID, HT2432.EmployeeID, HT2432.DepartmentID, HT2400.TeamID,
            HT2432.TranMonth, HT2432.TranYear, BaseSalary, InsuranceSalary, Salary01, Salary02,
            Salary03, SalaryCoefficient, DutyCoefficient, TimeCoefficient,

			GETDATE(), GETDATE(),@UserID,@UserID
FROM		HT2432 HT2432
INNER JOIN HT2400 HT2400 
	ON		HT2400.DivisionID = HT2432.DivisionID 
			AND HT2400.EmployeeID = HT2432.EmployeeID 
			AND HT2400.TranMonth = HT2432.TranMonth 
			AND HT2400.TranYear = HT2432.TranYear 
			AND HT2400.DepartmentID = HT2432.DepartmentID 
			AND ISNULL (HT2400.TeamID,'') = ISNULL(HT2432.TeamID,'')
WHERE		HT2432.DivisionID = @DivisionID
			AND HT2432.ProjectID = @ProjectID
			AND HT2432.TranMonth = @TranMonth
			AND HT2432.TranYear = @TranYear
	

		END
--------- Lưu Phụ cấp
DELETE FROM HT2430 WHERE DivisionID  = @DivisionID 
AND ProjectID = @ProjectID --AND PeriodID = @Period
AND TranMonth = @TranMonth
AND TranYear = @TranYear

INSERT INTO HT2430
(
	DivisionID,	ProjectID,	PeriodID,	EmployeeID,
	DepartmentID,	TeamID,	TranMonth,	TranYear,
	C01,	C02,	C03,	C04,	C05,
	C06,	C07,	C08,	C09,	C10,
	C11,	C12,	C13,	C14,	C15,
	C16,	C17,	C18,	C19,	C20,
	C21,	C22,	C23,	C24,	C25,
	BaseSalary,	Salary01,	Salary02,	Salary03,
	SalaryCoefficient,	TimeCoefficient,	DutyCoefficient,
	CreateDate,	LastModifyDate,	CreateUserID,	LastModifyUserID,
	InsuranceSalary
)
SELECT 
	H.DivisionID,	@ProjectID,	NULL,--@Period,	
	H.EmployeeID,
	H.DepartmentID,	H.TeamID,	H.TranMonth,	H.TranYear,
	H.C01,	H.C02,	H.C03,	H.C04,	H.C05,
	H.C06,	H.C07,	H.C08,	H.C09,	H.C10,
	H.C11,	H.C12,	H.C13,	H.C14,	H.C15,
	H.C16,	H.C17,	H.C18,	H.C19,	H.C20,
	H.C21,	H.C22,	H.C23,	H.C24,	H.C25,
	H.BaseSalary,	H.Salary01,	H.Salary02,	H.Salary03,
	H.SalaryCoefficient,	H.TimeCoefficient,	H.DutyCoefficient,
	GETDATE(),GETDATE(),@UserID, @UserID,
	InsuranceSalary
FROM HT2400 H
WHERE H.DivisionID = @DivisionID
AND H.TranMonth = @TranMonth
AND H.TranYear = @TranYear
AND H.EmployeeID IN (SELECT EmployeeID
                     FROM HT2416 
                     WHERE DivisionID = @DivisionID 
                     AND TranMonth = @TranMonth
                     AND TranYear = @TranYear
                     AND HT2416.ProjectID = @ProjectID
                     )

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

