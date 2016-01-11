IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP3499]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP3499]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created by Bảo Anh on 25/09/2013
----- Purpose: In tờ khai khấu trừ thuế TNCN và bảng kê thuế TNCN (mẫu 02/KK-TNCN và 05A/BK-TNCN)
---- Modified on 04/02/2015 by Lê Thị Hạnh: Bổ sung mẫu HR2706 - Chứng từ khấu trừ thuế Thu nhập cá nhân
----- HP3499 @DivisionID=N'VK',@TranMonth=10,@TranYear=2014,@Type=2
					
CREATE PROCEDURE 	[dbo].[HP3499] 	
					@DivisionID as nvarchar(50),   		
					@TranMonth as int, 			
					@TranYear as int,
					@Type as tinyint	

AS

IF @Type = 1	--- in tờ khai khấu trừ thuế TNCN 02/KK-TNCN
BEGIN
	Declare @EmpTotal as int,	--- tổng số lao động
			@ResEmpTotal as int,	--- tổng lao động cư trú có HĐLĐ
			@DeductedResEmpTotal as int,	--- tổng lao động cư trú đã khấu trừ thuế
			@DeductedNoResEmpTotal as int,	--- tổng lao động không cư trú đã khấu trừ thuế
			@ResHCSalaryTotal as decimal(28,8),	--- tổng TNCT trả cho lao động cư trú có HĐLĐ
			@ResNoHCSalaryTotal as decimal(28,8),	--- tổng TNCT trả cho lao động cư trú không có HĐLĐ
			@NoResSalaryTotal as decimal(28,8),	--- tổng TNCT trả cho lao động không cư trú
			@DeductedResHCSalaryTotal as decimal(28,8),	--- tổng TNCT trả cho lao động cư trú có HĐLĐ và thuộc diện khấu trừ thuế
			@DeductedResNoHCSalaryTotal as decimal(28,8),	--- tổng TNCT trả cho lao động cư trú không có HĐLĐ và thuộc diện khấu trừ thuế
			@DeductedNoResSalaryTotal as decimal(28,8),	--- tổng TNCT trả cho lao động không cư trú và thuộc diện khấu trừ thuế
			@DeductedResHCTaxTotal as decimal(28,8),	--- tổng thuế TNCN đã khấu trừ dành cho lao động cư trú có HĐLĐ
			@DeductedResNoHCTaxTotal as decimal(28,8)	--- tổng thuế TNCN đã khấu trừ dành cho lao động cư trú không có HĐLĐ

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

	--- Trả ra dữ liệu
	SELECT DivisionName, VATNO, [Address], Tel, Fax, Email,
	@EmpTotal as EmpTotal, @ResEmpTotal as ResEmpTotal, @DeductedResEmpTotal as DeductedResEmpTotal,
	@DeductedNoResEmpTotal as DeductedNoResEmpTotal, @ResHCSalaryTotal as ResHCSalaryTotal, @ResNoHCSalaryTotal as ResNoHCSalaryTotal,
	@NoResSalaryTotal as NoResSalaryTotal, @DeductedResHCSalaryTotal as DeductedResHCSalaryTotal,
	@DeductedResNoHCSalaryTotal as DeductedResNoHCSalaryTotal, @DeductedNoResSalaryTotal as DeductedNoResSalaryTotal,
	@DeductedResHCTaxTotal as DeductedResHCTaxTotal, @DeductedResNoHCTaxTotal as DeductedResNoHCTaxTotal

	FROM AT1101
	WHERE DivisionID = @DivisionID
END

ELSE	--- in bảng kê 05A/BK-TNCN + Chứng từ thuế TNCN
	SELECT	AT1101.DivisionName, AT1101.VATNO, HT34.EmployeeID, HV14.FullName, HV14.PersonalTaxID, HV14.IdentifyCardNo,
		Isnull(HT38.TotalAmount,0) as TotalAmount, ISNULL(HT38.TaxReducedAmount,0) as TaxReducedAmount,
		(Isnull(HT34.SubAmount01,0) + Isnull(HT34.SubAmount02,0) + Isnull(HT34.SubAmount03,0)) as InsAmount,
		ISNULL(HT38.IncomeTax,0) as IncomeTax, 
		-- Chung tu thue TNCN - HR2706
		AT1101.[Address], AT1101.Tel, AT1101.Fax, HV14.CountryName, HV14.FullAddress,
		HV14.PermanentAddress, HV14.TemporaryAddress, HV14.HomePhone, HV14.MobiPhone, 
		HV14.PassportNo, HV14.PassportDate, HV14.PassportEnd, HV14.IdentifyDate, HV14.IdentifyPlace,
		ISNULL(HT34.Income01,0) AS Income01, ISNULL(HT34.Income02,0) AS Income02, 
		ISNULL(HT34.Income03,0) AS Income03, ISNULL(HT34.Income04,0) AS Income04,
	    ISNULL(HT34.Income05,0) AS Income05, ISNULL(HT34.Income06,0) AS Income06, 
	    ISNULL(HT34.Income07,0) AS Income07, ISNULL(HT34.Income08,0) AS Income08,
	    ISNULL(HT34.Income09,0) AS Income09, ISNULL(HT34.Income10,0) AS Income10, 
	    ISNULL(HT34.Income11,0) AS Income11, ISNULL(HT34.Income12,0) AS Income12,
	    ISNULL(HT34.Income13,0) AS Income13, ISNULL(HT34.Income14,0) AS Income14, 
	    ISNULL(HT34.Income15,0) AS Income15, ISNULL(HT34.Income16,0) AS Income16,
	    ISNULL(HT34.Income17,0) AS Income17, ISNULL(HT34.Income18,0) AS Income18, 
	    ISNULL(HT34.Income19,0) AS Income19, ISNULL(HT34.Income20,0) AS Income20,
	    ISNULL(HT34.Income21,0) AS Income21, ISNULL(HT34.Income22,0) AS Income22, 
	    ISNULL(HT34.Income23,0) AS Income23, ISNULL(HT34.Income24,0) AS Income24,
	    ISNULL(HT34.Income25,0) AS Income25, ISNULL(HT34.Income26,0) AS Income26, 
	    ISNULL(HT34.Income27,0) AS Income27, ISNULL(HT34.Income28,0) AS Income28,
	    ISNULL(HT34.Income29,0) AS Income29, ISNULL(HT34.Income30,0) AS Income30,
		HV14.Target01ID, HV14.Target02ID, HV14.Target03ID, HV14.Target04ID, HV14.Target05ID, 
		HV14.Target06ID, HV14.Target07ID, HV14.Target08ID, HV14.Target09ID, HV14.Target10ID
		
	FROM HT3400 HT34
	LEFT JOIN AT1101 On HT34.DivisionID = AT1101.DivisionID
	INNER JOIN HV1400 HV14 On HT34.DivisionID = HV14.DivisionID And HT34.EmployeeID = HV14.EmployeeID
	--LEFT JOIN (Select * From HT0338 Where DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear) HT38
	LEFT JOIN HT0338 HT38 
	On HT34.DivisionID = HT38.DivisionID And HT34.EmployeeID = HT38.EmployeeID
	   AND HT38.DivisionID = @DivisionID AND HT38.TranMonth = @TranMonth AND HT38.TranYear = @TranYear

	WHERE HT34.DivisionID = @DivisionID And HT34.TranMonth = @TranMonth And HT34.TranYear = @TranYear
	ORDER BY HT34.EmployeeID