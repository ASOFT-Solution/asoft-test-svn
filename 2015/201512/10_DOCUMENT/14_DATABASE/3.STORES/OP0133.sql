IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0133]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0133]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load danh sách xác nhận hoàn thành
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
	Exec OP0133 'BBL', 201410, 201411, '2014-11-23 00:00:00.000', '2014-11-23 00:00:00.000', 0, 'DF', 'D'
*/
---- 

CREATE PROCEDURE [DBO].[OP0133]
(
	@DivisionID AS NVARCHAR(50), --- Đơn vị
	@FromPeriod AS INT, --- Từ kỳ
	@ToPeriod AS INT, --- Đến kỳ
	@FromDate AS DATETIME, --- Từ ngày
	@ToDate AS DATETIME, --- Đến ngày
	@IsDate AS TINYINT, --- 1: theo ngày, 0: theo kỳ
	@SOrderID AS NVARCHAR(50), --- Số YCDV
	@ObjectID AS NVARCHAR(50), --- Đối tượng
	@Notes AS NVARCHAR(250) --- Lô
)
AS

BEGIN
	DECLARE
		@SQL AS NVARCHAR(MAX),
		@SQL1 AS NVARCHAR(MAX),
		@WHERE AS NVARCHAR(MAX),
		@ORDERS AS NVARCHAR(MAX)

		--- Thời gian
		IF @IsDate = 1 
			SET @WHERE = N'
			AND CONVERT(VARCHAR, OT3001.OrderDate, 112)  BETWEEN ''' + CONVERT(NVARCHAR,@FromDate,112) + ''' AND ''' + CONVERT(NVARCHAR, @ToDate,112) + '''
			'
		ELSE
			SET @WHERE = N'
			AND OT3001.TranYear*100 + OT3001.TranMonth >= ' + STR(@FromPeriod) + '
			AND OT3001.TranYear*100 + OT3001.TranMonth <= ' + STR(@ToPeriod) + '
			'

		--- YCDV
		IF @SOrderID <> '' OR @SOrderID <> '%' --- Nếu có Số YCDV
			BEGIN
				SET @WHERE = @WHERE + N'
				AND OT3001.SOrderID LIKE N''' + @SOrderID + '''
				'
				IF @ObjectID <> ''
				SET @WHERE = @WHERE + N'
				AND OT3001.ObjectID LIKE N''' + @ObjectID + '''
				'
			END
		ELSE
			BEGIN
				SET @WHERE = @WHERE + N'
				AND OT3001.ObjectID LIKE N''' + @ObjectID + '''
				'
			END

		SET @SQL = N'
			SELECT CONVERT(bit,0) AS Selected,
				OT3001.DivisionID, OT3001.POrderID, OT3001.VoucherTypeID, OT3001.VoucherNo,
				OT3001.InventoryTypeID, OT3001.ObjectID, AT1202.ObjectName, OT3001.[Description],
				OT3001.OrderStatus, OT3001.TranMonth, OT3001.TranYear, OT3001.EmployeeID, OT3001.OrderDate,
				OT3001.SOrderID, Notes = (SELECT TOP 1 Notes02 FROM OT3002 WHERE OT3002.POrderID = OT3001.POrderID)
			FROM OT3001 OT3001
			LEFT JOIN AT1202 AT1202
			ON AT1202.DivisionID = OT3001.DivisionID AND AT1202.ObjectID = OT3001.ObjectID
			WHERE OT3001.KindVoucherID = 2 --- Xac nhan hoan thanh
			AND OT3001.DivisionID = ''' + @DivisionID + '''
			AND (	SELECT COUNT(Finish) 
					FROM OT3002 
					WHERE DivisionID = OT3001.DivisionID AND POrderID = OT3001.POrderID 
					AND ISNULL(Finish, 0) = 0
					AND ISNULL(IsPicking, 0) = 0
					AND ReceiveDate IS NOT NULL
					AND ISNULL(Notes01, '''') = '''') > 0
		'

		SET @ORDERS = N'
		ORDER BY OT3001.SOrderID, OT3001.ObjectID, OT3001.POrderID, OT3001.OrderDate
		'
		
		--- Tìm theo lô
		IF @Notes <> ''
		BEGIN
			SET @SQL1 = N'
				SELECT A.*
				FROM (' 
					+ @SQL + @WHERE + 
				') A
				WHERE ISNULL(Notes, '''') LIKE ''' + @Notes + '''
			'
			
			SET @ORDERS = N'
				ORDER BY A.SOrderID, A.ObjectID, A.POrderID, A.OrderDate
			'
			
			EXEC(@SQL1 + @ORDERS)
			PRINT (@SQL1 + @ORDERS)
		END
		ELSE
		BEGIN
			EXEC(@SQL + @WHERE + @ORDERS)
			PRINT (@SQL + @WHERE + @ORDERS)
		END
		
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
