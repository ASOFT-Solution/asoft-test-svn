IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP0319]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP0319]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
----- Created by Nguyen Van  Nhan, Date 12/02/2004
---
--- Edit by Nguyen Quoc Huy, Date: 29/10/2006
---- Modified on 06/12/2011 by Le Thi Thu Hien : Sua ngay CONVERT(varchar(10),VoucherDate,101)
---- Modified on 17/01/2012 by Le Thi Thu Hien : CONVERT ngay
---- Modify on 18/03/2013 by bao Anh: Bo sung truong
-- <Example>
---- 

CREATE PROCEDURE [dbo].[AP0319] 
				@DivisionID AS nvarchar(50), 
				@FromObjectID  AS nvarchar(50),  
				@ToObjectID  AS nvarchar(50),  
				@FromAccountID  AS nvarchar(50),  
				@ToAccountID  AS nvarchar(50),  
				@CurrencyID  AS nvarchar(50),  
				@FromInventoryID AS nvarchar(50),
				@ToInventoryID AS nvarchar(50),
				@IsDate AS tinyint, 
				@FromMonth AS int, 
				@FromYear  AS int,  
				@ToMonth AS int,
				@ToYear AS int,
				@FromDate AS Datetime, 
				@ToDate AS Datetime

AS

--Print ' AP0319'

Declare @sSQL AS varchar(max),
		@TypeDate AS nvarchar(50),
		@FromPeriod AS int,
		@ToPeriod AS int,
		@SQLwhere AS nvarchar(4000)
	
Set @TypeDate ='VoucherDate'

Set @FromPeriod = (@FromMonth + @FromYear*100)	
Set @ToPeriod = (@ToMonth + @ToYear*100)	

IF @IsDate =0   ----- Truong hop tinh Tu ky den ky 
	Set @SQLwhere ='  AND   (AT9000.TranMonth+ AT9000.TranYear*100 Between '+str(@FromPeriod)+' and '+str(@ToPeriod)+')   '

Else
	Set @SQLwhere ='  AND (CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9000.'+ltrim(Rtrim(@TypeDate))+',101),101) Between '''+convert(nvarchar(10),@FromDate,101)+''' and '''+convert(nvarchar(10),@ToDate,101)+''')  '

Set @sSQL='
SELECT 	NULL AS TransactionTypeID,
		AT9000.DivisionID,
		AT9000.ObjectID,
		AT1202.ObjectName,
		VoucherDate, 
		VoucherNo,
		NULL AS VoucherTypeID,
		VDescription, BDescription, TDescription, DebitAccountID, CreditAccountID, InvoiceNo,
		isnull(AT9000.InventoryID,'''') AS InventoryID,
		Case when isnull(AT9000.InventoryName1,'''')= ''''  then Isnull(InventoryName,isnull(AT9000.TDescription,''''))Else AT9000.InventoryName1 end AS InventoryName,
		-----	Isnull(InventoryName,isnull(AT9000.TDescription,'''')) AS InventoryName,
		AT9000.UnitID,
		sum(OriginalAmount) AS DebitOriginalAmount, 
		sum(ConvertedAmount) AS DebitConvertedAmount, 
		sum(isnull(Quantity,0)) AS DebitQuantity, 
		AT9000.UnitPrice AS DebitUnitPrice,
		0 AS CreditOriginalAmount,
		0 AS CreditConvertedAmount,
		0 AS CreditQuantity,		
		AT9000.UParameter01 as Parameter01,
		AT9000.UParameter02 as Parameter02,
		AT9000.UParameter03 as Parameter03,
		AT9000.UParameter04 as Parameter04,
		AT9000.UParameter05 as Parameter05,
		ConvertedUnitID, AT1304.UnitName as ConvertedUnitName, sum(isnull(ConvertedQuantity,0)) AS DebitConvertedQuantity, 0 AS CreditConvertedQuantity,
		Serial, MarkQuantity
		
FROM	AT9000 	
LEFT JOIN AT1302 on AT1302.InventoryID = AT9000.InventoryID  and AT1302.DivisionID = AT9000.DivisionID
LEFT JOIN AT1202 on AT1202.ObjectID = AT9000.ObjectID  and AT1202.DivisionID = AT9000.DivisionID
LEFT JOIN AT1304 on AT1304.UnitID = AT9000.ConvertedUnitID  and AT1304.DivisionID = AT9000.DivisionID
Where 	((TransactionTypeID <>''T00'' and TransactionTypeID not in (''T24'',''T34'') 
		and DebitAccountID between  '''+@FromAccountID+''' and '''+@ToAccountID+''') or	
		(TransactionTypeID in (''T24'',''T34'') and DebitAccountID between  '''+@FromAccountID+''' and '''+@ToAccountID+''')) and 
		DebitAccountID between  '''+@FromAccountID+''' and '''+@ToAccountID+''' and AT9000.DivisionID ='''+@DivisionID+''' and
		(AT9000.ObjectID between  '''+@FromObjectID+''' and '''+@ToObjectID+''' and 
			AT1202.Disabled = 0) and
		((AT9000.InventoryID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''')  or TransactionTypeID=''T14'') and
		AT9000.CurrencyID like '''+@CurrencyID+''' '+ @SQLwhere

Set @sSQL = @sSQl +'
Group by	TransactionTypeID, AT9000.DivisionID, AT9000.ObjectID, AT1202.ObjectName, VoucherDate, VoucherNo,
			VDescription, BDescription, TDescription, DebitAccountID, CreditAccountID, InvoiceNo,
			isnull(AT9000.InventoryID,''''), AT9000.UnitPrice, InventoryName, AT9000.UnitID,InventoryName1,
			AT9000.UParameter01, AT9000.UParameter02, AT9000.UParameter03, AT9000.UParameter04, AT9000.UParameter05,
			ConvertedUnitID, AT1304.UnitName, Serial, MarkQuantity
'


Set @sSQL= @sSQL+' 
UNION ALL
SELECT 	''11'' AS TransactionTypeID,
		AT9000.DivisionID,
		AT9000.ObjectID,
		AT1202.ObjectName,
		VoucherDate, 
		VoucherNo,
		VoucherTypeID,
		VDescription, BDescription, TDescription, DebitAccountID, CreditAccountID, InvoiceNo,
		'''' AS InventoryID,
		(Case when TransactionTypeID in (''T24'',''T34'') then Isnull(InventoryName,isnull(AT9000.TDescription,''''))
				else VDescription end) AS InventoryName,
		NULL AS UnitID,
		0 AS DebitOriginalAmount,
		0 AS DebitConvertedAmount,
		NULL AS DebitQuantity,
		NULL AS DebitUnitPrice,	
		Sum(OriginalAmount) AS CreditOriginalAmount,
		Sum(ConvertedAmount) AS CreditConvertedAmount,
		sum(isnull(Quantity,0)) AS CreditQuantity,		
		NULL as Parameter01, NULL as Parameter02, NULL as Parameter03, NULL as Parameter04, NULL as Parameter05,
		NULL as ConvertedUnitID, NULL as ConvertedUnitName, NULL as DebitConvertedQuantity, sum(isnull(ConvertedQuantity,0)) AS CreditConvertedQuantity,
		Serial, Sum(MarkQuantity) as MarkQuantity
FROM	AT9000
LEFT JOIN AT1302 on AT1302.InventoryID = AT9000.InventoryID  and AT1302.DivisionID = AT9000.DivisionID
LEFT JOIN AT1202 on AT1202.ObjectID = AT9000.ObjectID   and AT1202.DivisionID = AT9000.DivisionID
Where 	((TransactionTypeID <>''T00'' and TransactionTypeID not in (''T24'',''T34'') 
		and CreditAccountID between  '''+@FromAccountID+''' and '''+@ToAccountID+''') or
		(TransactionTypeID in (''T24'',''T34'') and CreditAccountID between  '''+@FromAccountID+''' and '''+@ToAccountID+''')) and 
		AT9000.DivisionID ='''+@DivisionID+''' and
		(AT9000.ObjectID between  '''+@FromObjectID+''' and '''+@ToObjectID+''' and 
		AT1202.Disabled=0 ) and
		AT9000.CurrencyID like '''+@CurrencyID+'''  
		'+@SQLwhere + '

GROUP BY TransactionTypeID, AT9000.DivisionID, AT9000.ObjectID, AT1202.ObjectName, VoucherDate,VoucherNo, VoucherID, VoucherTypeID,
		VDescription, BDescription, TDescription, DebitAccountID, CreditAccountID, InvoiceNo, InventoryName, TDescription, Serial'
---Print @sSQL

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0319]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
     		EXEC ('  CREATE VIEW AV0319 --AP0319
     		 AS ' + @sSQL)
	ELSE
		EXEC ('  ALTER VIEW AV0319  --AP0319
		As ' + @sSQL)

