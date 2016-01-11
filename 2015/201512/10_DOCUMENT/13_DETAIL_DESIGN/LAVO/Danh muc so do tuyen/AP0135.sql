IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0135]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0135]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- In báo cáo Sơ đồ tuyến màn hình truy vấn - CF0135 [Customize LAVO]
-- <History>
---- Create on 04/12/2014 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/* 
AP0135 @DivisionID ='CTY', @RouteIDList = '01'',''02'
 */
CREATE PROCEDURE [dbo].[AP0135] 	
	@DivisionID NVARCHAR(50),
	@RouteIDList NVARCHAR(MAX)
AS
DECLARE @sSQL1 NVARCHAR(MAX)
SET @RouteIDList = ISNULL(@RouteIDList,'')
-- Load dữ liệu cho lưới thông tin giao hàng
SET @sSQL1 = '
SELECT AT35.RouteID, AT35.RouteName, AT36.StationOrder, AT47.ObjectID,
       AT02.ObjectName, AT36.StationID, AT0133.StationName, AT0133.[Address], AT36.Notes
FROM AT0135 AT35
INNER JOIN AT0136 AT36 ON AT36.DivisionID = AT35.DivisionID AND AT36.RouteID = AT35.RouteID
LEFT JOIN AT0133 ON AT0133.DivisionID = AT35.DivisionID AND AT0133.StationID = AT36.StationID
LEFT JOIN AT0047 AT47 ON AT47.DivisionID = AT0133.DivisionID AND AT47.StationID = AT0133.StationID
LEFT JOIN AT1202 AT02 ON AT02.DivisionID = AT47.DivisionID AND AT02.ObjectID = AT47.ObjectID
WHERE AT35.DivisionID = '''+@DivisionID+''' AND AT35.RouteID IN ('''+@RouteIDList+''')
ORDER BY AT35.RouteID, AT36.StationOrder, AT36.StationID, AT47.ObjectID
	'
EXEC (@sSQL1)
--PRINT (@sSQL1)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
