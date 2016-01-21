IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CP0144]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[CP0144]
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[CP0144]    Script Date: 14/01/2016 10:27:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- <Summary>
---- Load Sơ đồ tuyến View/Edit dữ liệu Detail - CF0143-6 
-- <History>
---- Create on 14/01/2016 by Thị Phượng
---- Modified on ... by 
-- <Example>
/* 
CP0144 @DivisionID ='AS', @RouteID = '01'
 */
CREATE PROCEDURE [dbo].[CP0144] 	
	@DivisionID NVARCHAR(50),
	@RouteID NVARCHAR(50),
	@UserID AS VARCHAR(50) = ''
AS
DECLARE @sSQL1 NVARCHAR(MAX)
SET @RouteID = ISNULL(@RouteID,'')
-- Load dữ liệu cho lưới thông tin giao hàng
SET @sSQL1 = '
SELECT CASE WHEN CT44.RouteID IN (
			SELECT OT21.RouteID
			FROM OT2001 OT21
			WHERE OT21.DivisionID = '''+@DivisionID+''' AND OT21.RouteID = '''+@RouteID+''' AND OT21.OrderType = 0 )
			THEN CONVERT (TINYINT,1) ELSE CONVERT(TINYINT,0) END AS [IsUsed],
	   CT44.RouteID,  CT44.TransactionID, CT44.StationOrder, CT44.StationID , CT41.StationName, CT41.[Address], CT41.Street,
       CT41.Ward, CT41.District, CT44.Notes       	      
FROM CT0144 CT44
LEFT JOIN CT0141 CT41 ON CT41.DivisionID = CT44.DivisionID AND CT41.StationID = CT44.StationID
WHERE CT44.DivisionID = '''+@DivisionID+''' AND CT44.RouteID = '''+@RouteID+'''
ORDER BY CT44.StationOrder
	'
EXEC (@sSQL1)
--PRINT (@sSQL1)


GO


