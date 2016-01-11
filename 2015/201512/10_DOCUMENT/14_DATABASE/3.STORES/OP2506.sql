IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP2506]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP2506]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load danh mục các kho đang có hàng tồn kho mặt hàng cần tìm
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by:Thanh Sơn on: 03/03/2015
---- Modified on 
-- <Example>
/*
	 OP2506 'PL', '', 1, 2015, 'TPA','123','1=1'
*/

 CREATE PROCEDURE OP2506
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),	
	@TranMonth INT,
	@TranYear INT,
	@InventoryID NVARCHAR(50),
	@ConditionWA NVARCHAR(500),
	@IsUsedConditionWA NVARCHAR(500)
)
AS
DECLARE @sSQL NVARCHAR(1000)

EXEC OP2504_DNP @DivisionID, @TranMonth, @TranYear, @InventoryID

SET @sSQL = '
SELECT OV2504.WareHouseID, A03.WareHouseName, ReadyQuantity FROM OV2504
LEFT JOIN AT1303 A03 ON A03.DivisionID = OV2504.DivisionID AND A03.WareHouseID = OV2504.WareHouseID
WHERE ISNULL(OV2504.WareHouseID, ''#'') IN ('+@ConditionWA+') Or '+@IsUsedConditionWA+''

EXEC (@sSQL)
PRINT (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
