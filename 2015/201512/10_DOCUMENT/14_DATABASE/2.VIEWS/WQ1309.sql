
/****** Object:  View [dbo].[WQ1309]    Script Date: 12/16/2010 15:41:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----NGUYEN THI THUY TUYEN
-----VIEW  chet lay du lieu don vi tinh chuyen doi  phan he ASOFT WM.
---- Edit by Tấn Phú, Date 11/06/2012 : Thay giá trị mật định null as DataType thành 0 as DataType
------17/11/2006


ALTER VIEW [dbo].[WQ1309]
as
select AT1309.DivisionID,AT1309.InventoryID, AT1302.UnitID, AT1309.UnitID as ConvertedUnitID, UnitName as ConvertedUnitName, ConversionFactor,Operator,AT1309.FormulaID, FormulaDes,

case when  AT1309.DataType = 0 and Operator = 0 then 'WQ1309.MultiplyStr' Else   case  when AT1309.DataType = 0 and Operator =  1 then   'WQ1309.Divide'  else  '' End End as OperatorName,	
DataType,
case when  AT1309.DataType = 0 then 'WQ1309.Operators' Else Case when    AT1309.DataType = 1  then   'WQ1309.Formula'  End  End as DataTypeName



From AT1309 
Inner Join AT1304 on AT1304.UnitID = AT1309.UnitID And AT1304.DivisionID = AT1309.DivisionID
left join AT1302 on AT1302.InventoryID = AT1309.InventoryID And AT1302.DivisionID = AT1309.DivisionID
Left Join AT1319 on AT1309.FormulaID = AT1319.FormulaID And AT1309.DivisionID = AT1319.DivisionID
Where AT1309.Disabled = 0 
Union
select AT1302.DivisionID,AT1302.InventoryID,AT1302.UnitID, AT1302.UnitID as ConvertedUnitID , UnitName as ConvertedUnitName,1 as ConversionFactor,0 as Operator, null as FormulaID, null as FormulaDes,
 'WQ1309.MultiplyStr' OperatorName, 0 as DataType,  'WQ1309.Operators'as DataTypeName
From AT1302 
Inner Join AT1304 on AT1304.UnitID = AT1302.UnitID And AT1304.DivisionID = AT1302.DivisionID



GO


