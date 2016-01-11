
/****** Object:  StoredProcedure [dbo].[OP2304]    Script Date: 12/16/2010 13:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




-----VAN HUNG
----- Created by Vo Thanh Huong
----- Date 12/12/2005
----- Purpose: IN PHIEU DIEU DO SAN XUAT BAO BI IN
---- Edit by Nguyen Quoc Huy
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [03/08/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[OP2304] @DivisionID nvarchar(50),
				@VoucherID nvarchar(50)				
AS
Declare @sSQL as nvarchar(4000)	

Set @sSQL = ' 
Select  OT2002.DivisionID, 
		OT2001.VoucherNo, 
		OT2001.OrderDate, 
		OT2001.Notes as VDescription , 
		OT2001.EmployeeID, 
		AT1103.FullName,  		
		OT2001.DepartmentID, 
		AT1102.DepartmentName, 
		OT2001.FileType,	
		OT2001_Ref.ShipDate as ShipDate,	
		OT2002.Orders,
		OT2002.FileID, 
		OT1305.FileNo,
		OT2001_Ref.ObjectID,
		--OT2001_Ref.ObjectName,
		AT1202.ObjectName,
		OT2002.SourceNo, 
		OT2002.RefOrderID, 
		OT2002.InventoryID, 
		AT1302.InventoryName, 
		AT1304.UnitName,
		OT2002_Ref.OrderQuantity as OrderQuantityRef,
		OT2002.OrderQuantity, 
		0 StockQuantity, 
		OT2002.Cal01, 
		OT2002.Cal02, 
		OT2002.Cal03, 
		OT2002.Cal04, 
		OT2002.Cal05, 
		OT2002.Cal06, 
		OT2002.Cal07,
		OT2002.Cal08, 
		OT2002.Cal09, 
		OT2002.Cal10,

		OT1305.Var01, 
		OT1305.Var02, 
		OT1305.Var03,
		OT1305.Var04, 
		OT1305.Var05, 
		OT1305.Var06, 
		OT1305.Var07, 
		OT1305.Var08, 
		OT1305.Var09, 
		OT1305.Var10, 
		OT1305.Date01, 
		OT1305.Num01, 
		OT1305.Num02, 
		OT1305.Num03, 
		OT1305.Num04, 
		OT1305.Num05, 
		OT1305.Num06, 
		OT1305.Num07, 
		OT1305.Num08, 
		OT1305.Num09, 
		OT1305.Num10, 
		OT1305.Num11, 
		OT1305.Num12, 
		OT1305.Num13, 
		OT1305.Num14, 
		OT1305.Num15,
		OT1305.MaterialID,
		OT2002.Description as TDescription,	
		1 as Parts

From OT2002  inner join OT2001 on OT2002.SOrderID = OT2001.SOrderID
		left join OT2001 OT2001_Ref on OT2001_Ref.SOrderID = OT2002.RefOrderID
		left join AT1202 on AT1202.ObjectID = OT2001_Ref.ObjectID
		left join OT2002 OT2002_Ref on OT2002_Ref.SOrderID = OT2002.RefOrderID and 
			OT2002_Ref.InventoryID = OT2002.InventoryID
		left join AT1102 on AT1102.DepartmentID = OT2001.DepartmentID  and AT1102.DivisionID = OT2001.DivisionID
		inner join AT1302 on OT2002.InventoryID = AT1302.InventoryID 		
		
		left join AT1304 on AT1304.UnitID = OT2002.UnitID
		left join OT1305 on OT1305.FileID = OT2002.FileID  and OT1305.ProductID = OT2002.InventoryID
		LEFT join AT1103 on AT1103.EmployeeID = OT2001.EmployeeID and AT1103.DivisionID = OT2001.DivisionID
Where OT2001.DivisionID = ''' + @DivisionID + ''' and 
		OT2001.SOrderID = ''' + @VoucherID + ''''

--PRINT @sSQL 

IF not exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2314')
	EXEC('Create view OV2314 --tao boi OP2304
			as ' + @sSQL)
ELSE 
	EXEC('Alter view OV2314 --tao boi OP2304
			as ' + @sSQL)


Set @sSQL = ' Select OV2314.DivisionID, OV2314.VoucherNo,OV2314.OrderDate, 
OV2314.VDescription, OV2314.EmployeeID, 
OV2314.FullName, OV2314.DepartmentID, 
OV2314.DepartmentName, OV2314.FileType, 
OV2314.ShipDate, OV2314.Orders, OV2314.FileID, 
OV2314.FileNo,  

--OV2314.MaterialID,
OV2314.ObjectID, OV2314.ObjectName, OV2314.SourceNo, OV2314.RefOrderID, OV2314.InventoryID, 
OV2314.InventoryName, OV2314.UnitName, OV2314.OrderQuantityRef, OV2314.OrderQuantity, 
OV2314.StockQuantity, OV2314.Cal01, OV2314.Cal02, OV2314.Cal03, OV2314.Cal04, OV2314.Cal05, 
OV2314.Cal06, OV2314.Cal07, OV2314.Cal08, OV2314.Cal09, OV2314.Cal10, OV2314.Var01, OV2314.Var02, 
OV2314.Var03, OV2314.Var04, OV2314.Var05, OV2314.Var06, OV2314.Var07, OV2314.Var08, OV2314.Var09, 
OV2314.Var10, OV2314.Date01, OV2314.Num01, OV2314.Num02, OV2314.Num03, OV2314.Num04, OV2314.Num05, 
OV2314.Num06, OV2314.Num07, OV2314.Num08, OV2314.Num09, OV2314.Num10, OV2314.Num11, OV2314.Num12, 
OV2314.Num13, OV2314.Num14, OV2314.Num15,
OV2314.MaterialID, AT1302.InventoryName as MaterialName,
OV2314.TDescription, OV2314.Parts ,
OV2307.Num02  as ExtraQuantity,
OV2307.PDescription  
--0 as ExtraQuantity
From OV2314 Left join OV2307 on OV2307.SOrderID = OV2314.VoucherNo 
			and OV2307.MaterialID =OV2314.MaterialID 
			and OV2307.ProductID =OV2314.InventoryID
	        Left join AT1302 on AT1302.InventoryID = OV2314.MaterialID  
Where OV2314.VoucherNo = ''' + @VoucherID + '''


UNION
Select OV2314.DivisionID, OV2314.VoucherNo,OV2314.OrderDate, 
OV2314.VDescription, OV2314.EmployeeID, 
OV2314.FullName, OV2314.DepartmentID, 
OV2314.DepartmentName, OV2314.FileType, 
OV2314.ShipDate, OV2314.Orders, OV2314.FileID, 
OV2314.FileNo,  

--OV2314.MaterialID,
OV2314.ObjectID, OV2314.ObjectName, OV2314.SourceNo, OV2314.RefOrderID, OV2314.InventoryID, 
OV2314.InventoryName, OV2314.UnitName, OV2314.OrderQuantityRef, OV2314.OrderQuantity, 
OV2314.StockQuantity, OV2314.Cal01, OV2314.Cal02, OV2314.Cal03, OV2314.Cal04, OV2314.Cal05, 
OV2314.Cal06, OV2314.Cal07, OV2314.Cal08, OV2314.Cal09, OV2314.Cal10, OV2314.Var01, OV2314.Var02, 
OV2314.Var03, OV2314.Var04, OV2314.Var05, OV2314.Var06, OV2314.Var07, OV2314.Var08, OV2314.Var09, 
OV2314.Var10, OV2314.Date01, OV2314.Num01, OV2314.Num02, OV2314.Num03, OV2314.Num04, OV2314.Num05, 
OV2314.Num06, OV2314.Num07, OV2314.Num08, OV2314.Num09, OV2314.Num10, OV2314.Num11, OV2314.Num12, 
OV2314.Num13, OV2314.Num14, OV2314.Num15, 
OV2314.MaterialID,  AT1302.InventoryName as MaterialName,
OV2314.TDescription, 
2 as Parts ,
OV2307.Num02  as ExtraQuantity,
OV2307.PDescription  
--0 as ExtraQuantity
From OV2314 Left join OV2307 on OV2307.SOrderID = OV2314.VoucherNo 
			and OV2307.MaterialID =OV2314.MaterialID 
			and OV2307.ProductID =OV2314.InventoryID
		Left join AT1302 on AT1302.InventoryID = OV2314.MaterialID  
Where OV2314.VoucherNo = ''' + @VoucherID + ''''

--print @sSQL

IF not exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2304')
	EXEC('Create view OV2304 --tao boi OP2304
			as ' + @sSQL)
ELSE 
	EXEC('Alter view OV2304 --tao boi OP2304
			as ' + @sSQL)