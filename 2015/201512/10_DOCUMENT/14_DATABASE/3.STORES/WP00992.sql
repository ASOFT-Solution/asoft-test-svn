IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP00992]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP00992]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Đổ chi tiết màn hình duyệt phiếu yêu cầu nhập - xuất - chuyển kho
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 10/06/2014 by Lê Thị Thu Hiền
---- Modified by Tiểu Mai, on 05/11/2015: Bổ sung 20 cột quy cách hàng hóa.
---- Modified on 10/06/2014 by 
-- <Example>
---- 
CREATE PROCEDURE WP00992
( 
		@DivisionID AS NVARCHAR(50),
		@TranMonth AS INT, 
		@TranYear AS INT,
		@UserID AS NVARCHAR(50),
		@VoucherID AS NVARCHAR(50)
) 
AS 

IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	SELECT W.DivisionID, W.InventoryID, A.InventoryName, W.UnitID, W.ActualQuantity, W.UnitPrice,
		W.OriginalAmount, W.ConvertedAmount, W.Notes, W.TranMonth, W.TranYear,
		W.CurrencyID, W.ExchangeRate, W.SaleUnitPrice, W.SaleAmount,
		W.DiscountAmount, W.SourceNo, W.DebitAccountID, W.CreditAccountID,
		W.LocationID, W.ImLocationID, W.LimitDate, W.Orders, W.ConversionFactor,
		W.ReTransactionID, W.ReVoucherID, W.Ana01ID, W.Ana02ID, W.Ana03ID,
		W.PeriodID, W.ProductID, W.OrderID, W.InventoryName1, W.Ana04ID, W.Ana05ID,
		W.OTransactionID, W.ReSPVoucherID, W.ReSPTransactionID, W.ETransactionID,
		W.MTransactionID, W.Parameter01, W.Parameter02, W.Parameter03,
		W.Parameter04, W.Parameter05, W.ConvertedQuantity, W.ConvertedPrice,
		W.ConvertedUnitID, W.MOrderID, W.SOrderID, W.STransactionID, W.Ana06ID,
		W.Ana07ID, W.Ana08ID, W.Ana09ID, W.Ana10ID,
		O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
		O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
		A10.StandardName AS StandardName01, A11.StandardName AS StandardName02, A12.StandardName AS StandardName03, A13.StandardName AS StandardName04, A14.StandardName AS StandardName05,
		A15.StandardName AS StandardName06, A16.StandardName AS StandardName07, A17.StandardName AS StandardName08, A18.StandardName AS StandardName09, A19.StandardName AS StandardName10,
		A20.StandardName AS StandardName11, A21.StandardName AS StandardName12, A22.StandardName AS StandardName13, A23.StandardName AS StandardName14, A24.StandardName AS StandardName15, 
		A25.StandardName AS StandardName16, A26.StandardName AS StandardName17, A27.StandardName AS StandardName18, A28.StandardName AS StandardName19, A29.StandardName AS StandardName20

FROM WT0096 W
	LEFT JOIN AT1302 A ON A.DivisionID = W.DivisionID AND A.InventoryID = W.InventoryID
	LEFT JOIN WT8899 O99 ON O99.DivisionID = W.DivisionID AND O99.VoucherID = W.VoucherID AND O99.TransactionID = W.TransactionID
	LEFT JOIN AT0128 A10 ON A10.DivisionID = O99.DivisionID AND A10.StandardID = O99.S01ID AND A10.StandardTypeID = 'S01'
	LEFT JOIN AT0128 A11 ON A11.DivisionID = O99.DivisionID AND A11.StandardID = O99.S02ID AND A11.StandardTypeID = 'S02'
	LEFT JOIN AT0128 A12 ON A12.DivisionID = O99.DivisionID AND A12.StandardID = O99.S03ID AND A12.StandardTypeID = 'S03'
	LEFT JOIN AT0128 A13 ON A13.DivisionID = O99.DivisionID AND A13.StandardID = O99.S04ID AND A13.StandardTypeID = 'S04'
	LEFT JOIN AT0128 A14 ON A14.DivisionID = O99.DivisionID AND A14.StandardID = O99.S05ID AND A14.StandardTypeID = 'S05'
	LEFT JOIN AT0128 A15 ON A15.DivisionID = O99.DivisionID AND A15.StandardID = O99.S06ID AND A15.StandardTypeID = 'S06'
	LEFT JOIN AT0128 A16 ON A16.DivisionID = O99.DivisionID AND A16.StandardID = O99.S07ID AND A16.StandardTypeID = 'S07'
	LEFT JOIN AT0128 A17 ON A17.DivisionID = O99.DivisionID AND A17.StandardID = O99.S08ID AND A17.StandardTypeID = 'S08'
	LEFT JOIN AT0128 A18 ON A18.DivisionID = O99.DivisionID AND A18.StandardID = O99.S09ID AND A18.StandardTypeID = 'S09'
	LEFT JOIN AT0128 A19 ON A19.DivisionID = O99.DivisionID AND A19.StandardID = O99.S10ID AND A19.StandardTypeID = 'S10'
	LEFT JOIN AT0128 A20 ON A20.DivisionID = O99.DivisionID AND A20.StandardID = O99.S11ID AND A20.StandardTypeID = 'S11'
	LEFT JOIN AT0128 A21 ON A21.DivisionID = O99.DivisionID AND A21.StandardID = O99.S12ID AND A21.StandardTypeID = 'S12'
	LEFT JOIN AT0128 A22 ON A22.DivisionID = O99.DivisionID AND A22.StandardID = O99.S13ID AND A22.StandardTypeID = 'S13'
	LEFT JOIN AT0128 A23 ON A23.DivisionID = O99.DivisionID AND A23.StandardID = O99.S14ID AND A23.StandardTypeID = 'S14'
	LEFT JOIN AT0128 A24 ON A24.DivisionID = O99.DivisionID AND A24.StandardID = O99.S15ID AND A24.StandardTypeID = 'S15'
	LEFT JOIN AT0128 A25 ON A25.DivisionID = O99.DivisionID AND A25.StandardID = O99.S16ID AND A25.StandardTypeID = 'S16'
	LEFT JOIN AT0128 A26 ON A26.DivisionID = O99.DivisionID AND A26.StandardID = O99.S17ID AND A26.StandardTypeID = 'S17'
	LEFT JOIN AT0128 A27 ON A27.DivisionID = O99.DivisionID AND A27.StandardID = O99.S18ID AND A27.StandardTypeID = 'S18'
	LEFT JOIN AT0128 A28 ON A28.DivisionID = O99.DivisionID AND A28.StandardID = O99.S19ID AND A28.StandardTypeID = 'S19'
	LEFT JOIN AT0128 A29 ON A29.DivisionID = O99.DivisionID AND A29.StandardID = O99.S20ID AND A29.StandardTypeID = 'S20'
WHERE W.DivisionID = @DivisionID
AND W.TranMonth = @TranMonth
AND W.TranYear = @TranYear
AND W.VoucherID = @VoucherID

END
ELSE
	SELECT W.DivisionID, W.InventoryID, A.InventoryName, W.UnitID, W.ActualQuantity, W.UnitPrice,
       W.OriginalAmount, W.ConvertedAmount, W.Notes, W.TranMonth, W.TranYear,
       W.CurrencyID, W.ExchangeRate, W.SaleUnitPrice, W.SaleAmount,
       W.DiscountAmount, W.SourceNo, W.DebitAccountID, W.CreditAccountID,
       W.LocationID, W.ImLocationID, W.LimitDate, W.Orders, W.ConversionFactor,
       W.ReTransactionID, W.ReVoucherID, W.Ana01ID, W.Ana02ID, W.Ana03ID,
       W.PeriodID, W.ProductID, W.OrderID, W.InventoryName1, W.Ana04ID, W.Ana05ID,
       W.OTransactionID, W.ReSPVoucherID, W.ReSPTransactionID, W.ETransactionID,
       W.MTransactionID, W.Parameter01, W.Parameter02, W.Parameter03,
       W.Parameter04, W.Parameter05, W.ConvertedQuantity, W.ConvertedPrice,
       W.ConvertedUnitID, W.MOrderID, W.SOrderID, W.STransactionID, W.Ana06ID,
       W.Ana07ID, W.Ana08ID, W.Ana09ID, W.Ana10ID
FROM WT0096 W
LEFT JOIN AT1302 A ON A.DivisionID = W.DivisionID AND A.InventoryID = W.InventoryID
WHERE W.DivisionID = @DivisionID
AND W.TranMonth = @TranMonth
AND W.TranYear = @TranYear
AND W.VoucherID = @VoucherID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

