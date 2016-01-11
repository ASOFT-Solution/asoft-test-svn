
/****** Object:  StoredProcedure [dbo].[OP2011]    Script Date: 12/16/2010 11:28:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


----Created by: Thuy Tuyen, 
----Date: 10/09/2009
----purpose: In don hang ban -- mau 2
-- Last Update: 15/09/2009,24/09/2009,26/09/2009
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP2011] @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@OrderID as nvarchar(50)

AS
Declare @sSQL as nvarchar(4000),
		@sSQL1 as nvarchar(4000),
		@sSQL2 as nvarchar(4000)

Set @sSQL = 
'Select  OT2001.DivisionID, ReceivedAmount = isnull((Select Sum(SignAmount) From AV4301 Where ObjectID = OT2001.ObjectID and AccountID =''131'' and VoucherDate< OT2001.OrderDate),0),
	OT2001.SOrderID, TransactionID, 
	VoucherTypeID,VoucherNo, OrderDate, 	
	ContractNo,ContractDate,
	OT2001.CurrencyID,
	OT2001.ObjectID, AT1202.ObjectName ,AT1202.Address ,  AT1202.VATNo as OVATNo, AT1202.Tel, AT1202.Fax, AT1202.Email,
	OT2001.DeliveryAddress,OT2001.Notes as Descrip,
	OT2001.SalesManID, 	AT1103_2.FullName as SalesManName, AT1103_2.Email as EmailSalesMan, 
	OT2001.TransPort,
	OT2001.EmployeeID, AT1103.FullName, AT1103.Address as EmployeeAddress,
	OT2002.InventoryID, 	isnull(OT2002.InventoryCommonName, 	AT1302.InventoryName)  as InventoryName,  
	AT1302.UnitID,	AT1304.UnitName,
	AV1319.UnitID as ConversionUnitID, 
	AV1319.ConversionFactor,
	AV1319.UnitName as ConversionUnitName,
	AV1319.Operator,
	AT1002.CityName,
	AT1302.Notes01 as InNotes01, AT1302.Notes02 as InNotes02, AT1302.notes03 as InNotes03, AT1302.Specification,
	AT1302.S1, AT1302.S2,  AT1302.S3, 
	AT1310_S1.SName as SName1, AT1310_S2.SName as SName2, 
	AT1310_S3.SName as SName3,
	OT2002.MethodID, 	MethodName, 	
	AT1208.PaymentTermName, 
	OrderQuantity, ConvertedQuantity,		
(case when AV1319.Operator = 0 then 	
(OrderQuantity / AV1319.ConversionFactor  )
else
(OrderQuantity *  isnull(AV1319.ConversionFactor,0)   ) end)   as ConversionQuantity , '		
Set @sSQL1='
	OT2002.SalePrice, 	OT2001.ExchangeRate, 
	case when AT1004.Operator = 0 or OT2001.ExchangeRate = 0  then SalePrice*OT2001.ExchangeRate else
	OT2002.SalePrice/OT2001.ExchangeRate  end as SalePriceConverted,
	isnull(OT2002.ConvertedAmount,0) as ConvertedAmount, 
	isnull(OT2002.OriginalAmount,0) as OriginalAmount, 
	OT2002.VATPercent, 	
	isnull(OT2002.VATConvertedAmount,0) as VATConvertedAmount, 	
	isnull(OT2002.VATOriginalAmount, 0) as VATOriginalAmount,
	DiscountPercent, 	
	isnull(DiscountConvertedAmount,0) as DiscountConvertedAmount, 	
	isnull(DiscountOriginalAmount,0) as DiscountOriginalAmount,
	OT2002.CommissionPercent, 	
	isnull(OT2002.CommissionCAmount, 0) as CommissionCAmount,
	 isnull(OT2002.CommissionOAmount,0) as CommissionOAmount, 
	IsPicking, OT2002.WareHouseID, WareHouseName, ShipDate, OT2002.RefInfor,
	OT2002.Orders, AT1205.PaymentName, AT1004.CurrencyName,
	isnull(OT2002.OriginalAmount, 0) + isnull(OT2002.VATOriginalAmount, 0)	 -
	 isnull(OT2002.DiscountOriginalAmount, 0) - isnull(CommissionOAmount,0) as TotalOriginalAmount,
	isnull(OT2002.ConvertedAmount, 0) + isnull(OT2002.VATConvertedAmount, 0) - 
	isnull(OT2002.DiscountConvertedAmount, 0)-isnull(CommissionCAmount, 0)as TotalConvertedAmount,
	OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID, 
	OT1002_1.AnaName as AnaName1,
	OT1002_2.AnaName as AnaName2,
	OT1002_3.AnaName as AnaName3,
	OT1002_4.AnaName as AnaName4,
	OT1002_5.AnaName as AnaName5,
 	OT2002.Description ,
	isnull (OT2001.Contact, AT1202.contactor)as contactor ,
	OT2002.Notes, OT2002.Notes01, OT2002.Notes02,
	OT2001.VATObjectID,
	Isnull(OT2001.VATObjectName,T02.ObjectName) as VATObjectName,
	isnull(OT2001.Address,		 T02.Address) as VATAddress,
	Isnull(OT2001.VATNo,T02.VatNo) as VATNo ,
	ot2002.EndDate,
	AT1302.Varchar01, AT1302.Varchar02, AT1302.Varchar03, AT1302.varchar04, AT1302.varchar05,
	AT1302.I01ID,T15.AnaName as AnaNameI01,  AT1302.I02ID, T16.AnaName as AnaNameI02,
	 AT1302.I03ID, T17.AnaName as AnaNameI03,
	 AT1302.I04ID, AT1302.I05ID,
	OT2002.SaleOffPercent01,OT2002.SaleOffAmount01,
	OT2002.SaleOffPercent02,OT2002.SaleOffAmount02,
	OT2002.SaleOffPercent03,OT2002.SaleOffAmount03,
	OT2002.SaleOffPercent04,OT2002.SaleOffAmount04,
	OT2002.SaleOffPercent05,OT2002.SaleOffAmount05,
	OT2002.QuoTransactionID,OT2002.Pricelist,  AT1202. TradeName, OT3019.SOKitID,
	        (   salePrice - (salePrice * isnull(DiscountPercent,0) /100) - isnull (OT2002.SaleOffAmount02,0)       - isnull (OT2002.SaleOffAmount02,0) -isnull (OT2002.SaleOffAmount03,0)-isnull (OT2002.SaleOffAmount04,0)-isnull (OT2002.SaleOffAmount02,0)    )  as PriceLast,
	AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID	'
	
Set @sSQL2 = ' From OT2002 left join AT1302 on AT1302.InventoryID= OT2002.InventoryID		  			
	left join OT1003 on OT1003.MethodID = OT2002.MethodID 
	inner join OT2001 on OT2001.SOrderID = OT2002.SOrderID
	left join AT1205 on AT1205.PaymentID = OT2001.PaymentID  
	left join AT1303 on AT1303.WareHouseID = OT2002.WareHouseID and AT1303.DivisionID = OT2001.DivisionID
	left join AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID 	
	left join AT1304 on AT1304.UnitID = AT1302.UnitID	         
	left join AT1103 on AT1103.EmployeeID = OT2001.EmployeeID and AT1103.DivisionID = OT2001.DivisionID
	left join AT1103 AT1103_2 on AT1103_2.EmployeeID = OT2001.SalesManID and AT1103_2.DivisionID = OT2001.DivisionID
	left join AT1004 on AT1004.CurrencyID = OT2001.CurrencyID
	left join AT1202 on AT1202.ObjectID = OT2001.ObjectID
	left join AT1202 T02 on T02.ObjectID = OT2001.VATObjectID
	left join AT1208 on AT1208.PaymentTermID = OT2001.PaymentTermID
	left join AT1310  AT1310_S1 on AT1310_S1.STypeID= ''I01'' and AT1310_S1.S = AT1302.S1 
	left join AT1310  AT1310_S2 on AT1310_S2.STypeID= ''I02'' and AT1310_S2.S = AT1302.S2
	left join AT1310  AT1310_S3 on AT1310_S3.STypeID= ''I03'' and AT1310_S2.S = AT1302.S3
	left join AT1011	OT1002_1 on OT1002_1.AnaID = OT2001.Ana01ID and  OT1002_1.AnaTypeID = ''A01'' 
	left join AT1011	OT1002_2 on OT1002_2.AnaID = OT2001.Ana02ID and  OT1002_2.AnaTypeID = ''A02'' 
	left join AT1011	OT1002_3 on OT1002_3.AnaID = OT2001.Ana03ID and  OT1002_3.AnaTypeID = ''A03'' 
	left join AT1011	OT1002_4 on OT1002_4.AnaID = OT2001.Ana04ID and  OT1002_4.AnaTypeID = ''A04'' 
	left join AT1011	OT1002_5 on OT1002_5.AnaID = OT2001.Ana05ID and  OT1002_5.AnaTypeID = ''A05'' 
	left join AT1002 on AT1002.CityID = AT1202.CityID

	Left Join AT1015  T15 on  T15.AnaID = AT1302.I01ID and T15. AnaTypeID =''I01''
	Left Join AT1015   T16 on T16.AnaID = AT1302.I02ID and T16.AnaTypeID =''I02''
	Left Join AT1015  T17  on  T17.AnaID = AT1302.I03ID and  T17.AnaTypeID =''I03''
	Left Join AT1015   T18 on T18.AnaID = AT1302.I04ID and T18.AnaTypeID =''I04''
	Left Join AT1015  T19  on  T19.AnaID = AT1302.I05ID and  T19.AnaTypeID =''I05''
	Left join AV1319 on AV1319.InventoryID = AT1302.InventoryID and AV1319.UnitID  = OT2002.UnitID
	Left Join OT3019 on OT3019.SOKitTransactionID = OT2002.SOKitTransactionID

Where OT2001.DivisionID = ''' + @DivisionID + ''' and 
	 OT2001.SOrderID in ( ' + @OrderID + ')'
--Print @sSQL
	If Not Exists (Select 1 From sysObjects Where Name ='OV2011')
		Exec ('Create view OV2011  ---tao boi OP2011
			as '+@sSQL + @sSQL1 + @sSQL2)
	Else
		Exec( 'Alter view OV2011  ---tao boi OP2011
			as '+@sSQL + @sSQL1 + @sSQL2)