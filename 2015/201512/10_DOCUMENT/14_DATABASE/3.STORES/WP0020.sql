IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0020]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0020]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
--- Load Grid chi tiết màn hình điều chỉnh kho khi kế thừa từ phiếu kiểm kê kho
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 23/06/2015
---- Modified on 29/10/2015 by Tiểu Mai: Bổ sung điều kiện Left join WT8899
---- Modified on 10/12/2015 by Phương Thảo: Chỉnh sửa, nếu khi kiểm kê không nhập số lượng thì hiểu ko điều chỉnh gì --> không load dòng đó lên
-- <Example>
/*
	WP0020 'HD', '', 'dc5d4f8c-6c19-4ca7-9cd9-e96ec6f70c86' 
*/
CREATE PROCEDURE WP0020
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@VoucherID VARCHAR(50),
	@IsType TINYINT -- 0: Tất cả
					-- 1: Tăng
					-- 2: Giảm
)
AS
IF @IsType = 0
BEGIN
		SELECT	A37.*,		
				A02.InventoryName, O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
				O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		FROM AT2037 A37 
		LEFT JOIN AT1302 A02 ON A02.DivisionID = A37.DivisionID AND A02.InventoryID = A37.InventoryID
		LEFT JOIN WT8899 O99 ON O99.TransactionID = A37.TransactionID AND O99.DivisionID = A37.DivisionID AND O99.VoucherID = A37.VoucherID
		WHERE A37.DivisionID = @DivisionID
		AND A37.VoucherID = @VoucherID
		AND ISNULL(ReTransactionID, '') = ''
		AND Isnull(A37.AdjustQuantity,0) <> 0
		AND IsAdjust = 0
END
ELSE IF @IsType = 1
BEGIN
		SELECT A37.*, A02.InventoryName, O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
		O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		FROM AT2037 A37 
		LEFT JOIN AT1302 A02 ON A02.DivisionID = A37.DivisionID AND A02.InventoryID = A37.InventoryID
		LEFT JOIN WT8899 O99 ON O99.TransactionID = A37.TransactionID AND O99.DivisionID = A37.DivisionID AND O99.VoucherID = A37.VoucherID
		WHERE A37.DivisionID = @DivisionID
		AND A37.VoucherID = @VoucherID
		AND ISNULL(ReTransactionID, '') = ''
		AND IsAdjust = 0
		AND Isnull(A37.AdjustQuantity,0) <> 0
		AND ( Isnull(OriginalAmount,0)-Isnull(AdjutsOriginalAmount,0) < case when isnull(Quantity,0) =isnull(AdjustQuantity,0) then 0 end 
      or Isnull(Quantity,0)-Isnull(AdjustQuantity,0)< case when isnull(Quantity,0)<>isnull(AdjustQuantity,0) then 0 end)

END
ELSE 
	SELECT A37.*, A02.InventoryName, O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
	FROM AT2037 A37 
	LEFT JOIN AT1302 A02 ON A02.DivisionID = A37.DivisionID AND A02.InventoryID = A37.InventoryID
	LEFT JOIN WT8899 O99 ON O99.TransactionID = A37.TransactionID AND O99.DivisionID = A37.DivisionID AND O99.VoucherID = A37.VoucherID
	WHERE A37.DivisionID = @DivisionID
	AND A37.VoucherID = @VoucherID
	AND ISNULL(ReTransactionID, '') = ''
	AND IsAdjust = 0
	AND Isnull(A37.AdjustQuantity,0) <> 0
	AND (Isnull(OriginalAmount,0)-Isnull(AdjutsOriginalAmount,0) > case when isnull(Quantity,0) =isnull(AdjustQuantity,0) then 0 end 
		or Isnull(Quantity,0)-Isnull(AdjustQuantity,0)> case when isnull(Quantity,0)<>isnull(AdjustQuantity,0) then 0 end)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

