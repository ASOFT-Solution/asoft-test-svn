
/****** Object:  StoredProcedure [dbo].[OP0014]    Script Date: 12/16/2010 14:12:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




---- Created by Vo Thanh Huong
---- Date 11/08/2004
---- Purpose: Loc ra cac don hang ban da co lich giao hang cho man hinh truy van tien  do giao hang
--- Thuy Tuyen, date 23/10/2009

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/
---- Modified by Tieu Mai on 15/12/2015: Bổ sung 20 cột quy cách khi có thiết lập quản lý mặt hàng theo quy cách

ALTER PROCEDURE [dbo].[OP0014] @DivisionID nvarchar(50),
				@FromMonth int,
				@FromYear int,
				@ToMonth int,
				@ToYear int
								
AS
Declare @sSQL1 as nvarchar(4000),
	@sSQL11 as nvarchar(4000),
	@sSQL2 as nvarchar(4000),
	@sSQL22 as nvarchar(4000)

----- Buoc  1 : Tra ra thong tin Master View OV0017

Set @sSQL1 =N' 
Select 		OT2001.SOrderID, 	OT2001.VoucherTypeID, 
	VoucherNo, OT2001.DivisionID, OT2001.TranMonth, OT2001.TranYear,
	OrderDate, ContractNo, ContractDate, 
	OT2001.InventoryTypeID, InventoryTypeName,  OT2001.CurrencyID, CurrencyName, 	
	OT2001.ExchangeRate,  OT2001.PaymentID, OT2001.ObjectID,  isnull(OT2001.ObjectName,  AT1202.ObjectName ) as ObjectName, 
	isnull(OT2001.VatNo, AT1202.VatNo)  as VatNo, 	isnull( OT2001.Address, AT1202.Address)  as Address,
	DeliveryAddress, OT2001.ClassifyID, ClassifyName,
	OT2001.EmployeeID,  AT1103.FullName,  OT2001.Transport, IsUpdateName, IsCustomer, IsSupplier,
	ConvertedAmount = (Select Sum(isnull(ConvertedAmount,0)- isnull(DiscountConvertedAmount,0))  From OT2002 Where OT2002.SOrderID = OT2001.SOrderID),
	OriginalAmount = (Select Sum(isnull(OriginalAmount,0)- isnull(DiscountOriginalAmount,0))  From OT2002 Where OT2002.SOrderID = OT2001.SOrderID),
	VATOriginalAmount = (Select Sum(isnull(VATOriginalAmount,0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID),
	VATConvertedAmount = (Select Sum(isnull(VATConvertedAmount,0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID),
	DiscountConvertedAmount = (Select Sum(isnull(DiscountConvertedAmount,0)) From OT2002 Where OT2002.SOrderID = OT2001.SOrderID),
	OT2001.Notes, OT2001.Disabled, 
	OT2001.OrderStatus, OV1001.Description as OrderStatusName, OV1001.EDescription as EOrderStatusName,
	QuotationID,
	OT2001.OrderType,  OV1002.Description as OrderTypeName,
	Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
	OT2001.CreateUserID, OT2001.CreateDate, 
	OT2001.LastModifyUserID, OT2001.LastModifyDate'

Set @sSQL11 =N' 
From OT2001 left join AT1202 on AT1202.ObjectID = OT2001.ObjectID and AT1202.DivisionID = OT2001.DivisionID
	inner join OT2003 on OT2003.SOrderID = OT2001.SOrderID  and OT2003.DivisionID = OT2001.DivisionID
	left join AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID  and AT1301.DivisionID = OT2001.DivisionID
	inner join AT1004 on AT1004.CurrencyID = OT2001.CurrencyID and AT1004.DivisionID = OT2001.DivisionID
	left join AT1103 on AT1103.EmployeeID = OT2001.EmployeeID and AT1103.DivisionID = OT2001.DivisionID 
	left join OT1001 on OT1001.ClassifyID = OT2001.ClassifyID and OT1001.TypeID = ''SO'' and OT1001.DivisionID = OT2001.DivisionID
	left join OV1001 on OV1001.OrderStatus = OT2001.OrderStatus and OV1001.TypeID = ''SO'' and OV1001.DivisionID = OT2001.DivisionID
	left join OV1002 on OV1002.OrderType = OT2001.OrderType and OV1002.TypeID =''SO'' and OV1002.DivisionID = OT2001.DivisionID
Where  OT2001.DivisionID = ''' + @DivisionID + ''' and  OT2001.TranMonth + OT2001.TranYear*100 between ' +
	cast(@FromMonth + @FromYear*100 as nvarchar(20)) + ' and ' + cast(@ToMonth + @ToYear*100 as nvarchar(20))

---- Buoc  2 : Tra ra thong tin Detail View OV0018
if exists (select 1 from AT0000 where DefDivisionID = @DivisionID  and IsSpecificate = 1)
begin
	Set @sSQL2= N'
Select OT2002.DivisionID, OT2002.SOrderID, OT2002.TransactionID, 
	OT2001.VoucherTypeID, VoucherNo, OrderDate,  ContractNo, ContractDate, 
	OT2001.InventoryTypeID, InventoryTypeName, IsStocked,
	OT2002.InventoryID,
 Isnull (OT2002.InventoryCommonName,InventoryName) as InventoryName, 
 AT1302.UnitID, UnitName, 
	OT2002.MethodID, MethodName, OT2002.OrderQuantity, SalePrice, ConvertedAmount, OriginalAmount, 
	VATConvertedAmount, VATOriginalAmount, OT2002.VATPercent, DiscountConvertedAmount,  DiscountOriginalAmount,
	DiscountPercent, IsPicking, OT2002.WareHouseID, WareHouseName, 
	Quantity01, Quantity02, Quantity03, Quantity04, Quantity05,
	Quantity06, Quantity07, Quantity08, Quantity09, Quantity10,
	Quantity11, Quantity12, Quantity13, Quantity14, Quantity15,
	Quantity16, Quantity17, Quantity18, Quantity19, Quantity20,
	Quantity21, Quantity22, Quantity23, Quantity24, Quantity25,
	Quantity26, Quantity27, Quantity28, Quantity29, Quantity30,		
	Date01, Date02, Date03, Date04, Date05, Date06, Date07, Date08, Date09, Date10, 
	Date11, Date12, Date13, Date14, Date15, Date16, Date17, Date18, Date19, Date20, 
	Date21, Date22, Date23, Date24, Date25, Date26, Date27, Date28, Date29, Date30 , 
	ActualQuantity, EndQuantity as RemainQuantity, OT2002.ConvertedQuantity,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID,
	O99.S08ID, O99.S09ID, O99.S10ID, O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID,
	O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID, O99.UnitPriceStandard,
	AT01.StandardName S01Name, AT02.StandardName S02Name, AT03.StandardName S03Name, AT04.StandardName S04Name, AT05.StandardName S05Name,
	AT06.StandardName S06Name, AT07.StandardName S07Name, AT08.StandardName S08Name, AT09.StandardName S09Name, AT10.StandardName S10Name,
	AT11.StandardName S11Name, AT12.StandardName S12Name, AT13.StandardName S13Name, AT14.StandardName S14Name, AT15.StandardName S15Name,
	AT16.StandardName S16Name, AT17.StandardName S17Name, AT18.StandardName S18Name, AT19.StandardName S19Name, AT20.StandardName S20Name
	'
	
	Set @sSQL22 =N' 
From OT2002 left join AT1302 on AT1302.InventoryID= OT2002.InventoryID and AT1302.DivisionID= OT2002.DivisionID
	LEFT JOIN OT8899 O99 ON O99.DivisionID = OT2002.DivisionID AND O99.TransactionID = OT2002.TransactionID
	left join OT1003 on OT1003.MethodID = OT2002.MethodID  and OT1003.DivisionID= OT2002.DivisionID
	inner join OT2001 on OT2001.SOrderID = OT2002.SOrderID and OT2001.DivisionID= OT2002.DivisionID
	left join AT1303 on AT1303.WareHouseID = OT2002.WareHouseID and AT1303.DivisionID = OT2001.DivisionID 
	left join AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID and AT1301.DivisionID= OT2002.DivisionID
	left join AT1304 on AT1304.UnitID = AT1302.UnitID and AT1304.DivisionID= OT2002.DivisionID
	inner join OT2003 on OT2003.SOrderID = OT2001.SOrderID and OT2003.DivisionID= OT2002.DivisionID
	left join OV2901 on OV2901.SOrderID = OT2002.SOrderID and OV2901.TransactionID = OT2002.TransactionID and OV2901.DivisionID= OT2002.DivisionID
	LEFT JOIN AT0128 AT01 ON AT01.StandardID = O99.S01ID AND AT01.StandardTypeID = ''S01''
	LEFT JOIN AT0128 AT02 ON AT02.StandardID = O99.S02ID AND AT02.StandardTypeID = ''S02''
	LEFT JOIN AT0128 AT03 ON AT03.StandardID = O99.S03ID AND AT03.StandardTypeID = ''S03''
	LEFT JOIN AT0128 AT04 ON AT04.StandardID = O99.S04ID AND AT04.StandardTypeID = ''S04''
	LEFT JOIN AT0128 AT05 ON AT05.StandardID = O99.S05ID AND AT05.StandardTypeID = ''S05''
	LEFT JOIN AT0128 AT06 ON AT06.StandardID = O99.S06ID AND AT06.StandardTypeID = ''S06'' 
	LEFT JOIN AT0128 AT07 ON AT07.StandardID = O99.S07ID AND AT07.StandardTypeID = ''S07''
	LEFT JOIN AT0128 AT08 ON AT08.StandardID = O99.S08ID AND AT08.StandardTypeID = ''S08''
	LEFT JOIN AT0128 AT09 ON AT09.StandardID = O99.S09ID AND AT09.StandardTypeID = ''S09''
	LEFT JOIN AT0128 AT10 ON AT10.StandardID = O99.S10ID AND AT10.StandardTypeID = ''S10''
	LEFT JOIN AT0128 AT11 ON AT11.StandardID = O99.S11ID AND AT11.StandardTypeID = ''S11''
	LEFT JOIN AT0128 AT12 ON AT12.StandardID = O99.S12ID AND AT12.StandardTypeID = ''S12''
	LEFT JOIN AT0128 AT13 ON AT13.StandardID = O99.S13ID AND AT13.StandardTypeID = ''S13''
	LEFT JOIN AT0128 AT14 ON AT14.StandardID = O99.S15ID AND AT14.StandardTypeID = ''S14''
	LEFT JOIN AT0128 AT15 ON AT15.StandardID = O99.S15ID AND AT15.StandardTypeID = ''S15''
	LEFT JOIN AT0128 AT16 ON AT16.StandardID = O99.S16ID AND AT16.StandardTypeID = ''S16''
	LEFT JOIN AT0128 AT17 ON AT17.StandardID = O99.S17ID AND AT17.StandardTypeID = ''S17''
	LEFT JOIN AT0128 AT18 ON AT18.StandardID = O99.S18ID AND AT18.StandardTypeID = ''S18''
	LEFT JOIN AT0128 AT19 ON AT19.StandardID = O99.S19ID AND AT19.StandardTypeID = ''S19''
	LEFT JOIN AT0128 AT20 ON AT20.StandardID = O99.S20ID AND AT20.StandardTypeID = ''S20''
Where  OT2001.DivisionID = ''' + @DivisionID + ''' and  OT2001.TranMonth + OT2001.TranYear*100 between ' +
	cast(@FromMonth + @FromYear*100 as nvarchar(20)) + ' and ' + cast(@ToMonth + @ToYear*100 as nvarchar(20))
end
else
begin

	Set @sSQL2= N'
Select OT2002.DivisionID, OT2002.SOrderID, OT2002.TransactionID, 
	OT2001.VoucherTypeID, VoucherNo, OrderDate,  ContractNo, ContractDate, 
	OT2001.InventoryTypeID, InventoryTypeName, IsStocked,
	OT2002.InventoryID,
 Isnull (OT2002.InventoryCommonName,InventoryName) as InventoryName, 
 AT1302.UnitID, UnitName, 
	OT2002.MethodID, MethodName, OT2002.OrderQuantity, SalePrice, ConvertedAmount, OriginalAmount, 
	VATConvertedAmount, VATOriginalAmount, OT2002.VATPercent, DiscountConvertedAmount,  DiscountOriginalAmount,
	DiscountPercent, IsPicking, OT2002.WareHouseID, WareHouseName, 
	Quantity01, Quantity02, Quantity03, Quantity04, Quantity05,
	Quantity06, Quantity07, Quantity08, Quantity09, Quantity10,
	Quantity11, Quantity12, Quantity13, Quantity14, Quantity15,
	Quantity16, Quantity17, Quantity18, Quantity19, Quantity20,
	Quantity21, Quantity22, Quantity23, Quantity24, Quantity25,
	Quantity26, Quantity27, Quantity28, Quantity29, Quantity30,		
	Date01, Date02, Date03, Date04, Date05, Date06, Date07, Date08, Date09, Date10, 
	Date11, Date12, Date13, Date14, Date15, Date16, Date17, Date18, Date19, Date20, 
	Date21, Date22, Date23, Date24, Date25, Date26, Date27, Date28, Date29, Date30 , 
	ActualQuantity, EndQuantity as RemainQuantity, OT2002.ConvertedQuantity'
	
	Set @sSQL22 =N' 
From OT2002 left join AT1302 on AT1302.InventoryID= OT2002.InventoryID and AT1302.DivisionID= OT2002.DivisionID
	left join OT1003 on OT1003.MethodID = OT2002.MethodID  and OT1003.DivisionID= OT2002.DivisionID
	inner join OT2001 on OT2001.SOrderID = OT2002.SOrderID and OT2001.DivisionID= OT2002.DivisionID
	left join AT1303 on AT1303.WareHouseID = OT2002.WareHouseID and AT1303.DivisionID = OT2001.DivisionID 
	left join AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID and AT1301.DivisionID= OT2002.DivisionID
	left join AT1304 on AT1304.UnitID = AT1302.UnitID and AT1304.DivisionID= OT2002.DivisionID
	inner join OT2003 on OT2003.SOrderID = OT2001.SOrderID and OT2003.DivisionID= OT2002.DivisionID
	left join OV2901 on OV2901.SOrderID = OT2002.SOrderID and OV2901.TransactionID = OT2002.TransactionID and OV2901.DivisionID= OT2002.DivisionID
Where  OT2001.DivisionID = ''' + @DivisionID + ''' and  OT2001.TranMonth + OT2001.TranYear*100 between ' +
	cast(@FromMonth + @FromYear*100 as nvarchar(20)) + ' and ' + cast(@ToMonth + @ToYear*100 as nvarchar(20))

end
If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV0017')
	Exec('Create View OV0017 ---tao boi OP0014
		 as '+@sSQL1+@sSQL11)
Else
	Exec('Alter View OV0017 ---tao boi OP0014
		 as '+@sSQL1+@sSQL11)

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV0018')
	Exec('Create View OV0018  --tao boi OP0014
		as '+@sSQL2+@sSQL22)

Else
	Exec('Alter View OV0018  --- tao boi OP0014
		as '+@sSQL2+@sSQL22)