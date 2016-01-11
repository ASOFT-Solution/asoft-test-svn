IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP6411]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP6411]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


----- 	Created by Nguyen Van Nhan, Date 19/08/2005
-----	Pupose: In so chi phi
----- Last Edit  Thuy Tuyen Them ma phan tich 4,5
---- Modified on 16/01/2012 by Le Thi Thu Hien : Sua dieu kien loc theo ngay
---- Modified on 16/01/2012 by Lê Thị Thu Hiền : Bổ sung 5 khoản mục Ana06ID đến Ana10ID

CREATE PROCEDURE [dbo].[AP6411] 	
				@DivisionID AS nvarchar(50), 
				@FromAccountID nvarchar(50),
				@ToAccountID nvarchar(50),
				@IsDate AS tinyint,
				@FromMonth AS int, 
				@FromYear AS int,
				@ToMonth AS int,
				@ToYear AS int,
				@FromDate AS datetime,
				@ToDate AS  datetime,
				@IsGroup AS tinyint,
				@GroupID AS nvarchar(50)
	
AS

Declare @GroupField AS nvarchar(50),
		@sSQL AS nvarchar(4000),
   		@sSQL1 AS nvarchar(4000),
		@sTime AS nvarchar(4000)

If @IsGroup<>0 
	SET @GroupField = (Case @GroupID WHEN 'A01' THEN 'Ana01ID'  
					  	WHEN 'A02' THEN 'Ana02ID'  
						WHEN 'A03' THEN 'Ana03ID'
						WHEN 'A04' THEN 'Ana04ID'
						WHEN 'A05' THEN 'Ana05ID'
						WHEN 'A06' THEN 'Ana06ID'
						WHEN 'A07' THEN 'Ana07ID'
						WHEN 'A08' THEN 'Ana08ID'
						WHEN 'A09' THEN 'Ana09ID'
						WHEN 'A10' THEN 'Ana10ID' End)				

If @IsDate =0  -- Theo thang
	SET @sTime = '  TranMonth + TranYear*100  BETWEEN'+str(@FromMonth)+' + '+str(@FromYear)+'*100 AND '+str(@ToMonth)+' + '+str(@ToYear)+'*100 ' 
Else
	SET @sTime = '  CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101),101)   BETWEEN'''+Convert(varchar(10),@FromDate,101)+''' AND '''+Convert(varchar(10),@ToDate,101)+'''  ' 



If @IsGroup =0 
begin
	SET @sSQL=N'
	SELECT 	AT9000.DivisionID, '''' AS GroupID,
			'''' AS GroupName, 
			Ana01ID, Ana02ID, Ana03ID,  Ana04ID, Ana05ID,
			Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
			Orders, VoucherDate, VoucherNo, 
			VDescription, TDescription, 
			DebitAccountID, CreditAccountID, 			
			CASE WHEN DebitAccountID BETWEEN'''+@FromAccountID+''' AND  '''+@ToAccountID+'''  THEN  DebitAccountID  
				else  CreditAccountID End AS AccountID, 
			CASE WHEN DebitAccountID BETWEEN'''+@FromAccountID+''' AND  '''+@ToAccountID+'''  THEN  D.AccountName
				 else  C.AccountName End AS AccountName, 
			CASE WHEN DebitAccountID BETWEEN'''+@FromAccountID+''' AND  '''+@ToAccountID+'''  THEN  D.AccountNameE
				 else  C.AccountName End AS AccountNameE, 
			CASE WHEN DebitAccountID BETWEEN'''+@FromAccountID+''' AND  '''+@ToAccountID+'''  THEN  ConvertedAmount else 0 End AS DebitConvertedAmount, 
			CASE WHEN DebitAccountID BETWEEN '''+@FromAccountID+''' AND  '''+@ToAccountID+'''  THEN  OriginalAmount else 0 End AS DebitOriginalAmount,
			CASE WHEN CreditAccountID BETWEEN '''+@FromAccountID+''' AND  '''+@ToAccountID+'''  THEN  ConvertedAmount else 0 End AS CreditConvertedAmount, 
			CASE WHEN CreditAccountID BETWEEN '''+@FromAccountID+''' AND  '''+@ToAccountID+'''  THEN  OriginalAmount else 0 End AS CreditOriginalAmount,
	'
	SET @sSQL1 = N'
			CurrencyID, 
			InvoiceDate, InvoiceNo 
	FROM	AT9000 	
	LEFT JOIN AT1005 D on D.AccountID = AT9000.DebitAccountID AND  D.DivisionID = AT9000.DivisionID
	LEFT JOIN AT1005 C on C.AccountID = AT9000.CreditAccountID AND  C.DivisionID = AT9000.DivisionID
	WHERE 	AT9000.DivisionID like '''+@DivisionID+''' AND
			( DebitAccountID BETWEEN '''+@FromAccountID+''' AND  '''+@ToAccountID+'''   
			Or CreditAccountID BETWEEN'''+@FromAccountID+''' AND  '''+@ToAccountID+'''   ) AND
		'
end
Else
BEGIN
	SET @sSQL=N'
	SELECT 	AT9000.DivisionID, '+@GroupField+' AS GroupID,
			AT1011.AnaName AS GroupName, 
			Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
			Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
			CASE WHEN DebitAccountID BETWEEN'''+@FromAccountID+''' AND  '''+@ToAccountID+'''  THEN  DebitAccountID  
				else  CreditAccountID End AS AccountID, 
			CASE WHEN DebitAccountID BETWEEN'''+@FromAccountID+''' AND  '''+@ToAccountID+'''  THEN  D.AccountName
				else  C.AccountName End AS AccountName, 	
			CASE WHEN DebitAccountID BETWEEN'''+@FromAccountID+''' AND  '''+@ToAccountID+'''  THEN  D.AccountNameE
				else  C.AccountName End AS AccountNameE, 	
			Orders, VoucherDate, VoucherNo, VDescription, TDescription, DebitAccountID, CreditAccountID, 
			CASE WHEN DebitAccountID BETWEEN'''+@FromAccountID+''' AND  '''+@ToAccountID+'''  THEN  ConvertedAmount else 0 End AS DebitConvertedAmount, 
			CASE WHEN DebitAccountID BETWEEN '''+@FromAccountID+''' AND  '''+@ToAccountID+'''  THEN  OriginalAmount else 0 End AS DebitOriginalAmount,
			CASE WHEN CreditAccountID BETWEEN '''+@FromAccountID+''' AND  '''+@ToAccountID+'''  THEN  ConvertedAmount else 0 End AS CreditConvertedAmount, 
			CASE WHEN CreditAccountID BETWEEN '''+@FromAccountID+''' AND  '''+@ToAccountID+'''  THEN  OriginalAmount else 0 End AS CreditOriginalAmount,
	'
	SET @sSQL1 = N'
			CurrencyID, 
			InvoiceDate, InvoiceNo 
	FROM	AT9000 	
	LEFT JOIN AT1005 D on D.AccountID = AT9000.DebitAccountID AND  D.DivisionID = AT9000.DivisionID 
	LEFT JOIN AT1005 C on C.AccountID = AT9000.CreditAccountID  AND C.DivisionID = AT9000.DivisionID 
	LEFT JOIN AT1011 on  AT1011.AnaID = AT9000.'+@GroupField+' AND  AT1011.DivisionID = AT9000.DivisionID  AND	AT1011.AnaTypeID ='''+@GroupID+'''
	WHERE 	AT9000.DivisionID like '''+@DivisionID+''' AND
			( DebitAccountID BETWEEN '''+@FromAccountID+''' AND  '''+@ToAccountID+'''   
			Or CreditAccountID BETWEEN'''+@FromAccountID+''' AND  '''+@ToAccountID+'''   ) AND
		'

END
--PRINT @sSQL + @sSQL1 + @sTime 
IF EXISTS (SELECT TOP 1 1  FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='AV6411 ')
	DROP VIEW AV6411

EXEC('CREATE VIEW AV6411 --CREATED BY AP6411
	as '+@sSQL + @sSQL1 + @sTime + ' ')


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

