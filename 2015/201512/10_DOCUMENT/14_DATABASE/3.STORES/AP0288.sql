IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0288]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0288]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh, date 27/08/2004
--- Purpose: In báo cáo phân tích doanh thu theo thời gian
--- AP0288 'AS','0000000000','SAOS.00002',5,2012,4,2012,5,2012,3

CREATE PROCEDURE [dbo].[AP0288]	
				@DivisionID AS nvarchar(50),
				@FromInventoryID AS nvarchar(50),
				@ToInventoryID AS nvarchar(50),
				@TranMonth AS int,
				@TranYear AS int,
				@FromMonth AS int,
				@FromYear AS int,
				@ToMonth AS int,
				@ToYear AS int,
				@Type AS tinyint
				
as
DECLARE @sSQL AS nvarchar(4000),
		@sWHERE AS nvarchar(4000),
		@sWHERE1 AS nvarchar(4000),
		@sWHERE2 AS nvarchar(4000)

If @Type = 1
	SET @sWHERE = '(AT9000.TranMonth+AT9000.TranYear*12 = ' + ltrim(str(@TranMonth+@TranYear*12)) + ')'
Else 
	SET @sWHERE = '(AT9000.TranMonth+AT9000.TranYear*12 BETWEEN ' + ltrim(str(@FromMonth+@FromYear*12)) + ' AND ' + ltrim(str(@ToMonth+@ToYear*12)) + ')'

SET @sWHERE1 = '(T90.TranMonth+T90.TranYear*12 = ' + ltrim(str(@TranMonth+@TranYear*12-1)) + ')'
SET @sWHERE2 = '(T90.TranMonth+T90.TranYear*12 BETWEEN ' + ltrim(str(1+@TranYear*12)) + ' AND ' + ltrim(str(@TranMonth+@TranYear*12)) + ')'

If @Type = 1	--- In báo cáo phân tích kỳ này kỳ trước
	SET @sSQL = N'	
	SELECT		AT9000.InventoryID,
				CASE WHEN ISNULL(AT9000.InventoryName1, '''') = '''' THEN ISNULL(AT1302.InventoryName, '''')
				ELSE AT9000.InventoryName1 END AS InventoryName,
				AT1302.UnitID,
				AT1304.UnitName,
				SUM(AT9000.Quantity) AS Quantity,
				SUM(AT9000.OriginalAmount) AS OriginalAmount,
				SUM(AT9000.ConvertedAmount) AS ConvertedAmount,
				
				(Select Sum(T90.Quantity) From AT9000 T90
				Where T90.DivisionID = ''' + @DivisionID + ''' And T90.TransactionTypeID IN (''T04'', ''T40'')
				And T90.InventoryID = AT9000.InventoryID And ' + @sWHERE1 + ') as LastQuantity,
				
				(Select Sum(T90.OriginalAmount) From AT9000 T90
				Where T90.DivisionID = ''' + @DivisionID + ''' And T90.TransactionTypeID IN (''T04'', ''T40'')
				And T90.InventoryID = AT9000.InventoryID And ' + @sWHERE1 + ') as LastOriginalAmount,
				
				(Select Sum(T90.ConvertedAmount) From AT9000 T90
				Where T90.DivisionID = ''' + @DivisionID + ''' And T90.TransactionTypeID IN (''T04'', ''T40'')
				And T90.InventoryID = AT9000.InventoryID And ' + @sWHERE1 + ') as LastConvertedAmount,
				
				(Select Sum(T90.Quantity) From AT9000 T90
				Where T90.DivisionID = ''' + @DivisionID + ''' And T90.TransactionTypeID IN (''T04'', ''T40'')
				And T90.InventoryID = AT9000.InventoryID And ' + @sWHERE2 + ') as TotalQuantity,
				
				(Select Sum(T90.OriginalAmount) From AT9000 T90
				Where T90.DivisionID = ''' + @DivisionID + ''' And T90.TransactionTypeID IN (''T04'', ''T40'')
				And T90.InventoryID = AT9000.InventoryID And ' + @sWHERE2 + ') as TotalOriginalAmount,
				
				(Select Sum(T90.ConvertedAmount) From AT9000 T90
				Where T90.DivisionID = ''' + @DivisionID + ''' And T90.TransactionTypeID IN (''T04'', ''T40'')
				And T90.InventoryID = AT9000.InventoryID And ' + @sWHERE2 + ') as TotalConvertedAmount
				
	FROM		AT9000
	LEFT JOIN	AT1302 ON AT9000.DivisionID = AT1302.DivisionID AND AT9000.InventoryID = AT1302.InventoryID	 
	LEFT JOIN	AT1304 ON AT9000.DivisionID = AT1304.DivisionID AND AT1304.UnitID = AT1302.UnitID
				 
	WHERE		AT9000.DivisionID = ''' + @DivisionID + '''
				AND AT9000.TransactionTypeID IN (''T04'', ''T40'')
				AND (AT9000.InventoryID between ''' + @FromInventoryID + ''' And ''' + @ToInventoryID + ''')
				AND ' + @sWHERE + '

	GROUP BY 	AT9000.InventoryID, AT1302.InventoryName, AT9000.InventoryName1, AT1302.UnitID, AT1304.UnitName
	'

Else If @Type = 2
	SET @sSQL = N'	
	SELECT		((case when TranMonth < 10 then ''0'' else '''' end) + ltrim(TranMonth) + ''/'' + ltrim(TranYear)) as MonthYear,
				AT9000.InventoryID,
				AT1302.InventoryName,
				AT1302.InventoryTypeID, AT1301.InventoryTypeName,
				AT1302.UnitID,
				AT1304.UnitName,
				AT9000.Quantity,
				AT9000.OriginalAmount,
				AT9000.ConvertedAmount
				
	FROM		AT9000
	LEFT JOIN	AT1302 ON AT9000.DivisionID = AT1302.DivisionID AND AT9000.InventoryID = AT1302.InventoryID	 
	LEFT JOIN	AT1304 ON AT1302.DivisionID = AT1304.DivisionID AND AT1302.UnitID = AT1304.UnitID
	LEFT JOIN	AT1301 ON AT1302.DivisionID = AT1301.DivisionID AND AT1302.InventoryTypeID = AT1301.InventoryTypeID
				 
	WHERE		AT9000.DivisionID = ''' + @DivisionID + '''
				AND AT9000.TransactionTypeID IN (''T04'', ''T40'')
				AND (AT9000.InventoryID between ''' + @FromInventoryID + ''' And ''' + @ToInventoryID + ''')
				AND ' + @sWHERE

Else
	SET @sSQL = N'
	SELECT		AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear,
				AT9000.InventoryID,
				AT1302.InventoryName,
				AT1302.UnitID,
				AT1304.UnitName,
				Sum(AT9000.Quantity) as Quantity,
				Sum(AT9000.OriginalAmount) as OriginalAmount,
				Sum(AT9000.ConvertedAmount) as ConvertedAmount,
				
				(Select Sum(ConvertedAmount) From AT2007 Inner join AT2006 On AT2007.DivisionID = AT2006.DivisionID And AT2006.VoucherID = AT2007.VoucherID
				Where AT2007.DivisionID = AT9000.DivisionID And AT2007.TranMonth = AT9000.TranMonth And AT2007.TranYear = AT9000.TranYear 
				And AT2006.KindVoucherID in (2,4) And AT2007.InventoryID = AT9000.InventoryID
				) as CostConvertedAmount
				
	FROM		AT9000
	LEFT JOIN	AT1302 ON AT9000.DivisionID = AT1302.DivisionID AND AT9000.InventoryID = AT1302.InventoryID	 
	LEFT JOIN	AT1304 ON AT1302.DivisionID = AT1304.DivisionID AND AT1302.UnitID = AT1304.UnitID
				 
	WHERE		AT9000.DivisionID = ''' + @DivisionID + '''
				AND AT9000.TransactionTypeID IN (''T04'', ''T40'')
				AND (AT9000.InventoryID between ''' + @FromInventoryID + ''' And ''' + @ToInventoryID + ''')
				AND ' + @sWHERE + '

	GROUP BY 	AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear, AT9000.InventoryID, AT1302.InventoryName, AT1302.UnitID, AT1304.UnitName'
---print @sSQL
EXEC(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

