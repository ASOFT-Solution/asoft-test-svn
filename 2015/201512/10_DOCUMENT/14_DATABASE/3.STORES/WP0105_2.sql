IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0105_2]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[WP0105_2]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load chi tiết lệnh sản xuất cho màn hình kế thừa từ lệnh sản xuất
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 10/06/2015
---- Modified on 
-- <Example>
/*
	WP0105_2 '', '', ''
*/
CREATE PROCEDURE WP0105_2
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@VoucherID NVARCHAR(MAX)
)
AS
DECLARE @sSQL NVARCHAR(MAX), @sWhere NVARCHAR(1000) = ''

IF @VoucherID IS NOT NULL SET @sWhere = 'AND M22.VoucherID IN ('''+@VoucherID+''') '

SET @sSQL = '
SELECT M22.APK, M22.VoucherID, M22.MaterialID InventoryID, A02.InventoryName,
	A02.UnitID, A04.UnitName, M22.Quantity, A03.WareHouseName
FROM MT0122 M22
	LEFT JOIN AT1303 A03 ON A03.DivisionID = M22.DivisionID AND A03.WareHouseID = M22.WareHouseID
	LEFT JOIN AT1302 A02 ON A02.DivisionID = M22.DivisionID AND A02.InventoryID = M22.MaterialID
	LEFT JOIN At1304 A04 ON A04.DivisionID = A02.DivisionID AND A04.UnitID = A02.UnitID
WHERE M22.DivisionID = '''+@DivisionID+''' 
'+@sWhere+''

EXEC (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
