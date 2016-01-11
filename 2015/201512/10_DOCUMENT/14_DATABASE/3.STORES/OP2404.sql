
/****** Object:  StoredProcedure [dbo].[OP2404]    Script Date: 12/16/2010 13:39:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


-----VAN HUNG
----- Created by Vo Thanh Huong
----- Date 12/12/2005
----- Purpose: IN PHIEU DIEU DO SAN XUAT BAO BI THUNG
----- Edit By Nguyen Quoc Huy
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [03/08/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[OP2404] @DivisionID nvarchar(50),
				@VoucherID nvarchar(50)				
AS
Declare @sSQL as nvarchar(4000),
		@sSQL1 as nvarchar(4000)

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
		OT2001_Ref.ObjectName,
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
		OT1305.Num13, 
		OT1305.Num14, 
		OT1305.Num15,
		OT1305.L01,
		OT1305.L02,
		OT1305.L00,
		OT1305.L03,
		OT1305.L04,	
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
		LEFT join AT1103 on AT1103.EmployeeID = OT2001.EmployeeID and AT1103.DivisionID = OT2001.DivisionID
		left join (Select FileID, FileNo, FileDate, ObjectID, FileType, Type, EndDate, RegisNo, Description, 
				ProductID, PUnitID,  UnitPrice,
				Var01, Var02, Var03, Var04, Var05, Var06, Var07, Var08, Var09, Var10, 
				Date01, 
				Num01, Num02, Num03, Num04, Num05, Num06, Num07, Num08, Num09, Num10, -- Num11,--Num12 So lop
				Num13, Num14, Num15,
				sum(case when  AT1302_M.S1 = OT1306.SMaterial01ID   then Num12 else 0 end) as L01,
				sum(case when  AT1302_M.S1 = OT1306.SMaterial02ID   then Num12 else 0 end) as L02,
				sum(case when  AT1302_M.S1 = OT1306.SMaterial04ID   then Num12 else 0 end) as L00,
				sum(case when  AT1302_M.S1 = OT1306.SMaterial03ID    and Num11 = 1 then Num12 else 0 end) as L03,
				sum(case when  AT1302_M.S1 =OT1306.SMaterial03ID  and Num11 <> 1  then Num12 else 0 end) as L04	
			From OT1305 inner join AT1302 AT1302_M on AT1302_M.InventoryID = OT1305.MaterialID		
				left join OT1306 on OT1306.C01 = OT1306.C01	
			Where FileType = 2
			GROUP BY FileID, FileNo,FileDate, ObjectID, FileType, Type, EndDate, RegisNo, Description, 
				ProductID, PUnitID,  UnitPrice,
				Var01, Var02, Var03, Var04, Var05, Var06, Var07, Var08, Var09, Var10, 
				Date01, 
				Num01, Num02, Num03, Num04, Num05, Num06, Num07, Num08, Num09, Num10, -- Num11,--Num12 So lop
				Num13, Num14, Num15)  OT1305 
			 on OT1305.FileID = OT2002.FileID  and OT1305.ProductID = OT2002.InventoryID
Where OT2001.DivisionID = ''' + @DivisionID + ''' and 
		OT2001.SOrderID = ''' + @VoucherID + ''''
Set @sSQL1 = ' 
UNION 
Select	OT2002.DivisionID, 
		'''' as VoucherNo, 
		'''' as OrderDate, 
		'''' as VDescription , 
		'''' as EmployeeID, 
		'''' as FullName,  		
		'''' as DepartmentID, 
		'''' as DepartmentName, 
		1 as FileType,		
		'''' as ShipDate,	

		OT2002.Orders,
		OT2002.FileID, 
		OT1305.FileNo as FileNo,
		OT2001_Ref.ObjectID,
		'''' as ObjectName,
		0 as SourceNo, 
		'''' as RefOrderID, 
		OT2002.InventoryID, 
		AT1302.InventoryName, 
		'''' as UnitName,
		0 as OrderQuantityRef,
		0 as OrderQuantity, 
		0 as StockQuantity, 
		0 as Cal01, 
		0 as Cal02, 
		0 as Cal03, 
		0 as Cal04, 
		0 as Cal05, 
		0 as Cal06, 
		0 as Cal07,
		0 as Cal08, 
		0 as Cal09, 
		0 as Cal10,
		'''' as  Var01, 
		'''' as  Var02, 
		'''' as  Var03,
		'''' as  Var04, 
		'''' as  Var05, 
		'''' as  Var06, 
		'''' as  Var07, 
		'''' as  Var08, 
		'''' as  Var09, 
		'''' as Var10, 
		'''' as Date01, 
		0 as Num01, 
		0 as Num02, 
		0 as Num03, 
		0 as Num04, 
		0 as Num05, 
		0 as Num06, 
		0 as Num07, 
		0 as Num08, 
		0 as Num09, 
		0 as Num10, 
		0 as Num13, 
		0 as Num14, 
		0 as Num15,
		0 as L01,
		0 as L02,
		0 as L00,
		0 as L03,
		0 as L04,
		'''' as TDescription,
		2 as Parts
From OT2002  inner join AT1302 on OT2002.InventoryID = AT1302.InventoryID 		
	left join OT2001 OT2001_Ref on OT2001_Ref.SOrderID = OT2002.RefOrderID
	left join (Select Distinct FileID, FileNo From OT1305) OT1305 on OT1305.FileID = OT2002.FileID
Where OT2002.SOrderID = ''' + @VoucherID + ''''
--print @sSQL
IF not exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2404')
	EXEC('Create view OV2404 --tao boi OP2404
			as ' + @sSQL + @sSQL1)
ELSE 
	EXEC('Alter view OV2404 --tao boi OP2404
			as ' + @sSQL + @sSQL1)