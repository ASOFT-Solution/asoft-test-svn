IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0105]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0105]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- In báo cáo Phiếu yêu cầu nhập, xuất, vận chuyển nội bộ
----Edit by Mai Duyen, Date 12/09/2014: Bo sung them field AT1302.Notes01(KH Kingcom)
----Edit by Mai Duyen, Date 06/05/2015: Bo sung them field AT1302.BarCode(KH MANHPHUONG)
----Modified by Tiểu Mai on 25/12/2015: Bo sung thong tin quy cach hang hoa khi co thiet lap quan ly hang theo quy cach
----MOdified by Tiểu Mai on 07/01/2016: Bổ sung các cột của đơn hàng sx khi có thiết lập quản lý hàng theo quy cách.
/*
    EXEC WP0105 'KC','','79ebd83b-e203-4183-a633-84a9c6135c94', 2
*/

 CREATE PROCEDURE WP0105
(
     @DivisionID NVARCHAR(2000),
     @UserID VARCHAR(50),
     @VoucherID VARCHAR(50),
     @Mode TINYINT  --: 1,5: Phiếu yêu cầu nhập, 2,4: Phiếu yêu cầu xuất, 3: Phiếu yêu cầu VCNB

)
AS
DECLARE @sSQL NVARCHAR(MAX),
		@sSQL1 NVARCHAR(MAX),
		@sWhere NVARCHAR(2000),
		@sSQL2 NVARCHAR(MAX)
		
SET @sWhere = ''		
IF @Mode = 3
SET @sWhere = 'W95.WareHouseID2 ExVoucherID, A03.WareHouseName ExVoucherName, W95.WareHouseID ImWareHouseID, A33.WareHouseName ImWareHouseName,'

IF @Mode IN (1,5)
SET @sWhere = ' W95.WareHouseID ImWareHouseID, A33.WareHouseName ImWareHouseName,'

IF @Mode IN (2,4)
SET @sWhere = ' W95.WareHouseID ExVoucherID, A33.WareHouseName ExVoucherName,'
SET @sSQL2 = ''
IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN

	SET @sSQL = '
	SELECT O01.SOrderID, O01.ObjectID as ObjectID_DHSX, A203.ObjectName as ObjectName_DHSX, O01.OrderDate, O01.InheritApportionID , W95.VoucherNo, W95.VoucherDate, '+@sWhere+' W95.[Description],
	W96.InventoryID, A32.InventoryName, W96.UnitID, SUM(W96.ConvertedQuantity) ConvertedQuantity,
	W96.UnitPrice, SUM(W96.ConvertedAmount) ConvertedAmount, 
	A32.Notes01, W95.ObjectID, A202.ObjectName,A32.BarCode,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID, 
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
	A01.StandardName AS S01Name, A02.StandardName AS S02Name, A03.StandardName AS S03Name, A04.StandardName AS S04Name, A05.StandardName AS S05Name,
	A06.StandardName AS S06Name, A07.StandardName AS S07Name, A08.StandardName AS S08Name, A09.StandardName AS S09Name, A10.StandardName AS S10Name,
	A11.StandardName AS S11Name, A12.StandardName AS S12Name, A13.StandardName AS S13Name, A14.StandardName AS S14Name, A15.StandardName AS S15Name,
	A16.StandardName AS S16Name, A17.StandardName AS S17Name, A18.StandardName AS SName18, A19.StandardName AS S19Name, A20.StandardName AS S20Name
	'
	SET @sSQL1 = '
	FROM WT0095 W95
	LEFT JOIN AT1202 A202 ON A202.DivisionID = W95.DivisionID AND A202.ObjectID = W95.ObjectID
	LEFT JOIN WT0096 W96 ON W96.DivisionID = W95.DivisionID AND W96.VoucherID = W95.VoucherID
	LEFT JOIN OT2002 O02 ON O02.DivisionID = W96.DivisionID AND O02.SOrderID = W96.SOrderID AND O02.TransactionID = W96.OTransactionID
	LEFT JOIN OT2001 O01 ON O01.DivisionID = O02.DivisionID AND O01.SOrderID = O02.SOrderID
	LEFT JOIN AT1202 A203 ON A203.DivisionID = O01.DivisionID AND A203.ObjectID = O01.ObjectID
	LEFT JOIN AT1302 A32 ON A32.DivisionID = W96.DivisionID AND A32.InventoryID = W96.InventoryID
	LEFT JOIN AT1303 A33 ON A33.DivisionID = W95.DivisionID AND A33.WareHouseID = W95.WareHouseID
	LEFT JOIN AT1303 A34 ON A34.DivisionID = W95.DivisionID AND A34.WareHouseID = W95.WareHouseID2
	LEFT JOIN WT8899 O99 ON O99.DivisionID = W96.DivisionID AND O99.VoucherID = W96.VoucherID AND O99.TransactionID  = W96.TransactionID and O99.TableID  = ''WT0096''
	LEFT JOIN AT0128 A01 ON A01.DivisionID = O99.DivisionID AND A01.StandardID = O99.S01ID AND A01.StandardTypeID = ''S01''
	LEFT JOIN AT0128 A02 ON A02.DivisionID = O99.DivisionID AND A02.StandardID = O99.S02ID AND A02.StandardTypeID = ''S02''
	LEFT JOIN AT0128 A03 ON A03.DivisionID = O99.DivisionID AND A03.StandardID = O99.S03ID AND A03.StandardTypeID = ''S03''
	LEFT JOIN AT0128 A04 ON A04.DivisionID = O99.DivisionID AND A04.StandardID = O99.S04ID AND A04.StandardTypeID = ''S04''
	LEFT JOIN AT0128 A05 ON A05.DivisionID = O99.DivisionID AND A05.StandardID = O99.S05ID AND A05.StandardTypeID = ''S05''
	LEFT JOIN AT0128 A06 ON A06.DivisionID = O99.DivisionID AND A06.StandardID = O99.S06ID AND A06.StandardTypeID = ''S06''
	LEFT JOIN AT0128 A07 ON A07.DivisionID = O99.DivisionID AND A07.StandardID = O99.S07ID AND A07.StandardTypeID = ''S07''
	LEFT JOIN AT0128 A08 ON A08.DivisionID = O99.DivisionID AND A08.StandardID = O99.S08ID AND A08.StandardTypeID = ''S08''
	LEFT JOIN AT0128 A09 ON A09.DivisionID = O99.DivisionID AND A09.StandardID = O99.S09ID AND A09.StandardTypeID = ''S09''
	LEFT JOIN AT0128 A10 ON A10.DivisionID = O99.DivisionID AND A10.StandardID = O99.S10ID AND A10.StandardTypeID = ''S10''
	LEFT JOIN AT0128 A11 ON A11.DivisionID = O99.DivisionID AND A11.StandardID = O99.S11ID AND A11.StandardTypeID = ''S11''
	LEFT JOIN AT0128 A12 ON A12.DivisionID = O99.DivisionID AND A12.StandardID = O99.S12ID AND A12.StandardTypeID = ''S12''
	LEFT JOIN AT0128 A13 ON A13.DivisionID = O99.DivisionID AND A13.StandardID = O99.S13ID AND A13.StandardTypeID = ''S13''
	LEFT JOIN AT0128 A14 ON A14.DivisionID = O99.DivisionID AND A14.StandardID = O99.S14ID AND A14.StandardTypeID = ''S14''
	LEFT JOIN AT0128 A15 ON A15.DivisionID = O99.DivisionID AND A15.StandardID = O99.S15ID AND A15.StandardTypeID = ''S15''
	LEFT JOIN AT0128 A16 ON A16.DivisionID = O99.DivisionID AND A16.StandardID = O99.S16ID AND A16.StandardTypeID = ''S16''
	LEFT JOIN AT0128 A17 ON A17.DivisionID = O99.DivisionID AND A17.StandardID = O99.S17ID AND A17.StandardTypeID = ''S17''
	LEFT JOIN AT0128 A18 ON A18.DivisionID = O99.DivisionID AND A18.StandardID = O99.S18ID AND A18.StandardTypeID = ''S18''
	LEFT JOIN AT0128 A19 ON A19.DivisionID = O99.DivisionID AND A19.StandardID = O99.S19ID AND A19.StandardTypeID = ''S19''
	LEFT JOIN AT0128 A20 ON A20.DivisionID = O99.DivisionID AND A20.StandardID = O99.S20ID AND A20.StandardTypeID = ''S20''
	WHERE W95.DivisionID = '''+@DivisionID+'''
	AND W95.VoucherID = '''+@VoucherID+''' '
	
	SET @sSQL2 = '
	GROUP BY O01.SOrderID, O01.ObjectID, A203.ObjectName, O01.OrderDate, O01.InheritApportionID, W95.VoucherNo, W95.VoucherDate, W95.WareHouseID2, A34.WareHouseName, W95.WareHouseID,
	A33.WareHouseName, W95.[Description], W96.InventoryID, A32.InventoryName, W96.UnitID,
	W96.UnitPrice, A32.Notes01, W95.ObjectID, A202.ObjectName ,A32.Barcode,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID, 
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
	A01.StandardName, A02.StandardName, A03.StandardName, A04.StandardName, A05.StandardName,
	A06.StandardName, A07.StandardName, A08.StandardName, A09.StandardName, A10.StandardName,
	A11.StandardName, A12.StandardName, A13.StandardName, A14.StandardName, A15.StandardName,
	A16.StandardName, A17.StandardName, A18.StandardName, A19.StandardName, A20.StandardName '
	
END
ELSE
SET @sSQL = '
	SELECT W95.VoucherNo, W95.VoucherDate, '+@sWhere+' W95.[Description],
	W96.InventoryID, A02.InventoryName, W96.UnitID, SUM(W96.ConvertedQuantity) ConvertedQuantity,
	W96.UnitPrice, SUM(W96.ConvertedAmount) ConvertedAmount, 
	A02.Notes01, W95.ObjectID, A202.ObjectName,A02.BarCode
	FROM WT0095 W95
	LEFT JOIN AT1202 A202 ON A202.DivisionID = W95.DivisionID AND A202.ObjectID = W95.ObjectID
	LEFT JOIN WT0096 W96 ON W96.DivisionID = W95.DivisionID AND W96.VoucherID = W95.VoucherID
	LEFT JOIN AT1302 A02 ON A02.DivisionID = W96.DivisionID AND A02.InventoryID = W96.InventoryID
	LEFT JOIN AT1303 A33 ON A33.DivisionID = W95.DivisionID AND A33.WareHouseID = W95.WareHouseID
	LEFT JOIN AT1303 A34 ON A34.DivisionID = W95.DivisionID AND A34.WareHouseID = W95.WareHouseID2
	WHERE W95.DivisionID = '''+@DivisionID+'''
	AND W95.VoucherID = '''+@VoucherID+'''
	GROUP BY W95.VoucherNo, W95.VoucherDate, W95.WareHouseID2, A34.WareHouseName, W95.WareHouseID,
	A01.WareHouseName, W95.[Description], W96.InventoryID, A02.InventoryName, W96.UnitID,
	W96.UnitPrice, A02.Notes01, W95.ObjectID, A202.ObjectName ,A02.Barcode '

PRINT @sSQL
PRINT @sSQL1
PRINT @sSQL2
EXEC (@sSQL + @sSQL1 + @sSQL2)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
