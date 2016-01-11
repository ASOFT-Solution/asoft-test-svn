IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0342]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0342]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




---- Nguyen Thuy Tuyen
--- Date: 30/06/2007
--- Phuc vu bao cao tong hop cong no
---- Modified on 13/02/2012 by Le Thi Thu Hien : Bo sung them JOIN DivisionID
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/

CREATE PROCEDURE  [dbo].[AP0342] 	
		@DivisionID AS nvarchar(50) ,
		@FromObjectID AS nvarchar(50),
		@ToObjectID AS nvarchar(50),
		@FromAccountID AS nvarchar(50),
		@ToAccountID AS nvarchar(50),
		@CurrencyID AS nvarchar(50),
		@TypeD AS tinyint,  	---- Theo ngµy ho¸ ®¬n hay ngµy h¹ch to¸n. 0 theo th¸ng, 1 theo ngµy ho¸ ®¬n, 2 theo ngµy h¹ch to¸n
		@FromDate AS datetime,
		@ToDate AS datetime,
		@FromMonth AS int,
		@FromYear  AS int,
		@ToMonth  AS int,
		@ToYear  AS int
 AS

Declare @sSQL AS nvarchar(4000),
		@TypeDate AS nvarchar(50)
 --        @TableName AS varchar(20),
        --- @SqlObject AS varchar(8000) ,
       ---   @SqlGroupBy AS varchar(8000)
	



Exec AP7402  @DivisionID, @CurrencyID, @FromAccountID, @ToAccountID, @FromObjectID,  @ToObjectID


if @TypeD=2	---- Theo ngay hoa don
	set @TypeDate='InvoiceDate'
else if @TypeD=1	---- Theo ngay hach toan
	set @TypeDate='VoucherDate'

if @TypeD<> 0   ----- In theo ngay
set @sSQL=' 
SELECT	D3.ObjectID,  ObjectName, Object.Address, Object.VATNo, 
		D3.AccountID, AccountName, D3.CurrencyID,
		Object.S1, Object.S2,  Object.S3, Object.O01ID,  Object.O02ID, Object.O03ID, Object.O04ID, Object.O05ID,
		Object.Tel, Object.Fax, Object.Email,
		SUM (CASE WHEN '+@TypeDate+' < '''+CONVERT(DATETIME,CONVERT(NVARCHAR(10),@FromDate,101),101)+''' OR TransactiontypeID=''T00'' THEN SignOriginalAmount ELSE 0 END)  AS OriginalOpening,
		SUM (CASE WHEN '+@TypeDate+' < '''+CONVERT(DATETIME,CONVERT(NVARCHAR(10),@FromDate,101),101)+''' OR TransactiontypeID=''T00'' THEN SignConvertedAmount ELSE 0 END) AS ConvertedOpening,
		D3.DivisionID	                    	   
FROM	AV7402 D3 
INNER JOIN  AT1202 Object  on  Object.ObjectID = D3.ObjectID AND Object.DivisionID = D3.DivisionID
LEFT JOIN AT1015 on AT1015.AnaID = Object.O01ID AND AT1015.DivisionID = D3.DivisionID
INNER JOIN  AT1005 AS Account on Account.AccountID = D3.AccountID AND AT1005.DivisionID = D3.DivisionID
GROUP BY   D3.ObjectID, 
			D3.AccountID, ObjectName,  Object.Address, Object.VATNo, Object.Tel, Object.Fax, Object.Email,
			AccountName, D3.CurrencyID, Object.S1, Object.S2,  Object.S3, Object.O01ID,  Object.O02ID, Object.O03ID, Object.O04ID, Object.O05ID, AT1015.AnaName, D3.DivisionID '

else
Begin
set @sSQL=' 
SELECT	D3.ObjectID,	ObjectName ,	 Object.Address, Object.VATNo, 
		D3.AccountID,	AccountName,	D3.CurrencyID,
		Object.S1, Object.S2,  Object.S3, Object.O01ID,  Object.O02ID, Object.O03ID, Object.O04ID, Object.O05ID,
		Object.Tel, Object.Fax, Object.Email,
        SUM (CASE WHEN (TranMonth + 100*TranYear < '+str(@FromMonth)+' + 100*'+str(@FromYear)+') OR TransactiontypeID=''T00'' THEN SignOriginalAmount ELSE 0 END)  AS OriginalOpening,
        SUM (CASE WHEN (TranMonth + 100*TranYear < '+str(@FromMonth)+' + 100*'+str(@FromYear)+') OR TransactiontypeID=''T00'' THEN SignConvertedAmount ELSE 0 END) AS ConvertedOpening,
        D3.DivisionID
FROM	AV7402  D3 	
INNER JOIN  AT1202 Object  on  Object.ObjectID = D3.ObjectID AND Object.DivisionID = D3.DivisionID
LEFT JOIN AT1015 on AT1015.AnaID = Object.O01ID AND AT1015.DivisionID = D3.DivisionID 
INNER JOIN  AT1005 Account on Account.AccountID = D3.AccountID AND AT1005.DivisionID = D3.DivisionID
GROUP BY  D3.ObjectID, 
		D3.AccountID, ObjectName,  Object.Address, Object.VATNo, Object.Tel, Object.Fax, Object.Email,
		AccountName, D3.CurrencyID, Object.S1, Object.S2,  Object.S3, Object.O01ID,  Object.O02ID, Object.O03ID, Object.O04ID, Object.O05ID,  AT1015.AnaName, D3.DivisionID '
End

---Print @sSQL
IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0356]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
     EXEC ('  CREATE VIEW AV0356 AS ' + @sSQL)
ELSE
     EXEC ('  ALTER VIEW AV0356  AS ' + @sSQL)

--Print @sSQL

---- Bo phan so 0 
--
Set @sSQL ='  
SELECT	ObjectID,   ObjectName, Address, VATNo,  AccountID,  AccountName,  CurrencyID,  
		S1, S2, S3, O01ID,  O02ID, O03ID, O04ID, O05ID, Tel, Fax, Email,
		(Case when  OriginalOpening < 0 then Abs(OriginalOpening) else 0 end) AS CreditOriginalOpening ,  
		(Case when  OriginalOpening >= 0 then OriginalOpening else 0 end) AS DebitOriginalOpening ,
		(Case when  ConvertedOpening < 0 then Abs(ConvertedOpening) else 0 end) AS CreditConvetedOpening ,  
		(Case when  ConvertedOpening >= 0 then ConvertedOpening else 0 end) AS DebitConvetedOpening, DivisionID 
FROM	AV0356
WHERE	OriginalOpening <>0 OR ConvertedOpening <>0 '



IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0357]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
    EXEC ('  CREATE VIEW AV0357 AS ' + @sSQL)
ELSE
    EXEC ('  ALTER VIEW AV0357  AS ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

