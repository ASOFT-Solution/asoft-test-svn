IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0299]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0299]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Detail cho màn hình AF0301 - Quản lý lịch sử mặt hàng [Customize SGPT]
-- <History>
---- Create on 01/12/2014 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/* 
AP0299 @DivisionID ='IPL', @VoucherID = 'AV20130000008298', @InVoucherID = 'TV20140000000001'
 */
CREATE PROCEDURE [dbo].[AP0299] 	
	@DivisionID NVARCHAR(50),
	@VoucherID NVARCHAR(50),
	@InVoucherID NVARCHAR(50) -- Truyền vào khi Edit
AS
DECLARE @sSQL1 NVARCHAR(MAX)
SET @VoucherID = ISNULL(@VoucherID,'')
-- Load dữ liệu cho Detail cho lưới
SET @sSQL1 = '
SELECT ''AT9000'' AS ReTableID, AT90.VoucherID, AT90.TransactionID AS ReTransactionID, AT90.TransactionTypeID, AT90.Orders,
		AT90.InventoryID, AT02.InventoryName, AT90.UnitID, ISNULL(AT90.Quantity,0) AS Quantity,
		ISNULL(AT90.UnitPrice,0) AS UnitPrice, ISNULL(AT90.OriginalAmount,0) AS OriginalAmount, 
		ISNULL(AT90.ConvertedAmount,0) AS ConvertedAmount, ISNULL(AT90.ImTaxOriginalAmount,0) AS ImTaxOriginalAmount, 
		ISNULL(AT90.ImTaxConvertedAmount,0) AS ImTaxConvertedAmount, ISNULL(AT90.ExpenseOriginalAmount,0) AS ExpenseOriginalAmount, 
		ISNULL(AT90.ExpenseConvertedAmount,0) AS ExpenseConvertedAmount, AT90.TDescription,
		AT90.[Status], AT90.IsAudit, AT90.IsCost, AT90.Ana01ID, AT90.Ana02ID, AT90.Ana03ID, 
		AT90.Ana04ID, AT90.Ana05ID, AT90.Ana06ID, AT90.Ana07ID, AT90.Ana08ID, AT90.Ana09ID, AT90.Ana10ID,
		ISNULL(AT90.DiscountRate,0) AS DiscountRate,  ISNULL(AT90.DiscountAmount,0) AS DiscountAmount, 
		ISNULL(AT90.VATOriginalAmount,0) AS VATOriginalAmount, ISNULL(AT90.VATConvertedAmount,0) AS VATConvertedAmount, 
		AT90.Parameter01, AT90.Parameter02, AT90.Parameter03, AT90.Parameter04, 
		AT90.Parameter05, AT90.Parameter06, AT90.Parameter07, AT90.Parameter08, AT90.Parameter09, AT90.Parameter10,
		ISNULL(AT90.IsLateInvoice,0) AS IsLateInvoice, ISNULL(AT90.ConvertedQuantity,0) AS ConvertedQuantity, 
		ISNULL(AT90.ConvertedPrice,0) AS ConvertedPrice, AT90.ConvertedUnitID, 
		ISNULL(AT90.ConversionFactor,  WQ09.ConversionFactor) AS ConversionFactor,
		AT90.UParameter01, AT90.UParameter02, AT90.UParameter03, AT90.UParameter04, AT90.UParameter05,
		ISNULL(AT90.MarkQuantity,0) AS MarkQuantity, ISNULL(AT90.StandardPrice,0) AS StandardPrice, 
		ISNULL(AT90.StandardAmount,0) AS StandardAmount, ISNULL(AT90.IsCom,0) AS IsCom, AT90.DParameter01, AT90.DParameter02, 
		AT90.DParameter03, AT90.DParameter04, AT90.DParameter05, AT90.DParameter06,	AT90.DParameter07, AT90.DParameter08, 
		AT90.DParameter09, AT90.DParameter10, ISNULL(AT90.OriginalAmountCN,0) AS OriginalAmountCN, 
		AT90.DebitAccountID AS DebitAccountID, AT90.CreditAccountID AS CreditAccountID,
		AT02.AccountID as IsDebitAccountID, AT02.IsSource, AT02.IsLimitDate, AT02.IsLocation, AT02.IsStocked,
        AT02.IsDiscount, AT02.Barcode, WQ09.Operator, WQ09.DataType, WQ09.FormulaDes,
        AT90.PeriodID, AT90.ExpenseID, AT90.MaterialTypeID, AT90.ProductID        	      
FROM AT9000 AT90
LEFT JOIN WQ1309 WQ09 ON WQ09.DivisionID = AT90.DivisionID AND WQ09.InventoryID = AT90.InventoryID AND WQ09.ConvertedUnitID = AT90.ConvertedUnitID
LEFT JOIN AT1302 AT02 ON AT02.DivisionID = AT90.DivisionID AND AT02.InventoryID = AT90.InventoryID
WHERE AT90.DivisionID = '''+@DivisionID+''' AND AT90.VoucherID = '''+@VoucherID+''' AND AT90.TransactionTypeID IN (''T04'',''T64'') 
AND AT90.TableID = ''AT9000''
ORDER BY AT90.Orders
	'
EXEC (@sSQL1)
--PRINT (@sSQL1)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

