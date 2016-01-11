/****** Object:  StoredProcedure [dbo].[AP3019]    Script Date: 07/29/2010 10:50:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoang Thi Lan
--Date 06/10/2003
--Purpose:Dung cho Report AR3013(report mua hang) 
--Edited by Nguyen Quoc Huy
---Edit by : Thuy Tuyen lay  SourceNo date, 24/06/2008
---Edit by B.Anh, lay TDescription		date 08/10/2008
---Last edit date 05/09/2009	Lay them truong mã phan tich, so Fax, cac truong Dien giai
---Edit by Thiên Huỳnh: Date 13/07/2012: Thêm mã phân tích đối tượng, mã và tên điều khoản thanh toán
/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[AP3019]    @VoucherID as nvarchar(50)
as
Declare @sSql1 as nvarchar(4000),
	@sSql2 as nvarchar(4000),
	@sSql3 as nvarchar(4000),
	@sSql4 as nvarchar(4000),
	@InvoiceNoList as nvarchar(4000) ,
	@AT9000Cursor as cursor,
	@Serial as nvarchar(50),
	@InvoiceNo as nvarchar(50),
	@DebitAccountList as nvarchar(200),
	@CreditAccountList as nvarchar(200),
	@DebitAccountID as nvarchar(50),
	@CreditAccountID as nvarchar(50)
	
SET @InvoiceNoList =''
SET @AT9000Cursor = CURSOR SCROLL KEYSET FOR
Select Distinct isnull(Serial,'') , isnull(InvoiceNo,'') From AT9000 Where VoucherID =@VoucherID --and TransactionTypeID ='T01'
OPEN @AT9000Cursor
		FETCH NEXT FROM @AT9000Cursor INTO @Serial , @InvoiceNo
			 
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @InvoiceNoList<>''
				Set @InvoiceNoList = @InvoiceNoList+'; '+@Serial+'.'+@InvoiceNo
			Else
				Set @InvoiceNoList =@Serial+'.'+@InvoiceNo
		--Print '@InvoiceNoList'+str(@InvoiceNoList)
			FETCH NEXT FROM @AT9000Cursor INTO @Serial, @InvoiceNo
		END

CLOSE @AT9000Cursor


SET @CreditAccountList =''
SET @AT9000Cursor = CURSOR SCROLL KEYSET FOR
Select Distinct CreditAccountID From AT9000 Where VoucherID =@VoucherID and (TransactionTypeID ='T03' or 
		TransactionTypeID ='T13' or TransactionTypeID ='T33')
OPEN @AT9000Cursor
		FETCH NEXT FROM @AT9000Cursor INTO @CreditAccountID
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @CreditAccountList <>''
				Set @CreditAccountList = @CreditAccountList+'; '+@CreditAccountID
			Else
				Set @CreditAccountList  = @CreditAccountID

			FETCH NEXT FROM @AT9000Cursor INTO @CreditAccountID
		END

CLOSE @AT9000Cursor


SET @DebitAccountList =''
SET @AT9000Cursor = CURSOR SCROLL KEYSET FOR
Select Distinct DebitAccountID From AT9000 Where VoucherID =@VoucherID and (TransactionTypeID ='T03' or 
		TransactionTypeID ='T13' or TransactionTypeID ='T33')
OPEN @AT9000Cursor
		FETCH NEXT FROM @AT9000Cursor INTO @DebitAccountID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @DebitAccountList <>''
			
				Set @DebitAccountList = @DebitAccountList + '; ' + @DebitAccountID
			Else
				Set @DebitAccountList  = @DebitAccountID

			FETCH NEXT FROM @AT9000Cursor INTO @DebitAccountID
		END

CLOSE @AT9000Cursor



If @InvoiceNoList<>'' 
	Set @InvoiceNoList =N'Keøm theo   : '+@InvoiceNoList+' chöùng töø goác'
set @sSql1=N'
Select  0 as TaxOrders,
	AT9000.Orders,
	AT9000.VoucherID,
	AT9000.VoucherNo,
	AT9000.VoucherDate,
	AT9000.ExchangeRate,
	AT9000.TransactionTypeID,
	AT9000.DebitAccountID,
	AT9000.CreditAccountID,
	AT9000.VDescription, 
	'''+isnull(@InvoiceNoList,'')+''' as InvoiceNoList,
	'''+isnull(@CreditAccountList,'')+''' as CreditAccountList,
	'''+isnull(@DebitAccountList,'')+''' as DebitAccountList,
	 AT9000.InventoryID, AT9000.UnitID,
	AT1304.UnitName,
	AT1302.Specification,
	AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,
	AT1302.InventoryTypeID,
	AT9000.UnitPrice, AT9000.Quantity, 
	AT9000.OriginalAmount, AT9000.ConvertedAmount,
	isnull(ImTaxOriginalAmount,0) as ImTaxOriginalAmount,
	isnull(ImTaxConvertedAmount,0) as ImTaxConvertedAmount,
	isnull(ExpenseOriginalAmount,0) as ExpenseOriginalAmount, 
	isnull(ExpenseConvertedAmount,0) as ExpenseConvertedAmount,
	Serial,InvoiceNo,
	Case when isnull(AT9000.InventoryName1,'''') ='''' then AT1302.InventoryName else AT9000.InventoryName1 end as InventoryName ,
	AT9000.ObjectID,AT9000.DivisionID,AT1101.Address as DAddress,
	isnull(T02.Address,AT1202.Address) as OAddress,
	AT1101.Tel,AT1101.DivisionName,
	AT9000.InvoiceDate,'
	
set @sSql2=N'
	AT9000.CurrencyID,AT1202.PaymentID, isnull(AT9000.VATObjectName,isnull(T02.ObjectName,AT1202.ObjectName)) as VATObjectName,
	(Case when AT1202.IsUpdateName =1 then isnull(AT9000.VATObjectName,T02.ObjectName) else AT1202.ObjectName end) as ObjectName,
	(Case when AT1202.IsUpdateName =1 then isnull(AT9000.VATNo,T02.VATNo) else AT1202.VATNo end) as VATNo,
	AT2007.SourceNo, AT2006.WareHouseID, AT1303.WareHouseName,
	AT9000.TDescription, AT9000.IsMultiTax,
	AT9000.Ana01ID, AT9000.Ana02ID, AT9000.Ana03ID, AT9000.Ana04ID, AT9000.Ana05ID,
	AT1202.Fax, BDescription, 
	AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
	AT9000.PaymentTermID, AT1208.PaymentTermName, AT9000.ConvertedUnitID
	

From AT9000 	left join AT1302 on At1302.InventoryID = AT9000.InventoryID	and At1302.DivisionID=AT9000.DivisionID
		Left join AT1304 on AT1304.UnitID = AT9000.UnitID	and AT1304.DivisionID=AT9000.DivisionID
		left join AT1202 on At1202.ObjectID = AT9000.ObjectID	and At1202.DivisionID=AT9000.DivisionID
           		left join AT1101 on AT1101.DivisionID=AT9000.DivisionID
		left join AT1202 T02 on T02.ObjectID = AT9000.VATObjectID and T02.DivisionID=AT9000.DivisionID
 		Left Join AT2007 on AT2007.VoucherID =  AT9000.VoucherID
			and AT2007.TransactionID =AT9000.TransactionID and AT2007.DivisionID=AT9000.DivisionID
		Left Join AT2006 on AT2006.VoucherID =  AT9000.VoucherID and AT2006.DivisionID=AT9000.DivisionID
		Left Join AT1303 on AT1303.WareHouseID =  AT2006.WareHouseID and AT1303.DivisionID=AT9000.DivisionID
		Left Join AT1208 on AT1208.PaymentTermID = AT9000.PaymentTermID And AT1208.DivisionID = AT9000.DivisionID

Where 	AT9000.VoucherID ='''+@VoucherID+''' and 
             TransactionTypeID=''T03'' 

Union'

set @sSql3=N'
Select
	1 as TaxOrders,
	AT9000.Orders,
	AT9000.VoucherID,
	AT9000.VoucherNo,
	AT9000.VoucherDate,
	AT9000.ExchangeRate,
	AT9000.TransactionTypeID,
	AT9000.DebitAccountID,
	AT9000.CreditAccountID,
	AT9000.VDescription, 
	'''+isnull(@InvoiceNoList,'')+''' as InvoiceNoList,
	'''+isnull(@CreditAccountList,'')+''' as CreditAccountList,
	'''+isnull(@DebitAccountList,'')+''' as DebitAccountList,
	'''' as  InventoryID, 
	'''' as UnitID,
	'''' as UnitName,
	AT1302.Specification,
	AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,
	AT1302.InventoryTypeID,
	0 as UnitPrice, 
	0 as Quantity, 
	OriginalAmount, ConvertedAmount,
	0 as ImTaxOriginalAmount,
	0 as ImTaxConvertedAmount,
	0 as ExpenseOriginalAmount, 
	0 as ExpenseConvertedAmount,
 	AT9000.Serial,
	AT9000.InvoiceNo,	
	AT9000.TDescription as InventoryName,
	 AT9000.ObjectID, AT9000.DivisionID,AT1101.Address as DAddress,
	isnull(T02.Address,AT1202.Address) as OAddress, AT1101.Tel	,AT1101.DivisionName,
	AT9000.InvoiceDate,'

set @sSql4=N'
	AT9000.CurrencyID,AT1202.PaymentID, isnull(AT9000.VATObjectName,isnull(T02.ObjectName,AT1202.ObjectName)) as VATObjectName,
	(Case when AT1202.IsUpdateName =1 then isnull(AT9000.VATObjectName,T02.ObjectName) else AT1202.ObjectName end) as ObjectName,
	(Case when AT1202.IsUpdateName =1 then isnull(AT9000.VATNo,T02.VATNo) else AT1202.VATNo end) as VATNo,
	'''' as SourceNo, '''' as WareHouseID, '''' as WareHouseName,
	AT9000.TDescription, AT9000.IsMultiTax,
	AT9000.Ana01ID, AT9000.Ana02ID, AT9000.Ana03ID, AT9000.Ana04ID, AT9000.Ana05ID,
	AT1202.Fax,BDescription,
	AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
	AT9000.PaymentTermID, AT1208.PaymentTermName, AT9000.ConvertedUnitID

From AT9000 	left join AT1302 on At1302.InventoryID = AT9000.InventoryID	and At1302.DivisionID=AT9000.DivisionID
		left join AT1202 on At1202.ObjectID = AT9000.ObjectID and At1202.DivisionID=AT9000.DivisionID
		left join AT1101 on AT1101.DivisionID=AT9000.DivisionID
		left join AT1202 T02 on T02.ObjectID = AT9000.VATObjectID and T02.DivisionID=AT9000.DivisionID
		Left Join AT1208 on AT1208.PaymentTermID = AT9000.PaymentTermID And AT1208.DivisionID = AT9000.DivisionID
 
Where 	VoucherID ='''+@VoucherID+''' and 
             TransactionTypeID=''T13'' '



 
--Print @sSQL


If not exists (Select top 1 1 From SysObjects Where name = 'AV3013' and Xtype ='V')
	Exec ('Create view AV3013 as '+@sSQL1+@sSQL2+@sSQL3+@sSQL4)
Else
	Exec ('Alter view AV3013 as '+@sSQL1+@sSQL2+@sSQL3+@sSQL4)