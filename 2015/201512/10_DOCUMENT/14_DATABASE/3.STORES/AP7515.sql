IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7515]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7515]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-------- Created by Nguyen Van Nhan.
-------- Date 12/12/2007. In so ngan hang, tu thang --- den thang ----- 
--------Last Edit Thuy Tuyen, 18/03/2008/  lay so du dau ky theo BankAccountID
--------Edit by Nguyen Quoc Huy, Date 25/09/2008
--------Edit by Thien Huynh, Date 14/03/2012
---- Modified on 24/05/2013 by Lê Thị Thu Hiền : Bổ sung 10 khoản mục Ana
---- Modified on 26/06/2013 by Lê Thị Thu Hiền : Không select dữ liệu từ View AV1111 ( Cải tiến tốc độ)
/**********************************************
** Edited by: [GS] [Cẩm Loan] [30/07/2010]
***********************************************/
---- EXEC AP7515 'AS', '1311', '1311', 'VND', 1, 2011, 12, 2013,'','1=1'
---- Modified on 01/10/2013 by Khánh Vân: Cải thiện tốc độ
---- Modified on 03/10/2014 by Quốc Tuấn : bo sung điều kiện where
---- Modified on 08/10/2015 by Tieu Mai: Sửa tiền hạch toán theo thiết lập đơn vị-chi nhánh


CREATE PROCEDURE [dbo].[AP7515]  	
		@DivisionID AS nvarchar(50),
		@BankID AS nvarchar(50),
		@AccountID AS nvarchar(50),			
		@CurrencyID AS nvarchar(50),
		@FromMonth AS int,
		@FromYear AS int,
		@ToMonth AS int,
		@ToYear AS int,
		@Orderby as nvarchar(1000),
		@SqlWhere AS NVARCHAR(MAX)
				
AS
Declare @sSQLSelect AS nvarchar(4000),
		@sSQLFrom AS nvarchar(4000),
		@sSQLUnion AS nvarchar(4000),
		@sSQL AS nvarchar(4000),
		@sSQL1 AS nvarchar(4000),
		@sSQL2 AS nvarchar(4000),
		@sSQL3 AS nvarchar(4000),
		@sSQL4 AS nvarchar(4000),
		@sSQL5 AS nvarchar(4000),
		@sWHERE1 AS NVARCHAR(MAX),
		@sWHERE2 AS NVARCHAR(MAX)

SET @sWHERE1 = ''
SET @sWHERE2 = ''
		
IF @CurrencyID <> '' AND @CurrencyID <> '%'
BEGIN
	SET @sWHERE1 = @sWHERE1 + ' 
		AND		CASE WHEN TransactionTypeID=''T16'' then CurrencyIDCN else AT9000.CurrencyID END = '''+@CurrencyID+''' '	
	SET @sWHERE2 = @sWHERE2 + ' 
		AND		AT1016.CurrencyID = '''+@CurrencyID+''' '
END

IF @AccountID <> '' AND @AccountID <> '%'
BEGIN
	SET @sWHERE1 = @sWHERE1 + ' 
		AND	AT9000.CreditAccountID = '''+@AccountID+''' '
	SET @sWHERE2 = @sWHERE2 + '
		AND AT9000.DebitAccountID = '''+@AccountID+''' '
END



Set @sSQLSelect = N'
SELECT  DivisionID,
		TranMonth,
		TranYear,
		BankAccountID,
		AccountID, 
		CreditAccountID,
		DebitAccountID,
		CurrencyID,
		ExchangeRate,
		OriginalAmount,	
		ConvertedAmount,
		SignOriginalAmount,	
		SignConvertedAmount,
		VoucherDate,
		VoucherNo,
		VoucherID,
		ObjectID,
		VDescription,
		TDescription,
		BDescription,
		TransactionTypeID,
		D_C,
		Ana01ID,Ana02ID,Ana03ID,Ana04ID,Ana05ID,
		Ana06ID,Ana07ID,Ana08ID,Ana09ID,Ana10ID	 
Into #AV0087'

Print @sSQLSelect
	
SET @sSQLFrom = N'
From (
SELECT  AT9000.DivisionID,
		AT9000.TranMonth,
		AT9000.TranYear,
		CreditBankAccountID AS BankAccountID,
		CreditAccountID AS AccountID, 
		CreditAccountID,
		DebitAccountID,
		CASE WHEN TransactionTypeID=''T16'' then CurrencyIDCN else AT9000.CurrencyID END AS CurrencyID,
		CASE WHEN TransactionTypeID=''T16'' then ExchangeRateCN else AT9000.ExchangeRate End AS ExchangeRate,
		CASE WHEN TransactionTypeID=''T16'' then OriginalAmountCN else OriginalAmount End AS OriginalAmount,	
		ConvertedAmount,
		-CASE WHEN TransactionTypeID=''T16'' then OriginalAmountCN else OriginalAmount End AS SignOriginalAmount,	
		-ConvertedAmount AS SignConvertedAmount,
		VoucherDate,
		VoucherNo,
		VoucherID,
		ObjectID,
		VoucherTypeID
		VDescription,
		TDescription,
		BDescription,
		TransactionTypeID,
		''C'' AS D_C,
		Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
		AT9000.Ana06ID,	AT9000.Ana07ID,	AT9000.Ana08ID,AT9000.Ana09ID,AT9000.Ana10ID	 
FROM	AT9000 	
LEFT JOIN AT1016 on AT1016.BankAccountID = AT9000.CreditBankAccountID AND AT1016.DivisionID = AT9000.DivisionID
WHERE	ISNULL(CreditBankAccountID,'''') <>''''
		AND	AT9000.DivisionID = '''+@DivisionID+''' 
		--AND AT9000.TranYear*100+AT9000.TranMonth >= '+STR(@FromYear * 100 + @FromMonth)+'
		AND AT9000.TranYear*100+AT9000.TranMonth <= '+STR(@ToYear * 100 + @ToMonth)+' 
		'+@sWHERE1+''
Print @sSQLFrom

Set @sSQLUnion = N'
UNION ALL
SELECT   AT9000.DivisionID,
		AT9000.TranMonth,
		AT9000.TranYear,
		DebitBankAccountID AS BankAccountID,
		DebitAccountID AS AccountID, 
		CreditAccountID,
		DebitAccountID,
		AT1016.CurrencyID,
		AT9000.ExchangeRate,
		CASE WHEN AT1016.CurrencyID = (SELECT   top 1 BasecurrencyID from AT1101 where DivisionID = '''+@DivisionID+''') then ConvertedAmount else OriginalAmount end AS OriginalAmount,
		ConvertedAmount,
		CASE WHEN AT1016.CurrencyID = (SELECT  top  1  BasecurrencyID from AT1101 where DivisionID = '''+@DivisionID+''')  then ConvertedAmount else OriginalAmount end AS SignOriginalAmount,
		ConvertedAmount AS SignConvertedAmount,

		VoucherDate,
		VoucherNo,
		VoucherID,
		ObjectID,
		VoucherTypeID
		VDescription,
		TDescription,
		BDescription,
		TransactionTypeID,
		''D'' AS D_C,
		Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
		AT9000.Ana06ID,	AT9000.Ana07ID,	AT9000.Ana08ID,AT9000.Ana09ID,AT9000.Ana10ID 
FROM	AT9000 	
LEFT JOIN AT1016 on AT1016.BankAccountID = AT9000.DebitBankAccountID AND AT1016.DivisionID = AT9000.DivisionID
WHERE  ISNULL(DebitBankAccountID,'''')<>''''
		AND	AT9000.DivisionID = '''+@DivisionID+'''
		--AND AT9000.TranYear*100+AT9000.TranMonth >= '+STR(@FromYear * 100 + @FromMonth)+'
		AND AT9000.TranYear*100+AT9000.TranMonth <= '+STR(@ToYear * 100 + @ToMonth)+' 
		'+@sWHERE2+'
 )A  WHERE '+@SqlWhere+'

'
Print @sSQLUnion

----- Buoc 1, So du dau ky----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
Set @sSQL ='
SELECT	Isnull(Sum(SignOriginalAmount),0) as BegOriginalAmount, 
		Isnull(sum(SignConvertedAmount),0)as BegConvertedAmount
Into #Temp1
FROM	#AV0087 AV1111 
INNER JOIN AT1016 on AT1016.BankAccountID = AV1111.BankAccountID AND AT1016.DivisionID = AV1111.DivisionID
WHERE	
		IsNull(BankID, '''') LIKE '''+@BankID+''' 
		and ( (TranMonth + TranYear*100<'+STR(@FromYear * 100 + @FromMonth)+' ) 
		or (TranMonth + TranYear*100='+STR(@FromYear * 100 + @FromMonth)+' and TransactionTypeID=''T00'' ))  

SELECT	Isnull(Sum(SignOriginalAmount),0) as EndOriginalAmount, 
		Isnull(sum(SignConvertedAmount),0) as EndConvertedAmount
Into #Temp2 
FROM	#AV0087 AV1111 
INNER JOIN AT1016 on AT1016.BankAccountID = AV1111.BankAccountID AND AT1016.DivisionID = AV1111.DivisionID
WHERE	IsNull(BankID, '''') LIKE '''+@BankID+''' 
		and ( TranMonth + TranYear*100<='+STR(@ToYear * 100 + @ToMonth)+')
'

----- Buoc 1b, So du dau ky theo  BankAccountID ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Print @sSQL

SET @sSQL1 =' 
SELECT	AV1111.DivisionID, 
		SUM(ISNULL(SignOriginalAmount,0)) AS  BegOriginalAmountDe  ,
		SUM(ISNULL(SignConvertedAmount,0)) AS BegConvertedAmountDe, 
		AV1111.BankAccountID, ObjectName

Into #AV7516		
FROM	#AV0087 AV1111
INNER JOIN AT1016 on AT1016.BankAccountID =AV1111.BankAccountID AND AT1016.DivisionID =AV1111.DivisionID
LEFT JOIN AT1202 on AT1202.ObjectID =AT1016.BankID AND AT1202.DivisionID =AT1016.DivisionID

WHERE	ISNULL(AT1016.BankID,'''') LIKE '''+@BankID+'''  
		and ( (TranMonth + TranYear*100< ('+str(@FromMonth)+' + '+str(@FromYear)+'*100) ) or (TranMonth + TranYear*100= ('+str(@FromMonth)+' + '+str(@FromYear)+'*100)  and TransactionTypeID=''T00''))  
GROUP BY AV1111.DivisionID,AV1111.BankAccountID,ObjectName
'

Print @sSQL1

----- Buoc 2,  Xac dinh so phat sinh ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET @sSQL2='
SELECT	AV1111.DivisionID, TranMonth, TranYear,  CreditAccountID, DebitAccountID, 

		NULL AS AccountID, 
		(CASE WHEN CreditAccountID <> AV1111.AccountID then CreditAccountID else DebitAccountID End ) AS CorAccountID,
		ISNULL (AT01.ObjectName, AV7516.ObjectName) AS BankName,		
		(Select BegOriginalAmount from #Temp1) as BegOriginalAmount,
		(Select BegConvertedAmount from #Temp1 )as BegConvertedAmount,					 
		(Select EndOriginalAmount from #Temp2 )as EndOriginalAmount,
		(Select EndConvertedAmount from #Temp2 )as EndConvertedAmount,	
		ISNULL(BegOriginalAmountDe,0) AS BegOriginalAmountDe,
		ISNULL(BegConvertedAmountDe,	0) AS BegConvertedAmountDe,	
						 
		CASE WHEN D_C = ''D'' then OriginalAmount else 0 End AS ReOriginalAmount, 
		CASE WHEN D_C = ''D'' then ConvertedAmount else 0 End AS ReConvertedAmount,
		CASE WHEN D_C = ''C'' then OriginalAmount else 0 End AS DeOriginalAmount, 
		CASE WHEN D_C = ''C'' then ConvertedAmount else 0 End AS DeConvertedAmount, 

		VoucherDate,
		CASE WHEN D_C = ''D'' then VoucherNo else NULL end AS ReVoucherNo, 
		CASE WHEN D_C = ''C'' then VoucherNo else NULL end AS DeVoucherNo, 

		VDescription, TDescription, BDescription, 
		AV1111.ObjectID, AT02.ObjectName,

		CASE WHEN TransactionTypeID = ''T16'' AND D_C = ''C''  THEN ''T26'' ELSE TransactionTypeID  END AS TransactionTypeID , 
		D_C, 
		Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,
		AV1111.BankAccountID,  AV1111.CurrencyID, AT1016.BankAccountNo, 
		BankID
Into #AV7515
FROM	#AV0087 AV1111 	
INNER JOIN AT1016 on AT1016.BankAccountID =AV1111.BankAccountID AND AT1016.DivisionID =AV1111.DivisionID
LEFT JOIN #AV7516 AV7516 on AV7516.BankAccountID = AV1111.BankAccountID AND AV7516.DivisionID = AV1111.DivisionID
LEFT JOIN AT1202 AT01 on AT01.ObjectID =AT1016.BankID AND AT01.DivisionID =AT1016.DivisionID
LEFT JOIN AT1202 AT02 on AT02.ObjectID =AV1111.ObjectID AND AT02.DivisionID =AV1111.DivisionID

WHERE 	TransactionTypeID<>''T00'' AND
		ISNULL(AT1016.BankID,'''') LIKE '''+@BankID+'''  AND 
		(TranMonth + TranYear*100 Between ('+str(@FromMonth)+' + '+str(@FromYear)+'*100) and ('+str(@ToMonth)+' + '+str(@ToYear)+'*100))  '
Print @sSQL2

SET @sSQL3 ='SELECT * FROM #AV7515 
	UNION ALL
		SELECT	
				AV7516.DivisionID, 
				NULL AS TranMonth, 
				NULL AS TranYear,  
				NULL AS CreditAccountID, 
				NULL AS DebitAccountID, 
				NULL AS AccountID, 
				NULL AS CorAccountID,				
				AV7516.ObjectName AS  BankName,						
				(Select BegOriginalAmount from #Temp1 ) as BegOriginalAmount,
				(Select BegConvertedAmount from #Temp1 )as BegConvertedAmount,					 
				(Select EndOriginalAmount from #Temp2 )as EndOriginalAmount,
				(Select EndConvertedAmount from #Temp2 )as EndConvertedAmount,	
					 
				ISNULL(BegOriginalAmountDe,0) AS BegOriginalAmountDe,
				ISNULL(BegConvertedAmountDe,	0) AS BegConvertedAmountDe,									 
				0  AS ReOriginalAmount, 
				0  AS ReConvertedAmount,
				0  AS DeOriginalAmount, 
				0  AS DeConvertedAmount, 
				Convert(DateTime, NULL) AS VoucherDate,
				NULL  AS ReVoucherNo, 
				NULL  AS DeVoucherNo, 
				NULL AS VDescription, NULL AS TDescription, NULL AS BDescription, 
				NULL AS ObjectID, NULL AS  ObjectName,
				''TZZ'' AS TransactionTypeID, -- Gan <> NULL de Count tren Report
				NULL AS D_C, 
				Null as	Ana01ID,
				Null as	Ana02ID,
				Null as	Ana03ID,
				Null as	Ana04ID,
				Null as	Ana05ID,
				Null as	Ana06ID,
				Null as	Ana07ID,
				Null as	Ana08ID,
				Null as	Ana09ID,
				Null as	Ana10ID,
				AV7516.BankAccountID,  NULL AS CurrencyID, NULL AS BankAccountNo, 
				NULL AS BankID
		FROM		#AV7516 AV7516

		WHERE	AV7516.BankAccountID NOT IN (SELECT ISNULL(BankAccountID,'''') FROM #AV7515 ) 
				AND (ISNULL(BegOriginalAmountDe,0) <> 0 or ISNULL(BegConvertedAmountDe,0) <> 0)'+@Orderby
				
SET @sSQL4 ='SELECT	
				AV7516.DivisionID, 
				NULL AS TranMonth, 
				NULL AS TranYear,  
				NULL AS CreditAccountID, 
				NULL AS DebitAccountID, 
				NULL AS AccountID, 
				NULL AS CorAccountID,				
				AV7516.ObjectName AS  BankName,						
				(Select BegOriginalAmount from #Temp1 ) as BegOriginalAmount,
				(Select BegConvertedAmount from #Temp1 )as BegConvertedAmount,					 
				(Select EndOriginalAmount from #Temp2 )as EndOriginalAmount,
				(Select EndConvertedAmount from #Temp2 )as EndConvertedAmount,	
					 
				ISNULL(BegOriginalAmountDe,0) AS BegOriginalAmountDe,
				ISNULL(BegConvertedAmountDe,	0) AS BegConvertedAmountDe,									 
				0  AS ReOriginalAmount, 
				0  AS ReConvertedAmount,
				0  AS DeOriginalAmount, 
				0  AS DeConvertedAmount, 
				Convert(DateTime, NULL) AS VoucherDate,
				NULL  AS ReVoucherNo, 
				NULL  AS DeVoucherNo, 
				NULL AS VDescription, NULL AS TDescription, NULL AS BDescription, 
				NULL AS ObjectID, NULL AS  ObjectName,
				''TZZ'' AS TransactionTypeID, -- Gan <> NULL de Count tren Report
				NULL AS D_C, 
				Null as	Ana01ID,
				Null as	Ana02ID,
				Null as	Ana03ID,
				Null as	Ana04ID,
				Null as	Ana05ID,
				Null as	Ana06ID,
				Null as	Ana07ID,
				Null as	Ana08ID,
				Null as	Ana09ID,
				Null as	Ana10ID,
				AV7516.BankAccountID,  NULL AS CurrencyID, NULL AS BankAccountNo, 
				NULL AS BankID
		FROM		#AV7516 AV7516'
				
Set @sSQL5 = 'If Exists (Select top 1  1 From #AV7515) 
				Begin 
				'+@sSQL3+'
				End
				else 
				Begin
				'+@sSQL4+' 
				end'
EXEC (@sSQLSelect+@sSQLFrom+@sSQLUnion+@sSQL+@sSQL1+@sSQL2+@sSQL5)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

