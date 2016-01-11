IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0142]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0142]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load edit quyết toán tàu-sà lan
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
---- EXEC OP0142 'BBL', 'ASOFTADMIN', 'QT/11/20/2014/0001'

CREATE PROCEDURE OP0142
( 		
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@SOrderID AS NVARCHAR(50)
) 
AS 
DECLARE @sSQL AS NVARCHAR(MAX),
		@sSQL1 AS NVARCHAR(MAX),
		@sSQL2 AS NVARCHAR(MAX),
		@sWhere AS NVARCHAR(MAX)
		
	SET @sSQL = N'
		SELECT 
			APK, DivisionID, TranMonth, TranYear, SOrderID, VoucherTypeID, VoucherNo, VoucherDate,
			ShipID, ObjectID, ReceiverID, OrderStatus, IsPrinted, 
			Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
			Notes, ExchangeRate, CurrencyID, PriceListID, 
			ArrivedTime,DepartureTime, BerthedTime, 
			AlongsideFrom, AlongsideTo, AlongsideTime, GRT,
			PenaltyFrom, PenaltyTo, PenaltyTime, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID
		FROM OT2010
		WHERE 
			DivisionID = ''' + @DivisionID + '''
			AND SOrderID = ''' + @SOrderID + '''
	'
			
	EXEC(@sSQL)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
