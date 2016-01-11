IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0149]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0149]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Xuất excel PI (H
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by:Thanh Sơn on: 19/05/2015
---- Modified on 
-- <Example>
/*
	OP0149 'HD', '', 'EO/01/2015/0001'
*/
CREATE PROCEDURE OP0149
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@SOrderIDList NVARCHAR(MAX)
)
AS
DECLARE @sSQL NVARCHAR(MAX),
		@sSQL1 NVARCHAR(MAX),
		@sSQL2 NVARCHAR(MAX),
		@sWhere NVARCHAR(MAX) = ''
		
IF ISNULL(@SOrderIDList,'') <> '' SET @sWhere = '
AND O21.SOrderID IN ('''+@SOrderIDList+''')'

SET @sSQL = '
SELECT O21.SOrderID, O21.OrderDate, O21.VoucherNo, O21.ContractNo, O21.ObjectID, A02.ObjectName, O21.Notes MasterNotes,
	O22.InventoryID, A32.InventoryName, O22.UnitID, A04.UnitName, O22.TransactionID,
	O89.TableID, O89.S01ID, O89.S02ID, O89.S03ID, O89.S04ID, O89.S05ID, O89.S06ID,
	O89.S07ID, O89.S08ID, O89.S09ID, O89.S10ID, O89.S11ID, O89.S12ID, O89.S13ID,
	O89.S14ID, O89.S15ID, O89.S16ID, O89.S17ID, O89.S18ID, O89.S19ID, O89.S20ID,
	O89.SUnitPrice01, O89.SUnitPrice02, O89.SUnitPrice03, O89.SUnitPrice04,
	O89.SUnitPrice05, O89.SUnitPrice06, O89.SUnitPrice07, O89.SUnitPrice08,
	O89.SUnitPrice09, O89.SUnitPrice10, O89.SUnitPrice11, O89.SUnitPrice12,
	O89.SUnitPrice13, O89.SUnitPrice14, O89.SUnitPrice15, O89.SUnitPrice16,
	O89.SUnitPrice17, O89.SUnitPrice18, O89.SUnitPrice19, O89.SUnitPrice20,	
	T01.StandardName S01Name, T02.StandardName S02Name, T03.StandardName S03Name, T04.StandardName S04Name, T05.StandardName S05Name,
	T06.StandardName S06Name, T07.StandardName S07Name, T08.StandardName S08Name, T09.StandardName S09Name, T10.StandardName S10Name,
	T11.StandardName S11Name, T12.StandardName S12Name, T13.StandardName S13Name, T14.StandardName S14Name, T15.StandardName S15Name,
	T16.StandardName S16Name, T17.StandardName S17Name, T18.StandardName S18Name, T19.StandardName S19Name, T20.StandardName S20Name,	
	O22.OrderQuantity, O22.DiscountPercent,
	O22.OriginalAmount * (1 - O22.DiscountPercent/100) OriginalAmount,
	O22.SalePrice * (1 - O22.DiscountPercent/100) SalePrice,
	O22.RefInfor, O22.[Description],
	O22.Ana01ID, O22.Ana02ID, O22.Ana03ID, O22.Ana04ID, O22.Ana05ID, O22.Ana06ID, O22.Ana07ID, O22.Ana08ID, O22.Ana09ID, O22.Ana10ID,
	A11.AnaName Ana01Name, A12.AnaName Ana02Name, A13.AnaName Ana03Name, A14.AnaName Ana04Name, A15.AnaName Ana05Name,
	A16.AnaName Ana06Name, A17.AnaName Ana07Name, A18.AnaName Ana08Name, A19.AnaName Ana09Name, A20.AnaName Ana10Name,
	O22.Notes, O22.Notes01, O22.Notes02, O22.DeliveryDate,
	O22.nvarchar01, O22.nvarchar02, O22.nvarchar03, O22.nvarchar04, O22.nvarchar05,
	O22.nvarchar06, O22.nvarchar07, O22.nvarchar08, O22.nvarchar09, O22.nvarchar10,
	O22.Varchar01 nvarchar11, O22.Varchar02 nvarchar12, O22.Varchar03 nvarchar13, O22.Varchar04 nvarchar14, O22.Varchar05 nvarchar15,
	O22.Varchar06 nvarchar16, O22.Varchar07 nvarchar17, O22.Varchar08 nvarchar18, O22.Varchar09 nvarchar19, O22.Varchar10 nvarchar20,
	O21.Transport, O21.ShipDate, O21.DeliveryAddress, O21.ClassifyID, O01.ClassifyName,
	O21.EmployeeID, A03.FullName, O21.ContractDate, O21.CurrencyID, O21.ExchangeRate,
	(SELECT SUM(ISNULL(OriginalAmount,0) - ISNULL(DiscountOriginalAmount,0) - ISNULL(CommissionOAmount, 0) + ISNULL(VAToriginalAmount, 0))
	 FROM OT2002 WHERE OT2002.SOrderID = O21.SOrderID) OriginalAmount,
	(SELECT SUM(ISNULL(ConvertedAmount,0) - ISNULL(DiscountConvertedAmount,0) - ISNULL(CommissionCAmount,0) + ISNULL(VATConvertedAmount, 0))
	 FROM OT2002 Where OT2002.SOrderID = O21.SOrderID) ConvertedAmount, O21.Notes,
	 O02_1.AnaName Ana01Name, O02_2.AnaName Ana02Name, O02_3.AnaName Ana03Name, O02_4.AnaName Ana04Name, O02_5.AnaName Ana05Name,
	 O21.Disabled, O02.Description IsConfirm, O02.EDescription EIsConfirm, O21.DescriptionConfirm, O21.IsPrinted'

SET @sSQL1 = '	
FROM OT2001 O21
	LEFT JOIN OT1102 O02 ON O02.DivisionID = O21.DivisionID AND O02.Code = O21.IsConfirm AND O02.TypeID = ''SO''
	LEFT JOIN AT1103 A03 ON A03.DivisionID = O21.DivisionID AND A03.EmployeeID = O21.EmployeeID 
	LEFT JOIN OT1001 O01 ON O01.DivisionID = O21.DivisionID AND O01.ClassifyID = O21.ClassifyID AND O01.TypeID = ''SO''
	LEFT JOIN AT1202 A02 ON A02.DivisionID = O21.DivisionID AND A02.ObjectID = O21.ObjectID
	LEFT JOIN OT2002 O22 ON O22.SOrderID = O21.SOrderID
	LEFT JOIN OT8899 O89 ON O89.TransactionID = O22.TransactionID	
	LEFT JOIN AT0128 T01 ON T01.StandardID = O89.S01ID AND T01.StandardTypeID = ''S01''
	LEFT JOIN AT0128 T02 ON T02.StandardID = O89.S02ID AND T02.StandardTypeID = ''S02''
	LEFT JOIN AT0128 T03 ON T03.StandardID = O89.S03ID AND T03.StandardTypeID = ''S03''
	LEFT JOIN AT0128 T04 ON T04.StandardID = O89.S04ID AND T04.StandardTypeID = ''S04''
	LEFT JOIN AT0128 T05 ON T05.StandardID = O89.S05ID AND T05.StandardTypeID = ''S05''
	LEFT JOIN AT0128 T06 ON T06.StandardID = O89.S06ID AND T06.StandardTypeID = ''S06''
	LEFT JOIN AT0128 T07 ON T07.StandardID = O89.S07ID AND T07.StandardTypeID = ''S07''
	LEFT JOIN AT0128 T08 ON T08.StandardID = O89.S08ID AND T08.StandardTypeID = ''S08''
	LEFT JOIN AT0128 T09 ON T09.StandardID = O89.S09ID AND T09.StandardTypeID = ''S09''
	LEFT JOIN AT0128 T10 ON T10.StandardID = O89.S10ID AND T10.StandardTypeID = ''S10''
	LEFT JOIN AT0128 T11 ON T11.StandardID = O89.S11ID AND T11.StandardTypeID = ''S11''
	LEFT JOIN AT0128 T12 ON T12.StandardID = O89.S12ID AND T12.StandardTypeID = ''S12''
	LEFT JOIN AT0128 T13 ON T13.StandardID = O89.S13ID AND T13.StandardTypeID = ''S13''
	LEFT JOIN AT0128 T14 ON T14.StandardID = O89.S14ID AND T14.StandardTypeID = ''S14''
	LEFT JOIN AT0128 T15 ON T15.StandardID = O89.S15ID AND T15.StandardTypeID = ''S15''
	LEFT JOIN AT0128 T16 ON T16.StandardID = O89.S16ID AND T16.StandardTypeID = ''S16''
	LEFT JOIN AT0128 T17 ON T17.StandardID = O89.S17ID AND T17.StandardTypeID = ''S17''
	LEFT JOIN AT0128 T18 ON T18.StandardID = O89.S18ID AND T18.StandardTypeID = ''S18''
	LEFT JOIN AT0128 T19 ON T19.StandardID = O89.S19ID AND T19.StandardTypeID = ''S19''
	LEFT JOIN AT0128 T20 ON T20.StandardID = O89.S20ID AND T20.StandardTypeID = ''S20''	
	LEFT JOIN AT1304 A04 ON A04.DivisionID = O22.DivisionID AND A04.UnitID = O22.UnitID'
SET @sSQL2 = '
	LEFT JOIN AT1302 A32 ON A32.DivisionID = O22.DivisionID AND A32.InventoryID = O22.InventoryID
	LEFT JOIN AT1011 A11 ON A11.DivisionID = O22.DivisionID AND A11.AnaID = O22.Ana01ID AND A11.AnaTypeID = ''A01''
	LEFT JOIN AT1011 A12 ON A12.DivisionID = O22.DivisionID AND A12.AnaID = O22.Ana02ID AND A12.AnaTypeID = ''A02''
	LEFT JOIN AT1011 A13 ON A13.DivisionID = O22.DivisionID AND A13.AnaID = O22.Ana03ID AND A13.AnaTypeID = ''A03''
	LEFT JOIN AT1011 A14 ON A14.DivisionID = O22.DivisionID AND A14.AnaID = O22.Ana04ID AND A14.AnaTypeID = ''A04''
	LEFT JOIN AT1011 A15 ON A15.DivisionID = O22.DivisionID AND A15.AnaID = O22.Ana05ID AND A15.AnaTypeID = ''A05''
	LEFT JOIN AT1011 A16 ON A16.DivisionID = O22.DivisionID AND A16.AnaID = O22.Ana06ID AND A16.AnaTypeID = ''A06''
	LEFT JOIN AT1011 A17 ON A17.DivisionID = O22.DivisionID AND A17.AnaID = O22.Ana07ID AND A17.AnaTypeID = ''A07''
	LEFT JOIN AT1011 A18 ON A18.DivisionID = O22.DivisionID AND A18.AnaID = O22.Ana08ID AND A18.AnaTypeID = ''A08''
	LEFT JOIN AT1011 A19 ON A19.DivisionID = O22.DivisionID AND A19.AnaID = O22.Ana09ID AND A19.AnaTypeID = ''A09''
	LEFT JOIN AT1011 A20 ON A20.DivisionID = O22.DivisionID AND A20.AnaID = O22.Ana10ID AND A20.AnaTypeID = ''A10''	
	LEFT JOIN OT1002 O02_1 ON O02_1.DivisionID = O21.DivisionID AND O02_1.AnaID = O21.Ana01ID AND O02_1.AnaTypeID = ''S01''
	LEFT JOIN OT1002 O02_2 ON O02_2.DivisionID = O21.DivisionID AND O02_2.AnaID = O21.Ana02ID AND O02_2.AnaTypeID = ''S02''
	LEFT JOIN OT1002 O02_3 ON O02_3.DivisionID = O21.DivisionID AND O02_3.AnaID = O21.Ana03ID AND O02_3.AnaTypeID = ''S03''
	LEFT JOIN OT1002 O02_4 ON O02_4.DivisionID = O21.DivisionID AND O02_4.AnaID = O21.Ana04ID AND O02_4.AnaTypeID = ''S04''
	LEFT JOIN OT1002 O02_5 ON O02_5.DivisionID = O21.DivisionID AND O02_5.AnaID = O21.Ana05ID AND O02_5.AnaTypeID = ''S05''
WHERE O21.DivisionID = '''+@DivisionID+''' '+@sWhere+'
ORDER BY O21.OrderDate, O21.SOrderID, O22.Orders'

EXEC (@sSQL + @sSQL1 + @sSQL2)
--PRINT (@sSQL)
--PRINT (@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
