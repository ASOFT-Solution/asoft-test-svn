/****** Object:  View [dbo].[HV3401]    Script Date: 12/16/2010 15:17:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

------ Created by Nguyen Van Nhan, Date 18/05/2004
------ Purpose: In bang luong thang nhan vien

ALTER VIEW [dbo].[HV3401] as 
Select 	HT34.EmployeeID,           
	FullName,
	HT34.DivisionID,
       	HT34.TranMonth,
  	HT34.TranYear,    
	HT34.DepartmentID,         
	HT34.TeamID,               
	HT24.BaseSalary,
	HT24.SalaryCoefficient,             
	sum(isnull(Income01, 0)) as Income01,             
	sum(Isnull(Income02,0)) as Income02,                            
	sum(isnull(Income03,0)) as Income03,                            
	sum(isnull(Income04, 0)) as Income04,             
	sum(Isnull(Income05,0)) as Income05,                            
	sum(isnull(Income06,0)) as Income06,                            
	sum(isnull(Income07, 0)) as Income07,             
	sum(Isnull(Income08,0)) as Income08,                            
	sum(isnull(Income09,0)) as Income09,                            
	sum(isnull(Income10,0)) as Income10,                            
	InsAmount,             
	HeaAmount,             
	TempAmount,            
	TraAmount,             
	TaxAmount,             
	sum(isnull(SubAmount01,0)) as SubAmount01,            
	sum(isnull(SubAmount02,0)) as SubAmount02,            
	sum(isnull(SubAmount03,0)) as SubAmount03,            
	sum(isnull(SubAmount04,0)) as SubAmount04,            
	sum(isnull(SubAmount05,0)) as SubAmount05,            
	HV14.Orders            
From HT3400 Ht34 Inner join HV1400 HV14 on HV14.EmployeeID = HT34.EmployeeID
		 Inner join HT2400 HT24 on 	HT24.EmployeeID = HT34.EmployeeID and
						HT24.TranMonth = HT34.TranMonth and
						HT24.TranYear = HT34.TranYear 
Group by HT34.EmployeeID,           	FullName,	HT34.DivisionID,       	HT34.TranMonth,  	HT34.TranYear,    	HT34.DepartmentID,         
	HT34.TeamID,               	HT24.BaseSalary,	HT24.SalaryCoefficient,     InsAmount,  HeaAmount,             TempAmount,            
	TraAmount,   TaxAmount, HV14.Orders

GO


