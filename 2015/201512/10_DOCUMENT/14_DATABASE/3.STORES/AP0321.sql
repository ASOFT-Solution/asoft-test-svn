/****** Object:  StoredProcedure [dbo].[AP0321]    Script Date: 07/28/2010 13:51:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Nguyen Thi Ngoc Minh	
--Date: 10/09/2004
--Purpose: Bao cao cong no phai tra theo ma phan tich
---- Modified on 13/02/2012 by Le Thi Thu Hien : Bo sung them JOIN DivisionID
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [28/07/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[AP0321] 
				@DivisionID AS nvarchar(50),
				@Group1 AS nvarchar(50),
				@Group2 AS nvarchar(50),	
				@Group3 AS nvarchar(50),	
				@Filter1 AS nvarchar(50),
				@Filter1From AS nvarchar(50),
				@Filter1To AS nvarchar(50),				
				@Filter2 AS nvarchar(50),
				@Filter2From AS nvarchar(50),
				@Filter2To AS nvarchar(50),
				@Filter3 AS nvarchar(50),
				@Filter3From AS nvarchar(50),
				@Filter3To AS nvarchar(50),
				@FromAccID AS nvarchar(50),
				@ToAccID AS nvarchar(50),
				@FromObjectID AS nvarchar(50),
				@ToObjectID AS nvarchar(50),
				@CurrencyID AS nvarchar(50),
				@FromDate AS datetime,
				@ToDate AS datetime,
				@FromMonth AS int,
				@FromYear AS int,
				@ToMonth AS int,
				@ToYear AS int,
				@IsMonth AS tinyint,
				@DateType AS tinyint,	--0: Ngay dao han
							--1: Ngay hoa don
							--2: Ngay chung tu
				@AmountUnit AS int,
				@IsGeneral AS tinyint
AS

DECLARE @sSQL AS nvarchar(4000),
		@sWHERE AS nvarchar(500),
		@sWHERE1 AS nvarchar(500),
		@sSELECT AS nvarchar(500),
		@sSELECT1 AS nvarchar(500),
		@sGROUPBY AS nvarchar(500),
		@sGROUPBY1 AS nvarchar(500),
		@TypeDate AS nvarchar(100),
		@PeriodFrom AS int,
		@PeriodTo AS int,
		@ConversionAmountUnit AS int,
		@GroupName1 AS nvarchar(250),
		@GroupName2 AS nvarchar(250),
		@GroupName3 AS nvarchar(250),
		@Filter1ID AS nvarchar(250),
		@Filter2ID AS nvarchar(250),
		@Filter3ID AS nvarchar(250),
		@Group1ID AS nvarchar(50),
		@Group2ID AS nvarchar(50),
		@Group3ID AS nvarchar(50)

SET @sWHERE = ''
SET @sSELECT = ''
SET @sGROUPBY = ''
SET @sWHERE1 = ''
SET @sSELECT1 = ''
SET @sGROUPBY1 = ''

SET @PeriodFrom = @FromMonth + @FromYear*100
SET @PeriodTo = @ToMonth + @ToYear*100

-------------Xac dinh loai ngay len bao cao------------
if @DateType = 1 	---- Theo Ngay Ho¸ ®¬n
	SET @TypeDate  = 'InvoiceDate'
else if @DateType = 2	---- Theo Ngµy H¹ch to¸n
	SET @TypeDate = 'VoucherDate'
else 			---- Theo Ngay dao han
	SET @TypeDate = 'DueDate'

If @IsMonth = 0
	SET @sWHERE = @sWHERE + '
		(AV4301.'+ltrim(Rtrim(@TypeDate))+' Between '''+
		convert(nvarchar(10),@FromDate,101)+''' AND '''+convert(nvarchar(10),@ToDate,101)+''')  '
Else
	SET @sWHERE = @sWHERE + '
		((AV4301.TranMonth + AV4301.TranYear*100) between ' + 
		ltrim(rtrim(str(@PeriodFrom)))  + ' AND ' + ltrim(rtrim(str(@PeriodTo))) + ') '

IF @AmountUnit = 0
	SET @ConversionAmountUnit =1
IF @AmountUnit = 1
	SET @ConversionAmountUnit =1000
IF @AmountUnit = 2
	SET @ConversionAmountUnit =1000000


If @Group1 != ''
Exec AP4700  @Group1,	@Group1ID OUTPUT

If @Group2 != ''
Exec AP4700  @Group2,	@Group2ID OUTPUT

If @Group3 != ''
Exec AP4700  @Group3,	@Group3ID OUTPUT



If @IsGeneral = 0 
  Begin
	SET @sSELECT = ' isnull(AV4301.VoucherDate,' + getdate() + ') AS VoucherDate, 
		isnull(AV4301.VoucherNo,'''') AS VoucherNo,
		isnull(AV4301.InvoiceDate,' + getdate() + ') AS InvoiceDate, 
		isnull(AV4301.Serial,'''') AS Serial, 
		isnull(AV4301.InvoiceNo,'''') AS InvoiceNo, 
		isnull(AV4301.VDescription,'''') AS VDescription,
		isnull(AV4301.ObjectID,AV0331.ObjectID) AS ObjectID, T02.ObjectName, 
		isnull(AV4301.CurrencyIDCN, AV0331.CurrencyIDCN) AS CurrencyIDCN, '
	SET @sGROUPBY =  ' isnull(AV4301.VoucherDate,' + getdate() + '), 
		isnull(AV4301.VoucherNo,''''), isnull(AV4301.InvoiceDate,' + getdate() + '), 
		isnull(AV4301.Serial,''''), isnull(AV4301.InvoiceNo,''''), 
		isnull(AV4301.VDescription,''''),
		isnull(AV4301.ObjectID,AV0331.ObjectID), T02.ObjectName, 
		isnull(AV4301.CurrencyIDCN, AV0331.CurrencyIDCN) '
	
  End
Else
  Begin
	SET @sSELECT = ' isnull(AV4301.ObjectID,AV0331.ObjectID) AS ObjectID, T02.ObjectName, 
		isnull(AV4301.CurrencyIDCN, AV0331.CurrencyIDCN) AS CurrencyIDCN, '
	SET @sGROUPBY =  '  isnull(AV4301.ObjectID,AV0331.ObjectID), T02.ObjectName, 
		isnull(AV4301.CurrencyIDCN, AV0331.CurrencyIDCN)  '
  End

If @Filter1 != ''
  Begin
	Exec AP4700  @Filter1,	@Filter1ID OUTPUT
	SET @sWHERE = @sWHERE + ' AND 
					(AV4301.' + @Filter1ID + ' between ''' + @Filter1From + ''' AND ''' + @Filter1To + ''') 
					AND (AV0331.' + @Filter1ID + ' between ''' + @Filter1From + ''' AND ''' + @Filter1To + ''') '
	SET @sWHERE1 = @sWHERE1 + ' AND 
					(AV0331.' + @Filter1ID + ' between ''' + @Filter1From + ''' AND ''' + @Filter1To + ''') '
	SET @sSELECT = @sSELECT +' AV4301.' + @Filter1ID + ' AS Filter1, '
	SET @sSELECT1 = @sSELECT1 +' AV0331.' + @Filter1ID + ' AS Filter1, '
	SET @sGROUPBY = @sGROUPBY +', AV4301.' + @Filter1ID  
	SET @sGROUPBY1 = @sGROUPBY1 +', AV0331.' + @Filter1ID  
  End
Else
  Begin	
	SET @sSELECT = @sSELECT + ''''' AS Filter1,'
	SET @sSELECT1 = @sSELECT1 + ''''' AS Filter1,'
  End

If @Filter2 != ''
  Begin
	Exec AP4700  @Filter2,	@Filter2ID OUTPUT
	SET @sWHERE = @sWHERE + ' AND 
					(AV4301.' + @Filter2ID + ' between ''' + @Filter2From + ''' AND ''' + @Filter2To + ''') 
					AND (AV0331.' + @Filter2ID + ' between ''' + @Filter2From + ''' AND ''' + @Filter2To + ''') '
	SET @sWHERE1 = @sWHERE1 + ' AND 
					(AV0331.' + @Filter2ID + ' between ''' + @Filter2From + ''' AND ''' + @Filter2To + ''') '
	SET @sSELECT = @sSELECT +' AV4301.' + @Filter2ID + ' AS Filter2, '
	SET @sSELECT1 = @sSELECT1 +' AV0331.' + @Filter2ID + ' AS Filter2, '
	SET @sGROUPBY = @sGROUPBY +', AV4301.' + @Filter2ID
	SET @sGROUPBY1 = @sGROUPBY1 +', AV0331.' + @Filter2ID  
  End
Else
  Begin	
	SET @sSELECT = @sSELECT + ''''' AS Filter2,'
	SET @sSELECT1 = @sSELECT1 + ''''' AS Filter2,'
  End

If @Filter3 != ''
  Begin
	Exec AP4700  @Filter3,	@Filter3ID OUTPUT
	SET @sWHERE = @sWHERE + ' AND 
					(AV4301.' + @Filter3ID + ' between ''' + @Filter3From + ''' AND ''' + @Filter3To + ''') 
					AND (AV0331.' + @Filter3ID + ' between ''' + @Filter3From + ''' AND ''' + @Filter3To + ''') '
	SET @sWHERE1 = @sWHERE1 + ' AND 
					(AV0331.' + @Filter3ID + ' between ''' + @Filter3From + ''' AND ''' + @Filter3To + ''') '
	SET @sSELECT = @sSELECT +' AV4301.' + @Filter3ID + ' AS Filter3, '
	SET @sSELECT1 = @sSELECT1 +' AV0331.' + @Filter3ID + ' AS Filter3, '
	SET @sGROUPBY = @sGROUPBY +', AV4301.' + @Filter3ID 
	SET @sGROUPBY1 = @sGROUPBY1 +', AV0331.' + @Filter3ID  
  End
Else
  Begin	
	SET @sSELECT = @sSELECT + ''''' AS Filter3,'
	SET @sSELECT1 = @sSELECT1 + ''''' AS Filter3,'
  End

Exec AP0331 	@DivisionID, @FromObjectID, @ToObjectID, @FromAccID, @ToAccID,  
		@CurrencyID, @FromMonth, @FromYear, @FromDate, @IsMonth, @TypeDate,
		@Group1, @Group2, @Group3, @Filter1, @Filter2, @Filter3


If @IsMonth  = 0
Begin

  SET @sSQL='
SELECT  '	 + (CASE WHEN @Group1 != '' THEN '	V1.SelectionID AS  Group1ID, 
	V1.SelectionName AS Group1Name, ' ELSE '' END) 
	+ (CASE WHEN @Group2 != '' THEN '	V2.SelectionID AS  Group2ID, 
	V2.SelectionName AS Group2Name, ' ELSE '' END) 
 	+ (CASE WHEN @Group3 != '' THEN '	V3.SelectionID AS  Group3ID, 
	V3.SelectionName AS Group3Name, ' ELSE '' END) + '
	' + @sSELECT + '
	SUM(CASE WHEN AV4301.D_C = ''D'' 
		THEN ISNULL( AV4301.OriginalAmount,0) else 0 end)/' + ltrim(rtrim(str(@ConversionAmountUnit))) + ' AS DebitOriginalAmount,
	SUM(CASE WHEN AV4301.D_C = ''C'' 
		THEN ISNULL( AV4301.OriginalAmount,0) else 0 end)/' + ltrim(rtrim(str(@ConversionAmountUnit))) + ' AS CreditOriginalAmount,
	SUM(CASE WHEN AV4301.D_C = ''D'' 
		THEN ISNULL( AV4301.ConvertedAmount,0) else 0 end)/' + ltrim(rtrim(str(@ConversionAmountUnit))) + ' AS DebitConvertedlAmount,
	SUM(CASE WHEN AV4301.D_C = ''C'' 
		THEN ISNULL( AV4301.ConvertedAmount,0) else 0 end)/' + ltrim(rtrim(str(@ConversionAmountUnit))) + ' AS CreditConvertedlAmount,
	SUM(AV0331.OpeningConvertedAmount) AS OpeningConvertedAmount,
	SUM(AV0331.OpeningOriginalAmount) AS OpeningOriginalAmount, AV4301.DivisionID

From AV4301 
'+ (CASE WHEN @Group1 != '' THEN ' LEFT JOIN  AV6666 V1 on V1.DivisionID = AV4301.DivisionID AND V1.SelectionType = ''' + @Group1 + ''' AND V1.SelectionID = AV4301.' + @Group1ID + '' ELSE '' END) 
 + (CASE WHEN @Group2 != '' THEN ' LEFT JOIN  AV6666 V2 on V2.DivisionID = AV4301.DivisionID AND V2.SelectionType = ''' + @Group2 + ''' AND V2.SelectionID = AV4301.' + @Group2ID + '' ELSE '' END) 
 + (CASE WHEN @Group3 != '' THEN ' LEFT JOIN  AV6666 V3 on V3.DivisionID = AV4301.DivisionID AND V3.SelectionType = ''' + @Group3 + ''' AND V3.SelectionID = AV4301.' + @Group3ID + '' ELSE '' END) 
 + '
LEFT JOIN AV0331 on (AV0331.DivisionID = AV4301.DivisionID AND AV0331.ObjectID = AV4301.ObjectID AND AV0331.AccountID = AV4301.AccountID AND AV0331.CurrencyIDCN = AV4301.CurrencyIDCN
				' + (CASE WHEN @Group1 != '' THEN ' AND AV0331.Group1ID = V1.SelectionID ' ELSE '' END ) + '
				' + (CASE WHEN @Group2 != '' THEN ' AND AV0331.Group2ID = V2.SelectionID ' ELSE '' END ) + '
				' + (CASE WHEN @Group3 != '' THEN ' AND AV0331.Group3ID = V3.SelectionID ' ELSE '' END ) + '
				' + (CASE WHEN @Filter1 != '' THEN ' AND AV0331.Filter1 = AV4301.Filter1 ' ELSE '' END) + '
				' + (CASE WHEN @Filter2 != '' THEN ' AND AV0331.Filter2 = AV4301.Filter2 ' ELSE '' END) + '
				' + (CASE WHEN @Filter3 != '' THEN ' AND AV0331.Filter3 = AV4301.Filter3 ' ELSE '' END) + ')
LEFT JOIN AT1202 AS T02 on T02.ObjectID = AV4301.ObjectID AND T02.DivisionID = AV4301.DivisionID
LEFT JOIN AT1005 AS T05 on T05.AccountID = AV4301.AccountID AND T05.DivisionID = AV4301.DivisionID
WHERE	AV4301.DivisionID = ''' + @DivisionID + ''' AND 
		(AV4301.AccountID between ''' + @FromAccID + ''' AND ''' + @ToAccID + ''') and
		T05.GroupID = ''G04'' and
		(T02.ObjectID between ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''')  and
		AV4301.CurrencyIDCN like ''' + @CurrencyID + ''' and
		' + @sWHERE + '

GROUP BY AV4301.DivisionID, ' + (CASE WHEN @Group1 != '' THEN '	V1.SelectionID, 	V1.SelectionName, ' ELSE '' END) +
		(CASE WHEN @Group2 != '' THEN '	V2.SelectionID, 	V2.SelectionName, ' ELSE '' END) +
		(CASE WHEN @Group3 != '' THEN '	V3.SelectionID, 	V3.SelectionName, ' ELSE '' END) + '
		' + @sGROUPBY 
  End
Else
  Begin
  	SET @sSQL = '
SELECT  '+ (CASE WHEN @Group1 != '' THEN '	V1.SelectionID AS  Group1ID, V1.SelectionName AS Group1Name, ' ELSE '' END) 
		 + (CASE WHEN @Group2 != '' THEN '	V2.SelectionID AS  Group2ID, V2.SelectionName AS Group2Name, ' ELSE '' END) 
 		 + (CASE WHEN @Group3 != '' THEN '	V3.SelectionID AS  Group3ID, V3.SelectionName AS Group3Name, ' ELSE '' END) + '
		' + @sSELECT  + '	
		SUM(CASE WHEN AV4301.D_C = ''D'' 
			THEN ISNULL( AV4301.OriginalAmount,0) else 0 end)/' + ltrim(rtrim(str(@ConversionAmountUnit))) + ' AS DebitOriginalAmount,
		SUM(CASE WHEN AV4301.D_C = ''C'' 
			THEN ISNULL( AV4301.OriginalAmount,0) else 0 end)/' + ltrim(rtrim(str(@ConversionAmountUnit))) + ' AS CreditOriginalAmount,
		SUM(CASE WHEN AV4301.D_C = ''D'' 
			THEN ISNULL( AV4301.ConvertedAmount,0) else 0 end)/' + ltrim(rtrim(str(@ConversionAmountUnit))) + ' AS DebitConvertedlAmount,
		SUM(CASE WHEN AV4301.D_C = ''C'' 
			THEN ISNULL( AV4301.ConvertedAmount,0) else 0 end)/' + ltrim(rtrim(str(@ConversionAmountUnit))) + ' AS CreditConvertedlAmount,
		SUM(AV0331.OpeningConvertedAmount) AS OpeningConvertedAmount,
		SUM(AV0331.OpeningOriginalAmount) AS OpeningOriginalAmount, AV4301.DivisionID
FROM	AV4301 
'+ (CASE WHEN @Group1 != '' THEN '	 LEFT JOIN AV6666 V1 on V1.DivisionID = AV4301.DivisionID AND V1.SelectionType ='''+@Group1+''' and V1.SelectionID = AV4301.'+ @Group1ID +'' ELSE '' END) 
 + (CASE WHEN @Group2 != '' THEN '	 LEFT JOIN AV6666 V2 on V1.DivisionID = AV4301.DivisionID AND V2.SelectionType ='''+@Group2+''' and V2.SelectionID = AV4301.'+ @Group2ID +'' ELSE '' END) 
 + (CASE WHEN @Group3 != '' THEN '	 LEFT JOIN AV6666 V3 on V1.DivisionID = AV4301.DivisionID AND V3.SelectionType ='''+@Group3+''' and V3.SelectionID = AV4301.'+ @Group3ID +'' ELSE '' END) 
 + '
FULL JOIN AV0331 on (AV0331.DivisionID = AV4301.DivisionID AND AV0331.ObjectID = AV4301.ObjectID AND AV0331.AccountID = AV4301.AccountID	AND AV0331.CurrencyIDCN = AV4301.CurrencyIDCN	
			' + (CASE WHEN @Group1 != '' THEN 'AND AV0331.Group1ID = V1.SelectionID ' ELSE '' END ) + '
			' + (CASE WHEN @Group2 != '' THEN 'AND AV0331.Group2ID = V2.SelectionID ' ELSE '' END ) + '
			' + (CASE WHEN @Group3 != '' THEN 'AND AV0331.Group3ID = V3.SelectionID ' ELSE '' END ) + '
			' + (CASE WHEN @Filter1 != '' THEN ' AND AV0331.Filter1 = AV4301.Filter1 ' ELSE '' END) + '
			' + (CASE WHEN @Filter2 != '' THEN ' AND AV0331.Filter2 = AV4301.Filter2 ' ELSE '' END) + '
			' + (CASE WHEN @Filter3 != '' THEN ' AND AV0331.Filter3 = AV4301.Filter3 ' ELSE '' END) + ')
LEFT JOIN AT1202 AS T02 on T02.ObjectID = AV4301.ObjectID AND T02.DivisionID = AV4301.DivisionID
LEFT JOIN AT1005 AS T05 on T05.AccountID = AV4301.AccountID AND T05.DivisionID = AV4301.DivisionID
WHERE	AV4301.DivisionID = ''' + @DivisionID + ''' AND 
		(AV4301.AccountID between ''' + @FromAccID + ''' AND ''' + @ToAccID + ''') and
		T05.GroupID = ''G04'' and
		(T02.ObjectID between ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''')  and
		AV4301.CurrencyIDCN like ''' + @CurrencyID + ''' and
		'  + @sWHERE + '
GROUP BY AV4301.DivisionID, ' + (CASE WHEN @Group1 != '' THEN '	V1.SelectionID, 	V1.SelectionName, ' ELSE '' END) +
	(CASE WHEN @Group2 != '' THEN '	V2.SelectionID, 	V2.SelectionName, ' ELSE '' END) +
	(CASE WHEN @Group3 != '' THEN '	V3.SelectionID, 	V3.SelectionName, ' ELSE '' END) + '
	' + @sGROUPBY 
End

--print @sSQl

IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE NAME = 'AV0322' AND XTYPE ='V')
	 EXEC('CREATE VIEW AV0322 -- TAO BOI AP0321
			AS ' + @sSQL) 
ELSE
	EXEC ('ALTER VIEW AV0322 -- TAO BOI AP0321
			AS ' + @sSQL) 

SET @sSQL = '
SELECT * FROM AV0322 
UNION ALL
SELECT '+ (CASE WHEN @Group1 != '' THEN '	V1.SelectionID AS  Group1ID, V1.SelectionName AS Group1Name, ' ELSE '' END) 
		+ (CASE WHEN @Group2 != '' THEN '	V2.SelectionID AS  Group2ID, V2.SelectionName AS Group2Name, ' ELSE '' END) 
 		+ (CASE WHEN @Group3 != '' THEN '	V3.SelectionID AS  Group3ID, V3.SelectionName AS Group3Name, ' ELSE '' END) + '
		' + @sSELECT1 + '	
		0 AS DebitOriginalAmount,
		0 AS CreditOriginalAmount,
		0 AS DebitConvertedlAmount,
		0 AS CreditConvertedlAmount,
		SUM(AV0331.OpeningConvertedAmount) AS OpeningConvertedAmount,
		SUM(AV0331.OpeningOriginalAmount) AS OpeningOriginalAmount,
		AV0331.DivisionID
FROM	AV0331 
'+ (CASE WHEN @Group1 != '' THEN '	 LEFT JOIN  AV6666 V1 on V1.DivisionID = AV0331.DivisionID AND V1.SelectionType ='''+@Group1+''' and V1.SelectionID = AV0331.Group1ID	' ELSE '' END) 
 + (CASE WHEN @Group2 != '' THEN '	 LEFT JOIN  AV6666 V2 on V2.DivisionID = AV0331.DivisionID AND V2.SelectionType ='''+@Group2+''' and V2.SelectionID = AV0331.Group2ID	' ELSE '' END) 
 + (CASE WHEN @Group3 != '' THEN '	 LEFT JOIN  AV6666 V3 on V3.DivisionID = AV0331.DivisionID AND V3.SelectionType ='''+@Group3+''' and V3.SelectionID = AV0331.Group3ID	' ELSE '' END) 
 + '
LEFT JOIN AT1202 AS T02 on T02.ObjectID = AV0331.ObjectID AND T02.DivisionID = AV0331.DivisionID
LEFT JOIN AT1005 AS T05 on T05.AccountID = AV0331.AccountID AND T05.DivisionID = AV0331.DivisionID

WHERE	AV0331.ObjectID not in (Select ObjectID from AV0322)
		' + @sWHERE1 + '
GROUP BY AV0331.DivisionID, ' + (CASE WHEN @Group1 != '' THEN '	V1.SelectionID, 	V1.SelectionName, ' ELSE '' END) +
		(CASE WHEN @Group2 != '' THEN '	V2.SelectionID, 	V2.SelectionName, ' ELSE '' END) +
		(CASE WHEN @Group3 != '' THEN '	V3.SelectionID, 	V3.SelectionName, ' ELSE '' END) + '
		' + @sGROUPBY1

















