IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0136]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0136]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load danh sách quyết toán khách hàng
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
	exec OP0136 @DivisionID=N'BBL',@FromPeriod=201411,@ToPeriod=201411,@FromDate='2014-11-25 00:00:00',@ToDate='2014-11-01 00:00:00',@IsDate=1,@SOrderID=N'%',@ObjectID=N'KH014.0079', @Notes=''
*/
---- 

CREATE PROCEDURE [DBO].[OP0136]
(
	@DivisionID AS NVARCHAR(50), --- Đơn vị
	@FromPeriod AS INT, --- Từ kỳ
	@ToPeriod AS INT, --- Đến kỳ
	@FromDate AS DATETIME, --- Từ ngày
	@ToDate AS DATETIME, --- Đến ngày
	@IsDate AS TINYINT, --- 1: theo ngày, 0: theo kỳ
	@SOrderID AS NVARCHAR(250), --- Số YCDV
	@ObjectID AS NVARCHAR(50), --- Đối tượng
	@Notes AS NVARCHAR(250) --- Lô
)
AS

BEGIN
	DECLARE
		@SQL AS NVARCHAR(MAX),
		@SQL1 AS NVARCHAR(MAX),
		@WHERE AS NVARCHAR(MAX),
		@ORDER AS NVARCHAR(MAX)

		IF @IsDate = 1 
			SET @WHERE = N'
			AND CONVERT(VARCHAR, OT3004.OrderDate, 112) BETWEEN ' + CONVERT(VARCHAR,@FromDate,112) + ' AND ' + CONVERT(VARCHAR, @ToDate,112) + '
			'
		ELSE
			SET @WHERE = N'
			AND OT3004.TranYear*100 + OT3004.TranMonth >= ' + STR(@FromPeriod) + '
			AND OT3004.TranYear*100 + OT3004.TranMonth <= ' + STR(@ToPeriod) + '
			'

		SET @SQL = N'
			SELECT OT3004.APK, OT3004.TranMonth, OT3004.TranYear, OT3004.OrderID, OT3004.VoucherTypeID, OT3004.VoucherNo, 
				OT3004.InventoryTypeID, OT3004.CurrencyID, OT3004.ExchangeRate, OT3004.ObjectID, OT3005.Notes02 as Notes, 
				OT3004.[Description], OT3004.OrderStatus, OT3004.EmployeeID, OT3004.OrderDate, OT3004.IsPrinted, 
				OT3004.Ana01ID, OT3004.Ana02ID, OT3004.Ana03ID, OT3004.Ana04ID, OT3004.Ana05ID, 
				OT3004.Ana06ID, OT3004.Ana07ID, OT3004.Ana08ID, OT3004.Ana09ID, OT3004.Ana10ID,
				OT3004.ReVoucherID, OT3004.DivisionID, AT1202.ObjectName, 
				SUM(OT3005.OriginalAmount) as OriginalAmount,
				SUM(OT3005.VATOriginalAmount) AS VATOriginalAmount, SUM(OT3005.OriginalAmount) + SUM(OT3005.VATOriginalAmount) AS TotalAmount
			FROM OT3004 OT3004
			LEFT JOIN OT3005 OT3005
			ON OT3005.DivisionID = OT3004.DivisionID AND OT3005.OrderID = OT3004.OrderID
			LEFT JOIN AT1202 AT1202 
			ON AT1202.ObjectID = OT3004.ObjectID AND AT1202.DivisionID = OT3004.DivisionID 
			WHERE OT3004.ObjectID LIKE N''' + @ObjectID + '''
			AND OT3004.DivisionID = ''' + @DivisionID + '''
			' + @WHERE + '
			GROUP BY OT3004.APK, OT3004.TranMonth, OT3004.TranYear, OT3004.OrderID, OT3004.VoucherTypeID, OT3004.VoucherNo, 
				OT3004.InventoryTypeID, OT3004.CurrencyID, OT3004.ExchangeRate, OT3004.ObjectID, OT3005.Notes02, 
				OT3004.[Description], OT3004.OrderStatus, OT3004.EmployeeID, OT3004.OrderDate, OT3004.IsPrinted, 
				OT3004.Ana01ID, OT3004.Ana02ID, OT3004.Ana03ID, OT3004.Ana04ID, OT3004.Ana05ID, 
				OT3004.Ana06ID, OT3004.Ana07ID, OT3004.Ana08ID, OT3004.Ana09ID, OT3004.Ana10ID,
				OT3004.ReVoucherID, OT3004.DivisionID, AT1202.ObjectName
		'

		SET @ORDER = N'
			ORDER BY OT3004.VoucherNo
		'
		
		--- Tìm theo lô
		IF @Notes <> ''
		BEGIN
			SET @SQL1 = N'
				SELECT A.*
				FROM (' 
					+ @SQL + 
				') A
				WHERE ISNULL(Notes, '''') LIKE ''' + @Notes + '''
			'
			
			SET @ORDER = N'
				ORDER BY VoucherNo
			'
			
			EXEC(@SQL1 + @ORDER)
			PRINT (@SQL1 + @ORDER)
		END
		ELSE
		BEGIN
			EXEC(@SQL + @ORDER)
			PRINT (@SQL + @ORDER)
		END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
