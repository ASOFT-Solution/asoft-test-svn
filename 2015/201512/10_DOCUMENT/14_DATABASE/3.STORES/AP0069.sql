IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0069]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0069]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Lấy dữ liệu hóa đơn bán hàng để lập hàng bán trả lại (AF0069)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create by Tieu Mai on 16/12/2015: Thay câu query load chi tiết hóa đơn bán hàng hiện tại 
-- <Example>
---- 
CREATE PROCEDURE [DBO].[AP0069]
(
	@DivisionID AS NVARCHAR(50),	
	@VoucherID AS NVARCHAR(50) 
) 
AS

IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)

		Select AT9000.APK ,AT9000.DivisionID ,AT9000.VoucherID ,AT9000.BatchID ,AT9000.TransactionID ,AT9000.TableID ,AT9000.TranMonth ,
		AT9000.TranYear ,AT9000.TransactionTypeID ,AT9000.CurrencyID ,AT9000.ObjectID ,AT9000.CreditObjectID ,AT9000.VATNo ,AT9000.VATObjectID ,
		AT9000.VATObjectName ,AT9000.VATObjectAddress ,AT9000.DebitAccountID as CreditAccountID ,AT9000.ExchangeRate ,AT9000.UnitPrice ,
		AT9000.OriginalAmount ,AT9000.ConvertedAmount ,AT9000.ImTaxOriginalAmount ,AT9000.ImTaxConvertedAmount ,AT9000.ExpenseOriginalAmount ,
		AT9000.ExpenseConvertedAmount ,AT9000.IsStock ,AT9000.VoucherDate ,AT9000.InvoiceDate ,AT9000.VoucherTypeID ,AT9000.VATTypeID ,
		AT9000.VATGroupID ,AT9000.VoucherNo ,AT9000.Serial ,AT9000.InvoiceNo ,AT9000.Orders ,AT9000.EmployeeID ,AT9000.SenderReceiver ,
		AT9000.SRDivisionName ,AT9000.SRAddress ,AT9000.RefNo01 ,AT9000.RefNo02 ,AT9000.VDescription ,AT9000.BDescription ,AT9000.TDescription ,
		AT9000.Quantity ,AT9000.InventoryID ,AT9000.UnitID ,AT9000.Status ,AT9000.IsAudit ,AT9000.IsCost ,
		AT9000.Ana01ID ,AT9000.Ana02ID ,AT9000.Ana03ID ,AT9000.Ana04ID ,AT9000.Ana05ID ,
		AT9000.Ana06ID ,AT9000.Ana07ID ,AT9000.Ana08ID ,AT9000.Ana09ID ,AT9000.Ana10ID ,
		AT9000.PeriodID ,AT9000.ExpenseID ,AT9000.MaterialTypeID ,AT9000.ProductID ,AT9000.CreateDate ,AT9000.CreateUserID ,AT9000.LastModifyDate ,
		AT9000.LastModifyUserID ,AT9000.OriginalAmountCN ,AT9000.ExchangeRateCN ,AT9000.CurrencyIDCN ,AT9000.DueDays ,AT9000.PaymentID ,
		AT9000.DueDate ,AT9000.DiscountRate ,AT9000.OrderID ,AT9000.CreditBankAccountID ,AT9000.DebitBankAccountID ,AT9000.CommissionPercent ,
		AT9000.InventoryName1 ,AT9000.PaymentTermID ,AT9000.DiscountAmount ,AT9000.OTransactionID ,
		AT9000.IsMultiTax ,AT9000.VATOriginalAmount ,AT9000.VATConvertedAmount ,AT9000.ReVoucherID ,AT9000.ReBatchID ,AT9000.ReTransactionID ,
		AT9000.Parameter01 ,AT9000.Parameter02 ,AT9000.Parameter03 ,AT9000.Parameter04 ,AT9000.Parameter05 ,AT9000.Parameter06 ,
		AT9000.Parameter07 ,AT9000.Parameter08 ,AT9000.Parameter09 ,AT9000.Parameter10 ,AT1302.InventoryName, AT1302.IsSource,AT1302.IsLimitDate,
		AT1302.IsLocation, AT1302.IsStocked,AT1302.AccountID as IsDebitAccountID, AT1302.IsDiscount, AT1302.Barcode,
		AT9000.ConvertedUnitID, AT9000.ConvertedQuantity,
		AT9000.ConvertedPrice, AT9000.MarkQuantity,
		AT9000.UParameter01, AT9000.UParameter02, AT9000.UParameter03, AT9000.UParameter04, AT9000.UParameter05, WQ1309.Operator, WQ1309.ConversionFactor, WQ1309.DataType, WQ1309.FormulaDes
		,AT9000.InvoiceCode,AT9000.InvoiceSign,			
		O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
		O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
		AT01.StandardName S01Name, AT02.StandardName S02Name, AT03.StandardName S03Name, AT04.StandardName S04Name, AT05.StandardName S05Name,
		AT06.StandardName S06Name, AT07.StandardName S07Name, AT08.StandardName S08Name, AT09.StandardName S09Name, AT10.StandardName S10Name,
		AT11.StandardName S11Name, AT12.StandardName S12Name, AT13.StandardName S13Name, AT14.StandardName S14Name, AT15.StandardName S15Name,
		AT16.StandardName S16Name, AT17.StandardName S17Name, AT18.StandardName S18Name, AT19.StandardName S19Name, AT20.StandardName S20Name
		From AT9000 Left Join AT1302 On AT9000.InventoryID = AT1302.InventoryID And AT9000.DivisionID = AT1302.DivisionID
		Left join WQ1309
		On AT9000.DivisionID = WQ1309.DivisionID
		And AT9000.InventoryID = WQ1309.InventoryID
		And AT9000.ConvertedUnitID = WQ1309.ConvertedUnitID
		left join AT8899 O99 on O99.DivisionID = AT9000.DivisionID and O99.VoucherID = AT9000.VoucherID and O99.TransactionID = AT9000.TransactionID AND O99.TableID = 'AT9000'
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
		Where AT9000.VoucherID = @VoucherID And TransactionTypeID In ('T04','T64')  And AT9000.TableID ='AT9000'
		And AT9000.DivisionID = @DivisionID
		Order by Orders

ELSE
		Select AT9000.APK ,AT9000.DivisionID ,AT9000.VoucherID ,AT9000.BatchID ,AT9000.TransactionID ,AT9000.TableID ,AT9000.TranMonth ,
		AT9000.TranYear ,AT9000.TransactionTypeID ,AT9000.CurrencyID ,AT9000.ObjectID ,AT9000.CreditObjectID ,AT9000.VATNo ,AT9000.VATObjectID ,
		AT9000.VATObjectName ,AT9000.VATObjectAddress ,AT9000.DebitAccountID as CreditAccountID ,AT9000.ExchangeRate ,AT9000.UnitPrice ,
		AT9000.OriginalAmount ,AT9000.ConvertedAmount ,AT9000.ImTaxOriginalAmount ,AT9000.ImTaxConvertedAmount ,AT9000.ExpenseOriginalAmount ,
		AT9000.ExpenseConvertedAmount ,AT9000.IsStock ,AT9000.VoucherDate ,AT9000.InvoiceDate ,AT9000.VoucherTypeID ,AT9000.VATTypeID ,
		AT9000.VATGroupID ,AT9000.VoucherNo ,AT9000.Serial ,AT9000.InvoiceNo ,AT9000.Orders ,AT9000.EmployeeID ,AT9000.SenderReceiver ,
		AT9000.SRDivisionName ,AT9000.SRAddress ,AT9000.RefNo01 ,AT9000.RefNo02 ,AT9000.VDescription ,AT9000.BDescription ,AT9000.TDescription ,
		AT9000.Quantity ,AT9000.InventoryID ,AT9000.UnitID ,AT9000.Status ,AT9000.IsAudit ,AT9000.IsCost ,
		AT9000.Ana01ID ,AT9000.Ana02ID ,AT9000.Ana03ID ,AT9000.Ana04ID ,AT9000.Ana05ID ,
		AT9000.Ana06ID ,AT9000.Ana07ID ,AT9000.Ana08ID ,AT9000.Ana09ID ,AT9000.Ana10ID ,
		AT9000.PeriodID ,AT9000.ExpenseID ,AT9000.MaterialTypeID ,AT9000.ProductID ,AT9000.CreateDate ,AT9000.CreateUserID ,AT9000.LastModifyDate ,
		AT9000.LastModifyUserID ,AT9000.OriginalAmountCN ,AT9000.ExchangeRateCN ,AT9000.CurrencyIDCN ,AT9000.DueDays ,AT9000.PaymentID ,
		AT9000.DueDate ,AT9000.DiscountRate ,AT9000.OrderID ,AT9000.CreditBankAccountID ,AT9000.DebitBankAccountID ,AT9000.CommissionPercent ,
		AT9000.InventoryName1 ,AT9000.PaymentTermID ,AT9000.DiscountAmount ,AT9000.OTransactionID ,
		AT9000.IsMultiTax ,AT9000.VATOriginalAmount ,AT9000.VATConvertedAmount ,AT9000.ReVoucherID ,AT9000.ReBatchID ,AT9000.ReTransactionID ,
		AT9000.Parameter01 ,AT9000.Parameter02 ,AT9000.Parameter03 ,AT9000.Parameter04 ,AT9000.Parameter05 ,AT9000.Parameter06 ,
		AT9000.Parameter07 ,AT9000.Parameter08 ,AT9000.Parameter09 ,AT9000.Parameter10 ,AT1302.InventoryName, AT1302.IsSource,AT1302.IsLimitDate,
		AT1302.IsLocation, AT1302.IsStocked,AT1302.AccountID as IsDebitAccountID, AT1302.IsDiscount, AT1302.Barcode,
		AT9000.ConvertedUnitID, AT9000.ConvertedQuantity,
		AT9000.ConvertedPrice, AT9000.MarkQuantity,
		AT9000.UParameter01, AT9000.UParameter02, AT9000.UParameter03, AT9000.UParameter04, AT9000.UParameter05, WQ1309.Operator, WQ1309.ConversionFactor, WQ1309.DataType, WQ1309.FormulaDes
		,AT9000.InvoiceCode,AT9000.InvoiceSign
		From AT9000 Left Join AT1302 On AT9000.InventoryID = AT1302.InventoryID And AT9000.DivisionID = AT1302.DivisionID
		Left join WQ1309
		On AT9000.DivisionID = WQ1309.DivisionID
		And AT9000.InventoryID = WQ1309.InventoryID
		And AT9000.ConvertedUnitID = WQ1309.ConvertedUnitID		
		Where AT9000.VoucherID = @VoucherID And TransactionTypeID In ('T04','T64')  And AT9000.TableID ='AT9000'
		And AT9000.DivisionID = @DivisionID
		Order by Orders
		
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON		
