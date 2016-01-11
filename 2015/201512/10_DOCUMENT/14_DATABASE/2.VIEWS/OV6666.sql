
/****** Object:  View [dbo].[OV6666]    Script Date: 12/16/2010 15:16:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----- Created by Nguyen Thi Thuy Tuyen. Date 13/11/2006
----- View chet loc ra cac chi tieu(Giong AV6666)
-- Last edit : Thuy Tuyen 13/05/2009
ALTER VIEW [dbo].[OV6666] as 

Select DivisionID, 'AC' as SelectionType,
	AccountID as SelectionID,
	AccountName SelectionName
From AT1005 Where Disabled =0 and IsNotShow =0
Union All
Select DivisionID, 'VT' as SelectionType,
	VoucherTypeID as SelectionID,
	VoucherTypeName SelectionName
From AT1007   Where Disabled =0 
Union All

Select DivisionID, 'CV' as SelectionType,
	CurrencyID as SelectionID,
	CurrencyName SelectionName
From AT1004  Where Disabled =0
Union	All
Select DivisionID, 'DV' as SelectionType,
	DivisionID as SelectionID,
	DivisionName SelectionName
From AT1101  Where Disabled =0
	
Union	All
Select DivisionID, 'OB' as SelectionType,
	ObjectID as SelectionID,
	ObjectName SelectionName
From AT1202  Where Disabled =0
Union All


Select DivisionID, 'CO' as SelectionType,
	AccountID as SelectionID,
	AccountName SelectionName
From AT1005  Where Disabled =0

Union  All
Select DivisionID, 'IN' as SelectionType,
	InventoryID as SelectionID,
	InventoryName SelectionName
From AT1302  Where Disabled =0
Union  All
Select 	DivisionID, 'PE' as SelectionType,
	PeriodID as SelectionID,
	Description as SelectionName
From MT1601 Where Disabled =0

Union All  --- Ma phan tich
Select DivisionID, AnaTypeID as SelectionType,
	AnaID as SelectionID,
	AnaName  as SelectionName
From AT1011  Where Disabled =0

Union All 
Select DivisionID, AnaTypeID as SelectionType,
	AnaID as SelectionID,
	AnaName  as SelectionName
From AT1015  Where Disabled =0 

Union  All  --- Phan loai doi tuong
Select DivisionID,  Case when STypeID = 'O01' then 'CO1' 
		Else Case when STypeID = 'O02' then 'CO2' 
			Else Case when STypeID = 'O03' then 'CO3' 
			End End End
			as SelectionType,
	S as SelectionID,
	SName  as SelectionName
From AT1207  Where Disabled =0

Union  All  --- Phan loai mat hang
Select DivisionID,  Case when STypeID = 'I01' then 'CI1' 
		Else Case when STypeID = 'I02' then 'CI2' 
			Else Case when STypeID = 'I03' then 'CI3' 
			End End End
			as SelectionType,
	S as SelectionID,
	SName  as SelectionName
From AT1310  Where Disabled =0
Union  All   --- Don hang ban
Select DivisionID, 'SO' as SelectionType,
	SOrderID as SelectionID,
	VoucherNo SelectionName
From OT2001  Where Disabled =0
Union  All   --- Don hang Mua
Select DivisionID, 'PO' as SelectionType,
	POrderID as SelectionID,
	VoucherNo SelectionName
From OT3001  Where Disabled =0
Union all  --Yeu cau mau hang
Select DivisionID, 'RO' as SelectionType,
	ROrderID as SelectionID,
	VoucherNo SelectionName
From OT3101  Where Disabled =0

Union All  --- Theo thang
Select 	Distinct DivisionID,  'MO' as SelectionType,
	MonthYear as SelectionID,
	MonthYear as SelectionName
FROM AV9999
Union All  --- Theo quy 
Select Distinct DivisionID, 'QU' as SelectionType,
	Quarter as SelectionID,
	Quarter as SelectionName
FROM AV9999
Union All ----- Theo nam
Select 	Distinct DivisionID, 'YE' as SelectionType,
	str(TranYear) as SelectionID,
	str(TranYear) as SelectionName
FROM AV9999


Union  All   --- Phan loai don hang ban
Select DivisionID, 'SCO' as SelectionType,
	ClassifyID as SelectionID,
	ClassifyName  as SelectionName
From OT1001  Where Disabled =0 and TypeID = 'SO'
Union  All   --- Phan loai don hang mua
Select DivisionID, 'PCO' as SelectionType,
	ClassifyID as SelectionID,
	ClassifyName as  SelectionName
From OT1001  Where Disabled =0 and TypeID = 'PO'
Union All
Select DivisionID, AnaTypeID as SelectionType,
	AnaID as SelectionID,
	AnaName  as SelectionName
From OT1002  Where Disabled =0
Union All  --- Theo thang
Select 	Distinct DivisionID, 'OMO' as SelectionType,
	MonthYear as SelectionID,
	MonthYear as SelectionName
FROM OV9999


Union All  --- Theo quy 
Select 	Distinct DivisionID, 'OQU' as SelectionType,
	Quarter as SelectionID,
	Quarter as SelectionName
FROM OV9999
Union All ----- Theo nam
Select 	Distinct DivisionID, 'OYE' as SelectionType,
	str(TranYear) as SelectionID,
	str(TranYear) as SelectionName
FROM OV9999
Union All ----- Theo nam
Select 	Distinct DivisionID, 'OYE' as SelectionType,
	str(TranYear) as SelectionID,
	str(TranYear) as SelectionName
FROM OV9999
Union All	
Select 	Distinct DivisionID, 'EM' as SelectionType,
	EmployeeID as SelectionID,
	FullName as SelectionName
FROM AT1103
Where Disabled = 0
Union All	
Select 	Distinct DivisionID, 'SM' as SelectionType,
	EmployeeID as SelectionID,
	FullName as SelectionName
FROM AT1103
Where Disabled = 0
Union All  
Select DivisionID, 'SSO' as SelectionType,
	Convert ( varchar ,OrderStatus) as SelectionID,
	Description as  SelectionName
From OV1001  Where  TypeID = 'SO'
Union  All   --- Tinh trang don hang Mua
Select DivisionID, 'PSO' as SelectionType,
	Convert ( varchar ,OrderStatus) as SelectionID,
	Description as  SelectionName
From OV1001  Where  TypeID = 'PO'

/*
Union All	
SELECT 'SSO' as SelectionType,
	 '0' AS SelectionID, 
	'Chöa chaáp nhaän' AS SelectionName
Union All	
SELECT 'SSO' as SelectionType,
	'1' AS SelectionID, 
	'Chaáp nhaän' AS SelectionName
Union All	
SELECT 'SSO' as SelectionType,
	'2' AS SelectionID, 
	'Ñang giao haøng' AS SelectionName
Union All	
SELECT 'SSO' as SelectionType, 
	'3' AS SelectionID, 
	'Ñaõ hoaøn taát' AS SelectionName
Union All	
SELECT 'SSO' as SelectionType, 
	'4' AS SelectionID, 
	'Taïm ngöng' AS SelectionName
Union All	
SELECT 'SSO' as SelectionType, 
	'5' AS SelectionID, 
	'Göõ choã ' AS SelectionName

Union All	
SELECT 'SSO' as SelectionType, 
	'9' AS SelectionID, 
	'Huûy boû' AS SelectionName

Union All	
SELECT 'PSO' as SelectionType,
	 '0' AS SelectionID, 
	'Chöa chaáp nhaän' AS SelectionName
Union All	
SELECT 'PSO' as SelectionType,
	'1' AS SelectionID, 
	'Chaáp nhaän' AS SelectionName
Union All	
SELECT 'PSO' as SelectionType,
	'2' AS SelectionID, 
	'Ñang giao haøng' AS SelectionName
Union All	
SELECT 'PSO' as SelectionType, 
	'3' AS SelectionID, 
	'Ñaõ hoaøn taát' AS SelectionName
Union All	
SELECT 'PSO' as SelectionType, 
	'4' AS SelectionID, 
	'Taïm ngöng' AS SelectionName

Union All	
SELECT 'PSO' as SelectionType, 
	'9' AS SelectionID, 
	'Huûy boû' AS SelectionName


*/

GO


