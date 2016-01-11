
/****** Object:  StoredProcedure [dbo].[AP1619]    Script Date: 07/28/2010 15:14:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1619]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1619]
GO

/****** Object:  StoredProcedure [dbo].[AP1619]    Script Date: 07/28/2010 15:14:22 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

------ Created by Nguyen Quoc Huy, Date 23/03/2007
------ Purpose Chuyen but tang nguyen gia sang  GL

/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP1619] @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@RevaluateIDList as nvarchar(50) 

AS

	Insert AT9000 	(VoucherID, BatchID, TransactionID, TableID, DivisionID, TranMonth, TranYear, 
		TransactionTypeID, CurrencyID, ObjectID, CreditObjectID, VATNo, VATObjectID, VATObjectName,
		VATObjectAddress, DebitAccountID, CreditAccountID, ExchangeRate, UnitPrice, OriginalAmount, 
		ConvertedAmount, ImTaxOriginalAmount, ImTaxConvertedAmount, ExpenseOriginalAmount, ExpenseConvertedAmount, 
		IsStock, VoucherDate, InvoiceDate, VoucherTypeID, VATTypeID, VATGroupID, VoucherNo, Serial, InvoiceNo, 
		Orders, EmployeeID, SenderReceiver, SRDivisionName, SRAddress, RefNo01, RefNo02, VDescription, BDescription, 
		TDescription, Quantity, InventoryID, UnitID, Status, IsAudit, IsCost, Ana01ID, Ana02ID, Ana03ID, PeriodID, 
		ExpenseID, MaterialTypeID, ProductID, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, OriginalAmountCN, 
		ExchangeRateCN, CurrencyIDCN, DueDays, PaymentID, DueDate, DiscountRate, OrderID, CreditBankAccountID, DebitBankAccountID, 
		CommissionPercent, InventoryName1)
	
	Select 	
		VoucherID, BatchID, TransactionID, TableID, DivisionID, TranMonth, TranYear, 
		TransactionTypeID, CurrencyID, ObjectID, CreditObjectID, VATNo, VATObjectID, VATObjectName,
		VATObjectAddress, DebitAccountID, CreditAccountID, ExchangeRate, UnitPrice, OriginalAmount, 
		ConvertedAmount, ImTaxOriginalAmount, ImTaxConvertedAmount, ExpenseOriginalAmount, ExpenseConvertedAmount, 
		IsStock, VoucherDate, InvoiceDate, VoucherTypeID, VATTypeID, VATGroupID, VoucherNo, Serial, InvoiceNo, 
		Orders, EmployeeID, SenderReceiver, SRDivisionName, SRAddress, RefNo01, RefNo02, VDescription, BDescription, 
		TDescription, Quantity, InventoryID, UnitID, Status, IsAudit, IsCost, Ana01ID, Ana02ID, Ana03ID, PeriodID, 
		ExpenseID, MaterialTypeID, ProductID, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, OriginalAmountCN, 
		ExchangeRateCN, CurrencyIDCN, DueDays, PaymentID, DueDate, DiscountRate, OrderID, CreditBankAccountID, DebitBankAccountID, 
		CommissionPercent, InventoryName1
		
	From AT1690
	Where DivisionID =@DivisionID and
		TranMonth = @TranMonth and
		TranYear =@TranYear and
		VoucherID =  @RevaluateIDList 



Update AT1690 Set  Status =1
Where TranMonth = @TranMonth and
	TranYear = @TranYear and
	DivisionID =@DivisionID and
	VoucherID= @RevaluateIDList


Update AT1606 Set Status = 1
Where RevaluateID= @RevaluateIDList
and DivisionID =@DivisionID
GO

