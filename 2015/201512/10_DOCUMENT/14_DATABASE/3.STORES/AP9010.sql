/****** Object:  StoredProcedure [dbo].[AP9010]    Script Date: 07/29/2010 14:04:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--- Created by Van Nhan, Sunterday,  19/07/2009. Duyet cac phieu t?m thu - chi

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/
--- Edited by Bao Anh	Date: 17/09/2012
--- Purpose: Customize cho Toan Thang (khi duyet tam chi khong insert vao AT9000)
--- Modify on 11/12/2013 by Bao Anh: Neu là Toan Thang hoac Sinolife thi khi duyet khong insert vao AT9000
--- Modified on 25/03/2015 by Lê Thị Hạnh: Bổ sung nếu check IsInsertPayable = 1 thì lưu vào AT9000, bổ sung Ana06-10ID

ALTER PROCEDURE [dbo].[AP9010] 
		@DivisionID as nvarchar(50), 
		@VoucherID as nvarchar(50), 
		@TransactionTypeID as nvarchar(50)
 AS

Declare @Cursor as cursor,
		@CustomerName INT,
		@ReVoucherID NVARCHAR(50)
SET @ReVoucherID = NULL
		
--Tao bang tam de lay thong tin khach hang
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

IF (@CustomerName <> 5 and @CustomerName <> 20  and @CustomerName <> 23) AND
	EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND ISNULL(IsInsertPayable,0) = 1 )
BEGIN
	Insert AT9000 (VoucherID, BatchID, TransactionID, 
		TableID, DivisionID, TranMonth, TranYear, TransactionTypeID, 
		CurrencyID, ObjectID, CreditObjectID, VATNo, VATObjectID, VATObjectName, 
		VATObjectAddress, DebitAccountID, CreditAccountID, ExchangeRate, UnitPrice, OriginalAmount, ConvertedAmount, 
		ImTaxOriginalAmount, ImTaxConvertedAmount, ExpenseOriginalAmount, ExpenseConvertedAmount, IsStock, VoucherDate, 
		InvoiceDate, VoucherTypeID, VATTypeID, VATGroupID, VoucherNo, Serial, InvoiceNo, Orders, EmployeeID, SenderReceiver, 
		SRDivisionName, SRAddress, RefNo01, RefNo02, VDescription, BDescription, TDescription, Quantity, InventoryID, 
		UnitID, Status, IsAudit, IsCost, Ana01ID, Ana02ID, Ana03ID, PeriodID, ExpenseID, MaterialTypeID, ProductID, CreateDate, 
		CreateUserID, LastModifyDate, LastModifyUserID, OriginalAmountCN, ExchangeRateCN, CurrencyIDCN, DueDays, PaymentID, DueDate, DiscountRate, OrderID, CreditBankAccountID, 
		DebitBankAccountID, CommissionPercent, InventoryName1, Ana04ID, Ana05ID, PaymentTermID, DiscountAmount, 
		OTransactionID, IsMultiTax, VATOriginalAmount, VATConvertedAmount, ReVoucherID, Ana06ID,Ana07ID,Ana08ID,Ana09ID,Ana10ID)
	Select VoucherID, BatchID, TransactionID, 
		TableID, DivisionID, TranMonth, TranYear, TransactionTypeID, 
		CurrencyID, ObjectID, CreditObjectID, VATNo, VATObjectID, VATObjectName, 
		VATObjectAddress, DebitAccountID, CreditAccountID, ExchangeRate, UnitPrice, OriginalAmount, ConvertedAmount, 
		ImTaxOriginalAmount, ImTaxConvertedAmount, ExpenseOriginalAmount, ExpenseConvertedAmount, IsStock, VoucherDate, 
		InvoiceDate, VoucherTypeID, VATTypeID, VATGroupID, VoucherNo, Serial, InvoiceNo, Orders, EmployeeID, SenderReceiver, 
		SRDivisionName, SRAddress, RefNo01, RefNo02, VDescription, BDescription, TDescription, Quantity, InventoryID, 
		UnitID, Status, IsAudit, IsCost, Ana01ID, Ana02ID, Ana03ID, PeriodID, ExpenseID, MaterialTypeID, ProductID, CreateDate, 
		CreateUserID, LastModifyDate, LastModifyUserID, OriginalAmountCN, ExchangeRateCN, CurrencyIDCN, DueDays, PaymentID, DueDate, DiscountRate, OrderID, CreditBankAccountID, 
		DebitBankAccountID, CommissionPercent, InventoryName1, Ana04ID, Ana05ID, PaymentTermID, DiscountAmount, 
		OTransactionID, IsMultiTax, VATOriginalAmount, VATConvertedAmount, ReVoucherID,Ana06ID,Ana07ID,Ana08ID,Ana09ID,Ana10ID
	From AT9010
	Where DivisionID =@DivisionID and VoucherID=@VoucherID and TransactionTypeID=@TransactionTypeID and Status =0
	SET @ReVoucherID = @VoucherID
END

Set nocount on

Update AT9010 set Status =1, ReVoucherID = @ReVoucherID
Where DivisionID =@DivisionID and VoucherID=@VoucherID and TransactionTypeID=@TransactionTypeID and Status =0
Set nocount off
