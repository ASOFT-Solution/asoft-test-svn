IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0405]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0405]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





------ Created by Nguyen Quoc Huy
------ Created date 24/02/2004
------ Purpose: Chuyen doi nguyen te cong no phai tra
---- Modified on 24/10/2011 by Le Thi Thu Hien : Chinh sua where ngay
---- Modified on 08/11/2011 by Le Thi Thu Hien : Bo phan SQL3
---- Modified on 09/01/2015 by Mai Duyen : Sua Where theo ngay, khong len du lieu
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [28/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP0405] 	
					@DivisionID nvarchar(50),
					@TranMonth AS int,
					@TranYear AS int,					
					@FromObjectID  nvarchar(50),			
					@ToObjectID  nvarchar(50),			
					@AccountID  nvarchar(50),
					@CurrencyID  nvarchar(50),
					@VoucherTypeID AS nvarchar(50),
					@IsTime AS Tinyint,	--- 1 la ngay hoa don
										--- 2 Ngay hach toan	
					@FromDate AS datetime,
					@ToDate AS datetime

AS

Declare 
	@sSQL1 AS nvarchar(4000),
	@sSQL2 AS nvarchar(4000),
	@sSQL3 AS nvarchar(4000),
	@TypeDate AS nvarchar(250),
	@FromPeriod AS int,
	@ToPeriod AS int,
	@SQLwhere AS nvarchar(4000)

SET @sSQL3 = ''
SET @TypeDate = ''
SET @SQLwhere = ''

---PSCo
SET @sSQL1='
SELECT		VoucherID,	
			TableID,
			BatchID,	
			VoucherTypeID, 
			VoucherNo,
			InvoiceNo,
			Serial,
			InvoiceDate,
			VoucherDate,
			D4.CurrencyID,
			ExchangeRate,
			'''+@AccountID+''' AS AccountID,
			 ''C''  AS D_C,
			D4.ObjectID AS ObjectID,	
			(Case when IsUpdateName  = 1 then  VATObjectName ELSE ObjectName end) AS ObjectName,
			(Case when IsUpdateName  = 1 then  D4.VATNo ELSE AT1202.VATNo end) AS VATNo, 
			sum(OriginalAmount) AS OriginalAmount,
			sum(ConvertedAmount) AS ConvertedAmount,
			DueDate,
			BDescription ,	
			CurrencyIDCN,
			ExchangeRateCN,
			Status,
			D4.DivisionID,TranMonth,TranYear,
			sum(OriginalAmountCN) AS OriginalAmountCN
	
FROM		AT9000 D4  
INNER JOIN	AT1202	 
	ON 		AT1202.ObjectID = D4.ObjectID	
	AND		AT1202.DivisionID = D4.DivisionID
WHERE		D4.DivisionID = '''+@DivisionID+''' AND
			TranMonth ='+str(@TranMonth)+' AND
			TranYear ='+str(@TranYear)+' AND	
			Status = 0 AND
			D4.CurrencyID like '''+@CurrencyID+''' AND
			isnull(VoucherTypeID,'''')  like '''+@VoucherTypeID+''' AND

			--( DebitAccountID = ''' + @AccountID +''' ) 
			( CreditAccountID = ''' + @AccountID +''' ) '

IF @FromObjectID <> '%'
	--SET @sSQL1 = @sSQL1 +' AND D4.CreditObjectID >= '''+@FromObjectID + ''' AND D4.CreditObjectID <= ''' +@ToObjectID + ''''
	SET @sSQL1 = @sSQL1 +' AND D4.ObjectID >= '''+@FromObjectID + ''' AND D4.ObjectID <= ''' +@ToObjectID + ''''

IF @IsTime=1
	--SET @TypeDate ='CONVERT(nvarchar(10),InvoiceDate,101)'
	SET @TypeDate =' CONVERT(DateTime,CONVERT(nvarchar(10),InvoiceDate,101),101)'  
ELSE IF @IsTime=2 
	--SET @TypeDate='CONVERT(nvarchar(10),VoucherDate,101)'
	SET @TypeDate =' CONVERT(DateTime,CONVERT(nvarchar(10),VoucherDate,101),101)'  
IF @IsTime <> 0
	SET @sSQL1 = @sSQL1  + ' AND '+@TypeDate+' >= '''+CONVERT(nvarchar(10),@FromDate,101)+'''  AND '+@TypeDate+' <= '''+CONVERT(nvarchar(10),@ToDate,101)+''''

SET @sSQL1 = @sSQL1 + ' 
GROUP  BY   TableID, BatchID,  
			VoucherTypeID, VoucherID, VoucherNo, VoucherDate, 
			D4.CurrencyID,ExchangeRate,
			D4.ObjectID, ObjectName, 
			IsUpdateName, VATObjectName, DueDate,	AT1202.VATNo, D4.VATNo, 
			D4.DivisionID, D4.TranMonth, D4.TranYear,
			ExchangeRateCN,
			InvoiceNo,
			Serial, Status,	CurrencyIDCN,
			InvoiceDate, BDescription'
			
--- Phat sinh no 
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
			D4.CurrencyID,
			ExchangeRate,
			'''+@AccountID+''' AS AccountID,
			 ''D''  AS D_C,
			D4.ObjectID,	
			(Case when IsUpdateName  = 1 then  VATObjectName ELSE ObjectName end) AS ObjectName,
			(Case when IsUpdateName  = 1 then  D4.VATNo ELSE AT1202.VATNo end) AS VATNo,	
			sum(OriginalAmount) AS OriginalAmount,
			sum(ConvertedAmount) AS ConvertedAmount,
			DueDate,
			BDescription ,	
			CurrencyIDCN,
			ExchangeRateCN,
			Status,
			D4.DivisionID,TranMonth,TranYear,
			sum(OriginalAmountCN) AS OriginalAmountCN
	
FROM		AT9000 D4 
INNER JOIN	AT1202	 
	ON 		AT1202.ObjectID = D4.ObjectID
	AND		AT1202.DivisionID = D4.DivisionID
WHERE		D4.DivisionID = '''+@DivisionID+''' AND
			TranMonth ='+str(@TranMonth)+' AND
			TranYear ='+str(@TranYear)+' AND	
			Status=0 AND
			D4.CurrencyID like '''+@CurrencyID+''' AND
			isnull(VoucherTypeID,'''')  like '''+@VoucherTypeID+''' AND
			--( CreditAccountID = ''' + @AccountID +''' )  
			( DebitAccountID = ''' + @AccountID +''' ) '


IF @FromObjectID <> '%'
	SET @sSQL2 = @sSQL2 +' AND D4.ObjectID >= '''+@FromObjectID + ''' AND D4.ObjectID <= ''' +@ToObjectID + ''''
	
IF @IsTime=1
	--SET @TypeDate ='CONVERT(nvarchar(10),InvoiceDate,101)'
	SET @TypeDate =' CONVERT(DateTime,CONVERT(nvarchar(10),InvoiceDate,101),101)'  
ELSE IF @IsTime=2 
	--SET @TypeDate='CONVERT(nvarchar(10),VoucherDate,101)'
	SET @TypeDate =' CONVERT(DateTime,CONVERT(nvarchar(10),VoucherDate,101),101)'  

IF @IsTime <> 0
	SET @sSQL2 = @sSQL2  + ' AND '+@TypeDate+' >= '''+CONVERT(nvarchar(10),@FromDate,101)+'''  AND '+@TypeDate+' <= '''+CONVERT(nvarchar(10),@ToDate,101)+''''

SET @sSQL2 = @sSQL2 + ' 
GROUP  BY   TableID, BatchID,  
			VoucherTypeID, VoucherID, VoucherNo, VoucherDate, 
			D4.CurrencyID,ExchangeRate, 
			D4.ObjectID, ObjectName, 
			IsUpdateName, VATObjectName,  AT1202.VATNo, 
			DueDate,	D4.VATNo ,
			D4.DivisionID,D4.TranMonth,D4.TranYear,
			ExchangeRateCN,
			InvoiceNo,
			Serial, Status,	CurrencyIDCN,
			InvoiceDate, BDescription'
			

----- Phat sinh Co (CreditObject) cua but toan tong hop
SET @sSQL3 = ' 
UNION ALL 

SELECT   VoucherID,	
			TableID,
			BatchID,	
			VoucherTypeID, 
			VoucherNo,
			InvoiceNo,
			Serial,
			InvoiceDate,
			VoucherDate,
			D4.CurrencyID,
			ExchangeRate,
			'''+@AccountID+''' AS AccountID,
			 ''C''  AS D_C,
			D4.CreditObjectID AS ObjectID ,	
			(Case when IsUpdateName  = 1 then  VATObjectName ELSE ObjectName end) AS ObjectName,
			(Case when IsUpdateName  = 1 then  D4.VATNo ELSE AT1202.VATNo end) AS VATNo,	
			sum(OriginalAmount) AS OriginalAmount,
			sum(ConvertedAmount) AS ConvertedAmount,
			DueDate,
			BDescription ,	
			CurrencyIDCN,
			ExchangeRateCN,
			Status,
			D4.DivisionID,TranMonth,TranYear,
			sum(OriginalAmountCN) AS OriginalAmountCN
	
FROM		AT9000 D4 
INNER JOIN	AT1202	 
	ON 		AT1202.ObjectID = D4.CreditObjectID	
WHERE		D4.DivisionID = '''+@DivisionID+''' AND
			TranMonth ='+str(@TranMonth)+' AND
			TranYear ='+str(@TranYear)+' AND	
			Status=0 AND
			D4.CurrencyID like '''+@CurrencyID+''' AND
			D4.TransactionTypeID =''T99'' AND 
			isnull(VoucherTypeID,'''')  like '''+@VoucherTypeID+''' AND
			( CreditAccountID = ''' + @AccountID +''' )  
			 '


IF @FromObjectID <> '%'
	SET @sSQL3 = @sSQL3 +' AND D4.CreditObjectID >= '''+@FromObjectID + ''' AND D4.CreditObjectID <= ''' +@ToObjectID + ''''


IF @IsTime=1
	--SET @TypeDate ='CONVERT(nvarchar(10),InvoiceDate,101)'
	SET @TypeDate =' CONVERT(DateTime,CONVERT(nvarchar(10),InvoiceDate,101),101)'  
ELSE IF @IsTime=2 
	--SET @TypeDate='CONVERT(nvarchar(10),VoucherDate,101)'
	SET @TypeDate =' CONVERT(DateTime,CONVERT(nvarchar(10),VoucherDate,101),101)'  
	
	
IF @IsTime <> 0
	SET @sSQL3 = @sSQL3  + ' AND '+@TypeDate+' >= '''+CONVERT(nvarchar(10),@FromDate,101)+'''  AND '+@TypeDate+' <= '''+CONVERT(nvarchar(10),@ToDate,101)+''''


SET @sSQL3 = @sSQL3 + ' 
GROUP  BY   TableID, BatchID,  
			VoucherTypeID, VoucherID, VoucherNo, VoucherDate, 
			D4.CurrencyID,ExchangeRate, 
			D4.CreditObjectID , ObjectName, 
			IsUpdateName, VATObjectName,  AT1202.VATNo, DueDate,	D4.VATNo ,
			D4.DivisionID,D4.TranMonth,D4.TranYear,
			ExchangeRateCN,
			InvoiceNo,
			Serial, Status,	CurrencyIDCN,
			InvoiceDate, BDescription'
------------------------<<<<<<<<<<

pRINT @sSQL1 
pRINT  @sSQL2
pRINT  @sSQL3

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0405]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
     EXEC ('  CREATE VIEW AV0405 AS ' + @sSQL1 + @sSQL2 + @sSQL3)
ELSE
     EXEC ('  ALTER VIEW AV0405  AS ' + @sSQL1 + @sSQL2 + @sSQL3)




GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

