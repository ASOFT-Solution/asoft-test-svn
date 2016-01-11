IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0140]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0140]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load danh sách quyết toán tàu-sà lan
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 20/11/2014 Mai Tri Thien: Truy vấn Tàu-Sà lan
---- 
---- Modified on 02/10/2014 by 
-- <Example>
---- EXEC OP0140 'BBL', 'ASOFTADMIN', 10, 2014, 10, 2014, '2014-11-20 11:37:25.447', '2014-11-20 11:37:25.447', 1, 'KH0001', 'KH0001', 1

CREATE PROCEDURE OP0140
( 		
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@FromMonth AS INT,
		@FromYear AS INT,
		@ToMonth AS INT,
		@ToYear AS INT,
		@FromDate AS DATETIME,
		@ToDate AS DATETIME,
		@IsDate AS TINYINT,
		@ShipID AS NVARCHAR(50),
		@ObjectID AS NVARCHAR(50),
		@IsPrinted AS INT --- Tất cả: 0, đã in: 1, chưa in: 2
) 
AS 
DECLARE @sSQL AS NVARCHAR(MAX),
		@sSQL1 AS NVARCHAR(MAX),
		@sSQL2 AS NVARCHAR(MAX),
		@sWhere AS NVARCHAR(MAX)

		IF @IsDate = 1 
			SET @sWhere = N'
			AND CONVERT(VARCHAR, OT2010.VoucherDate, 112) BETWEEN '''+CONVERT(VARCHAR, @FromDate, 112)+ ''' AND ''' + CONVERT(VARCHAR, @ToDate, 112) + '''
			'
		ELSE
			SET @sWhere = N'
			AND OT2010.TranYear*100 + OT2010.TranMonth >= ' + STR(@FromMonth + @FromYear * 100) + '
			AND OT2010.TranYear*100 + OT2010.TranMonth <= ' + STR(@ToMonth + @ToYear * 100) + '
			'
		-- Đã in
		IF @IsPrinted = 1
			SET @sWhere = @sWhere + N'
			AND ISNULL(OT2010.IsPrinted, 0) = 1
			'
		-- Chưa in
		IF @IsPrinted = 2
			SET @sWhere = @sWhere + N'
			AND ISNULL(OT2010.IsPrinted, 0) = 0
			'
			
		SET @sSQL = N'
		SELECT
			OT2010.APK, OT2010.DivisionID, TranMonth, TranYear, SOrderID, VoucherTypeID, VoucherNo, VoucherDate,
			ShipID, AT12022.ObjectName AS ShipName, AT1201.ObjectTypeName AS ShipTypeName, 
			OT2010.ObjectID, AT1202.ObjectName, ReceiverID, 
			AT12021.ObjectName AS ReceiverName, OT2010.OrderStatus, 
			OV1101.Description AS StatusName, OV1101.EDescription AS StatusNameE, ISNULL(IsPrinted, 0) AS IsPrinted, 
			Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
			SAna01.AnaName Ana01Name,
			SAna02.AnaName Ana02Name,
			SAna03.AnaName Ana03Name,
			SAna04.AnaName Ana04Name,
			SAna05.AnaName Ana05Name,
			Notes, ExchangeRate, OT2010.CurrencyID, PriceListID, 
			ArrivedTime,DepartureTime, BerthedTime, 
			AlongsideFrom, AlongsideTo, AlongsideTime, 
			PenaltyFrom, PenaltyTo, PenaltyTime, OT2010.CreateDate, OT2010.CreateUserID, OT2010.LastModifyDate, OT2010.LastModifyUserID
		FROM OT2010
			LEFT JOIN OT1002 SAna01 ON SAna01.DivisionID = OT2010.DivisionID AND OT2010.Ana01ID = SAna01.AnaID AND SAna01.AnaTypeID = ''S01''
			LEFT JOIN OT1002 SAna02 ON SAna02.DivisionID = OT2010.DivisionID AND OT2010.Ana02ID = SAna02.AnaID AND SAna02.AnaTypeID = ''S02''
			LEFT JOIN OT1002 SAna03 ON SAna03.DivisionID = OT2010.DivisionID AND OT2010.Ana03ID = SAna03.AnaID AND SAna03.AnaTypeID = ''S03''
			LEFT JOIN OT1002 SAna04 ON SAna04.DivisionID = OT2010.DivisionID AND OT2010.Ana04ID = SAna04.AnaID AND SAna04.AnaTypeID = ''S04''
			LEFT JOIN OT1002 SAna05 ON SAna05.DivisionID = OT2010.DivisionID AND OT2010.Ana05ID = SAna05.AnaID AND SAna05.AnaTypeID = ''S05''
			LEFT JOIN AT1202 AT1202 ON AT1202.DivisionID = OT2010.DivisionID AND AT1202.ObjectID = OT2010.ObjectID
			LEFT JOIN AT1202 AT12021 ON AT12021.DivisionID = OT2010.DivisionID AND AT12021.ObjectID = OT2010.ReceiverID
			LEFT JOIN AT1202 AT12022 ON AT12022.DivisionID = OT2010.DivisionID AND AT12022.ObjectID = OT2010.ShipID
			LEFT JOIN AT1201 ON AT1201.DivisionID = AT12022.DivisionID AND AT1201.ObjectTypeID = AT12022.ObjectTypeID
			LEFT JOIN OV1101 OV1101 ON OV1101.DivisionID = OT2010.DivisionID AND OV1101.OrderStatus = OT2010.OrderStatus AND TypeID = ''SO''
		WHERE 
			OT2010.DivisionID = ''' + @DivisionID + '''
			AND ISNULL(OT2010.ObjectID, '''') LIKE ''' + @ObjectID + '''
			AND ISNULL(OT2010.ShipID, '''') LIKE ''' + @ShipID + '''
	'

	SET @sSQL1 = N'
		ORDER BY OT2010.VoucherNo, OT2010.VoucherDate
	'
	PRINT(@sSQL + @sWhere + @sSQL1)			
	EXEC(@sSQL + @sWhere + @sSQL1)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
