IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0423_HV]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP0423_HV]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





---- Create on 17/06/2014 by Bảo Anh
---- In danh sách lao động tham gia BHXH, BHYT (customize Hưng Vượng: mẫu D02-TS cũ)
---- HP0423_HV 'AS',5,2012,'0f87bc72-3551-46b9-8d9f-48d6f3c82a62'
---- Modified by Thanh Sơn on 24/12/2014: Bổ sung và thay đổi một số trườn theo mẫu 10/10/2014 của Bình Dương cho khách hàng SOFA
---- Modified by Quốc Tuấn on 29/01/2015: Bổ sung tình trạng cho SOFA giảm lao động là 5 còn Hưng vượng là 4
---- Modified by Thanh Thịnh on 7/8/2015 : Giảm Lao động đối với người thai sản, không hiện ở mục giảm không trả thẻ
---- Modified by Thanh Thịnh on 20/8/2015 : Đối với giảm lao động không có mức đống BHXH sẽ lấy mức đống BHXH tháng gần nhất

CREATE PROCEDURE HP0423_HV
( 
	@DivisionID NVARCHAR(50),
	@TranMonth INT,
	@TranYear INT,
	@VoucherID NVARCHAR(50)
) 
AS 
DECLARE @City NVARCHAR(50) = N'Bình Dương',
		@StatusReduce INT,
		@CustomerName INT
--Tạo bảng tạm để kiểm tra đây có phải là khách hàng Sài Gòn Petro không (CustomerName = 36)
	CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
	INSERT #CustomerName EXEC AP4444
	SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)
	IF @CustomerName= 30 SET @StatusReduce=4
	ELSE SET @StatusReduce=5
	
-- Tao Dòng Thứ 2 cho dữ liệu giảm Trả thẻ chậm và giảm không trả thẻ (Thinh)
	CREATE TABLE #RowSecond( [Row] int)
	INSERT INTO #RowSecond
	SELECT 1
	UNION
	SELECT 2

--- Các trường hợp không phải giảm lao động
SELECT H40.DutyName,  CASE WHEN ISNULL(HT2460.CFromDate,'1-jan-1900') = '1-jan-1900' 
						THEN '1/'+ CAST(@TranMonth AS NVARCHAR)+'/'+ CAST(@TranYear AS NVARCHAR)
						ELSE '1/'+ CAST(MONTH(HT2460.CFromDate) AS NVARCHAR)+'/'+ CAST(YEAR(HT2460.CFromDate) AS NVARCHAR) END FromMonth,
					 '1/'+ CAST(MONTH(HT2460.CToDate) AS NVARCHAR)+'/'+ CAST(YEAR(HT2460.CToDate) AS NVARCHAR)  ToMonth, H23.EmployeeID, H40.FullName,
	H40.DepartmentID, H40.DepartmentName, H40.Birthday, (CASE WHEN IsMale = 0 THEN 'X' ELSE '' END) IsFemale, 
	H40.HospitalName, H40.IdentifyCardNo, H40.IdentifyDate, H40.IdentifyPlace, ISNULL(H40.PermanentAddress, H40.TemporaryAddress) [Address],
	CASE WHEN H23.EmployeeID LIKE 'QL%' THEN 3 ELSE H23.[Status]END [Status], H23.StatusName, NULL ChildStatus, H23.OldInsuranceSalary, 0 OldSalary01, 0 OldSalary02,
	0 OldSalary03, 0 OldOtherSalary, H23.InsuranceSalary, H40.SoInsuranceNo, H23.Salary01, H23.Salary02,
	H23.Salary03, H23.OrtherSalary,RemainMonth, IsHStatus, H23.[Description], 
	(SELECT TOP 1 ContractNo FROM HT1360 WHERE DivisionID = @DivisionID AND EmployeeID = H23.EmployeeID ORDER BY SignDate DESC) ContractNo,
	case when H23.Status= 4 then (ISNULL(H61.TRate, 0) + ISNULL(H61.TRate2, 0))- (ISNULL(T61.TRate, 0) + ISNULL(T61.TRate2, 0)) else (ISNULL(H61.SRate, 0) + ISNULL(H61.SRate2, 0) + ISNULL(H61.HRate, 0) + ISNULL(H61.HRate2, 0) + ISNULL(H61.TRate, 0) + ISNULL(H61.TRate2, 0)) end TotalRate,
	case when H23.Status= 4 then (ISNULL(H61.TRate, 0) + ISNULL(H61.TRate2, 0))- (ISNULL(T61.TRate, 0) + ISNULL(T61.TRate2, 0)) else(ISNULL(T61.SRate, 0) + ISNULL(T61.SRate2, 0) + ISNULL(T61.HRate, 0) + ISNULL(T61.HRate2, 0) + ISNULL(T61.TRate, 0) + ISNULL(T61.TRate2, 0)) end TotalRate_Dec,
	@TranMonth TranMonth, @TranYear TranYear, @City City, NULL Notes, H40.EthnicName		
FROM HT0323 H23
	INNER JOIN HV1400 H40 ON H40.DivisionID = H23.DivisionID AND H40.EmployeeID = H23.EmployeeID
	INNER JOIN HT0322 H22 ON H22.DivisionID = H23.DivisionID AND H22.VoucherID = H23.VoucherID
	LEFT JOIN HT2461 H61 ON H61.DivisionID = H23.DivisionID AND H61.EmployeeID = H23.EmployeeID AND H61.TranMonth = @TranMonth AND H61.TranYear = @TranYear
	LEFT JOIN HT2461 T61 ON T61.DivisionID = H23.DivisionID AND T61.EmployeeID = H23.EmployeeID AND T61.TranMonth + T61.TranYear * 12 = (@TranMonth + @TranYear * 12) - 1
	LEFT JOIN HT2460 ON HT2460.DivisionID= H23.DivisionID and HT2460.EmployeeID = H23.EmployeeID AND HT2460.TranMonth= @TranMonth and HT2460.TranYear = @TranYear
WHERE H22.DivisionID = @DivisionID
	AND H22.TranMonth = @TranMonth 
	AND H22.TranYear = @TranYear 
	AND H22.VoucherID = @VoucherID
	AND H23.[Status] <> @StatusReduce
	AND H40.EmployeeStatus = 1
	--OR(H23.EmployeeID LIKE 'QL%' AND (CEILING(cast(@TranMonth as decimal(28,8))/3) *3) = @TranMonth)

		
--- Trường hợp giảm lao động có trả thẻ BHYT
UNION
Select DISTINCT	HV1400.DutyName, CASE WHEN ISNULL(HT0323.MonthYearFrom,'0') = '0' THEN '' ELSE '1/'+ HT0323.MonthYearFrom END  FromMonth,
								 CASE WHEN HT0323.IsHStatus = 1 and HT0323.HStatus = 0 
										THEN CASE WHEN RS.Row = 2 
												THEN '1/'+ CAST(MONTH(HT2460.CToDate) AS NVARCHAR)+'/'+ CAST(YEAR(HT2460.CToDate) AS NVARCHAR)  
												ELSE '1/'+ CAST(@TranMonth AS NVARCHAR)+'/'+ CAST(@TranYear AS NVARCHAR) END 
										ELSE '1/'+ CAST(@TranMonth AS NVARCHAR)+'/'+ CAST(@TranYear AS NVARCHAR) END as ToMonth,
		HT0323.EmployeeID, FullName, HV1400.DepartmentID, DepartmentName, Birthday, (case when isMale = 0 then 'X' else '' end) as IsFemale, 
		HV1400.HospitalName, HV1400.IdentifyCardNo, HV1400.IdentifyDate, HV1400.IdentifyPlace, Isnull(HV1400.PermanentAddress, HV1400.TemporaryAddress) as Address,
		CASE WHEN HV1400.StatusID in (3,9) THEN 5 ELSE HT0323.Status END [Status], HT0323.StatusName, (case when ISNULL(HStatus,0) <> 0 then 1 else 2 end) as ChildStatus, 0 OldInsuranceSalary,
		0 as oldSalary01, 0 as oldSalary02,0 as oldSalary03, 0 as OldOtherSalary, 
		CASE WHEN HT0323.InsuranceSalary IS NULL 
			THEN (	SELECT top 1 InsuranceSalary 
					FROM	HT2460 
					WHERE	HT2460.DivisionID = HT0323.DivisionID 
						AND HT2460.EmployeeID = HT0323.EmployeeID
					ORDER BY TRANYEAR DESC,TRANMONTH DESC
				 ) ELSE HT0323.InsuranceSalary END [InsuranceSalary], HV1400.SoInsuranceNo,
		HT0323.Salary01, HT0323.Salary02, HT0323.Salary03, HT0323.OrtherSalary,RemainMonth, IsHStatus, HT0323.Description,
		(Select top 1 ContractNo from HT1360 Where DivisionID = @DivisionID And EmployeeID = HT0323.EmployeeID Order by SignDate DESC) as ContractNo,
		CASE WHEN HT0323.IsHStatus = 1 and HT0323.HStatus = 0  AND RS.Row = 2 THEN 4.5  ELSE (Isnull(HT2461.SRate,0) + Isnull(HT2461.SRate2,0) + Isnull(HT2461.HRate,0) + Isnull(HT2461.HRate2,0) + Isnull(HT2461.TRate,0) + Isnull(HT2461.TRate2,0)) END as TotalRate,
		CASE WHEN HT0323.IsHStatus = 1 and HT0323.HStatus = 0 AND RS.Row = 2 THEN 4.5  ELSE (Isnull(T61.SRate,0) + Isnull(T61.SRate2,0) + Isnull(T61.HRate,0) + Isnull(T61.HRate2,0) + Isnull(T61.TRate,0) + Isnull(T61.TRate2,0)) END as TotalRate_Dec,
		@TranMonth as TranMonth, @TranYear as TranYear, @City City, NULL Notes, HV1400.EthnicName
		
From HT0323  
inner join HV1400 on HV1400.DivisionID = HT0323.DivisionID and HV1400.EmployeeID = HT0323.EmployeeID
inner join HT0322 on HT0322.DivisionID = HT0323.DivisionID and HT0322.VoucherID = HT0323.VoucherID
left join HT2461 on HT2461.DivisionID = HT0323.DivisionID and HT2461.EmployeeID = HT0323.EmployeeID and HT2461.TranMonth = @TranMonth and HT2461.TranYear = @TranYear
left join HT2461 T61 on T61.DivisionID = HT0323.DivisionID and T61.EmployeeID = HT0323.EmployeeID and T61.TranMonth + T61.TranYear * 12 = (@TranMonth + @TranYear * 12) -1
left join #RowSecond RS on 1 =1
LEFT JOIN HT2460 ON HT2460.DivisionID= HT0323.DivisionID and HT2460.EmployeeID = HT0323.EmployeeID AND HT2460.TranMonth= @TranMonth and HT2460.TranYear = @TranYear

Where	HT0322.DivisionID = @DivisionID
		and HT0322.TranMonth = @TranMonth 
		and HT0322.TranYear = @TranYear 
		and HT0322.VoucherID =@VoucherID
		and (HV1400.StatusID in (3,9) or  ( HT0323.Status = @StatusReduce)) and Isnull(IsHStatus,0) <> 0
		
--- Trường hợp giảm lao động không trả thẻ BHYT
UNION
Select	HV1400.DutyName,CASE WHEN ISNULL(HT0323.MonthYearFrom,'0') = '0' THEN '' ELSE '1/'+ HT0323.MonthYearFrom END  FromMonth,CASE WHEN RS.Row = 2 
																																		THEN '1/'+ CAST(MONTH(HT2460.CToDate) AS NVARCHAR)+'/'+ CAST(YEAR(HT2460.CToDate) AS NVARCHAR)  
																																		ELSE '1/'+ CAST(@TranMonth AS NVARCHAR)+'/'+ CAST(@TranYear AS NVARCHAR) END as ToMonth,
		HT0323.EmployeeID, FullName, HV1400.DepartmentID, DepartmentName, Birthday, (case when isMale = 0 then 'X' else '' end) as IsFemale, 
		HV1400.HospitalName, HV1400.IdentifyCardNo, HV1400.IdentifyDate, HV1400.IdentifyPlace, Isnull(HV1400.PermanentAddress, HV1400.TemporaryAddress) as Address,
		CASE WHEN HV1400.StatusID in (3,9) THEN 5 ELSE HT0323.Status END [Status], HT0323.StatusName, 3 as ChildStatus, 0 OldInsuranceSalary,
		0 as oldSalary01, 0 as oldSalary02,0 as oldSalary03, 0 as OldOtherSalary, 
			CASE WHEN HT0323.InsuranceSalary IS NULL 
				THEN (	SELECT top 1 InsuranceSalary 
						FROM	HT2460 
						WHERE	HT2460.DivisionID = HT0323.DivisionID 
							AND HT2460.EmployeeID = HT0323.EmployeeID
						ORDER BY TRANYEAR DESC,TRANMONTH DESC
					 ) ELSE HT0323.InsuranceSalary END [InsuranceSalary], HV1400.SoInsuranceNo,
		HT0323.Salary01, HT0323.Salary02, HT0323.Salary03, HT0323.OrtherSalary,RemainMonth, IsHStatus, HT0323.Description,
		(Select top 1 ContractNo from HT1360 Where DivisionID = @DivisionID And EmployeeID = HT0323.EmployeeID Order by SignDate DESC) as ContractNo,
		CASE WHEN RS.Row = 2 THEN 4.5 ELSE (Isnull(HT2461.SRate,0) + Isnull(HT2461.SRate2,0) + Isnull(HT2461.HRate,0) + Isnull(HT2461.HRate2,0) + Isnull(HT2461.TRate,0) + Isnull(HT2461.TRate2,0)) END as TotalRate,
		CASE WHEN RS.Row = 2 THEN 4.5 ELSE (Isnull(T61.SRate,0) + Isnull(T61.SRate2,0) + Isnull(T61.HRate,0) + Isnull(T61.HRate2,0) + Isnull(T61.TRate,0) + Isnull(T61.TRate2,0)) END as TotalRate_Dec,
		@TranMonth as TranMonth, @TranYear as TranYear, @City City, NULL Notes, HV1400.EthnicName
		
From HT0323  
inner join HV1400 on HV1400.DivisionID = HT0323.DivisionID and HV1400.EmployeeID = HT0323.EmployeeID
inner join HT0322 on HT0322.DivisionID = HT0323.DivisionID and HT0322.VoucherID = HT0323.VoucherID
left join HT2461 on HT2461.DivisionID = HT0323.DivisionID and HT2461.EmployeeID = HT0323.EmployeeID and HT2461.TranMonth = @TranMonth and HT2461.TranYear = @TranYear
left join HT2461 T61 on T61.DivisionID = HT0323.DivisionID and T61.EmployeeID = HT0323.EmployeeID and T61.TranMonth + T61.TranYear * 12 = (@TranMonth + @TranYear * 12) -1
left join #RowSecond RS on 1 =1
LEFT JOIN HT2460 ON HT2460.DivisionID= HT0323.DivisionID and HT2460.EmployeeID = HT0323.EmployeeID AND HT2460.TranMonth= @TranMonth and HT2460.TranYear = @TranYear

Where	HT0322.DivisionID = @DivisionID
		and HT0322.TranMonth = @TranMonth 
		and HT0322.TranYear = @TranYear 
		and HT0322.VoucherID =@VoucherID
		and (HV1400.StatusID in (3,9)  or  (HT0323.Status = @StatusReduce)) and Isnull(IsHStatus,0) = 0
		and HT0323.EmployeeID not in (Select EmployeeID From HT0315 Where DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear
									And ConditionTypeID = '2')
	
--- Trường hợp giảm lao động do thai sản
UNION
Select	HV1400.DutyName,CASE WHEN ISNULL(HT0323.MonthYearFrom,'0') = '0' THEN '' ELSE '1/'+ HT0323.MonthYearFrom END  FromMonth,
						'1/'+ CAST(@TranMonth AS NVARCHAR)+'/'+ CAST(@TranYear AS NVARCHAR) as ToMonth,
		HT0323.EmployeeID, FullName, HV1400.DepartmentID, DepartmentName, Birthday, (case when isMale = 0 then 'X' else '' end) as IsFemale, 
		HV1400.HospitalName, HV1400.IdentifyCardNo, HV1400.IdentifyDate, HV1400.IdentifyPlace, Isnull(HV1400.PermanentAddress, HV1400.TemporaryAddress) as Address,
		HT0323.Status, HT0323.StatusName, 4 as ChildStatus, 0 OldInsuranceSalary,
		0 as oldSalary01, 0 as oldSalary02,0 as oldSalary03, 0 as OldOtherSalary,
			CASE WHEN HT0323.InsuranceSalary IS NULL 
				THEN (	SELECT top 1 InsuranceSalary 
						FROM	HT2460 
						WHERE	HT2460.DivisionID = HT0323.DivisionID 
							AND HT2460.EmployeeID = HT0323.EmployeeID
						ORDER BY TRANYEAR DESC,TRANMONTH DESC
					 ) ELSE HT0323.InsuranceSalary END [InsuranceSalary], HV1400.SoInsuranceNo,
		HT0323.Salary01, HT0323.Salary02, HT0323.Salary03, HT0323.OrtherSalary,RemainMonth, IsHStatus, HT0323.Description,
		(Select top 1 ContractNo from HT1360 Where DivisionID = @DivisionID And EmployeeID = HT0323.EmployeeID Order by SignDate DESC) as ContractNo,
		(Isnull(HT2461.SRate,0) + Isnull(HT2461.SRate2,0) + Isnull(HT2461.HRate,0) + Isnull(HT2461.HRate2,0) + Isnull(HT2461.TRate,0) + Isnull(HT2461.TRate2,0)) as TotalRate,
		(Isnull(T61.SRate,0) + Isnull(T61.SRate2,0) + Isnull(T61.HRate,0) + Isnull(T61.HRate2,0) + Isnull(T61.TRate,0) + Isnull(T61.TRate2,0)) as TotalRate_Dec,
		@TranMonth as TranMonth, @TranYear as TranYear, @City City, NULL Notes, HV1400.EthnicName
		
From HT0323  
inner join HV1400 on HV1400.DivisionID = HT0323.DivisionID and HV1400.EmployeeID = HT0323.EmployeeID
inner join HT0322 on HT0322.DivisionID = HT0323.DivisionID and HT0322.VoucherID = HT0323.VoucherID
left join HT2461 on HT2461.DivisionID = HT0323.DivisionID and HT2461.EmployeeID = HT0323.EmployeeID and HT2461.TranMonth = @TranMonth and HT2461.TranYear = @TranYear
left join HT2461 T61 on T61.DivisionID = HT0323.DivisionID and T61.EmployeeID = HT0323.EmployeeID and T61.TranMonth + T61.TranYear * 12 = (@TranMonth + @TranYear * 12) -1

Where	HT0322.DivisionID = @DivisionID
		and HT0322.TranMonth = @TranMonth 
		and HT0322.TranYear = @TranYear 
		and HT0322.VoucherID =@VoucherID
		and HT0323.Status = @StatusReduce
		and HT0323.EmployeeID in (Select EmployeeID From HT0315 Where DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear
									And ConditionTypeID = '2')
	
ORDER BY Status ASC, ChildStatus ASC, SoInsuranceNo DESC,TotalRate DESC,TotalRate_Dec DESC




GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
