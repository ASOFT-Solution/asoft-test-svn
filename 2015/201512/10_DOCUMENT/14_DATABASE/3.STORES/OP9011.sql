IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP9011]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP9011]
GO
/****** Object:  StoredProcedure [dbo].[OP9011]    Script Date: 12/20/2010 16:22:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created by Nguyen Quoc Huy
---- Date 02/03/2009
---- Purpose: Loc ra cac Debit Note len truy van
--22/04/2009, 
-- Last Edit Tuyen,sua  view OV9011 giong view OV911, date: 13/11/2009,16/11/2009
-- Edit: Thuy Tuyen, date 27/11/2009. cai thien toc do.. yeu cau 1 debit not chi ke thua cho mot hoa don
--- Edit:Thuy Tuyen, date 03/03/2009, cai thien toc do tim kiem theo ngay (Master)
--- Edit:Thuy Tuyen, date 08/04/2010, xu ly Isnull cho O03ID
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[OP9011] @DivisionID nvarchar(50)
				
 AS
Declare @sSQL1 nvarchar(4000), @sSQL2 nvarchar(4000)
	

----- Buoc  1 : Tra ra thong tin Master View OV9011 ( Load Edit)
/*

Set @sSQL1 =' 
Select OT2001.SOrderID, 
		OT2001.VoucherTypeID, 
		OT2001.VoucherNo, 
		OT2001.DivisionID, 
		OT2001.TranMonth, 
		OT2001.TranYear,
		OT2001.OrderDate, 
		OT2001.ContractNo, 
		OT2001.ContractDate, 
		OT2001.InventoryTypeID, 
		InventoryTypeName,  
		OT2001.CurrencyID, 
		CurrencyName, 	
		OT2001.ExchangeRate,  
		OT2001.PaymentID, 
		OT2001.DepartmentID,  
		AT1102.DepartmentName, 
		IsPeriod, 
		IsPlan, 
		OT2001.ObjectID,  
		isnull(OT2001.ObjectName, AT1202.ObjectName)   as ObjectName, 
		isnull(OT2001.VatNo, AT1202.VatNo)  as VatNo, 
		isnull( OT2001.Address, AT1202.Address)  as Address,
		OT2001.DeliveryAddress, 
		OT2001.ClassifyID, 
		ClassifyName, 
		OT2001.InheritSOrderID,
		OT2001.EmployeeID,  
		AT1103.FullName,  
		OT2001.Transport, 
		AT1202.IsUpdateName, 
		AT1202.IsCustomer, 
		AT1202.IsSupplier,
		ConvertedAmount = (Select Sum(isnull(ConvertedAmount,0)- isnull(DiscountConvertedAmount,0)- isnull(CommissionCAmount,0) +
		isnull(VATConvertedAmount, 0))  From OT2002 Where OT2002.SOrderID = OT2001.SOrderID),
		OriginalAmount = (Select Sum(isnull(OriginalAmount,0)- isnull(DiscountOriginalAmount,0) - isnull(CommissionOAmount, 0) +
		isnull(VAToriginalAmount, 0))  From OT2002 Where OT2002.SOrderID = OT2001.SOrderID),
		OT2001.Notes, 
		OT2001.Disabled, 
		OT2001.OrderStatus, 
		OV1001.Description as OrderStatusName, 
		OV1001.EDescription as EOrderStatusName, 
		QuotationID,
		OT2001.OrderType,  
		OV1002.Description as OrderTypeName,
		Ana01ID, 
		Ana02ID, 
		Ana03ID, 
		Ana04ID, 
		Ana05ID, 
		OT1002_1.AnaName as Ana01Name, 
		OT1002_2.AnaName as Ana02Name, 
		OT1002_3.AnaName as Ana03Name, 
		OT1002_4.AnaName as Ana04Name, 
		OT1002_5.AnaName as Ana05Name, 
		OT2001.CreateUserID, 
		OT2001.CreateDate, 
		SalesManID, 
		AT1103_2.FullName as SalesManName, 
		ShipDate, 
		OT2001.LastModifyUserID, 
		OT2001.LastModifyDate, 
		OT2001.DueDate, 
		OT2001.PaymentTermID,
		OT2001.contact,
		OT2001.VATObjectID,
		 isnull(OT2001.VATObjectName,T02.ObjectName) as  VATObjectName,
		OT2001.IsInherit,  AT1202.Tel, AT1202.Contactor, AT1202.Email,
		(select   top 1   invoiceNo  from AT9000 where  OrderID =Ot2001.SorderID ) as VATInvoiceNo,
		(select sum( OriginalAmount)  from AT9000 where   OrderID =Ot2001.SorderID)  as VATInvoiceAmount,
		RefNo01, RefNo02, AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID    
From OT2001 left join AT1202 on AT1202.ObjectID = OT2001.ObjectID
		 left join AT1202 T02 on T02.ObjectID = OT2001.VATObjectID
		left join OT1002 OT1002_1 on OT1002_1.AnaID = OT2001.Ana01ID and OT1002_1.AnaTypeID = ''S01''
		left join OT1002 OT1002_2 on OT1002_2.AnaID = OT2001.Ana02ID and OT1002_2.AnaTypeID = ''S02''
		left join OT1002 OT1002_3 on OT1002_3.AnaID = OT2001.Ana03ID and OT1002_3.AnaTypeID = ''S03''
		left join OT1002 OT1002_4 on OT1002_4.AnaID = OT2001.Ana04ID and OT1002_4.AnaTypeID = ''S04''
		left join OT1002 OT1002_5 on OT1002_5.AnaID = OT2001.Ana05ID and OT1002_5.AnaTypeID = ''S05''

		
		left join AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID 
		left join AT1004 on AT1004.CurrencyID = OT2001.CurrencyID
		left join AT1103 on AT1103.EmployeeID = OT2001.EmployeeID and AT1103.DivisionID = OT2001.DivisionID 
		left join AT1103 AT1103_2 on AT1103_2.EmployeeID = OT2001.EmployeeID and AT1103_2.DivisionID = OT2001.DivisionID 
		left join AT1102 on AT1102.DepartmentID = OT2001.DepartmentID  and AT1102.DivisionID = OT2001.DivisionID
		left join OT1001 on OT1001.ClassifyID = OT2001.ClassifyID and OT1001.TypeID = ''SO'' 
		left join OV1001 on OV1001.OrderStatus = OT2001.OrderStatus and OV1001.TypeID = case when OT2001.OrderType <> 1 then ''SO'' else 
									''MO'' end 
		left join OV1002 on OV1002.OrderType = OT2001.OrderType and OV1002.TypeID =''SO''
		Where  OT2001.DivisionID = ''' + @DivisionID + ''''		


If exists (Select top 1 1 From SysObjects Where name = 'OV9011' and Xtype ='V') 
	Drop view OV9011
Exec ('Create view OV9011  --tao boi OP9011
		as '+@sSQL1)
*/
----- Buoc  1 .1: Tra ra thong tin Master View OV9111 ( De load truy van)
  -- tao view lay so tien, so haon don  da lap hoa don, 
Set @sSQL1 = 
'
Select Top 100 percent 
	DivisionID,
	Sum( isnull (OriginalAmount,0)) as  VATInvoiceAmount, OrderID, invoiceNo 
From AT9000
Group by DivisionID, InvoiceNo, OrderID
----having isnull (OrderID,'''') <>''''
Order by OrderID'
If exists (Select top 1 1 From SysObjects Where name = 'OV9011a' and Xtype ='V') 
	Exec ('Alter view OV9011a  --tao boi OP9011 as '+@sSQL1)
else 
	Exec ('Create view OV9011a  --tao boi OP9011 as '+@sSQL1)

Set @sSQL1 =' 
Select  
		Top 100 percent 
		OT2001.DivisionID,
		OT2001.SOrderID, 
		OT2001.VoucherTypeID, 
		OT2001.VoucherNo, 
		OT2001.DivisionID, 
		OT2001.TranMonth, 
		OT2001.TranYear,
		isnull(OT2001.OrderDate,'''') as OrderDate , 
		OT2001.ContractNo, 
		OT2001.ContractDate, 
		OT2001.InventoryTypeID, 
		InventoryTypeName,  
		OT2001.CurrencyID, 
		CurrencyName, 	
		OT2001.ExchangeRate,  
		OT2001.PaymentID, 
		OT2001.DepartmentID,  
		AT1102.DepartmentName, 
		IsPeriod, 
		IsPlan, 
		OT2001.ObjectID,  
		isnull(OT2001.ObjectName, AT1202.ObjectName)   as ObjectName, 
		isnull(OT2001.VatNo, AT1202.VatNo)  as VatNo, 
		isnull( OT2001.Address, AT1202.Address)  as Address,
		OT2001.DeliveryAddress, 
		OT2001.ClassifyID, 
		ClassifyName, 
		OT2001.InheritSOrderID,
		OT2001.EmployeeID,  
		AT1103.FullName,  
		OT2001.Transport, 
		AT1202.IsUpdateName, 
		AT1202.IsCustomer, 
		AT1202.IsSupplier,
		ConvertedAmount = (Select Sum(isnull(ConvertedAmount,0)- isnull(DiscountConvertedAmount,0)- isnull(CommissionCAmount,0) +
		isnull(VATConvertedAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID),
		OriginalAmount = (Select Sum(isnull(OriginalAmount,0)- isnull(DiscountOriginalAmount,0) - isnull(CommissionOAmount, 0) +
		isnull(VAToriginalAmount, 0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID),
		OT2001.Notes, 
		OT2001.Disabled, 
		OT2001.OrderStatus, 
		OV1001.Description as OrderStatusName, 
		OV1001.EDescription as EOrderStatusName, 
		QuotationID,
		OT2001.OrderType,  
		OV1002.Description as OrderTypeName,
		Ana01ID, 
		Ana02ID, 
		'''' as Ana03ID, 
		'''' as Ana04ID, 
		'''' as Ana05ID, 
		OT1002_1.AnaName as Ana01Name, 
		OT1002_2.AnaName as Ana02Name, 
		'''' as Ana03Name, 
		'''' as Ana04Name, 
		'''' as Ana05Name, 
		OT2001.CreateUserID, 
		OT2001.CreateDate, 
		SalesManID, 
		AT1103.FullName as SalesManName, 
		ShipDate, 
'
set @sSQL2 =
N'		OT2001.LastModifyUserID, 
		OT2001.LastModifyDate, 
		OT2001.DueDate, 
		OT2001.PaymentTermID,
		OT2001.contact,
		OT2001.VATObjectID,
		 isnull(OT2001.VATObjectName,T02.ObjectName) as  VATObjectName,
		OT2001.IsInherit,  AT1202.Tel,  AT1202.Contactor, AT1202.Email,
		OV9011a.invoiceNo as VATInvoiceNo,
		OV9011a. VATInvoiceAmount,
		---(select distinct  invoiceNo  from AT9000 where    VoucherID in (select  VoucherID  from AT9000 where OrderID =Ot2001.SorderID))  as VATInvoiceNo,
		---(select sum( ConvertedAMount)  from AT9000 where    VoucherID in (select  VoucherID  from AT9000 where OrderID =Ot2001.SorderID) ) as VATInvoiceAmount,
		RefNo01, RefNo02,AT1202.O01ID, AT1202.O02ID, ISNULL(AT1202.O03ID,'''') AS O03ID , AT1202.O04ID, AT1202.O05ID    
From OT2001 
		left join AT1202 on AT1202.ObjectID = OT2001.ObjectID
		left join AT1202 T02 on T02.ObjectID = OT2001.VATObjectID
		left join AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID 
		left join AT1004 on AT1004.CurrencyID = OT2001.CurrencyID
		left join AT1103 on AT1103.EmployeeID = OT2001.EmployeeID and AT1103.DivisionID = OT2001.DivisionID 
		left join AT1102 on AT1102.DepartmentID = OT2001.DepartmentID  and AT1102.DivisionID = OT2001.DivisionID
		left join OT1001 on OT1001.ClassifyID = OT2001.ClassifyID and OT1001.TypeID = ''SO'' 
		left join OT1101 OV1001  on OV1001.OrderStatus = OT2001.OrderStatus and OV1001.TypeID = case when OT2001.OrderType <> 1 then ''SO'' else ''MO'' end 
		left join OV1002 on OV1002.OrderType = OT2001.OrderType and OV1002.TypeID =''SO''
		left join OT1002 OT1002_1 on OT1002_1.AnaID = OT2001.Ana01ID and OT1002_1.AnaTypeID = ''S01''
		left join OT1002 OT1002_2 on OT1002_2.AnaID = OT2001.Ana02ID and OT1002_2.AnaTypeID = ''S02''
		Left Join OV9011a on OV9011a.OrderID = OT2001.SOrderID	
Where  OT2001.DivisionID = N''' + @DivisionID + ''' 
Order by OT2001.SorderID, OT2001.OrderDate, AT1202.O03ID, OT2001.ObjectID'

--print @sSQL1
--print @sSQL2

If exists (Select top 1 1 From SysObjects Where name = 'OV9011' and Xtype ='V') 
	Exec ('Alter view OV9011  --tao boi OP9011 as '+@sSQL1 + @sSQL2)
else 
	Exec ('Create view OV9011  --tao boi OP9011 as '+@sSQL1 + @sSQL2)

If exists (Select top 1 1 From SysObjects Where name = 'OV9111' and Xtype ='V') 
	Drop view OV9111
Exec ('Create view OV9111  --tao boi OP9011 as '+@sSQL1 + @sSQL2)

---- Buoc  2 : Tra ra thong tin Detail View OV9012
Set @sSQL1= '
Select 	OT2002.DivisionID,
		OT2002.SOrderID, 
		OT2002.TransactionID, 
		OT2001.VoucherTypeID, 
		VoucherNo, 
		OrderDate,  
		ContractNo, 
		ContractDate, 
		OT2001.InventoryTypeID, 
		InventoryTypeName, 
		IsStocked,
		OT2002.InventoryID, 
		AT1302.InventoryName as AInventoryName, 
		case when isnull(OT2002.InventoryCommonName, '''') = '''' then AT1302.InventoryName else OT2002.InventoryCommonName end as 
		InventoryName, 		
		OT2002.UnitID, 
		UnitName, 
		OT2002.OrderQuantity, 
		SalePrice, 
		ConvertedAmount, 
		OriginalAmount, 
		VATConvertedAmount, 
		VATOriginalAmount, 
		OT2002.VATPercent, 
		DiscountConvertedAmount,  
		DiscountOriginalAmount,
		OT2002.DiscountPercent, 
		OT2002.CommissionPercent, 
		OT2002.CommissionCAmount, 
		OT2002.CommissionOAmount, 
		IsPicking, 
		OT2002.WareHouseID, 
		WareHouseName,  
		OT2002.AdjustQuantity, 
		Quantity01, Quantity02, Quantity03, Quantity04, Quantity05,
		Quantity06, Quantity07, Quantity08, Quantity09, Quantity10,
		Quantity11, Quantity12, Quantity13, Quantity14, Quantity15,
		Quantity16, Quantity17, Quantity18, Quantity19, Quantity20,
		Quantity21, Quantity22, Quantity23, Quantity24, Quantity25,
		Quantity26, Quantity27, Quantity28, Quantity29, Quantity30,		
'
set @sSQL2 = 
N'		OT2002.Date01, OT2002.Date02, OT2002.Date03, OT2002.Date04, OT2002.Date05, 
		OT2002.LinkNo, 
		OT2002.EndDate, 
		OT2002.Orders, 
		OT2002.Description, 
		OT2002.RefInfor,
		OT2002.Ana01ID, 
		OT2002.Ana02ID, 
		T02.AnaName as AnaName02,
		OT2002.Ana03ID,
		T03.AnaName as AnaName03,
		OT2002.Ana04ID, 
		OT2002.Ana05ID,
		ActualQuantity, 
		EndQuantity as RemainQuantity,
		OT2002.Finish ,
		OT2002.Notes,
		OT2002.Notes01, OT2002.Notes02,OT2002.Notes03,OT2002.Notes04,OT2002.Notes05,
		OT2002.ObjectID01, OT2002.RefName01, OT2002.ObjectName01, OT2002.ObjectAddress01, OT2002.ObjectCity01, OT2002.ObjectState01, OT2002.ObjectCntry01, OT2002.ObjectZip01, 
		OT2002.ObjectID02, OT2002.RefName02, OT2002.ObjectName02, OT2002.ObjectAddress02, OT2002.ObjectCity02, OT2002.ObjectState02, OT2002.ObjectCntry02, OT2002.ObjectZip02, 
		--OT2001.contact,
		OT2002.QuotationID,
		OT2002.VATGroupID,
		OT2002.SourceNo,
		OT2002.Cal01,OT2002.cal02,OT2002.Cal03,OT2002.Cal04,OT2002.Cal05,OT2002.Aut, OT2002.Cut,
		OT2002.OrigLocn, OT2002.DestLocn, OT2002.SvType, OT2002.SvAbbrew, 
		OT2002.SurDesc1, OT2002.SurDesc2, OT2002.SurDesc3, OT2002.SurDesc4, 
		OT2002.SurDesc5, OT2002.SurDesc6, OT2002.SurDesc7, OT2002.SurDesc8,ET2002.TemPlateID
From OT2002 left join AT1302 on AT1302.InventoryID= OT2002.InventoryID		
		inner join OT2001 on OT2001.SOrderID = OT2002.SOrderID
		left join AT1303 on AT1303.WareHouseID = OT2002.WareHouseID and AT1303.DivisionID = OT2001.DivisionID 
		left join AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID 	
		left join AT1304 on AT1304.UnitID = AT1302.UnitID
		left join OV2901 on OV2901.SOrderID = OT2002.SOrderID and OV2901.TransactionID = OT2002.TransactionID
		Left Join AT1011 T02 on T02.AnaID = OT2002.Ana02ID
		Left Join AT1011 T03 on T03.AnaID = OT2002.Ana03ID 
		left Join ET2002 on ET2002.TemPlateTransactionID = OT2002.QuotationID 	
'

If exists (Select top 1 1 From SysObjects Where name = 'OV9012' and Xtype ='V') 
	Exec ('Alter view OV9012  --tao boi OP9011 as '+@sSQL1 + @sSQL2)
else 
	Exec ('Create view OV9012  --tao boi OP9011 as '+@sSQL1 + @sSQL2)
