IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0063]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0063]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load màn hình kế thừa YCDV Tổng Detail
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 29/09/2014 by Le Thi Thu Hien
---- 
---- Modified on 23/10/2014 by Mai Trí Thiện: Load thêm các trường ghi chú làm thông tin kế thừa từ YCDV
-- <Example>
---- EXEC OP0063 'TBI', 'ADMIN', 'GT/08/14/001'', ''GT/08/14/001'
CREATE PROCEDURE OP0063
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@ListVoucherID AS NVARCHAR(MAX)
)
AS 
DECLARE @sSQL AS NVARCHAR(MAX)
SET @sSQL = '
SELECT	CONVERT (tinyint,1) AS Selected,
		OT2001.SOrderID AS OrderID, OT2001.DivisionID, OT2001.VoucherTypeID, OT2001.VoucherNo,
		OT2001.ObjectID , OT2001.ObjectName, OT2002.Notes01 as Notes02,
      	OT2002.TransactionID, OT2002.InventoryID, AT1302.InventoryName,
      	OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID,
		OT2002.Ana06ID, OT2002.Ana07ID, OT2002.Ana08ID, OT2002.Ana09ID, OT2002.Ana10ID,
		Ana01.AnaName AS Ana01Name,		Ana02.AnaName AS Ana02Name,
		Ana03.AnaName AS Ana03Name,		Ana04.AnaName AS Ana04Name,
		Ana05.AnaName AS Ana05Name,		Ana06.AnaName AS Ana06Name,
		Ana07.AnaName AS Ana07Name,		Ana08.AnaName AS Ana08Name,
		Ana09.AnaName AS Ana09Name,		Ana10.AnaName AS Ana10Name
FROM OT2002 OT2002
INNER JOIN OT2001 OT2001 ON OT2001.DivisionID = OT2002.DivisionID AND OT2001.SOrderID = OT2002.SOrderID
INNER JOIN AT1302 AT1302 ON AT1302.DivisionID = OT2001.DivisionID AND AT1302.InventoryID = OT2002.InventoryID
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
WHERE OT2001.DivisionID = '''+@DivisionID+'''
AND OT2001.SOrderID IN ('''+@ListVoucherID+''')
'
PRINT(@sSQL)
EXEC(@sSQL)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

