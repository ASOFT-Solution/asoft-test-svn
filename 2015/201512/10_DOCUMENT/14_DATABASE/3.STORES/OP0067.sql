IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0067]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0067]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- In xác nhận hoàn thành
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 29/09/2014 by Le Thi Thu Hien
---- 
---- Modified on 29/09/2014 by Mai Tri Thien: Ket thong tin doi tuong lay Address va VATNo
---- Modified on 22/10/2014 by Mai Tri Thien: Lấy thêm trường từ OT3001
---- Modified on 08/12/2014 by Mai Tri Thien: Không load thầu phụ (IsPicking != 1) 
---- 
-- <Example>
---- EXEC OP0067 @DivisionID = 'BBL', @UserID = 'ASOFTADMIN', @VoucherID = N'HT/11/14/0001'
CREATE PROCEDURE OP0067
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@VoucherID AS NVARCHAR(50)
) 
AS 
	SELECT	
		OT3001.SOrderID,
		OT3002.DivisionID, OT3002.POrderID, OT3002.TransactionID, OT3001.VoucherTypeID, OT3001.VoucherNo, OT3001.OrderDate, OT3001.InventoryTypeID, AT1301.InventoryTypeName, AT1301.InventoryTypeNameE, IsStocked, OT3001.ObjectID, OT3001.ReceivedAddress, 
		OT3001.ObjectName, AT1202.VATNo, AT1202.[Address], OT3001.EmployeeID,AT1103.FullName AS EmployeeName, 
		AT1103.Tel, AT1103.Fax, AT1103.Email, AT1302.Barcode, OT3002.InventoryID,  OT3002.UnitID, UnitName, OT3002.MethodID, 
		MethodName, OT3002.OrderQuantity, OT3002.PurchasePrice, ConvertedAmount, OriginalAmount, VATConvertedAmount, VATOriginalAmount, 
		OT3002.VATPercent, DiscountConvertedAmount,  DiscountOriginalAmount, DiscountPercent, 
		ISNULL(OriginalAmount, 0) - ISNULL(DiscountOriginalAmount, 0) AS OriginalAmountBeforeVAT, OT3002.ImTaxPercent, OT3002.ImTaxOriginalAmount, OT3002.ImTaxConvertedAmount,
		ISNULL(OriginalAmount, 0) - ISNULL(DiscountOriginalAmount, 0) + ISNULL(OT3002.VATOriginalAmount, 0) +  ISNULL(OT3002.ImTaxOriginalAmount, 0) AS OriginalAmountAfterVAT,
		IsPicking, OT3002.WareHouseID, WareHouseName, 
		Quantity01, Quantity02, Quantity03, Quantity04, Quantity05, Quantity06, Quantity07, Quantity08, Quantity09, Quantity10,
		Quantity11, Quantity12, Quantity13, Quantity14, Quantity15, Quantity16, Quantity17, Quantity18, Quantity19, Quantity20, 
		Quantity21, Quantity22, Quantity23, Quantity24, Quantity25, Quantity26, Quantity27, Quantity28, Quantity29, Quantity30,
		Date01, Date02, Date03, Date04, Date05, Date06, Date07, Date08, Date09, Date10, 
		Date11, Date12, Date13, Date14, Date15, Date16, Date17, Date18, Date19, Date20, 
		Date21, Date22, Date23, Date24, Date25, Date26, Date27, Date28, Date29, Date30, 
		OT3002.Orders, OT3002.[Description] AS [Description], 
		OT3002.Ana01ID AS Ana01ID, OT3002.Ana02ID AS Ana02ID, OT3002.Ana03ID AS Ana03ID, OT3002.Ana04ID AS Ana04ID,	OT3002.Ana05ID AS Ana05ID,
		OT3002.Ana06ID AS Ana06ID, OT3002.Ana07ID AS Ana07ID, OT3002.Ana08ID AS Ana08ID, OT3002.Ana09ID AS Ana09ID, OT3002.Ana10ID AS Ana10ID,
		Ana01.AnaName AS Ana01Name, Ana02.AnaName AS Ana02Name, Ana03.AnaName AS Ana03Name, Ana04.AnaName AS Ana04Name,
		Ana05.AnaName AS Ana05Name, Ana06.AnaName AS Ana06Name,	Ana07.AnaName AS Ana07Name, Ana08.AnaName AS Ana08Name,
		Ana09.AnaName AS Ana09Name, Ana10.AnaName AS Ana10Name,	AT1302.InventoryName AS AInventoryName, 
		AT1302.InventoryName , ActualQuantity, EndQuantity AS RemainQuantity, OT3002.Finish, OT3002.Notes, OT3002.Notes01, 
		Notes03 = (SELECT TOP 1 ObjectID FROM OT3001 WHERE POrderID = OT3002.Notes01), 
		Notes03Name = (	SELECT TOP 1 AT1202.ObjectName FROM OT3001 
						LEFT JOIN AT1202 ON AT1202.ObjectID = OT3001.ObjectID
						WHERE POrderID = OT3002.Notes01), 
		Notes03Date = (SELECT TOP 1 OrderDate FROM OT3001 WHERE POrderID = OT3002.Notes01), 
		Notes03Ana05ID = 
				(
					SELECT TOP 1 Ana05ID FROM OT3002 o
					WHERE o.POrderID =  OT3002.Notes01
					AND o.Notes03 = OT3001.SOrderID
					AND o.InventoryID = OT3002.Notes04
					AND	o.Notes04 = OT3002.InventoryID
					AND o.Ana04ID =	OT3002.Ana04ID
				),
		Notes03Ana05Name = 
				(
					SELECT TOP 1 AT1011.AnaName FROM OT3002 o
					LEFT JOIN AT1011 
						ON AT1011.DivisionID = o.DivisionID 
						AND o.Ana05ID = AT1011.AnaID AND AT1011.AnaTypeID = 'A05'
					WHERE o.POrderID =  OT3002.Notes01
					AND o.Notes03 = OT3001.SOrderID
					AND o.InventoryID = OT3002.Notes04
					AND	o.Notes04 = OT3002.InventoryID
					AND o.Ana04ID =	OT3002.Ana04ID
				),	
		Notes04Name = (SELECT TOP 1 InventoryName FROM AT1302 WHERE InventoryID = OT3002.Notes04),
		OT3002.Notes02,	OT3002.Notes04,	OT3002.Notes05,	OT3002.Notes06,	OT3002.Notes07,	OT3002.Notes08,	OT3002.Notes09,		
		OT3002.RefTransactionID, OT3002.ROrderID, OT3101.ContractNo, OT3002.ConvertedQuantity, OT3002.ConvertedSaleprice,
		OT3002.ShipDate, OT3002.ReceiveDate, OT3002.Parameter01, OT3002.Parameter02, OT3002.Parameter03, OT3002.Parameter04, 
		OT3002.Parameter05,	OT3002.StrParameter01, OT3002.StrParameter02, OT3002.StrParameter03, OT3002.StrParameter04,	
		OT3002.StrParameter05, OT3002.StrParameter06, OT3002.StrParameter07, OT3002.StrParameter08, OT3002.StrParameter09,	
		OT3002.StrParameter10, OT3002.StrParameter11, OT3002.StrParameter12, OT3002.StrParameter13, OT3002.StrParameter14,	
		OT3002.StrParameter15, OT3002.StrParameter16, OT3002.StrParameter17, OT3002.StrParameter18, OT3002.StrParameter19,	
		OT3002.StrParameter20,
		OT3001.Ana01ID AS MAna01ID, SAna01.AnaName AS MAna01Name, SAna01.AnaNameE AS MAna01NameE,
		OT3001.Ana02ID AS MAna02ID, SAna02.AnaName AS MAna02Name, SAna02.AnaNameE AS MAna02NameE,
		OT3001.Ana03ID AS MAna03ID, SAna03.AnaName AS MAna03Name, SAna03.AnaNameE AS MAna03NameE,
		OT3001.Ana04ID AS MAna04ID, SAna04.AnaName AS MAna04Name, SAna04.AnaNameE AS MAna04NameE,
		OT3001.Ana05ID AS MAna05ID, SAna05.AnaName AS MAna05Name, SAna05.AnaNameE AS MAna05NameE,
		OT3001.Ana06ID AS MAna06ID, SAna06.AnaName AS MAna06Name, SAna06.AnaNameE AS MAna06NameE,
		OT3001.Ana07ID AS MAna07ID, SAna07.AnaName AS MAna07Name, SAna07.AnaNameE AS MAna07NameE,
		OT3001.Ana08ID AS MAna08ID, SAna08.AnaName AS MAna08Name, SAna08.AnaNameE AS MAna08NameE,
		OT3001.Ana09ID AS MAna09ID, SAna09.AnaName AS MAna09Name, SAna09.AnaNameE AS MAna09NameE,
		OT3001.Ana10ID AS MAna10ID, SAna10.AnaName AS MAna10Name, SAna10.AnaNameE AS MAna10NameE,
		OT3001.Notes AS MNotes, OT3001.[Description] AS MDescription, OT3001.Transport, OT3001.PaymentID, 
		OT3001.PaymentTermID, OT3001.ShipDate AS MShipDate,OT3001.DueDate, OT3001.IsConfirm, OT3001.DescriptionConfirm,
		OT3001.DeliveryDate, OT3001.IsPrinted, OT3001.Varchar01, OT3001.Varchar02, OT3001.Varchar03, OT3001.Varchar04,
		OT3001.Varchar05, OT3001.Varchar06, OT3001.Varchar07, OT3001.Varchar08, OT3001.Varchar09, OT3001.Varchar10, 
		OT3001.Varchar11, OT3001.Varchar12, OT3001.Varchar13, OT3001.Varchar14, OT3001.Varchar15, OT3001.Varchar16, 
		OT3001.Varchar17, OT3001.Varchar18,	OT3001.Varchar19, OT3001.Varchar20
	FROM OT3002 OT3002
	LEFT JOIN AT1011 Ana01 ON Ana01.DivisionID = OT3002.DivisionID AND OT3002.Ana01ID = Ana01.AnaID AND Ana01.AnaTypeID = 'A01'
	LEFT JOIN AT1011 Ana02 ON Ana02.DivisionID = OT3002.DivisionID AND OT3002.Ana02ID = Ana02.AnaID AND Ana02.AnaTypeID = 'A02'
	LEFT JOIN AT1011 Ana03 ON Ana03.DivisionID = OT3002.DivisionID AND OT3002.Ana03ID = Ana03.AnaID AND Ana03.AnaTypeID = 'A03'
	LEFT JOIN AT1011 Ana04 ON Ana04.DivisionID = OT3002.DivisionID AND OT3002.Ana04ID = Ana04.AnaID AND Ana04.AnaTypeID = 'A04'
	LEFT JOIN AT1011 Ana05 ON Ana05.DivisionID = OT3002.DivisionID AND OT3002.Ana05ID = Ana05.AnaID AND Ana05.AnaTypeID = 'A05'
	LEFT JOIN AT1011 Ana06 ON Ana06.DivisionID = OT3002.DivisionID AND OT3002.Ana06ID = Ana06.AnaID AND Ana06.AnaTypeID = 'A06'
	LEFT JOIN AT1011 Ana07 ON Ana07.DivisionID = OT3002.DivisionID AND OT3002.Ana07ID = Ana07.AnaID AND Ana07.AnaTypeID = 'A07'
	LEFT JOIN AT1011 Ana08 ON Ana08.DivisionID = OT3002.DivisionID AND OT3002.Ana08ID = Ana08.AnaID AND Ana08.AnaTypeID = 'A08'
	LEFT JOIN AT1011 Ana09 ON Ana09.DivisionID = OT3002.DivisionID AND OT3002.Ana09ID = Ana09.AnaID AND Ana09.AnaTypeID = 'A09'
	LEFT JOIN AT1011 Ana10 ON Ana10.DivisionID = OT3002.DivisionID AND OT3002.Ana10ID = Ana10.AnaID AND Ana10.AnaTypeID = 'A10'
	LEFT JOIN AT1302 AT1302 ON AT1302.InventoryID= OT3002.InventoryID AND AT1302.DivisionID = OT3002.DivisionID 
	LEFT JOIN OT1003 OT1003 ON OT1003.MethodID = OT3002.MethodID  AND OT1003.DivisionID = OT3002.DivisionID 
	INNER JOIN OT3001 OT3001 ON OT3001.POrderID = OT3002.POrderID AND OT3001.DivisionID = OT3002.DivisionID 
	LEFT JOIN AT1103 AT1103 ON AT1103.DivisionID = OT3001.DivisionID AND AT1103.EmployeeID = OT3001.EmployeeID
	LEFT JOIN AT1303 AT1303 ON AT1303.WareHouseID = OT3002.WareHouseID AND AT1303.DivisionID = OT3002.DivisionID 
	LEFT JOIN AT1301 AT1301 ON AT1301.InventoryTypeID = OT3001.InventoryTypeID 	 AND AT1301.DivisionID = OT3001.DivisionID 
	LEFT JOIN AT1304 AT1304 ON AT1304.UnitID =OT3002.UnitID AND AT1304.DivisionID = OT3002.DivisionID 
	LEFT JOIN OT3003 OT3003 ON OT3003.POrderID = OT3001.POrderID AND OT3003.DivisionID = OT3001.DivisionID 
	LEFT JOIN OV2902 OV2902 ON OV2902.POrderID = OT3002.POrderID AND OV2902.TransactionID = OT3002.TransactionID
	LEFT JOIN OT3101 OT3101 ON OT3101.RorderID = OT3002.RorderID   AND OT3101.DivisionID = OT3002.DivisionID 
	LEFT JOIN OT1002 SAna01 ON SAna01.DivisionID = OT3001.DivisionID AND OT3001.Ana01ID = SAna01.AnaID AND SAna01.AnaTypeID = 'S01'
	LEFT JOIN OT1002 SAna02 ON SAna02.DivisionID = OT3001.DivisionID AND OT3001.Ana02ID = SAna02.AnaID AND SAna02.AnaTypeID = 'S02'
	LEFT JOIN OT1002 SAna03 ON SAna03.DivisionID = OT3001.DivisionID AND OT3001.Ana03ID = SAna03.AnaID AND SAna03.AnaTypeID = 'S03'
	LEFT JOIN OT1002 SAna04 ON SAna04.DivisionID = OT3001.DivisionID AND OT3001.Ana04ID = SAna04.AnaID AND SAna04.AnaTypeID = 'S04'
	LEFT JOIN OT1002 SAna05 ON SAna05.DivisionID = OT3001.DivisionID AND OT3001.Ana05ID = SAna05.AnaID AND SAna05.AnaTypeID = 'S05'
	LEFT JOIN OT1002 SAna06 ON SAna06.DivisionID = OT3001.DivisionID AND OT3001.Ana06ID = SAna06.AnaID AND SAna06.AnaTypeID = 'S06'
	LEFT JOIN OT1002 SAna07 ON SAna07.DivisionID = OT3001.DivisionID AND OT3001.Ana07ID = SAna07.AnaID AND SAna07.AnaTypeID = 'S07'
	LEFT JOIN OT1002 SAna08 ON SAna08.DivisionID = OT3001.DivisionID AND OT3001.Ana08ID = SAna08.AnaID AND SAna08.AnaTypeID = 'S08'
	LEFT JOIN OT1002 SAna09 ON SAna09.DivisionID = OT3001.DivisionID AND OT3001.Ana09ID = SAna09.AnaID AND SAna09.AnaTypeID = 'S09'
	LEFT JOIN OT1002 SAna10 ON SAna10.DivisionID = OT3001.DivisionID AND OT3001.Ana10ID = SAna10.AnaID AND SAna10.AnaTypeID = 'S10'
	LEFT JOIN AT1202 AT1202 on AT1202.DivisionID = OT3001.DivisionID AND AT1202.ObjectID = OT3001.ObjectID 
	WHERE OT3002.DivisionID = @DivisionID
	AND OT3002.POrderID = @VoucherID 
	AND OT3002.IsPicking <> 1 -- Không load dữ liệu là thầu phụ (phát sinh)
	ORDER BY OT3002.POrderID, OT3002.Orders

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
