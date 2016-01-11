IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OV2001]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[OV2001]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- (view chet) Loc ra cac don hang phuc vu cho cong tac bao cao	
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Tạo 17/11/2011 bởi Võ Việt Khánh: Lấy dữ liệu đơn hàng bán để kế thừa.
---- Modified by Lê Thị Hạnh on 23/10/2014: Đổi trường lấy đơn vị tính từ OT2002
---- Modified by Lê Thị Hạnh on 05/03/2015: Bổ sung điều kiện OrderStatus not in (0,3,4,5,9)
---- Modified by Quốc Tuấn on 21/08/2015: Bổ sung thêm RemainOrderQuantity lấy từ PlanQuantity Cho Đại NAM PHÁT
---- Modified by Tiểu Mai on 17/12/2015: Bổ sung 20 cột quy cách
-- <Example>
----
 
CREATE VIEW [dbo].[OV2001] 
AS 

SELECT 
OT2001.DivisionID, 

OT2001.ObjectID,
AT1202.ObjectName, 
OT2001.VoucherNo, 
OT2001.OrderDate, 
OT2001.Notes, 
OT2001.Varchar01 AS MTVarchar01,
OT2001.Varchar02 AS MTVarchar02,
OT2001.Varchar03 AS MTVarchar03,
OT2001.Varchar04 AS MTVarchar04,
OT2001.Varchar05 AS MTVarchar05,
OT2001.Varchar06 AS MTVarchar06,
OT2001.Varchar07 AS MTVarchar07,
OT2001.Varchar08 AS MTVarchar08,
OT2001.Varchar09 AS MTVarchar09,
OT2001.Varchar10 AS MTVarchar10,
OT2001.Varchar11 AS MTVarchar11,
OT2001.Varchar12 AS MTVarchar12,
OT2001.Varchar13 AS MTVarchar13,
OT2001.Varchar14 AS MTVarchar14,
OT2001.Varchar15 AS MTVarchar15,
OT2001.Varchar16 AS MTVarchar16,
OT2001.Varchar17 AS MTVarchar17,
OT2001.Varchar18 AS MTVarchar18,
OT2001.Varchar19 AS MTVarchar19,
OT2001.Varchar20 AS MTVarchar20,

CAST(0 AS TINYINT) AS IsSelected,
OT2002.TransactionID,
AT1302.Barcode,
OT2002.InventoryID AS ProductID, 
AT1302.InventoryName AS ProductName, 
--AT1302.UnitID, 
OT2002.UnitID, -- Sử dụng cho cả trường hợp đơn vị tính chuyển đổi
OT2002.OrderQuantity AS Productquantity,
ISNULL(OT2002.LinkNo, '') AS LinkNo, 
OT2002.Description AS Description,
OT2002.Orders, 
OT2002.RefInfor, 
OT2002.SOrderID, 
OT2002.ConvertedQuantity, 
OT2002.ConvertedSalePrice, 
OT2002.SalePrice, 
OT2002.OriginalAmount, 
OT2002.ConvertedAmount, 
OT2002.DiscountPercent, 
OT2002.DiscountConvertedAmount, 
OT2002.VATPercent, 
OT2002.VATConvertedAmount, 
OT2002.Ana01ID, 
OT2002.Ana02ID, 
OT2002.Ana03ID, 
OT2002.Ana04ID, 
OT2002.Ana05ID,
OT2002.Ana06ID, 
OT2002.Ana07ID, 
OT2002.Ana08ID, 
OT2002.Ana09ID, 
OT2002.Ana10ID,
OT2002.NVarchar01,
OT2002.NVarchar02,
OT2002.NVarchar03,
OT2002.NVarchar04,
OT2002.NVarchar05,
OT2002.NVarchar06,
OT2002.NVarchar07,
OT2002.NVarchar08,
OT2002.NVarchar09,
OT2002.NVarchar10,
OT2002.Varchar01,
OT2002.Varchar02,
OT2002.Varchar03,
OT2002.Varchar04,
OT2002.Varchar05,
OT2002.Varchar06,
OT2002.Varchar07,
OT2002.Varchar08,
OT2002.Varchar09,
OT2002.Varchar10,
--OT2002.Notes, 
OT2002.Notes01, 
OT2002.Notes02,
(CASE WHEN (SELECT TOP 1 CustomerName FROM CustomerIndex)=47 THEN
	ISNULL(OT2002.PlanQuantity,0)
ELSE
(OT2002.OrderQuantity
- ISNULL((
            SELECT SUM(OrderQuantity) 
            FROM OT2002 T02 
            WHERE T02.RefSTransactionID = OT2002.TransactionID 
            AND T02.DivisionID = OT2002.DivisionID
        ), 0)) END)
AS RemainOrderQuantity,
ISNULL(OT2001.OrderStatus,0) AS OrderStatus,OT2002.ExtraID, AT1311.ExtraName,
O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
FROM OT2001
INNER JOIN OT2002 ON OT2002.DivisionID = OT2001.DivisionID AND OT2002.SOrderID = OT2001.SOrderID
INNER JOIN AT1202 ON AT1202.DivisionID = OT2001.DivisionID AND AT1202.ObjectID = OT2001.ObjectID
INNER JOIN AT1302 ON AT1302.DivisionID = OT2002.DivisionID AND AT1302.InventoryID = OT2002.InventoryID
LEFT JOIN OT8899 O99 ON O99.DivisionID = OT2002.DivisionID AND O99.VoucherID = OT2002.SOrderID AND O99.TransactionID = OT2002.TransactionID
LEFT  JOIN AT1311 ON AT1311.DivisionID = OT2002.DivisionID AND AT1311.ExtraID = OT2002.ExtraID
WHERE ISNULL(OT2001.OrderStatus,0) NOT IN (0,3,4,5,9)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
