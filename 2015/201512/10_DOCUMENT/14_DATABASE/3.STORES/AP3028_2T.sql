IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3028_2T]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3028_2T]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---Edit by: Khanh Van on 28/08/2013
---Purpose: Customize cho 2T dung de load len report tong hop doanh so mua hang theo mat hang, doi tuong, gia mua
---Edit by: Khanh Van: Thêm vào ConvertedQuantity
---Modified on 08/10/2015 by Tieu Mai: Sửa tiền hạch toán theo thiết lập đơn vị-chi nhánh


CREATE PROCEDURE [dbo].[AP3028_2T]	
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
DECLARE @sSQL AS nvarchar(4000),
		@sWHERE AS nvarchar(4000),
		@IsOriginal AS tinyint,
		@BaseCurrencyID AS nvarchar(50)

Begin
SET @BaseCurrencyID = (Select BaseCurrencyID From AT1101 where DivisionID = @DivisionID)
SET @IsOriginal = 1

If @IsDate = 0 
	SET @sWHERE = 'AT9000.TranMonth+AT9000.TranYear*100 BETWEEN ' + ltrim(str(@FromMonth+@FromYear*100)) + ' AND ' + ltrim(str(@ToMonth+@ToYear*100)) 
Else 
	SET @sWHERE = 'CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101),101) BETWEEN ''' + CONVERT(NVARCHAR(10), @FromDate, 101) + ''' AND ''' + CONVERT(NVARCHAR(10), @ToDate, 101) + ''''

SET @sSQL='
SELECT 	AT9000.InventoryID, AT1302.InventoryName, 
		AT9000.ObjectID, AT1202.ObjectName,
		AT1302.UnitID,AT9000.IsStock,
		AT1309.UnitID AS ConversionUnitID,
		AT1309.ConversionFactor,
		AT1309.Operator,	 
		' + CASE WHEN @IsOriginal = 0 then '''' + @BaseCurrencyID + '''' else 'AT9000.CurrencyID' end + ' AS CurrencyID,
		Sum(isnull(AT9000.OriginalAmount,0)) AS OriginalAmount,
		Sum(isnull(AT9000.ConvertedAmount,0)) AS ConvertedAmount,
		Sum(isnull(AT9000.Quantity,0)) AS Quantity,
		Sum(isnull(AT9000.ConvertedQuantity,0)) AS ConvertedQuantity,
		Sum(isnull(AT9000.MarkQuantity,0)) AS MarkQuantity,
		' + CASE WHEN @IsOriginal = 0 then 'isnull(AT9000.ConvertedAmount,0)' else 'isnull(AT9000.OriginalAmount,0)' end + 
		'/ (CASE WHEN AT9000.Quantity = 0 then 1 else AT9000.Quantity end) AS UnitPrice, AT9000.DivisionID,
		V70.Notes01, V70.Notes02, V70.Notes03, V70.Notes04, V70.Notes05, V70.Notes06, V70.Notes07, V70.Notes08, V70.Notes09, V70.Notes10, V70.Notes11, V70.Notes12, V70.Notes13, V70.Notes14, V70.Notes15, V70.SourceNo, V70.Parameter01, V70.Parameter02, V70.Parameter03, V70.Parameter04, V70.Parameter05
FROM	AT9000 
LEFT JOIN AT1202 on AT9000.ObjectID = AT1202.ObjectID and AT9000.DivisionID = AT1202.DivisionID
LEFT JOIN AT1302 on AT9000.InventoryID = AT1302.InventoryID and AT9000.DivisionID = AT1302.DivisionID
LEFT JOIN (SELECT	DivisionID, InventoryID, Min(UnitID) AS UnitID, Min(ConversionFactor) AS ConversionFactor, 
					Min(Operator) AS Operator 
           FROM		AT1309 
           GROUP BY DivisionID,InventoryID
			) AT1309 
	ON		AT9000.InventoryID = AT1309.InventoryID 
			AND AT9000.DivisionID = AT1309.DivisionID
Left JOIN AT2007 V70 ON AT9000.DivisionID = V70.DivisionID AND AT9000.VoucherID = V70.VoucherID and AT9000.InventoryID = V70.InventoryID and AT9000.Orders = V70.Orders

WHERE	TransactionTypeID in (''T03'',''T30'')
    	and  AT9000.DivisionID='''+@DivisionID + ''' 
		and AT9000.InventoryID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + '''
		and AT9000.ObjectID between ''' + @FromObjectID + ''' and ''' + @ToObjectID + '''
		and ' + @sWHERE + '
GROUP BY AT9000.InventoryID, AT1302.InventoryName, AT9000.ObjectID, AT1202.ObjectName,
		AT1302.UnitID,AT9000.IsStock,
		AT1309.UnitID,
		AT1309.ConversionFactor,
		AT1309.Operator,	 
		' + CASE WHEN @IsOriginal = 0 then 'isnull(AT9000.ConvertedAmount,0)' else 'isnull(AT9000.OriginalAmount,0)' end + 
		'/(CASE WHEN AT9000.Quantity = 0 then 1 else AT9000.Quantity end)
		' + CASE WHEN @IsOriginal = 1 then ', AT9000.CurrencyID' else '' end + ', AT9000.DivisionID,
		V70.Notes01, V70.Notes02, V70.Notes03, V70.Notes04, V70.Notes05, V70.Notes06, V70.Notes07, V70.Notes08, V70.Notes09, V70.Notes10, V70.Notes11, V70.Notes12, V70.Notes13, V70.Notes14, V70.Notes15, V70.SourceNo, V70.Parameter01, V70.Parameter02, V70.Parameter03, V70.Parameter04, V70.Parameter05
'
--print @sSQL

IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE NAME = 'AV3029' AND XTYPE ='V')
	EXEC ('CREATE VIEW AV3029	-- CREATED BY AP3028_2T
		AS '+@sSQL)
ELSE
	EXEC ('ALTER VIEW AV3029 	-- CREATED BY AP3028_2T
		AS '+@sSQL)
End
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

