IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0119_1]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0119_1]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load Grid danh mục đơn hàng sản xuất MF0119
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by:Thanh Sơn  on: 06/03/2015
---- Modified on 
-- <Example>
/*
	 MP0119_1 'PL', 'ASOFTADMIN', 1,2015,1,2015, '2015-03-06 09:19:01.983','2015-03-06 09:19:01.983',0
*/

 CREATE PROCEDURE MP0119_1
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsDate TINYINT
)
AS
DECLARE @sSQL NVARCHAR(MAX),
		@sWhere NVARCHAR(1000)
		
IF @IsDate = 0 SET @sWhere = 'AND O21.TranMonth + O21.TranYear * 100 BETWEEN '+STR(@FromMonth + @FromYear * 100)+' AND '+STR(@ToMonth + @ToYear * 100)+''
ELSE SET @sWhere = 'AND CONVERT(VARCHAR, O21.OrderDate, 112) BETWEEN '''+CONVERT(VARCHAR, @FromDate, 112)+''' AND '''+CONVERT(VARCHAR, @ToDate, 112)+''''

SET @sSQL = '
SELECT O21.DivisionID, O21.SOrderID, O21.VoucherNo, O21.OrderDate, O21.ObjectID, A02.ObjectName, O21.Notes
FROM OT2001 O21
LEFT JOIN AT1202 A02 ON A02.DivisionID = O21.DivisionID AND A02.ObjectID = O21.ObjectID
WHERE O21.DivisionID = '''+@DivisionID+'''
AND OrderType = 1
'+@sWhere+'
--AND O21.SOrderID NOT IN (select đơn hàng sản xuất đã lên kế hoạch tổng thể rồi)
'

EXEC (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
