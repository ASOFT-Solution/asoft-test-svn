IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0048]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0048]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- IN BÁO CÁO ĐẶC THÙ "BÁO CÁO LÃI LỖ ĐƠN HÀNG" [Customize Index: 45 - ABA)
-- <History>
---- Create on 05/05/2015 by Lê Thị Hạnh 
---- Modified on 08/01/2015 by Quoc Tuan sua them PNotes03 
---- Modified on ... by 
-- <Example>
/*
 OP0048 @DivisionID = 'vg', @FromPeriod = 201409, @ToPeriod = 201510, @FromDate = '2014-09-01',
 @ToDate = '2014-09-15', @TimeMode = 0, @FromObjectID = 'AC002', @ToObjectID = 'YKL001', @FromSupplyID = 'AC002',
 @ToSupplyID = 'YKL001', @FromAna02ID = '', @ToAna02ID = ''
 */

CREATE PROCEDURE [dbo].[OP0048] 	
	@DivisionID NVARCHAR(50),
	@FromPeriod INT,
	@ToPeriod INT,	
	@FromDate DATETIME,
	@ToDate DATETIME,
	@TimeMode TINYINT,
	@ToObjectID NVARCHAR(50),
	@FromObjectID NVARCHAR(50),
	@FromSupplyID NVARCHAR(50),
	@ToSupplyID NVARCHAR(50),
	@FromAna02ID NVARCHAR(50),
	@ToAna02ID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sWHERE NVARCHAR(MAX) 
IF LTRIM(STR(@TimeMode)) = 1	
SET @sWHERE = 'AND CONVERT(VARCHAR(10),OT21.OrderDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '

IF LTRIM(STR(@TimeMode)) = 0	
SET @sWHERE = 'AND (OT21.TranYear*100 + OT21.TranMonth) BETWEEN '+LTRIM(@FromPeriod)+' AND '+LTRIM(@ToPeriod)+' '
SET @sSQL1 = '
SELECT OT21.VoucherNo AS SOVoucherNo, OT21.OrderDate AS SOVoucherDate, 
	   OT21.ObjectID AS SOObjectID, AT12.ObjectName AS SOObjectName, OT21.DeliveryAddress,
       OT31.VoucherNo AS POVoucherNo, OT31.OrderDate AS POVoucherDate, 
       OT31.ObjectID AS POObjectID, AT02.ObjectName AS POObjectName,
       OT22.Ana02ID, A02.AnaName AS Ana02Name, OT22.InventoryID, 
       OT22.Ana01ID, OT22.Ana03ID, OT22.Ana04ID, OT22.Ana05ID, OT22.Ana06ID, OT22.Ana07ID, OT22.Ana08ID, 
       OT22.Ana09ID, OT22.Ana10ID, 
       OT22.nvarchar01 AS Notes, 
       (CASE WHEN ISNUMERIC(OT22.nvarchar02) = 0 OR OT22.nvarchar02 LIKE ''.'' OR OT22.nvarchar02 LIKE ''%e%'' OR OT22.nvarchar02 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar02) END) AS Notes01,
       (CASE WHEN ISNUMERIC(OT22.nvarchar03) = 0 OR OT22.nvarchar03 LIKE ''.'' OR OT22.nvarchar03 LIKE ''%e%'' OR OT22.nvarchar03 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar03) END) AS Notes02,
       OT22.nvarchar04 AS Notes03, OT22.nvarchar05 AS Notes04, OT22.nvarchar06 AS Notes05, OT22.nvarchar07 AS Notes06,
       (CASE WHEN ISNUMERIC(OT22.nvarchar08) = 0 OR OT22.nvarchar08 LIKE ''.'' OR OT22.nvarchar08 LIKE ''%e%'' OR OT22.nvarchar08 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar08) END) AS Notes07,
	   OT22.nvarchar09 AS Notes08, OT22.nvarchar10 AS Notes09,OT22.Varchar01 AS Notes10,OT22.Varchar02 AS Notes11, 
	   OT22.Varchar03 AS Notes12,OT22.Varchar04 AS Notes13,OT22.Varchar05 AS Notes14,OT22.Varchar06 AS Notes15,
	   OT22.Varchar07 AS Notes16,OT22.Varchar08 AS Notes17,OT22.Varchar09 AS Notes18,OT22.Varchar10 AS Notes19,
	   (CASE WHEN ISNUMERIC(OT32.Notes) = 0 OR OT32.Notes LIKE ''.'' OR OT32.Notes LIKE ''%e%'' OR OT32.Notes LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),ISNULL(OT32.Notes,''0'')) END) AS POPONotes,
       OT32.Notes01 AS POPONotes01,
       (CASE WHEN ISNUMERIC(OT32.Notes02) = 0 OR OT32.Notes02 LIKE ''.'' OR OT32.Notes02 LIKE ''%e%'' OR OT32.Notes02 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),ISNULL(OT32.Notes02,''0'')) END) AS POPONotes02,
       (CASE WHEN ISNUMERIC(OT32.Notes03) = 0 OR OT32.Notes03 LIKE ''.'' OR OT32.Notes03 LIKE ''%e%'' OR OT32.Notes03 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),ISNULL(OT32.Notes03,''0'')) END) AS POPONotes03, OT32.Notes04 AS POPONotes04, 
       OT32.Notes05 AS POPONotes05, OT32.Notes06 AS POPONotes06, OT32.Notes07 AS POPONotes07, OT32.Notes08 AS PONotes08, OT32.Notes09 AS PONotes09,
       ISNULL(OT22.OrderQuantity,0) AS SOQuantity, 
       ISNULL(OT22.SalePrice,0) AS SalesPrice, 
       ISNULL(OT22.ConvertedQuantity,0) AS SOConvertedQuantity, 
       ISNULL(OT22.ConvertedSalePrice,0) AS SOSalePrice, 
       ISNULL(OT32.OrderQuantity,0) AS POQuantity, 
       ISNULL(OT32.PurchasePrice,0) AS PurchasePrice, 
       ISNULL(OT32.ConvertedQuantity,0) AS POConvertedQuantity,
       ISNULL(OT32.ConvertedSalePrice,0) AS POPurchasePrice , 
	   OT22.Varchar01 as nvarchar11
FROM OT2001 OT21
INNER JOIN OT2002 OT22 ON OT22.DivisionID = OT21.DivisionID AND OT22.SOrderID = OT21.SOrderID 
LEFT JOIN OT3001 OT31 ON OT31.DivisionID = OT22.DivisionID AND OT31.POrderID = OT22.InheritVoucherID AND OT22.InheritTableID = ''OT3001''
LEFT JOIN OT3002 OT32 ON OT32.DivisionID = OT22.DivisionID AND OT31.POrderID = OT22.InheritVoucherID AND OT32.TransactionID = OT22.InheritTransactionID AND OT22.InheritTableID = ''OT3001''
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT21.DivisionID AND AT12.ObjectID = OT21.ObjectID
LEFT JOIN AT1202 AT02 ON AT02.DivisionID = OT31.DivisionID AND AT02.ObjectID = OT31.ObjectID
LEFT JOIN AT1011 A02 ON A02.DivisionID = OT22.DivisionID AND A02.AnaID = OT22.Ana02ID AND A02.AnaTypeID =''A02''
WHERE OT21.DivisionID = '''+@DivisionID+''' AND OT21.OrderType = 0 
	  AND ISNULL(OT21.ObjectID,'''') BETWEEN '''+@FromObjectID+''' AND '''+@ToObjectID+'''
	  AND ISNULL(OT22.Ana02ID,'''') BETWEEN '''+@FromAna02ID+''' AND '''+@ToAna02ID+'''
	--AND ISNULL(OT31.ObjectID,'''') BETWEEN '''+@FromSupplyID+''' AND '''+@ToSupplyID+'''
	  '+@sWHERE+'
ORDER BY OT21.OrderDate, OT21.VoucherNo, OT22.Orders'
EXEC (@sSQL1)
--PRINT (@sSQL1)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
