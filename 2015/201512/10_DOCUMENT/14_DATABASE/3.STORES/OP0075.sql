IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0075]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0075]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--<Summary>
--- Load grid chi tiết phiếu điều chỉnh đơn hàng bán (không sinh view) + 20 mã phân tích quy cách hàng
--<Param>
----
--<Return>
----
--<Reference>
----
--<History>
---- Created by: Thanh Sơn on: 17/06/2015
---- Modified on 
--<Example>
/*
	OP0075 'HD', '', 'HDVNS-H1506021'
*/
CREATE PROCEDURE OP0075
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@VoucherID VARCHAR(50)
	
)
AS
SELECT O07.DivisionID, O07.TransactionID, O07.VoucherID, O07.InventoryID, O07.UnitID, O07.AdjustQuantity, 
	O07.AdjustPrice, O07.OriginalAmount, O07.ConvertedAmount, O07.IsPicking, O07.WareHouseID, 
	O07.TDescription, O07.RefOrderID, O07.RefTransactionID, O07.Ana01ID, O07.Ana02ID, O07.Ana03ID, 
	O07.Ana04ID, O07.Ana05ID, O07.Ana06ID, O07.Ana07ID, O07.Ana08ID, O07.Ana09ID, O07.Ana10ID, O07.Orders,
	(CASE WHEN ISNULL(O07.InventoryCommonName, '') = '' THEN A02.InventoryName ELSE O07.InventoryCommonName END) InventoryName, 
	O07.InventoryCommonName, (CASE WHEN ISNULL(O07.InventoryCommonName, '') = '' THEN 0 ELSE 1 END) IsUpdate,
	A04.UnitName, O02.OrderQuantity, O02.SalePrice, O07.DataType,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
	AT01.StandardName S01Name, AT02.StandardName S02Name, AT03.StandardName S03Name, AT04.StandardName S04Name, AT05.StandardName S05Name,
	AT06.StandardName S06Name, AT07.StandardName S07Name, AT08.StandardName S08Name, AT09.StandardName S09Name, AT10.StandardName S10Name,
	AT11.StandardName S11Name, AT12.StandardName S12Name, AT13.StandardName S13Name, AT14.StandardName S14Name, AT15.StandardName S15Name,
	AT16.StandardName S16Name, AT17.StandardName S17Name, AT18.StandardName S18Name, AT19.StandardName S19Name, AT20.StandardName S20Name		
FROM OT2007 O07
	LEFT JOIN AT1304 A04 ON A04.DivisionID = O07.DivisionID AND A04.UnitID = O07.UnitID
	LEFT JOIN AT1302 A02 ON A02.DivisionID = O07.DivisionID AND A02.InventoryID = O07.InventoryID
	LEFT JOIN OT2002 O02 ON O02.DivisionID = O07.DivisionID and O02.SOrderID = O07.RefOrderID and O02.TransactionID = O07.RefTransactionID
	LEFT JOIN OT8899 O99 ON O99.DivisionID = O07.DivisionID AND O99.VoucherID = O07.RefOrderID and O99.TransactionID = O07.RefTransactionID
	LEFT JOIN AT0128 AT01 ON AT01.StandardID = O99.S01ID AND AT01.StandardTypeID = 'S01'
	LEFT JOIN AT0128 AT02 ON AT02.StandardID = O99.S02ID AND AT02.StandardTypeID = 'S02'
	LEFT JOIN AT0128 AT03 ON AT03.StandardID = O99.S03ID AND AT03.StandardTypeID = 'S03'
	LEFT JOIN AT0128 AT04 ON AT04.StandardID = O99.S04ID AND AT04.StandardTypeID = 'S04'
	LEFT JOIN AT0128 AT05 ON AT05.StandardID = O99.S05ID AND AT05.StandardTypeID = 'S05' 
	LEFT JOIN AT0128 AT06 ON AT06.StandardID = O99.S06ID AND AT06.StandardTypeID = 'S06' 
	LEFT JOIN AT0128 AT07 ON AT07.StandardID = O99.S07ID AND AT07.StandardTypeID = 'S07'
	LEFT JOIN AT0128 AT08 ON AT08.StandardID = O99.S08ID AND AT08.StandardTypeID = 'S08'
	LEFT JOIN AT0128 AT09 ON AT09.StandardID = O99.S09ID AND AT09.StandardTypeID = 'S09'
	LEFT JOIN AT0128 AT10 ON AT10.StandardID = O99.S10ID AND AT10.StandardTypeID = 'S10'
	LEFT JOIN AT0128 AT11 ON AT11.StandardID = O99.S11ID AND AT11.StandardTypeID = 'S11'
	LEFT JOIN AT0128 AT12 ON AT12.StandardID = O99.S12ID AND AT12.StandardTypeID = 'S12'
	LEFT JOIN AT0128 AT13 ON AT13.StandardID = O99.S13ID AND AT13.StandardTypeID = 'S13'
	LEFT JOIN AT0128 AT14 ON AT14.StandardID = O99.S15ID AND AT14.StandardTypeID = 'S14'
	LEFT JOIN AT0128 AT15 ON AT15.StandardID = O99.S15ID AND AT15.StandardTypeID = 'S15'
	LEFT JOIN AT0128 AT16 ON AT16.StandardID = O99.S16ID AND AT16.StandardTypeID = 'S16'
	LEFT JOIN AT0128 AT17 ON AT17.StandardID = O99.S17ID AND AT17.StandardTypeID = 'S17'
	LEFT JOIN AT0128 AT18 ON AT18.StandardID = O99.S18ID AND AT18.StandardTypeID = 'S18'
	LEFT JOIN AT0128 AT19 ON AT19.StandardID = O99.S19ID AND AT19.StandardTypeID = 'S19'
	LEFT JOIN AT0128 AT20 ON AT20.StandardID = O99.S20ID AND AT20.StandardTypeID = 'S20'
	
WHERE O07.DivisionID = @DivisionID
AND O07.VoucherID = @VoucherID
Order by O07.Orders
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
