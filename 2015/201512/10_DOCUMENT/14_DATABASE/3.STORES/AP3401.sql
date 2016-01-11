/****** Object: StoredProcedure [dbo].[AP3401] Script Date: 07/29/2010 13:12:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Create BY: Dang Le Bao Quynh; Date 10/12/2008
--Purpose: Tinh nang mua hang nhieu nhom thue
/***************************************************************
'* Edited BY : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[AP3401] 
    @DivisionID NVARCHAR(50),
    @TranMonth INT,
    @TranYear INT,
    @VoucherID NVARCHAR(50),
    @BatchID NVARCHAR(50),
    @TaxObjectID NVARCHAR(50),
    @TaxDebitAccountID NVARCHAR(50),
    @TaxCreditAccountID NVARCHAR(50),
    @TaxDescription NVARCHAR(250),
    @Type AS INT -- 1 Add, 2 Edit
AS

DECLARE 
@cur AS CURSOR,
    @VATGroupID AS NVARCHAR(50),
    @TransactionID AS NVARCHAR(50),
    @OriginalAmount AS DECIMAL(28,8),
    @ConvertedAmount AS DECIMAL(28,8)

IF @Type = 2
    BEGIN
        DELETE AT9000 
        WHERE VoucherID = @VoucherID 
            AND BatchID = @BatchID 
            AND TransactionTypeID = 'T13'
            AND DivisionID = @DivisionID 
    END

SET @cur = CURSOR STATIC FOR
SELECT VATGroupID, SUM(ISNULL(VATOriginalAmount,0)), SUM(ISNULL(VATConvertedAmount,0)) 
FROM AT9000 
WHERE VoucherID = @VoucherID 
    AND BatchID = @BatchID 
    AND TransactionTypeID = 'T03'
    AND DivisionID = @DivisionID 
GROUP BY VATGroupID

OPEN @cur
FETCH NEXT FROM @cur INTO @VATGroupID, @OriginalAmount, @ConvertedAmount
WHILE @@Fetch_Status = 0
    BEGIN
        EXEC AP0000 @DivisionID, @TransactionID Output, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'
        WHILE EXISTS(SELECT TOP 1 1 FROM AT9000 WHERE TransactionID = @TransactionID AND DivisionID = @DivisionID)
            EXEC AP0000 @DivisionID, @TransactionID Output, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'
        
        INSERT INTO AT9000 
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
        OriginalAmountCN, ExchangeRateCN, CurrencyIDCN, DueDays, PaymentID, DueDate, OrderID,
        InvoiceCode,InvoiceSign
        )
        SELECT TOP 1 
        VoucherID, BatchID, @TransactionID, 'AT9000', 
        DivisionID, TranMonth, TranYear, 'T13',
        CurrencyID, @TaxObjectID, 
        VATNo, VATObjectID, VATObjectName, VATObjectAddress, 
        @TaxDebitAccountID, @TaxCreditAccountID, ExchangeRate, 
        @OriginalAmount, @ConvertedAmount, 
        VoucherDate, InvoiceDate, VoucherTypeID, VATTypeID, 
        @VATGroupID, VoucherNo, Serial, InvoiceNo, 
        EmployeeID, SenderReceiver, SRDivisionName, SRAddress,
        VDescription, BDescription, @TaxDescription, 
        CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
        @OriginalAmount, ExchangeRateCN, CurrencyIDCN, DueDays, PaymentID, DueDate, OrderID,
        InvoiceCode,InvoiceSign
        FROM AT9000 
        WHERE VoucherID = @VoucherID 
            AND BatchID = @BatchID 
            AND TransactionTypeID = 'T03'
            AND DivisionID = @DivisionID 

        FETCH NEXT FROM @cur INTO @VATGroupID, @OriginalAmount, @ConvertedAmount
    END