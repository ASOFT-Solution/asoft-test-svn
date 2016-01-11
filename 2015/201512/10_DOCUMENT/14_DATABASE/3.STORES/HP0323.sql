IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP0323]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP0323]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- <Summary>
---- Đổ nguồn danh mục khai báo tăng giảm BHXH, BHYT
---- Create on 23/10/2013 by Khanh Van
---- Modified on 22/11/2013 by Khanh Van: Lấy thêm thông tin lương và lao động tăng giảm
---- Modified on 11/03/2013 by Bảo Anh: Bổ sung các trường Từ tháng/năm, Đến tháng/năm phát sinh thay đổi BHXH, BHYT
---- Modified on 11/05/2015 by Bảo Anh: Bổ sung các trường IsIBIssue, IsHIssue, HFromDate, HToDate

CREATE PROCEDURE [dbo].[HP0323]
( 
	@DivisionID as nvarchar(50),
	@TranMonth as int,
	@TranYear AS int,
	@VoucherID as nvarchar(50)
) 
AS 
Declare 
@SRate as decimal(28,8),
@HRate as decimal(28,8),
@TRate as decimal(28,8),
@Rate as decimal(28,8),
@TotalEmployee as int,
@IncNumber as int,
@DecNumber as int,
@IncSalaryAmount as decimal(28,8),
@DecSalaryAmount as decimal(28,8),
@TotalSalary as decimal(28,8)

Select @TotalEmployee=COUNT(EmployeeID), @TotalSalary = SUM(Ht2461.BaseSalary) from HT2461 where DivisionID=@DivisionID and TranMonth=@TranMonth and TranYear=@TranYear

Set @SRate = (Select top 1 (SRate +SRate2) from HT2461 where DivisionID=@DivisionID and TranMonth=@TranMonth and TranYear = @TranYear)
Set @HRate = (Select top 1 (HRate +HRate2) from HT2461 where DivisionID=@DivisionID and TranMonth=@TranMonth and TranYear = @TranYear)
Set @TRate = (Select top 1 (TRate +TRate2) from HT2461 where DivisionID=@DivisionID and TranMonth=@TranMonth and TranYear = @TranYear)
Set @Rate = (Select top 1 (SRate+ HRate + TRate + SRate2+ HRate2+ TRate2) from HT2461 where DivisionID=@DivisionID and TranMonth=@TranMonth and TranYear = @TranYear)
Set @IncNumber =(Select Sum(Case when Status in (1,2) then 1 else 0 end) from HT0323 A
 where A.DivisionID = @DivisionID and A.VoucherID = @VoucherID)    
Set @DecNumber = (Select Sum(Case when Status in (4,6) then 1 else 0 end) from HT0323 A
 where A.DivisionID = @DivisionID and A.VoucherID = @VoucherID)
 Set @IncSalaryAmount= (Select (Sum(Case when Ht0323.Status in (1,2) then (Ht0323.InsuranceSalary) else 0 end))+ (Sum(Case when Ht0323.Status =3 then (Ht0323.InsuranceSalary) - (Ht0323.OldInsuranceSalary) else 0 end))from HT0323 
 where DivisionID = @DivisionID and VoucherID = @VoucherID)        
 Set @DecSalaryAmount= (Select (Sum(Case when Ht0323.Status in (4,6) then (Ht0323.OldInsuranceSalary) else 0 end))+ (Sum(Case when Ht0323.Status =5 then (Ht0323.OldInsuranceSalary) - (Ht0323.InsuranceSalary) else 0 end))from HT0323 
 where DivisionID = @DivisionID and VoucherID = @VoucherID)      

If ISNULL(@VoucherID,'')=''
Begin
	Select	HV1400.DutyName, HT0321.EmployeeID, FullName, DepartmentName, Birthday, isMale,HV1400.IdentifyCardNo, FullAddress, HomePhone, HT0321.Status, HT0321.StatusName, HT0321.OldInsuranceSalary, HT0321.InsuranceSalary, HT0321.HeInsuranceNo, HT0321.SoInsuranceNo, HT0321.Salary01, HT0321.Salary02, HT0321.Salary03, HT0321.OrtherSalary, HT0321.Description, 0 as HStatus, 0 as RemainMonth, 0 as IsHStatus,
			HT0321.MonthYearFrom, HT0321.MonthYearTo, 0 as IsIBIssue, 0 as IsHIssue, NULL as HFromDate, NULL as HToDate
			
From HT0321  
inner join HV1400 on HV1400.DivisionID = HT0321.DivisionID and HV1400.EmployeeID = HT0321.EmployeeID

Where TranMonth = @TranMonth 
		and TranYear = @TranYear 
		and HT0321.DivisionID = @DivisionID 
		and HT0321.EmployeeID not in (Select EmployeeID from HT0323 inner join HT0322 on HT0322.DivisionID = HT0323.DivisionID and HT0322.VoucherID = HT0323.VoucherID where HT0322.DivisionID = @DivisionID and HT0322.TranMonth = @TranMonth and HT0322.Tranyear =@TranYear)

End
Else
Begin
	Select	HV1400.DutyName, HT0322.VoucherID, HT0322.VoucherNo, HT0322.VoucherDate, (CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(VoucherDate)-1),VoucherDate),103)) AS FromMonth, (CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,VoucherDate))),DATEADD(mm,RemainMonth,VoucherDate)),103)) as ToMonth, HT0323.EmployeeID, FullName, DepartmentName, Birthday, isMale, HV1400.IdentifyCardNo, FullAddress, HomePhone,  HT0323.Status, HT0323.StatusName, HT0323.OldInsuranceSalary,0 as oldSalary01, 0 as oldSalary02,0 as oldSalary03,HT0323.InsuranceSalary, HT0323.HeInsuranceNo, HT0323.SoInsuranceNo, HT0323.Salary01, HT0323.Salary02, HT0323.Salary03, HT0323.OrtherSalary, HT0323.Description, HStatus, RemainMonth, @SRate*HT0323.InsuranceSalary as SInsuranceSalary,
			@HRate*HT0323.InsuranceSalary as HInsuranceSalary, @TRate*HT0323.InsuranceSalary as TInsuranceSalary, @TotalEmployee AS TotalEmployee, 	@TotalSalary AS TotalSalary, @SRate AS SRate, @HRate AS HRate,@TRate AS TRate, IsHStatus,
			@IncNumber as IncNumber,   @DecNumber as DecNumber, @IncSalaryAmount as IncSalaryAmount , @DecSalaryAmount as DecSalaryAmount, HT0323.MonthYearFrom, HT0323.MonthYearTo,
			HT0323.IsIBIssue, HT0323.IsHIssue, HT0323.HFromDate, HT0323.HToDate

From HT0323  
inner join HV1400 on HV1400.DivisionID = HT0323.DivisionID and HV1400.EmployeeID = HT0323.EmployeeID
inner join HT0322 on HT0322.DivisionID = HT0323.DivisionID and HT0322.VoucherID = HT0323.VoucherID

Where TranMonth = @TranMonth 
		and TranYear = @TranYear 
		and HT0322.DivisionID = @DivisionID 
		and HT0322.VoucherID =@VoucherID

End