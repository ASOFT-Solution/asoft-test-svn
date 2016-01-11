IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0320]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0320]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Created by Nguyen Thi Ngoc Minh	
--Date: 10/09/2004
--Purpose: Bao cao cong no phai thu theo ma phan tich
---- Modified on 13/02/2012 by Le Thi Thu Hien : Bo sung them JOIN DivisionID
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [28/07/2010]
'**************************************************************/

CREATE PROCEDURE [dbo].[AP0320] 
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
		@Group3ID AS nvarchar(50),
		@GroupName AS nvarchar(250)

SET @sWHERE = ''
SET @sSELECT = ''
SET @sGROUPBY = ''
SET @sWHERE1 = ''
SET @sSELECT1 = ''
SET @sGROUPBY1 = ''

SET @PeriodFrom = @FromMonth + @FromYear*100
SET @PeriodTo = @ToMonth + @ToYear*100

-------------Xac dinh loai ngay len bao cao------------
IF @DateType = 1 	---- Theo Ngay hoa don
	SET @TypeDate  = 'InvoiceDate'
else IF @DateType = 2	---- Theo ngay hach toan
	SET @TypeDate = 'VoucherDate'
else 			---- Theo Ngay dao han
	SET @TypeDate = 'DueDate'

IF @IsMonth = 0
	SET @sWHERE = @sWHERE + '
		(AT9000.'+ltrim(Rtrim(@TypeDate))+' Between '''+
		convert(nvarchar(10),@FromDate,101)+''' AND '''+convert(nvarchar(10),@ToDate,101)+''')  '
Else
	SET @sWHERE = @sWHERE + '
		((AT9000.TranMonth + AT9000.TranYear*100) between ' + 
		ltrim(rtrim(str(@PeriodFrom)))  + ' AND ' + ltrim(rtrim(str(@PeriodTo))) + ') '

IF @AmountUnit = 0
	SET @ConversionAmountUnit =1
IF @AmountUnit = 1
	SET @ConversionAmountUnit =1000
IF @AmountUnit = 2
	SET @ConversionAmountUnit =1000000


IF @Group1 != ''
Exec AP4700  @Group1,	@Group1ID OUTPUT

IF @Group2 != ''
Exec AP4700  @Group2,	@Group2ID OUTPUT

IF @Group3 != ''
Exec AP4700  @Group3,	@Group3ID OUTPUT



IF @IsGeneral = 0 
  Begin
	SET @sSELECT = ' AT9000.VoucherDate, AT9000.VoucherNo,
		AT9000.InvoiceDate, AT9000.Serial, AT9000.InvoiceNo, AT9000.VDescription,
		AT9000.ObjectID, T02.ObjectName, AT9000.CurrencyIDCN, '
	SET @sGROUPBY = ' AT9000.VoucherDate, AT9000.VoucherNo,
		AT9000.InvoiceDate, AT9000.Serial, AT9000.InvoiceNo, AT9000.VDescription,
		AT9000.ObjectID, T02.ObjectName, AT9000.CurrencyIDCN '
  End
Else
  Begin
	SET @sSELECT = ' AT9000.ObjectID, T02.ObjectName, AT9000.CurrencyIDCN, '
	SET @sGROUPBY =  ' AT9000.ObjectID, T02.ObjectName, AT9000.CurrencyIDCN '
  End

IF @Filter1 != ''
  Begin
	Exec AP4700  @Filter1,	@Filter1ID OUTPUT
	SET @sWHERE = @sWHERE + ' AND 
					(AT9000.' + @Filter1ID + ' between ''' + @Filter1From + ''' AND ''' + @Filter1To + ''') 
					and (AV0331.' + @Filter1ID + ' between ''' + @Filter1From + ''' AND ''' + @Filter1To + ''') '
	SET @sSELECT = @sSELECT +' AT9000.' + @Filter1ID + ' AS Filter1, '
	SET @sGROUPBY = @sGROUPBY +', AT9000.' + @Filter1ID  
  End

IF @Filter2 != ''
  Begin
	Exec AP4700  @Filter2,	@Filter2ID OUTPUT
	SET @sWHERE = @sWHERE + ' AND 
					(AT9000.' + @Filter2ID + ' between ''' + @Filter2From + ''' AND ''' + @Filter2To + ''') 
					and (AV0331.' + @Filter2ID + ' between ''' + @Filter2From + ''' AND ''' + @Filter2To + ''') '
	SET @sSELECT = @sSELECT +' AT9000.' + @Filter2ID + ' AS Filter2, '
	SET @sGROUPBY = @sGROUPBY +', AT9000.' + @Filter2ID
  End

IF @Filter3 != ''
BEGIN
	Exec AP4700  @Filter3,	@Filter3ID OUTPUT
	SET @sWHERE = @sWHERE + ' AND 
					(AT9000.' + @Filter3ID + ' between ''' + @Filter3From + ''' AND ''' + @Filter3To + ''') 
					and (AV0331.' + @Filter3ID + ' between ''' + @Filter3From + ''' AND ''' + @Filter3To + ''') '
	SET @sSELECT = @sSELECT +' AT9000.' + @Filter3ID + ' AS Filter3, '
	SET @sGROUPBY = @sGROUPBY +', AT9000.' + @Filter3ID 
END

Exec AP0331 	@DivisionID, @FromObjectID, @ToObjectID, @FromAccID, @ToAccID,  
				@CurrencyID, @FromMonth, @FromYear, @FromDate, @IsMonth, @TypeDate,
				@Group1, @Group2, @Group3, @Filter1, @Filter2, @Filter3

IF @IsMonth  = 0
   Begin
	SET @sSQL = '
SELECT	'	 + (CASE WHEN @Group1 != '' THEN '	V1.SelectionID AS  Group1ID, 
		V1.SelectionName AS Group1Name, ' ELSE '' end) 
		+ (CASE WHEN @Group2 != '' THEN '	V2.SelectionID AS  Group2ID, 
		V2.SelectionName AS Group2Name, ' ELSE '' end) 
 		+ (CASE WHEN @Group3 != '' THEN '	V3.SelectionID AS  Group3ID, 
		V3.SelectionName AS Group3Name, ' ELSE '' end) + '
		' + @sSELECT + '
		SUM(CASE WHEN T51.GroupID = ''G04'' 
			then isnull(AT9000.OriginalAmount,0) ELSE 0 end)/' + ltrim(rtrim(str(@ConversionAmountUnit))) + ' AS DebitOriginalAmount,
		SUM(CASE WHEN T52.GroupID = ''G04'' 
			then isnull(AT9000.OriginalAmount,0) ELSE 0 end)/' + ltrim(rtrim(str(@ConversionAmountUnit))) + ' AS CreditOriginalAmount,
		SUM(CASE WHEN T51.GroupID = ''G04'' 
			then isnull(AT9000.ConvertedAmount,0) ELSE 0 end)/' + ltrim(rtrim(str(@ConversionAmountUnit))) + ' AS DebitConvertedlAmount,
		SUM(CASE WHEN T52.GroupID = ''G04'' 
			then isnull(AT9000.ConvertedAmount,0) ELSE 0 end)/' + ltrim(rtrim(str(@ConversionAmountUnit))) + ' AS CreditConvertedlAmount,
		SUM(AV0331.OpeningConvertedAmount) AS OpeningConvertedAmount,
		SUM(AV0331.OpeningOriginalAmount) AS OpeningOriginalAmount
FROM	AV4301 
'+ (CASE WHEN @Group1 != '' THEN ' LEFT JOIN  AV6666 V1 on V1.DivisionID = AV4301.DivisionID AND V1.SelectionType = ''' + @Group1 + ''' AND V1.SelectionID = AV4301.' + @Group1ID + '' ELSE '' end) 
 + (CASE WHEN @Group2 != '' THEN ' LEFT JOIN  AV6666 V2 on V2.DivisionID = AV4301.DivisionID AND V2.SelectionType = ''' + @Group2 + ''' AND V2.SelectionID = AV4301.' + @Group2ID + '' ELSE '' end) 
 + (CASE WHEN @Group3 != '' THEN ' LEFT JOIN  AV6666 V3 on V3.DivisionID = AV4301.DivisionID AND V3.SelectionType = ''' + @Group3 + ''' AND	V3.SelectionID = AV4301.' + @Group3ID + '' ELSE '' end) 
 + '
LEFT JOIN AV0331 on (AV0331.DivisionID = AV4301.DivisionID AND AV0331.ObjectID = AV4301.ObjectID AND AV0331.AccountID = AV4301.AccountID AND AV0331.CurrencyIDCN = AV4301.CurrencyIDCN 
				' + (CASE WHEN @Group1 != '' THEN ' AND AV0331.Group1ID = V1.SelectionID ' ELSE '' END ) + '
				' + (CASE WHEN @Group2 != '' THEN ' AND AV0331.Group2ID = V2.SelectionID ' ELSE '' END ) + '
				' + (CASE WHEN @Group3 != '' THEN ' AND AV0331.Group3ID = V3.SelectionID ' ELSE '' END ) + '
				' + (CASE WHEN @Filter1 != '' THEN ' AND AV0331.Filter1 = AV4301.Filter1 ' ELSE '' end) + '
				' + (CASE WHEN @Filter2 != '' THEN ' AND AV0331.Filter2 = AV4301.Filter2 ' ELSE '' end) + '
				' + (CASE WHEN @Filter3 != '' THEN ' AND AV0331.Filter3 = AV4301.Filter3 ' ELSE '' end) + ')
LEFT JOIN AT1202 AS T02 on T02.ObjectID = AV4301.ObjectID AND T02.DivisionID = AV4301.DivisionID
LEFT JOIN AT1005 AS T05 on T05.AccountID = AV4301.AccountID AND T05.DivisionID = AV4301.DivisionID
WHERE	AV4301.DivisionID = ''' + @DivisionID + ''' AND 
		(AV4301.AccountID between ''' + @FromAccID + ''' AND ''' + @ToAccID + ''') AND
		T05.GroupID = ''G04'' AND
		(T02.ObjectID between ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''')  AND
		AV4301.CurrencyIDCN like ''' + @CurrencyID + ''' AND
		' + @sWHERE + '

GROUP BY ' + (CASE WHEN @Group1 != '' THEN '	V1.SelectionID, 	V1.SelectionName, ' ELSE '' end) +
		(CASE WHEN @Group2 != '' THEN '	V2.SelectionID, 	V2.SelectionName, ' ELSE '' end) +
		(CASE WHEN @Group3 != '' THEN '	V3.SelectionID, 	V3.SelectionName, ' ELSE '' end) + '
		' + @sGROUPBY 
   End

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

