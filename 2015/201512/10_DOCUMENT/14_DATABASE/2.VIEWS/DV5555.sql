
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
	'Lo�i ��i t��ng' as NOTE,
             'ObjectTypeID' as IDTable, 'AsoftT' as Module,
	DivisionID
FROM AT1101	
Union
Select 
	'AT1202' as TABLENAME,
	'��i t��ng (Nh� cung c�p, kh�ch h�ng)' as NOTE,
             'ObjectID' as IDTable, 'AsoftT' as Module,
	DivisionID
FROM AT1101	
Union

Select 
	'AT1301' as TABLENAME,
	'Ph�n lo�i h�ng t�n kho' as NOTE,
             'InventoryTypeID' as IDTable, 'AsoftT' as Module,
	DivisionID
FROM AT1101	
Union
Select 
	'AT1302' as TABLENAME,
	'H�ng t�n kho' as NOTE,
             'InventoryID' as IDTable, 'AsoftT' as Module,
	DivisionID
FROM AT1101	

Union
Select 
	'OT1001' as TABLENAME,
	'Danh mu�c pha�n loa�i ��n ha�ng' as NOTE,
             'ClassifyID' as IDTable, 'AsoftOP' as Module,
	DivisionID
FROM AT1101	

Union
Select 
	'OT1003' as TABLENAME,
	'Danh mu�c ph��ng th��c thanh toa�n' as NOTE,
             'MethodID' as IDTable, 'AsoftOP' as Module,
	DivisionID
FROM AT1101	

Union
Select 
	'OT1002' as TABLENAME,
	'Danh mu�c ma� pha�n t�ch ��n ha�ng' as NOTE,
             'AnaID' as IDTable, 'AsoftOP' as Module,
	DivisionID
FROM AT1101	

Union
Select 
	'OT1004' as TABLENAME,
	'Danh mu�c khoa�n mu�c ph�' as NOTE,
             'CostID' as IDTable, 'AsoftOP' as Module,
	DivisionID
FROM AT1101	

GO


