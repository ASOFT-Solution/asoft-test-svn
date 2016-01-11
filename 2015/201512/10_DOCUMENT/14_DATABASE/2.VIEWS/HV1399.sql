/****** Object:  View [dbo].[HV1399]    Script Date: 12/16/2010 15:14:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---- Created by Dang Le Bao Quynh. Date 02/12/2006
---- Purpose: Chi tiet danh muc don vi tinh chuyen doi. View Chet

ALTER VIEW [dbo].[HV1399] as 
Select 	HT1309.DivisionID, HT1309.InventoryID, ProductName as InventoryName, HT1015.UnitID, B.UnitName ,HT1309.UnitID as ConvertUnitID, C.UnitName as ConvertUnitName,
	HT1309.Orders, 
	Case when HT1309.Operator =0 then  ' 01 '+C.UnitName+' = '+ltrim(rtrim(str(ConversionFactor)))+' '+B.UnitName 
	Else 
		 '01 '+B.UnitName+ ' = '+ltrim(rtrim(str(ConversionFactor)))+' '+C.UnitName End
	as Example,
	HT1309.Disabled,
	ConversionFactor,
	Operator, case when Operator = 0 then '* - Nh©n' 	Else '/ - Chia' End as OperatorName,	
	0 as locked

From HT1309 	inner join HT1015 on HT1015.ProductID = HT1309.InventoryID
		inner join AT1304 B on B.UnitID = HT1015.UnitID
		inner join AT1304 C on C.UnitID = HT1309.UnitID

GO


