IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0105_1]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[WP0105_1]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load danh sách kế lệnh sản xuất cho màn hình kế thừa phiếu xuất kho từ lệnh sản xuất
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: on:
---- Modified on 
-- <Example>
/*
	WP0105_1 'DNP', '',1,2015, 12,2015, '2015-06-05 11:10:23.323', '2015-06-05 11:10:23.323', 0,NULL,'2222'
*/
CREATE PROCEDURE WP0105_1
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsDate TINYINT,
	@ObjectID VARCHAR(50),
	@VoucherNo NVARCHAR(50)
)
AS
DECLARE @sSQL NVARCHAR(MAX), @sWhere NVARCHAR(1000) = ''

IF @IsDate = 1 SET @sWhere = '
AND CONVERT(VARCHAR,M21.VoucherDate, 112) BETWEEN '''+CONVERT(VARCHAR,@FromDate,112)+''' AND '''+CONVERT(VARCHAR,@ToDate,112)+''''
ELSE SET @sWhere = '
AND M21.TranMonth + M21.TranYear * 100 BETWEEN '+STR(@FromMonth + @FromYear * 100)+' AND '+STR(@ToMonth + @ToYear * 100)+''

SET @sSQL = '
SELECT M21.VoucherID, M21.VoucherNo, M21.VoucherDate, M21.PlanID, M01.VoucherNo PlanNo, O01.ObjectID,
	A02.ObjectName, M21.Description
FROM MT0121 M21
	LEFT JOIN MT2001 M01 ON M01.DivisionID = M21.DivisionID AND M01.PlanID = M21.PlanID
	LEFT JOIN OT2001 O01 ON O01.DivisionID = M01.DivisionID AND O01.SOrderID = M01.SOderID
	LEFT JOIN AT1202 A02 ON A02.DivisionID = O01.DivisionID AND A02.ObjectID = O01.ObjectID
WHERE M21.DivisionID = '''+@DivisionID+'''
AND O01.ObjectID LIKE '''+ISNULL(@ObjectID,'%')+''' 
AND M21.VoucherNo LIKE N''%'+ISNULL(@VoucherNo,'%')+'%'' '+@sWhere+'
'
EXEC (@sSQL)
PRINT (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
