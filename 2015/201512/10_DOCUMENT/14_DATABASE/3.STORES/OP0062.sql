IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0062]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0062]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load màn hình kế thừa YCDV Tổng master
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 29/09/2014 by Le Thi Thu Hien
---- 
---- Modified on 29/09/2014 by 
-- <Example>
---- EXEC OP0062 'TBI', 'ADMIN', 0, 201401, 201412, '2014-08-29 00:00:00', '2014-08-29 00:00:00'
CREATE PROCEDURE OP0062
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@Mode AS TINYINT,
	@FromPeriod AS INT,
	@ToPeriod AS INT,
	@FromDate AS DATETIME,
	@ToDate AS DATETIME
)
AS 
DECLARE @sSQL AS NVARCHAR(MAX)
DECLARE @sWhere AS NVARCHAR(MAX)
SET @sSQL = '
SELECT	CONVERT(bit,0) AS Selected,
		OT2001.SOrderID AS OrderID, OT2001.DivisionID, OT2001.VoucherTypeID, OT2001.VoucherNo,
      	OT2001.InventoryTypeID, OT2001.CurrencyID, OT2001.ExchangeRate,
      	OT2001.ObjectID, OT2001.Notes, OT2001.OrderDate,
      	OT2001.TranMonth, OT2001.TranYear, OT2001.ObjectName, OT2001.Transport,
      	OT2001.CreateUserID, OT2001.Createdate, OT2001.LastModifyUserID,
      	OT2001.LastModifyDate
FROM OT2001 OT2001
WHERE OT2001.DivisionID = '''+@DivisionID+'''
AND OT2001.OrderStatus <3 -- Hoàn tất
'
IF @Mode = 1 
SET @sWhere = '
AND OT2001.TranYear*100+OT2001.TranMonth >= '+STR(@FromPeriod)+'
AND OT2001.TranYear*100+OT2001.TranMonth <= '+STR(@ToPeriod)+'
'
IF @Mode = 0
SET @sWhere = '
AND OT2001.OrderDate  BETWEEN '''+Convert(nvarchar(10),@FromDate,21)+''' and '''+convert(nvarchar(10), @ToDate,21)+'''
'
PRINT(@sSQL)
PRINT(@sWhere)
EXEC(@sSQL+@sWhere)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

