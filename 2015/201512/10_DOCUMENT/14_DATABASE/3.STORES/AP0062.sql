IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0062]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0062]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load danh sách mặt hàng khai thuế
-- <History>
---- Create on 27/05/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/* 
 AP0062 @DivisionID = 'VG', @UserID = '',@TypeID = 1,
 @InventoryIDList = 'NT'',''PJC'',''SAT'',''VHNINO'',''SGOT'',''TT'',''XQKCT'',''XN'',''XQTP'
  */
 
CREATE PROCEDURE [dbo].[AP0062] 	
	@DivisionID NVARCHAR(50),
	@InventoryIDList NVARCHAR(MAX),
	@TypeID TINYINT, --1: Thuế TTĐB mua vào, 2: Thuế tài nguyên
	@UserID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX)
IF ISNULL(@TypeID,0) = 1
SET @sSQL1 = '
SELECT AT13.InventoryID, AT13.InventoryName, AT13.UnitID, AT13.SETID, AT36.SETName, AT36.UnitID AS SETUnitID, 
	   ISNULL(AT36.TaxRate,0) AS SETTaxRate, 1 AS SETConvertedUnit, 0 AS Quantity
FROM AT1302 AT13 
LEFT JOIN AT0136 AT36 ON AT36.DivisionID = AT13.DivisionID AND AT36.SETID = AT13.SETID
WHERE AT13.DivisionID = '''+@DivisionID+''' AND AT13.InventoryID IN ('''+@InventoryIDList+''')
'
IF ISNULL(@TypeID,0) = 2
SET @sSQL1 = '
SELECT AT13.InventoryID, AT13.InventoryName, AT13.UnitID, AT13.NRTClassifyID, AT34.NRTClassifyName, AT34.UnitID AS NRTUnitID, 
	   ISNULL(AT34.TaxRate,0) AS NRTTaxRate, 1 AS NRTConvertedUnit, 0 AS Quantity
FROM AT1302 AT13 
LEFT JOIN AT0134 AT34 ON AT34.DivisionID = AT13.DivisionID AND AT34.NRTClassifyID = AT13.NRTClassifyID
WHERE AT13.DivisionID = '''+@DivisionID+''' AND AT13.InventoryID IN ('''+@InventoryIDList+''')
'
EXEC (@sSQL1)
--PRINT (@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
