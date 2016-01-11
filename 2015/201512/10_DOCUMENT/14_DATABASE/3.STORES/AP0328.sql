IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0328]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0328]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Tinh toan so du theo mat hang
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----- Created by Nguyen Van  Nhan, Date 12/02/2004
---
---- Edited by Nguyen Thi Ngoc Minh
---- Modified on 06/12/2011 by Le Thi Thu Hien : Sua ngay CONVERT(varchar(10),VoucherDate,101)
---- Modified on 16/01/2012 by Le Thi Thu Hien : CONVERT ngay
---- Modified on 06/06/2013 by Le Thi Thu Hien : SELECT trực tiếp không lấy từ View AV4202
---- Modified on 14/08/2013 by Le Thi Thu Hien : Lấy số dư đầu kỳ không where theo InventoryID
---- Modified on 09/09/2013 by Le Thi Thu Hien : Sửa điều kiện where 
-- <Example>
---- 

CREATE PROCEDURE [dbo].[AP0328] 
		@DivisionID AS nvarchar(50), 
		@FromObjectID  AS nvarchar(50),  
		@ToObjectID  AS nvarchar(50),  
		@FromAccountID  AS nvarchar(50),  
		@ToAccountID  AS nvarchar(50),  
		@CurrencyID  AS nvarchar(50),  
		@FromInventoryID AS nvarchar(50),
		@ToInventoryID AS nvarchar(50),
		@IsDate AS tinyint, 
		@FromMonth AS int ,
		@FromYear  AS int,  
		@FromDate AS Datetime 
	

AS

DECLARE @sSQL AS nvarchar(MAX),
		@sSQL1 AS NVARCHAR(MAX),
		@sSQL2 AS NVARCHAR(MAX),
		@sWHERE AS NVARCHAR(MAX),
		@TempCurrID AS nvarchar(50)

SET @sWHERE = N'
		AT9000.DivisionID = '''+@DivisionID+'''
		AND AT9000.CurrencyIDCN like '''+ @CurrencyID +'''		
		AND (AT9000.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''	OR ISNULL(AT9000.InventoryID,'''') = '''')	
		'
IF @IsDate = 0
SET @sWHERE = @sWHERE + N'
		AND (	(AT9000.TranMonth + AT9000.TranYear*100 < '+str(@FromMonth)+' + 100*'+str(@FromYear)+' )
				OR (AT9000.TranMonth + AT9000.TranYear*100 = '+str(@FromMonth)+' + 100*'+str(@FromYear)+' 
					AND TransactionTypeID =''T00'' ) )
		'
IF @IsDate = 1
SET @sWHERE = @sWHERE + N'
		AND ( ( CONVERT(DATETIME,CONVERT(varchar(10),AT9000.VoucherDate,101),101) < '''+ CONVERT(NVARCHAR(10),@FromDate,101)+'''  )  
				OR ( CONVERT(DATETIME,CONVERT(varchar(10),AT9000.VoucherDate,101),101) = '''+ CONVERT(NVARCHAR(10),@FromDate,101)+''' 
				AND AT9000.TransactionTypeID =''T00'' ) )
		'

		
----- Xac dinh so du
IF @CurrencyID = '%'
	SET @TempCurrID = '''%'''
ELSE
	SET @TempCurrID = ' AV4202.CurrencyIDCN '
	
SET @sSQL1 = N'
 ---- PHAT SINH NO
SELECT 	AT9000.DivisionID, TranMonth,TranYear, 
		ObjectID, 
		CurrencyIDCN, VoucherDate, InvoiceDate, DueDate,
		AT9000.InventoryID,
		AT9000.DebitAccountID AS AccountID, AT1005.AccountName,
		SUM(ISNULL(ConvertedAmount,0)) AS ConvertedAmount, 
		SUM(ISNULL(OriginalAmountCN,0)) AS OriginalAmount,		
		CreditAccountID AS CorAccountID,   -- tai khoan doi ung
		''D'' AS D_C, TransactionTypeID
FROM	AT9000 
INNER JOIN AT1005 on AT1005.AccountID = AT9000.DebitAccountID and AT1005.DivisionID = AT9000.DivisionID
WHERE	'+@sWHERE+'
		AND AT9000.DebitAccountID IS NOT NULL
		AND AT9000.ObjectID BETWEEN  '''+ @FromObjectID +''' AND '''+ @ToObjectID +''' 
		AND AT1005.GroupID  in (''G03'', ''G04'')
		AND AT9000.DebitAccountID BETWEEN  '''+ @FromAccountID +''' AND '''+ @ToAccountID +'''
			
		
GROUP BY AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear, 
		AT9000.ObjectID, CurrencyIDCN, VoucherDate, InvoiceDate, DueDate, 
		DebitAccountID, AT1005.AccountName,	CreditAccountID, 
		TransactionTypeID, AT9000.InventoryID
			  
UNION ALL
---- PHAT SINH CO , LAY AM
SELECT	
	AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear, 
	(CASE WHEN TransactionTypeID = ''T99'' THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END) AS ObjectID, 
	CurrencyIDCN,VoucherDate, InvoiceDate, DueDate,
	AT9000.InventoryID,
	AT9000.CreditAccountID AS AccountID, AT1005.AccountName,
	SUM(ISNULL(ConvertedAmount,0)*-1) AS ConvertedAmount, 
	SUM(ISNULL(OriginalAmountCN,0)*-1) AS OriginalAmount,	
	DebitAccountID AS CorAccountID, 
	''C'' AS D_C, TransactionTypeID 
FROM AT9000 
INNER JOIN AT1005 on AT1005.AccountID = AT9000.CreditAccountID and AT1005.DivisionID = AT9000.DivisionID
WHERE	'+@sWHERE+'	
		AND AT9000.CreditAccountID IS NOT NULL 
		AND (CASE WHEN TransactionTypeID = ''T99'' THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END) BETWEEN  '''+ @FromObjectID +''' AND '''+ @ToObjectID +''' 
		AND AT1005.GroupID in (''G03'', ''G04'')
		AND AT9000.CreditAccountID BETWEEN  '''+ @FromAccountID +''' AND '''+ @ToAccountID +'''
		
GROUP BY AT9000.DivisionID, TranMonth, TranYear, 
		(CASE WHEN TransactionTypeID = ''T99'' THEN CreditObjectID ELSE ObjectID END),
		CurrencyIDCN, VoucherDate, InvoiceDate, DueDate, 
		CreditAccountID, AT1005.AccountName, DebitAccountID, 
		TransactionTypeID,AT9000.InventoryID
	
'
PRINT(@sSQL1)
IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV03081]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
	EXEC ('  CREATE VIEW AV03081 --AP0328
	 AS ' + @sSQL1)
ELSE
	EXEC ('  ALTER VIEW AV03081   --AP0328
	AS ' + @sSQL1)	
	
-------- Xac dinh so du cong no phai thu 
	SET @sSQL = ' 
		SELECT 	''T00'' AS TransactionTypeID,  AV4202.ObjectID, AV4202.AccountID , 			
				'+@TempCurrID+' AS CurrencyID,
				AT1202.ObjectName ,
				AV4202.AccountName , 
				SUM(ConvertedAmount) AS OpeningConvertedAmount,
				SUM(OriginalAmount) AS OpeningOriginalAmount,
				AV4202.DivisionID
				
		FROM	AV03081 AV4202 	
		INNER JOIN AT1202 on AT1202.ObjectID = AV4202.ObjectID AND AT1202.DivisionID = AV4202.DivisionID
		GROUP BY	AV4202.DivisionID, AV4202.ObjectID,  AV4202.AccountID, 
					AT1202.ObjectName, AV4202.AccountName '
					
		IF @CurrencyID <> '%'
			SET @sSQL = @sSQL +',  AV4202.CurrencyIDCN '

PRINT(@sSQL)
IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0328]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
	EXEC ('  CREATE VIEW AV0328 --AP0328
	 AS ' + @sSQL)
ELSE
	EXEC ('  ALTER VIEW AV0328   --AP0328
	AS ' + @sSQL)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

