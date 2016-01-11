IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP0318]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP0318]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---- Create on 18/09/2013 by Khanh Van: Load thông tin lên tờ khai BHXH, BHYT
---- Modify on 03/03/2014 by Bảo Anh: Sửa lỗi các thông tin hợp đồng không lên dữ liệu
---- Modify on 28/11/2014 by Quốc Tuấn: Bổ sung thêm 10 N0 từ bảng HT1413

CREATE PROCEDURE [dbo].[HP0318]
(
    @DivisionID nvarchar(50),
    @EmployeeID nvarchar(50)

)
AS

Select HV1400.DepartmentID, HV1400.DepartmentName, HV1400.EmployeeID, HV1400.FullName, HV1400.IsMale, HV1400.Birthday,
HV1400.EthnicName, HV1400.CountryName, HV1400.PermanentAddress, HV1400.FullAddress, HV1400.HomePhone, HV1400.MobiPhone,
HV1400.IdentifyCardNo, HV1400.IdentifyDate, HV1400.IdentifyPlace,HT1413.N01,HT1413.N02 ,HT1413.N03,
HT1413.N04, HT1413.N05, HT1413.N06, HT1413.N07, HT1413.N08, HT1413.N09, HT1413.N10,

(Case when Isnull(HT0305.ContractNo,'') <> '' then HT0305.ContractNo else (select top 1 ContractNo From HT1360 Where DivisionID = @DivisionID And EmployeeID = @EmployeeID Order by SignDate DESC) end) as ContractNo,
(Case when Isnull(HT0305.ContractDate,'') <> '' then HT0305.ContractDate else (select top 1 SignDate From HT1360 Where DivisionID = @DivisionID And EmployeeID = @EmployeeID Order by SignDate DESC) end) as ContractDate,
(Case when Isnull(HT0305.AppliedDate,'') <> '' then HT0305.AppliedDate else (select top 1 SignDate From HT1360 Where DivisionID = @DivisionID And EmployeeID = @EmployeeID Order by SignDate DESC) end) as AppliedDate,
(Case when Isnull(HT0305.ContractTypeID,'') <> '' then HT0305.ContractTypeID else (select top 1 ContractTypeID From HT1360 Where DivisionID = @DivisionID And EmployeeID = @EmployeeID Order by SignDate DESC) end) as ContractTypeID,

(Case when isnull(HT0305.DutyID,'')<>'' then HT0305.DutyID else HV1400.DutyID end) as DutyID,
(Case when isnull(HT0305.DutyID,'')<>'' then (Select DutyName from HT1102 where HT1102.DivisionID=HT0305.DivisionID
											and HT1102.DutyID= HT0305.DutyID) else HV1400.DutyName end) as DutyName,
(Case when isnull(HT0305.InsuranceSalary,0)<>0 then HT0305.InsuranceSalary else HV1400.InsuranceSalary end) as InsuranceSalary,
(Case when isnull(HT0305.Salary01,0)<>0 then HT0305.Salary01 else HV1400.Salary01 end) as Salary01,
(Case when isnull(HT0305.Salary02,0)<>0 then HT0305.Salary02 else HV1400.Salary02 end) as Salary02,
(Case when isnull(HT0305.Salary03,0)<>0 then HT0305.Salary03 else HV1400.Salary03 end) as Salary03,
(Case when isnull(HT0305.SoInsuranceNo,'')<>'' then HT0305.SoInsuranceNo else HV1400.SoInsuranceNo end) as SoInsuranceNo,
(Case when isnull(HT0305.HeInsuranceNo,'')<>'' then HT0305.HeInsuranceNo else HV1400.HeInsuranceNo end) as HeInsuranceNo,
isnull(HT0305.Description1,'') as Description1, isnull(HT0305.Description2,'') as Description2

From HV1400 
LEFT JOIN HT0305 ON HV1400.DivisionID = HT0305.DivisionID and HV1400.EmployeeID = HT0305.EmployeeID
LEFT JOIN HT1413 ON HT1413.DivisionID = HV1400.DivisionID AND HT1413.EmployeeID = HV1400.EmployeeID
Where HV1400.DivisionID =@DivisionID and HV1400.EmployeeID = @EmployeeID

