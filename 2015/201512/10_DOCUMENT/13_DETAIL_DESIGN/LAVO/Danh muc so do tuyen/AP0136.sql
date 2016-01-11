IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0136]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0136]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Sơ đồ tuyến View/Edit dữ liệu Detail - CF0135-6 [Customize LAVO]
-- <History>
---- Create on 04/12/2014 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/* 
AP0136 @DivisionID ='CTY', @RouteID = '01'
 */
CREATE PROCEDURE [dbo].[AP0136] 	
	@DivisionID NVARCHAR(50),
	@RouteID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX)
SET @RouteID = ISNULL(@RouteID,'')
-- Load dữ liệu cho lưới thông tin giao hàng
SET @sSQL1 = '
SELECT CASE WHEN AT36.StationID IN (
			SELECT OT21.StationID
			FROM OT2001 OT21
			WHERE OT21.DivisionID = '''+@DivisionID+''' AND OT21.RouteID = '''+@RouteID+''' AND OT21.OrderType = 0 )
			THEN CONVERT (TINYINT,1) ELSE CONVERT(TINYINT,0) END AS [IsUsed],
	   AT36.RouteID,  AT36.TransactionID, AT36.StationOrder, AT36.StationID, AT33.StationName, AT33.[Address], AT33.Street,
       AT33.Ward, AT33.District, AT36.Notes       	      
FROM AT0136 AT36
LEFT JOIN AT0133 AT33 ON AT33.DivisionID = AT36.DivisionID AND AT33.StationID = AT36.StationID
WHERE AT36.DivisionID = '''+@DivisionID+''' AND AT36.RouteID = '''+@RouteID+'''
ORDER BY AT36.StationOrder
	'
EXEC (@sSQL1)
--PRINT (@sSQL1)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
