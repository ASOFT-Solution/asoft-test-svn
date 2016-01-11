IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP3499_1]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP3499_1]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Đổ nguồn report bảng kê thuế TNCN theo quý
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on 30/03/2015
---- Modified by:
-- <Example>
/*
	  HP3499_1 'VK', '', 0, '04/2014', 10, 2014
*/
					
 CREATE PROCEDURE HP3499_1
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@IsPeriod TINYINT,
	@Quarter VARCHAR(50),
	@TranMonth INT,
	@TranYear INT
)
AS
DECLARE @FromMonth INT, @FromYear INT, @ToMonth INT, @ToYear INT,
		@EmpTotal INT,	--- tổng số lao động
		@ResEmpTotal INT,	--- tổng lao động cư trú có HĐLĐ
		@DeductedResEmpTotal INT,	--- tổng lao động cư trú đã khấu trừ thuế
		@DeductedNoResEmpTotal INT,	--- tổng lao động không cư trú đã khấu trừ thuế
		@ResHCSalaryTotal DECIMAL(28,8),	--- tổng TNCT trả cho lao động cư trú có HĐLĐ
		@ResNoHCSalaryTotal DECIMAL(28,8),	--- tổng TNCT trả cho lao động cư trú không có HĐLĐ
		@NoResSalaryTotal DECIMAL(28,8),	--- tổng TNCT trả cho lao động không cư trú
		@DeductedResHCSalaryTotal DECIMAL(28,8),	--- tổng TNCT trả cho lao động cư trú có HĐLĐ và thuộc diện khấu trừ thuế
		@DeductedResNoHCSalaryTotal DECIMAL(28,8),	--- tổng TNCT trả cho lao động cư trú không có HĐLĐ và thuộc diện khấu trừ thuế
		@DeductedNoResSalaryTotal DECIMAL(28,8),	--- tổng TNCT trả cho lao động không cư trú và thuộc diện khấu trừ thuế
		@DeductedResHCTaxTotal DECIMAL(28,8),	--- tổng thuế TNCN đã khấu trừ dành cho lao động cư trú có HĐLĐ
		@DeductedResNoHCTaxTotal DECIMAL(28,8)	--- tổng thuế TNCN đã khấu trừ dành cho lao động cư trú không có HĐLĐ

IF @IsPeriod = 0
BEGIN		
	SET @FromMonth = (SELECT TOP 1 TranMonth FROM HV9999 WHERE DivisionID = @DivisionID AND [Quarter] = @Quarter ORDER BY TranYear ASC, TranMonth ASC)
	SET @FromYear = (SELECT TOP 1 TranYear FROM HV9999 WHERE DivisionID = @DivisionID AND [Quarter] = @Quarter ORDER BY TranYear ASC, TranMonth ASC)
	SET @ToMonth = (SELECT TOP 1 TranMonth FROM HV9999 WHERE DivisionID = @DivisionID AND [Quarter] = @Quarter ORDER BY TranYear DESC, TranMonth DESC)
	SET @ToYear = (SELECT TOP 1 TranYear FROM HV9999 WHERE DivisionID = @DivisionID AND [Quarter] = @Quarter ORDER BY TranYear DESC, TranMonth DESC)

	-------------------------------------------------tổng số lao động----------------------------------------------------------------------------------------------------
	SELECT @EmpTotal = COUNT(DISTINCT EmployeeID) FROM HT3400 
	WHERE DivisionID = @DivisionID AND TranMonth + TranYear * 100 BETWEEN @FromMonth + @FromYear * 100 AND @ToMonth + @ToYear * 100
	-------------------------------------------------tổng lao động cư trú có HĐLĐ-----------------------------------------------------------------------------------------
	SELECT @ResEmpTotal = COUNT(DISTINCT HT3400.EmployeeID)
	FROM HT3400
		INNER JOIN HT1400 ON HT3400.DivisionID = HT1400.DivisionID And HT3400.EmployeeID = HT1400.EmployeeID
	WHERE HT3400.DivisionID = @DivisionID AND TranMonth + TranYear * 100 BETWEEN @FromMonth + @FromYear * 100 AND @ToMonth + @ToYear * 100
		AND HT3400.EmployeeID IN
			(
				SELECT HT1360.EmployeeID
				FROM HT1360
					INNER JOIN HT1105 On HT1360.DivisionID = HT1105.DivisionID And HT1360.ContractTypeID = HT1105.ContractTypeID
				WHERE HT1360.DivisionID = HT3400.DivisionID AND HT1105.Months >= 3
					AND MONTH(DATEADD(MONTH, HT1105.Months, HT1360.SignDate)) + YEAR(DATEADD(MONTH,HT1105.Months, HT1360.SignDate)) * 12 >= @FromMonth + @FromYear * 12
			)
		 AND HT1400.CountryID = 'VN'
	-------------------------------------------------tổng lao động cư trú đã khấu trừ thuế-------------------------------------------------------------------------
	SELECT @DeductedResEmpTotal = COUNT( DISTINCT HT0338.EmployeeID)FROM HT0338
		INNER JOIN HT1400 On HT0338.DivisionID = HT1400.DivisionID And HT0338.EmployeeID = HT1400.EmployeeID
	WHERE HT0338.DivisionID = @DivisionID AND TranMonth + TranYear * 100 BETWEEN @FromMonth + @FromYear * 100 AND @ToMonth + @ToYear * 100
		AND HT0338.IncomeTax > 0 AND HT1400.CountryID = 'VN'
	
	-------------------------------------------------tổng lao động không cư trú đã khấu trừ thuế-------------------------------------------------------------------
	SELECT @DeductedNoResEmpTotal = COUNT(DISTINCT HT0338.EmployeeID)
		FROM HT0338
		INNER JOIN HT1400 On HT0338.DivisionID = HT1400.DivisionID And HT0338.EmployeeID = HT1400.EmployeeID
		WHERE HT0338.DivisionID = @DivisionID AND HT0338.TranMonth + HT0338.TranYear * 100 BETWEEN @FromMonth + @FromYear * 100 AND @ToMonth + @ToYear * 100
		AND HT0338.IncomeTax > 0 AND HT1400.CountryID <> 'VN'

	-------------------------------------------------tổng TNCT trả cho lao động cư trú có HĐLĐ-----------------------------------------------------------------------
	SELECT @ResHCSalaryTotal = ISNULL(SUM(HT0338.TotalAmount),0)
	FROM HT0338
		INNER JOIN HT1400 On HT0338.DivisionID = HT1400.DivisionID AND HT0338.EmployeeID = HT1400.EmployeeID
	WHERE HT0338.DivisionID = @DivisionID AND TranMonth + TranYear * 100 BETWEEN @FromMonth + @FromYear * 100 AND @ToMonth + @ToYear * 100
		AND HT0338.EmployeeID IN 
			(
				SELECT HT1360.EmployeeID FROM HT1360
					INNER JOIN HT1105 On HT1360.DivisionID = HT1105.DivisionID AND HT1360.ContractTypeID = HT1105.ContractTypeID
				WHERE HT1360.DivisionID = HT0338.DivisionID And HT1105.Months >= 3
					AND MONTH(DATEADD(MONTH,HT1105.Months,HT1360.SignDate)) + YEAR(DATEADD(MONTH,HT1105.Months,HT1360.SignDate)) * 12 >= @FromMonth + @FromYear * 12
			)
		AND HT1400.CountryID = 'VN'
	
	-------------------------------------------------tổng TNCT trả cho lao động cư trú không có HĐLĐ------------------------------------------------------------------
	SELECT @ResNoHCSalaryTotal = ISNULL(SUM(HT0338.TotalAmount),0)
	FROM HT0338
		INNER JOIN HT1400 On HT0338.DivisionID = HT1400.DivisionID AND HT0338.EmployeeID = HT1400.EmployeeID
	WHERE HT0338.DivisionID = @DivisionID AND TranMonth + TranYear * 100 BETWEEN @FromMonth + @FromYear * 100 AND @ToMonth + @ToYear * 100
		AND HT0338.EmployeeID NOT IN 
			(
				SELECT HT1360.EmployeeID FROM HT1360
					INNER JOIN HT1105 On HT1360.DivisionID = HT1105.DivisionID And HT1360.ContractTypeID = HT1105.ContractTypeID
				WHERE HT1360.DivisionID = HT0338.DivisionID AND HT1105.Months >= 3
					AND MONTH(DATEADD(MONTH,HT1105.Months,HT1360.SignDate)) + YEAR(DATEADD(MONTH,HT1105.Months,HT1360.SignDate)) * 12 >= @FromMonth + @FromYear * 12
			)
		AND HT1400.CountryID = 'VN'
	
	-------------------------------------------------tổng TNCT trả cho lao động không cư trú------------------------------------------------------------------
	SELECT @NoResSalaryTotal = ISNULL(SUM(HT0338.TotalAmount),0)
	FROM HT0338
		INNER JOIN HT1400 ON HT0338.DivisionID = HT1400.DivisionID And HT0338.EmployeeID = HT1400.EmployeeID
	WHERE HT0338.DivisionID = @DivisionID AND TranMonth + TranYear * 100 BETWEEN @FromMonth + @FromYear * 100 AND @ToMonth + @ToYear * 100
		AND HT1400.CountryID <> 'VN'

	-------------------------------------------------tổng TNCT trả cho lao động cư trú có HĐLĐ và thuộc diện khấu trừ thuế---------------------------------------
	-------------------------------------------------tổng thuế TNCN đã khấu trừ dành cho lao động cư trú có HĐLĐ-------------------------------------------------
	SELECT @DeductedResHCSalaryTotal = ISNULL(SUM(HT0338.TotalAmount),0), @DeductedResHCTaxTotal = ISNULL(SUM(HT0338.IncomeTax),0)
	FROM HT0338
		INNER JOIN HT1400 On HT0338.DivisionID = HT1400.DivisionID AND HT0338.EmployeeID = HT1400.EmployeeID
	WHERE HT0338.DivisionID = @DivisionID AND TranMonth + TranYear * 100 BETWEEN @FromMonth + @FromYear * 100 AND @ToMonth + @ToYear * 100
		AND HT0338.EmployeeID IN
		(
			SELECT HT1360.EmployeeID FROM HT1360
				INNER JOIN HT1105 On HT1360.DivisionID = HT1105.DivisionID And HT1360.ContractTypeID = HT1105.ContractTypeID
			WHERE HT1360.DivisionID = HT0338.DivisionID AND HT1105.Months >= 3
				AND MONTH(DATEADD(MONTH,HT1105.Months,HT1360.SignDate)) + YEAR(DATEADD(MONTH,HT1105.Months,HT1360.SignDate)) * 12 >= @FromMonth + @FromYear * 12
		)
		AND HT0338.IncomeTax > 0 AND HT1400.CountryID = 'VN'
	
	-------------------------------------------------tổng TNCT trả cho lao động cư trú không có HĐLĐ và thuộc diện khấu trừ thuế---------------------------------------
	-------------------------------------------------tổng thuế TNCN đã khấu trừ dành cho lao động cư trú không có HĐLĐ-------------------------------------------------	
	SELECT @DeductedResNoHCSalaryTotal = ISNULL(SUM(HT0338.TotalAmount),0), @DeductedResNoHCTaxTotal = ISNULL(SUM(HT0338.IncomeTax),0)
	FROM HT0338
		INNER JOIN HT1400 ON HT0338.DivisionID = HT1400.DivisionID AND HT0338.EmployeeID = HT1400.EmployeeID
	WHERE HT0338.DivisionID = @DivisionID AND TranMonth + TranYear * 100 BETWEEN @FromMonth + @FromYear * 100 AND @ToMonth + @ToYear * 100
		AND HT0338.EmployeeID NOT IN 
		(
			SELECT HT1360.EmployeeID FROM HT1360
				INNER JOIN HT1105 On HT1360.DivisionID = HT1105.DivisionID AND HT1360.ContractTypeID = HT1105.ContractTypeID
			WHERE HT1360.DivisionID = HT0338.DivisionID AND HT1105.Months >= 3
				AND MONTH(DATEADD(MONTH,HT1105.Months,HT1360.SignDate)) + YEAR(DATEADD(MONTH,HT1105.Months,HT1360.SignDate)) * 12 >= @FromMonth + @FromYear * 12
		)
		AND HT0338.IncomeTax > 0 AND HT1400.CountryID = 'VN'
	
	-------------------------------------------------tổng TNCT trả cho lao động không cư trú và thuộc diện khấu trừ thuế----------------------------------------------	
	SELECT @DeductedNoResSalaryTotal = ISNULL(SUM(HT0338.TotalAmount),0)
		FROM HT0338
		INNER JOIN HT1400 On HT0338.DivisionID = HT1400.DivisionID And HT0338.EmployeeID = HT1400.EmployeeID
		WHERE HT0338.DivisionID = @DivisionID AND TranMonth + TranYear * 100 BETWEEN @FromMonth + @FromYear * 100 AND @ToMonth + @ToYear * 100
		AND HT0338.IncomeTax > 0 And HT1400.CountryID <> 'VN'
END
IF @IsPeriod = 1
BEGIN
	SELECT @EmpTotal = COUNT (EmployeeID)
	FROM HT3400
	WHERE DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear

	SELECT @ResEmpTotal = COUNT (HT3400.EmployeeID)
	FROM HT3400
	INNER JOIN HT1400 On HT3400.DivisionID = HT1400.DivisionID And HT3400.EmployeeID = HT1400.EmployeeID
	WHERE HT3400.DivisionID = @DivisionID And HT3400.TranMonth = @TranMonth And HT3400.TranYear = @TranYear
	AND HT3400.EmployeeID in (Select HT1360.EmployeeID From HT1360
							INNER JOIN HT1105 On HT1360.DivisionID = HT1105.DivisionID And HT1360.ContractTypeID = HT1105.ContractTypeID
							Where HT1360.DivisionID = HT3400.DivisionID And HT1105.Months >= 3
							And month(dateadd(month,HT1105.Months,HT1360.SignDate)) + year(dateadd(month,HT1105.Months,HT1360.SignDate)) * 12 >= @TranMonth + @TranYear*12
							)
	 And HT1400.CountryID = 'VN'

	SELECT @DeductedResEmpTotal = COUNT (HT0338.EmployeeID)
	FROM HT0338
	INNER JOIN HT1400 On HT0338.DivisionID = HT1400.DivisionID And HT0338.EmployeeID = HT1400.EmployeeID
	WHERE HT0338.DivisionID = @DivisionID And HT0338.TranMonth = @TranMonth And HT0338.TranYear = @TranYear
	AND HT0338.IncomeTax > 0 AND HT1400.CountryID = 'VN'

	SELECT @DeductedNoResEmpTotal = COUNT (HT0338.EmployeeID)
	FROM HT0338
	INNER JOIN HT1400 On HT0338.DivisionID = HT1400.DivisionID And HT0338.EmployeeID = HT1400.EmployeeID
	WHERE HT0338.DivisionID = @DivisionID And HT0338.TranMonth = @TranMonth And HT0338.TranYear = @TranYear
	AND HT0338.IncomeTax > 0 AND HT1400.CountryID <> 'VN'

	SELECT @ResHCSalaryTotal = Isnull(Sum(HT0338.TotalAmount),0)
	FROM HT0338
	INNER JOIN HT1400 On HT0338.DivisionID = HT1400.DivisionID And HT0338.EmployeeID = HT1400.EmployeeID
	WHERE HT0338.DivisionID = @DivisionID And HT0338.TranMonth = @TranMonth And HT0338.TranYear = @TranYear
	AND HT0338.EmployeeID in (Select HT1360.EmployeeID From HT1360
							INNER JOIN HT1105 On HT1360.DivisionID = HT1105.DivisionID And HT1360.ContractTypeID = HT1105.ContractTypeID
							Where HT1360.DivisionID = HT0338.DivisionID And HT1105.Months >= 3
							And month(dateadd(month,HT1105.Months,HT1360.SignDate)) + year(dateadd(month,HT1105.Months,HT1360.SignDate)) * 12 >= @TranMonth + @TranYear*12
							)
	And HT1400.CountryID = 'VN'

	SELECT @ResNoHCSalaryTotal = Isnull(Sum(HT0338.TotalAmount),0)
	FROM HT0338
	INNER JOIN HT1400 On HT0338.DivisionID = HT1400.DivisionID And HT0338.EmployeeID = HT1400.EmployeeID
	WHERE HT0338.DivisionID = @DivisionID And HT0338.TranMonth = @TranMonth And HT0338.TranYear = @TranYear
	AND HT0338.EmployeeID not in (Select HT1360.EmployeeID From HT1360
							INNER JOIN HT1105 On HT1360.DivisionID = HT1105.DivisionID And HT1360.ContractTypeID = HT1105.ContractTypeID
							Where HT1360.DivisionID = HT0338.DivisionID And HT1105.Months >= 3
							And month(dateadd(month,HT1105.Months,HT1360.SignDate)) + year(dateadd(month,HT1105.Months,HT1360.SignDate)) * 12 >= @TranMonth + @TranYear*12
							)
	And HT1400.CountryID = 'VN'

	SELECT @NoResSalaryTotal = Isnull(Sum(HT0338.TotalAmount),0)
	FROM HT0338
	INNER JOIN HT1400 On HT0338.DivisionID = HT1400.DivisionID And HT0338.EmployeeID = HT1400.EmployeeID
	WHERE HT0338.DivisionID = @DivisionID And HT0338.TranMonth = @TranMonth And HT0338.TranYear = @TranYear
	And HT1400.CountryID <> 'VN'

	SELECT @DeductedResHCSalaryTotal = Isnull(Sum(HT0338.TotalAmount),0), @DeductedResHCTaxTotal = Isnull(Sum(HT0338.IncomeTax),0)
	FROM HT0338
	INNER JOIN HT1400 On HT0338.DivisionID = HT1400.DivisionID And HT0338.EmployeeID = HT1400.EmployeeID
	WHERE HT0338.DivisionID = @DivisionID And HT0338.TranMonth = @TranMonth And HT0338.TranYear = @TranYear
	AND HT0338.EmployeeID in (Select HT1360.EmployeeID From HT1360
							INNER JOIN HT1105 On HT1360.DivisionID = HT1105.DivisionID And HT1360.ContractTypeID = HT1105.ContractTypeID
							Where HT1360.DivisionID = HT0338.DivisionID And HT1105.Months >= 3
							And month(dateadd(month,HT1105.Months,HT1360.SignDate)) + year(dateadd(month,HT1105.Months,HT1360.SignDate)) * 12 >= @TranMonth + @TranYear*12
							)
	AND HT0338.IncomeTax > 0 And HT1400.CountryID = 'VN'

	SELECT @DeductedResNoHCSalaryTotal = Isnull(Sum(HT0338.TotalAmount),0), @DeductedResNoHCTaxTotal = Isnull(Sum(HT0338.IncomeTax),0)
	FROM HT0338
	INNER JOIN HT1400 On HT0338.DivisionID = HT1400.DivisionID And HT0338.EmployeeID = HT1400.EmployeeID
	WHERE HT0338.DivisionID = @DivisionID And HT0338.TranMonth = @TranMonth And HT0338.TranYear = @TranYear
	AND HT0338.EmployeeID not in (Select HT1360.EmployeeID From HT1360
							INNER JOIN HT1105 On HT1360.DivisionID = HT1105.DivisionID And HT1360.ContractTypeID = HT1105.ContractTypeID
							Where HT1360.DivisionID = HT0338.DivisionID And HT1105.Months >= 3
							And month(dateadd(month,HT1105.Months,HT1360.SignDate)) + year(dateadd(month,HT1105.Months,HT1360.SignDate)) * 12 >= @TranMonth + @TranYear*12
							)
	AND HT0338.IncomeTax > 0 And HT1400.CountryID = 'VN'

	SELECT @DeductedNoResSalaryTotal = Isnull(Sum(HT0338.TotalAmount),0)
	FROM HT0338
	INNER JOIN HT1400 On HT0338.DivisionID = HT1400.DivisionID And HT0338.EmployeeID = HT1400.EmployeeID
	WHERE HT0338.DivisionID = @DivisionID And HT0338.TranMonth = @TranMonth And HT0338.TranYear = @TranYear
	AND HT0338.IncomeTax > 0 And HT1400.CountryID <> 'VN'
END

------------------------------------------------- Trả ra dữ liệu---------------------------------------------------------------------------------------------------

CREATE TABLE #Tam
(
	OrderNo INT,
	OrderText VARCHAR(50),
	DeclareRationType VARCHAR(50),
	TagetID VARCHAR(50),
	TagetName NVARCHAR(250),
	UnitName NVARCHAR(250),
	Person_Amount DECIMAL(28,8),
	[ReadOnly] TINYINT,
	FormulaString NVARCHAR(100)
)
INSERT INTO #Tam(OrderNo, OrderText, DeclareRationType, TagetID, TagetName, UnitName, Person_Amount, [ReadOnly], FormulaString)
SELECT OrderNo, OrderText, DeclareRationType, TagetID, TagetName, '', 0, [ReadOnly], FormulaString
FROM HT0009
WHERE DeclareRationType = '02KK-TNCN'

UPDATE #Tam SET Person_Amount = @EmpTotal WHERE TagetID = '[21]'
UPDATE #Tam SET Person_Amount = @ResEmpTotal WHERE TagetID = '[22]'
UPDATE #Tam SET Person_Amount = @DeductedResEmpTotal WHERE TagetID = '[24]'
UPDATE #Tam SET Person_Amount = @DeductedNoResEmpTotal WHERE TagetID = '[25]'
UPDATE #Tam SET Person_Amount = @ResHCSalaryTotal WHERE TagetID = '[27]'
UPDATE #Tam SET Person_Amount = @ResNoHCSalaryTotal WHERE TagetID = '[28]'
UPDATE #Tam SET Person_Amount = @NoResSalaryTotal WHERE TagetID = '[29]'
UPDATE #Tam SET Person_Amount = @DeductedResHCSalaryTotal WHERE TagetID = '[31]'
UPDATE #Tam SET Person_Amount = @DeductedResNoHCSalaryTotal WHERE TagetID = '[32]'
UPDATE #Tam SET Person_Amount = @DeductedNoResSalaryTotal WHERE TagetID = '[33]'
UPDATE #Tam SET Person_Amount = @DeductedResHCTaxTotal WHERE TagetID = '[35]'
UPDATE #Tam SET Person_Amount = @DeductedResNoHCTaxTotal WHERE TagetID = '[36]'
UPDATE #Tam SET Person_Amount = ISNULL(@DeductedNoResSalaryTotal, 0) / 5 WHERE TagetID = '[37]'

UPDATE #Tam SET UnitName = N'Người' WHERE TagetID BETWEEN '[21]' AND '[25]'
UPDATE #Tam SET UnitName = N'VNĐ' WHERE TagetID BETWEEN '[26]' AND '[37]'

SELECT * FROM #Tam


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
