IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0331]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0331]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-----Created by Nguyen Thi Ngoc Minh, Date 11/09/2004
-----Len so du cong no phai tra tu TK->TK, tu DT->DT, Ma phan tich
---- Modified on 13/02/2012 by Le Thi Thu Hien : Bo sung them JOIN DivisionID
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [28/07/2010]
'**************************************************************/

CREATE PROCEDURE  [dbo].[AP0331] 
			@DivisionID AS nvarchar(50), 
			@FromObjectID AS  nvarchar(50),  
			@ToObjectID AS  nvarchar(50),  
			@FromAccountID AS nvarchar(50),
			@ToAccountID AS nvarchar(50),  
			@CurrencyID nvarchar(50),  
			@FromMonth AS int, 
			@FromYear AS int, 			
			@FromDate AS Datetime, 		
			@IsMonth AS tinyint,
			@TypeDate AS nvarchar(50),
			@Group1 AS nvarchar(50),
			@Group2 AS nvarchar(50),	
			@Group3 AS nvarchar(50),	
			@Filter1 AS nvarchar(50),
			@Filter2 AS nvarchar(50),
			@Filter3 AS nvarchar(50)

AS

Declare @sSQL AS nvarchar(4000),
		@sSQLfrom AS nvarchar(4000),
		@sSELECT AS varchar(2000),
		@sGROUPBY AS varchar(2000),
		@Filter1ID AS nvarchar(250),
		@Filter2ID AS nvarchar(250),
		@Filter3ID AS nvarchar(250),
		@Group1ID AS nvarchar(50),
		@Group2ID AS nvarchar(50),
		@Group3ID AS nvarchar(50)

Set @sSELECT = ''
Set @sGROUPBY = ''

If @Group1 != ''
Exec AP4700  @Group1,	@Group1ID OUTPUT

If @Group2 != ''
Exec AP4700  @Group2,	@Group2ID OUTPUT

If @Group3 != ''
Exec AP4700  @Group3,	@Group3ID OUTPUT

If @Filter1 != ''
  Begin
	Exec AP4700  @Filter1,	@Filter1ID OUTPUT
	SET @sSELECT = @sSELECT +' AV4202.' + @Filter1ID + ' AS Filter1, '
	SET @sGROUPBY = @sGROUPBY +', AV4202.' + @Filter1ID  
  End

If @Filter2 != ''
  Begin
	Exec AP4700  @Filter2,	@Filter2ID OUTPUT
	SET @sSELECT = @sSELECT +' AV4202.' + @Filter2ID + ' AS Filter2, '
	SET @sGROUPBY = @sGROUPBY +', AV4202.' + @Filter2ID
  End

If @Filter3 != ''
  Begin
	Exec AP4700  @Filter3,	@Filter3ID OUTPUT
	SET @sSELECT = @sSELECT +' AV4202.' + @Filter3ID + ' AS Filter3, '
	SET @sGROUPBY = @sGROUPBY +', AV4202.' + @Filter3ID 
  End

If @IsMonth = 1  ---- Xac dinh theo ky	
	Begin
Set @sSQL =' 
SELECT '+ (CASE WHEN @Group1 != '' then '	V1.SelectionID AS  Group1ID, V1.SelectionName AS Group1Name, ' else '' end) 
		+ (CASE WHEN @Group2 != '' then '	V2.SelectionID AS  Group2ID, V2.SelectionName AS Group2Name, ' else '' end) 
 		+ (CASE WHEN @Group3 != '' then '	V3.SelectionID AS  Group3ID, V3.SelectionName AS Group3Name, ' else '' end)  + '
		' + @sSELECT  + '
		AV4202.ObjectID, AV4202.AccountID, 
		CurrencyIDCN,
		AT1202.ObjectName AS ObjectName,
		Sum(isnull(ConvertedAmount,0)) AS OpeningConvertedAmount,
		Sum(isnull(OriginalAmount,0)) AS OpeningOriginalAmount,
		AV4202.DivisionID '
		

Set @sSQLfrom =' 
FROM	AV4202 
'+ (CASE WHEN @Group1 != '' then '	 LEFT JOIN  AV6666 V1 on V1.DivisionID = AV4301.DivisionID AND V1.SelectionType =''' + @Group1 + ''' and V1.SelectionID = AV4202.' + @Group1ID + '' else '' end) 
 + (CASE WHEN @Group2 != '' then '	 LEFT JOIN  AV6666 V2 on V2.DivisionID = AV4301.DivisionID AND V2.SelectionType =''' + @Group2 + ''' and V2.SelectionID = AV4202.' + @Group2ID + '' else '' end) 
 + (CASE WHEN @Group3 != '' then '	 LEFT JOIN  AV6666 V3 on V3.DivisionID = AV4301.DivisionID AND V3.SelectionType =''' + @Group3 + ''' and V3.SelectionID = AV4202.' + @Group3ID + '' else '' end) 
 + '
INNER JOIN AT1202 on AT1202.ObjectID = AV4202.ObjectID AND AT1202.DivisionID = AV4202.DivisionID
WHERE 	AV4202.DivisionID = '''+@DivisionID+''' and
		( (AV4202.TranMonth + AV4202.TranYear*100< '+str(@FromMonth)+' + 100*'+str(@FromYear)+')  
		or (AV4202.TranMonth + AV4202.TranYear*100= '+str(@FromMonth)+' + 100*'+str(@FromYear)+' and AV4202.TransactionTypeID =''T00'' ) )  and
		(AV4202.ObjectID between  ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''')  and
		(AV4202.AccountID between ''' + @FromAccountID + ''' and ''' + @ToAccountID + ''') and
		AV4202.CurrencyIDCN like '''+@CurrencyID+'''	
GROUP BY AV4202.DivisionID, ' + (CASE WHEN @Group1 != '' then '	V1.SelectionID, 	V1.SelectionName, ' else '' end) +
		(CASE WHEN @Group2 != '' then '	V2.SelectionID, 	V2.SelectionName, ' else '' end) +
		(CASE WHEN @Group3 != '' then '	V3.SelectionID, 	V3.SelectionName, ' else '' end) + '
		AV4202.ObjectID, AV4202.AccountID, AT1202.ObjectName, 
		AV4202.CurrencyIDCN' + @sGROUPBY 
	
	EndELSE
	Begin
Set @sSQL =' 
SELECT '+ (CASE WHEN @Group1 != '' then '	V1.SelectionID AS  Group1ID, V1.SelectionName AS Group1Name, ' else '' end) 
		+ (CASE WHEN @Group2 != '' then '	V2.SelectionID AS  Group2ID, V2.SelectionName AS Group2Name, ' else '' end) 
 		+ (CASE WHEN @Group3 != '' then '	V3.SelectionID AS  Group3ID, V3.SelectionName AS Group3Name, ' else '' end) + '
		' + @sSELECT + '
		AV4202.ObjectID, AV4202.AccountID,
		CurrencyIDCN,
		AT1202.ObjectName,
		Sum(isnull(ConvertedAmount,0)) AS OpeningConvertedAmount,
		sum(isnull(OriginalAmount,0)) AS OpeningOriginalAmount,
		AV4202.DivisionID'
	
Set @sSQLfrom ='
FROM AV4202 
'+ (CASE WHEN @Group1 != '' then '	 LEFT JOIN  AV6666 V1 on V1.DivisionID = AV4301.DivisionID AND V1.SelectionType =''' + @Group1 + ''' and V1.SelectionID = AV4202.' + @Group1ID + '' else '' end) 
 + (CASE WHEN @Group2 != '' then '	 LEFT JOIN  AV6666 V2 on V2.DivisionID = AV4301.DivisionID AND V2.SelectionType =''' + @Group2 + ''' and V2.SelectionID = AV4202.' + @Group2ID + '' else '' end) 
 + (CASE WHEN @Group3 != '' then '	 LEFT JOIN  AV6666 V3 on V3.DivisionID = AV4301.DivisionID AND V3.SelectionType =''' + @Group3 + ''' and V3.SelectionID = AV4202.' + @Group3ID + '' else '' end) 
			+ '
INNER JOIN AT1202 on AT1202.ObjectID = AV4202.ObjectID AND AT1202.DivisionID = AV4202.DivisionID
WHERE 	AV4202.DivisionID = '''+@DivisionID+''' and
		( ' + ltrim(Rtrim(@TypeDate)) + ' < ''' + convert(nvarchar(10),@FromDate,101) + ''' or 
			 TransactionTypeID = ''T00'') and
		(AV4202.ObjectID between  ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''')  and
		(AV4202.AccountID between ''' + @FromAccountID + ''' and ''' + @ToAccountID + ''') and
		AV4202.CurrencyIDCN like '''+@CurrencyID+'''	
GROUP BY AV4202.DivisionID, ' + (CASE WHEN @Group1 != '' then '	V1.SelectionID, 	V1.SelectionName, ' else '' end) +
		(CASE WHEN @Group2 != '' then '	V2.SelectionID, 	V2.SelectionName, ' else '' end) +
		(CASE WHEN @Group3 != '' then '	V3.SelectionID, 	V3.SelectionName, ' else '' end) + '
		AV4202.ObjectID, AV4202.AccountID, AT1202.ObjectName, 
		AV4202.CurrencyIDCN' + @sGROUPBY 
	End	

--print @sSQL

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0331]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
	EXEC ('  CREATE VIEW AV0331 	--CREATED BY AP0331
		AS ' + @sSQL +  @sSQLfrom)
ELSE
	EXEC ('  ALTER VIEW AV0331  	--CREATED BY AP0331
			AS ' + @sSQL +  @sSQLfrom)











GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

