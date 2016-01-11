IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0040]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0040]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load dữ liệu báo cáo OR0140, OR0141 - Báo cáo quyết toán đơn hàng [Customize ABA]
-- <History>
---- Create on 05/05/2015 by Lê Thị Hạnh 
---- Modified on 03/06/2015 by Lê Thị Hạnh: Bổ sung trường DHM: Notes04 khấu trừ, DHM: nvarchar09, nvarchar10
-- <Example>
/*
exec OP0040 @DivisionID=N'VG',@SettleType=0,@SVoucherID=N'93750fb0-b2eb-45f4-b683-7e49a6443032'
 */
 
CREATE PROCEDURE [dbo].[OP0040] 	
	@DivisionID NVARCHAR(50),
	@SettleType TINYINT, -- 0:Đơn hàng bán, 1: đơn hàng mua
	@SVoucherID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX),
        @sWHERE NVARCHAR(MAX),
        @sSQL2 NVARCHAR(MAX)
		
SET @SVoucherID = ISNULL(@SVoucherID,'')
SET @sWHERE = ''
IF ISNULL(@SettleType,0) = 0 
BEGIN
	SET @sSQL1 = '
SELECT OT40.VoucherNo, OT40.VoucherDate, OT21.VoucherNo AS OPVoucherNo, OT21.OrderDate AS OPVoucherDate,
	   OT21.ObjectID AS OPObjectID, AT12.ObjectName AS OPObjectName, '''' AS District, AT12.CityID, AT02.CityName, 
	   OT22.InventoryID, AT13.InventoryName, OT21.DeliveryAddress,
       ISNULL(OT22.OrderQuantity,0) AS Quantity, 
       ISNULL(OT22.SalePrice,0) AS SalesPrice, 
       OT22.Ana01ID, A01.AnaName AS Ana01Name, OT22.Ana02ID, A02.AnaName AS Ana02Name, 
       OT22.Ana03ID, A03.AnaName AS Ana03Name, OT22.Ana04ID, A04.AnaName AS Ana04Name,
       OT22.Ana05ID, A05.AnaName AS Ana05Name, OT22.Ana06ID, A06.AnaName AS Ana06Name, 
       OT22.Ana07ID, A07.AnaName AS Ana07Name, OT22.Ana08ID, A08.AnaName AS Ana08Name,
       OT22.Ana09ID, A09.AnaName AS Ana09Name, OT22.Ana10ID, A10.AnaName AS Ana10Name,
       OT22.nvarchar01 AS Notes, 
       (CASE WHEN ISNUMERIC(OT22.nvarchar02) = 0 OR OT22.nvarchar02 LIKE ''.'' OR OT22.nvarchar02 LIKE ''%e%'' OR OT22.nvarchar02 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar02) END) AS Notes01,
       (CASE WHEN ISNUMERIC(OT22.nvarchar03) = 0 OR OT22.nvarchar03 LIKE ''.'' OR OT22.nvarchar03 LIKE ''%e%'' OR OT22.nvarchar03 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar03) END) AS Notes02,
       OT22.nvarchar04 AS Notes03, OT22.nvarchar05 AS Notes04, OT22.nvarchar06 AS Notes05, OT22.nvarchar07 AS Notes06,
       (CASE WHEN ISNUMERIC(OT22.nvarchar08) = 0 OR OT22.nvarchar08 LIKE ''.'' OR OT22.nvarchar08 LIKE ''%e%'' OR OT22.nvarchar08 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar08) END) AS Notes07,
	   (CASE WHEN ISNUMERIC(OT22.nvarchar09) = 0 OR OT22.nvarchar09 LIKE ''.'' OR OT22.nvarchar09 LIKE ''%e%'' OR OT22.nvarchar09 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar09) END) AS Notes08,
	   (CASE WHEN ISNUMERIC(OT22.nvarchar10) = 0 OR OT22.nvarchar10 LIKE ''.'' OR OT22.nvarchar10 LIKE ''%e%'' OR OT22.nvarchar10 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar10) END) AS Notes09,
	   OT22.varchar01 AS Notes10, OT22.varchar02 AS Notes11, 
	   (CASE WHEN ISNUMERIC(OT22.varchar03) = 0 OR OT22.varchar03 LIKE ''.'' OR OT22.varchar03 LIKE ''%e%'' OR OT22.varchar03 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT22.varchar03) END) AS Notes12,
	   (CASE WHEN ISNUMERIC(OT22.varchar04) = 0 OR OT22.varchar04 LIKE ''.'' OR OT22.varchar04 LIKE ''%e%'' OR OT22.varchar04 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT22.varchar04) END) AS Notes13	  '
SET @sSQL2 =     
'FROM OT0140 OT40
INNER JOIN OT0141 OT41 ON OT41.DivisionID = OT40.DivisionID AND OT41.VoucherID = OT40.VoucherID
INNER JOIN OT2001 OT21 ON OT21.DivisionID = OT41.DivisionID AND OT21.SOrderID = OT41.OPVoucherID AND OT41.OPTableID = ''OT2001''
INNER JOIN OT2002 OT22 ON OT22.DivisionID = OT21.DivisionID AND OT22.SOrderID = OT21.SOrderID
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT21.DivisionID AND AT12.ObjectID = OT21.ObjectID
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = OT22.DivisionID AND AT13.InventoryID = OT22.InventoryID
LEFT JOIN AT1011 A01 ON A01.DivisionID = OT22.DivisionID AND A01.AnaID = OT22.Ana01ID AND A01.AnaTypeID =''A01''
LEFT JOIN AT1011 A02 ON A02.DivisionID = OT22.DivisionID AND A02.AnaID = OT22.Ana02ID AND A02.AnaTypeID =''A02''
LEFT JOIN AT1011 A03 ON A03.DivisionID = OT22.DivisionID AND A03.AnaID = OT22.Ana03ID AND A03.AnaTypeID =''A03''
LEFT JOIN AT1011 A04 ON A04.DivisionID = OT22.DivisionID AND A04.AnaID = OT22.Ana04ID AND A04.AnaTypeID =''A04''
LEFT JOIN AT1011 A05 ON A05.DivisionID = OT22.DivisionID AND A05.AnaID = OT22.Ana01ID AND A05.AnaTypeID =''A05''
LEFT JOIN AT1011 A06 ON A06.DivisionID = OT22.DivisionID AND A06.AnaID = OT22.Ana02ID AND A06.AnaTypeID =''A06''
LEFT JOIN AT1011 A07 ON A07.DivisionID = OT22.DivisionID AND A07.AnaID = OT22.Ana03ID AND A07.AnaTypeID =''A07''
LEFT JOIN AT1011 A08 ON A08.DivisionID = OT22.DivisionID AND A08.AnaID = OT22.Ana04ID AND A08.AnaTypeID =''A08''
LEFT JOIN AT1011 A09 ON A09.DivisionID = OT22.DivisionID AND A09.AnaID = OT22.Ana03ID AND A09.AnaTypeID =''A09''
LEFT JOIN AT1011 A10 ON A10.DivisionID = OT22.DivisionID AND A10.AnaID = OT22.Ana04ID AND A10.AnaTypeID =''A10''
LEFT JOIN AT1002 AT02 ON AT02.DivisionID = AT12.DivisionID AND AT02.CityID = AT12.CityID
WHERE OT21.DivisionID = '''+@DivisionID+''' 
	  AND OT21.SOrderID IN (SELECT OT41.OPVoucherID 
	                        FROM OT0141 OT41 
	                        WHERE OT41.DivisionID = '''+@DivisionID+''' AND OT41.VoucherID  = '''+@SVoucherID+''' AND OT41.OPTableID = ''OT2001'') 
ORDER BY OT40.VoucherID, OT41.Orders, OT41.OPVoucherID, OT22.Orders
'
END
ELSE 
BEGIN
	SET @sSQL1 = '
SELECT OT40.VoucherNo, OT40.VoucherDate, OT31.VoucherNo AS OPVoucherNo, OT31.OrderDate AS OPVoucherDate,
	   OT31.ObjectID AS OPObjectID, AT12.ObjectName AS OPObjectName, OT32.InventoryID, AT13.InventoryName,
       ISNULL(OT32.OrderQuantity,0) AS Quantity, 
       ISNULL(OT32.PurchasePrice,0) AS SalesPrice, 
       OT32.Ana01ID, A01.AnaName AS Ana01Name, OT32.Ana02ID, A02.AnaName AS Ana02Name, 
       OT32.Ana03ID, A03.AnaName AS Ana03Name, OT32.Ana04ID, A04.AnaName AS Ana04Name,
       OT32.Ana05ID, A05.AnaName AS Ana05Name, OT32.Ana06ID, A06.AnaName AS Ana06Name, 
       OT32.Ana07ID, A07.AnaName AS Ana07Name, OT32.Ana08ID, A08.AnaName AS Ana08Name,
       OT32.Ana09ID, A09.AnaName AS Ana09Name, OT32.Ana10ID, A10.AnaName AS Ana10Name,        
       (CASE WHEN ISNUMERIC(OT32.Notes) = 0 OR OT32.Notes LIKE ''.'' OR OT32.Notes LIKE ''%e%'' OR OT32.Notes LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes) END) AS Notes,
       OT32.Notes01 AS Notes01,
       (CASE WHEN ISNUMERIC(OT32.Notes02) = 0 OR OT32.Notes02 LIKE ''.'' OR OT32.Notes02 LIKE ''%e%'' OR OT32.Notes02 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes02) END) AS Notes02,
       (CASE WHEN ISNUMERIC(OT32.Notes03) = 0 OR OT32.Notes03 LIKE ''.'' OR OT32.Notes03 LIKE ''%e%'' OR OT32.Notes03 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes03) END) AS Notes03,
       OT32.Notes04 AS Notes04, OT32.Notes05 AS Notes05, OT32.Notes06 AS Notes06, OT32.Notes07 AS Notes07, 
       OT32.Notes08 AS Notes08, OT32.Notes09 AS Notes09 '
SET @sSQL2 = 
'FROM OT0140 OT40
INNER JOIN OT0141 OT41 ON OT41.DivisionID = OT40.DivisionID AND OT41.VoucherID = OT40.VoucherID
INNER JOIN OT3001 OT31 ON OT31.DivisionID = OT41.DivisionID AND OT31.POrderID = OT41.OPVoucherID AND OT41.OPTableID = ''OT3001''
INNER JOIN OT3002 OT32 ON OT32.DivisionID = OT31.DivisionID AND OT32.POrderID = OT31.POrderID
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT31.DivisionID AND AT12.ObjectID = OT31.ObjectID
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = OT32.DivisionID AND AT13.InventoryID = OT32.InventoryID
LEFT JOIN AT1011 A01 ON A01.DivisionID = OT32.DivisionID AND A01.AnaID = OT32.Ana01ID AND A01.AnaTypeID =''A01''
LEFT JOIN AT1011 A02 ON A02.DivisionID = OT32.DivisionID AND A02.AnaID = OT32.Ana02ID AND A02.AnaTypeID =''A02''
LEFT JOIN AT1011 A03 ON A03.DivisionID = OT32.DivisionID AND A03.AnaID = OT32.Ana03ID AND A03.AnaTypeID =''A03''
LEFT JOIN AT1011 A04 ON A04.DivisionID = OT32.DivisionID AND A04.AnaID = OT32.Ana04ID AND A04.AnaTypeID =''A04''
LEFT JOIN AT1011 A05 ON A05.DivisionID = OT32.DivisionID AND A05.AnaID = OT32.Ana01ID AND A05.AnaTypeID =''A05''
LEFT JOIN AT1011 A06 ON A06.DivisionID = OT32.DivisionID AND A06.AnaID = OT32.Ana02ID AND A06.AnaTypeID =''A06''
LEFT JOIN AT1011 A07 ON A07.DivisionID = OT32.DivisionID AND A07.AnaID = OT32.Ana03ID AND A07.AnaTypeID =''A07''
LEFT JOIN AT1011 A08 ON A08.DivisionID = OT32.DivisionID AND A08.AnaID = OT32.Ana04ID AND A08.AnaTypeID =''A08''
LEFT JOIN AT1011 A09 ON A09.DivisionID = OT32.DivisionID AND A09.AnaID = OT32.Ana03ID AND A09.AnaTypeID =''A09''
LEFT JOIN AT1011 A10 ON A10.DivisionID = OT32.DivisionID AND A10.AnaID = OT32.Ana04ID AND A10.AnaTypeID =''A10''
WHERE OT31.DivisionID = '''+@DivisionID+''' 
	  AND OT31.POrderID IN (SELECT OT41.OPVoucherID 
	                        FROM OT0141 OT41 
	                        WHERE OT41.DivisionID = '''+@DivisionID+''' AND OT41.VoucherID = '''+@SVoucherID+''' AND OT41.OPTableID = ''OT3001'')
ORDER BY OT40.VoucherID, OT41.Orders, OT41.OPVoucherID, OT32.Orders
'
END	
EXEC (@sSQL1 + @sSQL2)
--PRINT (@sSQL1)
--PRINT (@sSQL2)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
