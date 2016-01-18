IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CP0143]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[CP0143]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- In báo cáo Sơ đồ tuyến màn hình truy vấn - CF0143 
-- <History>
---- Create on 13/01/2016 by Thị Phượng 
---- Modified on ... by 
-- <Example>
/* 
CP0143 @DivisionID ='CTY', @RouteID = '01'',''02'
 */
CREATE PROCEDURE [dbo].[CP0143] 	
	@DivisionID NVARCHAR(50),
	@RouteID NVARCHAR(MAX),
	@UserID AS VARCHAR(50) = ''
AS
DECLARE @sSQL1 NVARCHAR(MAX)
SET @RouteID = ISNULL(@RouteID,'')
-- Load dữ liệu cho lưới thông tin giao hàng
SET @sSQL1 = '
SELECT CT43.RouteID, CT43.RouteName, CT44.StationOrder, AT02.ObjectID,
       AT02.ObjectName, CT44.StationID, CT41.StationName, CT41.[Address], CT44.Notes
FROM CT0143 CT43
INNER JOIN CT0144 CT44 ON CT44.DivisionID = CT43.DivisionID AND CT44.RouteID = CT43.RouteID
LEFT JOIN CT0141 CT41 ON CT41.DivisionID = CT43.DivisionID AND CT41.StationID = CT44.StationID
LEFT JOIN AT1202 AT02 ON AT02.DivisionID = CT43.DivisionID 
WHERE CT43.DivisionID = '''+@DivisionID+''' AND CT43.RouteID IN ('''+@RouteID+''')
ORDER BY CT43.RouteID, CT44.StationOrder, CT44.StationID, AT02.ObjectID
	'
EXEC (@sSQL1)
--PRINT (@sSQL1)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
