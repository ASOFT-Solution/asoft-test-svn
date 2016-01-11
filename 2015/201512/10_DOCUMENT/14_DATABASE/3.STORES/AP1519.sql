
/****** Object:  StoredProcedure [dbo].[AP1519]    Script Date: 07/29/2010 11:17:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



------ Created by Nguyen Quoc Huy, Date 23/03/2007
------ Purpose Chuyen but tang nguyen gia sang  GL

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1519] 
				@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@RevaluateIDList as nvarchar(800) 

AS

	Insert AT9000 (VoucherID, BatchID, TransactionID, TableID, DivisionID, TranMonth, TranYear, 
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
		
	From AT1590
	Where DivisionID = @DivisionID 
		and	TranMonth = @TranMonth 
		and	TranYear =@TranYear 
		and	VoucherID =  @RevaluateIDList 

Update AT1590 Set Status = 1
Where TranMonth = @TranMonth 
	and	TranYear = @TranYear 
	and	DivisionID =@DivisionID 
	and	VoucherID= @RevaluateIDList

Update AT1506 Set Status = 1
Where RevaluateID= @RevaluateIDList
and	DivisionID = @DivisionID 