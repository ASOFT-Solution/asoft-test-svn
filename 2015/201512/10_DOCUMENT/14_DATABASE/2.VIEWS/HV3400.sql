/****** Object:  View [dbo].[HV3400]    Script Date: 06/07/2012 13:34:17 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[HV3400]'))
DROP VIEW [dbo].[HV3400]
GO
/****** Object:  View [dbo].[HV3400]    Script Date: 06/07/2012 13:34:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


----- Created by Nguyen Van Nhan
----- Created Date 05/05/2004
----- View chet tinh luong nhan vien
----- Modify on 01/08/2013 by Bao Anh: Bo sung 10 khoan thu nhap (Hung Vuong)

CREATE VIEW [dbo].[HV3400] as 
Select TransactionID,
        	HT3400.EmployeeID,
	HV1400.FullName,
	HT3400.DivisionID,
        	HT3400.TranMonth,
	HT3400.TranYear,
	HT3400.DepartmentID,         --- Phong ban
	HT3400.TeamID,             --- To nhom  
	IsNull(HV1400.DutyID,'') as DutyID,
	GeneralCo,             	-- He so chung
	GeneralAbsentAmount,    ---Ngay cong quy doi
	
	HT2400.SalaryCoefficient as C11 ,   HT2400.TimeCoefficient as C12 ,    HT2400.DutyCoefficient  as C13 ,    
	HT2400.BaseSalary   as SA01,         HT2400.Salary01   as SA03   ,
	HT2400.InsuranceSalary as SA02 ,    HT2400.Salary02    as SA04   ,       HT2400.Salary03  as SA05  ,          HT2400.C01              ,     HT2400.C02      ,             HT2400.C03   ,       
	HT2400.C04    ,               HT2400.C05     ,              HT2400.C06          ,         HT2400.C07              ,     HT2400.C08        ,
	HT2400.C09       ,            HT2400.C10   ,

	IGAbsentAmount01, IGAbsentAmount02, IGAbsentAmount03, IGAbsentAmount04, IGAbsentAmount05,
	IGAbsentAmount06,IGAbsentAmount07,IGAbsentAmount08,
	IGAbsentAmount09,IGAbsentAmount10,
	IGAbsentAmount11, IGAbsentAmount12,IGAbsentAmount13,IGAbsentAmount14, IGAbsentAmount15,
	IGAbsentAmount16,IGAbsentAmount17,IGAbsentAmount18,
	IGAbsentAmount19,IGAbsentAmount20,
	IGAbsentAmount21, IGAbsentAmount22,IGAbsentAmount23,IGAbsentAmount24, IGAbsentAmount25,
	IGAbsentAmount26,IGAbsentAmount27,IGAbsentAmount28,
	IGAbsentAmount29,IGAbsentAmount30,
	
	Income01,              Income02,              Income03,              
	Income04,              Income05,              Income06,              Income07,
        	Income08 ,             Income09,              Income10,         
	Income11,              Income12,              Income13,              
	Income14,              Income15,              Income16,              Income17,
        	Income18 ,             Income19,              Income20,       
    Income21, Income22, Income23, Income24, Income25, Income26, Income27, Income28, Income29, Income30,
        	InsAmount,
        	HeaAmount,     ----- BHYT        
	TempAmount ,   --  Tam Ung         
	TraAmount,        --- BHXH     
	TaxAmount,   	--- Thue thu nhap
        	SubAmount01,           SubAmount02,           SubAmount03,           SubAmount04,
        	SubAmount05, SubAmount06, SubAmount07, SubAmount08, SubAmount09, SubAmount10, 
	SubAmount11,           SubAmount12,           SubAmount13,           SubAmount14,
        	SubAmount15, SubAmount16, SubAmount17, SubAmount18, SubAmount19, SubAmount20, 
	Isnull(Income01, 0) + Isnull(Income02, 0)  + Isnull(Income03, 0)  + Isnull(Income04, 0)  + Isnull(Income05, 0) + 
	Isnull(Income06, 0) + Isnull(Income07, 0)  + Isnull(Income08, 0)  + Isnull(Income09, 0)  + Isnull(Income10, 0) +
	Isnull(Income11, 0) + Isnull(Income12, 0)  + Isnull(Income13, 0)  + Isnull(Income14, 0)  + Isnull(Income15, 0) + 
	Isnull(Income16, 0) + Isnull(Income17, 0)  + Isnull(Income18, 0)  + Isnull(Income19, 0)  + Isnull(Income20, 0) +
	Isnull(Income21, 0) + Isnull(Income22, 0)  + Isnull(Income23, 0)  + Isnull(Income24, 0)  + Isnull(Income25, 0) +
	Isnull(Income26, 0) + Isnull(Income27, 0)  + Isnull(Income28, 0)  + Isnull(Income29, 0)  + Isnull(Income30, 0) - 
	Isnull(SubAmount01, 0) - Isnull(SubAmount02, 0)  - Isnull(SubAmount03, 0)  - Isnull(SubAmount04, 0)  - Isnull(SubAmount05, 0) -
	Isnull(SubAmount06, 0) - Isnull(SubAmount07, 0)  - Isnull(SubAmount08, 0)  - Isnull(SubAmount09, 0)  - Isnull(SubAmount10, 0) - 
	Isnull(SubAmount11, 0) - Isnull(SubAmount12, 0)  - Isnull(SubAmount13, 0)  - Isnull(SubAmount14, 0)  - Isnull(SubAmount15, 0) -
	Isnull(SubAmount16, 0) - Isnull(SubAmount17, 0)  - Isnull(SubAmount18, 0)  - Isnull(SubAmount19, 0)  - Isnull(SubAmount20, 0) -Isnull(TaxAmount, 0) 
	as SalaryAmount, 
	Isnull(Income01, 0) + Isnull(Income02, 0)  + Isnull(Income03, 0)  + Isnull(Income04, 0)  + Isnull(Income05, 0) + 
	Isnull(Income06, 0) + Isnull(Income07, 0)  + Isnull(Income08, 0)  + Isnull(Income09, 0)  + Isnull(Income10, 0) +
	Isnull(Income11, 0) + Isnull(Income12, 0)  + Isnull(Income13, 0)  + Isnull(Income14, 0)  + Isnull(Income15, 0) + 
	Isnull(Income16, 0) + Isnull(Income17, 0)  + Isnull(Income18, 0)  + Isnull(Income19, 0)  + Isnull(Income20, 0) +
	Isnull(Income21, 0) + Isnull(Income22, 0)  + Isnull(Income23, 0)  + Isnull(Income24, 0)  + Isnull(Income25, 0) +
	Isnull(Income26, 0) + Isnull(Income27, 0)  + Isnull(Income28, 0)  + Isnull(Income29, 0)  + Isnull(Income30, 0) -  
	Isnull(SubAmount01, 0) - Isnull(SubAmount02, 0)  - Isnull(SubAmount03, 0)  - Isnull(SubAmount04, 0)  - Isnull(SubAmount05, 0) -
	Isnull(SubAmount06, 0) - Isnull(SubAmount07, 0)  - Isnull(SubAmount08, 0)  - Isnull(SubAmount09, 0)  - Isnull(SubAmount10, 0) - 
	Isnull(SubAmount11, 0) - Isnull(SubAmount12, 0)  - Isnull(SubAmount13, 0)  - Isnull(SubAmount14, 0)  - Isnull(SubAmount15, 0) -
	Isnull(SubAmount16, 0) - Isnull(SubAmount17, 0)  - Isnull(SubAmount18, 0)  - Isnull(SubAmount19, 0)  - Isnull(SubAmount20, 0) 
	as SalaryBeforeMinusTax,
        	PayrollMethodID,   ---- PP tinh luong
       	HV1400.Orders, 
       	HT3400.CreatedUserID, 
       	HT3400.CreateDate, 
       	HT3400.LastModifyUserID, 
       	HT3400.LastModifyDate, 
       	HT3400.CreateUserID      

From HT3400 inner join HT2400 on HT3400. DivisionID=HT2400.DivisionID and HT3400.EmployeeID=HT2400.EmployeeID 
and HT3400.DepartmentID=HT2400.DepartmentID and IsNull(HT3400.TeamID,'')=IsNull(HT2400.TeamID,'')
and HT3400.TranMonth=HT2400.TranMonth and HT3400.TranYear=HT2400.TranYear

 inner join HV1400 on HV1400.EmployeeID = HT3400.EmployeeID and HV1400.DivisionID = HT3400.DivisionID
GO


