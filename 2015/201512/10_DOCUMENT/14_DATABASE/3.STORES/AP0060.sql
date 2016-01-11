IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0060]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0060]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- LOAD VIEW/EDIT THUẾ TÀI NGUYÊN - AF0066
-- <History>
---- Create on 01/06/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
EXEC AP0060 'VG','AV20140000001109',''
*/

CREATE PROCEDURE [dbo].[AP0060]
	@DivisionID NVARCHAR(50),
	@VoucherID NVARCHAR(50),
	@UserID NVARCHAR(50)
	
AS
DECLARE @sSQL NVARCHAR(MAX), 
		@SET1 NVARCHAR(100),
		@SET2 NVARCHAR(100),
		@SET3 NVARCHAR(100)
SET @SET1 = N'Tài nguyên khai thác'
SET @SET2 = N'Tài nguyên mua gom'
SET @SET3 = N'Tài nguyên tịch thu, giao bán'		

SET @sSQL = '
SELECT AT90.DivisionID, AT90.VoucherID, AT90.BatchID, AT90.TransactionID, AT90.TableID,
        AT90.TranMonth, AT90.TranYear, AT90.TransactionTypeID, AT90.CurrencyID, AT90.ObjectID,
        AT90.VATObjectID, AT90.DebitAccountID, AT90.CreditAccountID, ISNULL(AT90.ExchangeRate,0) AS ExchangeRate,
        ISNULL(AT90.OriginalAmount,0) AS OriginalAmount, ISNULL(AT90.ConvertedAmount,0) AS ConvertedAmount, 
        AT90.VoucherDate, AT90.VoucherNo, AT90.Orders, AT90.InventoryID, AT13.InventoryName, 
        ISNULL(AT90.Quantity,0) AS Quantity, AT90.UnitID, AT90.TDescription, ISNULL(AT90.AssignedNRT,0) AS AssignedNRT, 
        AT90.NRTClassifyID, AT34.NRTClassifyName, ISNULL(AT90.NRTTaxRate,0) AS NRTTaxRate, AT90.NRTUnitID, 
        ISNULL(AT90.NRTTaxAmount,0) AS NRTTaxAmount, ISNULL(AT90.NRTConvertedUnit,0) AS NRTConvertedUnit, 
        ISNULL(AT90.NRTQuantity,0) AS NRTQuantity, ISNULL(AT90.NRTOriginalAmount,0) AS NRTOriginalAmount, 
        ISNULL(AT90.NRTConvertedAmount,0) AS NRTConvertedAmount, AT90.NRTConsistID, AT90.NRTTransactionID,
        CASE WHEN ISNULL(AT90.NRTConsistID,'''') = N''HKT'' THEN N'''+@SET1+'''
			 WHEN ISNULL(AT90.NRTConsistID,'''') = N''HTM'' THEN N'''+@SET2+'''
			 WHEN ISNULL(AT90.NRTConsistID,'''') = N''HTT'' THEN N'''+@SET3+'''
			 ELSE NULL END AS NRTConsistName
FROM AT9000 AT90
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = AT90.DivisionID AND AT13.InventoryID = AT90.InventoryID
LEFT JOIN AT0134 AT34 ON AT34.DivisionID = AT90.DivisionID AND AT34.NRTClassifyID = AT90.NRTClassifyID
WHERE AT90.DivisionID = '''+@DivisionID+''' AND AT90.VoucherID = '''+@VoucherID+''' AND AT90.TransactionTypeID IN (''T95'') 
ORDER BY AT90.Orders'
EXEC (@sSQL)
--PRINT (@sSQL)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
