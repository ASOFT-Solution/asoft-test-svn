

/****** Object:  View [dbo].[HV1112]    Script Date: 01/11/2012 12:26:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[HV1112]'))
DROP VIEW [dbo].[HV1112]
GO



/****** Object:  View [dbo].[HV1112]    Script Date: 01/11/2012 12:26:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----- Created by Nguyen Van Nhan, Date 03/04/04
---- Purpose: Loc ra cac muc luong
----- Update by Le Minh Lam, Date 29/12/11
----- Da ngon ngu trong HRM
CREATE  View [dbo].[HV1112] as 
Select  'BaseSalary' as BaseSalaryFieldID,
	N'HV1112.BaseSalary' as Description, -- Luong can ban
	0 as Orders, 'SA01' as FieldID, 0 as FOrders, DivisionID
FROM AT1101
	
Union 
Select 	'InsuranceSalary' as BaseSalaryFieldID,
	N'HV1112.InsuranceSalary' as Description, -- Luong BHXH
	1 as Orders,  'SA02' as FieldID, 1 as FOrders, DivisionID
FROM AT1101
Union
Select  'SuggestSalary' as BaseSalaryFieldID,
	N'HV1112.SuggestSalary' as Description, -- Luong co dinh
	2 as Orders,  'SA06' as FieldID, 6 as FOrders, DivisionID
FROM AT1101
Union
Select 	'Salary01' as BaseSalaryFieldID,
	N'HV1112.Salary01' as Description, -- Muc Luong 1
	3 as Orders,  'SA03' as FieldID, 2 as FOrders, DivisionID
FROM AT1101

Union
Select 'Salary02' as BaseSalaryFieldID,
	N'HV1112.Salary02' as Description, -- Muc luong 2
	4 as Orders,  'SA04' as FieldID, 3 as FOrders, DivisionID
FROM AT1101
Union
Select	'Salary03' as BaseSalaryFieldID,
	N'HV1112.Salary03' as Description, -- Muc Luong 3
	5 as Orders,  'SA05' as FieldID, 4 as FOrders, DivisionID
FROM AT1101
Union	
Select  'Others' as BaseSalaryFieldID,
	N'HV1112.Others' as Description, -- KHac
	6 as Orders,  'SA07' as FieldID, 5 as FOrders, DivisionID
FROM AT1101




GO


