
/****** Object:  View [dbo].[OV2600]    Script Date: 12/16/2010 15:07:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Created by: Vo Thanh Huong, date : 26/09/2005
--Purpose: (view chet) Loc ra cac DON HANG BAN  VA DON HANG MUA phuc vu cho cong tac bao cao	
 
ALTER VIEW [dbo].[OV2600] AS 
SELECT OT2001.DivisionID,
	OT2001.TranMonth,
	OT2001.TranYear,	
	OT2001.TranYear as Year,	  
	OV9999.MonthYear,
	OV9999.Quarter,
	OT2001.SOrderID as VoucherID, 	
	OT2001.VoucherTypeID, 
	OT2001.VoucherNo, 
	OT2001.OrderDate as VoucherDate, 
	OT2001.OrderType, 
	OT2001.ObjectID, 
	case when isnull(OT2001.ObjectName, '') = '' then  AT1202.ObjectName else OT2001.ObjectName end as ObjectName,
	OT2001.Notes as VDescription, 
	OT2001.OrderStatus, 	
	 OT2001.CurrencyID, 
	AT1004.CurrencyName,
	OT2001.ExchangeRate, 
	OT2001.EmployeeID, 
	OT2001.Disabled, 
	isnull(OT2001.Ana01ID, '') as VAna01ID, 		isnull(OT2001.Ana02ID, '') as VAna02ID, 		isnull(OT2001.Ana03ID, '') as VAna03ID, 	
	isnull(OT2001.Ana04ID, '') as VAna04ID, 		isnull(OT2001.Ana05ID, '') as VAna05ID,
	OT2002.TransactionID, 
	OT2002.InventoryID, 
	AT1302.InventoryName,
	OT2002.OrderQuantity as Quantity, 
	OT2002.SalePrice as UnitPrice,
	(isnull(OT2002.OriginalAmount, 0) - isnull(OT2002.VATOriginalAmount, 0) - isnull(OT2002.DiscountOriginalAmount, 0) - isnull(OT2002.CommissionOAmount, 0)) as OriginalAmount,
	(isnull(OT2002.ConvertedAmount, 0) - isnull(OT2002.VATConvertedAmount, 0) - isnull(OT2002.DiscountConvertedAmount, 0) - isnull(OT2002.CommissionCAmount,0)) as ConvertedAmount,
	OT2002.Orders, 
	OT2002.Description as TDescription,  	
	isnull(OT2002.Ana01ID, '') as Ana01ID, 	isnull(OT2002.Ana02ID, '') as Ana02ID, 	
	isnull(OT2002.Ana03ID,'') as Ana03ID, 	isnull(OT2002.Ana04ID,'') as Ana04ID,
	isnull(OT2002.Ana05ID, '') as Ana05ID,
	OT2002.UnitID,	
	isnull(AT1302.S1, '')  as CI1ID,	isnull(AT1302.S2, '')  as CI2ID, 	isnull(AT1302.S3, '') as CI3ID,  
	isnull(AT1302.I01ID, '') as I01ID, 		isnull(AT1302.I02ID, '') as I02ID, 		isnull(AT1302.I03ID, '') as I03ID,
	isnull( AT1302.I04ID, '') as I04ID, 		isnull(AT1302.I05ID, '') as I05ID,
	isnull(AT1202.S1, '')  as CO1ID,	isnull(AT1202.S2, '') as CO2ID, 	isnull(AT1202.S3, '') as CO3ID,
	isnull(AT1202.O01ID, '') as O01ID,  isnull(AT1202.O02ID, '') as O02ID, 		
	isnull(AT1202.O03ID, '') as O03ID,	isnull( AT1202.O04ID, '') as O04ID,  	isnull(AT1202.O05ID, '') as O05ID,
	'SO' as Type
From OT2002 inner join OT2001 on OT2001.SOrderID = OT2002.SOrderID  and OT2001.OrderType = 0	
	left join AT1302 on AT1302.InventoryID = OT2002.InventoryID 
	left join AT1202 on AT1202.ObjectID = OT2001.ObjectID
	left join AT1004 on AT1004.CurrencyID = OT2001.CurrencyID
	left join OV9999 on OT2001.TranMonth = OV9999.TranMonth and OT2001.TranYear = OV9999.TranYear and OT2001.DivisionID = OV9999.DivisionID		
UNION
SELECT OT3001.DivisionID,
	OT3001.TranMonth,
	OT3001.TranYear,	
	OT3001.TranYear as Year,	  
	OV9999.MonthYear,
	OV9999.Quarter,
	OT3001.POrderID as VoucherID, 	
	OT3001.VoucherTypeID, 
	OT3001.VoucherNo, 
	OT3001.OrderDate as VoucherDate, 
	OT3001.OrderType, 
	OT3001.ObjectID, 
	case when isnull(OT3001.ObjectName, '') = '' then  AT1202.ObjectName else OT3001.ObjectName end as ObjectName,
	OT3001.Notes as VDescription, 
	OT3001.OrderStatus, 	
	OT3001.CurrencyID, 
	AT1004.CurrencyName,
	OT3001.ExchangeRate, 
	OT3001.EmployeeID, 
	OT3001.Disabled, 
	isnull(OT3001.Ana01ID, '') as VAna01ID, 		isnull(OT3001.Ana02ID, '') as VAna02ID, 		isnull(OT3001.Ana03ID, '') as VAna03ID, 	
	isnull(OT3001.Ana04ID, '') as VAna04ID, 		isnull(OT3001.Ana05ID, '') as VAna05ID,
	OT3002.TransactionID, 
	OT3002.InventoryID, 
	AT1302.InventoryName,
	OT3002.OrderQuantity as Quantity, 
	OT3002.PurchasePrice as UnitPrice,
	(isnull(OT3002.OriginalAmount, 0) - isnull(OT3002.VATOriginalAmount, 0) - isnull(OT3002.DiscountOriginalAmount, 0)) as OriginalAmount,
	(isnull(OT3002.ConvertedAmount, 0) - isnull(OT3002.VATConvertedAmount, 0) - isnull(OT3002.DiscountConvertedAmount, 0)) as ConvertedAmount,
	OT3002.Orders, 
	OT3002.Description as TDescription,  	
	isnull(OT3002.Ana01ID, '') as Ana01ID, 	isnull(OT3002.Ana02ID, '') as Ana02ID, 	
	isnull(OT3002.Ana03ID,'') as Ana03ID, 	isnull(OT3002.Ana04ID,'') as Ana04ID,
	isnull(OT3002.Ana05ID, '') as Ana05ID,
	OT3002.UnitID,	
	isnull(AT1302.S1, '')  as CI1ID,	isnull(AT1302.S2, '')  as CI2ID, 	isnull(AT1302.S3, '') as CI3ID,  
	isnull(AT1302.I01ID, '') as I01ID, 		isnull(AT1302.I02ID, '') as I02ID, 		isnull(AT1302.I03ID, '') as I03ID,
	isnull( AT1302.I04ID, '') as I04ID, 		isnull(AT1302.I05ID, '') as I05ID,
	isnull(AT1202.S1, '')  as CO1ID,	isnull(AT1202.S2, '') as CO2ID, 	isnull(AT1202.S3, '') as CO3ID,
	isnull(AT1202.O01ID, '') as O01ID,  isnull(AT1202.O02ID, '') as O02ID, 		
	isnull(AT1202.O03ID, '') as O03ID,	isnull( AT1202.O04ID, '') as O04ID,  	isnull(AT1202.O05ID, '') as O05ID,
	'PO' as Type
From OT3002 inner join OT3001 on OT3001.POrderID = OT3002.POrderID  and OT3001.OrderType = 0	
	left join AT1302 on AT1302.InventoryID = OT3002.InventoryID 
	left join AT1202 on AT1202.ObjectID = OT3001.ObjectID
	left join AT1004 on AT1004.CurrencyID = OT3001.CurrencyID
	left join OV9999 on OT3001.TranMonth = OV9999.TranMonth and OT3001.TranYear = OV9999.TranYear and OT3001.DivisionID = OV9999.DivisionID

GO


