IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP5570]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP5570]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Import Salary
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 04/08/2011 by Le Thi Thu Hien
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh
-- <Example>
----

CREATE PROCEDURE [dbo].[AP5570] 
	@xml XML,
	@DivisionID nvarchar(50), 
	@TranMonth int , 
	@TranYear int, 
	@EmployeeID nvarchar(50),
	@Serial NVARCHAR(50)
AS

DECLARE @sql nvarchar(4000)

IF NOT @xml IS NULL
BEGIN
	DECLARE @AT5569 table 
	(
		ReVoucherID NVARCHAR(50),
		TransactionID nvarchar(50),
		ObjectID nvarchar(50),
		AgentStatus nvarchar(50),
		TranDate DateTime,
		CurrencyID nvarchar(50),
		ExchangeRate decimal(28,8),
		Amount decimal(28,8),
		BankAccountNo nvarchar(50),
		TranNotes nvarchar(250),
		InvoiceAmount decimal(28,8),		
		EndAmount DECIMAL(28,8)
	);
		
	SET ARITHABORT ON

	INSERT INTO @AT5569 (ReVoucherID, TransactionID,ObjectID,AgentStatus,TranDate,
						CurrencyID,ExchangeRate,Amount,BankAccountNo,TranNotes,InvoiceAmount, EndAmount)	
	select distinct *
	from (
	Select 	X.AT5569.query('ReVoucherID').value('.','nvarchar(50)') AS ReVoucherID
		  ,	X.AT5569.query('TransactionID').value('.','nvarchar(50)') AS TransactionID
		  , X.AT5569.query('ObjectID').value('.','nvarchar(50)') AS ObjectID
		  , X.AT5569.query('AgentStatus').value('.','nvarchar(50)') AS AgentStatus
		  , X.AT5569.query('TranDate').value('.','datetime') AS TranDate
		  , X.AT5569.query('CurrencyID').value('.','nvarchar(50)') AS CurrencyID
		  , X.AT5569.query('ExchangeRate').value('.','decimal(28,8)') AS ExchangeRate
		  , X.AT5569.query('Amount').value('.','decimal(28,8)') AS Amount
		  , X.AT5569.query('BankAccountNo').value('.','nvarchar(50)') AS BankAccountNo
		  , X.AT5569.query('TranNotes').value('.','nvarchar(250)') AS TranNotes
		  , X.AT5569.query('InvoiceAmount').value('.','decimal(28,8)') AS InvoiceAmount
		  , X.AT5569.query('EndAmount').value('.','decimal(28,8)') AS EndAmount
		  
	From @xml.nodes('//AT5569') AS X(AT5569)
	) AS XX
	
	SET ARITHABORT OFF

	-- Nếu không có dữ liệu thì không xử lý tiếp
	IF(SELECT COUNT(*) FROM @AT5569) = 0 GOTO Exist

-- Biến cố định không có trong XML
	

DECLARE	@TransactionID nvarchar(50),
		@RefNo02 nvarchar(50), ---TransactionID ben MVI
		@ObjectID nvarchar(50),
		@AgentStatus nvarchar(50),
		@TranDate DateTime,
		@CurrencyID nvarchar(50),
		@ExchangeRate decimal(28,8),
		@Amount decimal(28,8),
		@BankAccountNo nvarchar(50),
		@TranNotes nvarchar(250),
		@InvoiceAmount DECIMAL(28,8),
		@EndAmount DECIMAL(28,8)

DECLARE 	
	@VoucherTypeIDT99 nvarchar(50), --But toan tong hop
	@StringKey1T99 nvarchar(50), 
	@StringKey2T99 nvarchar(50),
	@StringKey3T99 nvarchar(50), 
	@OutputLenT99 int, 
	@OutputOrderT99 int,
	@SeparatedT99 int, 
	@SeparatorT99 char(1),
	
	@Enabled1 tinyint, 
	@Enabled2 tinyint,
	@Enabled3 tinyint,
	@S1 nvarchar(50), 
	@S2 nvarchar(50),
	@S3 nvarchar(50),
	@S1Type tinyint, 
	@S2Type tinyint,
	@S3Type tinyint, 

	@VoucherID nvarchar(50),
	@BatchID nvarchar(50),
	
	@VoucherNoT99 nvarchar(50), ----But toan tong hop

	@OrderCur AS cursor,
	
	@QuantityDecimals  AS tinyint,
	@UnitCostDecimals  AS tinyint, 
	@ConvertedDecimals AS tinyint

SELECT	@QuantityDecimals = QuantityDecimals, 
		@UnitCostDecimals = UnitCostDecimals, 
		@ConvertedDecimals = ConvertedDecimals
FROM	AT1101
WHERE DivisionID = @DivisionID

SET @QuantityDecimals =isnull( @QuantityDecimals,2)
SET @UnitCostDecimals = isnull( @UnitCostDecimals,2)
SET @ConvertedDecimals = isnull( @ConvertedDecimals,2)
	
SET NOCOUNT ON 

SET @VoucherTypeIDT99 = 'TH'

----Lay chi so tang so chung tu phieu tong hop
SELECT	@Enabled1 = Enabled1, @Enabled2 = Enabled2, @Enabled3 = Enabled3, 
		@S1 = S1, @S2 = S2, @S3 = S3, @S1Type = S1Type, @S2Type = S2Type, @S3Type = S3Type,
		@OutputLenT99 = OutputLength, @OutputOrderT99 = OutputOrder, @SeparatedT99 = Separated, @SeparatorT99 = Separator
FROM	AT1007 
WHERE	VoucherTypeID = @VoucherTypeIDT99 AND DivisionID = @DivisionID

IF @Enabled1 = 1
	SET @StringKey1T99 = 
	    CASE @S1Type 
	    WHEN 1 THEN CASE WHEN @TranMonth < 10 THEN '0' + LTRIM(@TranMonth) ELSE LTRIM(@TranMonth) END
	    WHEN 2 THEN LTRIM(@TranYear)
	    WHEN 3 THEN @VoucherTypeIDT99
	    WHEN 4 THEN @DivisionID
	    WHEN 5 THEN @S1
	    ELSE '' END
ELSE
	SET @StringKey1T99 = ''

IF @Enabled2 = 1
	SET @StringKey2T99 = 
	    CASE @S2Type 
	    WHEN 1 THEN CASE WHEN @TranMonth <10 THEN '0' + LTRIM(@TranMonth) ELSE LTRIM(@TranMonth) END
	    WHEN 2 THEN LTRIM(@TranYear)
	    WHEN 3 THEN @VoucherTypeIDT99
	    WHEN 4 THEN @DivisionID
	    WHEN 5 THEN @S2
	    ELSE '' END
ELSE
	SET @StringKey2T99 = ''

IF @Enabled3 = 1
	SET @StringKey3T99 = 
	    CASE @S3Type 
	    WHEN 1 THEN CASE WHEN @TranMonth <10 THEN '0' + LTRIM(@TranMonth) ELSE LTRIM(@TranMonth) END
	    WHEN 2 THEN LTRIM(@TranYear)
	    WHEN 3 THEN @VoucherTypeIDT99
	 WHEN 4 THEN @DivisionID
	    WHEN 5 THEN @S3
	    ELSE '' END
ELSE
	SET @StringKey3T99 = ''


-- Bat dau Import
 
DECLARE @TransactionTypeID  AS nvarchar(50),
		@DebitAccountID  AS nvarchar(50),
		@CreditAccountID nvarchar(50),
		@VoucherNo  AS nvarchar(50),
		@ReVoucherID  AS nvarchar(50),
		@VoucherTypeID  AS nvarchar(50),
		@InvoiceNo AS NVARCHAR(50),
		@LasKey AS int
		
SET @OrderCur = cursor static for
SELECT	ReVoucherID , TransactionID,ObjectID,AgentStatus,TranDate,CurrencyID,ExchangeRate,Amount,EndAmount, InvoiceAmount,
		BankAccountNo,TranNotes 
FROM	@AT5569 
BEGIN TRAN
OPEN @OrderCur
FETCH NEXT FROM @OrderCur INTO @ReVoucherID , @RefNo02, @ObjectID, @AgentStatus, @TranDate, @CurrencyID, @ExchangeRate, @Amount, @EndAmount, @InvoiceAmount, @BankAccountNo, @TranNotes
WHILE @@Fetch_Status = 0
BEGIN

	-- Sinh so phieu But toan tong hop
	EXEC AP0000 @DivisionID, @VoucherNoT99 Output, 'AT9000', @StringKey1T99, @StringKey2T99, @StringKey3T99, @OutputLenT99, @OutputOrderT99, @SeparatedT99, @SeparatorT99
	-- Sinh IGE
	EXEC AP0000 @DivisionID, @VoucherID Output, 'AT9000', 'AV', @TranYear, '', 16, 3, 0, '-'
	EXEC AP0000 @DivisionID, @BatchID Output, 'AT9000', 'AB', @TranYear, '', 16, 3, 0, '-'
	EXEC AP0000 @DivisionID, @TransactionID Output, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'			
	-- But toan tong hop
	SET @TransactionTypeID = 'T99'
	SET @DebitAccountID = '6411'
	SET @CreditAccountID = '3341'				
	SET @VoucherNo  = @VoucherNoT99
	SET @VoucherTypeID  = @VoucherTypeIDT99
		
	------>>> Hoa don tang tu dong
	IF ISNULL(@Serial, '') <> ''
	BEGIN
		IF NOT EXISTS ( SELECT TOP 1 1 FROM AT4444 WHERE TABLENAME = 'SERIAL' AND KEYSTRING = @Serial AND DivisionID = @DivisionID)
		BEGIN
			INSERT INTO AT4444
			(	DivisionID, TABLENAME,	KEYSTRING,	LASTKEY		)
			VALUES
			(	@DivisionID, 'SERIAL', @Serial,	1				)
			
			SET @LasKey = 1
		END
		ELSE
			BEGIN
				UPDATE AT4444
				SET		LASTKEY = LASTKEY + 1
				WHERE	TABLENAME = 'SERIAL' 
						AND KEYSTRING = @Serial
						AND DivisionID = @DivisionID
				SET @LasKey = (SELECT MAX(LASTKEY) FROM AT4444 WHERE TABLENAME = 'SERIAL' AND KEYSTRING = @Serial AND DivisionID = @DivisionID)
			END
		SET @InvoiceNo = REPLACE(STR(@LasKey, 4), ' ', '0')	
	END
	-------------<<< Hoa don tang tu dong
	
	---------->>>INSERT phieu tong hop
	INSERT INTO AT9000
	(VoucherID, BatchID, TransactionID, TableID, DivisionID, 
	TranMonth, TranYear, TransactionTypeID, CurrencyID, ObjectID,VATObjectID,
	DebitAccountID, CreditAccountID, ExchangeRate, 
	UnitPrice, OriginalAmount, ConvertedAmount,
	IsStock, VoucherDate, InvoiceDate, VoucherTypeID, VoucherNo, Orders,
	EmployeeID, Status,IsAudit,IsCost,VDescription, TDescription, Quantity, InventoryID, UnitID, 
	CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, 
	OriginalAmountCN, ExchangeRateCN, CurrencyIDCN, VATTypeID, VATGroupID, RefNo02, ReVoucherID,
	Serial, InvoiceNo		)
	VALUES
	(@VoucherID, @BatchID, @TransactionID, 'AT9000', @DivisionID, 
	@TranMonth, @TranYear, @TransactionTypeID, @CurrencyID, @ObjectID,@ObjectID,
	@DebitAccountID, @CreditAccountID, @ExchangeRate, 
	NULL, @Amount, Round(@Amount * @ExchangeRate,@ConvertedDecimals),
	0, @TranDate, @TranDate, @VoucherTypeID, @VoucherNo, 1, 
	@EmployeeID,0,0,0,@TranNotes,@TranNotes, NULL, '', NULL, 
	getDate(), @EmployeeID, getDate(), @EmployeeID, 
	@Amount, @ExchangeRate, @CurrencyID, '', '', @RefNo02, @ReVoucherID,
	@Serial, @InvoiceNo)			
	----------<<<INSERT phieu tong hop
	
-------->>> UPDATE so tien trong bang tam
	UPDATE	AT5567
	SET		EndAmount = EndAmount - @Amount
	WHERE	ReVoucherID = @ReVoucherID AND DivisionID = @DivisionID
----------<<<<UPDATE so tien trong bang tam
																		
	FETCH NEXT FROM @OrderCur INTO @ReVoucherID ,@RefNo02,@ObjectID,@AgentStatus,@TranDate,@CurrencyID,@ExchangeRate,@Amount,@EndAmount ,@InvoiceAmount ,@BankAccountNo,@TranNotes
END


IF @@ERROR = 0
	COMMIT TRAN
ELSE
	ROLLBACK TRAN
		
Close @OrderCur
End
Exist:
SET NOCOUNT OFF



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

