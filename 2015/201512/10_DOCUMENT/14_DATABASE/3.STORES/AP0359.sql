IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0359]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0359]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- <Summary>
---- Liet ke tong hop phat sinh theo mat hang, phieu thu
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 12/02/2004 by Nguyen Van Nhan
---- 
---- LastEdit ThuyTuyen Lay them truong Ma Phan tich 23/04/2008
---- Modified on 20/10/2010 by Hoàng Phước : sửa lỗi bị vượt qúa độ dài 4000
---- Modified on 17/01/2012 by Le Thi Thu Hien : Sua dieu kien loc theo ngay
---- Modified on 04/05/2012 by Le Thi Thu Hien : Chinh sua CreditAccount thành DebitAccount vì lấy Nợ trường hợp phải trả
---- Modified on 31/05/2012 by Le Thi Thu Hien : 0017081 
---- Modified on 08/06/2012 by Thiên Huỳnh; Chỉnh sửa lại các điều kiện Where
---- Modified on 14/06/2013 by Thiên Huỳnh: Bổ sung Mã phân tích
-- <Example>
----

CREATE PROCEDURE [dbo].[AP0359] 
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

--Print ' AP0319'

DECLARE @FromPeriod AS int,
		@ToPeriod AS int,
		@sSQL AS nvarchar(max),
		@sSQLunion AS nvarchar(max),
		@sSQLunionall AS nvarchar(max),
		@sSQL1 AS nvarchar(max),		
		@sSQL1union AS nvarchar(MAX),	
		@SQLwhere AS nvarchar(max)
	
SET @sSQL = ''
SET @sSQLunion = ''
SET @sSQL1 = ''
SET @sSQL1union = ''
Set @FromPeriod = (@FromMonth + @FromYear*100)	
Set @ToPeriod = (@ToMonth + @ToYear*100)	

IF @IsDate =0   ----- Truong hop tinh Tu ky den ky 
	Set @SQLwhere ='  And   (AT9000.TranMonth+ AT9000.TranYear*100 Between '+str(@FromPeriod)+' and '+str(@ToPeriod)+')   '

Else
	Set @SQLwhere ='  And (CONVERT(DATETIME,CONVERT(VARCHAR(10),isnull(AT9000.VoucherDate, ''' + convert(nvarchar(10),@FromDate,101) + '''),101),101) Between ''' + 
				convert(nvarchar(10),@FromDate,101) + ''' and ''' + convert(nvarchar(10),@ToDate,101) + ''')  '

--------Phai thu----------
If @IsPayable = 0 or @IsPayable = 2
  Begin
	Set @sSQL = '
SELECT 	NULL AS TransactionTypeID, AT9000.ObjectID, AT1202.ObjectName, AT1202.Address,
		NULL AS VoucherDate, 
		NULL AS VoucherNo, 
		NULL AS VoucherTypeID,
		isnull(AT9000.InventoryID,'''') AS InventoryID,
		Isnull(InventoryName,isnull(AT9000.TDescription,'''')) AS InventoryName,
		AT9000.UnitID, ''R'' AS R_P,
		sum(isnull(OriginalAmount,0)) AS DebitOriginalAmount, 
		sum(isnull(ConvertedAmount,0)) AS DebitConvertedAmount, 
		sum(isnull(Quantity,0)) AS DebitQuantity, 
		isnull(AT9000.UnitPrice,0) AS DebitUnitPrice,
		isnull(DiscountRate,0) AS DebitDiscountRate,
		0 AS CreditOriginalAmount,
		0 AS CreditConvertedAmount,
		0 AS CreditQuantity,
		AT9000.Ana01ID, T01.AnaName AS AnaName01,
		AT9000.Ana02ID, T02.AnaName AS AnaName02,
		AT9000.Ana03ID, T03.AnaName AS AnaName03,	
		AT9000.Ana04ID, T04.AnaName AS AnaName04,
		AT9000.Ana05ID, T05.AnaName AS AnaName05,
		AT9000.Ana06ID, T06.AnaName AS AnaName06,
		AT9000.Ana07ID, T07.AnaName AS AnaName07,
		AT9000.Ana08ID, T08.AnaName AS AnaName08,
		AT9000.Ana09ID, T09.AnaName AS AnaName09,
		AT9000.Ana10ID, T10.AnaName AS AnaName10,
		AT9000.InvoiceNo,
		AT9000.DivisionID
From AT9000 	
LEFT JOIN AT1302 on AT1302.InventoryID = AT9000.InventoryID and  AT1302.DivisionID = AT9000.DivisionID
LEFT JOIN AT1202 on AT1202.ObjectID = AT9000.ObjectID and  AT1202.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T01 on T01.AnaID = AT9000.Ana01ID and  T01.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T02 on T02.AnaID = AT9000.Ana02ID and  T02.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T03 on T03.AnaID = AT9000.Ana03ID and  T03.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T04 on T04.AnaID = AT9000.Ana04ID   AND  T04.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T05 on T05.AnaID = AT9000.Ana05ID   AND  T05.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T06 on T06.AnaID = AT9000.Ana06ID   AND  T06.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T07 on T07.AnaID = AT9000.Ana07ID   AND  T07.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T08 on T08.AnaID = AT9000.Ana08ID   AND  T08.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T09 on T09.AnaID = AT9000.Ana09ID   AND  T09.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T10 on T10.AnaID = AT9000.Ana10ID   AND  T10.DivisionID = AT9000.DivisionID
		
Where 	TransactionTypeID <>''T00'' AND DebitAccountID between ''' +  @FromRecAccountID + ''' AND ''' + @ToRecAccountID + '''
		AND AT9000.DivisionID ='''+@DivisionID+'''
		AND (AT9000.ObjectID between  '''+@FromObjectID+''' AND '''+@ToObjectID+''' AND AT1202.Disabled=0)
		AND IsNull(AT9000.InventoryID, ''' + @FromInventoryID + ''') Between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + '''
		AND CurrencyIDCN like '''+@CurrencyID+''' '+ @SQLwhere + '

GROUP BY TransactionTypeID, AT9000.ObjectID, AT1202.ObjectName, AT1202.Address, isnull(AT9000.InventoryID,''''), isnull(AT9000.UnitPrice,0),
		Isnull(InventoryName,isnull(AT9000.TDescription,'''')) , AT9000.UnitID, 
		Ana01ID, T01.AnaName, Ana02ID, T02.AnaName, Ana03ID, T03.AnaName, Ana04ID, T04.AnaName, Ana05ID, T05.AnaName,
		Ana06ID, T06.AnaName, Ana07ID, T07.AnaName, Ana08ID, T08.AnaName, Ana09ID, T09.AnaName, Ana10ID, T10.AnaName,
		AT9000.InvoiceNo, isnull(DiscountRate,0), AT9000.DivisionID
'
	Set @sSQLunion= ' 
UNION ALL
SELECT 	''11'' AS TransactionTypeID,
		(Case when TransactionTypeID in (''T99'') then AT9000.CreditObjectID else AT9000.ObjectID end) AS ObjectID,
		(Case when TransactionTypeID in (''T99'') then B.ObjectName else A.ObjectName end) AS ObjectName,
		A.Address,
		(Case when TransactionTypeID in (''T99'') then Dateadd(hour,1,VoucherDate) else VoucherDate end ) AS VoucherDate, 
		VoucherNo, VoucherTypeID, '''' AS InventoryID,
		(Case when TransactionTypeID in (''T24'',''T34'') then Isnull(InventoryName,isnull(AT9000.TDescription,''''))
			else VDescription end) AS InventoryName,
		NULL AS UnitID,  ''R'' AS R_P,
		0 AS DebitOriginalAmount,
		0 AS DebitConvertedAmount,
		0 AS DebitQuantity,
		0 AS DebitUnitPrice,	
		0 AS DebitDiscountRate,
		Sum(isnull(OriginalAmount,0)) AS CreditOriginalAmount,
		Sum(isnull(ConvertedAmount,0)) AS CreditConvertedAmount,
		sum(isnull(Quantity,0)) AS CreditQuantity,
		AT9000.Ana01ID, T01.AnaName AS AnaName01,
		AT9000.Ana02ID, T02.AnaName AS AnaName02,
		AT9000.Ana03ID, T03.AnaName AS AnaName03,	
		AT9000.Ana04ID, T04.AnaName AS AnaName04,
		AT9000.Ana05ID, T05.AnaName AS AnaName05,
		AT9000.Ana06ID, T06.AnaName AS AnaName06,
		AT9000.Ana07ID, T07.AnaName AS AnaName07,
		AT9000.Ana08ID, T08.AnaName AS AnaName08,
		AT9000.Ana09ID, T09.AnaName AS AnaName09,
		AT9000.Ana10ID, T10.AnaName AS AnaName10,
		AT9000.InvoiceNo,
		AT9000.DivisionID
From AT9000 	
LEFT JOIN AT1302 on AT1302.InventoryID = AT9000.InventoryID and  AT1302.DivisionID = AT9000.DivisionID 
LEFT JOIN AT1202 A on A.ObjectID = AT9000.ObjectID and  A.DivisionID = AT9000.DivisionID
LEFT JOIN AT1202 B on B.ObjectID = AT9000.CreditObjectID and  B.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T01 on T01.AnaID = AT9000.Ana01ID and  T01.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T02 on T02.AnaID = AT9000.Ana02ID and  T02.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T03 on T03.AnaID = AT9000.Ana03ID and  T03.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T04 on T04.AnaID = AT9000.Ana04ID   AND  T04.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T05 on T05.AnaID = AT9000.Ana05ID   AND  T05.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T06 on T06.AnaID = AT9000.Ana06ID   AND  T06.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T07 on T07.AnaID = AT9000.Ana07ID   AND  T07.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T08 on T08.AnaID = AT9000.Ana08ID   AND  T08.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T09 on T09.AnaID = AT9000.Ana09ID   AND  T09.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T10 on T10.AnaID = AT9000.Ana10ID   AND  T10.DivisionID = AT9000.DivisionID
		
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
		AND IsNull(AT9000.InventoryID, ''' + @FromInventoryID + ''') Between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + '''
		AND CurrencyIDCN like '''+@CurrencyID+''' '+@SQLwhere + '
		
GROUP BY TransactionTypeID, AT9000.ObjectID, AT9000.CreditObjectID, A.ObjectName, B.ObjectName, A.Address, VoucherDate,VoucherNo, VoucherID, 
		VoucherTypeID,  VDescription, InventoryName, TDescription, AT9000.UnitID,
		Ana01ID, T01.AnaName, Ana02ID, T02.AnaName, Ana03ID, T03.AnaName, Ana04ID, T04.AnaName, Ana05ID, T05.AnaName,
		Ana06ID, T06.AnaName, Ana07ID, T07.AnaName, Ana08ID, T08.AnaName, Ana09ID, T09.AnaName, Ana10ID, T10.AnaName,
		AT9000.InvoiceNo,AT9000.DivisionID '
  End
  
If @IsPayable = 2 SET @sSQLunionall= ' Union All '

----------Phai tra-----------

If @IsPayable = 1 or @IsPayable = 2
  Begin
 	Set @sSQL1 = '
SELECT 	NULL AS TransactionTypeID, AT9000.ObjectID, A.ObjectName,
		--(Case when TransactionTypeID in (''T99'') then AT9000.CreditObjectID else AT9000.ObjectID end) AS ObjectID,
		--(Case when TransactionTypeID in (''T99'') then B.ObjectName else A.ObjectName end) AS ObjectName,
		A.Address,
		NULL AS VoucherDate, 
		NULL AS VoucherNo, 
		NULL AS VoucherTypeID,
		isnull(AT9000.InventoryID,'''') AS InventoryID,
		Isnull(InventoryName,isnull(AT9000.TDescription,'''')) AS InventoryName,
		AT9000.UnitID,  ''P'' AS R_P,
		sum(isnull(OriginalAmount,0)) AS DebitOriginalAmount, 
		sum(isnull(ConvertedAmount,0)) AS DebitConvertedAmount, 
		sum(isnull(Quantity,0)) AS DebitQuantity, 
		isnull(AT9000.UnitPrice,0) AS DebitUnitPrice,
		isnull(DiscountRate,0) AS DebitDiscountRate,
		0 AS CreditOriginalAmount,
		0 AS CreditConvertedAmount,
		0 AS CreditQuantity,
		AT9000.Ana01ID, T01.AnaName AS AnaName01,
		AT9000.Ana02ID, T02.AnaName AS AnaName02,
		AT9000.Ana03ID, T03.AnaName AS AnaName03,	
		AT9000.Ana04ID, T04.AnaName AS AnaName04,
		AT9000.Ana05ID, T05.AnaName AS AnaName05,
		AT9000.Ana06ID, T06.AnaName AS AnaName06,
		AT9000.Ana07ID, T07.AnaName AS AnaName07,
		AT9000.Ana08ID, T08.AnaName AS AnaName08,
		AT9000.Ana09ID, T09.AnaName AS AnaName09,
		AT9000.Ana10ID, T10.AnaName AS AnaName10,
		AT9000.InvoiceNo,
		AT9000.DivisionID
From AT9000 	
LEFT JOIN AT1302 on AT1302.InventoryID = AT9000.InventoryID and AT1302.DivisionID = AT9000.DivisionID 
LEFT JOIN AT1202 A on A.ObjectID = AT9000.ObjectID  and A.DivisionID = AT9000.DivisionID
LEFT JOIN AT1202 B on B.ObjectID = AT9000.CreditObjectID and B.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T01 on T01.AnaID = AT9000.Ana01ID  and T01.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T02 on T02.AnaID = AT9000.Ana02ID  and T02.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T03 on T03.AnaID = AT9000.Ana03ID  and T03.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T04 on T04.AnaID = AT9000.Ana04ID   AND  T04.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T05 on T05.AnaID = AT9000.Ana05ID   AND  T05.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T06 on T06.AnaID = AT9000.Ana06ID   AND  T06.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T07 on T07.AnaID = AT9000.Ana07ID   AND  T07.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T08 on T08.AnaID = AT9000.Ana08ID   AND  T08.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T09 on T09.AnaID = AT9000.Ana09ID   AND  T09.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T10 on T10.AnaID = AT9000.Ana10ID   AND  T10.DivisionID = AT9000.DivisionID
		
Where 	TransactionTypeID <>''T00'' AND DebitAccountID between ''' +  @FromPayAccountID + ''' AND ''' + @ToPayAccountID + '''
		AND AT9000.DivisionID ='''+@DivisionID+'''
		AND (AT9000.ObjectID between  '''+@FromObjectID+''' AND '''+@ToObjectID+''' AND A.Disabled=0)
		AND IsNull(AT9000.InventoryID, ''' + @FromInventoryID + ''') Between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + '''
		AND CurrencyIDCN like '''+@CurrencyID+''' '+ @SQLwhere + '
		
Group by	TransactionTypeID, AT9000.ObjectID, AT9000.CreditObjectID, 
			A.ObjectName, B.ObjectName, A.Address, isnull(AT9000.InventoryID,''''), isnull(AT9000.UnitPrice,0),
			Isnull(InventoryName,isnull(AT9000.TDescription,'''')), AT9000.UnitID, 
			Ana01ID, T01.AnaName, Ana02ID, T02.AnaName, Ana03ID, T03.AnaName, Ana04ID, T04.AnaName, Ana05ID, T05.AnaName,
			Ana06ID, T06.AnaName, Ana07ID, T07.AnaName, Ana08ID, T08.AnaName, Ana09ID, T09.AnaName, Ana10ID, T10.AnaName,
			AT9000.InvoiceNo, isnull(DiscountRate,0),AT9000.DivisionID'
			
---------->>>>Phải trả bên có
 	Set @sSQL1union = '
UNION ALL
SELECT 	NULL AS TransactionTypeID,
		(Case when TransactionTypeID in (''T99'') then AT9000.CreditObjectID else AT9000.ObjectID end) AS ObjectID,
		(Case when TransactionTypeID in (''T99'') then B.ObjectName else A.ObjectName end) AS ObjectName,
		A.Address,
		NULL AS VoucherDate, 
		NULL AS VoucherNo, 
		NULL AS VoucherTypeID,
		isnull(AT9000.InventoryID,'''') AS InventoryID,
		Isnull(InventoryName,isnull(AT9000.TDescription,'''')) AS InventoryName,
		AT9000.UnitID,  ''P'' AS R_P,
		0 AS DebitOriginalAmount, 
		0 AS DebitConvertedAmount, 
		0 AS DebitQuantity, 
		0 AS DebitUnitPrice,
		0 AS DebitDiscountRate,
		sum(isnull(OriginalAmount,0)) AS CreditOriginalAmount,
		sum(isnull(ConvertedAmount,0)) AS CreditConvertedAmount,
		sum(isnull(Quantity,0)) AS CreditQuantity,
		AT9000.Ana01ID, T01.AnaName AS AnaName01,
		AT9000.Ana02ID, T02.AnaName AS AnaName02,
		AT9000.Ana03ID, T03.AnaName AS AnaName03,	
		AT9000.Ana04ID, T04.AnaName AS AnaName04,
		AT9000.Ana05ID, T05.AnaName AS AnaName05,
		AT9000.Ana06ID, T06.AnaName AS AnaName06,
		AT9000.Ana07ID, T07.AnaName AS AnaName07,
		AT9000.Ana08ID, T08.AnaName AS AnaName08,
		AT9000.Ana09ID, T09.AnaName AS AnaName09,
		AT9000.Ana10ID, T10.AnaName AS AnaName10,
		AT9000.InvoiceNo,
		AT9000.DivisionID
From AT9000 	
LEFT JOIN AT1302 on AT1302.InventoryID = AT9000.InventoryID and AT1302.DivisionID = AT9000.DivisionID 
LEFT JOIN AT1202 A on A.ObjectID = AT9000.ObjectID  and A.DivisionID = AT9000.DivisionID
LEFT JOIN AT1202 B on B.ObjectID = AT9000.CreditObjectID and B.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T01 on T01.AnaID = AT9000.Ana01ID  and T01.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T02 on T02.AnaID = AT9000.Ana02ID  and T02.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T03 on T03.AnaID = AT9000.Ana03ID  and T03.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T04 on T04.AnaID = AT9000.Ana04ID   AND  T04.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T05 on T05.AnaID = AT9000.Ana05ID   AND  T05.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T06 on T06.AnaID = AT9000.Ana06ID   AND  T06.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T07 on T07.AnaID = AT9000.Ana07ID   AND  T07.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T08 on T08.AnaID = AT9000.Ana08ID   AND  T08.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T09 on T09.AnaID = AT9000.Ana09ID   AND  T09.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 T10 on T10.AnaID = AT9000.Ana10ID   AND  T10.DivisionID = AT9000.DivisionID
		
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
		AND IsNull(AT9000.InventoryID, ''' + @FromInventoryID + ''') Between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + '''
		AND CurrencyIDCN like '''+@CurrencyID+''' '+ @SQLwhere + '
		
Group by	TransactionTypeID, AT9000.ObjectID, AT9000.CreditObjectID, 
			A.ObjectName, B.ObjectName, A.Address, isnull(AT9000.InventoryID,''''), isnull(AT9000.UnitPrice,0),
			Isnull(InventoryName,isnull(AT9000.TDescription,'''')), AT9000.UnitID,
			Ana01ID, T01.AnaName, Ana02ID, T02.AnaName, Ana03ID, T03.AnaName, Ana04ID, T04.AnaName, Ana05ID, T05.AnaName,
			Ana06ID, T06.AnaName, Ana07ID, T07.AnaName, Ana08ID, T08.AnaName, Ana09ID, T09.AnaName, Ana10ID, T10.AnaName,
			AT9000.InvoiceNo, isnull(DiscountRate,0),AT9000.DivisionID'
			
  End

--print @sSQL + @sSQLunion + @sSQLunionall + @sSQL1 + @sSQL1union

If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV0359]') and OBJECTPROPERTY(id, N'IsView') = 1)
     		Exec ('  Create View AV0359 	--created by AP0359
				as ' + @sSQL + @sSQLunion + @sSQLunionall + @sSQL1 + @sSQL1union)
	Else
		Exec ('  Alter View AV0359  	--created by AP0359
				as ' + @sSQL + @sSQLunion + @sSQLunionall + @sSQL1 + @sSQL1union)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

