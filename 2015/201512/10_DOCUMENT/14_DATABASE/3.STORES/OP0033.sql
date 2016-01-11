IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0033]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0033]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Hiển thị dữ liệu chi tiết cho màn hình duyệt đơn hàng bán 
-- <History>
---- Create on 01/10/2013 by Bảo Anh
---- Modified on ... by 
---- Modified Lê Thị Hạnh on 05/12/2014 by : Thay đổi cách lấy InventoryName
-- <Example>
/* 
OP0033 @DivisionID = 'CTY',@SOrderID = 'SO/12/2014/0015' 
*/

CREATE PROCEDURE [dbo].[OP0033]  
				@DivisionID nvarchar(50),
				@SOrderID nvarchar (50)
AS

Declare @sSQL AS nvarchar(4000)
		
Set @sSQL= N'
SELECT OT22.SOrderID, OT22.Orders, OT22.InventoryID, 
	   ISNULL(OT22.InventoryCommonName,AT02.InventoryName) AS InventoryName,
	   AT02.UnitID, ISNULL(OT22.OrderQuantity,0) AS OrderQuantity, 
	   ISNULL(OT22.SalePrice,0) AS SalePrice, ISNULL(OT22.ConvertedAmount,0) AS ConvertedAmount,
	   ISNULL(OT22.OriginalAmount,0) AS OriginalAmount, ISNULL(OT22.VATConvertedAmount,0) AS VATConvertedAmount, 
	   ISNULL(OT22.DiscountConvertedAmount,0) AS DiscountConvertedAmount,
	   OT22.Ana01ID, A01.AnaName AS Ana01Name, OT22.Ana02ID, A02.AnaName AS Ana02Name,
	   OT22.Ana03ID, A03.AnaName AS Ana03Name, OT22.Ana04ID, A04.AnaName AS Ana04Name,
	   OT22.Ana05ID, A05.AnaName AS Ana05Name, OT22.Ana06ID, A06.AnaName AS Ana06Name,
	   OT22.Ana07ID, A07.AnaName AS Ana07Name, OT22.Ana08ID, A08.AnaName AS Ana08Name,
	   OT22.Ana09ID, A09.AnaName AS Ana09Name, OT22.Ana10ID, A10.AnaName AS Ana10Name
FROM OT2002 OT22
LEFT JOIN AT1302 AT02 ON AT02.DivisionID = OT22.DivisionID AND AT02.InventoryID = OT22.InventoryID
LEFT JOIN AT1011 A01 ON A01.DivisionID = OT22.DivisionID AND A01.AnaID = OT22.Ana01ID AND A01.AnaTypeID =''A01''
LEFT JOIN AT1011 A02 ON A02.DivisionID = OT22.DivisionID AND A02.AnaID = OT22.Ana02ID AND A02.AnaTypeID =''A02''
LEFT JOIN AT1011 A03 ON A03.DivisionID = OT22.DivisionID AND A03.AnaID = OT22.Ana03ID AND A03.AnaTypeID =''A03''
LEFT JOIN AT1011 A04 ON A04.DivisionID = OT22.DivisionID AND A04.AnaID = OT22.Ana04ID AND A04.AnaTypeID =''A04''
LEFT JOIN AT1011 A05 ON A05.DivisionID = OT22.DivisionID AND A05.AnaID = OT22.Ana05ID AND A05.AnaTypeID =''A05''
LEFT JOIN AT1011 A06 ON A06.DivisionID = OT22.DivisionID AND A06.AnaID = OT22.Ana06ID AND A06.AnaTypeID =''A06''
LEFT JOIN AT1011 A07 ON A07.DivisionID = OT22.DivisionID AND A07.AnaID = OT22.Ana07ID AND A07.AnaTypeID =''A07''
LEFT JOIN AT1011 A08 ON A08.DivisionID = OT22.DivisionID AND A08.AnaID = OT22.Ana08ID AND A08.AnaTypeID =''A08''
LEFT JOIN AT1011 A09 ON A09.DivisionID = OT22.DivisionID AND A09.AnaID = OT22.Ana09ID AND A09.AnaTypeID =''A09''
LEFT JOIN AT1011 A10 ON A10.DivisionID = OT22.DivisionID AND A10.AnaID = OT22.Ana10ID AND A10.AnaTypeID =''A10''
WHERE OT22.DivisionID = '''+@DivisionID+''' AND OT22.SOrderID = '''+@SOrderID+'''
ORDER BY OT22.Orders '

/*Select	
		OT2002.SOrderID,
		OT2002.InventoryID, 
		--case when isnull(OT2002.InventoryCommonName, '''') = '''' then AT1302.InventoryName else OT2002.InventoryCommonName end AS 
		InventoryName, 		
		AT1302.UnitID,
		OT2002.OrderQuantity, 
		SalePrice, 
		ConvertedAmount, 
		OriginalAmount, 
		VATConvertedAmount, 
		DiscountConvertedAmount,  
		OT2002.Orders
From OT2002 
LEFT JOIN AT1302 on AT1302.InventoryID= OT2002.InventoryID And AT1302.DivisionID= OT2002.DivisionID
Where  OT2002.DivisionID = ''' + @DivisionID + ''' AND OT2002.SOrderID = ''' + @SOrderID + ''' ORDER BY Orders'
*/
EXEC(@sSQL)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON