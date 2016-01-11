IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0311]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0311]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 09/10/2013
--- Purpose: In DS đề nghị hưởng trợ cấp nghỉ DSPHSK sau thai sản
--- Modify on 08/11/2013 by Bảo Anh: Lấy quỹ lương là tổng lương BHXH
--- Modify on 21/11/2013 by Bảo Anh: Lấy tổng số lao động từ danh sách đăng ký BHXH
--- EXEC HP0311 'AS','%','%','%',3,2012,1

CREATE PROCEDURE [dbo].[HP0311] 
				@DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@TeamID nvarchar(50),
				@EmployeeID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@IsQuarter tinyint
AS

Declare @Quarter as varchar(7),
		@BankAccountNo as varchar(50),
		@BankName as varchar(50),
		@EmployeeTotal as int,
		@FemaleTotal as int,
		@SalaryAmount as decimal(28,8)

SELECT @Quarter = [Quarter] from HV9999 WHERE DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear

SELECT @BankAccountNo = BankAccountNo, @BankName = BankName FROM AT1016 WHERE DivisionID = @DivisionID
	And BankAccountID = (Select BankAccountID From HT0000 WHERE DivisionID = @DivisionID)

SELECT @EmployeeTotal = COUNT(*) From HT2460
Inner join HT1400 On HT2460.DivisionID = HT1400.DivisionID And HT2460.EmployeeID = HT1400.EmployeeID
WHERE HT2460.DivisionID = @DivisionID And HT1400.EmployeeStatus in (1,3)

SELECT @FemaleTotal = COUNT(*) From HT2400
Inner join HT1400 On HT2400.DivisionID = HT1400.DivisionID And HT2400.EmployeeID = HT1400.EmployeeID
WHERE HT2400.DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear
AND Isnull(HT1400.IsMale,0) = 0

SELECT @SalaryAmount = SUM(InsuranceSalary) FROM
(
select EmployeeID,TranMonth,sum(InsuranceSalary) as InsuranceSalary from HT2460
Where DivisionID = @DivisionID And EmployeeID in (Select EmployeeID From HT1400 Where DivisionID = @DivisionID And EmployeeStatus in (1,3))
Group by EmployeeID,TranMonth
having TranMonth = (select max(TranMonth) From HT2460 H60 Where H60.DivisionID = @DivisionID And H60.EmployeeID = HT2460.EmployeeID)) A

--- Hiển thị dữ liệu
IF @IsQuarter = 0
	SELECT	H10.*,
			Ltrim(RTrim(isnull(HT00.LastName,'')))+ ' ' + LTrim(RTrim(isnull(HT00.MiddleName,''))) + ' ' + LTrim(RTrim(Isnull(HT00.FirstName,''))) As FullName,
			@Quarter as [Quarter], @BankAccountNo as BankAccountNo, @BankName as BankName,
			@EmployeeTotal as EmployeeTotal, @FemaleTotal as FemaleTotal, @SalaryAmount as SalaryTotal, V03.ConditionTypeName,
			
			(SELECT SUM(Isnull(DATEDIFF(DAY, LeaveFromDate, LeaveToDate),0)) FROM HT0310
			WHERE DivisionID = @DivisionID AND TranYear = @TranYear AND TranMonth <= @TranMonth
			AND EmployeeID = H10.EmployeeID) as BeginLeaveDays			
	FROM	HT0310 H10
	INNER JOIN HT1400 HT00 On H10.DivisionID = HT00.DivisionID And H10.EmployeeID = HT00.EmployeeID
	LEFT JOIN HV0300 V03 On H10.DivisionID = V03.DivisionID And H10.ConditionTypeID = V03.ConditionTypeID And V03.TypeID = 'H01'
	WHERE 	H10.DivisionID = @DivisionID And
			H10.DepartmentID Like @DepartmentID And
			isnull(H10.TeamID,'') Like @TeamID And
			H10.EmployeeID Like @EmployeeID And
			H10.TranMonth = @TranMonth And
			H10.TranYear = @TranYear
	ORDER BY H10.EmployeeID
ELSE
	SELECT	H10.*,
			Ltrim(RTrim(isnull(HT00.LastName,'')))+ ' ' + LTrim(RTrim(isnull(HT00.MiddleName,''))) + ' ' + LTrim(RTrim(Isnull(HT00.FirstName,''))) As FullName,
			@Quarter as [Quarter], @BankAccountNo as BankAccountNo, @BankName as BankName,
			@EmployeeTotal as EmployeeTotal, @FemaleTotal as FemaleTotal, @SalaryAmount as SalaryTotal, V03.ConditionTypeName,
			
			(SELECT SUM(Isnull(DATEDIFF(DAY, LeaveFromDate, LeaveToDate),0)) FROM HT0310
			WHERE DivisionID = @DivisionID AND TranYear = @TranYear AND TranMonth <= @TranMonth
			AND EmployeeID = H10.EmployeeID) as BeginLeaveDays			
	FROM	HT0310 H10
	INNER JOIN HT1400 HT00 On H10.DivisionID = HT00.DivisionID And H10.EmployeeID = HT00.EmployeeID
	LEFT JOIN HV0300 V03 On H10.DivisionID = V03.DivisionID And H10.ConditionTypeID = V03.ConditionTypeID And V03.TypeID = 'H01'
	WHERE 	H10.DivisionID = @DivisionID And
			H10.DepartmentID Like @DepartmentID And
			isnull(H10.TeamID,'') Like @TeamID And
			H10.EmployeeID Like @EmployeeID And
			H10.TranYear = @TranYear And
			H10.TranMonth in (Select TranMonth FROM HV9999 Where DivisionID = @DivisionID And [Quarter] = @Quarter)
	ORDER BY H10.EmployeeID