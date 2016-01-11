IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP03212]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP03212]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load lưới phiếu mua hàng - Cập nhật phân bổ chi phí mua hàng[Customize LAVO] TH VIEW/EDIT
-- <History>
---- Create on 03/03/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
 AP03212 @DivisionID = 'LV', @VoucherID = 'E87C1D15-5811-49E9-8373-15524EBAD115', @VoucherIDList = 'TVc1884bcc-ceb8-4097-8847-822ff8a30207'
 */

CREATE PROCEDURE [dbo].[AP03212] 	
	@DivisionID NVARCHAR(50),
	@VoucherID NVARCHAR(50),
	@VoucherIDList NVARCHAR(MAX)
AS
DECLARE @sSQL1 NVARCHAR(MAX) = '',
		@sWHERE NVARCHAR(MAX) = ''

IF ISNULL(@VoucherID,'') <> '' -- Trường hợp Load form gọi từ AF0302
	BEGIN
	SET @sSQL1 = '
SELECT AT21.VoucherID, AT21.TransactionID, AT21.POCVoucherID, AT21.POVoucherID, AT90.BatchID, AT21.POTransactionID, AT21.[Check],
	   AT90.VoucherDate, AT90.VoucherNo, AT90.InventoryID, AT13.InventoryName, AT90.UnitID, 
	   ISNULL(AT90.Quantity,0) AS Quantity, ISNULL(AT90.UnitPrice,0) AS UnitPrice, 
	   ISNULL(AT90.OriginalAmount,0) AS OriginalAmount, 
	   ISNULL(AT90.ConvertedAmount,0)AS ConvertedAmount, 
	   ISNULL(AT21.ExpenseConvertedAmount,0) AS ExpenseConvertedAmount, 
	   AT90.CurrencyID, ISNULL(AT90.ExchangeRate,0) AS ExchangeRate, 
	   AT90.ObjectID, ISNULL(AT90.IsStock,0) AS IsStock, 
	   AT90.DebitAccountID, AT90.CreditAccountID, AT90.TDescription, 
	   AT90.VATTypeID, AT90.InvoiceDate, AT90.InvoiceNo, AT90.Serial, 
	   AT90.Ana01ID, AT90.Ana02ID, AT90.Ana03ID, AT90.Ana04ID, AT90.Ana05ID, 
	   AT90.Ana06ID, AT90.Ana07ID, AT90.Ana08ID, AT90.Ana09ID, AT90.Ana10ID, AT13.IsStocked, 
	   ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal, AT12.ObjectName
FROM AT0321 AT21
LEFT JOIN AT9000 AT90 ON AT90.DivisionID = AT21.DivisionID AND AT90.VoucherID = AT21.POVoucherID AND AT90.TransactionID = AT21.POTransactionID
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = AT90.DivisionID AND AT12.ObjectID = AT90.ObjectID
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = AT90.DivisionID AND AT13.InventoryID = AT90.InventoryID
LEFT JOIN AT1004 AT14 ON AT14.DivisionID = AT90.DivisionID AND AT14.CurrencyID = AT90.CurrencyID
WHERE AT21.DivisionID = '''+@DivisionID+''' AND AT21.VoucherID = '''+@VoucherID+''' 
	  AND AT90.TransactionTypeID IN (''T03'')
ORDER BY AT90.VoucherDate, AT90.VoucherNo, AT90.InventoryID
'
	END
ELSE -- Trường hợp Load form gọi từ AF0300
	BEGIN	
	SET @sSQL1 = '
SELECT AT90.VoucherID AS POVoucherID, AT90.BatchID, AT90.TransactionID AS POTransactionID, CONVERT(TINYINT,1) AS [Check],
	   AT90.VoucherDate, AT90.VoucherNo, AT90.InventoryID, AT13.InventoryName, AT90.UnitID, 
	   ISNULL(AT90.Quantity,0) AS Quantity, ISNULL(AT90.UnitPrice,0) AS UnitPrice, 
	   ISNULL(AT90.OriginalAmount,0) AS OriginalAmount, 
	   ISNULL(AT90.ConvertedAmount,0)AS ConvertedAmount, 
	   ISNULL(AT90.ExpenseConvertedAmount,0) AS ExpenseConvertedAmount, 
	   AT90.CurrencyID, ISNULL(AT90.ExchangeRate,0) AS ExchangeRate, 
	   AT90.ObjectID, ISNULL(AT90.IsStock,0) AS IsStock, 
	   AT90.DebitAccountID, AT90.CreditAccountID, AT90.TDescription, 
	   AT90.VATTypeID, AT90.InvoiceDate, AT90.InvoiceNo, AT90.Serial, 
	   AT90.Ana01ID, AT90.Ana02ID, AT90.Ana03ID, AT90.Ana04ID, AT90.Ana05ID, 
	   AT90.Ana06ID, AT90.Ana07ID, AT90.Ana08ID, AT90.Ana09ID, AT90.Ana10ID, AT13.IsStocked,
	   ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal, AT12.ObjectName
FROM AT9000 AT90 
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = AT90.DivisionID AND AT12.ObjectID = AT90.ObjectID
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = AT90.DivisionID AND AT13.InventoryID = AT90.InventoryID
LEFT JOIN AT1004 AT14 ON AT14.DivisionID = AT90.DivisionID AND AT14.CurrencyID = AT90.CurrencyID
WHERE AT90.DivisionID = '''+@DivisionID+''' AND AT90.TransactionTypeID IN (''T03'')
	  AND AT90.VoucherID IN ('''+@VoucherIDList+''')
ORDER BY  AT90.VoucherDate, AT90.VoucherNo, AT90.InventoryID
'
	END

EXEC (@sSQL1)
--PRINT @sSQL1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
