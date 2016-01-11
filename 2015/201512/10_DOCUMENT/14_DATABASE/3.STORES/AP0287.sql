IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0287]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0287]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh, date 23/07/2004
--- Purpose: In báo cáo phân tích giá mua
--- AP0287 'AS','0000000001','TG3','0000000000','SAOS.00002',1,2012,5,2012,'05/04/2012','05/31/2012',0

CREATE PROCEDURE [dbo].[AP0287]	
				@DivisionID AS nvarchar(50),
				@FromObjectID AS nvarchar(50),
				@ToObjectID AS nvarchar(50),
				@FromInventoryID AS nvarchar(50),
				@ToInventoryID AS nvarchar(50),
				@FromMonth AS int,
				@FromYear AS int,
				@ToMonth AS int,
				@ToYear AS int,
				@FromDate AS datetime,
				@ToDate AS datetime,
				@IsDate AS tinyint
				
as
DECLARE @sSQL AS nvarchar(4000),
		@sWHERE AS nvarchar(4000)

If @IsDate = 0 
	SET @sWHERE = 'AT9000.TranMonth+AT9000.TranYear*100 BETWEEN ' + ltrim(str(@FromMonth+@FromYear*100)) + ' AND ' + ltrim(str(@ToMonth+@ToYear*100)) 
Else 
	SET @sWHERE = 'CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101),101) BETWEEN ''' + CONVERT(NVARCHAR(10), @FromDate, 101) + ''' AND ''' + CONVERT(NVARCHAR(10), @ToDate, 101) + ''''

Set @sSQL='		
SELECT	TranMonth,TranYear,
		((case when TranMonth < 10 then ''0'' else '''' end) + ltrim(TranMonth) + ''/'' + ltrim(TranYear)) as MonthYear,
		VoucherDate,VoucherNo,
		AT9000.InventoryID,
		AT1302.InventoryName,
		AT1302.UnitID,
		AT1304.UnitName,
		AT9000.ObjectID,
		AT1202.ObjectName,
		AT9000.CurrencyID,
		AT9000.UnitPrice,
		Serial,
		Quantity,
		InvoiceDate,
		InvoiceNo,
		OriginalAmount,
		ConvertedAmount	

FROM	AT9000 
LEFT JOIN AT1302 ON AT9000.DivisionID = AT1302.DivisionID AND AT9000.InventoryID = AT1302.InventoryID
LEFT JOIN AT1202 ON AT9000.ObjectID = AT1202.ObjectID AND AT9000.DivisionID = AT1202.DivisionID
LEFT JOIN AT1304 ON AT9000.UnitID = AT1304.UnitID AND AT9000.DivisionID = AT1304.DivisionID
	
WHERE	AT9000.DivisionID=N'''+@DivisionID+'''
		AND AT9000.TransactionTypeID in (N''T03'', N''T30'')
		and AT9000.InventoryID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + '''
		and AT9000.ObjectID between ''' + @FromObjectID + ''' and ''' + @ToObjectID + '''
		and ' + @sWHERE	
	
---print @sSQL
EXEC(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

