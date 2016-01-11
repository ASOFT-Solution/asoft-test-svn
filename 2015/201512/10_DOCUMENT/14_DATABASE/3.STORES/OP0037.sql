IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0037]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0037]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






---- Created by : Thuy Tuyen
---- Date :26/05/2009
---- Purpose: Loc ra cac don hang  mua cho man hinh duyet don hang mua
----Edit: Thuy Tuyen  2/11/2009 , lay truong IsConfirmName, 25/01/2009
---- Modified on 21/01/2013 by Lê Thị Thu Hiền : Bổ sung điều kiện lọc master

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/
---- Modified by Tiểu Mai on 20/11/2015: Bổ sung trường hợp quản lý mặt hàng theo quy cách.
---- Modified by Tiểu Mai on 04/01/2016: Bổ sung trường duyệt IsConfirm01, ConfDescription01, IsConfirm02, ConfDescription02

CREATE PROCEDURE [dbo].[OP0037]   
			@DivisionID nvarchar(50),
			@ObjectID nvarchar (50),
			@FromMonth  int,
			@FromYear int,
			@ToMonth int,
			@ToYear int ,
			@IsCheck TINYINT,
			@IsPeriod TINYINT = 0,
			@FromDate DATETIME = '',
			@ToDate DATETIME = '',
			@Status TINYINT = 0,
			@VoucherTypeID NVARCHAR(50) = '',
			@IsPrinted TINYINT = 0
 AS
Declare @sSQL1 as nvarchar(4000),
		@sSQL11 as nvarchar(4000),
		@sSQL2 as nvarchar(4000),
		@sSQL22 as nvarchar(4000),
		@sWhere as nvarchar(500)
If @IsCheck  = 1
	Set @sWhere = ''
Else
	Set @sWhere = ' and  OT3001.IsConfirm = 0 '

IF @IsPrinted IS NOT NULL AND @IsPrinted = 1
BEGIN
	SET @sWHERE = @sWHERE + N' AND ISNULL(OT3001.IsPrinted, 0) = 1 '
END

IF @IsPrinted IS NOT NULL AND @IsPrinted = 2 
BEGIN
	SET @sWHERE = @sWHERE + N' AND ISNULL(OT3001.IsPrinted, 0) = 0 '
END

IF @ObjectID IS NOT NULL AND @ObjectID <> '' AND @ObjectID <> '%'
BEGIN
	SET @sWHERE = @sWHERE + N'	AND OT3001.ObjectID = '''+@ObjectID+'''	'
END

IF @Status IS NOT NULL
BEGIN
	SET @sWHERE = @sWHERE + N'	AND OT3001.OrderStatus = ' + STR(@Status) + ' '
END

IF @VoucherTypeID IS NOT NULL AND @VoucherTypeID <> '' AND @VoucherTypeID <> '%'
BEGIN
	SET @sWHERE = @sWHERE + N'	AND OT3001.VoucherTypeID = '''+@VoucherTypeID+''' '
END

IF @IsPeriod = 1
SET @sWhere = @sWhere +	'
	AND OT3001.TranMonth + OT3001.TranYear * 100 BETWEEN '+str(@FromMonth)+' + '+str(@Fromyear)+' *100 and  '+str(@ToMonth)+' + '+str(@Toyear)+' *100 '
ELSE
	SET @sWhere = @sWhere + '
	AND CONVERT(varchar(10),OT3001.OrderDate,101) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,101)+''' AND '''+CONVERT (VARCHAR(10),@ToDate,101)+''' '
	
---- Buoc  2 : Tra ra thong tin Master View OV0037

Set @sSQL1 =N' 
Select Distinct OT3001.POrderID, OT3001.VoucherTypeID, OT3001.VoucherNo, OT3001.DivisionID, OT3001.TranMonth, OT3001.TranYear,
		OrderDate, OT3001.InventoryTypeID, InventoryTypeName, OT3001.CurrencyID, CurrencyName, 	
		OT3001.ExchangeRate,  OT3001.PaymentID, 
		OT3001.ObjectID,  isnull(OT3001.ObjectName, AT1202.ObjectName)  as ObjectName, 
		isnull(OT3001.VatNo, AT1202.VatNo)  as VatNo,  isnull( OT3001.Address, AT1202.Address)  as Address,
		OT3001.ReceivedAddress, OT3001.ClassifyID, ClassifyName, OT3001.Transport,
		OT3001.EmployeeID,  AT1103.FullName,  IsSupplier, IsUpdateName, IsCustomer,
		ConvertedAmount = (Select Sum(isnull(ConvertedAmount,0)- isnull(DiscountConvertedAmount,0) + isnull(VATConvertedAmount, 0))  
		From OT3002 Where OT3002.POrderID = OT3001.POrderID),
		OriginalAmount = (Select Sum(isnull(OriginalAmount,0)- isnull(DiscountOriginalAmount,0) + isnull(VATOriginalAmount, 0))  From OT3002 Where OT3002.POrderID = OT3001.POrderID),
		OT3001.Notes, OT3001.Disabled, OT3001.OrderStatus, OV1001.Description as OrderStatusName, 
		OV1001.EDescription as EOrderStatusName, 
		OT3001.OrderType,  OV1002.Description as OrderTypeName, 
		OT3001.ContractNo, OT3001.ContractDate,
		Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
		OT1002_1.AnaName as Ana01Name, OT1002_2.AnaName as Ana02Name, 
		OT1002_3.AnaName as Ana03Name, OT1002_4.AnaName as Ana04Name, OT1002_5.AnaName as Ana05Name, 
		OT3001.CreateUserID, OT3001.CreateDate,  
		OT3001.LastModifyUserID, OT3001.LastModifyDate, ShipDate, OT3001.DueDate,OT3001.RequestID,
		OT3001.varchar01, OT3001.varchar02, OT3001.varchar03, OT3001.varchar04, OT3001.varchar05,
		OT3001.varchar06, OT3001.varchar07, OT3001.varchar08, OT3001.varchar09, OT3001.varchar10,
		OT3001.varchar11, OT3001.varchar12, OT3001.varchar13, OT3001.varchar14, OT3001.varchar15,
		OT3001.varchar16, OT3001.varchar17, OT3001.varchar18, OT3001.varchar19, OT3001.varchar20,
		OT3001.PaymentTermID,
		OT3001.IsConfirm,

		OT1102.Description as  IsConfirmName,
		OT1102.EDescription as EIsConfirmName,

		OT3001.DescriptionConfirm,
		OT3001.IsConfirm01,
		OT3001.ConfDescription01,
		OT3001.IsConfirm02,
		OT3001.ConfDescription02'
	
Set @sSQL11 =N' 
From OT3001 left join AT1202 on AT1202.ObjectID = OT3001.ObjectID And AT1202.DivisionID = OT3001.DivisionID
		left join OT1002 OT1002_1 on OT1002_1.AnaID = OT3001.Ana01ID and OT1002_1.AnaTypeID = ''P01'' And OT1002_1.DivisionID = OT3001.DivisionID
		left join OT1002 OT1002_2 on OT1002_2.AnaID = OT3001.Ana02ID and OT1002_2.AnaTypeID = ''P02'' And OT1002_2.DivisionID = OT3001.DivisionID
		left join OT1002 OT1002_3 on OT1002_3.AnaID = OT3001.Ana03ID and OT1002_3.AnaTypeID = ''P03'' And OT1002_3.DivisionID = OT3001.DivisionID
		left join OT1002 OT1002_4 on OT1002_4.AnaID = OT3001.Ana04ID and OT1002_4.AnaTypeID = ''P04'' And OT1002_4.DivisionID = OT3001.DivisionID
		left join OT1002 OT1002_5 on OT1002_5.AnaID = OT3001.Ana05ID and OT1002_5.AnaTypeID = ''P05''  And OT1002_5.DivisionID = OT3001.DivisionID
		left join AT1301 on AT1301.InventoryTypeID = OT3001.InventoryTypeID  And AT1301.DivisionId = OT3001.DivisionId
		inner join AT1004 on AT1004.CurrencyID = OT3001.CurrencyID And AT1004.DivisionID = OT3001.DivisionID
		left join AT1103 on AT1103.EmployeeID = OT3001.EmployeeID and AT1103.DivisionID = OT3001.DivisionID 
		left join OT1001 on OT1001.ClassifyID = OT3001.ClassifyID And OT1001.DivisionId = OT3001.DivisionId and OT1001.TypeID = ''PO''
		left join OV1001 on OV1001.OrderStatus = OT3001.OrderStatus and OV1001.DivisionId = OT3001.DivisionId And OV1001.TypeID= ''PO''
		left join OV1002 on OV1002.OrderType = OT3001.OrderType And OV1002.DivisionID = OT3001.DivisionID and OV1002.TypeID =''PO''
		left join OT1102 on OT1102.Code = OT3001.IsConfirm01 And OT1102.DivisionID = OT3001.DivisionID and OT1102.TypeID = ''SO''
Where OT3001.ObjectID like '''+ @ObjectID+''' 
  and OT3001.DivisionID = '''+ @DivisionID+'''
  and OT3001.POrderID  not in (select  Distinct  isnull(OrderID,'''')  from AT9000 )--chi cac phieu chua ke thua sang  mua hang
  
'
--Set @sSQL1 = @sSQL1 + @sWhere

---- Buoc  2 : Tra ra thong tin Detail View OV0038
IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	Set @sSQL2= N'Select Distinct OT3002.DivisionID,OT3002.POrderID, OT3002.TransactionID, 
			OT3001.VoucherTypeID, OT3001.VoucherNo,OT3001.OrderDate, OT3001.InventoryTypeID, InventoryTypeName, IsStocked,
			OT3002.InventoryID,  OT3002.UnitID, UnitName, 
			OT3002.MethodID, MethodName, OT3002.OrderQuantity, PurchasePrice, ConvertedAmount, OriginalAmount, 
			VATConvertedAmount, VATOriginalAmount, OT3002.VATPercent, DiscountConvertedAmount,  DiscountOriginalAmount,
			DiscountPercent, IsPicking, OT3002.WareHouseID, WareHouseName, 
			Quantity01, Quantity02, Quantity03, Quantity04, Quantity05, Quantity06, Quantity07, Quantity08, Quantity09, Quantity10,
			Quantity11, Quantity12, Quantity13, Quantity14, Quantity15, Quantity16, Quantity17, Quantity18, Quantity19, Quantity20, 
			Quantity21, Quantity22, Quantity23, Quantity24, Quantity25, Quantity26, Quantity27, Quantity28, Quantity29, Quantity30,
			Date01, Date02, Date03, Date04, Date05, Date06, Date07, Date08, Date09, Date10, 
			Date11, Date12, Date13, Date14, Date15, Date16, Date17, Date18, Date19, Date20, 
			Date21, Date22, Date23, Date24, Date25, Date26, Date27, Date28, Date29, Date30, OT3002.Orders, OT3002.Description, 
			OT3002.Ana01ID, OT3002.Ana02ID, OT3002.Ana03ID, OT3002.Ana04ID, OT3002.Ana05ID,
			AT1302.InventoryName as AInventoryName, 
			case when isnull(OT3002.InventoryCommonName, '''') = '''' then AT1302.InventoryName else OT3002.InventoryCommonName end as 
			InventoryName	, ActualQuantity, EndQuantity as RemainQuantity,
			OT3002.Finish ,OT3002.Notes, OT3002.notes01, OT3002.Notes02, OT3002.RefTransactionID, OT3002.ROrderID, OT3101.ContractNo, 
			OT3002.ConvertedQuantity, OT3002.ImTaxPercent, OT3002.ImTaxOriginalAmount, OT3002.ImTaxConvertedAmount,
			O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID,
			O99.S08ID, O99.S09ID, O99.S10ID, O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID,
			O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID, O99.UnitPriceStandard,
			AT01.StandardName S01Name, AT02.StandardName S02Name, AT03.StandardName S03Name, AT04.StandardName S04Name, AT05.StandardName S05Name,
			AT06.StandardName S06Name, AT07.StandardName S07Name, AT08.StandardName S08Name, AT09.StandardName S09Name, AT10.StandardName S10Name,
			AT11.StandardName S11Name, AT12.StandardName S12Name, AT13.StandardName S13Name, AT14.StandardName S14Name, AT15.StandardName S15Name,
			AT16.StandardName S16Name, AT17.StandardName S17Name, AT18.StandardName S18Name, AT19.StandardName S19Name, AT20.StandardName S20Name'
		
	Set @sSQL22= N'
		From OT3002 left join AT1302 on AT1302.InventoryID= OT3002.InventoryID And AT1302.DivisionID= OT3002.DivisionID
			left join OT1003 on OT1003.MethodID = OT3002.MethodID And OT1003.DivisionID = OT3002.DivisionID
			inner join OT3001 on OT3001.POrderID = OT3002.POrderID And OT3001.DivisionID = OT3002.DivisionID
			left join AT1303 on AT1303.WareHouseID = OT3002.WareHouseID and AT1303.DivisionID = OT3001.DivisionID 
			left join AT1301 on AT1301.InventoryTypeID = OT3001.InventoryTypeID And AT1301.DivisionID = OT3001.DivisionID	
			left join AT1304 on AT1304.UnitID =OT3002.UnitID ANd AT1304.DivisionID =OT3002.DivisionID
			left join OT3003 on OT3003.POrderID = OT3001.POrderID And OT3003.DivisionId = OT3001.DivisionId
			left join OV2902 on OV2902.POrderID = OT3002.POrderID and OV2902.TransactionID = OT3002.TransactionID And OV2902.DivisionId = OT3002.DivisionId
			lEFT joIN OT3101 on OT3101.RorderID = OT3002.RorderID And OT3101.DivisionID = OT3002.DivisionID
			LEFT JOIN OT8899 O99 ON O99.DivisionID = OT3002.DivisionID AND O99.VoucherID = OT3002.POrderID AND O99.TransactionID = OT3002.TransactionID and O99.TableID = ''OT3002'' 
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
			'	

END
ELSE
BEGIN
	Set @sSQL2= N'Select Distinct OT3002.DivisionID,OT3002.POrderID, OT3002.TransactionID, 
			OT3001.VoucherTypeID, OT3001.VoucherNo,OT3001.OrderDate, OT3001.InventoryTypeID, InventoryTypeName, IsStocked,
			OT3002.InventoryID,  OT3002.UnitID, UnitName, 
			OT3002.MethodID, MethodName, OT3002.OrderQuantity, PurchasePrice, ConvertedAmount, OriginalAmount, 
			VATConvertedAmount, VATOriginalAmount, OT3002.VATPercent, DiscountConvertedAmount,  DiscountOriginalAmount,
			DiscountPercent, IsPicking, OT3002.WareHouseID, WareHouseName, 
			Quantity01, Quantity02, Quantity03, Quantity04, Quantity05, Quantity06, Quantity07, Quantity08, Quantity09, Quantity10,
			Quantity11, Quantity12, Quantity13, Quantity14, Quantity15, Quantity16, Quantity17, Quantity18, Quantity19, Quantity20, 
			Quantity21, Quantity22, Quantity23, Quantity24, Quantity25, Quantity26, Quantity27, Quantity28, Quantity29, Quantity30,
			Date01, Date02, Date03, Date04, Date05, Date06, Date07, Date08, Date09, Date10, 
			Date11, Date12, Date13, Date14, Date15, Date16, Date17, Date18, Date19, Date20, 
			Date21, Date22, Date23, Date24, Date25, Date26, Date27, Date28, Date29, Date30, OT3002.Orders, OT3002.Description, 
			OT3002.Ana01ID, OT3002.Ana02ID, OT3002.Ana03ID, OT3002.Ana04ID, OT3002.Ana05ID,
			AT1302.InventoryName as AInventoryName, 
			case when isnull(OT3002.InventoryCommonName, '''') = '''' then AT1302.InventoryName else OT3002.InventoryCommonName end as 
			InventoryName	, ActualQuantity, EndQuantity as RemainQuantity,
			OT3002.Finish ,OT3002.Notes, OT3002.notes01, OT3002.Notes02, OT3002.RefTransactionID, OT3002.ROrderID, OT3101.ContractNo, 
			OT3002.ConvertedQuantity, OT3002.ImTaxPercent, OT3002.ImTaxOriginalAmount, OT3002.ImTaxConvertedAmount'
		
	Set @sSQL22= N'
		From OT3002 left join AT1302 on AT1302.InventoryID= OT3002.InventoryID And AT1302.DivisionID= OT3002.DivisionID
			left join OT1003 on OT1003.MethodID = OT3002.MethodID And OT1003.DivisionID = OT3002.DivisionID
			inner join OT3001 on OT3001.POrderID = OT3002.POrderID And OT3001.DivisionID = OT3002.DivisionID
			left join AT1303 on AT1303.WareHouseID = OT3002.WareHouseID and AT1303.DivisionID = OT3001.DivisionID 
			left join AT1301 on AT1301.InventoryTypeID = OT3001.InventoryTypeID And AT1301.DivisionID = OT3001.DivisionID	
			left join AT1304 on AT1304.UnitID =OT3002.UnitID ANd AT1304.DivisionID =OT3002.DivisionID
			left join OT3003 on OT3003.POrderID = OT3001.POrderID And OT3003.DivisionId = OT3001.DivisionId
			left join OV2902 on OV2902.POrderID = OT3002.POrderID and OV2902.TransactionID = OT3002.TransactionID And OV2902.DivisionId = OT3002.DivisionId
			lEFT joIN OT3101 on OT3101.RorderID = OT3002.RorderID And OT3101.DivisionID = OT3002.DivisionID '
END


If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV0037')
	Exec('Create View OV0037 ---tao boi OP0037
		 as '+@sSQL1+@sSQL11+@sWhere)
Else
	Exec('Alter View OV0037 ---tao boi OP0037
		 as '+@sSQL1+@sSQL11+@sWhere)

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV0038')	
	Exec('Create View OV0038  --tao boi OP0038
		as '+@sSQL2+@sSQL22)

Else
	Exec('Alter View OV0038  --- tao boi OP0038
		as '+@sSQL2+@sSQL22)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

