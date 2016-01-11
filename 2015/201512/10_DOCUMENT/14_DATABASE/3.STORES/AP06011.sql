IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP06011]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP06011]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Created by Khanh Van
--Date 27/08/2013
--Purpose: Dung cho Report Doanh so hang mua theo mat hang(chi tiet) 2T

----
CREATE PROCEDURE [dbo].[AP06011] 
(	
	@DivisionID AS nvarchar(50), 
	@sSQLWhere AS nvarchar(4000), 
	@Group1ID AS tinyint,	---- = 0 la theo loai mat hang.
							---  = 1 la theo tai khoan doanh so
							---  = 2 la theo doi tuong
	@Group2ID AS TINYINT
)
AS

DECLARE @sSQL AS nvarchar(MAX)
DECLARE @sSQL1 AS nvarchar(MAX)
DECLARE @sWHERE AS NVARCHAR(MAX)
SET @sWHERE = ''

IF @sSQLWhere <> ''
SET @sWHERE = ' AND ' + @sSQLWhere

Set @sSQL='		
		SELECT	
				' + (CASE WHEN @Group1ID = 0 then 'AT9000.InventoryID'	when @Group1ID = 1 then 'AT9000.DebitAccountID'	else 'AT9000.ObjectID' end) + ' AS Group1ID,
				' + (CASE WHEN @Group1ID = 0 then 'AT1302.InventoryName'when @Group1ID = 1 then 'AT1005.AccountName' else 'AT1202.ObjectName' end) + ' AS Group1Name,
				' + (CASE WHEN @Group2ID = 0 then 'AT9000.InventoryID'	when @Group2ID = 1 then 'AT9000.DebitAccountID'	else 'AT9000.ObjectID' end) + ' AS Group2ID,
				' + (CASE WHEN @Group2ID = 0 then 'AT1302.InventoryName'when @Group2ID = 1 then 'AT1005.AccountName' else 'AT1202.ObjectName' end) + ' AS Group2Name,
				AT9000.VoucherDate,
		AT9000.VoucherID,
		AT9000.VoucherNo,
		AT9000.InventoryID,
		AT1302.InventoryName,
		(Select WarehouseID from AT2006 V60 where V60.DivisionID = V70.DivisionID and V60.VoucherID = V70.VoucherID) as WarehouseID,
		(Select WarehouseName from AT1303 inner join AT2006 on AT2006.divisionID = AT1303.DivisionID and AT2006.WareHouseID = AT1303.WarehouseID where AT2006.DivisionID = V70.DivisionID and AT2006.VoucherID = V70.VoucherID) as WarehouseName,
		AT1302.UnitID,
		AT1304.UnitName,
		AT1309.UnitID AS ConversionUnitID,
		AT1309.ConversionFactor,
		AT1309.Operator,
		AT9000.ObjectID,
		AT1202.ObjectName,
		AT1202.Address,
		AT9000.CurrencyID,
		AT1004.CurrencyName,
		AT9000.UnitPrice,
		AT1302.RecievedPrice,		
		AT9000.DebitAccountID,
		AT9000.CreditAccountID,
		Serial,
		Quantity,
		AT9000.ConvertedQuantity,
		AT9000.MarkQuantity,
		InvoiceDate,
		InvoiceNo,
		VATRate,
		AT9000.OriginalAmount,
		AT9000.ConvertedAmount,
		ImTaxOriginalAmount,
		ImTaxConvertedAmount,
		ExpenseOriginalAmount,
		ExpenseConvertedAmount,
		AT9000.Duedate,
		AT9000.IsStock,
		AT9000.DivisionID,
		BDescription, TDescription, AT9000.PaymentTermID, AT1208.PaymentTermName, 
		V70.Notes01, V70.Notes02, V70.Notes03, V70.Notes04, V70.Notes05, V70.Notes06, V70.Notes07, V70.Notes08, V70.Notes09, V70.Notes10, V70.Notes11, V70.Notes12, V70.Notes13, V70.Notes14, V70.Notes15, V70.SourceNo, V70.Parameter01, V70.Parameter02, V70.Parameter03, V70.Parameter04, V70.Parameter05
'
set @sSQL1 = '
FROM	AT9000 
LEFT JOIN AT1302 ON AT9000.InventoryID = AT1302.InventoryID AND AT9000.DivisionID = AT1302.DivisionID
LEFT JOIN (SELECT	DivisionID, InventoryID,Min(UnitID) AS UnitID, 
					Min(ConversionFactor) AS ConversionFactor, 
					Min(Operator) AS Operator 
           FROM		AT1309 
           GROUP BY DivisionID, InventoryID) AT1309 
    ON	AT9000.InventoryID = AT1309.InventoryID AND AT9000.DivisionID = AT1309.DivisionID
LEFT JOIN AT1202 ON AT9000.ObjectID = AT1202.ObjectID AND AT9000.DivisionID = AT1202.DivisionID
LEFT JOIN AT1005 ON AT9000.DebitAccountID = AT1005.AccountID AND AT9000.DivisionID = AT1005.DivisionID
LEFT JOIN AT1010 ON AT1010.VATGroupID = AT9000.VATGroupID AND AT9000.DivisionID = AT1010.DivisionID
LEFT JOIN AT1004 ON AT1004.CurrencyID = AT9000.CurrencyID AND AT9000.DivisionID = AT1004.DivisionID
LEFT JOIN AT1304 ON AT9000.UnitID = AT1304.UnitID AND AT9000.DivisionID = AT1304.DivisionID
LEFT JOIN AT1208 ON AT9000.PaymentTermID = AT1208.PaymentTermID AND AT1208.DivisionID = AT9000.DivisionID
Left JOIN AT2007 V70 ON AT9000.DivisionID = V70.DivisionID AND AT9000.VoucherID = V70.VoucherID and AT9000.InventoryID = V70.InventoryID and AT9000.Orders = V70.Orders

	
WHERE	AT9000.DivisionID=N'''+@DivisionID+''' 
		AND AT9000.TransactionTypeID in (N''T03'', N''T30'')
		'

--PRINT @sSQL
--PRINT @sSQL1
--PRINT @sWHERE

IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE NAME = 'AV0601' AND XTYPE ='V')
	EXEC ('CREATE VIEW AV0601 -- AP06011
	 AS '+@sSQL + @sSQL1 +@sWHERE)
ELSE
	EXEC ('ALTER VIEW AV0601 -- AP06011
	AS '+@sSQL + @sSQL1 +@sWHERE)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

