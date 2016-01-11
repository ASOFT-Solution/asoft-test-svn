/****** Object:  View [dbo].[OV0055]    Script Date: 12/16/2010 15:50:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Load edit , load truy van man hinh but toan mau
-- Date: 04/06/2009
-- Thuy Tuyen, date 23/10/2009
ALTER VIEW [dbo].[OV0055]
as

Select 
	OT9002.TemplateTransactionID, OT9002.TemplateID, OT9002.IsStockVoucher,
	OT9002.DescriptionV, OT9002.TableID, OT9002.VoucherTypeID, 
	OT9002.CurrencyID, OT9002.ExchangeRate, OT9002.ClassifyID, 
	OT9002.InventoryTypeID, OT9002.EmployeeID, OT9002.Description, 
	OT9002.ObjectID,AT1202.ObjectName,
	OT9002.VATObjectID,
	 OT9002.VATObjectName, 
	OT9002.Address, OT9002.VatNo, 
	OT9002.Contact, OT9002.DeliveryAddress, 
	OT9002.OP01ID, OT9002.OP02ID, OT9002.OP03ID, 
	OT9002.OP04ID, OT9002.OP05ID, OT9002.DivisionID, 
	OT9002.CreateDate, OT9002.CreateUserID, OT9002.LastModifyUserID, 
	OT9002.LastModifyDate, OT9002.Orders, OT9002.InventoryID, AT1302.InventoryName,
	OT9002.UnitID, OT9002.Quantity, OT9002.UnitPrice, OT9002.OriginalAmount,
	OT9002.ConvertedAmount, OT9002.VATGroupID, OT9002.VATPercent, OT9002.VAtOriginalAmount,
	OT9002.DiscountPercent,
	OT9002.DiscountOriginalAmount, OT9002.CommissionPercent, OT9002.CommissionOAmount,
	OT9002.Notes, OT9002.Notes01, OT9002.Notes02, 
	OT9002.Ana01ID, OT9002.Ana02ID, OT9002.Ana03ID, OT9002.Ana04ID, OT9002.Ana05ID,
	OT9002.Ana06ID, OT9002.Ana07ID, OT9002.Ana08ID, OT9002.Ana09ID, OT9002.Ana10ID,
	OT9002.ConvertedQuantity , OT9002.ConvertedUnitPrice 

From OT9002
	Inner Join  AT1202 on  AT1202.ObjectID = OT9002.ObjectID And AT1202.DivisionID = OT9002.DivisionID
	Inner Join  AT1302 on  AT1302.InventoryID = OT9002.InventoryID And AT1302.DivisionID = OT9002.DivisionID

GO


