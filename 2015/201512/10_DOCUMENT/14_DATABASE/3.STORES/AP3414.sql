/****** Object: StoredProcedure [dbo].[AP3414] Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--Create BY: Dang Le Bao Quynh; Date 13/01/2009
--Purpose: Tinh nang hang ban tra lai nhieu nhom thue
/***************************************************************
'* Edited BY : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[AP3414] 
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
            AND TransactionTypeID = 'T35'
            AND DivisionID = @DivisionID
    END

SET @cur = CURSOR STATIC FOR
SELECT VATGroupID, SUM(ISNULL(VATOriginalAmount,0)), SUM(ISNULL(VATConvertedAmount,0)) 
FROM AT9000 
WHERE VoucherID = @VoucherID 
    AND BatchID = @BatchID 
    AND TransactionTypeID = 'T25'
    AND DivisionID = @DivisionID
GROUP BY VATGroupID

OPEN @cur
FETCH NEXT FROM @cur INTO @VATGroupID, @OriginalAmount, @ConvertedAmount
WHILE @@Fetch_Status = 0
    BEGIN
        EXEC AP0000 @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'
        
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
        OriginalAmountCN, ExchangeRateCN, CurrencyIDCN, DueDays, PaymentID, DueDate, OrderID 
        )
        SELECT TOP 1 
        VoucherID, BatchID, @TransactionID, 'AT9000', 
        DivisionID, TranMonth, TranYear, 'T35',
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
        FROM AT9000 
        WHERE VoucherID = @VoucherID 
            AND BatchID = @BatchID 
            AND TransactionTypeID = 'T25'
            AND DivisionID = @DivisionID

        FETCH NEXT FROM @cur INTO @VATGroupID, @OriginalAmount, @ConvertedAmount
    END
GO
