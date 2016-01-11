IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7100]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7100]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bao Anh		Date: 10/01/2013
--- Purpose: Truy van nguoc but toan tu BCDPS (hien thi giong so cai chi tiet AP7101)

CREATE PROCEDURE [dbo].[AP7100]
		@DivisionID AS NVARCHAR(50),
		@TranMonthFrom AS INT,
		@TranYearFrom AS INT,
		@TranMonthTo AS INT,
		@TranYearTo AS INT,
		@FromDate AS datetime,
		@ToDate  AS datetime,
		@IsDate AS tinyint,
		@AccountIDFrom AS NVARCHAR(50),
		@AccountIDTo AS NVARCHAR(50),
		@Level1 AS TINYINT
AS

DECLARE 	@strSQL AS NVARCHAR(MAX),
			@sSQLUnion as NVARCHAR(MAX)

IF @Level1 = 0
	SET @strSQL = '
		SELECT  DivisionID,			BatchID,				TransactionTypeID,
				AccountID,			CorAccountID,			D_C,			
				DebitAccountID, 	CreditAccountID,	
				Case when TransactionTypeID=''T98'' then  DateAdd(hh,1, VoucherDate) else  VoucherDate end AS  VoucherDate,		
				VoucherTypeID,	VoucherNo,
				InvoiceDate,		InvoiceNo,				Serial,			
				Sum(isnull(ConvertedAmount,0)) AS ConvertedAmount,
				Sum(isnull(OriginalAmount,0)) AS OriginalAmount,		
				Sum(isnull(OSignAmount,0)) AS OSignAmount,
				Sum(isnull(SignAmount,0)) AS SignAmount,
				CurrencyID,			ExchangeRate,		
				TranMonth,			TranYear,	
				TranMonth + TranYear*100 AS Period,
				CreateUserID,		VDescription,			BDescription, TDescription,
				ObjectID,			VATObjectID,
				VATNo,				VATObjectName,			Object_Address,	
				VATTypeID,			VATGroupID,		
				AccountID AS LinkAccountID ,
				AV5000.Orders,
				AV5000.SenderReceiver,
				AV5000.Ana01ID,AV5000.Ana02ID,AV5000.Ana03ID,AV5000.Ana04ID,AV5000.Ana05ID,
				AV5000.AnaName01,AV5000.AnaName02,AV5000.AnaName03,AV5000.AnaName04,AV5000.AnaName05,
				AV5000.VoucherID, AV5000.TableID, AV5000.Status'
ELSE
	SET @strSQL = '
		SELECT 	DivisionID,			BatchID,				TransactionTypeID,
				AccountID,			CorAccountID,			D_C,			
				DebitAccountID, 
				CreditAccountID,	
				Case when TransactionTypeID=''T98'' then  DateAdd(hh,1, VoucherDate) else  VoucherDate end AS  VoucherDate,		
				VoucherTypeID,		VoucherNo,
				InvoiceDate,		InvoiceNo,				Serial,			
				Sum(isnull(ConvertedAmount,0)) AS ConvertedAmount,
				Sum(isnull(OriginalAmount,0)) AS OriginalAmount,	
				Sum(isnull(OSignAmount,0)) AS OSignAmount,
				Sum(isnull(SignAmount,0)) AS SignAmount,	
				CurrencyID,			ExchangeRate,		
				TranMonth,			TranYear,				TranMonth + TranYear*100 AS Period,
				CreateUserID,				
				VDescription,		BDescription,			TDescription,
				ObjectID,			VATObjectID,
				VATNo,				VATObjectName,			Object_Address,	
				VATTypeID,			VATGroupID,		
				left(AccountID,' + str(@Level1+2) + ') AS LinkAccountID,
				AV5000.Orders,
				AV5000.SenderReceiver,
				AV5000.Ana01ID,AV5000.Ana02ID,AV5000.Ana03ID,AV5000.Ana04ID,AV5000.Ana05ID,
				AV5000.AnaName01,AV5000.AnaName02,AV5000.AnaName03,AV5000.AnaName04,AV5000.AnaName05,
				AV5000.VoucherID, AV5000.TableID, AV5000.Status'

SET @strSQL = @strSQL + ' 
		FROM	AV5000 '
SET @strSQL =	@strSQL + ' 
		WHERE	DivisionID like ''' + @DivisionID +'''
				AND (AccountID like ''' + @AccountIDFrom +'%''  OR AccountID like ''' + @AccountIDTo +'%''
				OR (AccountID >=  ''' + @AccountIDFrom +''' AND AccountID <=  ''' + @AccountIDTo +'''))
				'

If @IsDate = 0
	SET @strSQL =	@strSQL + ' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''''
Else 
	SET @strSQL =	@strSQL + ' AND VoucherDate <= ''' + convert(varchar(20),@ToDate,101) + ''' '		

SET @strSQL =	@strSQL + '  
		GROUP BY	DivisionID,		BatchID,			TransactionTypeID,
					AccountID,		CorAccountID,		D_C,			
					DebitAccountID, CreditAccountID,	
					VoucherDate,	VoucherTypeID,		VoucherNo,
					InvoiceDate,	InvoiceNo,			Serial,								
					CurrencyID,		ExchangeRate,		TranMonth,		TranYear,
					CreateUserID,	VDescription,		BDescription,	TDescription,
					ObjectID,		VATObjectID,
					VATNo,			VATObjectName,		Object_Address,	
					VATTypeID,		VATGroupID,		
					AccountID,		Orders ,			AV5000.SenderReceiver,
					AV5000.Ana01ID,AV5000.Ana02ID,AV5000.Ana03ID,AV5000.Ana04ID,AV5000.Ana05ID,
					AV5000.AnaName01,AV5000.AnaName02,AV5000.AnaName03,AV5000.AnaName04,AV5000.AnaName05,
					AV5000.VoucherID, AV5000.TableID, AV5000.Status'

Set @sSQLUnion = '
		UNION ALL
		SELECT  DivisionID,	NULL as	BatchID, TransactionTypeID,
				AccountID,	NULL as	CorAccountID, D_C,			
				DebitAccountID,	CreditAccountID,	
				VoucherDate, VoucherTypeID,	VoucherNo,
				NULL as InvoiceDate, NULL as InvoiceNo, NULL as Serial,			
				isnull(ConvertedAmount,0) AS ConvertedAmount,
				isnull(OriginalAmount,0) AS OriginalAmount,		
				isnull(SignOriginalAmount,0) AS OSignAmount,
				isnull(SignConvertedAmount,0) AS SignAmount,
				CurrencyID,			ExchangeRate,		
				TranMonth,			TranYear,	
				TranMonth + TranYear*100 AS Period,
				NULL as CreateUserID,		VDescription, NULL as BDescription, TDescription,
				ObjectID, NULL as VATObjectID,
				NULL as VATNo,	NULL as	VATObjectName,	NULL as	Object_Address,	
				NULL as VATTypeID,	NULL as VATGroupID,		
				(case when ' + str(@Level1) + ' = 0 then AccountID else left(AccountID,' + str(@Level1+2) + ') end) AS LinkAccountID,
				NULL as Orders,
				NULL as SenderReceiver,
				NULL as Ana01ID, NULL as Ana02ID, NULL as Ana03ID, NULL as Ana04ID, NULL as Ana05ID,
				NULL as AnaName01, NULL as AnaName02, NULL as AnaName03, NULL as AnaName04, NULL as AnaName05,
				VoucherID, ''AT9004'' as TableID, NULL as Status
		FROM AV9004
		WHERE	DivisionID like ''' + @DivisionID +'''
				AND (AccountID like ''' + @AccountIDFrom +'%''  OR AccountID like ''' + @AccountIDTo +'%''
				OR (AccountID >=  ''' + @AccountIDFrom +''' AND AccountID <=  ''' + @AccountIDTo +'''))
		'
If @IsDate = 0
	SET @sSQLUnion =	@sSQLUnion + ' AND TranYear*100+TranMonth <= ''' + str(@TranYearTo*100+@TranMonthTo) + ''''
Else 
	SET @sSQLUnion =	@sSQLUnion + ' AND VoucherDate <= ''' + convert(varchar(20),@ToDate,101) + ''' '
	
---Print  @sSQLUnion

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV4310' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV4310 --AP7100
	AS ' + @strSQL + @sSQLUnion)
ELSE
	EXEC ('ALTER VIEW AV4310 --AP7100
	AS ' + @strSQL + @sSQLUnion)


---- Chi hien thi So du
If @IsDate =0
Begin
SET @strSQL = 'SELECT V10.LinkAccountID, T01.AccountName, T01.AccountNameE, V10.DivisionID, '
SET @strSQL = @strSQL + ' sum(case when V10.TranYear*100+TranMonth < ''' + str(@TranYearFrom*100+@TranMonthFrom) + 
				''' OR V10.TransactionTypeID = ''' + 'T00' + ''' OR V10.TransactionTypeID = ''' + 'Z00' + ''' then SignAmount else 0 end) AS OpeningAmount, '
SET @strSQL = @strSQL + ' sum(case when V10.VoucherDate < ''' + convert(varchar(20), @FromDate, 101) + 
				''' OR V10.TransactionTypeID = ''' + 'T00' + ''' OR V10.TransactionTypeID = ''' + 'Z00' + ''' then OSignAmount else 0 end) AS OOpeningAmount, '

SET @strSQL = @strSQL + ' sum(SignAmount) AS ClosingAmount,'

SET @strSQL = @strSQL + ' sum(OSignAmount) AS OClosingAmount,'

SET @strSQL = @strSQL +'SUM (CASE WHEN  (V10.TranYear*100+V10.TranMonth) <=  ''' + str(@TranYearTo*100+@TranMonthTo) + 
				''' AND (V10.TranYear >= ''' + str(@TranYearFrom) + ''') AND
							V10.D_C ='''+'D'+''' AND V10.TransactionTypeID <> '''+'T00'+''' AND V10.TransactionTypeID <> '''+'Z00'+'''
							THEN ConvertedAmount ELSE 0 END) AS AccumulatedDebit,'
SET @strSQL = @strSQL +'SUM (CASE WHEN  (V10.TranYear*100+V10.TranMonth) <=  ''' + str(@TranYearTo*100+@TranMonthTo) + 
				''' AND (V10.TranYear >= ''' + str(@TranYearFrom) + ''') AND
							V10.D_C ='''+'C'+''' AND V10.TransactionTypeID <> '''+'T00'+''' AND V10.TransactionTypeID <> '''+'Z00'+'''
							THEN ConvertedAmount ELSE 0 END) AS AccumulatedCredit'


SET @strSQL = @strSQL + ' FROM AV4310 AS V10'
SET @strSQL = @strSQL + ' LEFT JOIN AT1005 AS T01 ON T01.AccountID = V10.LinkAccountID and T01.DivisionID = V10.DivisionID'


IF @Level1 <> 0	
	SET @strSQL =	@strSQL + ' WHERE len(V10.LinkAccountID) = ''' +str(@Level1+2) + ''''


SET @strSQL =	@strSQL + ' GROUP BY V10.LinkAccountID, T01.AccountName , T01.AccountNameE , V10.DivisionID'
End
Else
Begin
SET @strSQL = 'SELECT V10.LinkAccountID, T01.AccountName, T01.AccountNameE, V10.DivisionID, '
SET @strSQL = @strSQL + ' sum(case when V10.VoucherDate < ''' + convert(varchar(20), @FromDate, 101) + 
				''' OR V10.TransactionTypeID = ''' + 'T00' +''' OR V10.TransactionTypeID = ''' + 'Z00' +''' then SignAmount else 0 end) AS OpeningAmount, '

SET @strSQL = @strSQL + ' sum(case when V10.VoucherDate < ''' + convert(varchar(20), @FromDate, 101) + 
				''' OR V10.TransactionTypeID = ''' + 'T00' +''' OR V10.TransactionTypeID = ''' + 'Z00' +''' then OSignAmount else 0 end) AS OOpeningAmount, '

SET @strSQL = @strSQL + ' sum(SignAmount) AS ClosingAmount,'
SET @strSQL = @strSQL + ' sum(OSignAmount) AS OClosingAmount,'

SET @strSQL = @strSQL +'SUM (CASE WHEN  V10.VoucherDate<=  ''' +Convert(varchar(20), @ToDate,101) + '''
						AND V10.VoucherDate >= ''' +Convert(varchar(20), @FromDate,101)  + ''' AND
							V10.D_C ='''+'D'+''' AND V10.TransactionTypeID <> '''+'T00'+''' AND V10.TransactionTypeID <> '''+'Z00'+'''
							THEN ConvertedAmount ELSE 0 END) AS AccumulatedDebit,'
SET @strSQL = @strSQL +'SUM (CASE WHEN V10.VoucherDate  <=  ''' + Convert(varchar(20), @ToDate,101) + ''' 
						AND V10.VoucherDate >= ''' +Convert(varchar(20), @FromDate,101)  + ''' AND
							V10.D_C ='''+'C'+''' AND V10.TransactionTypeID <> '''+'T00'+''' AND V10.TransactionTypeID <> '''+'Z00'+'''
							THEN ConvertedAmount ELSE 0 END) AS AccumulatedCredit'


SET @strSQL = @strSQL + ' FROM AV4310 AS V10'
SET @strSQL = @strSQL + ' LEFT JOIN AT1005 AS T01 ON T01.AccountID = V10.LinkAccountID and T01.DivisionID = V10.DivisionID'


IF @Level1 <> 0	
	SET @strSQL =	@strSQL + ' WHERE len(V10.LinkAccountID) = ''' +str(@Level1+2) + ''''


SET @strSQL =	@strSQL + ' GROUP BY V10.LinkAccountID, T01.AccountName , T01.AccountNameE , V10.DivisionID'

End

--print @strSQL

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV4315' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV4315 --AP7100
	AS ' + @strSQL)
ELSE

	EXEC ('ALTER VIEW AV4315 AS --AP7100
	' + @strSQL)


----- Tra ra View so lieu phat sinh -- error here
SET @strSQL = 'SELECT *'
SET @strSQL = @strSQL + ' FROM AV4310  AS V10'

--SET @strSQL =	@strSQL + ' WHERE TranYear*100+TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''''
--SET @strSQL =	@strSQL + 'AND (TransactionTypeID is NULL OR TransactionTypeID <> ''' + 'T00' +''')'
--IF @Level1 <> 0	
	--SET @strSQL =	@strSQL + 'AND len(V10.LinkAccountID) = ''' +str(@Level1+2) + ''''

IF @IsDate =0
	SET @strSQL =	@strSQL + ' WHERE V10.TranYear*100+V10.TranMonth >= ''' + str(@TranYearFrom*100+@TranMonthFrom) + ''''
Else
	SET @strSQL =	@strSQL + ' WHERE (V10.VoucherDate Between ''' + convert(varchar(20), @FromDate,101)+ ''' And '''+convert(varchar(20),@ToDate,101)+ ''') '
SET @strSQL =	@strSQL + ' AND (V10.TransactionTypeID is NULL OR (V10.TransactionTypeID <> ''' + 'T00' +''' and V10.TransactionTypeID <> ''' + 'Z00' + '''))'
IF @Level1 <> 0	
	SET @strSQL =	@strSQL + ' AND len(V10.LinkAccountID) = ''' +str(@Level1+2) + ''''

--print @strSQL

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV4316' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV4316 --AP7100
	AS ' + @strSQL)
ELSE
	EXEC ('ALTER VIEW AV4316 --AP7100
	AS ' + @strSQL)


                   

SET @strSQL = '
	SELECT		ISNULL(V16.DivisionID, V15.DivisionID) AS DivisionID,  V16.BatchID, V16.TransactionTypeID, V16.Period, 
				isnull(V16.LinkAccountID, V15.LinkAccountID) AS AccountID, 
				V16.CorAccountID AS CorAccountID,
				V16.D_C AS D_C,  V16.DebitAccountID,       V16.CreditAccountID,
				V16.VoucherTypeID,
       			V16.VoucherNo,             V16.InvoiceDate, V16.VoucherDate, 
				V16.InvoiceNo,             V16.Serial,                V16.ConvertedAmount,                 V16.OriginalAmount,
				V16.CurrencyID,            V16.ExchangeRate,           V16.SignAmount,                        V16.OSignAmount ,
				V16.TranMonth, V16.TranYear,   V16.CreateUserID,          V16.VDescription, V16.BDescription,  
				--isnull(V16.TDescription, isnull(V16.BDescription,V16.VDescription)) AS TDescription,
				(case when (isnull(V16.TDescription,'''')='''') then isnull(V16.BDescription,V16.VDescription) else V16.TDescription end) AS TDescription,
 				V16. ObjectID,              V16.VATObjectID,           V16.VATNo       ,          V16.VATObjectName,
				V16.Object_Address,   V16.VATTypeID,             V16.VATGroupID,
				V15.OpeningAmount, 
				V15.ClosingAmount, 
				V15.AccountName, 
				
				V15.OOpeningAmount, 
				V15.OClosingAmount, 
				
				V15.AccountNameE, 
				V15.LinkAccountID  AS ReportAccountID, 				
				V15.AccumulatedDebit, 
				V15.AccumulatedCredit,
				V16.Orders,
				V16.SenderReceiver,
				V16.Ana01ID,V16.Ana02ID,V16.Ana03ID,V16.Ana04ID,V16.Ana05ID,
				V16.AnaName01,V16.AnaName02,V16.AnaName03,V16.AnaName04,V16.AnaName05, V16.VoucherID, V16.TableID, V16.Status'
SET @strSQL = @strSQL + ' FROM AV4315  AS V15'
SET @strSQL = @strSQL + ' LEFT JOIN AV4316  AS V16 ON V16.LinkAccountID = V15.LinkAccountID AND V15.DivisionID = V16.DivisionID
WHERE  Isnull(V15.OpeningAmount, 0) <> 0 OR isnull(V15.ClosingAmount, 0)<>0 OR  isnull(V16.ConvertedAmount,0) <>0 

'


--PRINT @strSQL
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV7100' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV7100 --AP7100
	AS ' + @strSQL)
ELSE
	EXEC ('ALTER VIEW AV7100 --AP7100
	AS ' + @strSQL)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

