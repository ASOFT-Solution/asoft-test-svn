IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0068]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0068]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- LOAD VIEW/EDIT THUẾ BẢO VỆ MÔI TRƯỜNG - HOÁ ĐƠN BÁN HÀNG
-- <History>
---- Create on 23/03/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
EXEC AP0068 'LV','',''
*/

CREATE PROCEDURE [dbo].[AP0068]
	@DivisionID nvarchar(50),
	@VoucherID nvarchar(50),
	@UserID NVARCHAR(50)
	
AS
SELECT AT90.DivisionID, AT90.VoucherID, AT90.TransactionTypeID, AT90.TransactionID, 
	   AT90.InventoryID, AT13.InventoryName, AT90.Quantity, AT90.ETaxID, AT93.ETaxName,
	   AT93.UnitID, AT93.UnitID AS ETaxUnitID, AT95.ETaxAmount, AT90.ETaxConvertedUnit, AT90.ETaxVoucherID,  
	   AT90.DebitAccountID, AT90.CreditAccountID, AT90.ETaxConvertedAmount, AT90.TDescription, AT90.ETaxTransactionID	
FROM AT9000 AT90
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = AT90.DivisionID AND AT13.InventoryID = AT90.InventoryID
LEFT JOIN AT0293 AT93 ON AT93.ETaxID = AT90.ETaxID
LEFT JOIN AT0295 AT95 ON AT95.VoucherID = AT90.ETaxVoucherID AND AT95.ETaxID = AT90.ETaxID
Where AT90.DivisionID = @DivisionID AND AT90.VoucherID = @VoucherID AND AT90.TransactionTypeID IN ('T94') 
ORDER BY AT90.Orders
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
