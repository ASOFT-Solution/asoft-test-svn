IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0102]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0102]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- 
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 04/06/2014 by Le Thi Thu Hien
---- 
---- Modified on 04/06/2014 by 
-- <Example>
---- 
CREATE PROCEDURE WP0102
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@VoucherID AS NVARCHAR(50)
) 
AS 

SELECT w.DivisionID, w.VoucherID, w.TableID ,
w.TranMonth, w.TranYear,
W.VoucherTypeID, W.VoucherNo, W.VoucherDate,
W.RefNo01, W.RefNo02, W.ObjectID, A1.ObjectName,
W.WareHouseID, A3.WareHouseName, W1.Price,
W.EmployeeID, W.[Description], W.IsKind,
W1.TransactionID, W1.Orders, W1.InventoryID, A.InventoryName,
W1.UnitID, W1.ActualQuantity, W1.ConvertedAmount, 
W1.Notes, W1.ReVoucherID, W1.ReTransactionID,
W1.Ana01ID, W1.Ana02ID, W1.Ana03ID, W1.Ana04ID, W1.Ana05ID, 
W1.Ana06ID, W1.Ana07ID,W1.Ana08ID, W1.Ana09ID, W1.Ana10ID

FROM WT0101 W
LEFT JOIN WT0102 W1 ON W1.DivisionID = W.DivisionID AND W1.VoucherID = W.VoucherID
LEFT JOIN AT1302 A ON A.DivisionID = W1.DivisionID AND A.InventoryID = W1.InventoryID
LEFT JOIN AT1202 A1 ON A1.DivisionID = W.DivisionID AND A1.ObjectID = W.ObjectID
LEFT JOIN AT1303 A3 ON A3.DivisionID = W.DivisionID AND A3.WareHouseID = W.WareHouseID

WHERE W.DivisionID = @DivisionID
AND W.VoucherID = @VoucherID
AND W.TranMonth = @TranMonth
AND W.TranYear = @TranYear
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

