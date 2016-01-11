IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3027]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3027]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---Created by Nguyen Thi Ngoc Minh, date 18/08/2004
---Purpose: Len bao cao doanh thu ban hang nhom theo mat hang, gia ban va doi tuong
---- Modified on 16/01/2012 by Le Thi Thu Hien : Sua dieu kien loc theo ngay
---- Modified on 08/10/2015 by Tieu Mai: Sửa tiền hạch toán theo thiết lập đơn vị-chi nhánh

/********************************************
'* Edited by: [GS] [Thanh Tram] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP3027]	
			@DivisionID AS nvarchar(50),
			@FromDate AS datetime,
			@ToDate AS datetime,
			@FromMonth AS int,
			@FromYear AS int,
			@ToMonth AS int,
			@ToYear AS int,
			@IsDate AS tinyint,
			@FromInventoryID AS nvarchar(50),
			@ToInventoryID AS nvarchar(50),
			@FromObjectID AS nvarchar(50),
			@ToObjectID AS nvarchar(50)
				
as
declare @sSQL AS nvarchar(4000),
		@sWHERE AS nvarchar(4000),
		@IsOriginal AS tinyint,
		@BaseCurrencyID AS nvarchar(50)

Set @BaseCurrencyID = (Select BaseCurrencyID From AT1101 where DivisionID=@DivisionID)
Set @IsOriginal = 1

If @IsDate = 0 
	Set @sWHERE = 'AT9000.TranMonth+AT9000.TranYear*100 between ' + ltrim(str(@FromMonth+@FromYear*100)) + 	' AND ' + ltrim(str(@ToMonth+@ToYear*100)) 
Else 
	Set @sWHERE = 'CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101),101) between ''' + convert(nvarchar(10), @FromDate, 101) + ''' AND ''' + convert(nvarchar(10), @ToDate, 101) + ''''
Set @sSQL='
SELECT 	AT9000.InventoryID, AT1302.InventoryName, AT9000.ObjectID, AT1202.ObjectName,
		' + CASE WHEN @IsOriginal = 0 then '''' + @BaseCurrencyID + '''' else 'AT9000.CurrencyID' end + ' AS CurrencyID,
		Sum(isnull(OriginalAmount,0)) AS OriginalAmount,
		Sum(isnull(ConvertedAmount,0)) AS ConvertedAmount,
		Sum(isnull(Quantity,0)) AS Quantity,
		Case When IsNull(AT9000.Quantity,0) = 0 then 0 else
		' + CASE WHEN @IsOriginal = 0 then 'isnull(ConvertedAmount,0)' else 'isnull(OriginalAmount,0)' end + '/isnull(Quantity,0) end AS UnitPrice, AT9000.DivisionID
FROM	AT9000 
left join AT1202 on AT9000.ObjectID = AT1202.ObjectID AND AT9000.DivisionID = AT1202.DivisionID
left join AT1302 on AT9000.InventoryID = AT1302.InventoryID AND AT9000.DivisionID = AT1302.DivisionID
Where	TransactionTypeID in (''T04'',''T40'')
    	AND AT9000.DivisionID='''+@DivisionID + ''' 
		AND AT9000.InventoryID between N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + '''
		AND AT9000.ObjectID between N''' + @FromObjectID + ''' AND N''' + @ToObjectID + '''
		AND ' + @sWHERE + '
Group By AT9000.InventoryID, AT1302.InventoryName, AT9000.ObjectID, AT1202.ObjectName,
	Case When IsNull(AT9000.Quantity,0) = 0 then 0 else
	' + CASE WHEN @IsOriginal = 0 then 'isnull(ConvertedAmount,0)' else 'isnull(OriginalAmount,0)' end + '/isnull(Quantity,0) end
	' + CASE WHEN @IsOriginal = 1 then ', AT9000.CurrencyID' else '' end + ', AT9000.DivisionID
'
--print @sSQL
IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE NAME = 'AV3027' AND XTYPE ='V')
	EXEC ('CREATE VIEW AV3027 	-- CREATED BY AP3027
		AS '+@sSQL)
ELSE
	EXEC ('ALTER VIEW AV3027 	-- CREATED BY AP3027
		AS '+@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

