IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0305]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0305]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

------ Created by Nguyen Van Nhan, Date 10/02/2004
------ Chuyen doi nguyen te cong no
------ Edit by Nguyen Quoc Huy, 
---- Modified on 24/11/2011 by Le Thi Thu Hien : Chinh sua where ngay
---- Modified on 08/02/2012 by Le Thi Thu Hien : Bo sung them JOIN DivisionID

/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/


CREATE PROCEDURE [dbo].[AP0305] 	
					@DivisionID nvarchar(50),
					@TranMonth AS int,
					@TranYear AS int,					
					@FromObjectID  nvarchar(50),			
					@ToObjectID  nvarchar(50),			
					@AccountID  nvarchar(50),
					@CurrencyID  nvarchar(50),
					@VoucherTypeID AS nvarchar(50),
					@IsTime AS Tinyint,		
					@FromDate AS datetime,
					@ToDate AS datetime

 AS

Declare @sSQL AS nvarchar(4000),
	@sSQL1 AS nvarchar(4000),
	@sSQL2 AS nvarchar(4000),
	@TypeDate AS nvarchar(50)

SET @sSQL='
SELECT		VoucherID,	
			TableID,
			BatchID,	
			VoucherTypeID, 
			VoucherNo,
			InvoiceNo,
			Serial,
			InvoiceDate,
			VoucherDate,
			D3.CurrencyID,
			ExchangeRate,
			'''+@AccountID+''' AS AccountID,
			 ''D''  AS D_C,
			D3.ObjectID,	
			(Case when IsUpdateName  = 1 then  VATObjectName ELSE ObjectName end) AS ObjectName,
			(Case when IsUpdateName  = 1 then  D3.VATNo ELSE AT1202.VATNo end) AS VATNo, 
			sum(OriginalAmount) AS OriginalAmount,
			sum(ConvertedAmount) AS ConvertedAmount,
			DueDate,
			BDescription ,	
			CurrencyIDCN,
			ExchangeRateCN,
			Status,
			D3.DivisionID,TranMonth,TranYear,
			sum(OriginalAmountCN) AS OriginalAmountCN
	
FROM		AT9000 D3 
INNER JOIN	AT1202	 
	ON 		AT1202.ObjectID = D3.ObjectID AND AT1202.DivisionID = D3.DivisionID
WHERE		D3.DivisionID = '''+@DivisionID+''' AND
			TranMonth ='+str(@TranMonth)+' AND
			TranYear ='+str(@TranYear)+' AND	
			Status=0 AND
			D3.CurrencyID like '''+@CurrencyID+''' AND
			isnull(VoucherTypeID,'''')  like '''+@VoucherTypeID+''' AND
			( DebitAccountID = ''' + @AccountID +''' )  '

IF @FromObjectID <> '%'
	SET @sSQL = @sSQL +' AND D3.ObjectID >= '''+@FromObjectID + ''' AND D3.ObjectID <= ''' +@ToObjectID + ''''


IF @IsTime=1
	SET @TypeDate ='CONVERT(nvarchar(10),InvoiceDate,101)'
ELSE IF @IsTime=2 
	SET @TypeDate='CONVERT(nvarchar(10),VoucherDate,101)'

IF @IsTime <> 0
	SET @sSQL = @sSQL  + ' AND '+@TypeDate+' >= '''+convert(nvarchar(10),@FromDate,101)+'''  AND '+@TypeDate+' <= '''+convert(nvarchar(10),@ToDate,101)+''''



SET @sSQL = @sSQL + ' 
GROUP  BY   TableID, BatchID,  
			VoucherTypeID, VoucherID, VoucherNo, VoucherDate, 
			D3.CurrencyID,ExchangeRate,
			D3.ObjectID, ObjectName, IsUpdateName, VATObjectName, DueDate,	AT1202.VATNo, D3.VATNo,
			D3.DivisionID,D3.TranMonth,D3.TranYear,
			ExchangeRateCN,
			InvoiceNo,
			Serial, Status,	CurrencyIDCN,
			InvoiceDate, BDescription'

SET @sSQL1 = ' 
UNION ALL 
SELECT		VoucherID,	
			TableID,
			BatchID,	
			VoucherTypeID, 
			VoucherNo,
			InvoiceNo,
			Serial,
			InvoiceDate,
			VoucherDate,
			D3.CurrencyID,
			ExchangeRate,
			'''+@AccountID+''' AS AccountID,
			 ''C''  AS D_C,
			D3.ObjectID,	
			(Case when IsUpdateName  = 1 then  VATObjectName ELSE ObjectName end) AS ObjectName,
			(Case when IsUpdateName  = 1 then  D3.VATNo ELSE AT1202.VATNo end) AS VATNo,	
			sum(OriginalAmount) AS OriginalAmount,
			sum(ConvertedAmount) AS ConvertedAmount,
			DueDate,
			BDescription ,	
			CurrencyIDCN,
			ExchangeRateCN,
			Status,
			D3.DivisionID,TranMonth,TranYear,
			sum(OriginalAmountCN) AS OriginalAmountCN
	
FROM		AT9000 D3 
INNER JOIN	AT1202	 
	ON 		AT1202.ObjectID = D3.ObjectID	AND AT1202.DivisionID = D3.DivisionID
WHERE		D3.DivisionID = '''+@DivisionID+''' AND
			TranMonth ='+str(@TranMonth)+' AND
			TranYear ='+str(@TranYear)+' AND	
			Status=0 AND
			D3.CurrencyID like '''+@CurrencyID+''' AND
			isnull(VoucherTypeID,'''')  like '''+@VoucherTypeID+''' AND
			( CreditAccountID = ''' + @AccountID +''' )  '


IF @FromObjectID <> '%'
	SET @sSQL1 = @sSQL1 +' AND D3.ObjectID >= '''+@FromObjectID + ''' AND D3.ObjectID <= ''' +@ToObjectID + ''''


IF @IsTime=1
	SET @TypeDate ='CONVERT(nvarchar(10),InvoiceDate,101)'
ELSE IF @IsTime=2 
	SET @TypeDate='CONVERT(nvarchar(10),VoucherDate,101)'

IF @IsTime <> 0
	SET @sSQL1 = @sSQL1  + ' AND '+@TypeDate+' >= '''+convert(nvarchar(10),@FromDate,101)+'''  AND '+@TypeDate+' <= '''+convert(nvarchar(10),@ToDate,101)+''''


SET @sSQL1 = @sSQL1 + ' 
GROUP  BY   TableID, BatchID,  VoucherTypeID, 
			VoucherID, VoucherNo, VoucherDate, D3.CurrencyID,ExchangeRate, 
			D3.ObjectID, ObjectName, 
			IsUpdateName, VATObjectName,  AT1202.VATNo, DueDate,	D3.VATNo ,
			D3.DivisionID,D3.TranMonth,D3.TranYear,
			ExchangeRateCN,
			InvoiceNo,
			Serial, Status,	CurrencyIDCN,
			InvoiceDate, BDescription'
-------------- Union them voi Phat sinh Co (CreditObject) cua but toan tong hop

SET @sSQL2 = ' 
UNION ALL 
SELECT		VoucherID,	
			TableID,
			BatchID,	
			VoucherTypeID, 
			VoucherNo,
			InvoiceNo,
			Serial,
			InvoiceDate,
			VoucherDate,
			D3.CurrencyID,
			ExchangeRate,
			'''+@AccountID+''' AS AccountID,
			 ''C''  AS D_C,
			D3.CreditObjectID AS ObjectID,	
			(Case when IsUpdateName  = 1 then  VATObjectName ELSE ObjectName end) AS ObjectName,
			(Case when IsUpdateName  = 1 then  D3.VATNo ELSE AT1202.VATNo end) AS VATNo,	
			sum(OriginalAmount) AS OriginalAmount,
			sum(ConvertedAmount) AS ConvertedAmount,
			DueDate,
			BDescription ,	
			CurrencyIDCN,
			ExchangeRateCN,
			Status,
			D3.DivisionID,TranMonth,TranYear,
			sum(OriginalAmountCN) AS OriginalAmountCN
			
FROM		AT9000 D3 
INNER JOIN	AT1202	 
	ON 		AT1202.ObjectID = D3.CreditObjectID	AND AT1202.DivisionID = D3.DivisionID
WHERE		D3.DivisionID = '''+@DivisionID+''' AND
			TranMonth ='+str(@TranMonth)+' AND
			TranYear ='+str(@TranYear)+' AND	
			Status=0 AND
			D3.CurrencyID like '''+@CurrencyID+''' AND
			D3.TransactionTypeID =''T99'' AND
			isnull(VoucherTypeID,'''')  like '''+@VoucherTypeID+''' AND
			( CreditAccountID = ''' + @AccountID +''' )  '


IF @FromObjectID <> '%'
	SET @sSQL2 = @sSQL2 +' AND D3.CreditObjectID >= '''+@FromObjectID + ''' AND D3.CreditObjectID <= ''' +@ToObjectID + ''''


IF @IsTime=1
	SET @TypeDate ='CONVERT(nvarchar(10),InvoiceDate,101)'
ELSE IF @IsTime=2 
	SET @TypeDate='CONVERT(nvarchar(10),VoucherDate,101)'

IF @IsTime <> 0
	SET @sSQL2 = @sSQL2  + ' AND '+@TypeDate+' >= '''+convert(nvarchar(10),@FromDate,101)+'''  AND '+@TypeDate+' <= '''+convert(nvarchar(10),@ToDate,101)+''''


SET @sSQL2 = @sSQL2 + ' 
GROUP  BY   TableID, BatchID,  
			VoucherTypeID, VoucherID, VoucherNo, VoucherDate, 
			D3.CurrencyID,ExchangeRate, 
			D3.CreditObjectID , ObjectName, 
			IsUpdateName, VATObjectName,  AT1202.VATNo, DueDate,	D3.VATNo ,
			D3.DivisionID,D3.TranMonth,D3.TranYear,
			ExchangeRateCN,
			InvoiceNo,
			Serial, Status,	CurrencyIDCN,
			InvoiceDate, BDescription'


IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0305]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
     EXEC ('  CREATE VIEW AV0305 AS ' + @sSQL + @sSQL1 + @sSQL2)
ELSE
     EXEC ('  ALTER VIEW AV0305  AS ' + @sSQL + @sSQL1 + @sSQL2)


---Print @sSQL

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

