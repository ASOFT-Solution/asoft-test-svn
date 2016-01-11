IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0274]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0274]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by: Bao Anh
---- Date: 03/12/2012
---- Purpose: Loc danh sach cac phieu mua hang/ban hang dung de ke thua lap phieu thu/chi
---- Modify on 20/03/2013 by Bao Anh: Bo sung WHERE DebitAccountID de len dung so tien con lai khi TK cong no va TK thue khac nhau
---- Modify on 08/04/2013 by Bao Anh: Bo sung 10 MPT
---- Modify on 14/05/2013 by Bao Anh: Gan dien giai la NULL (khong ke thua Dien giai chung tu)
---- Modify on 14/06/2013 by Khanh Van: Bo sung load them tai khoan
---- Modify on 20/09/2013 by Khanh Van: Chinh sua lai store nham cai tien toc do
---- Modify on 14/10/2015 by Phuong Thao: Bo sung ke thua chi tiet theo phong ban (Customize Sieu Thanh)

CREATE PROCEDURE [dbo].[AP0274] @DivisionID nvarchar(50),
								@FromMonth int,
  								@FromYear int,
								@ToMonth int,
								@ToYear int,  
								@FromDate as datetime,
								@ToDate as Datetime,
								@IsDate as tinyint, ----0 theo ky, 1 theo ng�y
								@ObjectID nvarchar(50),
								@TransactionTypeID as nvarchar(50),	--- T03: ke thua phieu mua h�ng, T04: ke thua HDBH
								@ConditionVT nvarchar(1000),
								@IsUsedConditionVT nvarchar(1000),
								@ConditionOB nvarchar(1000),
								@IsUsedConditionOB nvarchar(1000)
			
 AS

Declare @sqlSelect as nvarchar(4000),
		@sqlSelect1 as nvarchar(4000),
		@sqlWhere  as nvarchar(4000),
		@CustomerName INT

CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)
IF @CustomerName = 16 --- Customize Sieu Thanh
	EXEC AP0274_ST @DivisionID, @FromMonth, @FromYear,  @ToMonth, @ToYear,  @FromDate,  @ToDate,
				@IsDate, @ObjectID, @TransactionTypeID, @ConditionVT, @IsUsedConditionVT,
				@ConditionOB ,@IsUsedConditionOB
ELSE
BEGIN		
	
IF @IsDate = 0
	Set  @sqlWhere = N'
	And  TranMonth+TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' +  cast(@ToMonth + @ToYear*100 as nvarchar(50))  + ' '
else
	Set  @sqlWhere = N'
	And VoucherDate  Between '''+Convert(nvarchar(10),@FromDate,21)+''' and '''+convert(nvarchar(10), @ToDate,21)+''''

If @TransactionTypeID = 'T03'
Set @sqlSelect1 = N'
Select AT9000.DivisionID, AT9000.VoucherID, CreditAccountID,
(isnull(OriginalAmount, 0) - isnull(OriginalAmountPC,0)) as EndOriginalAmount,
(isnull(ConvertedAmount, 0) - isnull(ConvertedAmountPC,0)) as EndConvertedAmount 
Into #Temp
FROM(
(Select 
	DivisionID, TranMonth, TranYear, VoucherID, VoucherDate, CreditAccountID,
	isnull(Sum(AT9000.OriginalAmount), 0)  as OriginalAmount,
	isnull(Sum(AT9000.ConvertedAmount), 0)  as ConvertedAmount
From AT9000
Where TransactionTypeID in (''T03'',''T13'')
Group by DivisionID, TranMonth, TranYear, VoucherID, VoucherDate, CreditAccountID) AT9000

Left join (
	Select DivisionID, TVoucherID, DebitAccountID, sum(OriginalAmount) As OriginalAmountPC, sum(ConvertedAmount) As ConvertedAmountPC
	From AT9000
	Where TransactionTypeID In (''T02'',''T22'',''T99'', ''T25'', ''T35'') 
	Group by DivisionID, TVoucherID, DebitAccountID
	) K  on AT9000.DivisionID = K.DivisionID and AT9000.VoucherID = K.TVoucherID and AT9000.CreditAccountID = K.DebitAccountID)
WHERE	AT9000.DivisionID =N'''+@DivisionID+N''''+@sqlWhere
Else
Set @sqlSelect1 = N'
Select AT9000.DivisionID, AT9000.VoucherID, DebitAccountID,
(isnull(OriginalAmount, 0) - isnull(OriginalAmountPT,0)) as EndOriginalAmount,
(isnull(ConvertedAmount, 0) - isnull(ConvertedAmountPT,0)) as EndConvertedAmount
Into #Temp
FROM(
(Select 
	DivisionID, TranMonth, TranYear, VoucherID, VoucherDate, DebitAccountID,
	isnull(Sum(AT9000.OriginalAmount), 0)  as OriginalAmount,
	isnull(Sum(AT9000.ConvertedAmount), 0)  as ConvertedAmount
From AT9000
Where TransactionTypeID in (''T04'',''T14'')
Group by DivisionID, TranMonth, TranYear, VoucherID, VoucherDate,DebitAccountID) AT9000

Left join (
	Select DivisionID, TVoucherID, CreditAccountID, sum(OriginalAmount) As OriginalAmountPT, sum(ConvertedAmount) As ConvertedAmountPT
	From AT9000
	Where TransactionTypeID In (''T01'',''T21'',''T99'',''T24'',''T34'')
	Group by DivisionID, TVoucherID, CreditAccountID
	) K  on AT9000.DivisionID = K.DivisionID and AT9000.VoucherID = K.TVoucherID and AT9000.DebitAccountID = K.CreditAccountID)
WHERE	AT9000.DivisionID =N'''+@DivisionID+N''''+@sqlWhere




SET @sqlSelect=N'
		SELECT 	Convert(TinyInt, 0) As Choose, AT9000.DivisionID, AT9000.VoucherTypeID, AT9000.VoucherID, AT9000.BatchID, VoucherDate, VoucherNo, Serial, InvoiceNo, InvoiceDate, 
				NULL as VDescription, NULL as BDescription, AT9000.ObjectID, ObjectName, AT1202.VATNo, AT1202.IsUpdateName,
				AT9000.CurrencyID, ExchangeRate,' + (case when @TransactionTypeID = 'T03' then 'CreditAccountID' else 'DebitAccountID' end) + ' as AccountID,
				max(AT9000.Ana01ID) as Ana01ID, max(AT9000.Ana02ID) as Ana02ID, max(AT9000.Ana03ID) as Ana03ID, max(AT9000.Ana04ID) as Ana04ID, max(AT9000.Ana05ID) as Ana05ID,
				max(AT9000.Ana06ID) as Ana06ID, max(AT9000.Ana07ID) as Ana07ID, max(AT9000.Ana08ID) as Ana08ID, max(AT9000.Ana09ID) as Ana09ID, max(AT9000.Ana10ID) as Ana10ID,
				Sum(OriginalAmount) as OriginalAmount, Sum(ConvertedAmount) as ConvertedAmount,
				(Select EndOriginalAmount From #Temp 
				Where DivisionID = ''' + @DivisionID + ''' And VoucherID = AT9000.VoucherID And ' + (case when @TransactionTypeID = 'T04' then 'DebitAccountID = AT9000.DebitAccountID' else 'CreditAccountID = AT9000.CreditAccountID' end) +') as EndOriginalAmount,
				(Select EndConvertedAmount From #Temp 
				Where DivisionID = ''' + @DivisionID + ''' And VoucherID = AT9000.VoucherID And ' + (case when @TransactionTypeID = 'T04' then 'DebitAccountID = AT9000.DebitAccountID' else 'CreditAccountID = AT9000.CreditAccountID' end) +') as EndConvertedAmount
				,InvoiceCode,InvoiceSign	
		FROM		AT9000
		LEFT JOIN	AT1202 
			ON		AT1202.DivisionID = AT9000.DivisionID AND AT1202.ObjectID = AT9000.ObjectID '
					
Set @sqlSelect = @sqlSelect + N'
		WHERE	AT9000.DivisionID =N'''+@DivisionID+N''' AND
				AT9000.ObjectID Like N'''+@ObjectID+N''' AND AT9000.TransactionTypeID in (' +
				case when @TransactionTypeID = 'T03' then '''T03'',''T13''' else '''T04'',''T14''' end + N') AND '

IF @TransactionTypeID = 'T03'
		Set @sqlSelect = @sqlSelect + N'VoucherID in (Select VoucherID FROM #Temp Where DivisionID = N''' + @DivisionID + ''' And EndOriginalAmount>0) '
ELSE
		Set @sqlSelect = @sqlSelect + N'VoucherID in (Select VoucherID FROM #Temp Where DivisionID = N''' + @DivisionID + ''' And EndOriginalAmount>0) '
Set @sqlWhere = @sqlWhere+'and (Isnull(AT9000.VoucherTypeID,''#'')  in ' + @ConditionVT + ' OR ' + @IsUsedConditionVT + ')
And (Isnull(AT9000.ObjectID,''#'')  in ' + @ConditionOB + ' OR ' + @IsUsedConditionOB + ')'

      
Set @sqlSelect = @sqlSelect	+@sqlWhere+
		'GROUP BY AT9000.DivisionID, AT9000.VoucherTypeID, AT9000.VoucherID, AT9000.BatchID, VoucherDate, VoucherNo, Serial, InvoiceNo,InvoiceCode,InvoiceSign, InvoiceDate, 
				AT9000.ObjectID, ObjectName, AT1202.VATNo, AT1202.IsUpdateName,
				AT9000.CurrencyID, ExchangeRate,' + (case when @TransactionTypeID = 'T03' then 'CreditAccountID' else 'DebitAccountID' end)+'

Order by VoucherID, VoucherDate, InvoiceNo'

Exec(@sqlSelect1+@sqlSelect)

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON