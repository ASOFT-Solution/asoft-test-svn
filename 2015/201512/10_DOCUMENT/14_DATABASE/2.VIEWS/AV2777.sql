
/****** Object:  View [dbo].[AV2777]    Script Date: 12/16/2010 14:57:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---Thuy Tuyen
---date 13/12/2006
---Lay du lieu so du (Detail)
ALTER VIEW [dbo].[AV2777]
as
Select 
TransactionID, VoucherID, '' as BatchID, InventoryID, UnitID, 
ActualQuantity, UnitPrice, OriginalAmount, ConvertedAmount,
 Notes, TranMonth, TranYear, DivisionID, CurrencyID, ExchangeRate,
 SaleUnitPrice, SaleAmount, DiscountAmount, SourceNo, DebitAccountID, CreditAccountID,
 LocationID, ImLocationID, LimitDate, Orders,
 ConversionFactor, ReTransactionID, ReVoucherID, Ana01ID, Ana02ID, Ana03ID,  '' as PeriodID, 
 '' as ProductID, '' as OrderID, '' as InventoryName1
From AT2017
union
Select 
TransactionID, VoucherID, BatchID, InventoryID, UnitID, 
ActualQuantity, UnitPrice, OriginalAmount, ConvertedAmount,
 Notes, TranMonth, TranYear, DivisionID, CurrencyID, ExchangeRate,
 SaleUnitPrice, SaleAmount, DiscountAmount, SourceNo, DebitAccountID, CreditAccountID,
 LocationID, ImLocationID, LimitDate, Orders,
 ConversionFactor, ReTransactionID, ReVoucherID, Ana01ID, Ana02ID, Ana03ID, PeriodID, 
ProductID, OrderID, InventoryName1
From AT2007

GO


