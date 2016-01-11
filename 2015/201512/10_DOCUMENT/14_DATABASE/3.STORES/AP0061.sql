IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0061]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0061]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- LOAD VIEW/EDIT THUẾ TIÊU THỤ ĐẶC BIỆT - MUA VÀO - BÁN RA
-- <History>
---- Create on 28/05/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
EXEC AP0061 'VG','AV20140000001109',0,''
*/

CREATE PROCEDURE [dbo].[AP0061]
	@DivisionID NVARCHAR(50),
	@VoucherID NVARCHAR(50),
	@TypeID TINYINT, -- 0: Mua vào AF0063, 1: Bán ra AF0066
	@UserID NVARCHAR(50)
	
AS
DECLARE @sSQL NVARCHAR(MAX), 
		@SET1 NVARCHAR(100),
		@SET2 NVARCHAR(100),
		@SET3 NVARCHAR(100),
		@SET4 NVARCHAR(100),
		@SET5 NVARCHAR(100),
		@SET6 NVARCHAR(100)
SET @SET1 = N'Mua trong nước'
SET @SET2 = N'Nhập khẩu'
SET @SET3 = N'Hàng hoá, dịch vụ chịu thuế'
SET @SET4 = N'Hàng hoá xuất khẩu thuộc trường hợp không chịu thuế'
SET @SET5 = N'Hàng hoá bán để xuất khẩu thuộc trường hợp không chịu thuế'
SET @SET6 = N'Hàng hoá gia công để xuất khẩu thuộc trường hợp không chịu thuế'
IF ISNULL(@TypeID,0) = 0
SET @sSQL = '
SELECT 	AT90.DivisionID, AT90.VoucherID, AT90.BatchID, AT90.TransactionID, AT90.TableID,
        AT90.TranMonth, AT90.TranYear, AT90.TransactionTypeID, AT90.CurrencyID, AT90.ObjectID,
        AT90.VATObjectID, AT90.DebitAccountID, AT90.CreditAccountID, ISNULL(AT90.ExchangeRate,0) AS ExchangeRate,
        ISNULL(AT90.OriginalAmount,0) AS OriginalAmount, ISNULL(AT90.ConvertedAmount,0) AS ConvertedAmount, 
        AT90.VoucherDate, AT90.VoucherNo, AT90.Orders, AT90.InventoryID, AT13.InventoryName, 
        ISNULL(AT90.Quantity,0) AS Quantity, AT90.UnitID, AT90.TDescription, ISNULL(AT90.AssignedSET,0) AS AssignedSET, 
        AT90.SETID, AT36.SETName, AT90.SETUnitID, ISNULL(AT90.SETTaxRate,0) AS SETTaxRate,
        ISNULL(AT90.SETConvertedUnit,0) AS SETConvertedUnit, ISNULL(AT90.SETQuantity,0) AS SETQuantity, 
        ISNULL(AT90.SETOriginalAmount,0) AS SETOriginalAmount, ISNULL(AT90.SETConvertedAmount,0) AS SETConvertedAmount,
        AT90.SETConsistID, AT90.SETTransactionID,
        CASE WHEN ISNULL(AT90.SETConsistID,'''') = N''TN'' THEN N'''+@SET1+'''
			 WHEN ISNULL(AT90.SETConsistID,'''') = N''NK'' THEN N'''+@SET2+'''
			 ELSE NULL END AS SETConsistName
FROM AT9000 AT90
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = AT90.DivisionID AND AT13.InventoryID = AT90.InventoryID
LEFT JOIN AT0136 AT36 ON AT36.DivisionID = AT90.DivisionID AND AT36.SETID = AT90.SETID
Where AT90.DivisionID = '''+@DivisionID+''' AND AT90.VoucherID = '''+@VoucherID+''' AND AT90.TransactionTypeID IN (''T96'') 
ORDER BY AT90.Orders '
IF ISNULL(@TypeID,0) = 1
SET @sSQL = '
SELECT AT90.DivisionID, AT90.VoucherID, AT90.BatchID, AT90.TransactionID, AT90.TableID,
        AT90.TranMonth, AT90.TranYear, AT90.TransactionTypeID, AT90.CurrencyID, AT90.ObjectID,
        AT90.VATObjectID, AT90.DebitAccountID, AT90.CreditAccountID, ISNULL(AT90.ExchangeRate,0) AS ExchangeRate,
        ISNULL(AT90.OriginalAmount,0) AS OriginalAmount, ISNULL(AT90.ConvertedAmount,0) AS ConvertedAmount, 
        AT90.VoucherDate, AT90.VoucherNo, AT90.Orders, AT90.InventoryID, AT13.InventoryName, 
        ISNULL(AT90.Quantity,0) AS Quantity, AT90.UnitID, AT90.TDescription, ISNULL(AT90.AssignedSET,0) AS AssignedSET, 
        AT90.SETID, AT36.SETName, AT90.SETUnitID, ISNULL(AT90.SETTaxRate,0) AS SETTaxRate,
        ISNULL(AT90.SETConvertedUnit,0) AS SETConvertedUnit, ISNULL(AT90.SETQuantity,0) AS SETQuantity, 
        ISNULL(AT90.SETOriginalAmount,0) AS SETOriginalAmount, ISNULL(AT90.SETConvertedAmount,0) AS SETConvertedAmount,
        AT90.SETConsistID, AT90.SETTransactionID,
        CASE WHEN ISNULL(AT90.SETConsistID,'''') = N''HCT'' THEN N'''+@SET3+'''
			 WHEN ISNULL(AT90.SETConsistID,'''') = N''HXK'' THEN N'''+@SET4+'''
			 WHEN ISNULL(AT90.SETConsistID,'''') = N''HUQ'' THEN N'''+@SET5+'''
			 WHEN ISNULL(AT90.SETConsistID,'''') = N''HGC'' THEN N'''+@SET6+'''
			 ELSE NULL END AS SETConsistName
FROM AT9000 AT90
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = AT90.DivisionID AND AT13.InventoryID = AT90.InventoryID
LEFT JOIN AT0136 AT36 ON AT36.DivisionID = AT90.DivisionID AND AT36.SETID = AT90.SETID
WHERE AT90.DivisionID = '''+@DivisionID+''' AND AT90.VoucherID = '''+@VoucherID+''' AND AT90.TransactionTypeID IN (''T97'') 
ORDER BY AT90.Orders'
EXEC (@sSQL)
--PRINT (@sSQL)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
