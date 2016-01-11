/****** Object:  StoredProcedure [dbo].[AP3412]    Script Date: 07/29/2010 13:18:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Create by: Dang Le Bao Quynh; Date 13/01/2009
--Purpose: Tinh nang hang ban tra lai nhieu nhom thue

/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[AP3412]  @DivisionID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@VoucherID nvarchar(50),
				@BatchID nvarchar(50),
				@TaxObjectID nvarchar(50),
				@TaxDebitAccountID nvarchar(50),
				@TaxCreditAccountID nvarchar(50),
				@TaxDescription nvarchar(250),
				@Type as int -- 1 Add, 2 Edit
AS
Declare 
		@cur as cursor,
		@VATGroupID as nvarchar(50),
		@TransactionID as nvarchar(50),
		@OriginalAmount as decimal(28,8),
		@ConvertedAmount as decimal(28,8)

If @Type = 2
Begin
	Delete AT9000 Where 	VoucherID = @VoucherID And 
				BatchID = @BatchID And
				TransactionTypeID = 'T34' AND DivisionID = @DivisionID
End

Set @cur = cursor static for
		Select VATGroupID, Sum(isnull(VATOriginalAmount,0)), Sum(isnull(VATConvertedAmount,0)) 
		From AT9000 
		Where 	VoucherID = @VoucherID And 
			BatchID = @BatchID And
			TransactionTypeID = 'T24' AND DivisionID = @DivisionID
		Group By VATGroupID
open @cur
Fetch Next From @cur Into @VATGroupID, @OriginalAmount, @ConvertedAmount
While @@Fetch_Status = 0
Begin
	Exec AP0000 @DivisionID, @TransactionID Output, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'
	Insert Into AT9000 
	(
		VoucherID, BatchID, TransactionID, TableID, 
		DivisionID, TranMonth, TranYear, TransactionTypeID, 
		CurrencyID, ObjectID, 
		VATNo, VATObjectID, VATObjectName, VATObjectAddress, 
		DebitAccountID, CreditAccountID, ExchangeRate, 
		OriginalAmount, ConvertedAmount,
		VoucherDate, InvoiceDate, VoucherTypeID, VATTypeID, 
		VATGroupID, VoucherNo, Serial, InvoiceNo, 
		EmployeeID, SenderReceiver, SRDivisionName, SRAddress,
		VDescription, BDescription, TDescription, 
		CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
		OriginalAmountCN, ExchangeRateCN, CurrencyIDCN, DueDays, PaymentID, DueDate, OrderID 
	)
	Select Top 1 
		VoucherID, BatchID, @TransactionID, 'AT9000', 
		DivisionID, TranMonth, TranYear, 'T34',
		CurrencyID, @TaxObjectID, 
		VATNo, VATObjectID, VATObjectName, VATObjectAddress, 
		@TaxDebitAccountID, @TaxCreditAccountID, ExchangeRate, 
		@OriginalAmount, @ConvertedAmount, 
		VoucherDate, InvoiceDate, VoucherTypeID, VATTypeID, 
		@VATGroupID, VoucherNo, Serial, InvoiceNo, 
		EmployeeID, SenderReceiver, SRDivisionName, SRAddress,
		VDescription, BDescription, @TaxDescription, 
		CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
		@OriginalAmount, ExchangeRateCN, CurrencyIDCN, DueDays, PaymentID, DueDate, OrderID 
	From AT9000 
	Where 	VoucherID = @VoucherID And 
		BatchID = @BatchID And
		TransactionTypeID = 'T24' AND DivisionID = @DivisionID

	Fetch Next From @cur Into @VATGroupID, @OriginalAmount, @ConvertedAmount
End