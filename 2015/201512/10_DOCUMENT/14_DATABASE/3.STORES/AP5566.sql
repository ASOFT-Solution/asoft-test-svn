IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP5566]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP5566]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--Purpose: trường hợp số tiền hoa hồng nhận được = 0 thì  revert lại toàn bộ các bút toán tổng hợp
--Customize theo khách hàng MVI
-- File import 02_Template_ReceiptEntry.xls
/********************************************
'* Created by: [GS] [Thanh Nguyen] [29/07/2010]
Modified on 26/07/2011 by Le Thi Thu Hien : Sua Ana05ID thanh RefNo02
Modified on 29/08/2011 by Le Thi Thu Hien : Sua INSERT ObjectID 
Modified on 29/09/2011 by Le Thi Thu Hien :
'********************************************/

CREATE PROCEDURE [dbo].[AP5566] 
	@DivisionID nvarchar(50), 
	@TranMonth int , 
	@TranYear int, 
	@EmployeeID nvarchar(50),
	@RefNo02 nvarchar(50), -- Transaction id file import
	@ObjectIDImport nvarchar(50)
AS

-- Biến cố định không có trong XML
DECLARE
	@VoucherTypeID NVARCHAR(50), 
	@TransactionTypeID NVARCHAR(50), 
	@DebitAccountID NVARCHAR(50), 
	@CreditAccountID NVARCHAR(50),
	@ObjectID nvarchar(50),
	@CreditObjectID NVARCHAR(50),
	@DebitObjectID NVARCHAR(50)
	
SET @VoucherTypeID = 'TH' -- Lấy theo AT1007STD
SET @TransactionTypeID = 'T99' -- Lấy theo AT1008STD
SET @CreditObjectID = ''
SET @DebitObjectID = ''

-- Biến để tạo mã tăng tự động
DECLARE
    @Enabled1 TINYINT,		@Enabled2 TINYINT,		@Enabled3 TINYINT, 
    @S1 NVARCHAR(100),		@S2 NVARCHAR(100),		@S3 NVARCHAR(100), 
    @S1Type TINYINT,		@S2Type TINYINT,		@S3Type TINYINT,
	@OutputLen TINYINT,		@OutputOrder TINYINT, 
	@Separated TINYINT,		@Separator NVARCHAR(10),
	@StringKey1 NVARCHAR(100), @StringKey2 NVARCHAR(100), @StringKey3 NVARCHAR(100)
	
SELECT	@Enabled1 = Enabled1, @Enabled2 = Enabled2, @Enabled3 = Enabled3, 
		@S1 = S1, @S2 = S2, @S3 = S3, @S1Type = S1Type, @S2Type = S2Type, @S3Type = S3Type,
		@OutputLen = OutputLength, @OutputOrder = OutputOrder, @Separated = Separated, @Separator = Separator
FROM	AT1007 
WHERE	VoucherTypeID = @VoucherTypeID AND DivisionID = @DivisionID

IF @Enabled1 = 1
	SET @StringKey1 = 
	    CASE @S1Type 
	    WHEN 1 THEN CASE WHEN @TranMonth < 10 THEN '0' + LTRIM(@TranMonth) ELSE LTRIM(@TranMonth) END
	    WHEN 2 THEN LTRIM(@TranYear)
	    WHEN 3 THEN @VoucherTypeID
	    WHEN 4 THEN @DivisionID
	    WHEN 5 THEN @S1
	    ELSE '' END
ELSE
	SET @StringKey1 = ''

IF @Enabled2 = 1
	SET @StringKey2 = 
	    CASE @S2Type 
	    WHEN 1 THEN CASE WHEN @TranMonth <10 THEN '0' + LTRIM(@TranMonth) ELSE LTRIM(@TranMonth) END
	    WHEN 2 THEN LTRIM(@TranYear)
	    WHEN 3 THEN @VoucherTypeID
	    WHEN 4 THEN @DivisionID
	    WHEN 5 THEN @S2
	    ELSE '' END
ELSE
	SET @StringKey2 = ''

IF @Enabled3 = 1
	SET @StringKey3 = 
	    CASE @S3Type 
	    WHEN 1 THEN CASE WHEN @TranMonth <10 THEN '0' + LTRIM(@TranMonth) ELSE LTRIM(@TranMonth) END
	    WHEN 2 THEN LTRIM(@TranYear)
	    WHEN 3 THEN @VoucherTypeID
	    WHEN 4 THEN @DivisionID
	    WHEN 5 THEN @S3
	    ELSE '' END
ELSE
	SET @StringKey3 = ''

-- Biến để lưu mã tăng tự động hoặc tính toán
DECLARE
    @VoucherNo NVARCHAR(100),
    @VoucherID NVARCHAR(100),
    @BatchID NVARCHAR(100),
    @TransactionID NVARCHAR(100),
    @VoucherDate DATETIME, 
	@InvoiceDate DATETIME, 
	@CurrencyID NVARCHAR(50),
    @ExchangeRate DECIMAL(28, 8),
    @ConvertedAmount DECIMAL(28, 8),
    @OriginalAmount DECIMAL(28, 8),
    @DueDays INT,
    @TDescription NVARCHAR(250),
    @OrderCur CURSOR
		
SET @OrderCur = cursor static for
SELECT	VoucherDate,InvoiceDate,CurrencyID, 
		ObjectID, ExchangeRate, 
		OriginalAmount, ConvertedAmount, 
		DueDays, TDescription
FROM	AT9000 
WHERE	RefNo02 = @RefNo02 AND DivisionID = @DivisionID

OPEN @OrderCur

Fetch Next From @OrderCur Into  @VoucherDate,@InvoiceDate,@CurrencyID
, @ObjectID,@ExchangeRate,@OriginalAmount,@ConvertedAmount, @DueDays, @TDescription
While @@Fetch_Status = 0
Begin
	
    -- Tạo mã tăng tự động
	EXEC AP0000 @DivisionID, @VoucherNo OUTPUT, 'AT9000', @StringKey1, @StringKey2, @StringKey3, @OutputLen, @OutputOrder, @Separated, @Separator
    EXEC AP0000 @DivisionID, @VoucherID OUTPUT, 'AT9000', 'AV', @TranYear, '', 16, 3, 0, '-'
    EXEC AP0000 @DivisionID, @BatchID OUTPUT, 'AT9000', 'AB', @TranYear, '', 16, 3, 0, '-'
	EXEC AP0000 @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'

	IF(ISNUMERIC (@ObjectID) = 0)
		BEGIN
			SET @DebitAccountID = '3387'
			SET @CreditAccountID = '1311'
			SET @DebitObjectID = @ObjectID
		END
	ELSE
		BEGIN
			SET @DebitAccountID = '3388'
			SET @CreditAccountID = '6411'
			SET @CreditObjectID = @ObjectID
		END
			
    INSERT INTO AT9000
    (
        DivisionID,
        VoucherID,
        BatchID,
        TransactionID,
        TableID,
        TranMonth,
        TranYear,
        TransactionTypeID,
        CurrencyID,
        ObjectID,
        CreditObjectID,
        DebitAccountID,
        CreditAccountID,
        ExchangeRate,
        OriginalAmount,
        ConvertedAmount,
        IsStock,        
        VoucherDate,  
        InvoiceDate,      
        VoucherTypeID,
        VoucherNo,        
        Orders,
        EmployeeID,        
        Status,
        IsAudit,
        IsCost,        
        CreateDate,
        CreateUserID,
        LastModifyDate,
        LastModifyUserID,        
        OriginalAmountCN,
        ExchangeRateCN,
        CurrencyIDCN,        
        DueDays,
        TDescription,
        RefNo02
    )
    VALUES
    (
        @DivisionID,
        @VoucherID,
        @BatchID,
        @TransactionID,
        'AT9000',
        @TranMonth,
        @TranYear,
        @TransactionTypeID,
        @CurrencyID,
        @DebitObjectID,
        @CreditObjectID,
        @DebitAccountID,
        @CreditAccountID,
        @ExchangeRate,
        @OriginalAmount,
        @ConvertedAmount,
        0,
        @VoucherDate,
        @InvoiceDate,
        @VoucherTypeID,
        @VoucherNo,
        1,
        @EmployeeID,
        0,
        0,
        0,
        GETDATE(),
        @EmployeeID,
        GETDATE(),
        @EmployeeID,
        @OriginalAmount,
        @ExchangeRate,
        @CurrencyID,
        @DueDays,
        @TDescription,
        @RefNo02
    )
    
	Fetch Next From @OrderCur Into @VoucherDate,@InvoiceDate,@CurrencyID
	, @ObjectID,@ExchangeRate,@OriginalAmount,@ConvertedAmount, @DueDays, @TDescription
End
		
Close @OrderCur

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

