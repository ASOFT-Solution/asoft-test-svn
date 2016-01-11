IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0127]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0127]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load danh sách lệnh sản xuất
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 18/06/2015
---- Modified on 07/09/2015 by Bảo Anh: Bổ sung PlanDetailID
-- <Example>
/*
	MP0127 'HD', '', '2015-06-18 10:48:45.120', '2015-06-18 10:48:45.120', 1, 2015, 6, 2015, 0, ''
*/
CREATE PROCEDURE MP0127
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@FromDate DATETIME,
	@ToDate DATETIME,
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@IsDate TINYINT,
	@PlanID VARCHAR(50)	
)
AS
DECLARE @sSQL NVARCHAR(MAX),
		@sWhere NVARCHAR(2000) = ''
IF @IsDate = 0 SET @sWhere = @sWhere + '
AND M21.TranMonth + M21.TranYear * 100 BETWEEN '+STR(@FromMonth + @FromYear * 100)+' AND '+STR(@ToMonth + @ToYear * 100)+''
ELSE SET @sWhere = @sWhere + '
AND CONVERT(VARCHAR, M21.VoucherDate, 112) BETWEEN '''+CONVERT(VARCHAR,@FromDate,112)+''' AND '''+CONVERT(VARCHAR, @ToDate, 112)+''' '

IF @PlanID IS NOT NULL SET @sWhere = @sWhere + '
AND M21.PlanID LIKE ''%'+@PlanID+'%'' '

		
SET @sSQL = '
SELECT M21.APK, M21.VoucherID, M21.VoucherNo, M21.VoucherDate, M01.InventoryID, A02.InventoryName, M01.PlanQuantity,
	M21.EmployeeID, A03.FullName EmployeeName, M21.IsFinish, M21.TranMonth, M21.TranYear, M21.PlanDetailID
FROM MT0121 M21
LEFT JOIN MT0120 M01 ON M01.DivisionID = M21.DivisionID AND M01.PlanDetailID = M21.PlanDetailID
LEFT JOIN AT1302 A02 ON A02.DivisionID = M01.DivisionID AND A02.InventoryID = M01.InventoryID
LEFT JOIN AT1103 A03 ON A03.DivisionID = M21.DivisionID AND A03.EmployeeID = M21.EmployeeID
WHERE M21.DivisionID = '''+@DivisionID+ ''' '+@sWhere+''

EXEC (@sSQL)
--PRINT (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
