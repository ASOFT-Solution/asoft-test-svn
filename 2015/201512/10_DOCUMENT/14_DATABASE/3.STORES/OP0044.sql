IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0044]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0044]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Detail cho màn hình OF0142 - Chọn quyết toán đơn hàng [Customize ABA]
-- <History>
---- Create on 22/04/2015 by Lê Thị Hạnh 
---- Modified on 18/06/2015 by Lê Thị Hạnh: Cập nhật phí phát sinh, phí rớt điểm, phí bốc xếp, khấu trừ và thành tiền
---- Modified on 10/09/2015 by  Thanh Thịnh: Cập Nhật Tính Thêm Phí Trả Khay Và Phí Rớt Điểm Khay
-- <Example>
/* 
OP0044 @DivisionID ='VG', @VoucherIDList = 'SO/10/14/001', 
@SVoucherID = 'E0D31A31-6409-4310-8263-6AE9419907AD', @SettleType = 1 
 */
CREATE PROCEDURE [dbo].[OP0044] 	
	@DivisionID NVARCHAR(50),
	@VoucherIDList NVARCHAR(MAX),
	@SVoucherID NVARCHAR(50), -- Truyền vào khi Edit
	@SettleType TINYINT -- 1: đơn hàng mua, 0: đơn hàng bán
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sWHERE NVARCHAR(MAX) = '',
		@sSQL2 NVARCHAR(MAX) = ''
SET @SVoucherID = ISNULL(@SVoucherID,'')
SET @SettleType = ISNULL(@SettleType,0)
-- Load dữ liệu cho Detail cho lưới
IF ISNULL(@SettleType,0) = 0 -- QUYẾT TOÁN ĐƠN HÀNG BÁN
BEGIN
	IF ISNULL(@SVoucherID,'') <> ''
	SET @sWHERE = '
	  OR OT22.SOrderID IN (SELECT OPVoucherID 
	                        FROM OT0141 
	                        WHERE DivisionID = '''+@DivisionID+''' AND VoucherID = '''+@SVoucherID+''') '
SET @sSQL1 ='				   
SELECT ''OT2001'' AS OPTableID, OT21.SOrderID AS POVoucherID, OT22.TransactionID, 
		OT21.VoucherNo, ISNULL(OT22.Orders,0) AS Orders, OT22.InventoryID, AT12.InventoryName, OT22.UnitID,
	    ISNULL(OT22.ConvertedQuantity,0) AS ConvertedQuantity, 
	    ISNULL(OT22.ConvertedSalePrice,0) AS ConvertedSalePrice,
	    ISNULL(OT22.OrderQuantity,0) AS OrderQuantity,
	    ISNULL(OT22.SalePrice,0) AS SalesPrice,
	    ISNULL(OT22.VATPercent,0) AS VATPercent,
	    ISNULL(OT22.VATOriginalAmount,0) AS VATOriginalAmount,
	    ISNULL(OT22.VATConvertedAmount,0) AS VATConvertedAmount,
	    OT22.Ana01ID, OT22.Ana02ID, OT22.Ana03ID, OT22.Ana04ID, OT22.nvarchar01 AS Notes, 
	    OT22.nvarchar02 AS Notes01, OT22.nvarchar03 AS Notes02, OT22.Ana05ID, OT22.Ana06ID, OT22.Ana07ID,
	    OT22.Ana08ID, OT22.Ana09ID, OT22.Ana10ID, OT22.nvarchar04 AS Notes03, OT22.nvarchar05 AS Notes04, 
	    OT22.nvarchar06 AS Notes05, OT22.nvarchar07 AS Notes06, OT22.nvarchar08 AS Notes07, 
	    OT22.nvarchar09 AS Notes08, OT22.nvarchar10 AS Notes09,
	    ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal,
	    (ISNULL(OT22.OriginalAmount,0)) AS OPOriginalAmount,
	    (ISNULL(OT22.ConvertedAmount,0)) AS OPConvertedAmount,
	    ((CASE WHEN ISNUMERIC(OT22.nvarchar02) = 0 OR OT22.nvarchar02 LIKE ''.'' OR OT22.nvarchar02 LIKE ''%e%'' OR OT22.nvarchar02 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar02) END)) AS nvarchar02,
	    ((CASE WHEN ISNUMERIC(OT22.nvarchar03) = 0 OR OT22.nvarchar03 LIKE ''.'' OR OT22.nvarchar03 LIKE ''%e%'' OR OT22.nvarchar03 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar03) END)) AS nvarchar03,
	    ((CASE WHEN ISNUMERIC(OT22.nvarchar08) = 0 OR OT22.nvarchar08 LIKE ''.'' OR OT22.nvarchar08 LIKE ''%e%'' OR OT22.nvarchar08 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar08) END)) AS nvarchar08,
	   ((ISNULL(OT22.OriginalAmount,0))
	 + ((CASE WHEN ISNUMERIC(OT22.nvarchar02) = 0 OR OT22.nvarchar02 LIKE ''.'' OR OT22.nvarchar02 LIKE ''%e%'' OR OT22.nvarchar02 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar02) END)/ISNULL(OT21.ExchangeRate,1)) 
	 + ((CASE WHEN ISNUMERIC(OT22.nvarchar03) = 0 OR OT22.nvarchar03 LIKE ''.'' OR OT22.nvarchar03 LIKE ''%e%'' OR OT22.nvarchar03 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar03) END)/ISNULL(OT21.ExchangeRate,1))
	 + ((CASE WHEN ISNUMERIC(OT22.nvarchar08) = 0 OR OT22.nvarchar08 LIKE ''.'' OR OT22.nvarchar08 LIKE ''%e%'' OR OT22.nvarchar08 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar08) END)/ISNULL(OT21.ExchangeRate,1))
	 + ((CASE WHEN ISNUMERIC(OT22.varchar03) = 0 OR OT22.varchar03 LIKE ''.'' OR OT22.varchar03 LIKE ''%e%'' OR OT22.varchar03 LIKE ''%-%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar03) END)/ISNULL(OT21.ExchangeRate,1))
	 + ((CASE WHEN ISNUMERIC(OT22.varchar04) = 0 OR OT22.varchar04 LIKE ''.'' OR OT22.varchar04 LIKE ''%e%'' OR OT22.varchar04 LIKE ''%-%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar04) END)/ISNULL(OT21.ExchangeRate,1))		 
			 ) AS OriginalAmount,
	   ((ISNULL(OT22.ConvertedAmount,0))
	 + ((CASE WHEN ISNUMERIC(OT22.nvarchar02) = 0 OR OT22.nvarchar02 LIKE ''.'' OR OT22.nvarchar02 LIKE ''%e%'' OR OT22.nvarchar02 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar02) END)) 
	 + ((CASE WHEN ISNUMERIC(OT22.nvarchar03) = 0 OR OT22.nvarchar03 LIKE ''.'' OR OT22.nvarchar03 LIKE ''%e%'' OR OT22.nvarchar03 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar03) END))
	 + ((CASE WHEN ISNUMERIC(OT22.nvarchar08) = 0 OR OT22.nvarchar08 LIKE ''.'' OR OT22.nvarchar08 LIKE ''%e%'' OR OT22.nvarchar08 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar08) END))
	 + ((CASE WHEN ISNUMERIC(OT22.varchar03) = 0 OR OT22.varchar03 LIKE ''.'' OR OT22.varchar03 LIKE ''%e%'' OR OT22.varchar03 LIKE ''%e%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar03) END))
	 + ((CASE WHEN ISNUMERIC(OT22.varchar04) = 0 OR OT22.varchar04 LIKE ''.'' OR OT22.varchar04 LIKE ''%e%'' OR OT22.varchar04 LIKE ''%e%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar04) END))		 
			 ) AS ConvertedAmount '
SET @sSQL2 = '
FROM OT2001 OT21
INNER JOIN OT2002 OT22 ON OT22.DivisionID = OT21.DivisionID AND OT22.SOrderID = OT21.SOrderID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = OT22.DivisionID AND AT12.InventoryID = OT22.InventoryID
LEFT JOIN AT1004 AT14 ON AT14.DivisionID = OT21.DivisionID AND AT14.CurrencyID = OT21.CurrencyID
WHERE OT22.DivisionID = '''+@DivisionID+''' AND ISNULL(OT21.OrderType,0) = 0 
	  AND OT22.SOrderID IN ('''+@VoucherIDList+''') '+@sWHERE+'
ORDER BY VoucherNo, Orders, InventoryID
	'
END
ELSE  
BEGIN
	IF ISNULL(@SVoucherID,'') <> ''
	SET @sWHERE = '
	OR OT32.POrderID IN (SELECT OPVoucherID 
	                     FROM OT0141 
	                     WHERE DivisionID = '''+@DivisionID+''' AND VoucherID = '''+@SVoucherID+''') '
SET @sSQL1 =				   
'SELECT ''OT3001'' AS OPTableID, OT31.POrderID AS POVoucherID, OT32.TransactionID, 
		OT31.VoucherNo, ISNULL(OT32.Orders,0) AS Orders, OT32.InventoryID, AT12.InventoryName, OT32.UnitID,
	    ISNULL(OT32.ConvertedQuantity,0) AS ConvertedQuantity, 
	    ISNULL(OT32.ConvertedSalePrice,0) AS ConvertedSalePrice,
	    ISNULL(OT32.OrderQuantity,0) AS OrderQuantity,
	    ISNULL(OT32.PurchasePrice,0) AS SalesPrice,
	    ISNULL(OT32.VATPercent,0) AS VATPercent,
	    ISNULL(OT32.VATOriginalAmount,0) AS VATOriginalAmount,
	    ISNULL(OT32.VATConvertedAmount,0) AS VATConvertedAmount,
	    OT32.Ana01ID, OT32.Ana02ID, OT32.Ana03ID, OT32.Ana04ID, OT32.Notes,
	    OT32.Notes01, OT32.Notes02, OT32.Ana05ID, OT32.Ana06ID, OT32.Ana07ID,
	    OT32.Ana08ID, OT32.Ana09ID, OT32.Ana10ID, OT32.Notes03, OT32.Notes04,
	    OT32.Notes05, OT32.Notes06, OT32.Notes07, OT32.Notes08, OT32.Notes09,
	    ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal,
	    (ISNULL(OT32.OriginalAmount,0)) AS OPOriginalAmount,
	    (ISNULL(OT32.ConvertedAmount,0)) AS OPConvertedAmount,
	   ((CASE WHEN ISNUMERIC(OT32.Notes) = 0 OR OT32.Notes LIKE ''.'' OR OT32.Notes LIKE ''%e%'' OR OT32.Notes LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes) END)) AS Notes,
	   ((CASE WHEN ISNUMERIC(OT32.Notes02) = 0 OR OT32.Notes02 LIKE ''.'' OR OT32.Notes02 LIKE ''%e%'' OR OT32.Notes02 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes02) END)) AS Notes02,
	   ((CASE WHEN ISNUMERIC(OT32.Notes03) = 0 OR OT32.Notes03 LIKE ''.'' OR OT32.Notes03 LIKE ''%e%'' OR OT32.Notes03 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes03) END)) AS Notes03,
	  ((ISNULL(OT32.OriginalAmount,0))
	 + ((CASE WHEN ISNUMERIC(OT32.Notes) = 0 OR OT32.Notes LIKE ''.'' OR OT32.Notes LIKE ''%e%'' OR OT32.Notes LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes) END)/ISNULL(OT31.ExchangeRate,1))
	 + ((CASE WHEN ISNUMERIC(OT32.Notes02) = 0 OR OT32.Notes02 LIKE ''.'' OR OT32.Notes02 LIKE ''%e%'' OR OT32.Notes02 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes02) END)/ISNULL(OT31.ExchangeRate,1))
	 - ((CASE WHEN ISNUMERIC(OT32.Notes03) = 0 OR OT32.Notes03 LIKE ''.'' OR OT32.Notes03 LIKE ''%e%'' OR OT32.Notes03 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes03) END)/ISNULL(OT31.ExchangeRate,1))) AS OriginalAmount,
	  ((ISNULL(OT32.ConvertedAmount,0))
	 + ((CASE WHEN ISNUMERIC(OT32.Notes) = 0 OR OT32.Notes LIKE ''.'' OR OT32.Notes LIKE ''%e%'' OR OT32.Notes LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes) END))
	 + ((CASE WHEN ISNUMERIC(OT32.Notes02) = 0 OR OT32.Notes02 LIKE ''.'' OR OT32.Notes02 LIKE ''%e%'' OR OT32.Notes02 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes02) END))
	 - ((CASE WHEN ISNUMERIC(OT32.Notes03) = 0 OR OT32.Notes03 LIKE ''.'' OR OT32.Notes03 LIKE ''%e%'' OR OT32.Notes03 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes03) END))) AS ConvertedAmount '
SET @sSQL2 = '
FROM OT3002 OT32
INNER JOIN OT3001 OT31 ON OT31.DivisionID = OT32.DivisionID AND OT31.POrderID = OT32.POrderID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = OT32.DivisionID AND AT12.InventoryID = OT32.InventoryID
LEFT JOIN AT1004 AT14 ON AT14.DivisionID = OT31.DivisionID AND AT14.CurrencyID = OT31.CurrencyID
WHERE OT32.DivisionID = '''+@DivisionID+''' AND OT32.POrderID IN ('''+@VoucherIDList+''')
	  '+@sWHERE+'
ORDER BY VoucherNo, Orders, InventoryID
	'
END  
EXEC (@sSQL1 + @sSQL2) 
--PRINT (@sSQL1)
--PRINT (@sSQL2)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
