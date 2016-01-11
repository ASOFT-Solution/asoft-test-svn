IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP0063]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP0063]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- Created on 24/09/2013 by Bảo Anh
--- Load edit phiếu mua hàng
--- Modified on 05/05/2015 by Lê Thị Hạnh: Bổ sung 3 trường Inherit [ABA]
--- Modified on 01/07/2015 by Bảo Anh: Sửa điều kiện where TransactionTypeID = 'T03'
--- Modified on 03/07/2015 by Lê Thị Hạnh: Bổ sung các trường SET của thuế TTĐB
--- EXEC AP0063 'TL','TV20120000003522'

CREATE PROCEDURE [dbo].[AP0063]
	@DivisionID nvarchar(50),
	@VoucherID nvarchar(50)	
AS
SELECT DISTINCT
		AT9000.VoucherID,
		AT9000.BatchID,
		AT9000.TransactionID,
		AT9000.TableID,
		AT9000.DivisionID,
		AT9000.TranMonth,
		AT9000.TranYear,
		AT9000.TransactionTypeID,
		AT9000.CurrencyID,
		AT9000.ObjectID,
		AT9000.VATObjectID,
		AT9000.VATObjectName,
		AT9000.VATNo,
		AT9000.VATObjectAddress,
		AT9000.SRDivisionName,
		AT9000.SRAddress,
		AT9000.SenderReceiver,
		AT9000.CreditAccountID,
		AT9000.DebitAccountID,
		AT9000.ExchangeRate,
		AT9000.OriginalAmount,
		AT9000.ConvertedAmount,
		AT9000.IsMultiTax,
		AT9000.VATGroupID,
		AT9000.VATOriginalAmount,
		AT9000.VATConvertedAmount,
		AT9000.VoucherDate,
		AT9000.DueDate,
		AT9000.OriginalAmountCN,
		AT9000.ExchangeRateCN,
		AT9000.CurrencyIDCN,
		AT9000.InvoiceDate,
		AT9000.VoucherTypeID,
		AT9000.VATTypeID,
		AT9000.VoucherNo,
		AT9000.Serial,
		AT9000.InvoiceNo,
		AT9000.Orders,
		AT9000.EmployeeID,
		AT9000.RefNo01,
		AT9000.RefNo02,
		AT9000.VDescription,
		AT9000.BDescription,
		AT9000.TDescription,
		AT9000.Quantity,
		AT9000.UnitPrice,
		AT9000.MarkQuantity,
		AT9000.DiscountRate,
		AT9000.DiscountAmount,
		AT9000.InventoryID,
		AT9000.UnitID,
		AT9000.Status,
		AT9000.IsAudit,
		AT9000.ImTaxOriginalAmount,
		AT9000.ImTaxConvertedAmount,
		AT9000.ExpenseOriginalAmount,
		AT9000.ExpenseConvertedAmount,
		AT9000.Ana01ID,
		AT9000.Ana02ID,
		AT9000.Ana03ID,
		AT9000.Ana04ID,
		AT9000.Ana05ID,
		AT9000.Ana06ID,
		AT9000.Ana07ID,
		AT9000.Ana08ID,
		AT9000.Ana09ID,
		AT9000.Ana10ID,
		AT9000.CreateDate,
		AT9000.CreateUserID,
		AT9000.LastModifyDate,
		AT9000.LastModifyUserID,
		AT9000.ReVoucherID,
		AT9000.IsStock,
		AT9000.InventoryName1,
		AT9000.OrderID,
		AT9000.OTransactionID,
		AT1302.InventoryName,
		AT1302.IsSource,
		AT1302.IsLimitDate,
		AT1302.IsLocation,
		AT1302.IsStocked,
		AT1302.AccountID AS IsDebitAccountID,
		AT9000.ConversionFactor,
		0 AS F11,
		AT9000.IsLateInvoice,
		AT9000.RefVoucherNo,
		AT9000.ReBatchID,
		AT9000.ReTransactionID,
		AT9000.ConvertedUnitID,
		AT9000.UParameter01,
		AT9000.UParameter02,
		AT9000.UParameter03,
		AT9000.UParameter04,
		AT9000.UParameter05,
		AT9000.ConvertedQuantity,
		AT9000.ConvertedPrice,
		WQ1309.Operator, WQ1309.DataType, AT1319.FormulaDes,
		AT9000.PaymentTermID,
		AT9000.WOrderID,
		AT9000.WTransactionID,
		AT1302.Barcode,
		AT9000.PriceListID,
		AT9000.InvoiceCode,
		AT9000.InvoiceSign, AT9000.InheritTableID, AT9000.InheritVoucherID, AT9000.InheritTransactionID, 
		AT9000.AssignedSET, AT9000.SETOriginalAmount, AT9000.SETConvertedAmount, AT9000.SETQuantity, AT9000.AssignedSET,
		AT9000.SETID, AT9000.SETTaxRate, AT9000.SETConvertedUnit, AT9000.SETQuantity, AT9000.SETOriginalAmount, 
		AT9000.SETConvertedAmount, AT9000.SETConsistID, AT9000.SETTransactionID, AT9000.SETUnitID	
		FROM AT9000
		LEFT JOIN AT1302 ON AT1302.DivisionID = AT9000.DivisionID AND AT9000.InventoryID = AT1302.InventoryID
		LEFT JOIN AT1309 WQ1309 On WQ1309.DivisionID = AT9000.DivisionID AND WQ1309.InventoryID = AT9000.InventoryID AND WQ1309.UnitID = AT9000.ConvertedUnitID
		LEFT JOIN AT1319 On WQ1309.DivisionID = AT1319.DivisionID and WQ1309.FormulaID = AT1319.FormulaID		
		WHERE AT9000.DivisionID = @DivisionID
		AND AT9000.VoucherID = @VoucherID
		--AND AT9000.TransactionTypeID Not In ('T13','T33','T23')
		AND AT9000.TransactionTypeID = 'T03'
		AND AT9000.TableID = 'AT9000'		
		ORDER BY AT9000.Orders		
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


