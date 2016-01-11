
IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0034]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0034]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Cập nhật đơn giá cho phiếu nhập kho khi lưu đơn hàng mua
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 21/01/2013 by Lê Thị Thi Thu Hiền
---- Modified on 22/07/2014 by Bảo Anh: Dùng bảng tạm thay AT9000 để cải thiện tốc độ
---- Modified on 06/11/2014 by Lê Thị Hạnh: Fix bug kế thừa nhiều phiếu nhập kho
---- Modified on 11/03/2015 by Lê Thị Hạnh: Bổ sung cập nhật giá có chi phí mua hàng khi phân bổ chi phí mua hàng [LAVO]
-- <Example>
/*
  exec AP0034 @DivisionID=N'HH',@VoucherID=N'TV620bb655-4042-4ead-abed-e77f70b00a3a'
*/
CREATE PROCEDURE AP0034
( 
		@DivisionID AS NVARCHAR(50),
		@VoucherID AS NVARCHAR(50)
) 
AS 

DECLARE @PurchaseID AS NVARCHAR(50),
		@IsUpdatePrice AS TINYINT

SET @IsUpdatePrice = 0

----- Check Cập nhật giá cho phiếu nhập khi lưu phiếu mua hàng
SET @IsUpdatePrice = (SELECT TOP 1 IsUpdatePrice FROM AT0000 WHERE DefDivisionID = @DivisionID)

SET @PurchaseID = ''
IF ISNULL (@IsUpdatePrice,0) = 1
BEGIN

--- Lấy mã phiếu nhập kho
SET @PurchaseID = (SELECT TOP 1 WOrderID FROM AT9000 WHERE VoucherID = @VoucherID AND @DivisionID = @DivisionID AND ISNULL(WOrderID,'') <> '')

--- Lấy giá phiếu mua hàng
SELECT VoucherID, WOrderID, WTransactionID, UnitPrice
INTO #TAM
FROM AT9000
WHERE @DivisionID = @DivisionID AND VoucherID = @VoucherID AND ISNULL(WOrderID,'') <> ''

--SELECT DISTINCT A.InventoryID, A.Quantity, A.UnitPrice
--FROM AT9000 a WHERE a.VoucherID = @VoucherID AND ISNULL (a.WOrderID,'') <> ''

--UPDATE AT2007
--SET AT2007.UnitPrice = AT9000.UnitPrice,
--	AT2007.OriginalAmount = AT9000.UnitPrice * AT2007.ActualQuantity,
--	AT2007.ConvertedAmount = AT9000.UnitPrice * AT2007.ActualQuantity
--FROM AT2007 AT2007
--INNER JOIN #TAM AT9000
--		ON AT9000.WTransactionID = AT2007.TransactionID
--WHERE	AT2007.DivisionID = @DivisionID
--		AND AT2007.VoucherID = @PurchaseID
IF EXISTS (SELECT TOP 1 1 FROM AT0321 WHERE DivisionID = @DivisionID AND POVoucherID = @VoucherID)
	BEGIN -- Cập nhật giá có chi phí mua hàng AF0322
	UPDATE AT27 SET
		UnitPrice = (ISNULL(AT90.ConvertedAmount,0) + ISNULL(AT90.ImTaxConvertedAmount,0) + ISNULL(AT90.ExpenseConvertedAmount,0))/ISNULL(AT27.ActualQuantity,1),
		OriginalAmount = (ISNULL(AT90.ConvertedAmount,0) + ISNULL(AT90.ImTaxConvertedAmount,0) + ISNULL(AT90.ExpenseConvertedAmount,0)),
		ConvertedAmount = (ISNULL(AT90.ConvertedAmount,0) + ISNULL(AT90.ImTaxConvertedAmount,0) + ISNULL(AT90.ExpenseConvertedAmount,0)),
		ConvertedPrice = (ISNULL(AT90.ConvertedAmount,0) + ISNULL(AT90.ImTaxConvertedAmount,0) + ISNULL(AT90.ExpenseConvertedAmount,0))/ISNULL(AT27.ActualQuantity,1)
	FROM AT2007 AT27
	INNER JOIN AT2006 AT26 ON AT26.DivisionID = AT27.DivisionID AND AT26.VoucherID = AT27.VoucherID
	LEFT JOIN AT9000 AT90 ON AT90.DivisionID = AT26.DivisionID AND AT90.WOrderID = AT27.VoucherID
			  AND AT90.WTransactionID = AT27.TransactionID AND AT90.TransactionTypeID = 'T03'
	WHERE AT90.DivisionID = @DivisionID 
		  AND AT27.VoucherID IN (SELECT WOrderID
								 FROM AT9000 
						         WHERE AT9000.DivisionID = @DivisionID AND AT9000.VoucherID = @VoucherID AND ISNULL(WOrderID,'') <> '')
	END
ELSE
	BEGIN	
	UPDATE AT2007
	SET AT2007.UnitPrice = #TAM.UnitPrice,
		AT2007.OriginalAmount = #TAM.UnitPrice * AT2007.ActualQuantity,
		AT2007.ConvertedAmount = #TAM.UnitPrice * AT2007.ActualQuantity
	FROM AT2007 AT2007
	INNER JOIN #TAM
			ON #TAM.WOrderID = AT2007.VoucherID AND #TAM.WTransactionID = AT2007.TransactionID
	WHERE	AT2007.DivisionID = @DivisionID
			AND AT2007.VoucherID IN (SELECT WOrderID FROM AT9000 WHERE VoucherID = @VoucherID AND @DivisionID = @DivisionID AND ISNULL(WOrderID,'') <> '')
	END
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

