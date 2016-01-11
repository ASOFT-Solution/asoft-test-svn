IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7405]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP7405]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- <Summary>
---- In chi tiet no phai thu
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 27/08/2003 by Nguyen Van Nhan
----
----- Edited by Nguyen Thi Ngoc Minh, Date 27/04/2004
----- Purpose: Cho phep chon loai ngay len bao cao theo ngay  va theo ky
----- Last Edited by Van Nhan, Date 15/09/2004
----- Last Edited by Quoc Huy, Date 26/07/2006
----- Last Edited by Thuy Tuyen, Date 24/08/2007 -- Lay Ten Tai Khoan
----- Edited by Dang Le Bao Quynh, Date 04/07/2008
----- Purpose: Bo sung view phuc in chi tiet phai thu theo ma phan tich
---- Modified on 13/01/2011 by Le Thi Thu Hien : Sua in theo ngay
---- Modified on 15/03/2012 by Le Thi Thu Hien : B? sung tr??ng h?p in không có phát sinh thì không lên ??u k?
---- Modified on 25/10/2012 by Bao Anh : B? sung TableID, Status
---- Modified on 05/03/2013 by Khanh Van : In tu tai khoan den tai khoan cho Sieu Thanh
---- Modified on 27/05/2013 by Lê Th? Thu Hi?n : B? sung thêm Ana06ID --> Ana10ID
---- Modified by on 15/10/2014 by Hu?nh T?n Phú : B? sung ?i?u ki?n l?c theo 10 mã phân tích. 0022751: [VG] In s? d? ??u k? lên sai d?n ??n s? d? cu?i k? sai. 
---- Modified by on 31/10/2014 by Mai Duyen : Sua loi khong in duoc bao cao
---- Modified on 12/11/2014 by Mai Duyen : B? sung thêm DatabaseName (tinh n?ng In báo cao chi tiet no phai thu 2 Database, KH SIEUTHANH)
---- Modified on 05/12/2014 by Mai Duyen : Bo sung field DB (Customized bao cao 2 DB cho SIEU THANH)
---- Modified on 08/12/2014 by Mai Duyen : Fix sum  so du dau cua 2 DB
---- Modified on 30/12/2014 by Mai Duyen : Sua lai dieu kien ket du lieu cua view AV7405a
---- Modified on 06/04/2015 by Thanh Sơn: Bổ sung trường AccountNameE
---- Modified on 10/09/2015 by Tiểu Mai: Bổ sung tên 10 MPT, 10 tham số

-- <Example>
---- 

CREATE PROCEDURE [dbo].[AP7405]
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
					@FromObjectID  AS nvarchar(50),
					@ToObjectID  AS nvarchar(50),
					@SqlFind AS NVARCHAR(500),
					@DatabaseName as varchar(250)=''
	
 AS
DECLARE @sSQL AS nvarchar(MAX),
		@sSQL1 AS nvarchar(MAX),
		@sSQLUnionAll AS nvarchar(MAX),
		@SQLwhere AS nvarchar(MAX),
		@SQLwhereAna AS nvarchar(MAX),
		@TypeDate AS nvarchar(20),
		@SQLObject AS nvarchar(MAX),
		@sqlGroup AS nvarchar(MAX),
		@FromPeriod AS int,
		@ToPeriod AS int
		

Declare @CustomerName INT
--Tao bang tam de kiem tra day co phai la khach hang Sieu Thanh khong (CustomerName = 16)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)
		

IF @TypeD = 1   --- Ngay HT
	SET @TypeDate ='InvoiceDate'
ELSE IF @TypeD=2  --- Nga HD
	SET @TypeDate = 'VoucherDate'
ELSE IF @TypeD=3   --Ngay Dao han
	SET @TypeDate = 'DueDate'

SET @FromPeriod = (@FromMonth + @FromYear * 100)	
SET @ToPeriod = (@ToMonth + @ToYear * 100)	

IF @TypeD in (1, 2, 3)   -- Theo ngay
	SET @SQLwhere = ' AND (CONVERT(DATETIME,CONVERT(varchar(10),D3.' + LTRIM(RTRIM(@TypeDate)) + ',101),101) BETWEEN ''' + CONVERT(varchar(10), @FromDate, 101) + ''' AND ''' + CONVERT(varchar(10), @ToDate, 101) + ''') '
ELSE    ---Theo ky
	SET @SQLwhere = ' AND (D3.TranMonth + 100 * D3.TranYear BETWEEN ' + str(@FromPeriod) + ' AND '+ str(@ToPeriod) + ')'
	
------ Loc ra cac phan tu
EXEC AP7404  @DivisionID, @CurrencyID, @FromAccountID, @ToAccountID, @FromObjectID, @ToObjectID, @SQLwhere 

------- Xac dinh so du co cac doi tuong
EXEC AP7414 @DivisionID, @FromObjectID, @ToObjectID, @FromAccountID, @ToAccountID, @CurrencyID, @FromPeriod,  @FromDate, @TypeD, @TypeDate,@SqlFind

IF @TypeD = 4 ---  Tinh tu ky den ky
  BEGIN	
	
	SET @SQLwhere = '
		WHERE (ISNULL(AV7404.ObjectID, AV7414.ObjectID) between ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''') 
	and (ISNULL(AV7404.AccountID, AV7414.AccountID) between ''' + @FromAccountID+ ''' AND ''' + @ToAccountID + ''')'
	SET @SQLwhereAna ='
		WHERE (ISNULL(AV7404.ObjectID, AV7424.ObjectID) between ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''')
	and (ISNULL(AV7404.AccountID, AV7424.AccountID) between ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''')'
			
	IF @CurrencyID <> '%'
		Begin
			SET @SQLwhere = @SQLwhere + ' AND ISNULL(AV7404.CurrencyID, AV7414.CurrencyID) like ''' + @CurrencyID + ''' ' 
			SET @SQLwhereAna = @SQLwhereAna + ' AND  ISNULL(AV7404.CurrencyID, AV7424.CurrencyID) like  ''' + @CurrencyID + ''' ' 
		End
	
   END
ELSE    ---- Xac dinh theo Ngay
  BEGIN
	
	SET @SQLwhere = '
		WHERE (ISNULL(AV7404.ObjectID, AV7414.ObjectID) between ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''')
		 AND AV7404.DivisionId = ''' + @DivisionID + '''	AND (ISNULL(AV7404.AccountID, AV7414.AccountID) between ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''') '
	SET @SQLwhereAna = '
		WHERE (ISNULL(AV7404.ObjectID, AV7424.ObjectID) between ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''') 
		 AND AV7404.DivisionID = ''' + @DivisionID + '''	AND (ISNULL(AV7404.AccountID, AV7424.AccountID) between ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''')'
	
	IF @CurrencyID <> '%'
		Begin
			SET @SQLwhere = @SQLwhere + ' AND ISNULL(AV7404.CurrencyID, AV7414.CurrencyID) like ''' + @CurrencyID + ''' ' 
			SET @SQLwhereAna = @SQLwhereAna + ' AND ISNULL(AV7404.CurrencyID, AV7424.CurrencyID) like ''' + @CurrencyID + ''' ' 
		End
  END	
---In khong co ma phan tich 1
	SET @sSQL = '
		SELECT (ISNULL(AV7404.ObjectID, AV7414.ObjectID) + ISNULL(AV7404.AccountID, AV7414.AccountID)) AS GroupID,
			BatchID,
			VoucherID,
			TableID, Status,
			AV7404.DivisionID,
			TranMonth,
			TranYear, 
			Cast(ISNULL(AV7404.AccountID, AV7414.AccountID) AS char(20)) + 
			cast(ISNULL(AV7404.ObjectID, AV7414.ObjectID)  AS char(20)) + 
			cast(ISNULL(AV7404.CurrencyID,AV7414.CurrencyID) AS char(20)) + 
			cast(Day(VoucherDate) + Month(VoucherDate)* 100 +
			Year(VoucherDate) * 10000 AS char(8)) + 
			cast(VoucherID AS char(20)) + 
			(Case when RPTransactionType = ''00'' then ''0'' ELSE ''1'' end) AS Orders,
			RPTransactionType,
			TransactionTypeID,
			ISNULL(AV7404.ObjectID, AV7414.ObjectID) AS ObjectID,  
			ISNULL(AT1202.ObjectName,AV7414.ObjectName) AS ObjectName,
			AT1202.Address, AT1202.VATNo,
			DebitAccountID, CreditAccountID, 
			ISNULL(AV7404.AccountID, AV7414.AccountID) AS AccountID,
			ISNULL(AT1005.AccountName, AV7414.AccountName) AS AccountName,
			ISNULL(AT1005.AccountNameE, AV7414.AccountNameE) AS AccountNameE,
			VoucherTypeID,
			VoucherNo,
			VoucherDate,
			InvoiceNo,
			InvoiceDate,
			Serial,
			VDescription, 
			ISNULL(TDescription,ISNULL(BDescription,VDescription)) AS BDescription,
			TDescription,
			AV7404.Ana01ID,	AV7404.Ana02ID, AV7404.Ana03ID,	AV7404.Ana04ID,	AV7404.Ana05ID,
			AV7404.Ana06ID,	AV7404.Ana07ID,	AV7404.Ana08ID,	AV7404.Ana09ID,	AV7404.Ana10ID,
			--AV7404.Ana01Name,AV7404.Ana02Name,AV7404.Ana03Name,AV7404.Ana04Name,AV7404.Ana05Name,
			--AV7404.Ana06Name,AV7404.Ana07Name,AV7404.Ana08Name,AV7404.Ana09Name,AV7404.Ana10Name,
			--Parameter01,Parameter02,Parameter03,Parameter04,Parameter05,
			--Parameter06,Parameter07,Parameter08,Parameter09,Parameter10,
			ISNULL(AV7404.CurrencyID, AV7414.CurrencyID) AS CurrencyID,
			ExchangeRate,
			AV7404.CreateDate,
			Sum(Case When RPTransactionType = ''00'' then ISNULL(OriginalAmount, 0) ELSE 0 End) AS DebitOriginalAmount,
			Sum(Case When RPTransactionType = ''01'' then ISNULL(OriginalAmount, 0) ELSE 0 End) AS CreditOriginalAmount,
			Sum(Case When RPTransactionType = ''00'' then ISNULL(ConvertedAmount, 0) ELSE 0 End) AS DebitConvertedAmount,
			Sum(Case When RPTransactionType = ''01'' then ISNULL(ConvertedAmount, 0) ELSE 0 End) AS CreditConvertedAmount,
			ISNULL(AV7414.OpeningOriginalAmount, 0)  AS OpeningOriginalAmount,
			ISNULL(AV7414.OpeningConvertedAmount, 0) AS OpeningConvertedAmount,
			sum(ISNULL(SignConvertedAmount, 0)) AS SignConvertedAmount,
			sum(ISNULL(SignOriginalAmount, 0)) AS SignOriginalAmount,
			cast(0 as decimal(28,8)) AS ClosingOriginalAmount,
			cast(0 as decimal(28,8)) AS ClosingConvertedAmount,
			Duedate,
			Parameter01, Parameter02,
			Parameter03, Parameter04,
			Parameter05, Parameter06,
			Parameter07, Parameter08,
			Parameter09, Parameter10	
				
	FROM	AV7404 
	LEFT JOIN AT1202 on	AT1202.ObjectID = AV7404.ObjectID AND AT1202.DivisionID = AV7404.DivisionID 
	FULL JOIN AV7414 on AV7414.ObjectID = AV7404.ObjectID AND AV7414.AccountID = AV7404.AccountID	AND AV7414.DivisionID = AV7404.DivisionID					
	LEFT JOIN AT1005 on AT1005.AccountID = AV7404.AccountID  AND AT1005.DivisionID = AV7404.DivisionID ' + @SQLwhere + '
	
	GROUP BY BatchID, VoucherID, TableID, Status, AV7404.DivisionID, TranMonth, TranYear, 
			RPTransactionType, TransactionTypeID, AV7404.ObjectID, AV7414.ObjectID,
			DebitAccountID, CreditAccountID, AV7404.AccountID, AV7414.AccountID, 
			VoucherTypeID, VoucherNo, VoucherDate,AV7414.OpeningOriginalAmount, AV7414.OpeningConvertedAmount,
			InvoiceNo, InvoiceDate, Serial, VDescription,  BDescription, TDescription, 
			AV7404.Ana01ID,	AV7404.Ana02ID, AV7404.Ana03ID,	AV7404.Ana04ID,	AV7404.Ana05ID,
			AV7404.Ana06ID,	AV7404.Ana07ID,	AV7404.Ana08ID,	AV7404.Ana09ID,	AV7404.Ana10ID,
			AV7404.CreateDate,
			AV7404.CurrencyID, AV7414.CurrencyID, ExchangeRate, AT1202.ObjectName, 
			AT1202.Address, AT1202.VATNo, 
			AV7414.ObjectName, AT1005.AccountName, AT1005.AccountNameE, AV7414.AccountName, AV7414.AccountNameE, Duedate,
			Parameter01, Parameter02,
			Parameter03, Parameter04,
			Parameter05, Parameter06,
			Parameter07, Parameter08,
			Parameter09, Parameter10 '
SET @sSQL1 = '
	UNION ALL
	SELECT (ISNULL( AV7414.ObjectID, '''') + ISNULL( AV7414.AccountID, '''')) AS GroupID,
			NULL AS BatchID,
			NULL AS VoucherID,
			NULL as TableID,
			NULL as Status,
			AV7414.DivisionID,
			NULL AS TranMonth,
			NULL AS TranYear, 
			Cast(ISNULL(AV7414.AccountID , '''') AS char(20)) + 
			cast(ISNULL(AV7414.ObjectID, '''')  AS char(20)) + 
			cast(ISNULL(AV7414.CurrencyID, '''') AS char(20))  AS Orders,
			NULL AS RPTransactionType,
			NULL AS TransactionTypeID,
			ISNULL( AV7414.ObjectID,'''') AS ObjectID,  
			ISNULL(AV7414.ObjectName , '''') AS ObjectName,
			AT1202.Address, AT1202.VATNo,
			NULL AS DebitAccountID, 
			NULL AS CreditAccountID, 
			ISNULL(AV7414.AccountID, '''') AS AccountID,
			ISNULL(AV7414.AccountName, '''' ) AS AccountName,
			ISNULL(AV7414.AccountNameE, '''' ) AS AccountNameE,
			NULL AS VoucherTypeID,
			NULL AS VoucherNo,
			CONVERT(DATETIME, NULL) AS VoucherDate,
			NULL AS InvoiceNo,
			CONVERT(DATETIME, NULL) AS InvoiceDate,
			NULL AS Serial,
			NULL AS VDescription, 
			NULL AS BDescription,
			NULL AS TDescription,
			Cast (AV7414.Ana01ID as nvarchar(50)),
			Cast (AV7414.Ana02ID as nvarchar(50)),
			Cast (AV7414.Ana03ID as nvarchar(50)),
			Cast (AV7414.Ana04ID as nvarchar(50)),
			Cast (AV7414.Ana05ID as nvarchar(50)),
			Cast (AV7414.Ana06ID as nvarchar(50)),
			Cast (AV7414.Ana07ID as nvarchar(50)),
			Cast (AV7414.Ana08ID as nvarchar(50)),
			Cast (AV7414.Ana09ID as nvarchar(50)),
			Cast (AV7414.Ana10ID as nvarchar(50)),
			
			AV7414.CurrencyID AS CurrencyID,
			0 AS ExchangeRate,
			CONVERT(DATETIME, NULL)CreateDate,
			0 AS DebitOriginalAmount,
			0 AS CreditOriginalAmount,
			0 AS DebitConvertedAmount,
			0 AS CreditConvertedAmount,
			ISNULL(AV7414.OpeningOriginalAmount, 0)  AS OpeningOriginalAmount,
			ISNULL(AV7414.OpeningConvertedAmount, 0) AS OpeningConvertedAmount,
			0 AS SignConvertedAmount,
			0 AS SignOriginalAmount,
			cast(0 as decimal(28,8)) AS ClosingOriginalAmount,
			cast(0 as decimal(28,8)) AS ClosingConvertedAmount,
			CONVERT(DATETIME, NULL) AS Duedate,
			NULL as Parameter01, NULL as Parameter02,
			NULL as Parameter03, NULL as Parameter04,
			NULL as Parameter05, NULL as Parameter06,
			NULL as Parameter07, NULL as Parameter08,
			NULL as Parameter09, NULL as Parameter10	
				
	FROM	AV7414 
	LEFT JOIN AT1202 ON AT1202.ObjectID = AV7414.ObjectID AND AT1202.DivisionID = AV7414.DivisionID
	WHERE	AV7414.ObjectID + AV7414.AccountID NOT IN ( SELECT DISTINCT ObjectID+AccountID FROM AV7404 )
	
	'
	
--PRINT @sSQL	
--PRINT @sSQL1
IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7415]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
     EXEC ('  CREATE VIEW AV7415 AS ' + @sSQL + @sSQL1)
ELSE
     EXEC ('  ALTER VIEW AV7415  AS ' + @sSQL + @sSQL1)
     

--In khong co ma phan tich 1
	IF @CustomerName = 16   --- Customize Sieu Thanh in du lieu 2 database
		SET @sSQL = ' SELECT 1 as DB , '
	ELSE
		SET @sSQL = ' SELECT '
		
SET @sSQL =  @sSQL + '
				 AV7415.GroupID,AV7415.BatchID,AV7415.VoucherID,AV7415.TableID,AV7415.Status,AV7415.DivisionID,AV7415.TranMonth,AV7415.TranYear,AV7415.RPTransactionType,AV7415.TransactionTypeID,
				AV7415.ObjectID,AV7415.ObjectName,AV7415.Address,AV7415.VATNo,AT1202.S1,AT1202.S2,AT1202.S3,AT1202.Tel,AT1202.Fax,AT1202.Email,
				AV7415.DebitAccountID,A01.AccountName AS DebitAccountName,AV7415.CreditAccountID, A02.AccountName AS CreditAccountName,
				AV7415.AccountID, AV7415.AccountName, AV7415.AccountNameE, AV7415.VoucherTypeID,AV7415.VoucherNo,AV7415.VoucherDate,AV7415.InvoiceNo,AV7415.InvoiceDate, AV7415.Serial,AV7415.VDescription,AV7415.BDescription,AV7415.TDescription,
				AV7415.Ana01ID,AV7415.Ana02ID,AV7415.Ana03ID,	AV7415.Ana04ID,	AV7415.Ana05ID,AV7415.Ana06ID,	AV7415.Ana07ID,	AV7415.Ana08ID,	AV7415.Ana09ID,
				AV7415.Ana10ID,
				A11.AnaName AS Ana01Name,A12.AnaName AS Ana02Name,A13.AnaName AS Ana03Name,A14.AnaName AS Ana04Name,A15.AnaName AS Ana05Name,
				A16.AnaName AS Ana06Name,A17.AnaName AS Ana07Name,A18.AnaName AS Ana08Name,A19.AnaName AS Ana09Name,A10.AnaName AS Ana10Name,
				O01ID,	O02ID,	O03ID,	O04ID,	O05ID,AV7415.CurrencyID,AV7415.ExchangeRate,
				Sum(DebitOriginalAmount) AS DebitOriginalAmount,Sum(CreditOriginalAmount) AS CreditOriginalAmount,
				Sum(DebitConvertedAmount) AS DebitConvertedAmount,Sum(CreditConvertedAmount) AS CreditConvertedAmount,
				OpeningOriginalAmount,OpeningConvertedAmount,
				sum(ISNULL(SignConvertedAmount, 0)) AS SignConvertedAmount,sum(ISNULL(SignOriginalAmount, 0)) AS SignOriginalAmount,
				ClosingOriginalAmount,ClosingConvertedAmount ,
				CAST (AV7415.TranMonth AS Varchar)  + ''/'' + CAST (AV7415.TranYear AS Varchar) AS MonthYear,
				CONVERT(varchar(20), AV7415.Duedate, 103) AS duedate,
				''' + CONVERT(varchar(10), @FromDate, 103) + ''' AS Fromdate,
				(case when' + str(@TypeD) + ' = 0 then ''30/' + Ltrim (str(@ToMonth)) + '/' + ltrim(str(@ToYear)) + ''' ELSE ''' + CONVERT(varchar(10), @ToDate,103) + ''' end) AS Todate,
				Parameter01,Parameter02,Parameter03,Parameter04,Parameter05,Parameter06,Parameter07,Parameter08,Parameter09,Parameter10
		FROM AV7415 
		INNER JOIN AT1202 on AT1202.ObjectID = AV7415.ObjectID AND AT1202.DivisionID = AV7415.DivisionID
		LEFT JOIN AT1005 A01 on A01.AccountID  = AV7415.DebitAccountID AND A01.DivisionID  = AV7415.DivisionID
		LEFT JOIN AT1005 A02 on A02.AccountID  = AV7415.CreditAccountID AND A02.DivisionID  = AV7415.DivisionID
		LEFT JOIN AT1011 A11 on A11.AnaID = AV7415.Ana01ID AND A11.DivisionID=AV7415.DivisionID AND A11.AnaTypeID = ''A01''
		LEFT JOIN AT1011 A12 on A12.AnaID = AV7415.Ana01ID AND A12.DivisionID=AV7415.DivisionID AND A12.AnaTypeID = ''A02''
		LEFT JOIN AT1011 A13 on A13.AnaID = AV7415.Ana01ID AND A13.DivisionID=AV7415.DivisionID AND A13.AnaTypeID = ''A03''
		LEFT JOIN AT1011 A14 on A14.AnaID = AV7415.Ana01ID AND A14.DivisionID=AV7415.DivisionID AND A14.AnaTypeID = ''A04''
		LEFT JOIN AT1011 A15 on A15.AnaID = AV7415.Ana01ID AND A15.DivisionID=AV7415.DivisionID AND A15.AnaTypeID = ''A05''
		LEFT JOIN AT1011 A16 on A16.AnaID = AV7415.Ana01ID AND A16.DivisionID=AV7415.DivisionID AND A16.AnaTypeID = ''A06''
		LEFT JOIN AT1011 A17 on A17.AnaID = AV7415.Ana01ID AND A17.DivisionID=AV7415.DivisionID AND A17.AnaTypeID = ''A07''
		LEFT JOIN AT1011 A18 on A18.AnaID = AV7415.Ana01ID AND A18.DivisionID=AV7415.DivisionID AND A18.AnaTypeID = ''A08'' 
		LEFT JOIN AT1011 A19 on A19.AnaID = AV7415.Ana01ID AND A19.DivisionID=AV7415.DivisionID AND A19.AnaTypeID = ''A09''
		LEFT JOIN AT1011 A10 on A10.AnaID = AV7415.Ana01ID AND A10.DivisionID=AV7415.DivisionID AND A10.AnaTypeID = ''A10''
		WHERE (DebitOriginalAmount <> 0 OR CreditOriginalAmount <> 0 
				OR DebitConvertedAmount <> 0 OR CreditConvertedAmount <> 0 
				OR OpeningOriginalAmount <> 0 OR OpeningConvertedAmount <> 0)
			
		GROUP BY AV7415. GroupID, AV7415.BatchID,AV7415.VoucherID, AV7415.TableID,AV7415.Status,AV7415.DivisionID, AV7415.TranMonth, AV7415.TranYear, 
				AV7415.RPTransactionType, AV7415.TransactionTypeID, AV7415.ObjectID, 
				AV7415.Address, AV7415.VATNo,  
				AT1202.S1, AT1202.S2, AT1202.S3, AT1202.Tel, AT1202.Fax, AT1202.Email,
				AV7415.DebitAccountID, AV7415.CreditAccountID,
				AV7415. AccountID, 
				AV7415.VoucherTypeID, AV7415.VoucherNo, AV7415.VoucherDate, AV7415.OpeningOriginalAmount, AV7415.OpeningConvertedAmount,
				AV7415.InvoiceNo, AV7415.InvoiceDate, AV7415.Serial, AV7415.VDescription,  AV7415.BDescription, AV7415.TDescription, 
				AV7415.Ana01ID,	AV7415.Ana02ID,	AV7415.Ana03ID,	AV7415.Ana04ID,	AV7415.Ana05ID,
				AV7415.Ana06ID,	AV7415.Ana07ID,	AV7415.Ana08ID,	AV7415.Ana09ID,	AV7415.Ana10ID, 
				A11.AnaName,
				O01ID,O02ID,O03ID, O04ID,O05ID,
				AV7415.CurrencyID, AV7415.ExchangeRate, AV7415.ObjectName, 
				AV7415. AccountName, AV7415. AccountNameE, ClosingOriginalAmount, ClosingConvertedAmount, 
				A01.AccountName,  A02.AccountName,AV7415.Duedate,A11.AnaName,A12.AnaName,A13.AnaName ,A14.AnaName,A15.AnaName,
				A16.AnaName,A17.AnaName,A18.AnaName,A19.AnaName,A10.AnaName,
				Parameter01,Parameter02,Parameter03,Parameter04,Parameter05,Parameter06,Parameter07,Parameter08,Parameter09,Parameter10'

SET @sSQL1 = ''
				
	IF @CustomerName = 16  AND @DatabaseName <>'' --- Customize Sieu Thanh in du lieu 2 database
		BEGIN
			Exec AP7405_ST @DivisionID, @FromMonth, @FromYear,@ToMonth,@ToYear,@TypeD,@FromDate,@ToDate,@CurrencyID,@FromAccountID,@ToAccountID,@FromObjectID,@ToObjectID,@SqlFind,@DatabaseName
			SET @sSQLUnionAll ='		 
				UNION ALL
					SELECT  2 as DB , GroupID,  BatchID,VoucherID,TableID,Status,DivisionID,TranMonth,TranYear,RPTransactionType,TransactionTypeID,
					ObjectID,ObjectName,Address,VATNo,S1,S2,S3,Tel,Fax,Email,
					DebitAccountID,DebitAccountName,CreditAccountID,CreditAccountName,
					AccountID,AccountName,VoucherTypeID,VoucherNo,VoucherDate,InvoiceNo,InvoiceDate, Serial,VDescription,BDescription,TDescription,
					Ana01ID,Ana02ID,Ana03ID,Ana04ID,Ana05ID,Ana06ID,Ana07ID,Ana08ID,Ana09ID,
					Ana10ID,Ana01Name,O01ID,O02ID,O03ID,O04ID,O05ID,CurrencyID,ExchangeRate,
					DebitOriginalAmount, CreditOriginalAmount,
					DebitConvertedAmount,CreditConvertedAmount,
					OpeningOriginalAmount, OpeningConvertedAmount,
					SignConvertedAmount,SignOriginalAmount,
					ClosingOriginalAmount,ClosingConvertedAmount ,
					MonthYear,duedate,Fromdate,Todate  
					FROM AV7405_ST '
					
				IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7405a]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
					EXEC ('  CREATE VIEW AV7405a AS ' + @sSQL + @sSQLUnionAll)
				ELSE
					EXEC ('  ALTER VIEW AV7405a  AS ' + @sSQL + @sSQLUnionAll)
					
					
				SET @sSQL = 'SELECT  DB,AV7405a.GroupID as GroupID,  BatchID,VoucherID,TableID,Status,DivisionID,TranMonth,TranYear,RPTransactionType,TransactionTypeID,
					ObjectID,ObjectName,Address,VATNo,S1,S2,S3,Tel,Fax,Email,
					DebitAccountID,DebitAccountName,CreditAccountID,CreditAccountName, 
					AccountID,AccountName, VoucherTypeID,VoucherNo,VoucherDate,InvoiceNo,InvoiceDate, Serial,VDescription,BDescription,TDescription,
					Ana01ID,Ana02ID,Ana03ID,Ana04ID,Ana05ID,Ana06ID,Ana07ID,Ana08ID,Ana09ID,
					Ana10ID,Ana01Name,O01ID,O02ID,O03ID,O04ID,O05ID,CurrencyID,ExchangeRate,
					DebitOriginalAmount, CreditOriginalAmount,
					DebitConvertedAmount,CreditConvertedAmount,
					--OpeningOriginalAmount, OpeningConvertedAmount,
					SignConvertedAmount,SignOriginalAmount,
					ClosingOriginalAmount,ClosingConvertedAmount ,
					MonthYear,duedate,Fromdate,Todate  ,
					(T08.OpeningOriginalAmount +  T09.OpeningOriginalAmount )  as  OpeningOriginalAmount,
					(T08.OpeningConvertedAmount +  T09.OpeningConvertedAmount )  as  OpeningConvertedAmount
					FROM AV7405a 
					Left Join (Select Distinct  GroupID, OpeningOriginalAmount,OpeningConvertedAmount  From AV7405a Where DB =1 ) T08 On AV7405a.GroupID = T08.GroupID  
					Left Join (Select Distinct  GroupID , OpeningOriginalAmount,OpeningConvertedAmount  From AV7405a Where DB =2 ) T09 On AV7405a.GroupID = T09.GroupID 
					
					 '
		END 
		--Print @sSQL		

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7405]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
	EXEC ('  CREATE VIEW AV7405 AS ' + @sSQL )
ELSE
	EXEC ('  ALTER VIEW AV7405  AS ' + @sSQL )


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
