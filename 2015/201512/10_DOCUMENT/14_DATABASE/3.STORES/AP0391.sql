IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0391]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0391]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



---- Created by Van Nhan, Date 19/06/2009
----- purpose: so du cong no
----Last Edit : Thuy Tuyen, date 12/09/2208

---xu ly tam de viet code....
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/
---- Modified on 21/05/2013 by Le Thi Thu Hien : Bo sung but toan tong hop

CREATE PROCEDURE [dbo].[AP0391] 	
			@DivisionID AS nvarchar(50),
			@ReportDate AS Datetime,
			@FromAccountID AS nvarchar(50),
			@ToAccountID AS nvarchar(50),
			@FromObjectID AS nvarchar(50),
			@ToObjectID AS nvarchar(50),
			@CurrencyID AS nvarchar(50),
			@IsGroup AS tinyint,
			@GroupID AS nvarchar(50)
					
 AS
Declare @sSQL AS nvarchar(MAX),
		@sSQL1 AS nvarchar(MAX),
		@sSQLFROM AS nvarchar(MAX),
		@Month AS int,
		@Year AS int,
		@Period01 AS int,
		@GroupIDField AS nvarchar(50),
		@SQLGroup AS nvarchar(50)
	
SET nocount off
--Delete AT0393
SET @Month = month(@ReportDate)
SET @Year = year(@ReportDate)
--------- So du No dau ky-----------------------------------------------------------------

If @IsGroup = 1
Begin
	SET @GroupIDField =  (SELECT Case @GroupID when  'A01'  then 'Ana01ID'
					   when 'O01' then 'O01ID'   when 'O02' then 'O02ID'   when 'O03' then 'O03ID'   when 'O04' then 'O04ID' 
					   when 'O05' then 'O05ID'   End)

	SET @SQLGroup = ',' + @GroupIDField
End

Else 

Begin
   SET     @GroupIDField   =  ''''''''''
   SET   @SQLGroup = ''
End

--Print @SQLGroup


SET @sSQL='
SELECT 
	AT9000.ObjectID , Ana01ID , VoucherID, TableID, batchID, CurrencyIDCN, DebitAccountID AS AccountID, DivisionID,	
	BeginDebitAmount =SUM(ISNULL(OriginalAmountCN,0))
	 -
	 ISNULL((SELECT SUM(ISNULL(OriginalAmount,0)) FROM AT0303 
									WHERE 	DivisionID = AT9000.DivisionID AND
										Month(CreditVoucherDate)+100*Year(CreditVoucherDate)<'+str(@Month)+'+'+str(@Year)+'*100 AND
										At0303.ObjectID = AT9000.ObjectID AND
										DebitVoucherID = AT9000.VoucherID AND
										DebitBatchID = AT9000.BatchID AND
										DebitTableID = At9000.TableID AND
										AT0303.AccountID = AT9000.DebitAccountID AND
										CurrencyID = AT9000.CurrencyIDCN),0),
	
	BeginDebitConAmount =SUM(ISNULL(ConvertedAmount,0))
	 -
	 ISNULL((SELECT SUM(ISNULL(ConvertedAmount,0)) FROM AT0303 
									WHERE 	DivisionID = AT9000.DivisionID AND
										Month(CreditVoucherDate)+100*Year(CreditVoucherDate)<'+str(@Month)+'+'+str(@Year)+'*100 AND
									    AT0303.ObjectID = AT9000.ObjectID AND
										DebitVoucherID = AT9000.VoucherID AND
										DebitBatchID = AT9000.BatchID AND
										DebitTableID = At9000.TableID AND
										AT0303.AccountID = AT9000.DebitAccountID AND
										CurrencyID = AT9000.CurrencyIDCN),0),

	0 AS BeginCreditAmount,
	0 AS BeginCreditConAmount
FROM  AT9000  

WHERE 	DebitAccountID between '''+@FromAccountID+''' AND '''+@ToAccountID+''' AND
		AT9000.ObjectID  between '''+@FromObjectID+''' AND '''+@ToObjectID+''' AND
		TranMonth + TranYear*100 < '+str(@Month)+'+100*'+str(@Year)+'
		and AT9000.CurrencyIDCN like '''+@CurrencyID+'''
GROUP BY AT9000.ObjectID,  VoucherID, TableID, batchID, CurrencyIDCN, DebitAccountID , DivisionID,  Ana01ID 
UNION ALL
SELECT 
	AT9000.ObjectID, Ana01ID  , VoucherID, TableID, batchID, CurrencyIDCN, CreditAccountID AS AccountID, DivisionID,
	0 AS BeginDebitAmount,
	0 AS BeginDebitConAmount,

	BeginCreditAmount =SUM(ISNULL(OriginalAmountCN,0))
	 -
	 ISNULL((SELECT SUM(ISNULL(OriginalAmount,0)) FROM AT0303 
									WHERE 	DivisionID = AT9000.DivisionID AND
										Month(DebitVoucherDate)+100*Year(DebitVoucherDate)<'+str(@Month)+'+'+str(@Year)+'*100 AND
										AT0303.ObjectID = AT9000.ObjectID AND
										CreditVoucherID = AT9000.VoucherID AND
										CreditBatchID = AT9000.BatchID AND
										CreditTableID = At9000.TableID AND
										AT0303.AccountID = AT9000.CreditAccountID AND
							CurrencyID = AT9000.CurrencyIDCN),0),
	BeginCreditConAmount =SUM(ISNULL(ConvertedAmount,0))
	 -
	 ISNULL((SELECT SUM(ISNULL(ConvertedAmount,0)) FROM AT0303 
									WHERE 	DivisionID = AT9000.DivisionID AND
										Month(DebitVoucherDate)+100*Year(DebitVoucherDate)<'+str(@Month)+'+'+str(@Year)+'*100 AND
										AT0303.ObjectID = AT9000.ObjectID AND
										CreditVoucherID = AT9000.VoucherID AND
										CreditBatchID = AT9000.BatchID AND
										CreditTableID = At9000.TableID AND
										AT0303.AccountID = AT9000.CreditAccountID AND
										CurrencyID = AT9000.CurrencyIDCN),0)
	
	
FROM  AT9000 

WHERE 	CreditAccountID between '''+@FromAccountID+''' AND '''+@ToAccountID+''' AND
		AT9000.ObjectID  between '''+@FromObjectID+''' AND '''+@ToObjectID+''' AND
		TranMonth + TranYear*100 < '+str(@Month)+'+100*'+str(@Year)+'
		and AT9000.CurrencyIDCN like '''+@CurrencyID+'''
GROUP BY AT9000.ObjectID,  VoucherID, TableID, batchID, CurrencyIDCN, CreditAccountID , DivisionID,  Ana01ID  '

-------------AT9090 But toan tong hop
SET @sSQL1='
UNION ALL
SELECT 
	AT9000.ObjectID , Ana01ID , VoucherID, 
	''AT9090'' AS TableID, TransactionID AS BatchID, 
	CurrencyID AS CurrencyIDCN, DebitAccountID AS AccountID, 
	DivisionID,	
	BeginDebitAmount =SUM(ISNULL(OriginalAmount,0))
	 -
	 ISNULL((SELECT SUM(ISNULL(OriginalAmount,0)) 
	        FROM AT0303 
			WHERE 	DivisionID = AT9000.DivisionID AND
					Month(CreditVoucherDate)+100*Year(CreditVoucherDate)<'+str(@Month)+'+'+str(@Year)+'*100 AND
					At0303.ObjectID = AT9000.ObjectID AND
					DebitVoucherID = AT9000.VoucherID AND
					DebitBatchID = AT9000.VoucherID AND
					DebitTableID = ''AT9090'' AND
					AT0303.AccountID = AT9000.DebitAccountID AND
					CurrencyID = AT9000.CurrencyID),0),
	
	BeginDebitConAmount =SUM(ISNULL(ConvertedAmount,0))
	 -
	 ISNULL((SELECT SUM(ISNULL(ConvertedAmount,0)) 
	        FROM AT0303 
			WHERE 	DivisionID = AT9000.DivisionID AND
					Month(CreditVoucherDate)+100*Year(CreditVoucherDate)<'+str(@Month)+'+'+str(@Year)+'*100 AND
				    AT0303.ObjectID = AT9000.ObjectID AND
					DebitVoucherID = AT9000.VoucherID AND
					DebitBatchID = AT9000.VoucherID AND
					DebitTableID = ''AT9090'' AND
					AT0303.AccountID = AT9000.DebitAccountID AND
					CurrencyID = AT9000.CurrencyID),0),

	0 AS BeginCreditAmount,
	0 AS BeginCreditConAmount
FROM  AT9090 AT9000  

WHERE 	DebitAccountID between '''+@FromAccountID+''' AND '''+@ToAccountID+''' AND
		AT9000.ObjectID  between '''+@FromObjectID+''' AND '''+@ToObjectID+''' AND
		TranMonth + TranYear*100 < '+str(@Month)+'+100*'+str(@Year)+'
		and AT9000.CurrencyID like '''+@CurrencyID+'''
GROUP BY AT9000.ObjectID,  VoucherID, TransactionID, CurrencyID, DebitAccountID , DivisionID,  Ana01ID 

UNION ALL

SELECT 
	AT9000.ObjectID, Ana01ID  , VoucherID, 
	''AT9090'' AS TableID, TransactionID AS BatchID, 
	CurrencyID AS CurrencyIDCN, 
	CreditAccountID AS AccountID, DivisionID,
	0 AS BeginDebitAmount,
	0 AS BeginDebitConAmount,

	BeginCreditAmount =SUM(ISNULL(OriginalAmount,0))
	 -
	 ISNULL((SELECT SUM(ISNULL(OriginalAmount,0)) FROM AT0303 
									WHERE 	DivisionID = AT9000.DivisionID AND
										Month(DebitVoucherDate)+100*Year(DebitVoucherDate)<'+str(@Month)+'+'+str(@Year)+'*100 AND
										AT0303.ObjectID = AT9000.ObjectID AND
										CreditVoucherID = AT9000.VoucherID AND
										CreditBatchID = AT9000.VoucherID AND
										CreditTableID = ''AT9090'' AND
										AT0303.AccountID = AT9000.CreditAccountID AND
							CurrencyID = AT9000.CurrencyID),0),
	BeginCreditConAmount =SUM(ISNULL(ConvertedAmount,0))
	 -
	 ISNULL((SELECT SUM(ISNULL(ConvertedAmount,0)) FROM AT0303 
									WHERE 	DivisionID = AT9000.DivisionID AND
										Month(DebitVoucherDate)+100*Year(DebitVoucherDate)<'+str(@Month)+'+'+str(@Year)+'*100 AND
										AT0303.ObjectID = AT9000.ObjectID AND
										CreditVoucherID = AT9000.VoucherID AND
										CreditBatchID = AT9000.VoucherID AND
										CreditTableID = ''AT9090'' AND
										AT0303.AccountID = AT9000.CreditAccountID AND
										CurrencyID = AT9000.CurrencyID),0)
	
	
FROM  AT9090 AT9000 

WHERE 	CreditAccountID between '''+@FromAccountID+''' AND '''+@ToAccountID+''' AND
		AT9000.ObjectID  between '''+@FromObjectID+''' AND '''+@ToObjectID+''' AND
		TranMonth + TranYear*100 < '+str(@Month)+'+100*'+str(@Year)+'
		AND AT9000.CurrencyID like '''+@CurrencyID+'''
		
GROUP BY AT9000.ObjectID,  VoucherID,  TransactionID, CurrencyID, CreditAccountID , DivisionID,  Ana01ID  '
--PRINT(@sSQL)
--PRINT(@sSQL1)
IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0397]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
    EXEC ('  CREATE VIEW AV0397 	--CREATED BY AP0393
				AS ' + @sSQL +@sSQL1)
ELSE
	EXEC ('  ALTER VIEW AV0397  	--CREATED BY AP0393
				AS ' + @sSQL +@sSQL1)
 

SET @sSQL =' 
SELECT 	AV0397.ObjectID, '+@GroupIDField+'  AS  GroupID  ,  AV0397.VoucherID, AV0397.TableID, 
		AV0397.batchID, AV0397.CurrencyIDCN, AV0397.AccountID, AV0397.DivisionID, 
		SUM(ISNULL(AV0397.BeginDebitAmount,0)) AS BeginDebitAmount  , SUM(ISNULL(AV0397.BeginDebitConAmount,0)) AS BeginDebitConAmount , 
		SUM(ISNULL(AV0397.BeginCreditAmount,0)) AS BeginCreditAmount  , SUM(ISNULL(AV0397.BeginCreditConAmount,0)) AS BeginCreditConAmount

FROM	AV0397  
INNER JOIN AT1202 on AT1202.ObjectID = AV0397.ObjectID AND AT1202.DivisionID = AV0397.DivisionID 
GROUP BY   AV0397.ObjectID ,  AV0397.VoucherID, AV0397.TableID, 
			AV0397.batchID, AV0397.CurrencyIDCN, AV0397.AccountID, AV0397.DivisionID '

--print @sSQL
--print @GroupIDField
SET @sSQL =  @sSQL + @SQLGroup

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0391]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
	EXEC ('  CREATE VIEW AV0391 	--CREATED BY AP0393
		AS ' + @sSQL )
ELSE
	EXEC ('  ALTER VIEW  AV0391 	--CREATED BY AP0393
		AS ' + @sSQL )





---PRINT   @sSQL
--Print @GroupIDField




IF   @IsGroup  = 1 

	INSERT AT0393 (	DivisionID, ObjectID,   GroupID ,   
					BeginDebitAmount, BeginCreditAmount,   
					BeginDebitConAmount, BeginCreditConAmount)
	SELECT	DivisionID, ObjectID,  GroupID, 
			SUM(BeginDebitAmount), SUM(BeginCreditAmount), 
			SUM(BeginDebitConAmount), SUM(BeginCreditConAmount)
	FROM	AV0391
	WHERE	BeginDebitAmount<>0 
			or BeginCreditAmount<>0 
			or  BeginDebitConAmount<>0 
			or BeginCreditConAmount<>0
	GROUP BY DivisionID,ObjectID, GroupID 

ELSE 

	INSERT AT0393 (	DivisionID, ObjectID, 
					BeginDebitAmount, BeginCreditAmount,  
					BeginDebitConAmount , BeginCreditConAmount)
	SELECT	DivisionID, ObjectID,  
			SUM(BeginDebitAmount), SUM(BeginCreditAmount),  
			SUM(BeginDebitConAmount), SUM(BeginCreditConAmount)
	FROM	AV0391
	WHERE	BeginDebitAmount<>0 
			or BeginCreditAmount<>0 
			or  BeginDebitConAmount<>0 
			or BeginCreditConAmount<>0
	GROUP BY DivisionID,ObjectID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

