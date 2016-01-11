IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0358]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0358]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- <Summary>
---- Liet ke chi tiet phat sinh theo mat hang, chung tu
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- 	Created on 15/09/2004 by Nguyen Thi Ngoc Minh
----- 
---- Last Update : 25/01/2007  Thuy Tuyen --Lay ten ma phan tich
---- Edit by: Dang Le Bao Quynh; Date 08/11/2008
---- Purpose: Bo sung truong TDescription cho view AV0358
---- Purpose: Bo sung truong VDescription, BDescription  cho view AV0358
---- Modified on 28/09/2011 by Le Thi Thu Hien : Chinh sua CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101), 101)
---- Modified on 04/05/2012 by Le Thi Thu Hien : Chinh sua CreditAccount thành DebitAccount vì lấy Nợ trường hợp phải trả
---- Modified on 31/05/2012 by Le Thi Thu Hien : 0017081 
---- Modified on 07/06/2012 by Thiên Huỳnh; Chỉnh sửa lại các điều kiện Where
---- Modify on 18/03/2013 by bao Anh: Bo sung truong
---- Modified on 14/06/2013 by Thiên Huỳnh: Bổ sung Mã phân tích
---- Modified on 10/02/2014 by Mai Duyen: Sưa  dieu kien ket ma phan tích
-- <Example>
---- 
CREATE PROCEDURE [dbo].[AP0358] 
				@DivisionID AS nvarchar(50), 
				@FromObjectID  AS nvarchar(50),  
				@ToObjectID  AS nvarchar(50),  
				@FromRecAccountID  AS nvarchar(50),  
				@ToRecAccountID  AS nvarchar(50), 
				@FromPayAccountID  AS nvarchar(50),  
				@ToPayAccountID  AS nvarchar(50), 
				@CurrencyID  AS nvarchar(50),  
				@FromInventoryID AS nvarchar(50),
				@ToInventoryID AS nvarchar(50),
				@IsDate AS tinyint, 
				@FromMonth AS int, 
				@FromYear  AS int,  
				@ToMonth AS int,
				@ToYear AS int,
				@FromDate AS Datetime, 
				@ToDate AS Datetime,
				@IsPayable AS tinyint
AS
Declare @FromPeriod AS int,
		@ToPeriod AS int,
		@SQLwhere AS varchar(max),
		@sSQLSelect AS varchar(max),
		@sSQL AS varchar(max),
		@sSQLSelectUnion AS varchar(max),
		@sSQLUnion AS varchar(max),
		@sSQLGroupByUnion AS varchar(max),
		@sSQLunionall AS varchar(max),
		@sSQL1 AS varchar(max),		
		@sSQLSelect1 AS varchar(max),		
		@sSQLSelect1Union AS varchar(MAX),	
		@sSQL1union AS varchar(MAX)	

SET @sSQL = ''
SET @sSQLSelectUnion = ''
SET @sSQLUnion = ''
SET @sSQLGroupByUnion = ''
SET @sSQL1 = ''
Set @sSQLSelect1Union =''
SET @sSQL1union = ''
SET @sSQLSelect = ''
SET @sSQLSelect1 = ''
Set @FromPeriod = (@FromMonth + @FromYear*100)	
Set @ToPeriod = (@ToMonth + @ToYear*100)	

IF @IsDate =0   ----- Truong hop tinh Tu ky den ky 
	Set @SQLwhere ='  AND (AT9000.TranMonth+ AT9000.TranYear*100 Between '+str(@FromPeriod)+' AND '+str(@ToPeriod)+')   '
Else
	Set @SQLwhere ='  AND (CONVERT(DATETIME,CONVERT(VARCHAR(10),isnull(AT9000.VoucherDate, ''' + CONVERT(nvarchar(10),@FromDate,101) + '''),101), 101) Between ''' + 
						CONVERT(nvarchar(10),@FromDate,101) + ''' AND ''' + CONVERT(nvarchar(10),@ToDate,101) + ''')  '

------------Phai thu-----------------
If @IsPayable = 0  OR  @IsPayable = 2
  BEGIN
  
	Set @sSQLSelect= '
	
SELECT 	TransactionTypeID, AT9000.ObjectID, AT1202.ObjectName, AT1202.Address,  AT1202.Tel, At1202.Fax, At1202.Email, AT1202.VATNo, 
		AT1202.S1, AT1202.S2, AT1202.S3, AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
		(CASE WHEN TransactionTypeID in (''T99'') then Dateadd(hour,1,VoucherDate) else VoucherDate end ) AS VoucherDate, 
		VoucherNo, VoucherTypeID, 
		Ana01ID, T01.AnaName AS AnaName01,
		Ana02ID, T02.AnaName AS AnaName02,
		Ana03ID, T03.AnaName AS AnaName03,	
		Ana04ID, T04.AnaName AS AnaName04,
		Ana05ID, T05.AnaName AS AnaName05,
		Ana06ID, T06.AnaName AS AnaName06,
		Ana07ID, T07.AnaName AS AnaName07,
		Ana08ID, T08.AnaName AS AnaName08,
		Ana09ID, T09.AnaName AS AnaName09,
		Ana10ID, T10.AnaName AS AnaName10,
		AT9000.InvoiceDate, AT9000.InvoiceNo, AT9000.Serial,
		AT9000.DebitAccountID, AT9000.CreditAccountID,
		isnull(AT9000.InventoryID,'''') AS InventoryID,		
		Isnull( Isnull(AT9000.InventoryName1,InventoryName),isnull(AT9000.TDescription,'''')) AS InventoryName,
		AT9000.TDescription, 
		AT9000.VDescription, 
		AT9000.BDescription, 
		AT9000.UnitID, ''R'' AS R_P,
		isnull(OriginalAmount,0) AS DebitOriginalAmount, 
		isnull(ConvertedAmount,0) AS DebitConvertedAmount, 
		isnull(Quantity,0) AS DebitQuantity, 
		isnull(UnitPrice,0) AS DebitUnitPrice,
		isnull(DiscountRate,0) AS DebitDiscountRate,
		0 AS CreditOriginalAmount,
		0 AS CreditConvertedAmount,
		0 AS CreditQuantity,
		AT9000.DivisionID,
		AT9000.UParameter01 as Parameter01,
		AT9000.UParameter02 as Parameter02,
		AT9000.UParameter03 as Parameter03,
		AT9000.UParameter04 as Parameter04,
		AT9000.UParameter05 as Parameter05,
		ConvertedUnitID, AT1304.UnitName as ConvertedUnitName, isnull(ConvertedQuantity,0) AS DebitConvertedQuantity, 0 AS CreditConvertedQuantity,
		isnull(MarkQuantity,0) as MarkQuantity'
		
	Set @sSQL= '
FROM	AT9000 	
LEFT JOIN AT1302 on AT1302.InventoryID = AT9000.InventoryID  AND  AT1302.DivisionID = AT9000.DivisionID
LEFT JOIN AT1202 on AT1202.ObjectID = AT9000.ObjectID   AND  AT1202.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T01 on T01.AnaID = AT9000.Ana01ID   AND  T01.DivisionID = AT9000.DivisionID AND T01.AnaTypeID = ''A01''
LEFT JOIN AT1011 T02 on T02.AnaID = AT9000.Ana02ID   AND  T02.DivisionID = AT9000.DivisionID AND T02.AnaTypeID = ''A02''
LEFT JOIN AT1011 T03 on T03.AnaID = AT9000.Ana03ID   AND  T03.DivisionID = AT9000.DivisionID AND T03.AnaTypeID = ''A03''
LEFT JOIN AT1011 T04 on T04.AnaID = AT9000.Ana04ID   AND  T04.DivisionID = AT9000.DivisionID AND T04.AnaTypeID = ''A04''
LEFT JOIN AT1011 T05 on T05.AnaID = AT9000.Ana05ID   AND  T05.DivisionID = AT9000.DivisionID AND T05.AnaTypeID = ''A05''
LEFT JOIN AT1011 T06 on T06.AnaID = AT9000.Ana06ID   AND  T06.DivisionID = AT9000.DivisionID AND T06.AnaTypeID = ''A06''
LEFT JOIN AT1011 T07 on T07.AnaID = AT9000.Ana07ID   AND  T07.DivisionID = AT9000.DivisionID AND T07.AnaTypeID = ''A07''
LEFT JOIN AT1011 T08 on T08.AnaID = AT9000.Ana08ID   AND  T08.DivisionID = AT9000.DivisionID AND T08.AnaTypeID = ''A08''
LEFT JOIN AT1011 T09 on T09.AnaID = AT9000.Ana09ID   AND  T09.DivisionID = AT9000.DivisionID AND T09.AnaTypeID = ''A09''
LEFT JOIN AT1011 T10 on T10.AnaID = AT9000.Ana10ID   AND  T10.DivisionID = AT9000.DivisionID AND T10.AnaTypeID = ''A10''
LEFT JOIN AT1304 on AT1304.UnitID = AT9000.ConvertedUnitID  and AT1304.DivisionID = AT9000.DivisionID

Where 	TransactionTypeID <>''T00'' AND DebitAccountID between ''' +  @FromRecAccountID + ''' AND ''' + @ToRecAccountID + '''
		AND AT9000.DivisionID ='''+@DivisionID+'''
		AND (AT9000.ObjectID between  '''+@FromObjectID+''' AND '''+@ToObjectID+''' AND AT1202.Disabled=0)
		AND ISNULL(AT9000.InventoryID, ''' + @FromInventoryID + ''') between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + '''
		AND CurrencyIDCN like '''+@CurrencyID+''' '+ @SQLwhere



Set @sSQLSelectUnion = ' 
	UNION ALL
	SELECT 	TransactionTypeID, 
		(CASE WHEN TransactionTypeID in (''T99'',''T98'') then AT9000.CreditObjectID else AT9000.ObjectID end) AS ObjectID,
		(CASE WHEN TransactionTypeID in (''T99'',''T98'') then B.ObjectName else A.ObjectName end) AS ObjectName, 
		A.Address,  A.Tel, A.Fax, A.Email, A.VATNo, A.S1, A.S2, A.S3, A.O01ID, A.O02ID, A.O03ID, A.O04ID, A.O05ID,
		(CASE WHEN TransactionTypeID in (''T99'') then Dateadd(hour,1,VoucherDate) else VoucherDate end ) AS VoucherDate, 
		VoucherNo,VoucherTypeID,
		Ana01ID, T01.AnaName AS AnaName01,
		Ana02ID, T02.AnaName AS AnaName02,
		Ana03ID, T03.AnaName AS AnaName03,
		Ana04ID, T04.AnaName AS AnaName04,
		Ana05ID, T05.AnaName AS AnaName05,
		Ana06ID, T06.AnaName AS AnaName06,
		Ana07ID, T07.AnaName AS AnaName07,
		Ana08ID, T08.AnaName AS AnaName08,
		Ana09ID, T09.AnaName AS AnaName09,
		Ana10ID, T10.AnaName AS AnaName10,
		AT9000.InvoiceDate, AT9000.InvoiceNo, AT9000.Serial, AT9000.DebitAccountID, AT9000.CreditAccountID,
		'''' AS InventoryID,
		(CASE WHEN TransactionTypeID in (''T24'',''T34'') then Isnull(InventoryName,isnull(AT9000.TDescription,''''))
				else VDescription end) AS InventoryName,
		AT9000.TDescription,
		AT9000.VDescription,
		AT9000.BDescription,
		AT9000.UnitID, ''R'' AS R_P,
		0 AS DebitOriginalAmount, 
		0 AS DebitConvertedAmount, 
		0 AS DebitQuantity, 
		Sum(isnull(UnitPrice,0)) AS DebitUnitPrice,-- su dung chung cho ca Credit va Debit
		0 AS DebitDiscountRate,
		Sum(isnull(OriginalAmount,0)) AS CreditOriginalAmount,
		Sum(isnull(ConvertedAmount,0)) AS CreditConvertedAmount,
		Sum(isnull(Quantity,0)) AS CreditQuantity,
		AT9000.DivisionID,
		NULL as Parameter01, NUll as Parameter02, NULL as Parameter03, NULL as Parameter04, NULL as Parameter05,
		ConvertedUnitID, AT1304.UnitName as ConvertedUnitName, 0 as DebitConvertedQuantity, sum(isnull(ConvertedQuantity,0)) AS CreditConvertedQuantity,
		Sum(Isnull(MarkQuantity,0)) as MarkQuantity '
		
 Set @sSQLUnion = ' 		
From	AT9000 	
LEFT JOIN AT1302 on AT1302.InventoryID = AT9000.InventoryID AND AT1302.DivisionID = AT9000.DivisionID 
LEFT JOIN AT1202 A on A.ObjectID = AT9000.ObjectID  AND A.DivisionID = AT9000.DivisionID
LEFT JOIN AT1202 B on B.ObjectID = AT9000.CreditObjectID AND B.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T01 on T01.AnaID = AT9000.Ana01ID   AND  T01.DivisionID = AT9000.DivisionID AND T01.AnaTypeID = ''A01''
LEFT JOIN AT1011 T02 on T02.AnaID = AT9000.Ana02ID   AND  T02.DivisionID = AT9000.DivisionID AND T02.AnaTypeID = ''A02''
LEFT JOIN AT1011 T03 on T03.AnaID = AT9000.Ana03ID   AND  T03.DivisionID = AT9000.DivisionID AND T03.AnaTypeID = ''A03''
LEFT JOIN AT1011 T04 on T04.AnaID = AT9000.Ana04ID   AND  T04.DivisionID = AT9000.DivisionID AND T04.AnaTypeID = ''A04''
LEFT JOIN AT1011 T05 on T05.AnaID = AT9000.Ana05ID   AND  T05.DivisionID = AT9000.DivisionID AND T05.AnaTypeID = ''A05''
LEFT JOIN AT1011 T06 on T06.AnaID = AT9000.Ana06ID   AND  T06.DivisionID = AT9000.DivisionID AND T06.AnaTypeID = ''A06''
LEFT JOIN AT1011 T07 on T07.AnaID = AT9000.Ana07ID   AND  T07.DivisionID = AT9000.DivisionID AND T07.AnaTypeID = ''A07''
LEFT JOIN AT1011 T08 on T08.AnaID = AT9000.Ana08ID   AND  T08.DivisionID = AT9000.DivisionID AND T08.AnaTypeID = ''A08''
LEFT JOIN AT1011 T09 on T09.AnaID = AT9000.Ana09ID   AND  T09.DivisionID = AT9000.DivisionID AND T09.AnaTypeID = ''A09''
LEFT JOIN AT1011 T10 on T10.AnaID = AT9000.Ana10ID   AND  T10.DivisionID = AT9000.DivisionID AND T10.AnaTypeID = ''A10''
LEFT JOIN AT1304 on AT1304.UnitID = AT9000.ConvertedUnitID  and AT1304.DivisionID = AT9000.DivisionID

Where 	TransactionTypeID <>''T00'' 
		AND CreditAccountID between ''' +  @FromRecAccountID + ''' AND ''' + @ToRecAccountID + '''
		AND AT9000.DivisionID ='''+@DivisionID+'''
		AND ((TransactionTypeID <>''T00'' AND TransactionTypeID not in (''T99'',''T98'') 
			AND AT9000.ObjectID between ''' +  @FromObjectID + ''' AND ''' + @ToObjectID + '''
			AND A.Disabled = 0)
			OR
			(TransactionTypeID in (''T99'',''T98'') 
			AND (CreditObjectID between ''' +  @FromObjectID + ''' AND ''' + @ToObjectID + '''
			AND B.Disabled = 0)))
		AND ISNULL(AT9000.InventoryID, ''' + @FromInventoryID + ''') between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + '''
		AND CurrencyIDCN like '''+@CurrencyID+''' '+@SQLwhere 
		
		
SET @sSQLGroupByUnion ='		
GROUP BY TransactionTypeID, AT9000.ObjectID, AT9000.CreditObjectID, A.ObjectName, B.ObjectName, A.Address, A.Tel, A.Fax, A.Email, A.VATNo,
		A.S1, A.S2, A.S3, A.O01ID, A.O02ID, A.O03ID, A.O04ID, A.O05ID,
		VoucherDate, VoucherNo,VoucherTypeID,
		Ana01ID, T01.AnaName, Ana02ID, T02.AnaName, Ana03ID, T03.AnaName, Ana04ID, T04.AnaName, Ana05ID, T05.AnaName,
		Ana06ID, T06.AnaName, Ana07ID, T07.AnaName, Ana08ID, T08.AnaName, Ana09ID, T09.AnaName, Ana10ID, T10.AnaName,
		AT9000.InvoiceDate, AT9000.InvoiceNo, AT9000.Serial, AT9000.DebitAccountID, AT9000.CreditAccountID,
		AT9000.InventoryID, AT9000.UnitPrice, AT9000.Quantity,
		InventoryName, 
		TDescription, 
		AT9000.VDescription,
		AT9000.BDescription,
		AT9000.UnitID, AT9000.DivisionID, ConvertedUnitID, AT1304.UnitName
'
		
  End

If @IsPayable = 2 SET @sSQLunionall= ' Union All '

------------------Phai tra----------------
If @IsPayable = 1  OR  @IsPayable = 2
  BEGIN
  
	Set @sSQLSelect1 = '
	

SELECT 	TransactionTypeID, AT9000.ObjectID, A.ObjectName,
		--(CASE WHEN TransactionTypeID in (''T99'') then AT9000.CreditObjectID else AT9000.ObjectID end) AS ObjectID,
		--(CASE WHEN TransactionTypeID in (''T99'') then B.ObjectName else A.ObjectName end) AS ObjectName, 
		A.Address, A.Tel, A.Fax, A.Email, A.VATNo, A.S1, A.S2, A.S3, A.O01ID, A.O02ID, A.O03ID, A.O04ID, A.O05ID,
		(CASE WHEN TransactionTypeID in (''T99'') then 
			Dateadd(hour,1,VoucherDate) else VoucherDate end ) AS VoucherDate, 
		VoucherNo, VoucherTypeID, 
		Ana01ID, T01.AnaName AS AnaName01,
		Ana02ID, T02.AnaName AS AnaName02,
		Ana03ID, T03.AnaName AS AnaName03,
		Ana04ID, T04.AnaName AS AnaName04,
		Ana05ID, T05.AnaName AS AnaName05,
		Ana06ID, T06.AnaName AS AnaName06,
		Ana07ID, T07.AnaName AS AnaName07,
		Ana08ID, T08.AnaName AS AnaName08,
		Ana09ID, T09.AnaName AS AnaName09,
		Ana10ID, T10.AnaName AS AnaName10,
		AT9000.InvoiceDate, AT9000.InvoiceNo, AT9000.Serial, AT9000.DebitAccountID, AT9000.CreditAccountID,
		isnull(AT9000.InventoryID,'''') AS InventoryID,
		Isnull(InventoryName,isnull(AT9000.TDescription,'''')) AS InventoryName,
		AT9000.TDescription,
		AT9000.VDescription,
		AT9000.BDescription,
		AT9000.UnitID, ''P'' AS R_P,
		isnull(OriginalAmount,0) AS DebitOriginalAmount,
		isnull(ConvertedAmount,0) AS DebitConvertedAmount,
		isnull(Quantity,0) AS DebitQuantity	,
		isnull(UnitPrice,0) AS DebitUnitPrice,
		isnull(DiscountRate,0) AS DebitDiscountRate,
		0 AS CreditOriginalAmount, 
		0 AS CreditConvertedAmount, 
		0 AS CreditQuantity,
		AT9000.DivisionID,
		AT9000.UParameter01 as Parameter01,
		AT9000.UParameter02 as Parameter02,
		AT9000.UParameter03 as Parameter03,
		AT9000.UParameter04 as Parameter04,
		AT9000.UParameter05 as Parameter05,
		ConvertedUnitID, AT1304.UnitName as ConvertedUnitName, isnull(ConvertedQuantity,0) AS DebitConvertedQuantity, 0 AS CreditConvertedQuantity,
		isnull(MarkQuantity,0) as MarkQuantity '
		
Set @sSQL1=  ' 
FROM AT9000 	
LEFT JOIN AT1302 on AT1302.InventoryID = AT9000.InventoryID AND AT1302.DivisionID = AT9000.DivisionID 
LEFT JOIN AT1202 A on A.ObjectID = AT9000.ObjectID  AND A.DivisionID = AT9000.DivisionID
LEFT JOIN AT1202 B on B.ObjectID = AT9000.CreditObjectID AND B.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T01 on T01.AnaID = AT9000.Ana01ID   AND  T01.DivisionID = AT9000.DivisionID AND T01.AnaTypeID = ''A01''
LEFT JOIN AT1011 T02 on T02.AnaID = AT9000.Ana02ID   AND  T02.DivisionID = AT9000.DivisionID AND T02.AnaTypeID = ''A02''
LEFT JOIN AT1011 T03 on T03.AnaID = AT9000.Ana03ID   AND  T03.DivisionID = AT9000.DivisionID AND T03.AnaTypeID = ''A03''
LEFT JOIN AT1011 T04 on T04.AnaID = AT9000.Ana04ID   AND  T04.DivisionID = AT9000.DivisionID AND T04.AnaTypeID = ''A04''
LEFT JOIN AT1011 T05 on T05.AnaID = AT9000.Ana05ID   AND  T05.DivisionID = AT9000.DivisionID AND T05.AnaTypeID = ''A05''
LEFT JOIN AT1011 T06 on T06.AnaID = AT9000.Ana06ID   AND  T06.DivisionID = AT9000.DivisionID AND T06.AnaTypeID = ''A06''
LEFT JOIN AT1011 T07 on T07.AnaID = AT9000.Ana07ID   AND  T07.DivisionID = AT9000.DivisionID AND T07.AnaTypeID = ''A07''
LEFT JOIN AT1011 T08 on T08.AnaID = AT9000.Ana08ID   AND  T08.DivisionID = AT9000.DivisionID AND T08.AnaTypeID = ''A08''
LEFT JOIN AT1011 T09 on T09.AnaID = AT9000.Ana09ID   AND  T09.DivisionID = AT9000.DivisionID AND T09.AnaTypeID = ''A09''
LEFT JOIN AT1011 T10 on T10.AnaID = AT9000.Ana10ID   AND  T10.DivisionID = AT9000.DivisionID AND T10.AnaTypeID = ''A10''
LEFT JOIN AT1304 on AT1304.UnitID = AT9000.ConvertedUnitID  and AT1304.DivisionID = AT9000.DivisionID

Where 	TransactionTypeID <>''T00'' AND DebitAccountID between ''' +  @FromPayAccountID + ''' AND ''' + @ToPayAccountID + '''
		AND AT9000.DivisionID ='''+@DivisionID+'''
		AND (AT9000.ObjectID between  '''+@FromObjectID+''' AND '''+@ToObjectID+''' AND A.Disabled=0)
		AND ISNULL(AT9000.InventoryID, ''' + @FromInventoryID + ''') between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + '''
		AND CurrencyIDCN like '''+@CurrencyID+''' '+ @SQLwhere

--------------->>>>>>>>>>>>Trường hợp phải trả bên có
	
	Set @sSQLSelect1Union = '
	
	UNION ALL
	SELECT 	TransactionTypeID,
		(CASE WHEN TransactionTypeID in (''T99'', ''T98'') then AT9000.CreditObjectID else AT9000.ObjectID end) AS ObjectID,
		(CASE WHEN TransactionTypeID in (''T99'', ''T98'') then B.ObjectName else A.ObjectName end) AS ObjectName, 
		A.Address, A.Tel, A.Fax, A.Email, A.VATNo, A.S1, A.S2, A.S3, A.O01ID, A.O02ID, A.O03ID, A.O04ID, A.O05ID,
		(CASE WHEN TransactionTypeID in (''T99'') then 
			Dateadd(hour,1,VoucherDate) else VoucherDate end ) AS VoucherDate, 
		VoucherNo, VoucherTypeID, 
		Ana01ID, T01.AnaName AS AnaName01,
		Ana02ID, T02.AnaName AS AnaName02,
		Ana03ID, T03.AnaName AS AnaName03,
		Ana04ID, T04.AnaName AS AnaName04,
		Ana05ID, T05.AnaName AS AnaName05,
		Ana06ID, T06.AnaName AS AnaName06,
		Ana07ID, T07.AnaName AS AnaName07,
		Ana08ID, T08.AnaName AS AnaName08,
		Ana09ID, T09.AnaName AS AnaName09,
		Ana10ID, T10.AnaName AS AnaName10,
		AT9000.InvoiceDate, AT9000.InvoiceNo, AT9000.Serial, AT9000.DebitAccountID, AT9000.CreditAccountID,
		isnull(AT9000.InventoryID,'''') AS InventoryID,
		Isnull(InventoryName,isnull(AT9000.TDescription,'''')) AS InventoryName,
		AT9000.TDescription,
		AT9000.VDescription,
		AT9000.BDescription,
		AT9000.UnitID, ''P'' AS R_P,
		0 AS DebitOriginalAmount,
		0 AS DebitConvertedAmount,
		0 AS DebitQuantity	,
		isnull(UnitPrice,0) AS DebitUnitPrice,-- su dung chung cho ca Credit va Debit
		0 AS DebitDiscountRate,
		isnull(OriginalAmount,0) AS CreditOriginalAmount, 
		isnull(ConvertedAmount,0) AS CreditConvertedAmount, 
		isnull(Quantity,0) AS CreditQuantity,
		AT9000.DivisionID,
		AT9000.UParameter01 as Parameter01,
		AT9000.UParameter02 as Parameter02,
		AT9000.UParameter03 as Parameter03,
		AT9000.UParameter04 as Parameter04,
		AT9000.UParameter05 as Parameter05,
		ConvertedUnitID, AT1304.UnitName as ConvertedUnitName, 0 as DebitConvertedQuantity, isnull(ConvertedQuantity,0) AS CreditConvertedQuantity,
		isnull(MarkQuantity,0) as MarkQuantity '
		
Set @sSQL1union = ' 		
FROM AT9000 	
LEFT JOIN AT1302 on AT1302.InventoryID = AT9000.InventoryID AND AT1302.DivisionID = AT9000.DivisionID 
LEFT JOIN AT1202 A on A.ObjectID = AT9000.ObjectID  AND A.DivisionID = AT9000.DivisionID
LEFT JOIN AT1202 B on B.ObjectID = AT9000.CreditObjectID AND B.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T01 on T01.AnaID = AT9000.Ana01ID   AND  T01.DivisionID = AT9000.DivisionID AND T01.AnaTypeID = ''A01''
LEFT JOIN AT1011 T02 on T02.AnaID = AT9000.Ana02ID   AND  T02.DivisionID = AT9000.DivisionID AND T02.AnaTypeID = ''A02''
LEFT JOIN AT1011 T03 on T03.AnaID = AT9000.Ana03ID   AND  T03.DivisionID = AT9000.DivisionID AND T03.AnaTypeID = ''A03''
LEFT JOIN AT1011 T04 on T04.AnaID = AT9000.Ana04ID   AND  T04.DivisionID = AT9000.DivisionID AND T04.AnaTypeID = ''A04''
LEFT JOIN AT1011 T05 on T05.AnaID = AT9000.Ana05ID   AND  T05.DivisionID = AT9000.DivisionID AND T05.AnaTypeID = ''A05''
LEFT JOIN AT1011 T06 on T06.AnaID = AT9000.Ana06ID   AND  T06.DivisionID = AT9000.DivisionID AND T06.AnaTypeID = ''A06''
LEFT JOIN AT1011 T07 on T07.AnaID = AT9000.Ana07ID   AND  T07.DivisionID = AT9000.DivisionID AND T07.AnaTypeID = ''A07''
LEFT JOIN AT1011 T08 on T08.AnaID = AT9000.Ana08ID   AND  T08.DivisionID = AT9000.DivisionID AND T08.AnaTypeID = ''A08''
LEFT JOIN AT1011 T09 on T09.AnaID = AT9000.Ana09ID   AND  T09.DivisionID = AT9000.DivisionID AND T09.AnaTypeID = ''A09''
LEFT JOIN AT1011 T10 on T10.AnaID = AT9000.Ana10ID   AND  T10.DivisionID = AT9000.DivisionID AND T10.AnaTypeID = ''A10''
LEFT JOIN AT1304 on AT1304.UnitID = AT9000.ConvertedUnitID  and AT1304.DivisionID = AT9000.DivisionID

WHERE 	TransactionTypeID <>''T00'' 
		AND CreditAccountID between ''' +  @FromPayAccountID + ''' AND ''' + @ToPayAccountID + '''
		AND AT9000.DivisionID ='''+@DivisionID+'''
		AND ((TransactionTypeID <>''T99'' AND TransactionTypeID not in (''T99'',''T98'') 
			AND AT9000.ObjectID between ''' +  @FromObjectID + ''' AND ''' + @ToObjectID + '''
			AND A.Disabled = 0)
			OR 
			(TransactionTypeID in (''T99'',''T98'') 
			AND (AT9000.CreditObjectID between ''' +  @FromObjectID + ''' AND ''' + @ToObjectID + '''
			AND B.Disabled = 0)))		
		AND ISNULL(AT9000.InventoryID, ''' + @FromInventoryID + ''') between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + '''
		AND CurrencyIDCN like '''+@CurrencyID+''' '+ @SQLwhere

  End

--print @sSQL 
--print @sSQLSelectUnion 
--print @sSQLunion 
--print @sSQLGroupByUnion 
--print @sSQLunionall 
--print @sSQL1 
--print @sSQLSelect1Union
--print @sSQL1union 
--Print @SQLwhere
 

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0358]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
	EXEC ('  CREATE VIEW AV0358 	--CREATED BY AP0358
		AS ' +  @sSQLSelect +  @sSQL +  @sSQLSelectUnion + @sSQLunion + @sSQLGroupByUnion + @sSQLunionall + @sSQLSelect1 + @sSQL1 + @sSQLSelect1Union + @sSQL1union)
ELSE
	EXEC ('  ALTER VIEW AV0358  	--CREATED BY AP0358
		AS ' + @sSQLSelect + @sSQL + @sSQLSelectUnion + @sSQLunion + @sSQLGroupByUnion + @sSQLunionall +  @sSQLSelect1 +  @sSQL1 + @sSQLSelect1Union + @sSQL1union)





GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

