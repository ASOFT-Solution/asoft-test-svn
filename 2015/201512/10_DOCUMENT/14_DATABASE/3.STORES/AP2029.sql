/****** Object: StoredProcedure [dbo].[AP2029] Script Date: 08/05/2010 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[AP2029]
AS
DECLARE @sSQL AS nvarchar(4000)

SET @sSQL = '
SELECT 
WareHouseID, 
VoucherID, 
TransactionID, 
VoucherDate, 
InventoryID, 
ImUnitPrice, 
ExUnitPrice, 
SUM(BeginQuantity) AS BeginQuantity, 
SUM(ImConvertedQuantity) AS ImConvertedQuantity, 
SUM(ExConvertedQuantity) AS ExConvertedQuantity, 
SUM(BeginQuantity) AS BeginAmount, 
SUM(ImConvertedQuantity) AS ImConvertedAmount, 
SUM(ExConvertedQuantity) AS ExConvertedAmount,
DivisionID
FROM AV2027
GROUP BY WareHouseID, VoucherDate, TransactionID, VoucherID, InventoryID, ImUnitPrice, ExUnitPrice, DivisionID'
IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV2029' )
  EXEC ( 'CREATE VIEW AV2029 AS ' + @sSQL )
ELSE
  EXEC ( 'ALTER VIEW AV2029 AS ' + @sSQL )