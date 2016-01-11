IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0145]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0145]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- In quyết toán tàu-sà lan
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 20/11/2014 Mai Tri Thien: In báo cáo Tàu-Sà lan
---- 
---- Modified on 02/10/2014 by 
-- <Example>
---- EXEC OP0145 'BBL', 'ASOFTADMIN', '2e989049-be34-4acb-8901-3f7954bf7091'

CREATE PROCEDURE OP0145
( 		
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@SOrderID AS NVARCHAR(50)
) 
AS 
DECLARE @sSQL AS NVARCHAR(MAX),
		@sSQL1 AS NVARCHAR(MAX),
		@sSQL2 AS NVARCHAR(MAX),
		@sWhere AS NVARCHAR(MAX)

		SET @sSQL = N'
		SELECT
			OT2011.APK, OT2011.DivisionID, OT2011.SOrderID, OT2011.InventoryID, AT1302.InventoryName, 
			OT2011.UnitID, AT1304.UnitName, OT2011.OriginalQuantity, OT2011.UnitPrice, OT2011.ConvertedPrice,
			OT2011.OriginalAmount, OT2011.VATPercent, OT2011.VATOriginalAmount, OT2011.TotalAmount, 
			OT2011.Notes01, OT2011.Notes02, OT2011.Notes03, OT2011.Notes04, OT2011.Notes05, 
			OT2011.Notes06, OT2011.Notes07, OT2011.Notes08, OT2011.Notes09, OT2011.Notes10,
			OT2011.Ana01ID, OT2011.Ana02ID, OT2011.Ana03ID, OT2011.Ana04ID, OT2011.Ana05ID, 
			OT2011.Ana06ID, OT2011.Ana07ID, OT2011.Ana08ID, OT2011.Ana09ID, OT2011.Ana10ID,
			Ana01.AnaName AS Ana01Name,
			Ana02.AnaName AS Ana02Name,
			Ana03.AnaName AS Ana03Name,
			Ana04.AnaName AS Ana04Name,
			Ana05.AnaName AS Ana05Name,
			Ana06.AnaName AS Ana06Name,
			Ana07.AnaName AS Ana07Name,
			Ana08.AnaName AS Ana08Name,
			Ana09.AnaName AS Ana09Name,
			Ana10.AnaName AS Ana10Name,
			OT2011.CreateDate, OT2011.CreateUserID, OT2011.LastModifyDate, OT2011.LastModifyUserID,
			OT10.Ana01ID AS SAna01ID, SAna01.AnaName AS SAna01Name,
			OT10.Ana02ID AS SAna02ID, SAna02.AnaName AS SAna02Name,
			OT10.Ana03ID AS SAna03ID, SAna03.AnaName AS SAna03Name,
			OT10.Ana04ID AS SAna04ID, SAna04.AnaName AS SAna04Name,
			OT10.Ana05ID AS SAna05ID, SAna05.AnaName AS SAna05Name,
			OT10.ArrivedTime, OT10.DepartureTime, OT10.BerthedTime, 
			OT10.AlongsideFrom, OT10.AlongsideTo, OT10.AlongsideTime,
			OT10.PenaltyFrom, OT10.PenaltyTo, OT10.PenaltyTime, 
			OT10.Notes, OT10.ObjectID, AT12020.ObjectName,
			OT10.ShipID, AT12022.ObjectName AS ShipName, AT12021.ObjectTypeID AS ShipTypeID, AT12022.LegalCapital as GRT, OT10.ReceiverID, 
			AT12021.ObjectName AS ReceiverName, OT10.CurrencyID, OT10.ExchangeRate, OT10.VoucherNo, OT10.VoucherDate, 
			OT10.VoucherTypeID, OT10.TranMonth, OT10.TranYear, OT10.IsPrinted, 
			OT10.OrderStatus, OV1101.[Description] AS OrderStatusName, OV1101.EDescription AS OrderStatusNameE,
			AT12020.[Address], AT12020.VATNo, AT12020.Phonenumber, AT12020.Contactor, AT1201.ObjectTypeName AS ShipTypeName'
			
		SET @sSQL1 = N'
		FROM OT2011
			LEFT JOIN OT2010 OT10 ON OT10.SOrderID = OT2011.SOrderID AND OT10.DivisionID = OT2011.DivisionID
			LEFT JOIN AT1011 Ana01 ON Ana01.DivisionID = OT2011.DivisionID AND OT2011.Ana01ID = Ana01.AnaID AND Ana01.AnaTypeID = ''A01''
			LEFT JOIN AT1011 Ana02 ON Ana02.DivisionID = OT2011.DivisionID AND OT2011.Ana02ID = Ana02.AnaID AND Ana02.AnaTypeID = ''A02''
			LEFT JOIN AT1011 Ana03 ON Ana03.DivisionID = OT2011.DivisionID AND OT2011.Ana03ID = Ana03.AnaID AND Ana03.AnaTypeID = ''A03''
			LEFT JOIN AT1011 Ana04 ON Ana04.DivisionID = OT2011.DivisionID AND OT2011.Ana04ID = Ana04.AnaID AND Ana04.AnaTypeID = ''A04''
			LEFT JOIN AT1011 Ana05 ON Ana05.DivisionID = OT2011.DivisionID AND OT2011.Ana05ID = Ana05.AnaID AND Ana05.AnaTypeID = ''A05''
			LEFT JOIN AT1011 Ana06 ON Ana06.DivisionID = OT2011.DivisionID AND OT2011.Ana06ID = Ana06.AnaID AND Ana06.AnaTypeID = ''A06''
			LEFT JOIN AT1011 Ana07 ON Ana07.DivisionID = OT2011.DivisionID AND OT2011.Ana07ID = Ana07.AnaID AND Ana07.AnaTypeID = ''A07''
			LEFT JOIN AT1011 Ana08 ON Ana08.DivisionID = OT2011.DivisionID AND OT2011.Ana08ID = Ana08.AnaID AND Ana08.AnaTypeID = ''A08''
			LEFT JOIN AT1011 Ana09 ON Ana09.DivisionID = OT2011.DivisionID AND OT2011.Ana09ID = Ana09.AnaID AND Ana09.AnaTypeID = ''A09''
			LEFT JOIN AT1011 Ana10 ON Ana10.DivisionID = OT2011.DivisionID AND OT2011.Ana10ID = Ana10.AnaID AND Ana10.AnaTypeID = ''A10''
			LEFT JOIN OT1002 SAna01 ON SAna01.DivisionID = OT2011.DivisionID AND OT2011.Ana01ID = SAna01.AnaID AND SAna01.AnaTypeID = ''S01''
			LEFT JOIN OT1002 SAna02 ON SAna02.DivisionID = OT2011.DivisionID AND OT2011.Ana02ID = SAna02.AnaID AND SAna02.AnaTypeID = ''S02''
			LEFT JOIN OT1002 SAna03 ON SAna03.DivisionID = OT2011.DivisionID AND OT2011.Ana03ID = SAna03.AnaID AND SAna03.AnaTypeID = ''S03''
			LEFT JOIN OT1002 SAna04 ON SAna04.DivisionID = OT2011.DivisionID AND OT2011.Ana04ID = SAna04.AnaID AND SAna04.AnaTypeID = ''S04''
			LEFT JOIN OT1002 SAna05 ON SAna05.DivisionID = OT2011.DivisionID AND OT2011.Ana05ID = SAna05.AnaID AND SAna05.AnaTypeID = ''S05''
			LEFT JOIN AT1302 AT1302 ON AT1302.DivisionID = OT2011.DivisionID AND AT1302.InventoryID = OT2011.InventoryID
			LEFT JOIN AT1202 AT12020 ON AT12020.DivisionID = OT10.DivisionID AND AT12020.ObjectID = OT10.ObjectID
			LEFT JOIN AT1202 AT12021 ON AT12021.DivisionID = OT10.DivisionID AND AT12021.ObjectID = OT10.ReceiverID
			LEFT JOIN AT1202 AT12022 ON AT12022.DivisionID = OT10.DivisionID AND AT12022.ObjectID = OT10.ShipID
			LEFT JOIN AT1201 AT1201 ON AT1201.DivisionID = AT12022.DivisionID AND AT1201.ObjectTypeID = AT12022.ObjectTypeID
			LEFT JOIN OV1101 OV1101 ON OV1101.DivisionID = OT10.DivisionID AND OV1101.OrderStatus = OT10.OrderStatus AND TypeID = ''OP''
			LEFT JOIN AT1304 ON AT1304.DivisionID = OT2011.DivisionID AND AT1304.UnitID = OT2011.UnitID
		WHERE 
			OT2011.DivisionID = ''' + @DivisionID + '''
			AND OT2011.SOrderID = ''' + @SOrderID + '''
		'
		
		PRINT(@sSQL)
		PRINT(@sSQL1)
		EXEC(@sSQL+ @sSQL1)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
