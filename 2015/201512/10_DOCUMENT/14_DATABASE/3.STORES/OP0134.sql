IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0134]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0134]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load danh sách chi tiết xác nhận hoàn thành
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 24/10/2014 Trí Thiện
---- 
---- Modified on
-- <Example>
---- 
/* 
	Exec OP0134 'BBL',201410, 201411, '2014-11-23 00:00:00.000', '2014-11-23 00:00:00.000', 0, 'CT/11/2014/0005'', ''HT/11/14/0001', ''
*/
---- 

CREATE PROCEDURE [DBO].[OP0134]
(
	@DivisionID AS NVARCHAR(50), --- Đơn vị
	@FromPeriod AS INT, --- Từ kỳ
	@ToPeriod AS INT, --- Đến kỳ
	@FromDate AS DATETIME, --- Từ ngày
	@ToDate AS DATETIME, --- Đến ngày
	@IsDate AS TINYINT, --- 1: theo ngày, 0: theo kỳ
	@POrderIDs AS NVARCHAR(MAX), --- Danh sách mã xác nhận
	@Notes AS NVARCHAR(50) --- Mã kiểm soát
)
AS

BEGIN
	DECLARE
		@SQL AS NVARCHAR(MAX),
		@WHERE AS NVARCHAR(MAX),
		@BeginDate AS DATETIME,
		@EndDate AS DATETIME

		SET @SQL = N''
		SET @WHERE = N''
		
		IF @IsDate = 1 
			SET @WHERE = N'
			AND CONVERT(VARCHAR, OT3002.ReceiveDate, 112) BETWEEN ''' + CONVERT(NVARCHAR,@FromDate,112) + ''' AND ''' + CONVERT(NVARCHAR, @ToDate,112) + '''
			'
		ELSE
		BEGIN
			--- Lấy ngày bắt đầu và kết thúc theo kỳ được chọn
			SELECT @BeginDate = MIN(BeginDate), @EndDate = MAX(EndDate)
			FROM OT9999
			WHERE 
				TranYear*100 + TranMonth >= @FromPeriod
			AND TranYear*100 + TranMonth <= @ToPeriod

			SET @WHERE = N'
			AND CONVERT(VARCHAR, OT3002.ReceiveDate, 112) BETWEEN ''' + CONVERT(NVARCHAR,@BeginDate,112) + ''' AND ''' + CONVERT(NVARCHAR, @EndDate,112) + '''
			'
		END

		SET @SQL = N'
			SELECT CONVERT(TINYINT,0) AS Selected,
				OT3002.DivisionID, OT3002.POrderID, OT3001.VoucherNo,
				OT3002.InventoryID, AT1302.InventoryName, OT3002.Notes01, OT3002.Notes02, 
				Notes03 = (	SELECT TOP 1 AT1202.ObjectName
							FROM OT3001
							LEFT JOIN AT1202
								ON AT1202.ObjectID = OT3001.ObjectID
		      				WHERE OT3001.POrderID = OT3002.Notes01),
				Notes04 = (	SELECT TOP 1 AT1302.InventoryName
		      				FROM AT1302
		      				WHERE AT1302.InventoryID = OT3002.Notes04),
				OT3002.UnitID, OT3002.ReceiveDate, OT3002.OrderQuantity,
				OT3001.SOrderID, OT3001.ObjectID, AT1202.ObjectName, OT3002.TransactionID,
				OT3002.Ana01ID, OT3002.Ana02ID, OT3002.Ana03ID, OT3002.Ana04ID, OT3002.Ana05ID, 
				OT3002.Ana06ID, OT3002.Ana07ID, OT3002.Ana08ID, OT3002.Ana09ID, OT3002.Ana10ID,
				ANA01.AnaName AS Ana01Name,
				ANA02.AnaName AS Ana02Name,
				ANA03.AnaName AS Ana03Name,
				ANA04.AnaName AS Ana04Name,
				ANA05.AnaName AS Ana05Name,
				ANA06.AnaName AS Ana06Name,
				ANA07.AnaName AS Ana07Name,
				ANA08.AnaName AS Ana08Name,
				ANA09.AnaName AS Ana09Name,
				ANA10.AnaName AS Ana10Name
			FROM OT3002 OT3002
			INNER JOIN OT3001 OT3001
			ON OT3001.DivisionID = OT3002.DivisionID AND OT3001.POrderID = OT3002.POrderID
			LEFT JOIN AT1202 AT1202
			ON AT1202.DivisionID = OT3002.DivisionID AND AT1202.ObjectID = OT3001.ObjectID
			LEFT JOIN AT1302 AT1302
			ON AT1302.DivisionID = OT3002.DivisionID AND AT1302.InventoryID = OT3002.InventoryID
			LEFT JOIN AT1011 ANA01
			ON ANA01.DivisionID = OT3002.DivisionID AND ANA01.AnaID = OT3002.Ana01ID AND ANA01.AnaTypeID = ''A01''
			LEFT JOIN AT1011 ANA02
			ON ANA02.DivisionID = OT3002.DivisionID AND ANA02.AnaID = OT3002.Ana02ID AND ANA02.AnaTypeID = ''A02''
			LEFT JOIN AT1011 ANA03
			ON ANA03.DivisionID = OT3002.DivisionID AND ANA03.AnaID = OT3002.Ana03ID AND ANA03.AnaTypeID = ''A03''
			LEFT JOIN AT1011 ANA04
			ON ANA04.DivisionID = OT3002.DivisionID AND ANA04.AnaID = OT3002.Ana04ID AND ANA04.AnaTypeID = ''A04''
			LEFT JOIN AT1011 ANA05
			ON ANA05.DivisionID = OT3002.DivisionID AND ANA05.AnaID = OT3002.Ana05ID AND ANA05.AnaTypeID = ''A05''
			LEFT JOIN AT1011 ANA06
			ON ANA06.DivisionID = OT3002.DivisionID AND ANA06.AnaID = OT3002.Ana06ID AND ANA06.AnaTypeID = ''A06''
			LEFT JOIN AT1011 ANA07
			ON ANA07.DivisionID = OT3002.DivisionID AND ANA07.AnaID = OT3002.Ana07ID AND ANA07.AnaTypeID = ''A07''
			LEFT JOIN AT1011 ANA08
			ON ANA08.DivisionID = OT3002.DivisionID AND ANA08.AnaID = OT3002.Ana08ID AND ANA08.AnaTypeID = ''A08''
			LEFT JOIN AT1011 ANA09
			ON ANA09.DivisionID = OT3002.DivisionID AND ANA09.AnaID = OT3002.Ana09ID AND ANA09.AnaTypeID = ''A09''
			LEFT JOIN AT1011 ANA10
			ON ANA10.DivisionID = OT3002.DivisionID AND ANA10.AnaID = OT3002.Ana10ID AND ANA10.AnaTypeID = ''A10''
			WHERE 
				OT3002.POrderID IN (''' + @POrderIDs + ''')
			AND OT3001.KindVoucherID = 2 --- Xac nhan hoan thanh
			AND OT3002.DivisionID = ''' + @DivisionID + '''
			AND ISNULL(OT3002.Notes02, '''') LIKE N''%' + @Notes + '%''
			AND ISNULL(OT3002.Finish, 0) = 0 --- Cac phieu chua quyet toan
			AND ISNULL(OT3002.IsPicking, 0) = 0 --- Khong phai la thau phu (khong phat sinh)
			AND OT3002.TransactionID NOT IN (SELECT RefTransactionID FROM OT3005)
			AND ISNULL(OT3002.Notes01, '''') = ''''
			' + @WHERE + '
			ORDER BY OT3001.SOrderID, OT3001.ObjectID, OT3002.POrderID, OT3002.InventoryID
		'
		
		PRINT (@SQL)
		EXEC (@SQL)
		
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
