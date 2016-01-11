IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0258]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0258]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- In phiếu tạm thu qua ngân hàng
-- Created by Trần Lê Thiên Huỳnh on 17/08/2012
-- EXEC AP0258 'AS', 7, 2012, 'AV20120000000018'

CREATE PROCEDURE [dbo].[AP0258] @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50)
	
 AS
Declare @sSQL as nvarchar(4000),
	@AT9010Cursor as cursor,
	@InvoiceNo as nvarchar(50),
	@Serial as nvarchar(50),
	@InvoiceNoList as nvarchar(500),
	@DebitAccountList as nvarchar(500),
	@DebitAccountID  as nvarchar(50),
	@CreditAccountList as nvarchar(500),
	@CreditAccountID  as nvarchar(50),
	@DebitBankAccountID as nvarchar(50)

SET @InvoiceNoList = ''
SET @AT9010Cursor = CURSOR SCROLL KEYSET FOR

Select Distinct isnull(Serial,'') , isnull(InvoiceNo,'') From AT9010 
Where VoucherID =@VoucherID and DivisionID =@DivisionID and TransactionTypeID ='T21'

OPEN @AT9010Cursor
		FETCH NEXT FROM @AT9010Cursor INTO @Serial , @InvoiceNo
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @InvoiceNoList<>''
				Set @InvoiceNoList = @InvoiceNoList + @Serial + @InvoiceNo
			Else
				Set @InvoiceNoList =@Serial + @InvoiceNo
			
			FETCH NEXT FROM @AT9010Cursor INTO @Serial, @InvoiceNo
		END

CLOSE @AT9010Cursor

SET @CreditAccountList = ''
SET @AT9010Cursor = CURSOR SCROLL KEYSET FOR

Select Distinct CreditAccountID From AT9010 
Where VoucherID =@VoucherID and DivisionID =@DivisionID and TransactionTypeID ='T21'

OPEN @AT9010Cursor
		FETCH NEXT FROM @AT9010Cursor INTO @CreditAccountID
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @CreditAccountList <>''
				Set @CreditAccountList = @CreditAccountList+'; '+@CreditAccountID
			Else
				Set @CreditAccountList  = @CreditAccountID

			FETCH NEXT FROM @AT9010Cursor INTO @CreditAccountID
		END

CLOSE @AT9010Cursor

If @InvoiceNoList<>'' 
	Set @InvoiceNoList =' Keøm theo: '+@InvoiceNoList+' laøm chöùng töø goác'
Set @sSQL ='
Select 	VoucherID, AT9010.DivisionID, AT9010.TranMonth, AT9010.TranYear, 
	VoucherTypeID, VoucherNo, VoucherDate,
	VDescription,
	'''+isnull(@InvoiceNoList,'')+''' as InvoiceNoList,
	'''+isnull(@CreditAccountList,'') +''' as CreditAccountID,
	DebitAccountID as AccountID, 
	AT9010.CurrencyID, ExchangeRate,
	SenderReceiver, SRDivisionName, SRAddress,
	RefNo01, RefNo02, DebitBankAccountID, AT1016.BankName, AT1016.BankAccountNo,
	AT1101.Address as DivisionAddress,
	Sum(ConvertedAmount) as ConvertedAmount,
	Sum(OriginalAmount) as OriginalAmount,
	Case When AT1202.IsUpdateName = 1 Then VATObjectAddress Else AT1202.Address End As ObjectAddress
	
From AT9010 
	Left join AT1202 on AT1202.DivisionID = AT9010.DivisionID AND AT9010.ObjectID = AT1202.ObjectID
	Left join AT1016 on AT1016.DivisionID = AT9010.DivisionID AND AT1016.BankAccountID = AT9010.DebitBankAccountID
	Left join AT1101 on AT1101.DivisionID = AT9010.DivisionID AND AT1101.DivisionID = AT9010.DivisionID

Where TransactionTypeID =''T21'' and
	AT9010.DivisionID = '''+@DivisionID+''' and
	VoucherID ='''+@VoucherID+''' 
Group by VoucherID, AT9010.DivisionID, AT9010.TranMonth, AT9010.TranYear, 
	VoucherTypeID, VoucherNo, VoucherDate, DebitBankAccountID,
	AT1016.BankName, AT1016.BankAccountNo, VDescription, DebitAccountID, 
	AT9010.CurrencyID, ExchangeRate,
	SenderReceiver, SRDivisionName, SRAddress, RefNo01, RefNo02,
	AT1101.Address,
	Case When AT1202.IsUpdateName = 1 Then VATObjectAddress Else AT1202.Address End'

Print (@sSQL)
EXEC(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

