IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0077]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0077]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load Grid chi tiết đơn hàng bán (không sinh view) + 20 mã phân tích quy cách hàng
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 17/06/2015
---- Modified on 
-- <Example>
/*
	OP0077 'HD', '', 'HDVNS-H1506022'
*/
CREATE PROCEDURE OP0077
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@POrderID VARCHAR(50)
)
AS

SELECT O32.DivisionID, O32.POrderID, O32.TransactionID, O31.VoucherTypeID, O31.VoucherNo, O31.OrderDate,
	O31.InventoryTypeID, A01.InventoryTypeName, A02.IsStocked, A02.Barcode, O32.InventoryID,  O32.UnitID,
	A04.UnitName, O32.MethodID, O03.MethodName, O32.OrderQuantity, O32.PurchasePrice, O32.ConvertedAmount,
	O32.OriginalAmount, O32.VATConvertedAmount, O32.VATOriginalAmount, O32.VATPercent, O32.DiscountConvertedAmount,
	O32.DiscountOriginalAmount, O32.DiscountPercent, O32.OriginalAmount - O32.DiscountOriginalAmount OriginalAmountBeforeVAT,
	O32.ImTaxPercent, O32.ImTaxOriginalAmount, O32.ImTaxConvertedAmount,
	(O32.OriginalAmount - O32.DiscountOriginalAmount + O32.VATOriginalAmount +  O32.ImTaxOriginalAmount) OriginalAmountAfterVAT,
	O32.IsPicking, O32.WareHouseID, A03.WareHouseName, O32.Quantity01, O32.Quantity02, O32.Quantity03,
	O32.Quantity04, O32.Quantity05, O32.Quantity06, O32.Quantity07, O32.Quantity08, O32.Quantity09, O32.Quantity10,
	O32.Quantity11, O32.Quantity12, O32.Quantity13, O32.Quantity14, O32.Quantity15, O32.Quantity16, O32.Quantity17,
	O32.Quantity18, O32.Quantity19, O32.Quantity20, 
	O32.Quantity21, O32.Quantity22, O32.Quantity23, O32.Quantity24, O32.Quantity25, O32.Quantity26, O32.Quantity27,
	O32.Quantity28, O32.Quantity29, O32.Quantity30,
	O33.Date01, O33.Date02, O33.Date03, O33.Date04, O33.Date05, O33.Date06, O33.Date07, O33.Date08, O33.Date09, O33.Date10, 
	O33.Date11, O33.Date12, O33.Date13, O33.Date14, O33.Date15, O33.Date16, O33.Date17, O33.Date18, O33.Date19, O33.Date20, 
	O33.Date21, O33.Date22, O33.Date23, O33.Date24, O33.Date25, O33.Date26, O33.Date27, O33.Date28, O33.Date29, O33.Date30,
	O32.Orders, O32.[Description], O32.Ana01ID, O32.Ana02ID, O32.Ana03ID, O32.Ana04ID, O32.Ana05ID,
	O32.Ana06ID, O32.Ana07ID, O32.Ana08ID, O32.Ana09ID, O32.Ana10ID, A32.InventoryName AInventoryName, 
	(CASE WHEN ISNULL(O32.InventoryCommonName, '') = '' THEN A02.InventoryName ELSE O32.InventoryCommonName END) InventoryName,
	V92.ActualQuantity, V92.EndQuantity RemainQuantity, O32.Finish ,O32.Notes, O32.Notes01, O32.Notes02, 
	O32.Notes03, O32.Notes04, O32.Notes05, O32.Notes06, O32.Notes07, O32.Notes08, O32.Notes09, O32.RefTransactionID,
	O32.ROrderID, O31.ContractNo, O32.ConvertedQuantity, O32.ConvertedSaleprice, O32.ShipDate, O32.ReceiveDate, 
	O32.Parameter01, O32.Parameter02, O32.Parameter03, O32.Parameter04, O32.Parameter05,
	O32.StrParameter01,	O32.StrParameter02,	O32.StrParameter03,	O32.StrParameter04,	O32.StrParameter05,
	O32.StrParameter06,	O32.StrParameter07,	O32.StrParameter08,	O32.StrParameter09,	O32.StrParameter10,
	O32.StrParameter11,	O32.StrParameter12,	O32.StrParameter13,	O32.StrParameter14,	O32.StrParameter15,
	O32.StrParameter16,	O32.StrParameter17,	O32.StrParameter18,	O32.StrParameter19,	O32.StrParameter20,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID,
	O99.S08ID, O99.S09ID, O99.S10ID, O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID,
	O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID, O99.UnitPriceStandard,
	AT01.StandardName S01Name, AT02.StandardName S02Name, AT03.StandardName S03Name, AT04.StandardName S04Name, AT05.StandardName S05Name,
	AT06.StandardName S06Name, AT07.StandardName S07Name, AT08.StandardName S08Name, AT09.StandardName S09Name, AT10.StandardName S10Name,
	AT11.StandardName S11Name, AT12.StandardName S12Name, AT13.StandardName S13Name, AT14.StandardName S14Name, AT15.StandardName S15Name,
	AT16.StandardName S16Name, AT17.StandardName S17Name, AT18.StandardName S18Name, AT19.StandardName S19Name, AT20.StandardName S20Name
	
FROM OT3002 O32
	LEFT JOIN OV2902 V92 ON V92.POrderID = O32.POrderID AND V92.TransactionID = O32.TransactionID
	LEFT JOIN AT1302 A32 ON A32.DivisionID = O32.DivisionID AND A32.InventoryID = O32.InventoryID
	LEFT JOIN AT1303 A03 ON A03.DivisionID = O32.DivisionID AND A03.WareHouseID = O32.WareHouseID
	LEFT JOIN OT1003 O03 ON O03.DivisionID = O32.DivisionID AND O03.MethodID = O32.MethodID
	LEFT JOIN AT1304 A04 ON A04.DivisionID = O32.DivisionID AND A04.UnitID = O32.UnitID
	LEFT JOIN AT1302 A02 ON A02.DivisionID = O32.DivisionID AND A02.InventoryID = O32.InventoryID
	LEFT JOIN OT3001 O31 ON O31.DivisionID = O32.DivisionID AND O31.POrderID = O32.POrderID
	LEFT JOIN OT3003 O33 ON O33.POrderID = O31.POrderID AND O33.DivisionID = O31.DivisionID 
	LEFT JOIN AT1301 A01 ON A01.DivisionID = O31.DivisionID AND A01.InventoryTypeID = O31.InventoryTypeID
	LEFT JOIN OT8899 O99 ON O99.TransactionID = O32.TransactionID
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
WHERE O32.DivisionID = @DivisionID
	AND O32.POrderID = @POrderID
Order by O32.Orders
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
