/****** Object:  StoredProcedure [dbo].[AP0450]    Script Date: 07/28/2010 17:22:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----- Created by 	Nguyen Van Nhan, 
---- Purpose 	Insert bang tam, de phuc vu viec giai tru cong no
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [28/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[AP0450]  	@DivisionID as nvarchar(50), 
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
					@ToAna01ID as nvarchar(50)
					

AS

Set nocount on

Declare @sSQL as nvarchar(4000)
SET @sSQL = '';

Delete AT0333

print @FromDate
print @ToDate
If @IsDate = 0  ---- Theo Ky
set @sSQL ='
Insert AT0333 (DivisionID, VoucherID, BatchID, TableID, ObjectID, VoucherDate, DueDate, OriginalAmountCN, ConvertedAmount, 
		RemainOriginal, RemainConverted, AccountID, D_C, Ana01ID )
Select DivisionID, VoucherID, BatchID, TableID, ObjectID, VoucherDate, DueDate, OriginalAmountCN, ConvertedAmount, 
		OriginalAmountCN - GivedOriginalAmount, ConvertedAmount - GivedOriginalAmount, CreditAccountID, ''C'', Ana01ID
		From AV0402 
		Where DivisionID ='''+@DivisionID+''' and 
			(TranMonth+ 100*TranYear Between '+str(@FromMonth) +'  + 100*'+str(@FromYear) +' and '+str(@ToMonth)+'+100*'+str(@ToYear)+' ) and
			(ObjectID Between '''+@FromObjectID+''' and '''+@ToObjectID+''') and
			(CurrencyID = '''+@CurrencyID+''') and
			(CreditAccountID = '''+@AccountID+''')  and
			OriginalAmountCN - GivedOriginalAmount >0  ---- Con lai chua giai tru
Union all
Select DivisionID, VoucherID, BatchID, TableID, ObjectID, VoucherDate, DueDate, OriginalAmountCN, ConvertedAmount, 
		OriginalAmountCN - GivedOriginalAmount, ConvertedAmount - GivedOriginalAmount, DebitAccountID, ''D'', Ana01ID
		From AV0401 
		Where DivisionID ='''+@DivisionID+''' and 			
			(ObjectID Between '''+@FromObjectID+''' and '''+@ToObjectID+''') and
			(CurrencyID = '''+@CurrencyID+''') and
			(DebitAccountID = '''+@AccountID+''')  and
			OriginalAmountCN - GivedOriginalAmount >0  ---- Con lai chua giai tru  '
	

Else  --- Theo ngay
set @sSQL ='
Insert AT0333 (DivisionID, VoucherID, BatchID, TableID, ObjectID, VoucherDate, DueDate, OriginalAmountCN, ConvertedAmount, 
		RemainOriginal, RemainConverted, AccountID, D_C, Ana01ID)
Select 	DivisionID, VoucherID, BatchID, TableID, ObjectID, VoucherDate, DueDate, OriginalAmountCN, ConvertedAmount, 
		OriginalAmountCN - GivedOriginalAmount, ConvertedAmount - GivedOriginalAmount, CreditAccountID, ''C'', Ana01ID
		From AV0402 
		Where 	DivisionID ='''+@DivisionID+''' and 
			(VoucherDate between '''+convert(nvarchar(10),@FromDate,101)+''' and '''+convert(nvarchar(10),@ToDate,101)+''')  And
			(ObjectID Between '''+@FromObjectID+''' and '''+@ToObjectID+''') and
			(CurrencyID = '''+@CurrencyID+''') and
			(CreditAccountID = '''+@AccountID+''')  and
			OriginalAmountCN - GivedOriginalAmount >0  ---- Con lai chua giai tru
Union all
Select 		VoucherID, BatchID, TableID, ObjectID, VoucherDate, DueDate, OriginalAmountCN, ConvertedAmount, 
		OriginalAmountCN - GivedOriginalAmount, ConvertedAmount - GivedOriginalAmount, DebitAccountID, ''D'', Ana01ID
		From AV0401 
		Where 	DivisionID = '''+@DivisionID+''' and 
			(ObjectID Between '''+@FromObjectID+''' and '''+@ToObjectID+''') and
			(CurrencyID = '''+@CurrencyID+''') and
			(DebitAccountID = '''+@AccountID+''')  and
			OriginalAmountCN - GivedOriginalAmount >0  ---- Con lai chua giai tru '
			
--print @sSQL	
if  isnull(@FromAna01ID,'')<>''
  Set @sSQL = @sSQL+' And Ana01ID between '''+@FromAna01ID+''' and '''+@ToAna01ID+''' '

Exec (@sSQL)

Set nocount off
---Print @sSQL