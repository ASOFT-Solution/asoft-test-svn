/****** Object:  StoredProcedure [dbo].[AP0300]    Script Date: 07/28/2010 16:12:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----- Created by 	Nguyen Van Nhan, 
---- Purpose 	Insert bang tam, de phuc vu viec giai tru cong no
---- Edit by: 	Nguyen Quoc Huy, date 26/08/2008
--- Last Edit:      Thuy Tuyen 18/08/2009 sua Where  CurrencyID = CurrencyIDCN
/********************************************
'* Edited by: [GS] [Tố Oanh] [28/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[AP0300]  	@DivisionID as nvarchar(50), 
					@AccountID as nvarchar(50),  
					@CurrencyID as nvarchar(50),  
					@FromObjectID as nvarchar(50),  
					@ToObjectID as nvarchar(50), 
					@FromMonth as int, 
					@FromYear as int, 
					@ToMonth as int, 
					@ToYear as int, 
					@FromDate as Datetime, 
					@ToDate as Datetime, 
					@IsDate as tinyint,
					@FromAna01ID as nvarchar(50),
					@ToAna01ID as nvarchar(50),
					@FromAna02ID as nvarchar(50),
					@ToAna02ID as nvarchar(50),
					@FromAna03ID as nvarchar(50),
					@ToAna03ID as nvarchar(50)

AS

Set nocount on

Declare @sSQL as nvarchar(4000)

Delete AT0333 where DivisionID = @DivisionID


If @IsDate = 0  ---- Theo Ky
set @sSQL ='
Insert AT0333 	(DivisionID, VoucherID, BatchID, TableID, ObjectID, VoucherDate, DueDate, OriginalAmountCN, ConvertedAmount, 
		RemainOriginal, RemainConverted, AccountID, D_C, Ana02ID )
Select 		DivisionID, VoucherID, BatchID, TableID, ObjectID, VoucherDate, DueDate, OriginalAmountCN, ConvertedAmount, 
		OriginalAmountCN - GivedOriginalAmount, ConvertedAmount - GivedOriginalAmount, DebitAccountID, ''D'', Ana02ID
		From AV0301 
		Where 	DivisionID ='''+@DivisionID+''' and 
			(TranMonth+ 100*TranYear Between '+str(@FromMonth) +'  + 100*'+str(@FromYear) +' and '+str(@ToMonth)+'+100*'+str(@ToYear)+' ) and
			(ObjectID Between N'''+@FromObjectID+''' and N'''+@ToObjectID+''') and
			(CurrencyIDCN = N'''+@CurrencyID+''') and
			(DebitAccountID = N'''+@AccountID+''')  and
			OriginalAmountCN - GivedOriginalAmount >0  ---- Con lai chua giai tru
Union all
Select 		DivisionID, VoucherID, BatchID, TableID, ObjectID, VoucherDate, DueDate, OriginalAmountCN, ConvertedAmount, 
		OriginalAmountCN - GivedOriginalAmount, ConvertedAmount - GivedOriginalAmount, CreditAccountID, ''C'', Ana02ID
		From AV0302 
		Where 	DivisionID ='''+@DivisionID+''' and 			
			(ObjectID Between N'''+@FromObjectID+''' and '''+@ToObjectID+''') and
			(CurrencyIDCN = N'''+@CurrencyID+''') and
			(CreditAccountID = N'''+@AccountID+''')  and
			OriginalAmountCN - GivedOriginalAmount >0  ---- Con lai chua giai tru  '
	

Else  --- Theo ngay
set @sSQL ='
Insert AT0333 	(DivisionID, VoucherID, BatchID, TableID, ObjectID, VoucherDate, DueDate, OriginalAmountCN, ConvertedAmount, 
		RemainOriginal, RemainConverted, AccountID, D_C, Ana02ID)
Select 		DivisionID, VoucherID, BatchID, TableID, ObjectID, VoucherDate, DueDate, OriginalAmountCN, ConvertedAmount, 
		OriginalAmountCN - GivedOriginalAmount, ConvertedAmount - GivedOriginalAmount, DebitAccountID, ''D'', Ana02ID
		From AV0301 
		Where 	DivisionID ='''+@DivisionID+''' and 
			(VoucherDate between '''+convert(nvarchar(10),@FromDate,101)+''' and '''+convert(nvarchar(10),@ToDate,101)+''')  And
			(ObjectID Between N'''+@FromObjectID+''' and '''+@ToObjectID+''') and
			(CurrencyIDCN = N'''+@CurrencyID+''') and
			(DebitAccountID = N'''+@AccountID+''')  and
			OriginalAmountCN - GivedOriginalAmount >0  ---- Con lai chua giai tru
Union all
Select 		DivisionID, VoucherID, BatchID, TableID, ObjectID, VoucherDate, DueDate, OriginalAmountCN, ConvertedAmount, 
		OriginalAmountCN - GivedOriginalAmount, ConvertedAmount - GivedOriginalAmount, CreditAccountID, ''C'', Ana02ID
		From AV0302 
		Where 	DivisionID = '''+@DivisionID+''' and 
			(ObjectID Between N'''+@FromObjectID+''' and '''+@ToObjectID+''') and
			(CurrencyIDCN = N'''+@CurrencyID+''') and
			(CreditAccountID = N'''+@AccountID+''')  and
			OriginalAmountCN - GivedOriginalAmount >0  ---- Con lai chua giai tru '
	
if  isnull(@FromAna01ID,'')<>''
  Set @sSQL = @sSQL+' And Ana01ID between N'''+@FromAna01ID+''' and N'''+@ToAna01ID+''' '
if  isnull(@FromAna02ID,'')<>''
  Set @sSQL = @sSQL+' And Ana02ID between N'''+@FromAna02ID+''' and N'''+@ToAna02ID+''' '
if  isnull(@FromAna03ID,'')<>''
  Set @sSQL = @sSQL+' And Ana03ID between N'''+@FromAna03ID+''' and N'''+@ToAna03ID+''' '

Exec (@sSQL)

Set nocount off
---Print @sSQL