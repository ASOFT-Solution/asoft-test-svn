IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0314]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0314]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
---- Bao cao tong  hop tinh hinh thanh toan no phai thu
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----- Created by Nguyen Van  Nhan, Date 27/08/2007
---
---- Last Edit Thuy Tuyen : Lay so du cuoi ky, Ten ma phan tich doi tuong : Date 26/10/2007, date 03/06/2008
---- Modified on 06/12/2011 by Le Thi Thu Hien : Sua ngay CONVERT(DATETIME,CONVERT(varchar(10),VoucherDate,101)
-- <Example>
---- 


CREATE PROCEDURE [dbo].[AP0314] 
				@DivisionID nvarchar(50), 
				@FromObjectID AS nvarchar(50),
				@ToObjectID AS nvarchar(50),
				@FromAccountID  AS nvarchar(50),	
				@ToAccountID AS nvarchar(50),
				@CurrencyID  AS nvarchar(50),
				@TypeD AS tinyint,
				@FromDate AS Datetime,
				@ToDate AS  Datetime,
				@FromMonth AS int,
				@FromYear AS int,
				@ToMonth AS int,
				@ToYear AS int,
				@IsZero AS int,
				@IsNotGiveUp AS int


as
Declare @sSQL AS nvarchar(4000),
		@TypeDate AS nvarchar (50),
		@Enddate AS DATETIME
		
-------->> Xu ly tong no phai thu
EXEC AP7402  @DivisionID, @CurrencyID, @FromAccountID, @ToAccountID, @FromObjectID,  @ToObjectID

----------------------- Xu ly chung -------------------------------------------------------
IF @TypeD= 1	---- Theo ngay hoa don
	set @TypeDate = 'InvoiceDate'
ELSE IF  @TypeD= 2 	---- Theo ngay hach toan
	SET @TypeDate = 'VoucherDate'


 --set @Enddate = (Select EndDate From AT9999 Where TranMonth + TranYear *100 =  str(@ToMonth) + 100*str(@ToYear) )
 --Hoangphuoc sua. Them top 1 de chi lay ra mot gia tri. Neu khong se bi loi neu co hon 1 dong tra ve
 SET @Enddate = (SELECT TOP 1 EndDate FROM AT9999 WHERE TranMonth + TranYear *100 =  str(@ToMonth) + 100*str(@ToYear) AND DivisionID = @DivisionID)

--Print @Enddate

---B1  Du ra co so du + phat sinh
IF @TypeD<> 0   ----- In theo ngay
SET @sSQL = ' 
SELECT  D3.ObjectID,  ObjectName, Object.Address, Object.VATNo, 
        D3.AccountID, AccountName, D3.CurrencyID,
        Object.S1, Object.S2,  Object.S3, Object.O01ID,  Object.O02ID, Object.O03ID, Object.O04ID, Object.O05ID,
        Object.Tel, Object.Fax, Object.Email,
        SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) < '''+convert(nvarchar(10),@FromDate,101)+''' OR TransactiontypeID=''T00'' THEN SignOriginalAmount ELSE 0 END)  AS OriginalOpening,
        SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) < '''+convert(nvarchar(10),@FromDate,101)+''' OR TransactiontypeID=''T00'' THEN SignConvertedAmount ELSE 0 END) AS ConvertedOpening,
        SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) >= '''+convert(nvarchar(10),@FromDate,101)+''' AND CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= '''+convert(nvarchar(10),@ToDate,101)+''' AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''00'' THEN OriginalAmount ELSE 0 END) AS OriginalDebit,
        SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) >= '''+convert(nvarchar(10),@FromDate,101)+''' AND CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= '''+convert(nvarchar(10),@ToDate,101)+''' AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''00'' THEN ConvertedAmount ELSE 0 END) AS ConvertedDebit,
        SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) >= '''+convert(nvarchar(10),@FromDate,101)+''' AND CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= '''+convert(nvarchar(10),@ToDate,101)+''' AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''01'' THEN OriginalAmount ELSE 0 END) AS OriginalCredit,
		SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) >= '''+convert(nvarchar(10),@FromDate,101)+''' AND CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= '''+convert(nvarchar(10),@ToDate,101)+''' AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''01'' THEN ConvertedAmount ELSE 0 END) AS ConvertedCredit,
		SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= '''+convert(nvarchar(10),@ToDate,101)+''' OR TransactiontypeID=''T00''  THEN SignOriginalAmount ELSE 0 END) AS OriginalClosing,
        SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= '''+convert(nvarchar(10),@ToDate,101)+''' OR TransactiontypeID=''T00'' THEN SignConvertedAmount ELSE 0 END) AS ConvertedClosing,
        SUM (CASE WHEN (TranMonth + TranYear*100 > '+str(@FromYear)+'*100)  AND  CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= '''+convert(nvarchar(10),@ToDate,101)+''' AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''00'' THEN OriginalAmount ELSE 0 END) AS OriginalDebitYTD,
        SUM (CASE WHEN (TranMonth + TranYear*100 > '+str(@FromYear)+'*100)  AND  CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= '''+convert(nvarchar(10),@ToDate,101)+''' AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''00'' THEN ConvertedAmount ELSE 0 END) AS ConvertedDebitYTD,
        SUM (CASE WHEN (TranMonth + TranYear*100 > '+str(@FromYear)+'*100)  AND  CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= '''+convert(nvarchar(10),@ToDate,101)+''' AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''01'' THEN OriginalAmount ELSE 0 END) AS OriginalCreditYTD,
        SUM (CASE WHEN (TranMonth + TranYear*100 > '+str(@FromYear)+'*100)  AND  CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= '''+convert(nvarchar(10),@ToDate,101)+''' AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''01'' THEN ConvertedAmount ELSE 0 END) AS ConvertedCreditYTD,
        D3.DivisionID
FROM	AV7402 D3 
INNER JOIN AT1202 Object  on  Object.ObjectID = D3.ObjectID AND Object.DivisionID = D3.DivisionID 
INNER JOIN AT1005 AS Account on Account.AccountID = D3.AccountID AND Account.DivisionID = D3.DivisionID
GROUP BY	D3.ObjectID, 
			D3.AccountID, ObjectName,  Object.Address, Object.VATNo, Object.Tel, Object.Fax, Object.Email,
			AccountName, D3.CurrencyID, Object.S1, Object.S2,  Object.S3, 
			Object.O01ID,  Object.O02ID, Object.O03ID, Object.O04ID, Object.O05ID, D3.DivisionID '

ELSE
BEGIN
set @sSQL='	
SELECT  D3.ObjectID,	ObjectName ,	 Object.Address, Object.VATNo, 
		D3.AccountID,	AccountName,	D3.CurrencyID,
		Object.S1, Object.S2,  Object.S3, Object.O01ID,  Object.O02ID, Object.O03ID, Object.O04ID, Object.O05ID,
		Object.Tel, Object.Fax, Object.Email,
        SUM (CASE WHEN (TranMonth + 100*TranYear < '+str(@FromMonth)+' + 100*'+str(@FromYear)+') OR TransactiontypeID=''T00'' THEN SignOriginalAmount ELSE 0 END)  AS OriginalOpening,
		SUM (CASE WHEN (TranMonth + 100*TranYear < '+str(@FromMonth)+' + 100*'+str(@FromYear)+') OR TransactiontypeID=''T00'' THEN SignConvertedAmount ELSE 0 END) AS ConvertedOpening,
		SUM (CASE WHEN (TranMonth + 100*TranYear >= '+str(@FromMonth)+' + 100*'+str(@FromYear)+') AND (TranMonth + 100*TranYear <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+') AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''00'' THEN OriginalAmount ELSE 0 END) AS OriginalDebit,
		SUM (CASE WHEN (TranMonth + 100*TranYear >= '+str(@FromMonth)+' + 100*'+str(@FromYear)+') AND (TranMonth + 100*TranYear <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+') AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''00'' THEN ConvertedAmount ELSE 0 END) AS ConvertedDebit,
		SUM (CASE WHEN (TranMonth + 100*TranYear >= '+str(@FromMonth)+' + 100*'+str(@FromYear)+') AND (TranMonth + 100*TranYear <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+') AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''01'' THEN OriginalAmount ELSE 0 END) AS OriginalCredit,
		SUM (CASE WHEN (TranMonth + 100*TranYear >= '+str(@FromMonth)+' + 100*'+str(@FromYear)+') AND (TranMonth + 100*TranYear <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+') AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''01'' THEN ConvertedAmount ELSE 0 END) AS ConvertedCredit,
		SUM (CASE WHEN (TranMonth + 100*TranYear <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+')  OR TransactiontypeID=''T00'' THEN SignOriginalAmount ELSE 0 END) AS OriginalClosing,
		SUM (CASE WHEN (TranMonth + 100*TranYear <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+') OR TransactiontypeID=''T00''  THEN SignConvertedAmount ELSE 0 END) AS ConvertedClosing,
		SUM (CASE WHEN (TranMonth + TranYear*100 > '+str(@FromYear)+'*100)  AND (TranMonth +TranYear *100 < ='+str(@ToMonth)+' + '+str(@ToYear)+'*100)  AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''00'' THEN OriginalAmount ELSE 0 END) AS OriginalDebitYTD,
		SUM (CASE WHEN (TranMonth + TranYear*100 > '+str(@FromYear)+'*100)  AND (TranMonth +TranYear *100 < ='+str(@ToMonth)+' + '+str(@ToYear)+'*100)  AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''00'' THEN ConvertedAmount ELSE 0 END) AS ConvertedDebitYTD,
		SUM (CASE WHEN (TranMonth + TranYear*100 > '+str(@FromYear)+'*100)  AND (TranMonth +TranYear *100 < ='+str(@ToMonth)+' + '+str(@ToYear)+'*100)  AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''01'' THEN OriginalAmount ELSE 0 END) AS OriginalCreditYTD,
		SUM (CASE WHEN (TranMonth + TranYear*100 > '+str(@FromYear)+'*100)  AND (TranMonth +TranYear *100 < ='+str(@ToMonth)+' + '+str(@ToYear)+'*100)  AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''01'' THEN ConvertedAmount ELSE 0 END) AS ConvertedCreditYTD,
        D3.DivisionID
FROM	AV7402 D3 	
INNER JOIN AT1202 Object  on  Object.ObjectID = D3.ObjectID	and Object.DivisionID = D3.DivisionID									
INNER JOIN AT1005 Account on Account.AccountID = D3.AccountID AND Account.DivisionID = D3.DivisionID	
GROUP BY	D3.ObjectID, 
			D3.AccountID, ObjectName,  Object.Address, Object.VATNo, Object.Tel, Object.Fax, Object.Email,
			AccountName, D3.CurrencyID, Object.S1, Object.S2,  Object.S3, 
			Object.O01ID,  Object.O02ID, Object.O03ID, Object.O04ID, Object.O05ID,D3.DivisionID '
END

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0350]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
     EXEC ('  CREATE VIEW AV0350 --AP0134
      AS ' + @sSQL)
ELSE
     EXEC ('  ALTER VIEW AV0350   --AP0134
     AS ' + @sSQL)



--Print @sSQL


---- Bo phan so 0 
IF @CurrencyID<>'%'
SET @sSQL ='  
SELECT  ObjectID,   ObjectName, Address, VATNo,  AccountID,  AccountName,  CurrencyID,  
		S1, S2, S3, O01ID,  O02ID, O03ID, O04ID, O05ID, Tel, Fax, Email,
		(CASE WHEN  OriginalOpening < 0 then Abs(OriginalOpening) else 0 end) AS CreditOriginalOpening ,  
		(CASE WHEN  OriginalOpening >= 0 then OriginalOpening else 0 end) AS DebitOriginalOpening ,  
		OriginalOpening,
		(CASE WHEN  ConvertedOpening < 0 then Abs(ConvertedOpening) else 0 end) AS CreditConvertedOpening ,  
		(CASE WHEN  ConvertedOpening >= 0 then ConvertedOpening else 0 end) AS DebitConvertedOpening ,  
 
 		ConvertedOpening ,   

		OriginalDebit,   ConvertedDebit,   OriginalCredit,  ConvertedCredit,  
		(CASE WHEN  OriginalClosing < 0 then Abs(OriginalClosing) else 0 end) AS CreditOriginalClosing ,  
		(CASE WHEN  OriginalClosing >= 0 then OriginalClosing else 0 end) AS DebitOriginalClosing ,  
		OriginalClosing ,   
		(CASE WHEN  ConvertedClosing < 0 then Abs(ConvertedClosing) else 0 end) AS CreditConvertedClosing ,  
		(CASE WHEN  ConvertedClosing >= 0 then ConvertedClosing else 0 end) AS DebitConvertedClosing ,  

		ConvertedClosing ,
		OriginalDebitYTD,  ConvertedDebitYTD,  OriginalCreditYTD ,  ConvertedCreditYTD, DivisionID   
FROM	AV0350
WHERE	OriginalOpening <>0 OR ConvertedOpening <>0 OR 
		OriginalDebit<>0 OR ConvertedDebit <>0 OR 
		OriginalCredit<>0 OR ConvertedCredit<>0 OR 
		OriginalClosing<>0 OR ConvertedClosing<>0 '

Else
Set @sSQL =' 
SELECT 	ObjectID,   ObjectName, Address, VATNo,  AccountID,  AccountName,
		''%'' AS CurrencyID,  
	
		S1, S2, S3, O01ID,  O02ID, O03ID, O04ID, O05ID, Tel, Fax, Email,

		0  AS CreditOriginalOpening ,  
 		0 AS DebitOriginalOpening ,  
		0  OriginalOpening,	
 	
 		CASE WHEN Sum(ConvertedOpening) <0 then -Sum(ConvertedOpening) else 0 end AS CreditConvertedOpening ,   
		CASE WHEN Sum(ConvertedOpening) >0 then Sum(ConvertedOpening) else 0 end AS DebitConvertedOpening ,   
		Sum(ConvertedOpening) AS ConvertedOpening,
		sum(OriginalDebit) AS OriginalDebit,   
		sum(ConvertedDebit) AS ConvertedDebit,   
		sum(OriginalCredit) AS OriginalCredit,  
		Sum(ConvertedCredit) AS ConvertedCredit,  
		0 AS CreditOriginalClosing ,  
		0 AS DebitOriginalClosing ,  
		sum(OriginalClosing) AS OriginalClosing ,    	
		CASE WHEN Sum(ConvertedClosing) <0 then -Sum(ConvertedClosing) else 0 end AS CreditConvertedClosing ,   
		CASE WHEN Sum(ConvertedClosing) >0 then Sum(ConvertedClosing) else 0 end AS DebitConvertedClosing ,   
		Sum(ConvertedClosing) AS ConvertedClosing ,
	   0 AS OriginalDebitYTD,  
		0 AS ConvertedDebitYTD,  
		0 AS OriginalCreditYTD ,  
		0 AS ConvertedCreditYTD,
		AV0350.DivisionID   
FROM	AV0350
WHERE	OriginalOpening <>0 OR ConvertedOpening <>0 OR 
		OriginalDebit<>0 OR ConvertedDebit <>0 OR 
		OriginalCredit<>0 OR ConvertedCredit<>0 OR 
		OriginalClosing<>0 OR ConvertedClosing<>0 
GROUP BY	ObjectID,   ObjectName, Address, VATNo,  AccountID,  AccountName,		
			S1, S2, S3, O01ID,  O02ID, O03ID, O04ID, O05ID,Tel, Fax, Email,DivisionID '


--print @sSQL

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0351]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
    EXEC ('  CREATE VIEW AV0351 --AP0314 
    AS ' + @sSQL)
ELSE
    EXEC ('  ALTER VIEW AV0351  --AP0314 
    AS ' + @sSQL)

--- B2: Dua ra so da giai tru
If @TypeD =  0 
	SET @sSQL='
	SELECT   DISTINCT AT0303.ObjectID, sum(AT0303.OriginalAmount) AS GivedOriginalAmount, sum(AT0303.ConvertedAmount) AS GivedConvertedAmount, AT0303.DivisionID
	FROM	AT0303
	--- inner join AV0302 on AV0302.VoucherID = AT0303.CreditVoucherID AND AV0302.CreditAccountID = AT0303.AccountID 
	LEFT JOIN  ( SELECT DISTINCT DivisionID, TranMonth,TranYear,  
						VoucherID,tableID,ObjectID,VoucherDate  
				 FROM	AV0302
				) AS  AV0302 
		on		AV0302.VoucherID = AT0303.CreditVoucherID AND AV0302.TableID = AT0303.CreditTableID AND
				AV0302.ObjectID = AT0303.ObjectID AND  AV0302.DivisionID = AT0303.DivisionID

	WHERE	AT0303.ObjectID between N'''+@FromObjectID+'''  AND   N'''+@ToObjectID+'''  AND 
			AV0302.TranMonth + TranYear*100 Between '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  AND  '+str(@ToMonth)+' + 100*'+str(@ToYear)+'  
	GROUP BY AT0303.ObjectID, AT0303.DivisionID '


ELSE

	SET @sSQL='
	SELECT	AT0303.ObjectID, sum(AT0303.OriginalAmount) AS GivedOriginalAmount, 
			sum(AT0303.ConvertedAmount) AS GivedConvertedAmount, AT0303.DivisionID
	FROM	AT0303 
	INNER JOIN AV0302 on AV0302.VoucherID = AT0303.CreditVoucherID AND AV0302.CreditAccountID = AT0303.AccountID AND AV0302.DivisionID = AT0303.DivisionID 
	WHERE	AT0303.ObjectID between N'''+@FromObjectID+'''  AND  N'''+@ToObjectID+'''  AND 
			CONVERT(DATETIME,CONVERT(varchar(10),AV0302.VoucherDate,101),101)  Between '''+ convert(nvarchar(10),@FromDate,101) +''' AND '''+convert(nvarchar(10),@ToDate,101)+''' 
	GROUP BY AT0303.ObjectID, AT0303.DivisionID '


--Print @sSQL

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0346]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
    EXEC ('  CREATE VIEW AV0346 --ap0314
    AS ' + @sSQL)
ELSE
    EXEC ('  ALTER VIEW AV0346   --ap0314
    AS ' + @sSQL)


--- B3: Dua ra so No qua han


If @TypeD  <> 0
 
	SET @sSQL='
		SELECT	ObjectID, sum(OriginalAmount- GivedOriginalAmount) AS OverOriginalAmount, 
				Sum(ConvertedAmount- GivedConvertedAmount) AS  OverConvertedAmount, DivisionID
		FROM	AV0301
		WHERE	(DueDate < = CASE WHEN DueDate <>''01/01/1900'' then  '''+convert(nvarchar(10),@ToDate,101)+''' end )  AND 
				ObjectID between '''+@FromObjectID+'''  AND  '''+@ToObjectID+'''  
		GROUP BY AV0301.ObjectID, DivisionID '

ELSE
	SET @sSQL='
		SELECT	ObjectID, sum(OriginalAmount- GivedOriginalAmount) AS OverOriginalAmount, 
				Sum(ConvertedAmount- GivedConvertedAmount) AS  OverConvertedAmount, DivisionID
		FROM	AV0301
		WHERE	(DueDate < = CASE WHEN DueDate <>''01/01/1900'' then  '''+convert(nvarchar(10),@EndDate,101)+'''  end ) AND
				ObjectID between '''+@FromObjectID+'''  AND  '''+@ToObjectID+'''  
		GROUP BY AV0301.ObjectID, DivisionID '

--Print @sSQL

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0347]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
    EXEC ('  CREATE VIEW AV0347  --AP0314
    AS ' + @sSQL)
ELSE
    EXEC ('  ALTER VIEW AV0347  --AP0314
     AS ' + @sSQL)


---B4: Lien ket lai voi nha
Set @sSQL='
	SELECT	AV0351.ObjectID, AV0351.ObjectName, AV0351.Address, AV0351.VATNo, 
			AV0351.AccountID AS DebitAccountID , AV0351.AccountName AS DebitAccountName, AV0351.CurrencyID AS CurrencyIDCN, AV0351.S1, AV0351.S2, AV0351.S3,
			AV0351.O01ID, T01.AnaName AS O01Name , 
			AV0351.O02ID, T02.AnaName AS  O02Name, 
			AV0351.O03ID, T03.AnaName O03Name,
			AV0351.O04ID, T04.AnaName O04Name,
			AV0351.O05ID, T05.AnaName O05Name,
			AV0351.Tel, AV0351.Fax, AV0351.Email, 
			CASE WHEN isnull (AV0351.CreditOriginalOpening,0)<> 0 then CreditOriginalOpening else  -(AV0351.DebitOriginalOpening) end AS DebitOriginalOpening,
			CASE WHEN isnull (AV0351.CreditConvertedOpening,0)<> 0 then CreditOriginalOpening else  -(AV0351.DebitConvertedOpening) end AS DebitConvetedOpening,
			AV0351.OriginalDebit AS OriginalAmount, AV0351.ConvertedDebit AS ConvertedAmount,  AV0346.GivedOriginalAmount  AS GiveUpOrAmount  ,AV0346.GivedConvertedAmount  AS GiveUpCoAmount , 
			Av0347.OverOriginalAmount,AV0347.OverConvertedAmount,  AT1202.Note1,  AT1202.Note, Av0351.OriginalClosing,Av0351.ConvertedClosing, AV0351.DivisionID
	FROM	AV0351 	
	LEFT JOIN AV0346 on AV0346.ObjectID = AV0351.ObjectID AND AV0346.DivisionID = AV0351.DivisionID
	LEFT JOIN AV0347 on AV0347.ObjectID = AV0351.ObjectID AND AV0347.DivisionID = AV0351.DivisionID
	INNER JOIN AT1202 on AT1202. ObjectID = AV0351.ObjectID AND AT1202.DivisionID = AV0351.DivisionID
	LEFT JOIN  AT1015  T01 on T01.AnaID = AV0351.O01ID AND T01.AnaTypeID  =''O01'' AND T01.DivisionID = AV0351.DivisionID
	LEFT JOIN  AT1015  T02 on T02.AnaID = AV0351.O02ID AND T02.AnaTypeID  =''O02'' AND T02.DivisionID = AV0351.DivisionID
	LEFT JOIN  AT1015  T03 on T03.AnaID = AV0351.O03ID AND T03.AnaTypeID  =''O03'' AND T03.DivisionID = AV0351.DivisionID
	LEFT JOIN  AT1015  T04 on T04.AnaID = AV0351.O04ID AND T04.AnaTypeID  =''O04'' AND T04.DivisionID = AV0351.DivisionID
	LEFT JOIN  AT1015  T05 on T05.AnaID = AV0351.O05ID AND T05.AnaTypeID  =''O05'' AND T05.DivisionID = AV0351.DivisionID
	'

--print @sSQL

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0352]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
    EXEC ('  CREATE VIEW AV0352 --AP0314
    AS ' + @sSQL)
ELSE
    EXEC ('  ALTER VIEW AV0352 --AP0314
     AS ' + @sSQL)
--- Buoc

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

