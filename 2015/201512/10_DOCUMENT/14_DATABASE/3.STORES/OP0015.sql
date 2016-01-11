
/****** Object:  StoredProcedure [dbo].[OP0015]    Script Date: 12/16/2010 14:14:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



---- Created by Vo Thanh Huong
---- Date 11/08/2004
---- Purpose: Loc ra cac don hang  mua co tien do nhan hang cho man hinh truy van  tien do nhan hang
---- Thuy Tuyen, date 23/10/2009

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/


ALTER PROCEDURE [dbo].[OP0015]
 AS
Declare @sSQL1 as nvarchar(4000),
	 @sSQL11 as nvarchar(4000),
	@sSQL2 as nvarchar(4000),
	@sSQL22 as nvarchar(4000)

---- Buoc  2 : Tra ra thong tin master  View OV0019

Set @sSQL1 =N' Select OT3001.POrderID, OT3001.VoucherTypeID, VoucherNo, OT3001.DivisionID, OT3001.TranMonth, OT3001.TranYear,
		OrderDate, OT3001.InventoryTypeID, InventoryTypeName, OT3001.CurrencyID, CurrencyName, 	
		OT3001.ExchangeRate,  OT3001.PaymentID,
		OT3001.ObjectID,  case when isnull(OT3001.ObjectName,'''') = '''' then  AT1202.ObjectName else OT3001.ObjectName end as ObjectName, 
		case when isnull(OT3001.VatNo,'''') = '''' then AT1202.VatNo else OT3001.VatNo end as VatNo,  
		case when isnull( OT3001.Address,'''') = '''' then AT1202.Address else OT3001.Address end as Address,
		ReceivedAddress, OT3001.ClassifyID, ClassifyName, OT3001.Transport,
		OT3001.EmployeeID,  AT1103.FullName,  IsSupplier, IsUpdateName, IsCustomer,
		ConvertedAmount = (Select Sum(isnull(ConvertedAmount,0)- isnull(DiscountConvertedAmount,0))  From OT3002 Where OT3002.POrderID = OT3001.POrderID),
		OriginalAmount = (Select Sum(isnull(OriginalAmount,0)- isnull(DiscountOriginalAmount,0))  From OT3002 Where OT3002.POrderID = OT3001.POrderID),
		VATConvertedAmount = (Select Sum(isnull(VATConvertedAmount,0)) From OT3002 Where OT3002.POrderID = OT3001.POrderID),
		VATOriginalAmount = (Select Sum(isnull(VATOriginalAmount,0)) From OT3002 Where OT3002.POrderID = OT3001.POrderID),
		DiscountConvertedAmount = (Select Sum(isnull(DiscountConvertedAmount,0)) From OT3002 Where OT3002.POrderID = OT3001.POrderID),
		OT3001.Notes, OT3001.Disabled, 
		OT3001.OrderStatus,  OV1001.Description as OrderStatusName,  OV1001.EDescription as EOrderStatusName, 
		OT3001.OrderType,  OV1002.Description as OrderTypeName,
		Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
		OT3001.CreateUserID, OT3001.CreateDate, 
		OT3001.LastModifyUserID, OT3001.LastModifyDate,0 as ActualQuantity, 0 as RemainQuantity'
	
Set @sSQL11 =N'
	From OT3001 left join AT1202 on AT1202.ObjectID = OT3001.ObjectID and AT1202.DivisionID = OT3001.DivisionID
		inner join OT3003 on OT3003.POrderID = OT3001.POrderID and OT3003.DivisionID = OT3001.DivisionID
		left join AT1301 on AT1301.InventoryTypeID = OT3001.InventoryTypeID  and AT1301.DivisionID = OT3001.DivisionID
		inner join AT1004 on AT1004.CurrencyID = OT3001.CurrencyID and AT1004.DivisionID = OT3001.DivisionID
		left join AT1103 on AT1103.EmployeeID = OT3001.EmployeeID and AT1103.DivisionID = OT3001.DivisionID 
		left join OT1001 on OT1001.ClassifyID = OT3001.ClassifyID and OT1001.TypeID = ''PO'' and OT1001.DivisionID = OT3001.DivisionID
		left join OV1001 on OV1001.OrderStatus = OT3001.OrderStatus and OV1001.TypeID= ''PO'' and OV1001.DivisionID = OT3001.DivisionID
		left join OV1002 on OV1002.OrderType = OT3001.OrderType and OV1002.TypeID =''PO'' and OV1002.DivisionID = OT3001.DivisionID'

---- Buoc  2 : Tra ra thong tin Detail View OV0020

	Set @sSQL2= N'Select OT3002.DivisionID, OT3002.POrderID, OT3002.TransactionID, 
		OT3001.VoucherTypeID, VoucherNo, OrderDate, OT3001.InventoryTypeID, InventoryTypeName, IsStocked,
		OT3002.InventoryID, InventoryName, AT1302.UnitID, UnitName, 
		OT3002.MethodID, MethodName, OT3002.OrderQuantity, PurchasePrice, ConvertedAmount, OriginalAmount, 
		VATConvertedAmount, VATOriginalAmount, OT3002.VATPercent, DiscountConvertedAmount,  DiscountOriginalAmount,
		DiscountPercent, IsPicking, OT3002.WareHouseID, WareHouseName, 
		Quantity01, Quantity02, Quantity03, Quantity04, Quantity05, Quantity06, Quantity07, Quantity08, Quantity09, Quantity10,
		Quantity11, Quantity12, Quantity13, Quantity14, Quantity15, Quantity16, Quantity17, Quantity18, Quantity19, Quantity20, 
		Quantity21, Quantity22, Quantity23, Quantity24, Quantity25, Quantity26, Quantity27, Quantity28, Quantity29, Quantity30,
		Date01, Date02, Date03, Date04, Date05, Date06, Date07, Date08, Date09, Date10, 
		Date11, Date12, Date13, Date14, Date15, Date16, Date17, Date18, Date19, Date20, 
		Date21, Date22, Date23, Date24, Date25, Date26, Date27, Date28, Date29, Date30,
		ActualQuantity, EndQuantity as RemainQuantity ,OT3002.ConvertedQuantity'
	
	Set @sSQL22= N'
	From OT3002 left join AT1302 on AT1302.InventoryID= OT3002.InventoryID and  AT1302.DivisionID = OT3002.DivisionID
		left join OT1003 on OT1003.MethodID = OT3002.MethodID  and  OT1003.DivisionID = OT3002.DivisionID
		inner join OT3001 on OT3001.POrderID = OT3002.POrderID and  OT3001.DivisionID = OT3002.DivisionID
		left join AT1303 on AT1303.WareHouseID = OT3002.WareHouseID and AT1303.DivisionID = OT3002.DivisionID 
		left join AT1301 on AT1301.InventoryTypeID = OT3001.InventoryTypeID 	 and  AT1301.DivisionID = OT3002.DivisionID
		left join AT1304 on AT1304.UnitID = AT1302.UnitID and  AT1304.DivisionID = OT3002.DivisionID
		inner join OT3003 on OT3003.POrderID = OT3001.POrderID and  OT3003.DivisionID = OT3002.DivisionID
		left join OV2902 on OV2902.POrderID = OT3002.POrderID and OV2902.TransactionID = OT3002.TransactionID and  OV2902.DivisionID = OT3002.DivisionID'

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV0019')
	Exec('Create View OV0019 ---tao boi OP0015
		 as '+@sSQL1+@sSQL11)
Else
	Exec('Alter View OV0019 ---tao boi OP0015
		 as '+@sSQL1+@sSQL11)

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV0020')	
	Exec('Create View OV0020  --tao boi OP0015
		as '+@sSQL2+@sSQL22)
Else
	Exec('Alter View OV0020  --- tao boi OP0015
		as '+@sSQL2+@sSQL22)