IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3021_2T]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3021_2T]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Created by Khanh Van
--Date 28/08/2013
--Purpose: In bao cao chi tiet doanh so ban hang theo mat hang cho 2T, thêm vào ConvertedQuantity

CREATE PROCEDURE [dbo].[AP3021_2T] 
	(
		@DivisionID AS nvarchar(50) ,
		@sSQLWhere AS nvarchar(4000)  
	)
AS

DECLARE @sSQL1 AS nvarchar(4000) ,
		@sSQL2 AS nvarchar(4000) ,
		@sWhere AS NVARCHAR(4000)

SET @sWhere = N''
		
set @sSQL1=N'
SELECT  AT9000.InventoryID,
		AT1302.InventoryName,
		CASE WHEN ISNULL(AT9000.InventoryName1,'''')= '''' then  isnull(AT1302.InventoryName,'''')  Else AT9000.InventoryName1 end AS InventoryName1,
		(Select WarehouseID from AT2006 where AT2006.DivisionID = AT9000.DivisionID and AT2006.VoucherID = AT9000.VoucherID) as WarehouseID,
		AT1302.UnitID,
		AT1302.S1,
		AT1302.S2,
		AT1302.S3,
		AT1304.UnitName,
	    AT9000.Serial,
		AT9000.ObjectID,
		AT1202.ObjectName,
		AT9000.VATObjectID,
		OB.ObjectName AS VATObjectName,
		AT1202.Address,
		AT9000.VoucherID,
		AT9000.InvoiceNo,
		AT9000.VoucherDate,
		AT9000.VoucherNo,
		AT9000.DebitAccountID,
		AT9000.CreditAccountID,
		AT9000.InvoiceDate,
		AT9000.Quantity,
		AT9000.ConvertedQuantity,
		AT9000.MarkQuantity,
		AT9000.UnitPrice,
		AT9000.ConvertedPrice,
		AT9000.CurrencyID,
		AT9000.OriginalAmount,
		AT9000.ConvertedAmount , VATRate,
		AT9000.VDescription, AT9000.BDescription, AT9000.TDescription,
		(Isnull (AT9000.OriginalAmount,0) * Isnull (VATRate,0))/100  AS VATOriginalAmount,
		(Isnull (AT9000.ConvertedAmount,0) * Isnull (VATRate,0))/100  AS VATConvertedAmount,
		(Isnull (AT9000.UnitPrice,0) * Isnull (VATRate,0))/100  + Isnull(AT9000.UnitPrice,0) AS VATUnitPrice,
		(SELECT Sum(Isnull (T9.OriginalAmount,0)) From AT9000 T9 Where T9.VoucherID = AT9000.VoucherID And T9.TransactionTypeID = ''T14'')  AS VATOriginalAmountForInvoice,
		(SELECT Sum(Isnull (T9.ConvertedAmount,0)) From AT9000 T9 Where T9.VoucherID = AT9000.VoucherID And T9.TransactionTypeID = ''T14'')  AS VATConvertedAmountForInvoice,
		AT9000.VoucherTypeID, AT9000.DiscountRate, AT9000.DiscountAmount, AT9000.DivisionID,
		AT9000.UParameter01, AT9000.UParameter02, AT9000.UParameter03, AT9000.UParameter04, AT9000.UParameter05,
		AT1302.IsStocked, 		V70.Notes01, V70.Notes02, V70.Notes03, V70.Notes04, V70.Notes05, V70.Notes06, V70.Notes07, V70.Notes08, V70.Notes09, V70.Notes10, V70.Notes11, V70.Notes12, V70.Notes13, V70.Notes14, V70.Notes15, V70.SourceNo, V70.Parameter01, V70.Parameter02, V70.Parameter03, V70.Parameter04, V70.Parameter05, isnull(V00.ConvertedAmount,0) as Commission

		'
		
set @sSQL2=N'
FROM AT9000 	
LEFT JOIN AT1302 on AT9000.InventoryID=AT1302.InventoryID and AT9000.DivisionID=AT1302.DivisionID
LEFT JOIN AT1304 on AT1302.UnitID=AT1304.UnitID  and AT9000.DivisionID=AT1304.DivisionID
LEFT JOIN AT1202 on AT1202.ObjectID = AT9000.ObjectID  and AT9000.DivisionID=AT1202.DivisionID
LEFT JOIN AT1202 OB on OB.ObjectID = AT9000.VATObjectID  and AT9000.DivisionID=OB.DivisionID
LEFT JOIN AT1010 on AT1010.VATGroupID = AT9000.VATGroupID  and AT9000.DivisionID=AT1010.DivisionID
Left JOIN AT2007 V70 ON AT9000.DivisionID = V70.DivisionID AND AT9000.VoucherID = V70.VoucherID and AT9000.InventoryID = V70.InventoryID and AT9000.Orders = V70.Orders
Left Join (Select * from AT9000 where TransactionTypeID = ''T54'') V00 ON AT9000.DivisionID = V00.DivisionID AND AT9000.VoucherID = V00.VoucherID and AT9000.InventoryID = V00.InventoryID and AT9000.Orders = V00.Orders
WHERE	AT9000.DivisionID='''+@DivisionID+'''
		AND AT9000.TransactionTypeID in  (''T04'',''T40'')
'

IF ISNULL(@sSQLWhere,'') <> ''
SET @sWhere = N' 
		AND '+@sSQLWhere+''
		
--PRINT(@sSQL1)
--PRINT(@sSQL2)

IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE NAME = 'AV3021' AND XTYPE ='V')
	EXEC ('CREATE VIEW AV3021 -- AP3021
	AS '+@sSQL1+@sSQL2 +@sWhere)
ELSE
	EXEC ('ALTER VIEW AV3021 ---- AP3021
	AS '+@sSQL1+@sSQL2 +@sWhere)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON