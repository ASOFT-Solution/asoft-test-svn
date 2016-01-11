IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP0322]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP0322]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- <Summary>
---- Đổ nguồn báo cáo danh sách tham gia BHXH, BHYT
---- Create on 30/10/2013 by Khanh Van
---- Modify on 10/02/2014 by Bảo Anh: Sửa cách tính mức đóng tăng/giảm, bỏ các trường hợp tăng/giảm do thai sản/nghỉ ốm/...
---- HP0322 'UN',1,2014

CREATE PROCEDURE [dbo].[HP0322]    
(     
 @DivisionID as nvarchar(50),    
 @TranMonth as int,    
 @TranYear AS int    
)     
AS     
Declare    
@Rate as decimal(28,8),    
@HRate as decimal(28,8)    
Set @Rate = (Select top 1 (SRate+ HRate + TRate + SRate2+ HRate2+ TRate2) from HT2461 where DivisionID=@DivisionID and TranMonth=@TranMonth and TranYear = @TranYear)    
    
Set @HRate = (Select top 1 (HRate +HRate2) from HT2461 where DivisionID=@DivisionID and TranMonth=@TranMonth and TranYear = @TranYear)    
    
    
Select HT0322.DivisionID, HT0322.VoucherID, HT0322.VoucherNo, HT0322.VoucherDate,     
Sum(Case when HT0323.Status in (1) then 1 else 0 end) as IncNumber,    
Sum(Case when HT0323.Status in (5) then 1 else 0 end) as DecNumber,    
Sum(Case when HT0323.Status in (1) then HT0323.InsuranceSalary else 0 end) as IncSalaryAmount,    
Sum(Case when HT0323.Status in (5) then HT0323.OldInsuranceSalary else 0 end) as DecSalaryAmount,    
---Sum(Case when HT0323.Status in (1) then HT0323.InsuranceSalary else 0 end)*@Rate/100 as IncPremiumAmount,    
---Sum(Case when HT0323.Status in (5) then HT0323.OldInsuranceSalary else 0 end)*@Rate/100 as DecPremiumAmount,
Sum(Case when HT0323.Status in (2) then HT0323.InsuranceSalary - HT0323.OldInsuranceSalary else 0 end) as IncPremiumAmount,    
Sum(Case when HT0323.Status in (6) then HT0323.OldInsuranceSalary - HT0323.InsuranceSalary else 0 end) as DecPremiumAmount,    

Sum(Case when HT0323.Status in (5) and isnull(RemainMonth,0)<>0 and Hstatus =0 then HT0323.InsuranceSalary*RemainMonth else 0 end)*@HRate/100 as AdjustAmount,
HT0322.CreateUserID     
     
From HT0322 inner join HT0323 on HT0322.DivisionID = HT0323.DivisionID and HT0322.VoucherID = HT0323.VoucherID    
Where TranMonth = @TranMonth and TranYear = @TranYear and HT0322.DivisionID = @DivisionID    
Group by HT0322.DivisionID, HT0322.VoucherID, HT0322.VoucherNo, HT0322.VoucherDate,  HT0322.CreateUserID
