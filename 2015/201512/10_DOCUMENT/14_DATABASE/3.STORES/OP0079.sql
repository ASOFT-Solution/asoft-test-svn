IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0079]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0079]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load Chi tiết phiếu yêu cầu mua hàng
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 18/06/2015
---- Modified on 
-- <Example>
/*
	OP0079 'HD', '','HDVNS-H1506023'
*/

CREATE PROCEDURE OP0079
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@ROrderID VARCHAR(50)
)
AS
SELECT O02.DivisionID, A02.Barcode, O02.ROrderID, O02.TransactionID, O01.VoucherTypeID, 
	O01.OrderDate, O01.VoucherNo, O01.ContractNo, O01.ContractDate, O01.InventoryTypeID,
	A01.InventoryTypeName, A02.IsStocked, O02.[Description], O02.InventoryID,
	A02.InventoryName AInventoryName, 
	(CASE WHEN ISNULL(O02.InventoryCommonName, '') = '' THEN A02.InventoryName ELSE O02.InventoryCommonName END) InventoryName, 
	ISNULL(O02.UnitID, A02.UnitID) UnitID, ISNULL(A04_1.UnitName, A04_2.UnitName) UnitName, 
	O02.OrderQuantity, O02.ConvertedQuantity, O02.RequestPrice, O02.PriceList, O02.ConvertedSaleprice, 
	O02.OriginalAmount, O02.ConvertedAmount, O02.DiscountPercent, O02.DiscountOriginalAmount, O02.DiscountConvertedAmount,
	O02.VATPercent, O02.VATConvertedAmount, O02.VATOriginalAmount, O02.Ana01ID, O02.Ana02ID, O02.Ana03ID, O02.Ana04ID, O02.Ana05ID, 
	O02.Ana06ID, O02.Ana07ID, O02.Ana08ID, O02.Ana09ID, O02.Ana10ID, O02.Orders, O02.Notes, O02.Notes01, O02.Notes02, O02.Finish, 
	O02.RefTransactionID, O02.Parameter01, O02.Parameter02, O02.Parameter03, O02.Parameter04, O02.Parameter05,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
	AT01.StandardName S01Name, AT02.StandardName S02Name, AT03.StandardName S03Name, AT04.StandardName S04Name, AT05.StandardName S05Name,
	AT06.StandardName S06Name, AT07.StandardName S07Name, AT08.StandardName S08Name, AT09.StandardName S09Name, AT10.StandardName S10Name,
	AT11.StandardName S11Name, AT12.StandardName S12Name, AT13.StandardName S13Name, AT14.StandardName S14Name, AT15.StandardName S15Name,
	AT16.StandardName S16Name, AT17.StandardName S17Name, AT18.StandardName S18Name, AT19.StandardName S19Name, AT20.StandardName S20Name
FROM OT3102 O02
	LEFT JOIN OT3101 O01 ON O01.DivisionID = O02.DivisionID AND O01.ROrderID = O02.ROrderID
	LEFT JOIN AT1302 A02 ON A02.InventoryID = O02.InventoryID AND A02.DivisionID = O02.DivisionID
	LEFT JOIN AT1301 A01 ON A01.InventoryTypeID = O01.InventoryTypeID AND A01.DivisionID = O01.DivisionID
	LEFT JOIN AT1304 A04_1 ON A04_1.UnitID = O02.UnitID AND A04_1.DivisionID = O02.DivisionID
	LEFT JOIN AT1304 A04_2 ON A04_2.UnitID = A02.UnitID AND A04_2.DivisionID = A02.DivisionID
	LEFT JOIN OT8899 O99 ON O99.TransactionID = O02.TransactionID
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
WHERE O02.DivisionID = @DivisionID
AND O02.ROrderID = @ROrderID
Order by O02.Orders
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
