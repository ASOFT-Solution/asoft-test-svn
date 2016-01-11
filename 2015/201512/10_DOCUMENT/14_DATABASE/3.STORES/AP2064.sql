IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2064]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP2064]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Cập nhật dữ liệu cho phiếu nhập kho kho hàng về trước sau khi lập hóa đơn sau tại màn hình mua hàng (AF0063)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 25/10/2011 by Nguyễn Bình Minh
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh

-- <Example>
---- 
CREATE PROCEDURE [DBO].[AP2064]
(
	@DivisionID AS NVARCHAR(50),
	@TranMonth AS INT,
	@TranYear AS INT,
	@VoucherID AS NVARCHAR(50)
) 
AS 
UPDATE		T07
SET			UnitPrice = ROUND((T00.ConvertedAmount + T00.ImTaxConvertedAmount + T00.ExpenseConvertedAmount)/T07.ActualQuantity, T01.UnitCostDecimals),
			ConvertedAmount = (T00.ConvertedAmount + T00.ImTaxConvertedAmount + T00.ExpenseConvertedAmount),
			OriginalAmount = (T00.ConvertedAmount + T00.ImTaxConvertedAmount + T00.ExpenseConvertedAmount)
FROM		AT2007 T07
INNER JOIN	AT2006 T06
		ON	T06.VoucherID = T07.VoucherID AND T06.DivisionID = T07.DivisionID AND T06.IsGoodsFirstVoucher = 1
INNER JOIN	AT9000 T00
		ON	T00.ReVoucherID = T06.VoucherID AND T00.ReTransactionID = T07.TransactionID
			AND T00.InventoryID = T07.InventoryID AND T00.DivisionID = T07.DivisionID AND T00.TransactionTypeID = 'T03'
INNER JOIN	AT1101 T01
		ON	T01.DivisionID = @DivisionID			
WHERE		T00.VoucherID = @VoucherID AND T00.IsLateInvoice = 1 AND T00.DivisionID = @DivisionID 