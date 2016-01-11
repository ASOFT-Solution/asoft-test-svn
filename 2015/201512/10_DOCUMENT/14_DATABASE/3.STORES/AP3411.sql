IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3411]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3411]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Create by: Dang Le Bao Quynh; Date 10/12/2008
--Purpose: Tinh nang ban hang nhieu nhom thue
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/
---- Modified on 01/07/2014 by Lê Thi Thu Hien : Bổ sung thêm 1 số trường

CREATE PROCEDURE [dbo].[AP3411]  
				@DivisionID nvarchar(50),
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
		@ConvertedAmount as decimal(28,8),
		@ReTableID AS NVARCHAR(50),
		@ReVoucherID AS NVARCHAR(50)

If @Type = 2
Begin
	Delete AT9000 Where 	VoucherID = @VoucherID And 
				BatchID = @BatchID And
				TransactionTypeID = 'T14' AND DivisionID = @DivisionID
End

Set @cur = cursor static for
		Select VATGroupID, Sum(isnull(VATOriginalAmount,0)), Sum(isnull(VATConvertedAmount,0)) 
		From AT9000 
		Where 	VoucherID = @VoucherID And 
			BatchID = @BatchID And
			TransactionTypeID = 'T04'
			And DivisionID in (Select DivisionID From GetDivisionID(@DivisionID))
		Group By VATGroupID
open @cur
Fetch Next From @cur Into @VATGroupID, @OriginalAmount, @ConvertedAmount
While @@Fetch_Status = 0
Begin
	Exec AP0000 @DivisionID, @TransactionID Output, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'
	while(exists(select top 1 1 from AT9000 where TransactionID = @TransactionID and DivisionID = @DivisionID))
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
		OriginalAmountCN, ExchangeRateCN, CurrencyIDCN, DueDays, PaymentID, DueDate, OrderID ,
		ReVoucherID, ReTableID, IsStock
	)
	Select Top 1 
		VoucherID, BatchID, @TransactionID, 'AT9000', 
		DivisionID, TranMonth, TranYear, 'T14',
		CurrencyID, @TaxObjectID, 
		VATNo, VATObjectID, VATObjectName, VATObjectAddress, 
		@TaxDebitAccountID, @TaxCreditAccountID, ExchangeRate, 
		@OriginalAmount, @ConvertedAmount, 
		VoucherDate, InvoiceDate, VoucherTypeID, VATTypeID, 
		@VATGroupID, VoucherNo, Serial, InvoiceNo, 
		EmployeeID, SenderReceiver, SRDivisionName, SRAddress,
		VDescription, BDescription, @TaxDescription, 
		CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
		@OriginalAmount, ExchangeRateCN, CurrencyIDCN, DueDays, PaymentID, DueDate, OrderID ,
		ReVoucherID, ReTableID, IsStock
	From AT9000 
	Where 	VoucherID = @VoucherID And 
		BatchID = @BatchID And
		TransactionTypeID = 'T04'
		And DivisionID in (Select DivisionID From GetDivisionID(@DivisionID))

	Fetch Next From @cur Into @VATGroupID, @OriginalAmount, @ConvertedAmount
End

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

