IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0045]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0045]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Dữ liệu cho màn hình OF0139 - Danh mục quyết toán đơn hàng[Customize ABA]
-- <History>
---- Create on 22/04/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
OP0045 @DivisionID = 'VG', @FromMonth = 11, @FromYear = 2014, @ToMonth = 1, @ToYear = 2015, 
       @FromDate = '2014-11-02 14:39:51.283', @ToDate = '2014-12-02 14:39:51.283', @IsDate = 0, 
       @ObjectID = '%', @SettleType = '1'
 */

CREATE PROCEDURE [dbo].[OP0045] 	
	@DivisionID NVARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsDate TINYINT, -- = 1: search theo ngày
	@ObjectID NVARCHAR(50),
	@SettleType NVARCHAR(50) --1: Đơn hàng mua, 0: đơn hàng bán, '%' TẤT CẢ
AS
DECLARE @sSQL1 NVARCHAR(MAX),
        @sWHERE NVARCHAR(MAX),
        @Settle0 NVARCHAR(100),
        @Settle1 NVARCHAR(100)
		
SET @sWHERE = ''
SET @Settle0 = N'Quyết toán đơn hàng bán'
SET @Settle1 = N'Quyết toán đơn hàng mua'
IF @ObjectID IS NOT NULL OR @ObjectID != ''
SET @sWHERE = @sWHERE + 'AND ISNULL(OT40.ObjectID,'''') LIKE '''+@ObjectID+''' '
IF LTRIM(STR(@IsDate)) = 1	SET @sWHERE = @sWHERE + '
	  AND CONVERT(VARCHAR(10),OT40.VoucherDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
IF LTRIM(STR(@IsDate)) = 0	SET @sWHERE = @sWHERE + '
	  AND (OT40.TranYear*12 + OT40.TranMonth) BETWEEN '+LTRIM(STR(@FromYear*12 + @FromMonth))+' AND '+LTRIM(STR(@ToYear*12 + @ToMonth))+' '
SET @sSQL1 = '
SELECT OT40.VoucherID, OT40.VoucherTypeID, OT40.VoucherNo, OT40.VoucherDate,
       OT40.EmployeeID, OT40.ObjectID, AT12.ObjectName, OT40.SettleType,
       OT40.[Description], OT40.TranMonth, OT40.TranYear,
       CASE WHEN ISNULL(OT40.SettleType,0) = 0 THEN N'''+@Settle0+'''
			WHEN ISNULL(OT40.SettleType,0) = 1 THEN N'''+@Settle1+'''
			ELSE '''' END AS SettleTypeName
FROM OT0140 OT40
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT40.DivisionID AND AT12.ObjectID = OT40.ObjectID 
WHERE OT40.DivisionID = '''+@DivisionID+''' 
	--AND ISNULL(OT40.SettleType,0) LIKE ISNULL('''+@SettleType+''',0)
      '+@sWHERE+'
ORDER BY OT40.VoucherDate, VoucherNo
'	
EXEC (@sSQL1)
--PRINT(@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
