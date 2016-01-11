IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0068]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0068]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load Thông tin kế thừa Xác nhận hoàn thành khi chọn YCDV Tổng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 29/09/2014 by Le Thi Thu Hien
---- 
---- Modified on 22/10/2014 by Mai Tri Thien: Lấy thêm trường từ OT3002.Notes05 và OT2002.Notes02 (Mã kiểm soát) 
---- Modified on 30/10/2014 by Mai Tri Thien: chỉ lấy dữ liệu từ YCDV Tổng
---- Modified on 13/11/2014 by Trí Thiện: Bổ sung tên nhà thầu phụ
---- Modified on 18/11/2014 by Trí Thiện: Bổ sung điều kiện mặt hàng (mpt04) vào kết dữ liệu DV tổng và LDD
-- <Example>
---- EXEC OP0068 'TBI', 'ADMIN', 'GT/08/14/001'
CREATE PROCEDURE OP0068
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@VoucherID AS NVARCHAR(50)
)
AS 
DECLARE @sSQL AS NVARCHAR(MAX)
DECLARE @sSQL1 AS NVARCHAR(MAX)
DECLARE @sSQL2 AS NVARCHAR(MAX)
DECLARE @sSQL3 AS NVARCHAR(MAX)

SET @sSQL = '
-----------Lay lenh dieu dong

SELECT	CONVERT(TINYINT, 0) AS Selected,
		OT2002.InventoryID, AT1302.InventoryName, OT3001.VoucherNo AS Notes01,	OT2002.UnitID,		
		--OT3002.OrderQuantity,	
		Convert(Decimal(28, 0), 0) AS OrderQuantity, OT2002.SalePrice AS PurchasePrice,		
		OT2002.VATPercent, OT3002.Notes05 as Notes02,
		OT3002.OrderQuantity * ISNULL(OT2002.SalePrice,0) AS OriginalAmount,	
		OT3002.OrderQuantity * ISNULL(OT2002.SalePrice,0) AS ConvertedAmount,	
		OT3002.OrderQuantity * ISNULL(OT2002.SalePrice,0) * ISNULL(OT2002.VATPercent,0)/100 AS VATOriginalAmount,
		OT3002.OrderQuantity * ISNULL(OT2002.SalePrice,0) * ISNULL(OT2002.VATPercent,0)/100 AS VATConvertedAmount,
		OT3002.Ana01ID, OT3002.Ana02ID, OT3002.Ana03ID, OT3002.Ana04ID, OT3002.Ana05ID,
		OT3002.Ana06ID, OT3002.Ana07ID, OT3002.Ana08ID, OT3002.Ana09ID, OT3002.Ana10ID,
		Ana01.AnaName AS Ana01Name,		Ana02.AnaName AS Ana02Name,
		Ana03.AnaName AS Ana03Name,		Ana04.AnaName AS Ana04Name,
		Ana05.AnaName AS Ana05Name,		Ana06.AnaName AS Ana06Name,
		Ana07.AnaName AS Ana07Name,		Ana08.AnaName AS Ana08Name,
		Ana09.AnaName AS Ana09Name,		Ana10.AnaName AS Ana10Name, OT3002.IsPicking,
		OT3001.ObjectID AS Notes03, AT1202.ObjectName AS AInventoryName, OT3002.InventoryID as Notes04, AT02.InventoryName as ReInventoryName
		
FROM OT3002 OT3002
INNER JOIN OT3001 OT3001 ON OT3001.DivisionID = OT3002.DivisionID AND OT3001.POrderID = OT3002.POrderID 
INNER JOIN OT2002 OT2002 ON OT2002.DivisionID = OT3002.DivisionID AND OT2002.InventoryID = OT3002.Notes04 AND OT2002.Ana04ID = OT3002.Ana04ID
INNER JOIN OT2001 OT2001 ON OT2001.DivisionID = OT2002.DivisionID AND OT2001.SOrderID = OT2002.SOrderID AND OT2001.VoucherNo = OT3002.Notes03
INNER JOIN AT1302 AT1302 ON AT1302.DivisionID = OT3002.DivisionID AND AT1302.InventoryID = OT2002.InventoryID
INNER JOIN AT1302 AT02 ON AT02.InventoryID= OT3002.InventoryID AND AT02.DivisionID = OT3002.DivisionID
LEFT JOIN AT1011 Ana01 ON Ana01.DivisionID = OT3002.DivisionID AND OT3002.Ana01ID = Ana01.AnaID AND Ana01.AnaTypeID = ''A01''
LEFT JOIN AT1011 Ana02 ON Ana02.DivisionID = OT3002.DivisionID AND OT3002.Ana02ID = Ana02.AnaID AND Ana02.AnaTypeID = ''A02''
LEFT JOIN AT1011 Ana03 ON Ana03.DivisionID = OT3002.DivisionID AND OT3002.Ana03ID = Ana03.AnaID AND Ana03.AnaTypeID = ''A03''
LEFT JOIN AT1011 Ana04 ON Ana04.DivisionID = OT3002.DivisionID AND OT3002.Ana04ID = Ana04.AnaID AND Ana04.AnaTypeID = ''A04''
LEFT JOIN AT1011 Ana05 ON Ana05.DivisionID = OT3002.DivisionID AND OT3002.Ana05ID = Ana05.AnaID AND Ana05.AnaTypeID = ''A05''
LEFT JOIN AT1011 Ana06 ON Ana06.DivisionID = OT3002.DivisionID AND OT3002.Ana06ID = Ana06.AnaID AND Ana06.AnaTypeID = ''A06''
LEFT JOIN AT1011 Ana07 ON Ana07.DivisionID = OT3002.DivisionID AND OT3002.Ana07ID = Ana07.AnaID AND Ana07.AnaTypeID = ''A07''
LEFT JOIN AT1011 Ana08 ON Ana08.DivisionID = OT3002.DivisionID AND OT3002.Ana08ID = Ana08.AnaID AND Ana08.AnaTypeID = ''A08''
LEFT JOIN AT1011 Ana09 ON Ana09.DivisionID = OT3002.DivisionID AND OT3002.Ana09ID = Ana09.AnaID AND Ana09.AnaTypeID = ''A09''
LEFT JOIN AT1011 Ana10 ON Ana10.DivisionID = OT3002.DivisionID AND OT3002.Ana10ID = Ana10.AnaID AND Ana10.AnaTypeID = ''A10''
LEFT JOIN AT1202 ON AT1202.DivisionID = OT3002.DivisionID AND AT1202.ObjectID = OT3001.ObjectID
WHERE OT3002.DivisionID = ''' + @DivisionID + '''
AND OT3001.KindVoucherID = 1
AND	OT2001.SOrderID = ''' + @VoucherID + '''
AND OT3001.OrderStatus < 3
'

SET @sSQL1 = N'
UNION
SELECT	CONVERT(TINYINT, 0) AS Selected,
		OT3002.Notes04 as InventoryID, AT1302.InventoryName, OT3001.VoucherNo AS Notes01,	OT3002.UnitID,		
		--OT3002.OrderQuantity,	
		Convert(Decimal(28, 0), 0) AS OrderQuantity, OT3002.PurchasePrice,		
		OT3002.VATPercent, OT3002.Notes05 as Notes02,
		OT3002.OrderQuantity * ISNULL(OT3002.PurchasePrice,0) AS OriginalAmount,	
		OT3002.OrderQuantity * ISNULL(OT3002.PurchasePrice,0) AS ConvertedAmount,	
		OT3002.OrderQuantity * ISNULL(OT3002.PurchasePrice,0) * ISNULL(OT3002.VATPercent,0)/100 AS VATOriginalAmount,
		OT3002.OrderQuantity * ISNULL(OT3002.PurchasePrice,0) * ISNULL(OT3002.VATPercent,0)/100 AS VATConvertedAmount,
		OT3002.Ana01ID, OT3002.Ana02ID, OT3002.Ana03ID, OT3002.Ana04ID, OT3002.Ana05ID,
		OT3002.Ana06ID, OT3002.Ana07ID, OT3002.Ana08ID, OT3002.Ana09ID, OT3002.Ana10ID,
		Ana01.AnaName AS Ana01Name,		Ana02.AnaName AS Ana02Name,
		Ana03.AnaName AS Ana03Name,		Ana04.AnaName AS Ana04Name,
		Ana05.AnaName AS Ana05Name,		Ana06.AnaName AS Ana06Name,
		Ana07.AnaName AS Ana07Name,		Ana08.AnaName AS Ana08Name,
		Ana09.AnaName AS Ana09Name,		Ana10.AnaName AS Ana10Name, OT3002.IsPicking,
		OT3001.ObjectID AS Notes03, AT1202.ObjectName AS AInventoryName, OT3002.InventoryID as Notes04, AT02.InventoryName as ReInventoryName
FROM OT3002 OT3002
INNER JOIN OT3001 OT3001 ON OT3001.DivisionID = OT3002.DivisionID AND OT3001.POrderID = OT3002.POrderID 
INNER JOIN AT1302 AT1302 ON AT1302.DivisionID = OT3002.DivisionID AND AT1302.InventoryID = OT3002.Notes04
INNER JOIN AT1302 AT02 ON AT02.InventoryID= OT3002.InventoryID AND AT02.DivisionID = OT3002.DivisionID
'
SET @sSQL2 = N'
LEFT JOIN AT1011 Ana01 ON Ana01.DivisionID = OT3002.DivisionID AND OT3002.Ana01ID = Ana01.AnaID AND Ana01.AnaTypeID = ''A01''
LEFT JOIN AT1011 Ana02 ON Ana02.DivisionID = OT3002.DivisionID AND OT3002.Ana02ID = Ana02.AnaID AND Ana02.AnaTypeID = ''A02''
LEFT JOIN AT1011 Ana03 ON Ana03.DivisionID = OT3002.DivisionID AND OT3002.Ana03ID = Ana03.AnaID AND Ana03.AnaTypeID = ''A03''
LEFT JOIN AT1011 Ana04 ON Ana04.DivisionID = OT3002.DivisionID AND OT3002.Ana04ID = Ana04.AnaID AND Ana04.AnaTypeID = ''A04''
LEFT JOIN AT1011 Ana05 ON Ana05.DivisionID = OT3002.DivisionID AND OT3002.Ana05ID = Ana05.AnaID AND Ana05.AnaTypeID = ''A05''
LEFT JOIN AT1011 Ana06 ON Ana06.DivisionID = OT3002.DivisionID AND OT3002.Ana06ID = Ana06.AnaID AND Ana06.AnaTypeID = ''A06''
LEFT JOIN AT1011 Ana07 ON Ana07.DivisionID = OT3002.DivisionID AND OT3002.Ana07ID = Ana07.AnaID AND Ana07.AnaTypeID = ''A07''
LEFT JOIN AT1011 Ana08 ON Ana08.DivisionID = OT3002.DivisionID AND OT3002.Ana08ID = Ana08.AnaID AND Ana08.AnaTypeID = ''A08''
LEFT JOIN AT1011 Ana09 ON Ana09.DivisionID = OT3002.DivisionID AND OT3002.Ana09ID = Ana09.AnaID AND Ana09.AnaTypeID = ''A09''
LEFT JOIN AT1011 Ana10 ON Ana10.DivisionID = OT3002.DivisionID AND OT3002.Ana10ID = Ana10.AnaID AND Ana10.AnaTypeID = ''A10''
LEFT JOIN AT1202 ON AT1202.DivisionID = OT3002.DivisionID AND AT1202.ObjectID = OT3001.ObjectID
WHERE OT3002.DivisionID =  ''' + @DivisionID + '''
AND OT3001.KindVoucherID = 1
AND OT3002.Notes03 =  ''' + @VoucherID + '''
AND OT3001.OrderStatus < 3
AND ISNULL(OT3002.Notes03, '''') + ISNULL(OT3002.Notes04, '''') + ISNULL(Ot3002.Ana04ID, '''') NOT IN (
	SELECT
		ISNULL(OT2001.SOrderID, '''') + ISNULL(OT2002.InventoryID, '''') + ISNULL(OT2002.Ana04ID, '''')
		FROM OT2002 OT2002
		INNER JOIN OT2001 OT2001 ON OT2001.DivisionID = OT2002.DivisionID AND OT2001.SOrderID = OT2002.SOrderID 
		WHERE OT2001.SOrderID = ''' + @VoucherID + '''
		AND OT2001.DivisionID = ''' + @DivisionID + '''
)
'

SET @sSQL3 = N'
UNION
----------- Lay dong dịch vu ma khong co trong LDD
SELECT	CONVERT(TINYINT, 0) AS Selected,
		OT2002.InventoryID, AT1302.InventoryName, '''' as Notes01, OT2002.UnitID,
		--OT2002.OrderQuantity, 
		Convert(Decimal(28, 0), 0) AS OrderQuantity,
		OT2002.SalePrice AS PurchasePrice, 
		OT2002.VATPercent, OT2002.Notes01 as Notes02,
		OT2002.OriginalAmount,	OT2002.ConvertedAmount,	
		OT2002.VATOriginalAmount,
		OT2002.VATConvertedAmount,
		OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID,
		OT2002.Ana06ID, OT2002.Ana07ID, OT2002.Ana08ID, OT2002.Ana09ID, OT2002.Ana10ID,
		Ana01.AnaName AS Ana01Name,		Ana02.AnaName AS Ana02Name,
		Ana03.AnaName AS Ana03Name,		Ana04.AnaName AS Ana04Name,
		Ana05.AnaName AS Ana05Name,		Ana06.AnaName AS Ana06Name,
		Ana07.AnaName AS Ana07Name,		Ana08.AnaName AS Ana08Name,
		Ana09.AnaName AS Ana09Name,		Ana10.AnaName AS Ana10Name, CONVERT(TINYINT, 0) AS IsPicking,
		'''' AS Notes03, '''' AS AInventoryName, '''' AS Notes04, '''' AS ReInventoryName
FROM OT2002 OT2002
INNER JOIN AT1302 AT1302 ON AT1302.DivisionID = OT2002.DivisionID AND AT1302.InventoryID = OT2002.InventoryID 
INNER JOIN OT2001 OT2001 ON OT2001.DivisionID = OT2002.DivisionID AND OT2001.SOrderID = OT2002.SOrderID
LEFT JOIN AT1011 Ana01 ON Ana01.DivisionID = OT2002.DivisionID AND OT2002.Ana01ID = Ana01.AnaID AND Ana01.AnaTypeID = ''A01''
LEFT JOIN AT1011 Ana02 ON Ana02.DivisionID = OT2002.DivisionID AND OT2002.Ana02ID = Ana02.AnaID AND Ana02.AnaTypeID = ''A02''
LEFT JOIN AT1011 Ana03 ON Ana03.DivisionID = OT2002.DivisionID AND OT2002.Ana03ID = Ana03.AnaID AND Ana03.AnaTypeID = ''A03''
LEFT JOIN AT1011 Ana04 ON Ana04.DivisionID = OT2002.DivisionID AND OT2002.Ana04ID = Ana04.AnaID AND Ana04.AnaTypeID = ''A04''
LEFT JOIN AT1011 Ana05 ON Ana05.DivisionID = OT2002.DivisionID AND OT2002.Ana05ID = Ana05.AnaID AND Ana05.AnaTypeID = ''A05''
LEFT JOIN AT1011 Ana06 ON Ana06.DivisionID = OT2002.DivisionID AND OT2002.Ana06ID = Ana06.AnaID AND Ana06.AnaTypeID = ''A06''
LEFT JOIN AT1011 Ana07 ON Ana07.DivisionID = OT2002.DivisionID AND OT2002.Ana07ID = Ana07.AnaID AND Ana07.AnaTypeID = ''A07''
LEFT JOIN AT1011 Ana08 ON Ana08.DivisionID = OT2002.DivisionID AND OT2002.Ana08ID = Ana08.AnaID AND Ana08.AnaTypeID = ''A08''
LEFT JOIN AT1011 Ana09 ON Ana09.DivisionID = OT2002.DivisionID AND OT2002.Ana09ID = Ana09.AnaID AND Ana09.AnaTypeID = ''A09''
LEFT JOIN AT1011 Ana10 ON Ana10.DivisionID = OT2002.DivisionID AND OT2002.Ana10ID = Ana10.AnaID AND Ana10.AnaTypeID = ''A10''
WHERE OT2002.DivisionID =  '''+@DivisionID+'''
AND	OT2002.SOrderID =  '''+@VoucherID+'''
'
--PRINT(@sSQL)
--PRINT(@sSQL1)
--PRINT(@sSQL2)
--PRINT(@sSQL3)
EXEC(@sSQL+@sSQL1+@sSQL2+@sSQL3)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

