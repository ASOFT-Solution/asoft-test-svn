IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7409]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7409]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- In Tong hop no phai tra
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Created by Nguyen Van Nhan, Date 22.08.2003
----
---- Last  Edit Van Nhan &  Thuy Tuyen Date 13/07/2006 
---- Modified on 24/11/2011 by Le Thi Thu Hien : Chinh sua where ngay
---- Modified on 16/01/2012 by Le Thi Thu Hien : Sua CONVERT ngay
---- Modified on 28/12/2012 by Lê Thị Thu Hiền : Bổ sung thêm strDivisionID
---- Modified on 14/11/2014 by Mai Duyen : Bổ sung thêm DatabaseName (tinh năng In báo cao TH no phai tra 2 Database ,KH SIEUTHANH)
---- Modified on 08/04/2015 by Thanh Sơn: Bổ sung trường AccountNameE
-- <Example>
---- 

CREATE PROCEDURE [dbo].[AP7409] 	
					@DivisionID AS nvarchar(50) ,
					@FromMonth AS int,
					@FromYear  AS int,
					@ToMonth  AS int,
					@ToYear  AS int,
					@TypeD AS tinyint,  	
					@FromDate AS datetime,
					@ToDate AS datetime,
					@CurrencyID AS nvarchar(50),
					@FromAccountID AS nvarchar(50),
					@ToAccountID AS nvarchar(50),
					@FromObjectID AS nvarchar(50),
					@ToObjectID AS nvarchar(50),
					@Groupby AS tinyint ,
					@StrDivisionID AS NVARCHAR(4000) = '' ,
					@DatabaseName  AS NVARCHAR(250) = ''  
 AS

DECLARE @sSQL AS nvarchar(4000),
		@sSQL1 AS NVARCHAR(4000),
		@sSQLUnion AS nvarchar(Max),
		@GroupTypeID AS nvarchar(50),
		@GroupID AS nvarchar(50),
		@TypeDate AS nvarchar(50),
		@TableName AS nvarchar(50),
		@SqlObject AS nvarchar(4000) ,
		@SqlGroupBy AS nvarchar(4000),
		@sGROUPBY AS nvarchar(4000),
		@CustomerName INT
		
		
--Tao bang tam de kiem tra day co phai la khach hang Sieu Thanh khong (CustomerName = 16)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)
		
		
SET @GroupTypeID ='O01'


SET @GroupID = (Case @GroupTypeID 
					When 'O01'  Then 'Object.O01ID' 		---- Nhom theo ma phan tich
					When 'O02'  Then 'Object.O02ID' 
					When 'O03'  Then 'Object.O03ID' 
					When 'O04'  Then 'Object.O04ID'
					When 'O05'  Then 'Object.O05D' 
				End)


If @GroupBy= 0    ---- Nhom theo doi tuong , tai khoan
	SET @SqlGroupBy = '
				Object.O01ID AS GroupID,
				AT1015.AnaName AS  GroupName,
				D3.ObjectID AS GroupID1, 
				ObjectName AS GroupName1,
				D3.AccountID AS GroupID2,
				AccountName AS GroupName2, '
else   		----- Nhom theo tai khoan, doi tuong
	SET @SqlGroupBy = '
				Object.O01ID AS GroupID,
				AT1015.AnaName AS  GroupName,
				D3.AccountID AS GroupID1,
				AccountName AS GroupName1, 
				D3.ObjectID AS GroupID2, 
				ObjectName AS GroupName2,'

Exec AP7401 @DivisionID, @CurrencyID, @FromAccountID, @ToAccountID, @FromObjectID, @ToObjectID, @StrDivisionID

IF @TypeD = 1	---- Theo ngay hoa don
	SET @TypeDate = 'CONVERT(nvarchar(10),InvoiceDate,101)'
ELSE IF @TypeD = 2 	---- Theo ngay chung tu
	SET @TypeDate = 'CONVERT(nvarchar(10),VoucherDate,101)'

IF @TypeD <> 0   ----- In theo ngay
BEGIN
	SET @sSQL = N' 
	SELECT	D3.DivisionID, ' + @SqlGroupBy + '	
			D3.ObjectID,	ObjectName,	Object.Address,	Object.VATNo,
			D3.AccountID,	AccountName,
			D3.CurrencyID,
			Object.S1,	Object.S2,	Object.S3,
			Object.O01ID,Object.O02ID,Object.O03ID,	Object.O04ID,Object.O05ID,		
			Object.Tel,	Object.Fax,	Object.Email,
			SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) < ''' + convert(nvarchar(10), @FromDate, 101) + ''' OR TransactiontypeID = ''T00'' THEN SignOriginalAmount ELSE 0 END) AS OriginalOpening,
			SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) < ''' + convert(nvarchar(10), @FromDate, 101) + ''' OR TransactiontypeID = ''T00'' THEN SignConvertedAmount ELSE 0 END) AS ConvertedOpening,
			SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) >= ''' + convert(nvarchar(10), @FromDate, 101) + '''  
					   and CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <>''T00'') AND RPTransactionType = ''00'' THEN OriginalAmount ELSE 0 END) AS OriginalDebit,
			SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) >= ''' + convert(nvarchar(10), @FromDate, 101) + '''  
					   and CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND RPTransactionType= ''00'' THEN ConvertedAmount ELSE 0 END) AS ConvertedDebit,
			SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) >= ''' + convert(nvarchar(10), @FromDate, 101) + '''  
					   and CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <>''T00'') AND RPTransactionType= ''01'' THEN OriginalAmount ELSE 0 END) AS OriginalCredit,
			SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) >= ''' + convert(nvarchar(10), @FromDate, 101) + ''' 
					   and CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <>''T00'') AND RPTransactionType= ''01'' THEN ConvertedAmount ELSE 0 END) AS ConvertedCredit,
			SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' OR TransactiontypeID = ''SD'' THEN SignOriginalAmount ELSE 0 END) AS OriginalClosing,
			SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' OR TransactiontypeID = ''SD'' THEN SignConvertedAmount ELSE 0 END) AS ConvertedClosing,
			SUM (CASE WHEN (TranMonth + TranYear * 100 > ' + str(@FromYear) + ' * 100) AND CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND RPTransactionType = ''00'' THEN OriginalAmount ELSE 0 END) AS OriginalDebitYTD,
			SUM (CASE WHEN (TranMonth + TranYear * 100 > ' + str(@FromYear) + ' * 100) AND CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <> ''T00'' ) AND  RPTransactionType= ''00'' THEN ConvertedAmount ELSE 0 END) AS ConvertedDebitYTD,
			SUM (CASE WHEN (TranMonth + TranYear * 100 > ' + str(@FromYear) + ' * 100) AND CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <> ''T00'' ) AND  RPTransactionType= ''01'' THEN OriginalAmount ELSE 0 END) AS OriginalCreditYTD,
			SUM (CASE WHEN (TranMonth + TranYear * 100 > ' + str(@FromYear) + ' * 100) AND CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <> ''T00'' ) AND  RPTransactionType= ''01'' THEN ConvertedAmount ELSE 0 END) AS ConvertedCreditYTD
	'
	SET @sSQL1 = N'
	FROM	AV7401 D3 
	INNER JOIN AT1202 Object  on  Object.ObjectID = D3.ObjectID and Object.DivisionID = D3.DivisionID
	LEFT JOIN AT1015 on AT1015.AnaID = Object.O01ID and AT1015.DivisionID = Object.DivisionID and	AT1015.AnaTypeID = ''' + @GroupTypeID + '''
	INNER JOIN AT1005 AS Account on Account.AccountID = D3.AccountID and Account.DivisionID = D3.DivisionID

	GROUP BY D3.DivisionID, D3.ObjectID, 
			D3.AccountID, ObjectName,  Object.S1, Object.S2,  Object.S3, Object.O01ID, 
			Object.O02ID, Object.O03ID, Object.O04ID, Object.O05ID,
			Object.Tel, Object.Fax, Object.Email,
			Object.Address, Object.VATNo, AccountName, D3.CurrencyID,  AT1015.AnaName, ' 
END


ELSE
BEGIN
	SET @sSQL = N'
	SELECT  D3.DivisionID, '+ @SqlGroupBy+'	
			D3.ObjectID,
			ObjectName,	
			Address, 
			VATNo,
			D3.AccountID,
			AccountName,
			D3.CurrencyID,
			Object.S1, 
			Object.S2,  
			Object.S3, 
			Object.O01ID,  
			Object.O02ID, 
			Object.O03ID, 
			Object.O04ID, 
			Object.O05ID,
			Object.Tel, 
			Object.Fax, 
			Object.Email,
  			SUM (CASE WHEN (TranMonth + 100*TranYear < '+str(@FromMonth)+' + 100*'+str(@FromYear)+') OR TransactiontypeID=''T00'' THEN SignOriginalAmount ELSE 0 END)  AS OriginalOpening,
  			SUM (CASE WHEN (TranMonth + 100*TranYear < '+str(@FromMonth)+' + 100*'+str(@FromYear)+') OR TransactiontypeID=''T00'' THEN SignConvertedAmount ELSE 0 END) AS ConvertedOpening ,
  			SUM (CASE WHEN (TranMonth + 100*TranYear >= '+str(@FromMonth)+' + 100*'+str(@FromYear)+') AND (TranMonth + 100*TranYear <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+') AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''00'' THEN OriginalAmount ELSE 0 END) AS OriginalDebit ,
  			SUM (CASE WHEN (TranMonth + 100*TranYear >= '+str(@FromMonth)+' + 100*'+str(@FromYear)+') AND (TranMonth + 100*TranYear <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+') AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''00'' THEN ConvertedAmount ELSE 0 END) AS ConvertedDebit,
  			SUM (CASE WHEN (TranMonth + 100*TranYear >= '+str(@FromMonth)+' + 100*'+str(@FromYear)+') AND (TranMonth + 100*TranYear <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+') AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''01'' THEN OriginalAmount ELSE 0 END) AS OriginalCredit,
 			SUM (CASE WHEN (TranMonth + 100*TranYear >= '+str(@FromMonth)+' + 100*'+str(@FromYear)+') AND (TranMonth + 100*TranYear <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+') AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''01'' THEN ConvertedAmount ELSE 0 END) AS ConvertedCredit,
 			SUM (CASE WHEN (TranMonth + 100*TranYear <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+')  OR TransactiontypeID=''T00'' THEN SignOriginalAmount ELSE 0 END) AS OriginalClosing,
 			SUM (CASE WHEN (TranMonth + 100*TranYear <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+') OR TransactiontypeID=''T00''  THEN SignConvertedAmount ELSE 0 END) AS ConvertedClosing,
 			SUM (CASE WHEN (TranMonth + TranYear*100 > '+str(@FromYear)+'*100)  AND (TranMonth +TranYear *100 < ='+str(@ToMonth)+' + '+str(@ToYear)+'*100)  AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''00'' THEN OriginalAmount ELSE 0 END) AS OriginalDebitYTD,
 			SUM (CASE WHEN (TranMonth + TranYear*100 > '+str(@FromYear)+'*100)  AND (TranMonth +TranYear *100 < ='+str(@ToMonth)+' + '+str(@ToYear)+'*100)  AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''00'' THEN ConvertedAmount ELSE 0 END) AS ConvertedDebitYTD,
 			SUM (CASE WHEN (TranMonth + TranYear*100 > '+str(@FromYear)+'*100)  AND (TranMonth +TranYear *100 < ='+str(@ToMonth)+' + '+str(@ToYear)+'*100)  AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''01'' THEN OriginalAmount ELSE 0 END) AS OriginalCreditYTD,
 			SUM (CASE WHEN (TranMonth + TranYear*100 > '+str(@FromYear)+'*100)  AND (TranMonth +TranYear *100 < ='+str(@ToMonth)+' + '+str(@ToYear)+'*100)  AND (IsNull(TransactiontypeID,'''')<>''T00'' ) AND  RPTransactionType= ''01'' THEN ConvertedAmount ELSE 0 END) AS ConvertedCreditYTD
	'
	SET @sSQL1 = N'
	FROM AV7401 D3 	
	INNER JOIN AT1202 Object  on  Object.ObjectID = D3.ObjectID and Object.DivisionID = D3.DivisionID
	LEFT JOIN AT1015 on	AT1015.AnaID = Object.O01ID and AT1015.DivisionID = Object.DivisionID and AT1015.AnaTypeID =''' + @GroupTypeID + '''
	INNER JOIN AT1005 Account on Account.AccountID = D3.AccountID and Account.DivisionID = D3.DivisionID

	GROUP BY	D3.DivisionID, D3.ObjectID, D3.AccountID, ObjectName,  Object.S1, Object.S2,  Object.S3, 
				Object.O01ID,  Object.O02ID, Object.O03ID, Object.O04ID, Object.O05ID,
				Object.Tel, Object.Fax, Object.Email,
				Address, VATNo, AccountName, D3.CurrencyID,  AT1015.AnaName, ' 
END

--PRINT @sSQL
--PRINT(@sSQL1)
--PRINT(@GroupID)

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7419]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
     EXEC ('  CREATE VIEW AV7419 AS ' + @sSQL + @sSQL1 + @GroupID)
ELSE
     EXEC ('  ALTER VIEW AV7419  AS ' + @sSQL + @sSQL1 + @GroupID)



---Print @sSQL
	
---- Bo phan so 0 
IF @CurrencyID = '%'
	SET @sSQL =   '
		SELECT DivisionID, 
		GroupID,
		GroupName, 
		GroupID1, 
		GroupName1, 
		GroupID2, 
		GroupName2, 
		ObjectID, 
		ObjectName,
		Address, 
		VATNo,
		AccountID, 
		AccountName, (SELECT TOP 1 AccountNameE FROM AT1005 WHERE DivisionID = AV7419.DivisionID AND AccountID = AV7419.AccountID) AccountNameE,
		''%'' AS CurrencyID,
		S1, 
		S2,  
		S3, 
		O01ID,  
		O02ID, 
		O03ID, 
		O04ID, 
		O05ID, 
		Tel, 
		Fax, 
		Email,
		0 AS CreditOriginalOpening ,  
 		0 AS DebitOriginalOpening ,  
		0 AS OriginalOpening,	
		Case when Sum(ConvertedOpening) < 0 then -Sum(ConvertedOpening) else 0 end AS CreditConvertedOpening ,   
		Case when Sum(ConvertedOpening) > 0 then Sum(ConvertedOpening) else 0 end AS DebitConvertedOpening ,   
		Sum(ConvertedOpening) AS ConvertedOpening,
		sum(OriginalDebit) AS OriginalDebit,   
		sum(ConvertedDebit) AS ConvertedDebit,   
		sum(OriginalCredit) AS OriginalCredit,  
		Sum(ConvertedCredit) AS ConvertedCredit,  
		0 AS CreditOriginalClosing ,  
		0 AS DebitOriginalClosing ,  
		sum(OriginalClosing) AS OriginalClosing ,	
		Case when Sum(ConvertedClosing) <0 then -Sum(ConvertedClosing) else 0 end AS CreditConvertedClosing ,   
		Case when Sum(ConvertedClosing) >0 then Sum(ConvertedClosing) else 0 end AS DebitConvertedClosing ,   
		Sum(ConvertedClosing) AS ConvertedClosing ,	
		0 AS OriginalDebitYTD,  
		0 AS ConvertedDebitYTD,  
		0 AS OriginalCreditYTD ,  
		0 AS ConvertedCreditYTD 	
			
	 FROM AV7419 
	 WHERE OriginalOpening <> 0 OR ConvertedOpening <> 0 OR OriginalDebit <> 0 
		OR ConvertedDebit <> 0 OR OriginalCredit <> 0 OR ConvertedCredit <> 0 
		OR OriginalClosing <> 0 OR ConvertedClosing <> 0 
	 GROUP BY DivisionID, GroupID,  GroupName,  GroupID1,   GroupName1,   GroupID2,   GroupName2,
			ObjectID,   ObjectName, Address, VATNo,  AccountID,  AccountName,		
			S1, S2, S3, O01ID,  O02ID, O03ID, O04ID, O05ID, Tel, Fax, Email '

ELSE
	SET @sSQL =  '
		SELECT DivisionID, 
		GroupID, 
		GroupName, 
		GroupID1, 
		GroupName1, 
		GroupID2, 
		GroupName2, 
		ObjectID, 
		ObjectName,
		Address, 
		VATNo,
		AccountID, 
		AccountName, (SELECT TOP 1 AccountNameE FROM AT1005 WHERE DivisionID = AV7419.DivisionID AND AccountID = AV7419.AccountID) AccountNameE,
		CurrencyID,
		S1, 
		S2,  
		S3, 
		O01ID,  
		O02ID, 
		O03ID, 
		O04ID, 
		O05ID, 
		Tel, 
		Fax, 
		Email,
		(Case when OriginalOpening < 0 then abs(OriginalOpening) else 0 end) AS CreditOriginalOpening,
		(Case when OriginalOpening >= 0 then abs(OriginalOpening) else 0 end) AS DebitOriginalOpening,
		OriginalOpening, 
		(Case when ConvertedOpening < 0 then abs(ConvertedOpening) else 0 end) AS CreditConvertedOpening,
		(Case when ConvertedOpening >= 0 then abs(ConvertedOpening) else 0 end) AS DebitConvertedOpening,
		ConvertedOpening, 
		OriginalDebit, 
		ConvertedDebit, 
		OriginalCredit,
		ConvertedCredit,
		(Case when OriginalClosing < 0 then abs(OriginalClosing) else 0 end) AS CreditOriginalClosing,
		(Case when OriginalClosing >= 0 then abs(OriginalClosing) else 0 end) AS DebitOriginalClosing,	 
		OriginalClosing, 
		(Case when ConvertedClosing < 0 then abs(ConvertedClosing) else 0 end) AS CreditConvertedClosing,
		(Case when ConvertedClosing >= 0 then abs(ConvertedClosing) else 0 end) AS DebitConvertedClosing,
		ConvertedClosing,
		OriginalDebitYTD,
		ConvertedDebitYTD, 
		OriginalCreditYTD, 
		ConvertedCreditYTD 
	FROM AV7419 
	WHERE OriginalOpening <> 0 OR ConvertedOpening <> 0 OR OriginalDebit <> 0 
		OR ConvertedDebit <> 0 OR OriginalCredit <> 0 OR ConvertedCredit <> 0 
		OR OriginalClosing <> 0 OR ConvertedClosing <> 0 '
		
----- Print @sSQL 
--IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7409]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
--    EXEC ('  CREATE VIEW AV7409 AS ' + @sSQL)
--ELSE
--    EXEC ('  ALTER VIEW AV7409  AS ' + @sSQL)


	IF @CustomerName = 16  AND @DatabaseName <>'' --- Customize Sieu Thanh in du lieu 2 database
		BEGIN
			EXEC AP7409_ST  @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear,@TypeD, @FromDate, @ToDate,@CurrencyID,@FromAccountID,@ToAccountID, @FromObjectID, @ToObjectID,@Groupby,@StrDivisionID,@DatabaseName 
			SET @sSQLUnion = '
				UNION ALL 
				SELECT  DivisionID,GroupID,GroupName,GroupID1,GroupName1,GroupID2,GroupName2,ObjectID,ObjectName,Address,VATNo,AccountID,AccountName, 
				CurrencyID,S1,S2,S3,O01ID,O02ID,O03ID,O04ID,O05ID,Tel,Fax, Email, CreditOriginalOpening,DebitOriginalOpening,OriginalOpening,
				CreditConvertedOpening,DebitConvertedOpening,ConvertedOpening,OriginalDebit,ConvertedDebit,OriginalCredit,ConvertedCredit, 
				CreditOriginalClosing,DebitOriginalClosing,OriginalClosing,CreditConvertedClosing,DebitConvertedClosing,ConvertedClosing,
				OriginalDebitYTD,ConvertedDebitYTD,OriginalCreditYTD, ConvertedCreditYTD
				FROM AV7409_ST '
				
				IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7409a]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
					EXEC ('  CREATE VIEW AV7409a AS ' + @sSQL + @sSQLUnion )
				ELSE
					EXEC ('  ALTER VIEW AV7409a  AS ' + @sSQL + @sSQLUnion)
	
				SET @sSQL = '
					SELECT  DivisionID,GroupID,Max(Isnull(GroupName,'''')) as GroupName,GroupID1,Max(Isnull(GroupName1,'''')) as GroupName1,
					GroupID2,Max(Isnull(GroupName2,'''')) as GroupName2,
					ObjectID,Max(Isnull(ObjectName,'''')) as ObjectName,
					Address,VATNo,AccountID, Max(Isnull(AccountName,'''')) as AccountName,					
					CurrencyID,S1,S2,S3,O01ID,O02ID,O03ID,O04ID,O05ID,Tel,Fax, Email,
					Case When ( Sum(DebitOriginalOpening) - SUM(CreditOriginalOpening) ) < 0 then   SUM(CreditOriginalOpening) - Sum(DebitOriginalOpening) Else 0  end as CreditOriginalOpening ,
					Case When ( Sum(DebitOriginalOpening) - SUM(CreditOriginalOpening) ) > 0 then   SUM(DebitOriginalOpening) - Sum(CreditOriginalOpening) Else 0  end as DebitOriginalOpening ,
					Sum (OriginalOpening) as OriginalOpening,
					Case When ( Sum(DebitConvertedOpening) - SUM(CreditConvertedOpening) ) < 0 then   SUM(CreditConvertedOpening) - Sum(DebitConvertedOpening) Else 0  end as CreditConvertedOpening ,
					Case When ( Sum(DebitConvertedOpening) - SUM(CreditConvertedOpening) ) > 0 then   SUM(DebitConvertedOpening) - Sum(CreditConvertedOpening) Else 0  end as DebitConvertedOpening ,
					Sum (ConvertedOpening) as ConvertedOpening,
					Sum(OriginalDebit) as OriginalDebit, 
					Sum(ConvertedDebit) as ConvertedDebit, 
					Sum(OriginalCredit) as OriginalCredit,
					Sum(ConvertedCredit) as ConvertedCredit,
					Case When ( Sum(DebitOriginalClosing) - SUM(CreditOriginalClosing) ) < 0 then   SUM(CreditOriginalClosing) - Sum(DebitOriginalClosing) Else 0  end as CreditOriginalClosing ,
					Case When ( Sum(DebitOriginalClosing) - SUM(CreditOriginalClosing) ) > 0 then   SUM(DebitOriginalClosing) - Sum(CreditOriginalClosing) Else 0  end as DebitOriginalClosing ,
					Sum (OriginalClosing) as OriginalClosing,
					Case When ( Sum(DebitConvertedClosing) - SUM(CreditConvertedClosing) ) < 0 then   SUM(CreditConvertedClosing) - Sum(DebitConvertedClosing) Else 0  end as CreditConvertedClosing ,
					Case When ( Sum(DebitConvertedClosing) - SUM(CreditConvertedClosing) ) > 0 then   SUM(DebitConvertedClosing) - Sum(CreditConvertedClosing) Else 0  end as DebitConvertedClosing ,
					Sum (ConvertedClosing) as ConvertedClosing,
					Sum(OriginalDebitYTD) as OriginalDebitYTD ,
					Sum(ConvertedDebitYTD) as ConvertedDebitYTD,
					Sum(OriginalCreditYTD) as OriginalCreditYTD, 
					Sum(ConvertedCreditYTD) as ConvertedCreditYTD
					FROM AV7409a 
					GROUP BY  DivisionID,GroupID,GroupID1, GroupID2,ObjectID,Address,VATNo,AccountID, 
					CurrencyID,S1,S2,S3,O01ID,O02ID,O03ID,O04ID,O05ID,Tel,Fax, Email
					'
		END
	print @sSQL
			
IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7409]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
	EXEC ('  CREATE VIEW AV7409 AS ' + @sSQL )
ELSE
	EXEC ('  ALTER VIEW AV7409  AS ' + @sSQL )
	
			
			
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

