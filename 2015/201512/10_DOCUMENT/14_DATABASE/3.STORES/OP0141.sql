IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0141]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0141]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load chi tiết quyết toán tàu-sà lan
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 20/11/2014 Mai Tri Thien: Truy vấn Tàu-Sà lan
---- 
---- Modified on 02/10/2014 by 
-- <Example>
---- EXEC OP0141 'BBL', 'ASOFTADMIN', 'QT/11/20/2014/0001'

CREATE PROCEDURE OP0141
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
			OT2011.APK, OT2011.DivisionID, SOrderID, OT2011.InventoryID, AT1302.InventoryName, OT2011.UnitID, OriginalQuantity, UnitPrice, ConvertedPrice,
			OriginalAmount, OT2011.VATPercent, VATOriginalAmount, TotalAmount, OT2011.Notes01, OT2011.Notes02, OT2011.Notes03,
			Notes04, Notes05, Notes06, Notes07, Notes08, Notes09, Notes10,
			Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
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
			OT2011.CreateDate, OT2011.CreateUserID, OT2011.LastModifyDate, OT2011.LastModifyUserID
		FROM OT2011
			LEFT JOIN OT1002 Ana01 ON Ana01.DivisionID = OT2011.DivisionID AND OT2011.Ana01ID =Ana01.AnaID AND Ana01.AnaTypeID = ''A01''
			LEFT JOIN OT1002 Ana02 ON Ana02.DivisionID = OT2011.DivisionID AND OT2011.Ana02ID =Ana02.AnaID AND Ana02.AnaTypeID = ''A02''
			LEFT JOIN OT1002 Ana03 ON Ana03.DivisionID = OT2011.DivisionID AND OT2011.Ana03ID =Ana03.AnaID AND Ana03.AnaTypeID = ''A03''
			LEFT JOIN OT1002 Ana04 ON Ana04.DivisionID = OT2011.DivisionID AND OT2011.Ana04ID =Ana04.AnaID AND Ana04.AnaTypeID = ''A04''
			LEFT JOIN OT1002 Ana05 ON Ana05.DivisionID = OT2011.DivisionID AND OT2011.Ana05ID =Ana05.AnaID AND Ana05.AnaTypeID = ''A05''
			LEFT JOIN OT1002 Ana06 ON Ana06.DivisionID = OT2011.DivisionID AND OT2011.Ana06ID =Ana06.AnaID AND Ana06.AnaTypeID = ''A06''
			LEFT JOIN OT1002 Ana07 ON Ana07.DivisionID = OT2011.DivisionID AND OT2011.Ana07ID =Ana07.AnaID AND Ana07.AnaTypeID = ''A07''
			LEFT JOIN OT1002 Ana08 ON Ana08.DivisionID = OT2011.DivisionID AND OT2011.Ana08ID =Ana08.AnaID AND Ana08.AnaTypeID = ''A08''
			LEFT JOIN OT1002 Ana09 ON Ana09.DivisionID = OT2011.DivisionID AND OT2011.Ana09ID =Ana09.AnaID AND Ana09.AnaTypeID = ''A09''
			LEFT JOIN OT1002 Ana10 ON Ana10.DivisionID = OT2011.DivisionID AND OT2011.Ana10ID =Ana10.AnaID AND Ana10.AnaTypeID = ''A10''
			LEFT JOIN AT1302 AT1302 ON AT1302.DivisionID = OT2011.DivisionID AND AT1302.InventoryID = OT2011.InventoryID
		WHERE 
			OT2011.DivisionID = ''' + @DivisionID + '''
			AND OT2011.SOrderID = ''' + @SOrderID + '''
		ORDER BY OT2011.Orders
		'
		
		EXEC(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
