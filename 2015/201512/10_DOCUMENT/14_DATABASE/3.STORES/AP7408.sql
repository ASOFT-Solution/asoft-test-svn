IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7408]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP7408]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
---- In chi tiet cong no phai tra
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
-----Created by Nguyen Van Nhan, Date 29/08/2003
-----
-----Edited by Nguyen Thi Ngoc Minh, Date 27/04/2004
-----Purpose: Cho phep chon loai ngay len bao cao theo ngay  va theo ky
-----Edited by Nguyen Quoc Huy, Date 27/04/2007
-----Edited by Dang Le Bao Quynh, Date 29/12/2008
-----Purpose: Bo sung view phuc in chi tiet phai tra theo ma phan tich
-----Edited by Dang Le Bao Quynh, Date 03/11/2009
-----Purpose: Bo sung Ana01 trong cau lenh full join tao view AV7428
---- Modified on 16/01/2012 by Le Thi Thu Hien : Chinh sua where ngay
---- Modified on 27/10/2012 by Bao Anh: Bo sung TableID, Status
---- Modified on 05/03/2013 by Khanh Van: Bo sung lay len tu tai khoan den tai khoan cho Sieu Thanh 
---- Modified on 25/07/2013 by Lê Thị Thu Hiền : Bổ sung thêm Ana06ID --> Ana10ID
---- Modified by on 15/10/2014 by Huỳnh Tấn Phú : Bổ sung điều kiện lọc theo 10 mã phân tích. 0022752: [VG] In số dư đầu kỳ lên sai dẫn đến số dư cuối kỳ sai. 
---- Modified on 13/11/2014 by Mai Duyen : Bổ sung thêm DatabaseName (tinh năng In báo cao chi tiet no phai tra 2 Database, KH SIEUTHANH)
---- Modified on 04/12/2014 by Mai Duyen : Fix loi convert Ana
---- Modified on 05/12/2014 by Mai Duyen : Bo sung field DB (Customized bao cao 2 DB cho SIEU THANH)
---- Modified on 08/12/2014 by Mai Duyen : Fix sum  so du dau cua 2 DB
---- Modified on 30/12/2014 by Mai Duyen : Sua lai dieu kien ket du lieu cua view AV7408a, AV7429a
---- Modified on 30/12/2014 by Thanh Sơn: Bổ sung định danh trường ObjectID
---- Modified on 10/09/2015 by Tiểu Mai: Bổ sung tên 10 MPT, 10 tham số Parameter.
---- Modified on 16/12/2015 by Tiểu Mai: fix bug
-- <Example>
---- exec AP7408 @DivisionID=N'AS',@FromMonth=1,@FromYear=2013,@ToMonth=1,@ToYear=2013,@TypeD=4,@FromDate='2013-05-27 08:44:55.65',@ToDate='2013-05-27 08:44:55.65',@CurrencyID=N'VND',@FromAccountID=N'3111',@ToAccountID=N'3562',@FromObjectID=N'0000000001',@ToObjectID=N'SZ.0001'

CREATE PROCEDURE [dbo].[AP7408]
					@DivisionID AS nvarchar(50),
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
					@SqlFind AS NVARCHAR(MAX),
					@DatabaseName as nvarchar(250) =''
					
 AS
Declare @sqlSelect nvarchar(Max),
		@sqlFrom nvarchar(Max),
        @sqlGroupBy nvarchar(Max);
        
Declare @sqlSelect1 nvarchar(Max),
		@sqlFrom1 nvarchar(Max),
        @sqlGroupBy1 nvarchar(Max);
          
Declare @sSQL AS nvarchar(Max),
		@SQLwhere AS nvarchar(Max),
		@SQLwhere1 AS nvarchar(Max),
		@sSQLUnion AS nvarchar(Max),
		@sSQLUnion1 AS nvarchar(Max),
		@SQLwhereAna AS nvarchar(Max),
		@TypeDate AS nvarchar(50),
		@FromPeriod AS int,
		@ToPeriod AS int,
		@TmpDivisionID AS nvarchar(50)

Declare @CustomerName INT
--Tao bang tam de kiem tra day co phai la khach hang Sieu Thanh khong (CustomerName = 16)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)


IF @TypeD = 1 	---- Ngay Hoa don
	SET @TypeDate = 'InvoiceDate'
ELSE IF @TypeD = 2 	---- Ngay chung tu
	SET @TypeDate = 'VoucherDate'
       ELSE IF @TypeD = 3 	---- Theo Ngay dao han
		SET @TypeDate = 'DueDate'

SET @FromPeriod = (@FromMonth + @FromYear * 100)	
SET @ToPeriod = (@ToMonth + @ToYear * 100)	

IF @TypeD in (1, 2, 3)   -- Theo ngay	
	SET @SQLwhere = ' AND (CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) BETWEEN ''' +	CONVERT(NVARCHAR(10), @FromDate, 101) + ''' AND ''' + CONVERT(NVARCHAR(10), @ToDate, 101)+''')  '
ELSE    ---Theo ky
	SET @SQLwhere = ' AND (D3.TranMonth + 100 * D3.TranYear BETWEEN ' + str(@FromPeriod) + ' AND ' + str(@ToPeriod) + ') '

----------	 Xac dinh so phat sinh
EXEC AP7407  @DivisionID, @CurrencyID, @FromAccountID, @ToAccountID, @FromObjectID, @ToObjectID, @SQLwhere

----------	  Xac dinh so du 
EXEC AP7417 @DivisionID, @FromObjectID, @ToObjectID, @FromAccountID, @ToAccountID, @CurrencyID, @FromPeriod,  @FromDate, @TypeD, @TypeDate,@SqlFind

	/*
	SET @SQLwhere='
	WHERE
			(isnull(AV7407.ObjectID, AV7417.ObjectID ) between  ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''')  and
			(isnull(AV7407.AccountID, AV7417.AccountID ) like  '''+@AccountID+'%''  )   '

	IF @CurrencyID <>'%'
		SET @SQLwhere = @SQLwhere+' and  isnull(AV7407.CurrencyIDCN, AV7417.CurrencyIDCN)  like  '''+@CurrencyID+'''  ' 
	*/
SET @SQLwhere = '
	WHERE (isnull(AV7407.ObjectID, AV7417.ObjectID) between ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''')  and (isnull(AV7407.AccountID, AV7417.AccountID) between ''' + @FromAccountID + ''' and ''' + @ToAccountID + ''')  '
		
SET @SQLwhereAna = '
	WHERE (isnull(AV7407.ObjectID, AV7427.ObjectID) between ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''')  and (isnull(AV7407.AccountID, AV7427.AccountID) between ''' + @FromAccountID + ''' and ''' + @ToAccountID + ''') '
		
IF @CurrencyID <> '%'
	BEGIN
		SET @SQLwhere = @SQLwhere + ' and  isnull(AV7407.CurrencyIDCN, AV7417.CurrencyIDCN) like  ''' + @CurrencyID + '''  ' 
		SET @SQLwhereAna = @SQLwhereAna + ' and  isnull(AV7407.CurrencyIDCN, AV7427.CurrencyIDCN) like ''' + @CurrencyID + '''  ' 
	END

	--Khong co ma phan tich
	SET @sqlSelect = N'
	SELECT (ltrim(rtrim(isnull(AV7407.ObjectID, AV7417.ObjectID))) + ltrim(rtrim(isnull(AV7407.AccountID, AV7417.AccountID)))) AS GroupID,
			BatchID,
			VoucherID,
			AV7407.TableID, AV7407.Status,
			AV7407.DivisionID,
			TranMonth,
			TranYear, 
			Cast(Isnull(AV7407.AccountID, AV7417.AccountID) AS char(20)) + 
				cast(isnull(AV7407.ObjectID, AV7417.ObjectID)  AS char(20)) + 
				cast(isnull(AV7407.CurrencyIDCN, AV7417.CurrencyIDCN) AS char(20)) + 
				cast(Day(VoucherDate) + Month(VoucherDate)* 100 +
				Year(VoucherDate)*10000 AS char(8)) + 
				cast(VoucherID AS char(20)) + 
				(Case when RPTransactionType = ''00'' then ''0'' ELSE ''1'' end) AS Orders,
			RPTransactionType , TransactionTypeID,
			Isnull(AV7407.ObjectID, AV7417.ObjectID) AS ObjectID,
			isnull(AT1202.ObjectName,AV7417.ObjectName)  AS ObjectName,
			AT1202.Address, AT1202.VATNo,
			AT1202.S1, AT1202.S2, AT1202.S3, AT1202.Tel, AT1202.Fax, AT1202.Email,
			AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
			DebitAccountID, CreditAccountID, 
			Isnull(AV7407.AccountID, AV7417.AccountID) AS AccountID, 
			Isnull(AT1005.AccountName, AV7417.AccountName) AS AccountName,
			VoucherTypeID,
			VoucherNo,
			VoucherDate,
			InvoiceNo,
			InvoiceDate,
			Serial,
			VDescription,
			BDescription,
			TDescription, 
			AV7407.Ana01ID,
			AV7407.Ana02ID,
			AV7407.Ana03ID,
			AV7407.Ana04ID,
			AV7407.Ana05ID,
			AV7407.Ana06ID,
			AV7407.Ana07ID,
			AV7407.Ana08ID,
			AV7407.Ana09ID,
			AV7407.Ana10ID,
			AV7407.Ana01Name,AV7407.Ana02Name,AV7407.Ana03Name,AV7407.Ana04Name,AV7407.Ana05Name,AV7407.Ana06Name,AV7407.Ana07Name,AV7407.Ana08Name,AV7407.Ana09Name,AV7407.Ana10Name,
			isnull(AV7407.CurrencyIDCN, AV7417.CurrencyIDCN) AS CurrencyID,
			ExchangeRate,
			AV7407.CreateDate, -- = (Select distinct max(AV7407.Createdate) From AV7407 V07 where V07.VoucherID = AV7407.VoucherID),
			Sum(isnull(SignConvertedAmount, 0)) AS SignConvertedAmount,
			Sum(isnull(SignOriginalAmount, 0)) AS SignOriginalAmount,
			Sum(Case When RPTransactionType = ''00'' then isnull(OriginalAmount, 0) ELSE 0 End )as DebitOriginalAmount,
			Sum(Case When RPTransactionType = ''01'' then isnull(OriginalAmount, 0) ELSE 0 End) AS CreditOriginalAmount,
			Sum(Case When RPTransactionType = ''00'' then isnull(ConvertedAmount, 0) ELSE 0 End) AS DebitConvertedAmount,
			Sum(Case When RPTransactionType = ''01'' then isnull(ConvertedAmount, 0) ELSE 0 End) AS CreditConvertedAmount,
			isnull(OpeningOriginalAmount,0) AS OpeningOriginalAmount,
			isnull(OpeningConvertedAmount,0) AS OpeningConvertedAmount,
			cast(0 as decimal(28,8)) AS ClosingOriginalAmount,
			cast(0 as decimal(28,8)) AS ClosingConvertedAmount,Duedate,
			AV7407.Parameter01, AV7407.Parameter02, AV7407.Parameter03, AV7407.Parameter04, AV7407.Parameter05, AV7407.Parameter06, AV7407.Parameter07, AV7407.Parameter08, AV7407.Parameter09, AV7407.Parameter10 '
			
SET @sqlFrom  = ' 
	FROM		AV7407 
	LEFT JOIN 	AT1202 
		ON 		AT1202.ObjectID = AV7407.ObjectID 
				AND AT1202.DivisionID = AV7407.DivisionID
	FULL JOIN	AV7417 
		ON		AV7417.ObjectID = AV7407.ObjectID and AV7417.AccountID = AV7407.AccountID And AV7417.DivisionID = AV7407.DivisionID
	LEFT JOIN	AT1005 
		ON		AT1005.AccountID = AV7407.AccountID And AT1005.DivisionID = AV7407.DivisionID ' 
	SET @sqlWhere  = @SQLwhere
	SET @sqlGroupBy =' 
	GROUP BY 	BatchID, VoucherID, AV7407.TableID, AV7407.Status, AV7407.DivisionID, TranMonth, TranYear, 
				RPTransactionType, TransactionTypeID, AV7407.ObjectID, AV7417.ObjectID, 
				AT1202.Address, AT1202.VATNo, AT1202.S1, AT1202.S2, AT1202.S3, AT1202.Tel, AT1202.Fax, AT1202.Email,
				AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
				DebitAccountID, CreditAccountID, AV7407.AccountID, AV7417.AccountID, 
				VoucherTypeID, VoucherNo, VoucherDate, AV7417.OpeningOriginalAmount,AV7417.OpeningConvertedAmount,
				InvoiceNo, InvoiceDate, Serial, VDescription, BDescription,  TDescription,
				AV7407.Ana01ID,
				AV7407.Ana02ID,
				AV7407.Ana03ID,
				AV7407.Ana04ID,
				AV7407.Ana05ID,
				AV7407.Ana06ID,
				AV7407.Ana07ID,
				AV7407.Ana08ID,
				AV7407.Ana09ID,
				AV7407.Ana10ID,
				AV7407.Ana01Name,AV7407.Ana02Name,AV7407.Ana03Name,AV7407.Ana04Name,AV7407.Ana05Name,AV7407.Ana06Name,AV7407.Ana07Name,AV7407.Ana08Name,AV7407.Ana09Name,AV7407.Ana10Name,
				AV7407.CurrencyIDCN, AV7417.CurrencyIDCN, ExchangeRate, AV7407.CreateDate,
				AV7417.ObjectName, AT1202.ObjectName, AT1005.AccountName, AV7417.AccountName,Duedate,
				AV7407.Parameter01, AV7407.Parameter02, AV7407.Parameter03, AV7407.Parameter04, AV7407.Parameter05, AV7407.Parameter06, AV7407.Parameter07, AV7407.Parameter08, AV7407.Parameter09, AV7407.Parameter10 '
	-- Lấy số dư của đối tường mà không có phát sinh trong kỳ
		--Khong co ma phan tich
		SET @sqlSelect1 = ' 
		UNION 
		SELECT (ltrim(rtrim(isnull(AV7407.ObjectID, AV7417.ObjectID))) + ltrim(rtrim(isnull(AV7407.AccountID, AV7417.AccountID)))) AS GroupID,
			BatchID,
			VoucherID,
			TableID, Status,
			AV7417.DivisionID,
			TranMonth,
			TranYear, 
			Cast(Isnull(AV7407.AccountID, AV7417.AccountID) AS char(20)) + 
				cast(isnull(AV7407.ObjectID, AV7417.ObjectID)  AS char(20)) + 
				cast(isnull(AV7407.CurrencyIDCN, AV7417.CurrencyIDCN) AS char(20)) + 
				cast(Day(VoucherDate) + Month(VoucherDate)* 100 +
				Year(VoucherDate)*10000 AS char(8)) + 
				cast(VoucherID AS char(20)) + 
				(Case when RPTransactionType = ''00'' then ''0'' ELSE ''1'' end) AS Orders,
			RPTransactionType , TransactionTypeID,
			Isnull(AV7407.ObjectID, AV7417.ObjectID) AS ObjectID,
			isnull(AT1202.ObjectName,AV7417.ObjectName)  AS ObjectName,
			AT1202.Address, AT1202.VATNo,
			AT1202.S1, AT1202.S2, AT1202.S3, AT1202.Tel, AT1202.Fax, AT1202.Email,
			AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
			DebitAccountID, CreditAccountID, 
			Isnull(AV7407.AccountID, AV7417.AccountID) AS AccountID, 
			Isnull(AT1005.AccountName, AV7417.AccountName) AS AccountName,
			VoucherTypeID,
			VoucherNo,
			VoucherDate,
			InvoiceNo,
			InvoiceDate,
			Serial,
			VDescription,
			BDescription,
			TDescription,
			--convert(varchar,AV7417.Ana01ID),
			--convert(varchar,AV7417.Ana02ID),
			--convert(varchar,AV7417.Ana03ID),
			--convert(varchar,AV7417.Ana04ID),
			--convert(varchar,AV7417.Ana05ID),
			--convert(varchar,AV7417.Ana06ID),
			--convert(varchar,AV7417.Ana07ID),
			--convert(varchar,AV7417.Ana08ID),
			--convert(varchar,AV7417.Ana09ID),
			--convert(varchar,AV7417.Ana10ID),
			
			Cast (AV7417.Ana01ID as nvarchar(50)),
			Cast (AV7417.Ana02ID as nvarchar(50)),
			Cast (AV7417.Ana03ID as nvarchar(50)),
			Cast (AV7417.Ana04ID as nvarchar(50)),
			Cast (AV7417.Ana05ID as nvarchar(50)),
			Cast (AV7417.Ana06ID as nvarchar(50)),
			Cast (AV7417.Ana07ID as nvarchar(50)),
			Cast (AV7417.Ana08ID as nvarchar(50)),
			Cast (AV7417.Ana09ID as nvarchar(50)),
			Cast (AV7417.Ana10ID as nvarchar(50)),
			AV7407.Ana01Name,AV7407.Ana02Name,AV7407.Ana03Name,AV7407.Ana04Name,AV7407.Ana05Name,AV7407.Ana06Name,AV7407.Ana07Name,AV7407.Ana08Name,AV7407.Ana09Name,AV7407.Ana10Name,
			isnull(AV7407.CurrencyIDCN, AV7417.CurrencyIDCN) AS CurrencyID,
			ExchangeRate,
			AV7407.CreateDate, -- = (Select distinct max(AV7407.Createdate) From AV7407 V07 where V07.VoucherID = AV7407.VoucherID),
			Sum(isnull(SignConvertedAmount, 0)) AS SignConvertedAmount,
			Sum(isnull(SignOriginalAmount, 0)) AS SignOriginalAmount,
			Sum(Case When RPTransactionType = ''00'' then isnull(OriginalAmount, 0) ELSE 0 End )as DebitOriginalAmount,
			Sum(Case When RPTransactionType = ''01'' then isnull(OriginalAmount, 0) ELSE 0 End) AS CreditOriginalAmount,
			Sum(Case When RPTransactionType = ''00'' then isnull(ConvertedAmount, 0) ELSE 0 End) AS DebitConvertedAmount,
			Sum(Case When RPTransactionType = ''01'' then isnull(ConvertedAmount, 0) ELSE 0 End) AS CreditConvertedAmount,
			isnull(OpeningOriginalAmount,0) AS OpeningOriginalAmount,
			isnull(OpeningConvertedAmount,0) AS OpeningConvertedAmount,
			cast(0 as decimal(28,8)) AS ClosingOriginalAmount,
			cast(0 as decimal(28,8)) AS ClosingConvertedAmount,Duedate,
			AV7407.Parameter01, AV7407.Parameter02, AV7407.Parameter03, AV7407.Parameter04, AV7407.Parameter05, AV7407.Parameter06, AV7407.Parameter07, AV7407.Parameter08, AV7407.Parameter09, AV7407.Parameter10'
		SET @sqlFrom1  = ' 
		FROM AV7417 
		LEFT JOIN AV7407 on AV7417.ObjectID = AV7407.ObjectID and AV7417.AccountID = AV7407.AccountID And AV7417.DivisionID = AV7407.DivisionID
		LEFT JOIN AT1202 on AT1202.ObjectID = AV7417.ObjectID AND AT1202.DivisionID = AV7417.DivisionID
		LEFT JOIN AT1005 on AT1005.AccountID = AV7417.AccountID And AT1005.DivisionID = AV7417.DivisionID ' 
		SET @sqlGroupBy1 =' 
		GROUP BY	BatchID, VoucherID, TableID, Status, AV7417.DivisionID, TranMonth, TranYear, 
					RPTransactionType, TransactionTypeID, AV7407.ObjectID, AV7417.ObjectID, 
					AT1202.Address, AT1202.VATNo, AT1202.S1, AT1202.S2, AT1202.S3, AT1202.Tel, AT1202.Fax, AT1202.Email,
					AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
					DebitAccountID, CreditAccountID, AV7407.AccountID, AV7417.AccountID, 
					VoucherTypeID, VoucherNo, VoucherDate, AV7417.OpeningOriginalAmount,AV7417.OpeningConvertedAmount,
					InvoiceNo, InvoiceDate, Serial, VDescription, BDescription,  TDescription,
					AV7417.Ana01ID,
					AV7417.Ana02ID,
					AV7417.Ana03ID,
					AV7417.Ana04ID,
					AV7417.Ana05ID,
					AV7417.Ana06ID,
					AV7417.Ana07ID,
					AV7417.Ana08ID,
					AV7417.Ana09ID,
					AV7417.Ana10ID,
					AV7407.Ana01Name,AV7407.Ana02Name,AV7407.Ana03Name,AV7407.Ana04Name,AV7407.Ana05Name,AV7407.Ana06Name,AV7407.Ana07Name,AV7407.Ana08Name,AV7407.Ana09Name,AV7407.Ana10Name,
					AV7407.CurrencyIDCN, AV7417.CurrencyIDCN, ExchangeRate, AV7407.CreateDate,
					AV7417.ObjectName, AT1202.ObjectName, AT1005.AccountName, AV7417.AccountName,Duedate,
					AV7407.Parameter01, AV7407.Parameter02, AV7407.Parameter03, AV7407.Parameter04, AV7407.Parameter05, AV7407.Parameter06, AV7407.Parameter07, AV7407.Parameter08, AV7407.Parameter09, AV7407.Parameter10 '

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7418]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
     EXEC ('  CREATE VIEW AV7418 	--Created by AP7408
		AS ' +  @sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy +  
		@sqlSelect1 + @sqlFrom1 + @sqlWhere + @sqlGroupBy1)
ELSE
     EXEC ('  ALTER VIEW AV7418  	--Created by AP7408
		AS ' + @sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy + 
		@sqlSelect1 + @sqlFrom1 + @sqlWhere + @sqlGroupBy1)

		--In co ma phan tich
		SET @sqlSelect='
		SELECT (ltrim(rtrim(isnull(AV7407.ObjectID, AV7427.ObjectID))) + ltrim(rtrim(isnull(AV7407.AccountID, AV7427.AccountID)))) AS GroupID,
				BatchID,
				VoucherID,
				AV7407.TableID, AV7407.Status,
				AV7407.DivisionID,
				TranMonth,
				TranYear, 
				Cast(Isnull(AV7407.AccountID, AV7427.AccountID)  AS char(20)) + 
				cast(isnull(AV7407.ObjectID, AV7427.ObjectID)  AS char(20)) + 
				cast(isnull(AV7407.CurrencyIDCN, AV7427.CurrencyIDCN) AS char(20)) + 
				cast(Day(VoucherDate) + Month(VoucherDate)* 100 +
				Year(VoucherDate)*10000 AS char(8)) + 
				cast(VoucherID AS char(20)) + 
				(Case when RPTransactionType = ''00'' then ''0'' ELSE ''1'' end) AS Orders,
				RPTransactionType , TransactionTypeID,
				Isnull(AV7407.ObjectID, AV7427.ObjectID) AS ObjectID,
				isnull(AT1202.ObjectName,AV7427.ObjectName)  AS ObjectName,
				AT1202.Address,
				AT1202.VATNo,
				AT1202.S1, 
				AT1202.S2,
				AT1202.S3, 
				AT1202.Tel,
				AT1202.Fax, 
				AT1202.Email,
				AT1202.O01ID,
				AT1202.O02ID,
				AT1202.O03ID,
				AT1202.O04ID,
				AT1202.O05ID,
				DebitAccountID,
				CreditAccountID, 
				Isnull(AV7407.AccountID, AV7427.AccountID) AS AccountID, 
				Isnull(AT1005.AccountName, AV7427.AccountName) AS AccountName,
				VoucherTypeID,
				VoucherNo,
				VoucherDate,
				InvoiceNo,
				InvoiceDate,
				Serial,
				VDescription,
				BDescription,
				TDescription,
				Isnull(AV7407.Ana01ID,AV7427.Ana01ID) AS Ana01ID,
				AV7407.Ana02ID, AV7407.Ana03ID, AV7407.Ana04ID, AV7407.Ana05ID,
				AV7407.Ana06ID,AV7407.Ana07ID,AV7407.Ana08ID,AV7407.Ana09ID,AV7407.Ana10ID,
				isnull(AV7407.CurrencyIDCN, AV7427.CurrencyIDCN) AS CurrencyID,
				ExchangeRate,
				AV7407.CreateDate, -- = (Select distinct max(AV7407.Createdate) From AV7407 V07 where V07.VoucherID = AV7407.VoucherID),
				Sum(isnull(SignConvertedAmount, 0)) AS SignConvertedAmount,
				Sum(isnull(SignOriginalAmount, 0)) AS SignOriginalAmount,
				Sum(Case When RPTransactionType = ''00'' then isnull(OriginalAmount, 0) ELSE 0 End )as DebitOriginalAmount,
				Sum(Case When RPTransactionType = ''01'' then isnull(OriginalAmount, 0) ELSE 0 End) AS CreditOriginalAmount,
				Sum(Case When RPTransactionType = ''00'' then isnull(ConvertedAmount, 0) ELSE 0 End) AS DebitConvertedAmount,
				Sum(Case When RPTransactionType = ''01'' then isnull(ConvertedAmount, 0) ELSE 0 End) AS CreditConvertedAmount,
				isnull(OpeningOriginalAmount, 0) AS OpeningOriginalAmount,
				isnull(OpeningConvertedAmount, 0) AS OpeningConvertedAmount,
				isnull(AV7427.OpeningOriginalAmountAna01ID, 0)  AS OpeningOriginalAmountAna01ID,
				isnull(AV7427.OpeningConvertedAmountAna01ID, 0) AS OpeningConvertedAmountAna01ID,
				cast(0 as decimal(28,8)) AS ClosingOriginalAmount,
				cast(0 as decimal(28,8)) AS ClosingConvertedAmount '
		SET @sqlFrom = ' 
		FROM AV7407 
		LEFT JOIN AT1202 on	AT1202.ObjectID = AV7407.ObjectID AND AT1202.DivisionID = AV7407.DivisionID
		FULL JOIN AV7427 on AV7427.ObjectID = AV7407.ObjectID and AV7427.AccountID = AV7407.AccountID and AV7427.Ana01ID = AV7407.Ana01ID and AV7427.DivisionID = AV7407.DivisionID
		LEFT JOIN AT1005 on AT1005.AccountID = AV7407.AccountID And AT1005.DivisionID = AV7407.DivisionID  ' 
		SET @sqlWhere = @SQLwhereAna
		SET @sqlGroupBy = ' 
		GROUP BY BatchID, VoucherID, AV7407.TableID, AV7407.Status, AV7407.DivisionID, TranMonth, TranYear, 
				RPTransactionType, TransactionTypeID, AV7407.ObjectID, AV7427.ObjectID, 
				AT1202.Address, AT1202.VATNo, AT1202.S1, AT1202.S2, AT1202.S3, AT1202.Tel, AT1202.Fax, AT1202.Email,
				AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
				DebitAccountID, CreditAccountID, AV7407.AccountID, AV7427.AccountID, 
				VoucherTypeID, VoucherNo, VoucherDate, AV7427.OpeningOriginalAmount,AV7427.OpeningConvertedAmount, AV7427.OpeningOriginalAmountAna01ID, AV7427.OpeningConvertedAmountAna01ID,
				InvoiceNo, InvoiceDate, Serial, VDescription, BDescription,  TDescription,
				AV7427.Ana01ID, AV7407.Ana01ID, 
				AV7407.Ana02ID, AV7407.Ana03ID, AV7407.Ana04ID, AV7407.Ana05ID,
				AV7407.Ana06ID,AV7407.Ana07ID,AV7407.Ana08ID,AV7407.Ana09ID,AV7407.Ana10ID,
				AV7407.CurrencyIDCN, AV7427.CurrencyIDCN, ExchangeRate, AV7407.CreateDate,
				AV7427.ObjectName, AT1202.ObjectName, AT1005.AccountName, AV7427.AccountName '
	-- Lấy số dư của đối tường mà không có phát sinh trong kỳ
		--In co ma phan tich
		SET @sqlSelect1=' 
		UNION
		SELECT (ltrim(rtrim(isnull(AV7407.ObjectID, AV7427.ObjectID))) + ltrim(rtrim(isnull(AV7407.AccountID, AV7427.AccountID)))) AS GroupID,
				BatchID,
				VoucherID,
				TableID, Status,
				AV7427.DivisionID,
				TranMonth,
				TranYear, 
				Cast(Isnull(AV7407.AccountID, AV7427.AccountID)  AS char(20)) + 
				cast(isnull(AV7407.ObjectID, AV7427.ObjectID)  AS char(20)) + 
				cast(isnull(AV7407.CurrencyIDCN, AV7427.CurrencyIDCN) AS char(20)) + 
				cast(Day(VoucherDate) + Month(VoucherDate)* 100 +
				Year(VoucherDate)*10000 AS char(8)) + 
				cast(VoucherID AS char(20)) + 
				(Case when RPTransactionType = ''00'' then ''0'' ELSE ''1'' end) AS Orders,
				RPTransactionType , TransactionTypeID,
				Isnull(AV7407.ObjectID, AV7427.ObjectID) AS ObjectID,
				isnull(AT1202.ObjectName,AV7427.ObjectName)  AS ObjectName,
				AT1202.Address,
				AT1202.VATNo,
				AT1202.S1, 
				AT1202.S2,
				AT1202.S3, 
				AT1202.Tel,
				AT1202.Fax, 
				AT1202.Email,
				AT1202.O01ID,
				AT1202.O02ID,
				AT1202.O03ID,
				AT1202.O04ID,
				AT1202.O05ID,
				DebitAccountID,
				CreditAccountID, 
				Isnull(AV7407.AccountID, AV7427.AccountID) AS AccountID, 
				Isnull(AT1005.AccountName, AV7427.AccountName) AS AccountName,
				VoucherTypeID,
				VoucherNo,
				VoucherDate,
				InvoiceNo,
				InvoiceDate,
				Serial,
				VDescription,
				BDescription,
				TDescription,
				Isnull(AV7407.Ana01ID,AV7427.Ana01ID) AS Ana01ID,
				AV7407.Ana02ID, AV7407.Ana03ID, AV7407.Ana04ID, AV7407.Ana05ID,
				AV7407.Ana06ID,AV7407.Ana07ID,AV7407.Ana08ID,AV7407.Ana09ID,AV7407.Ana10ID,
				isnull(AV7407.CurrencyIDCN, AV7427.CurrencyIDCN) AS CurrencyID,
				ExchangeRate,
				AV7407.CreateDate, -- = (Select distinct max(AV7407.Createdate) From AV7407 V07 where V07.VoucherID = AV7407.VoucherID),
				Sum(isnull(SignConvertedAmount, 0)) AS SignConvertedAmount,
				Sum(isnull(SignOriginalAmount, 0)) AS SignOriginalAmount,
				Sum(Case When RPTransactionType = ''00'' then isnull(OriginalAmount, 0) ELSE 0 End )as DebitOriginalAmount,
				Sum(Case When RPTransactionType = ''01'' then isnull(OriginalAmount, 0) ELSE 0 End) AS CreditOriginalAmount,
				Sum(Case When RPTransactionType = ''00'' then isnull(ConvertedAmount, 0) ELSE 0 End) AS DebitConvertedAmount,
				Sum(Case When RPTransactionType = ''01'' then isnull(ConvertedAmount, 0) ELSE 0 End) AS CreditConvertedAmount,
				isnull(OpeningOriginalAmount, 0) AS OpeningOriginalAmount,
				isnull(OpeningConvertedAmount, 0) AS OpeningConvertedAmount,
				isnull(AV7427.OpeningOriginalAmountAna01ID, 0)  AS OpeningOriginalAmountAna01ID,
				isnull(AV7427.OpeningConvertedAmountAna01ID, 0) AS OpeningConvertedAmountAna01ID,
				cast(0 as decimal(28,8)) AS ClosingOriginalAmount,
				cast(0 as decimal(28,8)) AS ClosingConvertedAmount '
		SET @sqlFrom1 = ' 
		FROM AV7427 LEFT JOIN AV7407 on AV7427.ObjectID = AV7407.ObjectID and AV7427.AccountID = AV7407.AccountID And AV7427.DivisionID = AV7407.DivisionID
		LEFT JOIN AT1202 on AT1202.ObjectID = AV7427.ObjectID AND AT1202.DivisionID = AV7427.DivisionID
		LEFT JOIN AT1005 on AT1005.AccountID = AV7427.AccountID And AT1005.DivisionID = AV7427.DivisionID ' 
		SET @sqlGroupBy1 = ' 
		GROUP BY BatchID, VoucherID, TableID, Status, AV7427.DivisionID, TranMonth, TranYear, 
				RPTransactionType, TransactionTypeID, AV7407.ObjectID, AV7427.ObjectID, 
				AT1202.Address, AT1202.VATNo, AT1202.S1, AT1202.S2, AT1202.S3, AT1202.Tel, AT1202.Fax, AT1202.Email,
				AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
				DebitAccountID, CreditAccountID, AV7407.AccountID, AV7427.AccountID, 
				VoucherTypeID, VoucherNo, VoucherDate, AV7427.OpeningOriginalAmount,AV7427.OpeningConvertedAmount, AV7427.OpeningOriginalAmountAna01ID, AV7427.OpeningConvertedAmountAna01ID,
				InvoiceNo, InvoiceDate, Serial, VDescription, BDescription,  TDescription,
				AV7427.Ana01ID, AV7407.Ana01ID, 
				AV7407.Ana02ID, AV7407.Ana03ID, AV7407.Ana04ID, AV7407.Ana05ID,
				AV7407.Ana06ID,AV7407.Ana07ID,AV7407.Ana08ID,AV7407.Ana09ID,AV7407.Ana10ID,
				AV7407.CurrencyIDCN, AV7427.CurrencyIDCN, ExchangeRate, AV7407.CreateDate,
				AV7427.ObjectName, AT1202.ObjectName, AT1005.AccountName, AV7427.AccountName '

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7428]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
     EXEC ('  CREATE VIEW AV7428 	--Created by AP7408
		AS ' + @sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy
		+  @sqlSelect1 + @sqlFrom1 + @sqlWhere + @sqlGroupBy1)
ELSE
     EXEC ('  ALTER VIEW AV7428  	--Created by AP7408
		AS ' + @sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy
		+  @sqlSelect1 + @sqlFrom1 + @sqlWhere + @sqlGroupBy1)




--Khong co ma phan tich
IF @CustomerName = 16 --(Customized KH SIEU THANH)
	SET @sqlSelect = ' SELECT 1 as DB , '
ELSE
	SET @sqlSelect =' SELECT  '


SET @sqlSelect = @sqlSelect + '
	V18.GroupID,V18.BatchID,V18.VoucherID,V18.TableID, V18.Status,V18.DivisionID,V18.TranMonth,V18.TranYear,V18.RPTransactionType,V18.TransactionTypeID,
	V18.ObjectID,V18.ObjectName,V18.Address,VATNo,S1,S2,S3,Tel,Fax,Email,O01ID,O02ID,O03ID,O04ID,O05ID,V18.DebitAccountID,V18.CreditAccountID,
	V18.AccountID,AccountName, (SELECT TOP 1 AccountNameE FROM AT1005 WHERE DivisionID = V18.DivisionID AND AccountID = V18.AccountID) AccountNameE,
	V18.VoucherTypeID,V18.VoucherNo,V18.VoucherDate,V18.InvoiceNo,V18.InvoiceDate, V18.Serial,V18.VDescription,V18.BDescription,V18.TDescription,
	V18.Ana01ID,V18.Ana02ID,V18.Ana03ID,V18.Ana04ID,V18.Ana05ID,V18.Ana06ID,V18.Ana07ID,V18.Ana08ID,V18.Ana09ID,V18.Ana10ID,
	V18.Ana01Name,V18.Ana02Name,V18.Ana03Name,V18.Ana04Name,V18.Ana05Name,V18.Ana06Name,V18.Ana07Name,V18.Ana08Name,V18.Ana09Name,V18.Ana10Name,V18.CurrencyID,V18.ExchangeRate, 
	Sum(isnull(V18.DebitOriginalAmount, 0)) AS DebitOriginalAmount,Sum(isnull(V18.CreditOriginalAmount, 0)) AS CreditOriginalAmount,
	Sum(isnull(V18.DebitConvertedAmount, 0)) AS DebitConvertedAmount,Sum(isnull(V18.CreditConvertedAmount, 0)) AS CreditConvertedAmount,
	OpeningOriginalAmount,	V18.OpeningConvertedAmount,
	sum(isnull(V18.SignConvertedAmount, 0)) AS SignConvertedAmount,sum(isnull(V18.SignOriginalAmount, 0)) AS SignOriginalAmount,
	V18.ClosingOriginalAmount,V18.ClosingConvertedAmount,
	CAST (V18.TranMonth AS nvarchar)  + ''/'' + CAST (V18.TranYear AS nvarchar) AS MonthYear,
	convert (varchar(20), V18.Duedate,103) AS duedate,
	''' + convert(varchar(10), @FromDate, 103) + ''' AS Fromdate,
	(case when' + str(@TypeD) + '= 4 then ''30/' + Ltrim (str(@ToMonth)) 
	+ '/'+ltrim(str(@ToYear)) + ''' ELSE ''' + convert(varchar(10), @ToDate, 103) + ''' end) AS Todate,
	V18.Parameter01,V18.Parameter02,V18.Parameter03,V18.Parameter04,V18.Parameter05,V18.Parameter06,V18.Parameter07,V18.Parameter08,V18.Parameter09,V18.Parameter10 '
SET @sqlFrom = ' 
FROM AV7418 V18
'
SET @sqlWhere = ' 
WHERE	V18.DebitOriginalAmount <> 0 OR V18.CreditOriginalAmount <> 0 OR V18.DebitConvertedAmount <> 0 
		OR V18.CreditConvertedAmount <> 0 OR V18.OpeningOriginalAmount <> 0 OR V18.OpeningConvertedAmount <> 0  '
SET @sqlGroupBy = ' 
GROUP BY V18.GroupID, V18.BatchID,V18.VoucherID, V18.TableID, V18.Status, V18.DivisionID, V18.TranMonth, V18.TranYear, V18.RPTransactionType, V18.TransactionTypeID, 
		V18.ObjectID, V18.ObjectName,V18.Address, VATNo,S1,S2, S3, Tel, Fax, Email,O01ID, O02ID, O03ID, O04ID, O05ID,
		V18.DebitAccountID, V18.CreditAccountID, V18.AccountID, 
		V18.VoucherTypeID, V18.VoucherNo, V18.VoucherDate, V18.OpeningOriginalAmount, V18.OpeningConvertedAmount,
		V18.InvoiceNo, V18.InvoiceDate, V18.Serial, V18.VDescription, V18.BDescription, V18.TDescription, 
		V18.Ana01ID,V18.Ana02ID,V18.Ana03ID,V18.Ana04ID,V18.Ana05ID,V18.Ana06ID,V18.Ana07ID,V18.Ana08ID,V18.Ana09ID,V18.Ana10ID,
		CurrencyID, V18.ExchangeRate, ObjectName, AccountName, ClosingOriginalAmount, ClosingConvertedAmount,V18.Duedate,
		V18.Ana01Name,V18.Ana02Name,V18.Ana03Name,V18.Ana04Name,V18.Ana05Name,V18.Ana06Name,V18.Ana07Name,V18.Ana08Name,V18.Ana09Name,V18.Ana10Name,
		V18.Parameter01,V18.Parameter02,V18.Parameter03,V18.Parameter04,V18.Parameter05,V18.Parameter06,V18.Parameter07,V18.Parameter08,V18.Parameter09,V18.Parameter10 
'
		--IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7408]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
		--	 EXEC ('  CREATE VIEW AV7408 --Created by AP7408
		--	 AS '  + @sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy)
		--ELSE
		--	 EXEC ('  ALTER VIEW AV7408  --Created by AP7408
		--	 AS ' + @sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy)
	     
     
--Co ma phan tich
IF @CustomerName = 16 --(Customized KH SIEU THANH)
	SET @sqlSelect1 = ' SELECT 1 as DB, '
ELSE
	SET @sqlSelect1 =' SELECT  '
 

SET @sqlSelect1 = @sqlSelect1 + '
	GroupID,BatchID,VoucherID,TableID, Status,AV7428.DivisionID,TranMonth,TranYear,RPTransactionType,TransactionTypeID,
	AV7428.ObjectID,ObjectName,Address,VATNo,S1,S2,S3,Tel,Fax,Email,O01ID,O02ID,O03ID,O04ID,O05ID,DebitAccountID,	CreditAccountID,
	AV7428.AccountID, AccountName, (SELECT TOP 1 AccountNameE FROM AT1005 WHERE DivisionID = AV7428.DivisionID AND AccountID = AV7428.AccountID) AccountNameE,
	VoucherTypeID,VoucherNo,VoucherDate,InvoiceNo,InvoiceDate, Serial,VDescription,BDescription,TDescription,
	AV7428.Ana01ID,AV7428.Ana02ID,AV7428.Ana03ID,AV7428.Ana04ID,AV7428.Ana05ID,AV7428.Ana06ID,AV7428.Ana07ID,AV7428.Ana08ID,AV7428.Ana09ID,AV7428.Ana10ID,
	A11.AnaName AS Ana01Name,CurrencyID,ExchangeRate, 
	Sum(isnull(DebitOriginalAmount, 0)) AS DebitOriginalAmount,Sum(isnull(CreditOriginalAmount, 0)) AS CreditOriginalAmount,
	Sum(isnull(DebitConvertedAmount, 0)) AS DebitConvertedAmount,Sum(isnull(CreditConvertedAmount, 0)) AS CreditConvertedAmount,
	OpeningOriginalAmount,OpeningConvertedAmount,OpeningOriginalAmountAna01ID,OpeningConvertedAmountAna01ID,
	sum(isnull(SignConvertedAmount,0)) AS SignConvertedAmount,sum(isnull(SignOriginalAmount,0)) AS SignOriginalAmount,
	ClosingOriginalAmount,ClosingConvertedAmount,
	CAST(TranMonth AS nvarchar) + ''/'' + CAST(TranYear AS nvarchar) AS MonthYear '
SET @sqlFrom1 = ' 
FROM AV7428	
LEFT JOIN AT1011 A11 on A11.AnaID=AV7428.Ana01ID And A11.DivisionID=AV7428.DivisionID And A11.AnaTypeID = ''A01'' '

SET @sqlWhere1 = ' 
WHERE DebitOriginalAmount <> 0 OR CreditOriginalAmount <> 0 
	OR DebitConvertedAmount <> 0 OR CreditConvertedAmount <> 0 
	OR OpeningOriginalAmount <> 0 OR OpeningConvertedAmount <> 0 '
SET @sqlGroupBy1 = ' 
GROUP BY GroupID, BatchID,VoucherID, TableID, Status, AV7428.DivisionID, TranMonth, TranYear, RPTransactionType, TransactionTypeID, AV7428.ObjectID, 
	Address, VATNo,S1,S2, S3, Tel, Fax, Email,O01ID, O02ID, O03ID, O04ID, O05ID,DebitAccountID, CreditAccountID, AV7428.AccountID, 
	VoucherTypeID, VoucherNo, VoucherDate, OpeningOriginalAmount, 
	OpeningConvertedAmount, OpeningOriginalAmountAna01ID, OpeningConvertedAmountAna01ID,
	InvoiceNo, InvoiceDate, Serial, VDescription, BDescription, TDescription, 
	AV7428.Ana01ID,AV7428.Ana02ID,AV7428.Ana03ID,AV7428.Ana04ID,AV7428.Ana05ID,AV7428.Ana06ID,AV7428.Ana07ID,AV7428.Ana08ID,AV7428.Ana09ID,AV7428.Ana10ID,
	A11.AnaName, CurrencyID, ExchangeRate, ObjectName, ObjectName, AccountName, ClosingOriginalAmount, ClosingConvertedAmount
'
--IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7429]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
--     EXEC ('  CREATE VIEW AV7429 --Created by AP7408
--     AS ' + @sqlSelect1 + @sqlFrom1 + @sqlWhere1 + @sqlGroupBy1)
--ELSE
--     EXEC ('  ALTER VIEW AV7429  --Created by AP7408
--     AS ' + @sqlSelect1 + @sqlFrom1 + @sqlWhere1 + @sqlGroupBy1)
     
    IF @CustomerName = 16  AND @DatabaseName <>'' --- Customize Sieu Thanh in du lieu 2 database
		BEGIN
			EXEC AP7408_ST  @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear,@TypeD, @FromDate, @ToDate,@CurrencyID,@FromAccountID,@ToAccountID, @FromObjectID, @ToObjectID,@SqlFind,@DatabaseName 
			SET @sSQLUnion = '
			UNION ALL
				SELECT 2 as DB, GroupID,BatchID,VoucherID,TableID, Status,DivisionID,TranMonth,TranYear,RPTransactionType,TransactionTypeID,
				ObjectID,ObjectName,Address,VATNo,S1,S2,S3,Tel,Fax,Email,O01ID,O02ID,O03ID,O04ID,O05ID,DebitAccountID,CreditAccountID,
				AccountID,AccountName,VoucherTypeID,VoucherNo,VoucherDate,InvoiceNo,InvoiceDate, Serial,VDescription,BDescription,TDescription,
				Ana01ID,Ana02ID,Ana03ID,Ana04ID,Ana05ID,Ana06ID,Ana07ID,Ana08ID,Ana09ID,Ana10ID,CurrencyID,ExchangeRate, 
				DebitOriginalAmount, CreditOriginalAmount,
				DebitConvertedAmount, CreditConvertedAmount,
				OpeningOriginalAmount,	OpeningConvertedAmount,
				SignConvertedAmount,  SignOriginalAmount,
				ClosingOriginalAmount,ClosingConvertedAmount,
				MonthYear,duedate,Fromdate,Todate 
				FROM AV7408_ST '
				
				
			SET @sSQLUnion1 = '
			UNION ALL
				SELECT 2 as DB, GroupID,BatchID,VoucherID,TableID, Status,DivisionID,TranMonth,TranYear,RPTransactionType,TransactionTypeID,
				ObjectID,ObjectName,Address,VATNo,S1,S2,S3,Tel,Fax,Email,O01ID,O02ID,O03ID,O04ID,O05ID,DebitAccountID,CreditAccountID,
				AccountID,AccountName,VoucherTypeID,VoucherNo,VoucherDate,InvoiceNo,InvoiceDate, Serial,VDescription,BDescription,TDescription,
				Ana01ID,Ana02ID,Ana03ID,Ana04ID,Ana05ID,Ana06ID,Ana07ID,Ana08ID,Ana09ID,Ana10ID,Ana01Name,CurrencyID,ExchangeRate, 
				DebitOriginalAmount, CreditOriginalAmount,
				DebitConvertedAmount, CreditConvertedAmount,
				OpeningOriginalAmount,OpeningConvertedAmount,OpeningOriginalAmountAna01ID,OpeningConvertedAmountAna01ID,
				SignConvertedAmount, SignOriginalAmount,ClosingOriginalAmount,ClosingConvertedAmount,MonthYear 
				FROM AV7429_ST '
					
				---view temp AV7408a khong co ma phan tich
				IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7408a]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
					 EXEC ('  CREATE VIEW AV7408a --Created by AP7408
					 AS '  + @sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy +  @sSQLUnion )
				ELSE
					 EXEC ('  ALTER VIEW AV7408a  --Created by AP7408
					 AS ' + @sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy + @sSQLUnion)	
					 
				--view temp AV7429a Co ma phan tich			
				IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7429a]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
					EXEC ('  CREATE VIEW AV7429a --Created by AP7408
					AS ' + @sqlSelect1 + @sqlFrom1 + @sqlWhere1 + @sqlGroupBy1 + @sSQLUnion1)
				ELSE
					EXEC ('  ALTER VIEW AV7429a  --Created by AP7408
					AS ' + @sqlSelect1 + @sqlFrom1 + @sqlWhere1 + @sqlGroupBy1 + @sSQLUnion1)
						
						
				SET @sqlSelect = '
					SELECT  DB, AV7408a.GroupID,BatchID,VoucherID,TableID, Status,DivisionID,TranMonth,TranYear,RPTransactionType,TransactionTypeID,
					ObjectID,ObjectName,Address,VATNo,S1,S2,S3,Tel,Fax,Email,O01ID,O02ID,O03ID,O04ID,O05ID,DebitAccountID,CreditAccountID,
					AccountID,AccountName,VoucherTypeID,VoucherNo,VoucherDate,InvoiceNo,InvoiceDate, Serial,VDescription,BDescription,TDescription,
					Ana01ID,Ana02ID,Ana03ID,Ana04ID,Ana05ID,Ana06ID,Ana07ID,Ana08ID,Ana09ID,Ana10ID,CurrencyID,ExchangeRate, 
					DebitOriginalAmount, CreditOriginalAmount,
					DebitConvertedAmount, CreditConvertedAmount,
					--OpeningOriginalAmount,	OpeningConvertedAmount,
					SignConvertedAmount,  SignOriginalAmount,
					ClosingOriginalAmount,ClosingConvertedAmount,
					MonthYear,duedate,Fromdate,Todate ,
					(T08.OpeningOriginalAmount +  T09.OpeningOriginalAmount )  as  OpeningOriginalAmount,
					(T08.OpeningConvertedAmount +  T09.OpeningConvertedAmount )  as  OpeningConvertedAmount 
					FROM AV7408a
					Left Join (Select Distinct  GroupID, OpeningOriginalAmount,OpeningConvertedAmount  From AV7408a Where DB =1 ) T08 On AV7408a.GroupID = T08.GroupID  
					Left Join (Select Distinct  GroupID , OpeningOriginalAmount,OpeningConvertedAmount  From AV7408a Where DB =2 ) T09 On AV7408a.GroupID = T09.GroupID 
					'
				
				
				SET @sqlSelect1='
				SELECT  DB, AV7429a.GroupID,BatchID,VoucherID,TableID, Status,DivisionID,TranMonth,TranYear,RPTransactionType,TransactionTypeID,
				ObjectID,ObjectName,Address,VATNo,S1,S2,S3,Tel,Fax,Email,O01ID,O02ID,O03ID,O04ID,O05ID,DebitAccountID,CreditAccountID,
				AccountID,AccountName,VoucherTypeID,VoucherNo,VoucherDate,InvoiceNo,InvoiceDate, Serial,VDescription,BDescription,TDescription,
				Ana01ID,Ana02ID,Ana03ID,Ana04ID,Ana05ID,Ana06ID,Ana07ID,Ana08ID,Ana09ID,Ana10ID,Ana01Name,CurrencyID,ExchangeRate, 
				DebitOriginalAmount, CreditOriginalAmount,
				DebitConvertedAmount, CreditConvertedAmount,
				--OpeningOriginalAmount,OpeningConvertedAmount,
				OpeningOriginalAmountAna01ID,OpeningConvertedAmountAna01ID,
				SignConvertedAmount, SignOriginalAmount,ClosingOriginalAmount,ClosingConvertedAmount,MonthYear ,
				(T08.OpeningOriginalAmount +  T09.OpeningOriginalAmount )  as  OpeningOriginalAmount,
				(T08.OpeningConvertedAmount +  T09.OpeningConvertedAmount )  as  OpeningConvertedAmount 
				FROM AV7429a
				Left Join (Select Distinct  GroupID, OpeningOriginalAmount,OpeningConvertedAmount  From AV7429a Where DB =1 ) T08 On AV7429a.GroupID = T08.GroupID  
				left Join (Select Distinct  GroupID , OpeningOriginalAmount,OpeningConvertedAmount  From AV7429a Where DB =2 ) T09 On AV7429a.GroupID = T09.GroupID 
					'	
					
				--print 	@sqlSelect
				--print 	@sqlSelect1
				--Khong co ma phan tich		
				IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7408]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
					 EXEC ('  CREATE VIEW AV7408 --Created by AP7408
					 AS '  + @sqlSelect )
				ELSE
					 EXEC ('  ALTER VIEW AV7408  --Created by AP7408
					 AS ' + @sqlSelect )	
					 	
				
				--Co ma phan tich			
				IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7429]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
					EXEC ('  CREATE VIEW AV7429 --Created by AP7408
					AS ' + @sqlSelect1 )
				ELSE
					EXEC ('  ALTER VIEW AV7429  --Created by AP7408
					AS ' + @sqlSelect1 )	
		END
		
	ELSE 
	BEGIN
		PRINT @sqlSelect
		PRINT @sqlFrom
		PRINT @sqlWhere
		PRINT @sqlGroupBy
		PRINT @sSQLUnion
			--Khong co ma phan tich		
			IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7408]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
				 EXEC ('  CREATE VIEW AV7408 --Created by AP7408
				 AS '  + @sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy +  @sSQLUnion )
			ELSE
				 EXEC ('  ALTER VIEW AV7408  --Created by AP7408
				 AS ' + @sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy + @sSQLUnion)		
					 
			--Co ma phan tich			
			IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7429]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
				EXEC ('  CREATE VIEW AV7429 --Created by AP7408
				AS ' + @sqlSelect1 + @sqlFrom1 + @sqlWhere1 + @sqlGroupBy1 + @sSQLUnion1)
			ELSE
				EXEC ('  ALTER VIEW AV7429  --Created by AP7408
				AS ' + @sqlSelect1 + @sqlFrom1 + @sqlWhere1 + @sqlGroupBy1 + @sSQLUnion1)
		END	

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
