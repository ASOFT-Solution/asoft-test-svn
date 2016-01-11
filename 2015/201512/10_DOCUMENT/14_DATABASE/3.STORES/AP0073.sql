IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0073]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0073]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load Grid chi tiết hàng mua trả lại
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 23/06/2015
---- Modified on 
-- <Example>
/*
	AP0073 'HD', '', 'TV20150000000001' 
*/
CREATE PROCEDURE AP0073
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@VoucherID VARCHAR(50)
)
AS
SELECT A90.APK, A90.DivisionID, A90.VoucherID, A90.BatchID, A90.TransactionID, A90.TableID,
	A90.TranMonth, A90.TranYear, A90.TransactionTypeID, A90.CurrencyID, A90.ObjectID,
	A90.CreditObjectID, A90.VATNo, A90.VATObjectID, A90.VATObjectName, A90.VATObjectAddress,
	A90.DebitAccountID, A90.CreditAccountID, A90.ExchangeRate, A90.UnitPrice, A90.OriginalAmount,
	A90.ConvertedAmount, A90.ImTaxOriginalAmount, A90.ImTaxConvertedAmount, A90.ExpenseOriginalAmount,
	A90.ExpenseConvertedAmount, A90.IsStock, A90.VoucherDate, A90.InvoiceDate, A90.VoucherTypeID,
	A90.VATTypeID, A90.VATGroupID, A90.VoucherNo, A90.Serial, A90.InvoiceNo, A90.Orders, A90.EmployeeID,
	A90.SenderReceiver, A90.SRDivisionName, A90.SRAddress, A90.RefNo01, A90.RefNo02, A90.VDescription,
	A90.BDescription, A90.TDescription, A90.Quantity, A90.InventoryID, A90.UnitID, A90.[Status], A90.IsAudit,
	A90.IsCost, A90.Ana01ID, A90.Ana02ID, A90.Ana03ID, A90.PeriodID, A90.ExpenseID, A90.MaterialTypeID,
	A90.ProductID, A90.CreateDate, A90.CreateUserID, A90.LastModifyDate, A90.LastModifyUserID, A90.OriginalAmountCN,
	A90.ExchangeRateCN, A90.CurrencyIDCN, A90.DueDays, A90.PaymentID, A90.DueDate, A90.DiscountRate, A90.OrderID,
	A90.CreditBankAccountID, A90.DebitBankAccountID, A90.CommissionPercent, A90.Ana04ID, A90.Ana05ID, A90.PaymentTermID,
	A90.DiscountAmount, A90.OTransactionID, A90.IsMultiTax, A90.VATOriginalAmount, A90.VATConvertedAmount,
	A90.ReVoucherID, A90.ReBatchID, A90.ReTransactionID, A02.InventoryName, A02.IsSource, A02.IsLimitDate,
	A02.IsLocation, A02.IsStocked, A02.AccountID AS IsDebitAccountID, A90.Ana06ID, A90.Ana07ID, A90.Ana08ID,
	A90.Ana09ID, A90.Ana10ID, A90.InvoiceCode, A90.InvoiceSign,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
	AT01.StandardName S01Name, AT02.StandardName S02Name, AT03.StandardName S03Name, AT04.StandardName S04Name, AT05.StandardName S05Name,
	AT06.StandardName S06Name, AT07.StandardName S07Name, AT08.StandardName S08Name, AT09.StandardName S09Name, AT10.StandardName S10Name,
	AT11.StandardName S11Name, AT12.StandardName S12Name, AT13.StandardName S13Name, AT14.StandardName S14Name, AT15.StandardName S15Name,
	AT16.StandardName S16Name, AT17.StandardName S17Name, AT18.StandardName S18Name, AT19.StandardName S19Name, AT20.StandardName S20Name,
	O99.UnitPriceStandard
FROM AT9000 A90
	LEFT JOIN AT1302 A02 ON A90.DivisionID = A02.DivisionID AND A90.InventoryID = A02.InventoryID
	LEFT JOIN AT8899 O99 ON O99.TransactionID = A90.TransactionID
	LEFT JOIN AT0128 AT01 ON AT01.StandardID = O99.S01ID AND AT01.StandardTypeID = 'S01'
	LEFT JOIN AT0128 AT02 ON AT02.StandardID = O99.S02ID AND AT02.StandardTypeID = 'S02'
	LEFT JOIN AT0128 AT03 ON AT03.StandardID = O99.S03ID AND AT03.StandardTypeID = 'S03'
	LEFT JOIN AT0128 AT04 ON AT04.StandardID = O99.S04ID AND AT04.StandardTypeID = 'S04'
	LEFT JOIN AT0128 AT05 ON AT05.StandardID = O99.S05ID AND AT05.StandardTypeID = 'S05'
	LEFT JOIN AT0128 AT06 ON AT06.StandardID = O99.S06ID AND AT06.StandardTypeID = 'S06'
	LEFT JOIN AT0128 AT07 ON AT07.StandardID = O99.S07ID AND AT07.StandardTypeID = 'S07'
	LEFT JOIN AT0128 AT08 ON AT08.StandardID = O99.S08ID AND AT08.StandardTypeID = 'S08'
	LEFT JOIN AT0128 AT09 ON AT09.StandardID = O99.S09ID AND AT09.StandardTypeID = 'S09'
	LEFT JOIN AT0128 AT10 ON AT10.StandardID = O99.S10ID AND AT10.StandardTypeID = 'S10'
	LEFT JOIN AT0128 AT11 ON AT11.StandardID = O99.S11ID AND AT11.StandardTypeID = 'S11'
	LEFT JOIN AT0128 AT12 ON AT12.StandardID = O99.S12ID AND AT12.StandardTypeID = 'S12'
	LEFT JOIN AT0128 AT13 ON AT13.StandardID = O99.S13ID AND AT13.StandardTypeID = 'S13'
	LEFT JOIN AT0128 AT14 ON AT14.StandardID = O99.S15ID AND AT14.StandardTypeID = 'S14'
	LEFT JOIN AT0128 AT15 ON AT15.StandardID = O99.S15ID AND AT15.StandardTypeID = 'S15'
	LEFT JOIN AT0128 AT16 ON AT16.StandardID = O99.S16ID AND AT16.StandardTypeID = 'S16'
	LEFT JOIN AT0128 AT17 ON AT17.StandardID = O99.S17ID AND AT17.StandardTypeID = 'S17'
	LEFT JOIN AT0128 AT18 ON AT18.StandardID = O99.S18ID AND AT18.StandardTypeID = 'S18'
	LEFT JOIN AT0128 AT19 ON AT19.StandardID = O99.S19ID AND AT19.StandardTypeID = 'S19'
	LEFT JOIN AT0128 AT20 ON AT20.StandardID = O99.S20ID AND AT20.StandardTypeID = 'S20'
WHERE A90.DivisionID = @DivisionID
	AND A90.VoucherID = @VoucherID
	AND A90.TransactionTypeID IN ('T25')
	AND A90.TableID = 'AT9000'
ORDER BY A90.Orders

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
