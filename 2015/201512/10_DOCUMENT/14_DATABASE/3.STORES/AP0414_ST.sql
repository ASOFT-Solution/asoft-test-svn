IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0414_ST]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0414_ST]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Bao cao chi tiet cong no giai tru cong no phai tra
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Created by Nguyen Van  Nhan, Date 17/11/2003
----
---- Lasted Edit by Van Nhan, 11/01/2005
---- Edited By: Nguyen Quoc Huy, Date: 15/08/2006
---- last edit : Thuy Tuyen , them cac truong O Code, date 15/07/2009
---- Modified on 24/11/2011 by Le Thi Thu Hien : Chinh sua where ngay
---- Modified on 16/01/2012 by Le Thi Thu Hien : CONVERT ngay
---- Modified on 06/03/2013 by Khanh Van: Bo sung tu tai khoan den tai khoan cho Sieu Thanh
---- Modified on 17/11/2014 by Mai Duyen: Bo sung @DatabaseName de in bao cao 2 database (Customized SIEUTHANH )
-- <Example>
---- 

CREATE PROCEDURE [dbo].[AP0414_ST]  
				@DivisionID nvarchar(50), 
				@FromObjectID AS nvarchar(50),
				@ToObjectID AS nvarchar(50),
				@FromAccountID AS nvarchar(50),
				@ToAccountID AS nvarchar(50),
				@CurrencyID  AS nvarchar(50),
				@IsDate AS tinyint,
				@FromDate AS Datetime,
				@ToDate AS  Datetime,
				@FromMonth AS int,
				@FromYear AS int,
				@ToMonth AS int,
				@ToYear AS int,
				@IsZero AS int,
				@IsNotGiveUp AS int,
				@DatabaseName  as NVARCHAR(250)=''
 AS
Declare @sSQL AS nvarchar(4000),
		@sTime AS nvarchar(4000),
		@TableDBO as nvarchar(250)

If @DatabaseName  ='' 
	 Set @TableDBO=''
Else
	Set @TableDBO = '[' +  @DatabaseName + '].DBO.'


SET @sSQL = ' 	
	SELECT	DISTINCT	BatchID+ObjectID  AS LinkID, DivisionID	
	FROM	'+ @TableDBO + 'AV0402  AV0402
	WHERE 	(CreditAccountID >= '''+@FromAccountID+''' AND CreditAccountID<= '''+@ToAccountID+''' )and
			DivisionID = '''+@DivisionID+''' AND 
			(ObjectID >= '''+@FromObjectID+''' AND ObjectID<= '''+@ToObjectID+''' )and
			CurrencyIDCN like '''+@CurrencyID+''' AND		
			OriginalAmountCN-GivedOriginalAmount >0   '

If @IsDate =0 
	SET @sTime ='TranMonth + 100*TranYear between '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  AND  '+str(@ToMonth)+' + 100*'+str(@ToYear)+'  '
If @IsDate =1
	SET @sTime ='CONVERT(DATETIME,CONVERT(varchar(10),VoucherDate,101),101)  BETWEEN '''+ convert(nvarchar(10),@FromDate,101) +''' AND '''+convert(nvarchar(10),@ToDate,101)+'''  '
If  @IsDate =2
	SET @sTime ='CONVERT(DATETIME,CONVERT(varchar(10),InvoiceDate,101),101)  Between '''+ convert(nvarchar(10),@FromDate,101) +''' AND '''+convert(nvarchar(10),@ToDate,101)+'''   '

SET @sSQL = @sSQL+' AND '+@sTime

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='AV0415_ST')
	EXEC ('CREATE VIEW AV0415_ST AS '+@sSQL)
ELSE
	EXEC( 'ALTER VIEW AV0415_ST AS '+@sSQL)


If @IsDate =0 
	SET @sTime ='AV0412.TranMonth + 100*AV0412.TranYear between '+str(@FromMonth)+' + 100*'+str(@FromYear)+' AND  '+str(@ToMonth)+' + 100*'+str(@ToYear)+'  '
If @IsDate =1
	SET @sTime ='CONVERT(DATETIME,CONVERT(varchar(10),AV0412.VoucherDate,101),101)  Between '''+ convert(varchar(10),@FromDate,101) +''' AND '''+convert(varchar(10),@ToDate,101)+'''   '
If  @IsDate =2
	SET @sTime ='CONVERT(DATETIME,CONVERT(varchar(10),AV0412.InvoiceDate,101),101)  Between '''+ convert(varchar(10),@FromDate,101) +''' AND '''+convert(varchar(10),@ToDate,101)+'''   '

SET @sSQL ='
SELECT 	DISTINCT
		AV0412.ObjectID+AV0412.CreditAccountID AS GroupID,
		AV0412.VoucherID, 
		AV0412.BatchID+AV0412.ObjectID+ISNULL(AV0412.InvoiceNo,'''') AS BatchID , 
		AV0412.ObjectID, 
		AV0412.ObjectName,
		AV0412.CreditAccountID, 
		AV0412.CreditAccountName,
		AV0412.CurrencyID, 
		AV0412.CurrencyIDCN,
		AV0412.BDescription AS CreditDescription,
		AV0412.OriginalAmount,
		AV0412.OriginalAmountCN, 		--- So tien nguyen te theo doi cong no
		AV0412.ConvertedAmount,			--- So tien quy doi 
		ISNULL(AT0404.OriginalAmount,0) AS GiveUpOrAmount,	--- So tien nguyen te giai tru tuong ung
		ISNULL(AT0404.ConvertedAmount,0) AS GiveUpCoAmount,--- So tien quy doi giai tru tuong ung
		AV0412.VoucherNo AS CreditVoucherNo,		
		AV0412.VoucherDate AS CreditVoucherDate,
		AV0412.Serial AS CreditSerial,
		AV0412.InvoiceNo AS CreditInvoiceNo,
		AV0412.InvoiceDate AS CreditInvoiceDate,
		CONVERT(VARCHAR(10),AV0412.DueDate,103)   AS CreditDueDate,
		AV0411.BDescription AS DebitDescription,
		AV0411.Serial AS DebitSerial,
		AV0411.InvoiceNo AS DebitInvoiceNo,
		AV0411.VoucherNo AS DebitVoucherNo,
		AV0411.VoucherDate AS DebitVoucherDate,
		AV0411.InvoiceDate AS DebitInvoiceDate,
		AV0411.VoucherTypeID AS DebitVoucherTypeID,
		AV0412.VoucherTypeID AS CreditVoucherTypeID,
		  '''+convert(varchar(10),@FromDate,103)+''' AS Fromdate,
		(CASE WHEN '+str(@IsDate)+'= 0 then ''30/'+Ltrim (str(@ToMonth))+'/'+ltrim(str(@ToYear))+'''  else   '''+convert(varchar(10),@ToDate,103)+''' end ) AS Todate,
		AV0412.O01ID, AV0412.O02ID, AV0412.O03ID,AV0412.O04ID, AV0412.O05ID,
		AV0412.O01Name , AV0412.O02Name ,AV0412.O03Name ,AV0412.O04Name,AV0412.O05Name, AV0412.DivisionID	
FROM		'+ @TableDBO + 'AV0412  AV0412   
LEFT JOIN   '+ @TableDBO + 'AT0404  AT0404
	ON 		AV0412.VoucherID = AT0404.CreditVoucherID AND
			AV0412.ObjectID = AT0404.ObjectID AND		
			AV0412.BatchID = AT0404.CreditBatchID AND
			AV0412.TableID = AT0404.CreditTableID AND
			AV0412.CreditAccountID = AT0404.AccountID AND 
			AV0412.DivisionID = AT0404.DivisionID 
LEFT JOIN   '+ @TableDBO + 'AV0411  AV0411
	ON 		AV0411.VoucherID = AT0404.DebitVoucherID AND
			AV0411.ObjectID = AT0404.ObjectID AND		
			AV0411.BatchID = AT0404.DebitBatchID AND
			AV0411.TableID = AT0404.DebitTableID AND					
			AV0411.DebitAccountID =AT0404.AccountID AND
			AV0411.DivisionID = AT0404.DivisionID 		
			
WHERE 		AV0412.DivisionID = '''+@DivisionID+''' AND 
			AV0412.ObjectID >= '''+@FromObjectID+''' AND AV0412.ObjectID<= '''+@ToObjectID+''' AND
			AV0412.CurrencyIDCN like '''+@CurrencyID+''' AND
			AV0412.CreditAccountID >= '''+@FromAccountID+''' AND AV0412.CreditAccountID<= '''+@ToAccountID+'''  '

if @IsZero = 1  --khong hien thi hoa don da giai tru het
	SET @sSQL = @sSQL +' AND AV0412.BatchID+AV0412.ObjectID in (Select LinkID From '+ @TableDBO + 'AV0415  AV0415 ) '

if @IsNotGiveUp = 1 --khong hien thi hoa don chua giai tru 
	SET @sSQL = @sSQL +' AND ISNULL(AT0404.OriginalAmount,0) <>0    '

SET @sSQL = @sSQL +' AND '+@sTime

---Print @sSQL
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='AV0414_ST')
	EXEC ('CREATE VIEW AV0414_ST AS '+@sSQL)
ELSE
	EXEC( 'ALTER VIEW AV0414_ST AS '+@sSQL)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO