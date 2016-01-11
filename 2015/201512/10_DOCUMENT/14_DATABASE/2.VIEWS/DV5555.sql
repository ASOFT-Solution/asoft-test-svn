
/****** Object:  View [dbo].[DV5555]    Script Date: 12/16/2010 16:09:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----- Created by Quoc Huy, Date 03/11/2004
----- View chet chua ten cac table danh muc

ALTER VIEW [dbo].[DV5555] as
Select 
	'AT1201' as TABLENAME,
	'Lo¹i ®èi t­îng' as NOTE,
             'ObjectTypeID' as IDTable, 'AsoftT' as Module,
	DivisionID
FROM AT1101	
Union
Select 
	'AT1202' as TABLENAME,
	'§èi t­îng (Nhµ cung cÊp, kh¸ch hµng)' as NOTE,
             'ObjectID' as IDTable, 'AsoftT' as Module,
	DivisionID
FROM AT1101	
Union

Select 
	'AT1301' as TABLENAME,
	'Ph©n lo¹i hµng tån kho' as NOTE,
             'InventoryTypeID' as IDTable, 'AsoftT' as Module,
	DivisionID
FROM AT1101	
Union
Select 
	'AT1302' as TABLENAME,
	'Hµng tån kho' as NOTE,
             'InventoryID' as IDTable, 'AsoftT' as Module,
	DivisionID
FROM AT1101	

Union
Select 
	'OT1001' as TABLENAME,
	'Danh muïc phaân loaïi ñôn haøng' as NOTE,
             'ClassifyID' as IDTable, 'AsoftOP' as Module,
	DivisionID
FROM AT1101	

Union
Select 
	'OT1003' as TABLENAME,
	'Danh muïc phöông thöùc thanh toaùn' as NOTE,
             'MethodID' as IDTable, 'AsoftOP' as Module,
	DivisionID
FROM AT1101	

Union
Select 
	'OT1002' as TABLENAME,
	'Danh muïc maõ phaân tích ñôn haøng' as NOTE,
             'AnaID' as IDTable, 'AsoftOP' as Module,
	DivisionID
FROM AT1101	

Union
Select 
	'OT1004' as TABLENAME,
	'Danh muïc khoaûn muïc phí' as NOTE,
             'CostID' as IDTable, 'AsoftOP' as Module,
	DivisionID
FROM AT1101	

GO


