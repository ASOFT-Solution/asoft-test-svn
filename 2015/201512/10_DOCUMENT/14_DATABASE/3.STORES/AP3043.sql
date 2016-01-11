/****** Object:  StoredProcedure [dbo].[AP3043]    Script Date: 07/29/2010 10:22:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
----- In phieu thu qua ngan hang
----- Created by Nguyen Thi Ngoc Minh, Date 24/09/2004
----- Edited by Nguyen Quoc Huy, Date 04/06/2007
----- Edited by Dang Le Bao Quynh, Date 14/11/2008
----- Purpose: Bo sung dia chi doi tuong

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3043] @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50)
	
 AS
Declare @sSQL as nvarchar(4000),
	@AT9000Cursor as cursor,
	@InvoiceNo as nvarchar(50),
	@Serial as nvarchar(50),
	@InvoiceNoList as nvarchar(500),
	@DebitAccountList as nvarchar(500),
	@DebitAccountID  as nvarchar(50),
	@CreditAccountList as nvarchar(500),
	@CreditAccountID  as nvarchar(50),
	@DebitBankAccountID as nvarchar(50)

SET @InvoiceNoList =''
SET @AT9000Cursor = CURSOR SCROLL KEYSET FOR
Select Distinct isnull(Serial,'') , isnull(InvoiceNo,'') From AT9000 Where VoucherID =@VoucherID and DivisionID =@DivisionID and TransactionTypeID ='T21'
OPEN @AT9000Cursor
		FETCH NEXT FROM @AT9000Cursor INTO @Serial , @InvoiceNo
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @InvoiceNoList<>''
				Set @InvoiceNoList = @InvoiceNoList + @Serial + @InvoiceNo
			Else
				Set @InvoiceNoList =@Serial + @InvoiceNo
			
			FETCH NEXT FROM @AT9000Cursor INTO @Serial, @InvoiceNo
		END

CLOSE @AT9000Cursor

SET @CreditAccountList =''
SET @AT9000Cursor = CURSOR SCROLL KEYSET FOR
Select Distinct CreditAccountID From AT9000 Where VoucherID =@VoucherID and DivisionID =@DivisionID and TransactionTypeID ='T21'
OPEN @AT9000Cursor
		FETCH NEXT FROM @AT9000Cursor INTO @CreditAccountID
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @CreditAccountList <>''
				Set @CreditAccountList = @CreditAccountList+'; '+@CreditAccountID
			Else
				Set @CreditAccountList  = @CreditAccountID

			FETCH NEXT FROM @AT9000Cursor INTO @CreditAccountID
		END

CLOSE @AT9000Cursor

--print @InvoiceNoList

If @InvoiceNoList<>'' 
	Set @InvoiceNoList =' Keøm theo: '+@InvoiceNoList+' laøm chöùng töø goác'
Set @sSQL ='
Select 	VoucherID, AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear, 
	VoucherTypeID, VoucherNo, VoucherDate,
	VDescription,
	'''+isnull(@InvoiceNoList,'')+''' as InvoiceNoList,
	'''+isnull(@CreditAccountList,'') +''' as CreditAccountID,
	DebitAccountID as AccountID, 
	AT9000.CurrencyID, ExchangeRate,
	SenderReceiver, SRDivisionName, SRAddress,
	RefNo01, RefNo02, DebitBankAccountID, AT1016.BankName, AT1016.BankAccountNo,
	AT1101.Address as DivisionAddress,
	Sum(ConvertedAmount) as ConvertedAmount,
	Sum(OriginalAmount) as OriginalAmount,
	Case When AT1202.IsUpdateName = 1 Then VATObjectAddress Else AT1202.Address End As ObjectAddress
	
From AT9000 
	Left join AT1202 on AT1202.DivisionID = AT9000.DivisionID AND AT9000.ObjectID = AT1202.ObjectID
	Left join AT1016 on AT1016.DivisionID = AT9000.DivisionID AND AT1016.BankAccountID = AT9000.DebitBankAccountID
	Left join AT1101 on AT1101.DivisionID = AT9000.DivisionID AND AT1101.DivisionID = AT9000.DivisionID

Where TransactionTypeID =''T21'' and
	AT9000.DivisionID = '''+@DivisionID+''' and
	VoucherID ='''+@VoucherID+''' 
Group by VoucherID, AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear, 
	VoucherTypeID, VoucherNo, VoucherDate, DebitBankAccountID,
	AT1016.BankName, AT1016.BankAccountNo, VDescription, DebitAccountID, 
	AT9000.CurrencyID, ExchangeRate,
	SenderReceiver, SRDivisionName, SRAddress, RefNo01, RefNo02,
	AT1101.Address,
	Case When AT1202.IsUpdateName = 1 Then VATObjectAddress Else AT1202.Address End'


If Not Exists (Select 1 From sysObjects Where Name ='AV3043')
	Exec ('Create view AV3043 as '+@sSQL)
Else
	Exec( 'Alter view AV3043 as '+@sSQL)
