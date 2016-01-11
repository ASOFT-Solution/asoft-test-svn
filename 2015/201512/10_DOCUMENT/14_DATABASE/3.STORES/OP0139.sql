IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0139]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0139]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Bao cao quyet toan khach hang (BOURBON)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 27/10/2014 Mai Tri Thien In Quyet toan khach hang
---- 
---- Modified on 02/10/2014 by 
-- <Example>
---- EXEC OP0139 'BBL', 'OR0136', '186CBBDB-822D-48D3-A71A-AF23AA7F8FE9'
CREATE PROCEDURE OP0139
( 		
		@DivisionID AS NVARCHAR(50),
		@ReportID AS NVARCHAR(50),
		@OrderIDs AS NVARCHAR(MAX)
) 
AS 
DECLARE @Cur AS Cursor

DECLARE 
	@sSQL			NVARCHAR(MAX),
	@sSQL1			NVARCHAR(MAX)  
	
	EXEC(N'
			UPDATE OT3004
			SET IsPrinted = 1
			WHERE DivisionID = ''' + @DivisionID + '''
			AND OrderID IN ('''+ @OrderIDs + ''')
		')

IF @ReportID = 'OR0136' -- Báo cáo tổng hợp tổng 2
BEGIN
	SET @sSQL = N' 
	WITH Tam
	AS (
	SELECT	OT3004.OrderID, OT3004.DivisionID, OT3004.VoucherTypeID, OT3004.VoucherNo,
			OT3004.InventoryTypeID, OT3004.CurrencyID, OT3004.ExchangeRate,
			OT3004.ObjectID, AT1202.ObjectName,
			OT3004.Notes AS MNotes,
			OT3004.Description AS MDescription, 
			OT3004.OrderStatus, OV1001.Description AS OrderStatusName,
			OT3004.TranMonth, OT3004.TranYear, OT3004.EmployeeID, OT3004.OrderDate,
			OT3004.CreateUserID, OT3004.Createdate, OT3004.LastModifyUserID,
			OT3004.LastModifyDate, 
			OT3004.IsPrinted,
			OT3005.InventoryID, AT1302.InventoryName, OT3005.TransactionID,
			OT3005.OrderQuantity, OT3005.OriginalAmount, OT3005.ConvertedAmount,
			OT3005.PurchasePrice, OT3005.VATPercent, OT3005.VATConvertedAmount,
			OT3005.DiscountPercent, OT3005.DiscountConvertedAmount,
			OT3005.DiscountOriginalAmount, OT3005.VATOriginalAmount,
			OT3005.[Description], OT3005.Orders,
			OT3005.Ana01ID, OT3005.Ana02ID, OT3005.Ana03ID, OT3005.Ana04ID, OT3005.Ana05ID,
			OT3005.Ana06ID, OT3005.Ana07ID, OT3005.Ana08ID,	OT3005.Ana09ID, OT3005.Ana10ID,
			Ana01.AnaName AS Ana01Name,		Ana02.AnaName AS Ana02Name,
			Ana03.AnaName AS Ana03Name,		Ana04.AnaName AS Ana04Name,
			Ana05.AnaName AS Ana05Name,		Ana06.AnaName AS Ana06Name,
			Ana07.AnaName AS Ana07Name,		Ana08.AnaName AS Ana08Name,
			Ana09.AnaName AS Ana09Name,		Ana10.AnaName AS Ana10Name,
			OT3005.Notes, 
			OT3005.Notes01, OT3005.Notes02,	OT3005.Notes03,	OT3005.Notes04,	OT3005.Notes05, 
			OT3005.Notes06, OT3005.Notes07,	OT3005.Notes08, OT3005.Notes09, 
			OT3005.RefTransactionID, OT3005.ReceiveDate,OT3005.UnitID,AT1304.UnitName,
			SOrderID = (Select SOrderID From OT3001 Where POrderID = OT02.POrderID)
			
	FROM OT3005 OT3005 
	INNER JOIN  OT3004 OT3004 ON OT3004.DivisionID = OT3005.DivisionID AND OT3004.OrderID = OT3005.OrderID
	LEFT JOIN AT1302 AT1302 ON AT1302.InventoryID= OT3005.InventoryID AND AT1302.DivisionID = OT3005.DivisionID 
	LEFT JOIN AT1202 AT1202 ON AT1202.ObjectID= OT3004.ObjectID AND AT1202.DivisionID = OT3004.DivisionID 
	LEFT JOIN OV1001 OV1001 ON OV1001.OrderStatus = OT3004.OrderStatus AND OV1001.TypeID= ''PO'' AND OV1001.DivisionID = OT3004.DivisionID
	LEFT JOIN AT1011 Ana01 ON Ana01.DivisionID = OT3005.DivisionID AND OT3005.Ana01ID = Ana01.AnaID AND Ana01.AnaTypeID = ''A01''
	LEFT JOIN AT1011 Ana02 ON Ana02.DivisionID = OT3005.DivisionID AND OT3005.Ana02ID = Ana02.AnaID AND Ana02.AnaTypeID = ''A02''
	LEFT JOIN AT1011 Ana03 ON Ana03.DivisionID = OT3005.DivisionID AND OT3005.Ana03ID = Ana03.AnaID AND Ana03.AnaTypeID = ''A03''
	LEFT JOIN AT1011 Ana04 ON Ana04.DivisionID = OT3005.DivisionID AND OT3005.Ana04ID = Ana04.AnaID AND Ana04.AnaTypeID = ''A04''
	LEFT JOIN AT1011 Ana05 ON Ana05.DivisionID = OT3005.DivisionID AND OT3005.Ana05ID = Ana05.AnaID AND Ana05.AnaTypeID = ''A05''
	LEFT JOIN AT1011 Ana06 ON Ana06.DivisionID = OT3005.DivisionID AND OT3005.Ana06ID = Ana06.AnaID AND Ana06.AnaTypeID = ''A06''
	LEFT JOIN AT1011 Ana07 ON Ana07.DivisionID = OT3005.DivisionID AND OT3005.Ana07ID = Ana07.AnaID AND Ana07.AnaTypeID = ''A07''
	LEFT JOIN AT1011 Ana08 ON Ana08.DivisionID = OT3005.DivisionID AND OT3005.Ana08ID = Ana08.AnaID AND Ana08.AnaTypeID = ''A08''
	LEFT JOIN AT1011 Ana09 ON Ana09.DivisionID = OT3005.DivisionID AND OT3005.Ana09ID = Ana09.AnaID AND Ana09.AnaTypeID = ''A09''
	LEFT JOIN AT1011 Ana10 ON Ana10.DivisionID = OT3005.DivisionID AND OT3005.Ana10ID = Ana10.AnaID AND Ana10.AnaTypeID = ''A10''
	LEFT JOIN AT1304 AT1304 ON AT1304.DivisionID = AT1304.DivisionID AND OT3005.UnitID = AT1304.UnitID
	LEFT JOIN OT3002 OT02 ON OT02.TransactionID = OT3005.RefTransactionID
	WHERE OT3004.DivisionID = ''' + @DivisionID + '''
	AND OT3004.OrderID IN (''' + @OrderIDs + ''')
	)
		
		
	SELECT ObjectID, ObjectName, InventoryID, InventoryName, 
	Ana04ID, Ana04Name, Ana10ID, Ana10Name, PurchasePrice, VATPercent, UnitName, SOrderID,
	(PurchasePrice * SUM(OrderQuantity)) OriginalAmount, 
	(PurchasePrice * SUM(OrderQuantity) * VATPercent / 100) VATOriginalAmount, 
	SUM(OrderQuantity) AS OrderQuantity
	FROM (
		SELECT OrderID, ObjectID, ObjectName, InventoryID, InventoryName, 
		Ana04ID, Ana04Name, Ana10ID, Ana10Name, PurchasePrice, VATPercent, UnitName, SOrderID,
		(PurchasePrice * SUM(OrderQuantity)) OriginalAmount, 
		(PurchasePrice * SUM(OrderQuantity) * VATPercent / 100) VATOriginalAmount, 
		SUM(OrderQuantity) AS OrderQuantity
		FROM (
			SELECT OrderID, ObjectID, ObjectName, InventoryID, InventoryName, Ana04ID, Ana04Name, Ana10ID, Ana10Name, Notes01, Notes04, 
			PurchasePrice, VATPercent, UnitName, 
			SOrderID = (CASE WHEN (SELECT COUNT(X.SOrderID) FROM 
											(
												SELECT DISTINCT SOrderID FROM Tam	
											) X
										) > 1 THEN N'''' ELSE SOrderID END)
			,
			SUM(OrderQuantity) AS OrderQuantity
			FROM Tam
			GROUP BY OrderID, ObjectID, ObjectName, InventoryID, InventoryName, Ana04ID, Ana04Name, Ana10ID, Ana10Name, 
			Notes01, Notes04, PurchasePrice, VATPercent, UnitName, SOrderID
		) A
		GROUP BY OrderID, ObjectID, ObjectName, InventoryID, InventoryName, 
		Ana04ID, Ana04Name, Ana10ID, Ana10Name, PurchasePrice, VATPercent, UnitName, SOrderID
	
	) B
	GROUP BY ObjectID, ObjectName, InventoryID, InventoryName, 
	Ana04ID, Ana04Name, Ana10ID, Ana10Name, PurchasePrice, VATPercent, UnitName, SOrderID
	
	'
	
	EXEC(@sSQL)
END
ELSE IF @ReportID = 'OR0135' -- Báo cáo tổng hợp tổng 1
BEGIN
	SET @sSQL = N' 
	WITH Tam
	AS (
	SELECT	OT3004.OrderID, OT3004.DivisionID, OT3004.VoucherTypeID, OT3004.VoucherNo,
			OT3004.InventoryTypeID, OT3004.CurrencyID, OT3004.ExchangeRate,
			OT3004.ObjectID, AT1202.ObjectName,
			OT3004.Notes AS MNotes,
			OT3004.Description AS MDescription, 
			OT3004.OrderStatus, OV1001.Description AS OrderStatusName,
			OT3004.TranMonth, OT3004.TranYear, OT3004.EmployeeID, OT3004.OrderDate,
			OT3004.CreateUserID, OT3004.Createdate, OT3004.LastModifyUserID,
			OT3004.LastModifyDate, 
			OT3004.IsPrinted,
			OT3005.InventoryID, AT1302.InventoryName, OT3005.TransactionID,
			OT3005.OrderQuantity, OT3005.OriginalAmount, OT3005.ConvertedAmount,
			OT3005.PurchasePrice, OT3005.VATPercent, OT3005.VATConvertedAmount,
			OT3005.DiscountPercent, OT3005.DiscountConvertedAmount,
			OT3005.DiscountOriginalAmount, OT3005.VATOriginalAmount,
			OT3005.[Description], OT3005.Orders,
			OT3005.Ana01ID, OT3005.Ana02ID, OT3005.Ana03ID, OT3005.Ana04ID, OT3005.Ana05ID,
			OT3005.Ana06ID, OT3005.Ana07ID, OT3005.Ana08ID,	OT3005.Ana09ID, OT3005.Ana10ID,
			Ana01.AnaName AS Ana01Name,		Ana02.AnaName AS Ana02Name,
			Ana03.AnaName AS Ana03Name,		Ana04.AnaName AS Ana04Name,
			Ana05.AnaName AS Ana05Name,		Ana06.AnaName AS Ana06Name,
			Ana07.AnaName AS Ana07Name,		Ana08.AnaName AS Ana08Name,
			Ana09.AnaName AS Ana09Name,		Ana10.AnaName AS Ana10Name,
			OT3005.Notes, 
			OT3005.Notes01, OT3005.Notes02,	OT3005.Notes03,	OT3005.Notes04,	OT3005.Notes05, 
			OT3005.Notes06, OT3005.Notes07,	OT3005.Notes08, OT3005.Notes09, 
			OT3005.RefTransactionID, OT3005.ReceiveDate,OT3005.UnitID,AT1304.UnitName,
			SOrderID = (Select SOrderID From OT3001 Where POrderID = OT02.POrderID)
	FROM OT3005 OT3005 
	INNER JOIN  OT3004 OT3004 ON OT3004.DivisionID = OT3005.DivisionID AND OT3004.OrderID = OT3005.OrderID
	LEFT JOIN AT1302 AT1302 ON AT1302.InventoryID= OT3005.InventoryID AND AT1302.DivisionID = OT3005.DivisionID 
	LEFT JOIN AT1202 AT1202 ON AT1202.ObjectID= OT3004.ObjectID AND AT1202.DivisionID = OT3004.DivisionID 
	LEFT JOIN OV1001 OV1001 ON OV1001.OrderStatus = OT3004.OrderStatus AND OV1001.TypeID= ''PO'' AND OV1001.DivisionID = OT3004.DivisionID
	LEFT JOIN AT1011 Ana01 ON Ana01.DivisionID = OT3005.DivisionID AND OT3005.Ana01ID = Ana01.AnaID AND Ana01.AnaTypeID = ''A01''
	LEFT JOIN AT1011 Ana02 ON Ana02.DivisionID = OT3005.DivisionID AND OT3005.Ana02ID = Ana02.AnaID AND Ana02.AnaTypeID = ''A02''
	LEFT JOIN AT1011 Ana03 ON Ana03.DivisionID = OT3005.DivisionID AND OT3005.Ana03ID = Ana03.AnaID AND Ana03.AnaTypeID = ''A03''
	LEFT JOIN AT1011 Ana04 ON Ana04.DivisionID = OT3005.DivisionID AND OT3005.Ana04ID = Ana04.AnaID AND Ana04.AnaTypeID = ''A04''
	LEFT JOIN AT1011 Ana05 ON Ana05.DivisionID = OT3005.DivisionID AND OT3005.Ana05ID = Ana05.AnaID AND Ana05.AnaTypeID = ''A05''
	LEFT JOIN AT1011 Ana06 ON Ana06.DivisionID = OT3005.DivisionID AND OT3005.Ana06ID = Ana06.AnaID AND Ana06.AnaTypeID = ''A06''
	LEFT JOIN AT1011 Ana07 ON Ana07.DivisionID = OT3005.DivisionID AND OT3005.Ana07ID = Ana07.AnaID AND Ana07.AnaTypeID = ''A07''
	LEFT JOIN AT1011 Ana08 ON Ana08.DivisionID = OT3005.DivisionID AND OT3005.Ana08ID = Ana08.AnaID AND Ana08.AnaTypeID = ''A08''
	LEFT JOIN AT1011 Ana09 ON Ana09.DivisionID = OT3005.DivisionID AND OT3005.Ana09ID = Ana09.AnaID AND Ana09.AnaTypeID = ''A09''
	LEFT JOIN AT1011 Ana10 ON Ana10.DivisionID = OT3005.DivisionID AND OT3005.Ana10ID = Ana10.AnaID AND Ana10.AnaTypeID = ''A10''
	LEFT JOIN AT1304 AT1304 ON AT1304.DivisionID = AT1304.DivisionID AND OT3005.UnitID = AT1304.UnitID
	LEFT JOIN OT3002 OT02 ON OT02.TransactionID = OT3005.RefTransactionID
	WHERE OT3004.DivisionID = ''' + @DivisionID + '''
	AND OT3004.OrderID IN (''' + @OrderIDs + ''')
	)
		
	SELECT OrderID, VoucherNo, ObjectID, ObjectName, InventoryID, InventoryName, 
	Ana04ID, Ana04Name, Ana10ID, Ana10Name, PurchasePrice, VATPercent, UnitName, SOrderID,
	(PurchasePrice * SUM(OrderQuantity)) OriginalAmount, 
	(PurchasePrice * SUM(OrderQuantity) * VATPercent / 100) VATOriginalAmount, 
	SUM(OrderQuantity) AS OrderQuantity
	FROM (
		SELECT OrderID, VoucherNo, ObjectID, ObjectName, InventoryID, InventoryName, Ana04ID, Ana04Name, Ana10ID, Ana10Name, Notes01, Notes04, 
		PurchasePrice, VATPercent, UnitName, 
		SOrderID = (CASE WHEN (SELECT COUNT(X.SOrderID) FROM 
											(
												SELECT DISTINCT SOrderID FROM Tam	
											) X
										) > 1 THEN N'''' ELSE SOrderID END)
		,
		SUM(OrderQuantity) AS OrderQuantity 
		FROM Tam
		GROUP BY OrderID, VoucherNo, ObjectName, ObjectID, InventoryID, InventoryName, Ana04ID, Ana04Name, Ana10ID, Ana10Name, 
		Notes01, Notes04, PurchasePrice, VATPercent, UnitName, SOrderID
	) A
	GROUP BY OrderID, VoucherNo, ObjectID, ObjectName, InventoryID, InventoryName, 
	Ana04ID, Ana04Name, Ana10ID, Ana10Name, PurchasePrice, VATPercent, UnitName, SOrderID
	ORDER BY OrderID, ObjectID, InventoryID, Ana04ID, Ana10ID

	'
	PRINT(@sSQL)
	EXEC(@sSQL)
END
ELSE
BEGIN
	SET @sSQL = N'
	SELECT	OT3004.OrderID, OT3004.DivisionID, OT3004.VoucherTypeID, OT3004.VoucherNo,
			OT3004.InventoryTypeID, OT3004.CurrencyID, OT3004.ExchangeRate,
			OT3004.ObjectID, AT1202.ObjectName,
			OT3004.Notes AS MNotes,
			OT3004.Description AS MDescription, 
			OT3004.OrderStatus, OV1001.Description AS OrderStatusName,
			OT3004.Ana01ID AS MAna01ID,	
			OT3004.Ana02ID AS MAna02ID,	 
			OT3004.Ana03ID AS MAna03ID,	 
			OT3004.Ana04ID AS MAna04ID,	 
			OT3004.Ana05ID AS MAna05ID,	
			OT3004.Ana06ID AS MAna06ID,	 
			OT3004.Ana07ID AS MAna07ID,	 
			OT3004.Ana08ID AS MAna08ID,	
			OT3004.Ana09ID AS MAna09ID,	 
			OT3004.Ana10ID AS MAna10ID,	 
			OT1002_1.AnaName AS MAna01Name, 
			OT1002_2.AnaName AS MAna02Name, 
			OT1002_3.AnaName AS MAna03Name, 
			OT1002_4.AnaName AS MAna04Name, 
			OT1002_5.AnaName AS MAna05Name, 
			OT3004.TranMonth, OT3004.TranYear, OT3004.EmployeeID, OT3004.OrderDate,
			OT3004.CreateUserID, OT3004.Createdate, OT3004.LastModifyUserID,
			OT3004.LastModifyDate, 
			OT3004.IsPrinted,
			OT3005.InventoryID, AT1302.InventoryName, OT3005.TransactionID,
			OT3005.OrderQuantity, OT3005.OriginalAmount, OT3005.ConvertedAmount,
			OT3005.PurchasePrice, OT3005.VATPercent, OT3005.VATConvertedAmount,
			OT3005.DiscountPercent, OT3005.DiscountConvertedAmount,
			OT3005.DiscountOriginalAmount, OT3005.VATOriginalAmount,
			OT3005.[Description], OT3005.Orders,
			OT3005.Ana01ID, OT3005.Ana02ID, OT3005.Ana03ID, OT3005.Ana04ID, OT3005.Ana05ID,
			OT3005.Ana06ID, OT3005.Ana07ID, OT3005.Ana08ID,	OT3005.Ana09ID, OT3005.Ana10ID,
			Ana01.AnaName AS Ana01Name,		Ana02.AnaName AS Ana02Name,
			Ana03.AnaName AS Ana03Name,		Ana04.AnaName AS Ana04Name,
			Ana05.AnaName AS Ana05Name,		Ana06.AnaName AS Ana06Name,
			Ana07.AnaName AS Ana07Name,		Ana08.AnaName AS Ana08Name,
			Ana09.AnaName AS Ana09Name,		Ana10.AnaName AS Ana10Name,
			OT3005.Notes, 
			OT3005.Notes01, OT3005.Notes02,	OT3005.Notes03,	OT3005.Notes04,	OT3005.Notes05, 
			OT3005.Notes06, OT3005.Notes07,	OT3005.Notes08, OT3005.Notes09, 
			OT3005.RefTransactionID, OT3005.ReceiveDate,OT3005.UnitID,AT1304.UnitName,
			SOrderID = (Select SOrderID From OT3001 Where POrderID = OT02.POrderID)
			'
	SET @sSQL1 = N'
	FROM OT3005 OT3005 
	INNER JOIN  OT3004 OT3004 ON OT3004.DivisionID = OT3005.DivisionID AND OT3004.OrderID = OT3005.OrderID
	LEFT JOIN AT1302 AT1302 ON AT1302.InventoryID= OT3005.InventoryID AND AT1302.DivisionID = OT3005.DivisionID 
	LEFT JOIN AT1202 AT1202 ON AT1202.ObjectID= OT3004.ObjectID AND AT1202.DivisionID = OT3004.DivisionID 
	LEFT JOIN OT1002 OT1002_1 ON OT1002_1.AnaID = OT3004.Ana01ID AND OT1002_1.AnaTypeID = ''P01'' AND OT1002_1.DivisionID = OT3004.DivisionID
	LEFT JOIN OT1002 OT1002_2 ON OT1002_2.AnaID = OT3004.Ana02ID AND OT1002_2.AnaTypeID = ''P02'' AND OT1002_2.DivisionID = OT3004.DivisionID
	LEFT JOIN OT1002 OT1002_3 ON OT1002_3.AnaID = OT3004.Ana03ID AND OT1002_3.AnaTypeID = ''P03'' AND OT1002_3.DivisionID = OT3004.DivisionID
	LEFT JOIN OT1002 OT1002_4 ON OT1002_4.AnaID = OT3004.Ana04ID AND OT1002_4.AnaTypeID = ''P04'' AND OT1002_4.DivisionID = OT3004.DivisionID
	LEFT JOIN OT1002 OT1002_5 ON OT1002_5.AnaID = OT3004.Ana05ID AND OT1002_5.AnaTypeID = ''P05'' AND OT1002_5.DivisionID = OT3004.DivisionID
	LEFT JOIN OV1001 OV1001 ON OV1001.OrderStatus = OT3004.OrderStatus AND OV1001.TypeID= ''PO'' AND OV1001.DivisionID = OT3004.DivisionID
	LEFT JOIN AT1011 Ana01 ON Ana01.DivisionID = OT3005.DivisionID AND OT3005.Ana01ID = Ana01.AnaID AND Ana01.AnaTypeID = ''A01''
	LEFT JOIN AT1011 Ana02 ON Ana02.DivisionID = OT3005.DivisionID AND OT3005.Ana02ID = Ana02.AnaID AND Ana02.AnaTypeID = ''A02''
	LEFT JOIN AT1011 Ana03 ON Ana03.DivisionID = OT3005.DivisionID AND OT3005.Ana03ID = Ana03.AnaID AND Ana03.AnaTypeID = ''A03''
	LEFT JOIN AT1011 Ana04 ON Ana04.DivisionID = OT3005.DivisionID AND OT3005.Ana04ID = Ana04.AnaID AND Ana04.AnaTypeID = ''A04''
	LEFT JOIN AT1011 Ana05 ON Ana05.DivisionID = OT3005.DivisionID AND OT3005.Ana05ID = Ana05.AnaID AND Ana05.AnaTypeID = ''A05''
	LEFT JOIN AT1011 Ana06 ON Ana06.DivisionID = OT3005.DivisionID AND OT3005.Ana06ID = Ana06.AnaID AND Ana06.AnaTypeID = ''A06''
	LEFT JOIN AT1011 Ana07 ON Ana07.DivisionID = OT3005.DivisionID AND OT3005.Ana07ID = Ana07.AnaID AND Ana07.AnaTypeID = ''A07''
	LEFT JOIN AT1011 Ana08 ON Ana08.DivisionID = OT3005.DivisionID AND OT3005.Ana08ID = Ana08.AnaID AND Ana08.AnaTypeID = ''A08''
	LEFT JOIN AT1011 Ana09 ON Ana09.DivisionID = OT3005.DivisionID AND OT3005.Ana09ID = Ana09.AnaID AND Ana09.AnaTypeID = ''A09''
	LEFT JOIN AT1011 Ana10 ON Ana10.DivisionID = OT3005.DivisionID AND OT3005.Ana10ID = Ana10.AnaID AND Ana10.AnaTypeID = ''A10''
	LEFT JOIN AT1304 AT1304 ON AT1304.DivisionID = AT1304.DivisionID AND OT3005.UnitID = AT1304.UnitID
	LEFT JOIN OT3002 OT02 ON OT02.TransactionID = OT3005.RefTransactionID
	WHERE OT3004.DivisionID = ''' + @DivisionID + '''
	AND OT3004.OrderID IN (''' + @OrderIDs + ''')
	ORDER BY OrderID, ObjectID, InventoryID, Ana04ID, Ana10ID, ReceiveDate
	'
	EXEC(@sSQL + @sSQL1)
END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
