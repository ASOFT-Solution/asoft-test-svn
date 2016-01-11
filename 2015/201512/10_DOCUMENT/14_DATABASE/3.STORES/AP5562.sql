IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP5562]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP5562]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Purpose: Import danh sách bút toán tổng hợp về thông tin hoa hồng của công ty nhận từ chủ đầu tư
--Customize theo khách hàng MVI
-- File import 01_Template_BillingInfo.xls
/********************************************
'* Created by: [GS] [Thanh Nguyen] [29/07/2010]
Modified on 26/07/2011 by Le Thi Thu Hien : Sua Ana05ID thanh RefNo02
Modified on 29/07/2011 by Le Thi Thu Hien : Sua Commission thanh Commission + Commission*VAT10
Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh
'********************************************/

CREATE PROCEDURE [dbo].[AP5562] 
    @xml XML, 
    @DivisionID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT, 
    @EmployeeID NVARCHAR(50)
AS

SET NOCOUNT ON 

DECLARE 
    @sql NVARCHAR(4000)

-- Nếu không có dữ liệu XML thì không xử lý tiếp
IF @xml IS NULL GOTO Exist

-- Tạo bảng tạm trên RAM
DECLARE @AT5561 table 
(
	[TransactionID] NVARCHAR(50), 
	[ObjectID] NVARCHAR(50), 
	[TranDate] DATETIME, 
	[DueDate] DATETIME, 
	[CurrencyID] NVARCHAR(50), 
	[ExchangeRate] DECIMAL(28, 8), 
	[Commission] DECIMAL(28, 8)
);
		
SET ARITHABORT ON

-- Lấy dữ liệu từ XML đưa vào bảng tạm 
INSERT INTO @AT5561 (TransactionID, ObjectID, TranDate, DueDate, CurrencyID, ExchangeRate, Commission)
SELECT 
    X.AT5561.query('TransactionID').value('.', 'NVARCHAR(50)') AS TransactionID, 
    X.AT5561.query('ObjectID').value('.', 'NVARCHAR(50)') AS ObjectID, 
    X.AT5561.query('TranDate').value('.', 'DATETIME') AS TranDate, 
    X.AT5561.query('DueDate').value('.', 'DATETIME') AS DueDate, 
    X.AT5561.query('CurrencyID').value('.', 'NVARCHAR(50)') AS CurrencyID, 
    X.AT5561.query('ExchangeRate').value('.', 'DECIMAL(28, 8)') AS ExchangeRate, 
    X.AT5561.query('Commission').value('.', 'DECIMAL(28, 8)') AS Commission	  
FROM @xml.nodes('//AT5561') AS X(AT5561)
		
SET ARITHABORT OFF

-- Nếu không có dữ liệu thì không xử lý tiếp
IF(SELECT COUNT(*) FROM @AT5561) = 0 GOTO Exist

-- Biến cố định không có trong XML
DECLARE
	@VoucherTypeID NVARCHAR(50), 
	@TransactionTypeID NVARCHAR(50), 
	@DebitAccountID NVARCHAR(50), 
	@CreditAccountID NVARCHAR(50)
	
SET @VoucherTypeID = 'TH' -- Lấy theo AT1007STD
SET @TransactionTypeID = 'T99' -- Lấy theo AT1008STD
SET @DebitAccountID = '1311'
SET @CreditAccountID = '3387'

-- Biến để làm tròn
DECLARE
	@QuantityDecimals TINYINT,
	@UnitCostDecimals TINYINT, 
	@ConvertedDecimals TINYINT

SELECT 
    @QuantityDecimals = ISNULL(QuantityDecimals, 5), 
    @UnitCostDecimals = ISNULL(UnitCostDecimals, 5), 
    @ConvertedDecimals = ISNULL(ConvertedDecimals, 5)
FROM AT1101 WHERE DivisionID = @DivisionID

-- Biến để tạo mã tăng tự động
DECLARE
    @Enabled1 TINYINT, @Enabled2 TINYINT, @Enabled3 TINYINT, 
    @S1 NVARCHAR(100), @S2 NVARCHAR(100), @S3 NVARCHAR(100), @S1Type TINYINT, @S2Type TINYINT, @S3Type TINYINT,
	@OutputLen TINYINT, @OutputOrder TINYINT, @Separated TINYINT, @Separator NVARCHAR(10),
	@StringKey1 NVARCHAR(100), @StringKey2 NVARCHAR(100), @StringKey3 NVARCHAR(100)
	
SELECT 
    @Enabled1 = Enabled1, @Enabled2 = Enabled2, @Enabled3 = Enabled3, 
    @S1 = S1, @S2 = S2, @S3 = S3, @S1Type = S1Type, @S2Type = S2Type, @S3Type = S3Type,
	@OutputLen = OutputLength, @OutputOrder = OutputOrder, @Separated = Separated, @Separator = Separator
FROM AT1007 WHERE VoucherTypeID = @VoucherTypeID AND DivisionID = @DivisionID

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

-- Biến để lấy dữ liệu từ bảng tạm
DECLARE
	@RefNo02 NVARCHAR(50), 
	@ObjectID NVARCHAR(50), 
	@TranDate DATETIME, 
	@DueDate DATETIME, 
	@CurrencyID NVARCHAR(50), 
	@ExchangeRate DECIMAL(28, 8), 
	@Commission DECIMAL(28, 8)

-- Biến để lưu mã tăng tự động hoặc tính toán
DECLARE
    @VoucherNo NVARCHAR(100),
    @VoucherID NVARCHAR(100),
    @BatchID NVARCHAR(100),
    @TransactionID NVARCHAR(100),
    @ConvertedAmount DECIMAL(28, 8),
    @DueDays INT,
	@AT5561Cursor CURSOR
	
SET @AT5561Cursor = CURSOR STATIC FOR
SELECT TransactionID, ObjectID, TranDate, DueDate, CurrencyID, ExchangeRate, Commission 
FROM @AT5561 

OPEN @AT5561Cursor
FETCH NEXT FROM @AT5561Cursor INTO @RefNo02, @ObjectID, @TranDate, @DueDate, @CurrencyID, @ExchangeRate, @Commission

While @@Fetch_Status = 0
BEGIN
    -- Kiểm tra nếu đã có dữ liệu với RefNo02 giống dư liệu cần import thì bỏ qua
    IF EXISTS(SELECT TOP 1 RefNo02 FROM AT9000 WHERE RefNo02 = @RefNo02 AND DivisionID = @DivisionID) GOTO NextRecord

    -- Tạo mã tăng tự động
	EXEC AP0000 @DivisionID, @VoucherNo OUTPUT, 'AT9000', @StringKey1, @StringKey2, @StringKey3, @OutputLen, @OutputOrder, @Separated, @Separator
    EXEC AP0000 @DivisionID, @VoucherID OUTPUT, 'AT9000', 'AV', @TranYear, '', 16, 3, 0, '-'
    EXEC AP0000 @DivisionID, @BatchID OUTPUT, 'AT9000', 'AB', @TranYear, '', 16, 3, 0, '-'
	EXEC AP0000 @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'
	
	SET @Commission = @Commission + @Commission * 10/100
	-- Làm tròn
    SET @ExchangeRate = ROUND(@ExchangeRate, @ConvertedDecimals)
    SET @Commission = ROUND(@Commission, @ConvertedDecimals)
    SET @ConvertedAmount = ROUND(@Commission * @ExchangeRate, @ConvertedDecimals)
    SET @DueDays = DATEDIFF(d, @TranDate, @DueDate)
	
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
        @ObjectID,
        @DebitAccountID,
        @CreditAccountID,
        @ExchangeRate,
        @Commission,
        @ConvertedAmount,
        0,
        @TranDate,
        @TranDate,
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
        @Commission,
        @ExchangeRate,
        @CurrencyID,
        @DueDays,
        @RefNo02
    )

    NextRecord:
    FETCH NEXT FROM @AT5561Cursor INTO @RefNo02, @ObjectID, @TranDate, @DueDate, @CurrencyID, @ExchangeRate, @Commission
END

Exist:

SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

