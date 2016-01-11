/****** Object:  StoredProcedure [dbo].[AP3015]    Script Date: 12/31/2010 11:19:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--In phiÕu tong hop
--Created by Hoang Thi Lan
--Edit by Nguyen Quoc Huy,
 --Last Edit: Thuy Tuyen , date 15/09/2008. lay  truong dia chi doi tuong no va co

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'* Edited by: [GS] [Cẩm Loan] [10/01/2010] [Thêm điều kiện DivisionID]
'********************************************/

ALTER PROCEDURE 		[dbo].[AP3015] @DivisionID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int,
					@VoucherID as nvarchar(50)
	
 AS
Declare @sSQL1 as nvarchar(4000),
	@sSQL2 as nvarchar(4000),
	@AT9000Cursor as cursor,
	@InvoiceNo as nvarchar(50),
	@Serial as nvarchar(50),
	@InvoiceNoList as nvarchar(500),
	@DebitAccountList as nvarchar(500),
	@DebitAccountID  as nvarchar(50),
	@CreditAccountList as nvarchar(500),
	@CreditAccountID  as nvarchar(50)

SET @InvoiceNoList =''
SET @AT9000Cursor = CURSOR SCROLL KEYSET FOR
Select Distinct Serial , InvoiceNo From AT9000 Where VoucherID =@VoucherID and TransactionTypeID ='T99' and DivisionID = @DivisionID
OPEN @AT9000Cursor
		FETCH NEXT FROM @AT9000Cursor INTO @Serial , @InvoiceNo
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @InvoiceNoList<>''
				Set @InvoiceNoList = @InvoiceNoList+'; '+@Serial+'.'+@InvoiceNo
			Else
				Set @InvoiceNoList =@Serial+'.'+@InvoiceNo

			FETCH NEXT FROM @AT9000Cursor INTO @Serial, @InvoiceNo
		END

CLOSE @AT9000Cursor

If @InvoiceNoList<>'' 
	Set @InvoiceNoList =N' Kèm theo: '+@InvoiceNoList+' chứng từ gốc'

Set @sSQL1 =N'
Select Distinct	VoucherID, AT9000.DivisionID, TranMonth, TranYear, 
	Orders,
	VoucherTypeID, VoucherNo, VoucherDate,
	AT9000.InvoiceNo,
	InvoiceDate,
	AT9000.Serial, 
	Ana01ID, 
	Ana02ID, 
	Ana03ID, 
	AT9000.ObjectID,
	AT9000.CreditObjectID,
	AT9000.ObjectID+ '' - ''+A.ObjectName as DebitObjectName,
	A.Address as DebitAddress,
	AT9000.CreditObjectID+'' - ''+ B.ObjectName as CreditObjectName,
	B.Address as CreditAddress,
	VDescription,
	BDescription,
	TDescription,
	'''+isnull(@InvoiceNoList,'')+''' as InvoiceNoList,
	DebitAccountID,
	C.AccountName as DebitAccountName,
	CreditAccountID, 
	D.AccountName as CreditAccountName,
	FullName,
	ChiefAccountant,

	AT9000.CurrencyID, ExchangeRate,
	ConvertedAmount as ConvertedAmount,
	OriginalAmount as OriginalAmount	'

Set @sSQL2 =N'
 From AT9000  	Left  join AT1202 A on A.ObjectID = AT9000.ObjectID And A.DivisionID = AT9000.DivisionID
		Left  join AT1202 B on B.ObjectID = AT9000.CreditObjectID And B.DivisionID = AT9000.DivisionID

		Left  join AT1005 C on C.AccountID = AT9000.DebitAccountID And C.DivisionID = AT9000.DivisionID
		Left  join AT1005 D on D.AccountID = AT9000.CreditAccountID And D.DivisionID = AT9000.DivisionID

		Left join AT1103 On AT1103.EmployeeID = AT9000.EmployeeID and AT1103.DivisionID =AT9000.DivisionID,
	AT0001

 Where 	AT9000.DivisionID = AT0001.DivisionID and
	TransactionTypeID =''T99'' and
	VoucherID ='''+@VoucherID+''' and
	AT9000.DivisionID ='''+@DivisionID+''' 	 '

print @sSQL1
print @sSQL2
If Not Exists (Select 1 From sysObjects Where Name ='AV3015')
	Exec ('Create view AV3015 as '+@sSQL1+@sSQL2)
Else
	Exec( 'Alter view AV3015 as '+@sSQL1+@sSQL2)