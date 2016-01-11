IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP5568]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP5568]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Purpose: Import danh sách phiếu chi
--Customize theo khách hàng MVI
-- File import 03_Template_PayableEntry.xls
/********************************************
'* Created by: [GS] [Trung Dung] [11/07/2011]
Modified on 26/07/2011 by Le Thi Thu Hien : Sua Ana05ID thanh RefNo02
Modified on 27/09/2011 by Le Thi Thu Hien : 
'********************************************/
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh

CREATE PROCEDURE [dbo].[AP5568] 
	@xml XML,
	@DivisionID nvarchar(50), 
	@TranMonth int , 
	@TranYear int, 
	@EmployeeID nvarchar(50),
	@Serial NVARCHAR(50)
AS

Declare @sql nvarchar(4000)

If not @xml IS NULL
Begin	
	declare @AT5569 table 
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
	Select 	X.AT5569.query('ReVoucherID').value('.','nvarchar(50)') as ReVoucherID
		  ,	X.AT5569.query('TransactionID').value('.','nvarchar(50)') as TransactionID
		  , X.AT5569.query('ObjectID').value('.','nvarchar(50)') as ObjectID
		  , X.AT5569.query('AgentStatus').value('.','nvarchar(50)') as AgentStatus
		  , X.AT5569.query('TranDate').value('.','datetime') as TranDate
		  , X.AT5569.query('CurrencyID').value('.','nvarchar(50)') as CurrencyID
		  , X.AT5569.query('ExchangeRate').value('.','decimal(28,8)') as ExchangeRate
		  , X.AT5569.query('Amount').value('.','decimal(28,8)') as Amount
		  , X.AT5569.query('BankAccountNo').value('.','nvarchar(50)') as BankAccountNo
		  , X.AT5569.query('TranNotes').value('.','nvarchar(250)') as TranNotes
		  , X.AT5569.query('InvoiceAmount').value('.','decimal(28,8)') as InvoiceAmount
		  , X.AT5569.query('EndAmount').value('.','decimal(28,8)') as EndAmount
		  
	From @xml.nodes('//AT5569') AS X(AT5569)
	) as XX
	
	SET ARITHABORT OFF

	--drop table AT5564
	--select * into AT5564 from @AT5569
	-- Nếu không có dữ liệu thì không xử lý tiếp
	IF(SELECT COUNT(*) FROM @AT5569) = 0 GOTO Exist

-- Biến cố định không có trong XML
	

Declare	@TransactionID nvarchar(50),
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

Declare @VoucherTypeIDT02 nvarchar(50), --But toan chi tien mặt
	@StringKey1T02 nvarchar(50), 
	@StringKey2T02 nvarchar(50),
	@StringKey3T02 nvarchar(50), 
	@OutputLenT02 int, 
	@OutputOrderT02 int,
	@SeparatedT02 int, 
	@SeparatorT02 char(1),

	@VoucherTypeIDT22 nvarchar(50), --But toan chi tien qua ngan hang
	@StringKey1T22 nvarchar(50), 
	@StringKey2T22 nvarchar(50),
	@StringKey3T22 nvarchar(50), 
	@OutputLenT22 int, 
	@OutputOrderT22 int,
	@SeparatedT22 int, 
	@SeparatorT22 char(1),
	
	@VoucherTypeIDT03 nvarchar(50), --But toan mua hang
	@StringKey1T03 nvarchar(50),
	@StringKey2T03 nvarchar(50),
	@StringKey3T03 nvarchar(50), 
	@OutputLenT03 int, 
	@OutputOrderT03 int,
	@SeparatedT03 int, 
	@SeparatorT03 char(1),
	
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
	@VoucherNoT03 nvarchar(50), ----Hoa don mua hang
	@VoucherNoT02 nvarchar(50), ----Phieu chi tien mat tai quy
	@VoucherNoT22 nvarchar(50), ----Phieu chi qua ngan hang
	
	@OrderCur as cursor,
	
	@QuantityDecimals  as tinyint,
	@UnitCostDecimals  as tinyint, 
	@ConvertedDecimals as tinyint

Select @QuantityDecimals = QuantityDecimals, @UnitCostDecimals = UnitCostDecimals, @ConvertedDecimals = ConvertedDecimals
FROM AT1101
WHERE DivisionID = @DivisionID
SET @QuantityDecimals =isnull( @QuantityDecimals,2)
SET @UnitCostDecimals = isnull( @UnitCostDecimals,2)
SET @ConvertedDecimals = isnull( @ConvertedDecimals,2)
	
SET NOCOUNT ON 

SET @VoucherTypeIDT99 = 'TH'
SET @VoucherTypeIDT02 = 'PC'
SET @VoucherTypeIDT22 = 'H1'
SET @VoucherTypeIDT03 = 'MH'

--Lay chi so tang so chung tu phieu chi
Select @Enabled1=Enabled1,@Enabled2=Enabled2,@Enabled3=Enabled3,@S1=S1,@S2=S2,@S3=S3,@S1Type=S1Type,@S2Type=S2Type,@S3Type=S3Type,
	@OutputLenT02 = OutputLength, @OutputOrderT02=OutputOrder,@SeparatedT02=Separated,@SeparatorT02=Separator
From AT1007 Where VoucherTypeID = @VoucherTypeIDT02 AND DivisionID = @DivisionID
If @Enabled1 = 1
	SET @StringKey1T02 = 
	Case @S1Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT02
	When 4 Then @DivisionID
	When 5 Then @S1
	Else '' End
Else
	SET @StringKey1T02 = ''

If @Enabled2 = 1
	SET @StringKey2T02 = 
	Case @S2Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT02
	When 4 Then @DivisionID
	When 5 Then @S2
	Else '' End
Else
	SET @StringKey2T02 = ''

If @Enabled3 = 1
	SET @StringKey3T02 = 
	Case @S3Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT02
	When 4 Then @DivisionID
	When 5 Then @S3
	Else '' End
Else
	SET @StringKey3T02 = ''


--Lay chi so tang so chung tu phieu chi qua ngan hang
SELECT	@Enabled1=Enabled1,@Enabled2=Enabled2,@Enabled3=Enabled3,@S1=S1,@S2=S2,@S3=S3,@S1Type=S1Type,@S2Type=S2Type,@S3Type=S3Type,
		@OutputLenT22 = OutputLength, @OutputOrderT22=OutputOrder,@SeparatedT22=Separated,@SeparatorT22=Separator
FROM	AT1007 WHERE VoucherTypeID = @VoucherTypeIDT22 AND DivisionID = @DivisionID
If @Enabled1 = 1
	SET @StringKey1T22 = 
	Case @S1Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT22
	When 4 Then @DivisionID
	When 5 Then @S1
	Else '' End
Else
	SET @StringKey1T22 = ''

If @Enabled2 = 1
	SET @StringKey2T22 = 
	Case @S2Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT22
	When 4 Then @DivisionID
	When 5 Then @S2
	Else '' End
Else
	SET @StringKey2T22 = ''

If @Enabled3 = 1
	SET @StringKey3T22 = 
	Case @S3Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT22
	When 4 Then @DivisionID
	When 5 Then @S3
	Else '' End
Else
	SET @StringKey3T22 = ''

----Lay chi so tang so chung tu phieu tong hop
SELECT 
    @Enabled1 = Enabled1, @Enabled2 = Enabled2, @Enabled3 = Enabled3, 
    @S1 = S1, @S2 = S2, @S3 = S3, @S1Type = S1Type, @S2Type = S2Type, @S3Type = S3Type,
	@OutputLenT99 = OutputLength, @OutputOrderT99 = OutputOrder, @SeparatedT99 = Separated, @SeparatorT99 = Separator
FROM AT1007 WHERE VoucherTypeID = @VoucherTypeIDT99 AND DivisionID = @DivisionID

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


--Lay chi so tang so chung tu mua hang
Select @Enabled1=Enabled1,@Enabled2=Enabled2,@Enabled3=Enabled3,@S1=S1,@S2=S2,@S3=S3,@S1Type=S1Type,@S2Type=S2Type,@S3Type=S3Type,
	@OutputLenT03 = OutputLength, @OutputOrderT03=OutputOrder,@SeparatedT03=Separated,@SeparatorT03=Separator
From AT1007 Where VoucherTypeID = @VoucherTypeIDT03 AND DivisionID = @DivisionID
If @Enabled1 = 1
	SET @StringKey1T03 = 
	Case @S1Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT03
	When 4 Then @DivisionID
	When 5 Then @S1
	Else '' End
Else
	SET @StringKey1T03 = ''

If @Enabled2 = 1
	SET @StringKey2T03 = 
	Case @S2Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT03
	When 4 Then @DivisionID
	When 5 Then @S2
	Else '' End
Else
	SET @StringKey2T03 = ''

If @Enabled3 = 1
	SET @StringKey3T03 = 
	Case @S3Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT03
	When 4 Then @DivisionID
	When 5 Then @S3
	Else '' End
Else
	SET @StringKey3T03 = ''
	
-- Bat dau Import
 
declare @TransactionTypeID  as nvarchar(50),
		@DebitAccountID  as nvarchar(50),
		@CreditAccountID nvarchar(50),
		@VoucherNo  as nvarchar(50),
		@ReVoucherID  as nvarchar(50),
		@VoucherTypeID  as nvarchar(50),
		@InvoiceNo AS NVARCHAR(50),
		@LasKey AS int
		
SET @OrderCur = cursor static for
SELECT	ReVoucherID , TransactionID,ObjectID,AgentStatus,TranDate,CurrencyID,ExchangeRate,Amount,EndAmount, InvoiceAmount,
		BankAccountNo,TranNotes 
FROM	@AT5569 
BEGIN TRAN
OPEN @OrderCur
FETCH NEXT FROM @OrderCur INTO @ReVoucherID , @RefNo02,@ObjectID,@AgentStatus,@TranDate,@CurrencyID,@ExchangeRate,@Amount,@EndAmount ,@InvoiceAmount ,@BankAccountNo,@TranNotes
While @@Fetch_Status = 0
Begin
	-- Voucher No but toan thu tien
	EXEC AP0000 @DivisionID, @VoucherNoT02 Output, 'AT9000', @StringKey1T02, @StringKey2T02, @StringKey3T02, @OutputLenT02, @OutputOrderT02, @SeparatedT02, @SeparatorT02
	-- Voucher No but toan thu tien qua ngan hang
	EXEC AP0000 @DivisionID, @VoucherNoT22 Output, 'AT9000', @StringKey1T22, @StringKey2T22, @StringKey3T22, @OutputLenT22, @OutputOrderT22, @SeparatedT22, @SeparatorT22
	--Import Hoa don mua hang
	EXEC AP0000 @DivisionID, @VoucherNoT03 Output, 'AT9000', @StringKey1T03, @StringKey2T03, @StringKey3T03, @OutputLenT03, @OutputOrderT03, @SeparatedT03, @SeparatorT03
	-- But toan tong hop
	EXEC AP0000 @DivisionID, @VoucherNoT99 Output, 'AT9000', @StringKey1T99, @StringKey2T99, @StringKey3T99, @OutputLenT99, @OutputOrderT99, @SeparatedT99, @SeparatorT99
	
	-- If the Sign shows agent is a company (cobroker)
	----Tao phieu mua hang
	--if(@ObjectID LIKE 'E%')
	IF (LEFT (@ObjectID,3) <> 'MVI') AND ISNUMERIC(@ObjectID) <> 0
		BEGIN				
			-- But toan hoa don mua hang
			SET @TransactionTypeID = 'T03'
			SET @DebitAccountID = '3388'
			SET @CreditAccountID = '3311'				
			SET @VoucherNo  = @VoucherNoT03
			SET @VoucherTypeID  = @VoucherTypeIDT03
			
			EXEC AP0000 @DivisionID, @VoucherID Output, 'AT9000', 'AV', @TranYear, '', 16, 3, 0, '-'
			EXEC AP0000 @DivisionID, @BatchID Output, 'AT9000', 'AB', @TranYear, '', 16, 3, 0, '-'
			EXEC AP0000 @DivisionID, @TransactionID Output, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'
			
			----Hóa đơn tăng tự động
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
			@EmployeeID,0,0,0,@TranNotes,@TranNotes, NULL, 'DV0001', NULL, 
			getDate(), @EmployeeID, getDate(), @EmployeeID, 
			@Amount, @ExchangeRate, @CurrencyID, 'VHDTT1', 'T10', @RefNo02, @ReVoucherID,
			@Serial, @InvoiceNo);	
			--Import but toan thue VAT của hoá đơn mua hang
			SET @TransactionTypeID = 'T13'
			SET @DebitAccountID = '1331'
			SET @CreditAccountID = '3311'						
			EXEC AP0000 @DivisionID, @TransactionID Output, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'
			INSERT INTO AT9000
					(VoucherID, BatchID, TransactionID, TableID, DivisionID, 
					TranMonth, TranYear, TransactionTypeID, CurrencyID, ObjectID, VATObjectID, 
					DebitAccountID, CreditAccountID, ExchangeRate, 
					OriginalAmount, ConvertedAmount,
					VoucherDate, InvoiceDate, VoucherTypeID, VoucherNo, Serial, InvoiceNo, Orders,
					EmployeeID, Status,IsAudit,IsCost,  VDescription, TDescription, 
					CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, 
					OriginalAmountCN, ExchangeRateCN, CurrencyIDCN, RefNo01, VATTypeID, VATGroupID, RefNo02)
				VALUES
					(@VoucherID, @BatchID, @TransactionID, 'AT9000', @DivisionID, 
					@TranMonth, @TranYear, @TransactionTypeID, @CurrencyID, @ObjectID, @ObjectID, 
					@DebitAccountID, @CreditAccountID, @ExchangeRate, 
					@Amount*10/100, Round(@Amount * @ExchangeRate,@ConvertedDecimals)*10/100,
					@TranDate, @TranDate, @VoucherTypeID, @VoucherNo, @Serial, @InvoiceNo, 0,
					@EmployeeID,0,0,0,@TranNotes,@TranNotes,getDate(), @EmployeeID, getDate(), @EmployeeID, 
					@Amount*10/100, @ExchangeRate, @CurrencyID, @VoucherNo, 'RGTGT1', 'T10', @RefNo02)	
			
		END
		
	IF @AgentStatus='RESIGN' 
		BEGIN 			
			SET @TransactionTypeID = 'T99'
			SET @DebitAccountID = '3388'
			SET @CreditAccountID = '3388'					
			SET @VoucherNo  = @VoucherNoT99
			SET @VoucherTypeID  = @VoucherTypeIDT99					
		END						
	ELSE ---@AgentStatus<>'RESIGN'
		BEGIN
			--IF @ObjectID LIKE 'E%'
			IF (LEFT (@ObjectID,3) = 'MVI') OR ISNUMERIC(@ObjectID) = 0
				BEGIN
					IF(@BankAccountNo <> '')
						BEGIN
							SET @TransactionTypeID = 'T22'
							SET @DebitAccountID = '3311'
							SET @CreditAccountID = '1112'					
							SET @VoucherNo  = @VoucherNoT22
							SET @VoucherTypeID  = @VoucherTypeIDT22
						END
					ELSE
						BEGIN
							SET @TransactionTypeID = 'T02'
							SET @DebitAccountID = '3311'
							SET @CreditAccountID = '1111'					
							SET @VoucherNo  = @VoucherNoT02
							SET @VoucherTypeID  = @VoucherTypeIDT02
						END
				END
			ELSE
				BEGIN
					IF(@BankAccountNo <> '')
						begin
							SET @TransactionTypeID = 'T22'
							SET @DebitAccountID = '3388'
							SET @CreditAccountID = '1112'					
							SET @VoucherNo  = @VoucherNoT22
							SET @VoucherTypeID  = @VoucherTypeIDT22
						END
					ELSE
						BEGIN
							SET @TransactionTypeID = 'T02'
							SET @DebitAccountID = '3388'
							SET @CreditAccountID = '1111'					
							SET @VoucherNo  = @VoucherNoT02
							SET @VoucherTypeID  = @VoucherTypeIDT02
						END
				END
				
		END
	EXEC AP0000 @DivisionID, @VoucherID Output, 'AT9000', 'AV', @TranYear, '', 16, 3, 0, '-'
	EXEC AP0000 @DivisionID, @TransactionID Output, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'
	INSERT INTO AT9000
	(VoucherID, BatchID, TransactionID, TableID, DivisionID, 
	TranMonth, TranYear, TransactionTypeID, CurrencyID, ObjectID,
	DebitAccountID, CreditAccountID, ExchangeRate, 
	UnitPrice, OriginalAmount, ConvertedAmount,
	IsStock, VoucherDate, InvoiceDate, VoucherTypeID, VoucherNo, Orders,
	EmployeeID, Status, IsAudit,IsCost,VDescription, TDescription,CreditBankAccountID,   
	CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, 
	OriginalAmountCN, ExchangeRateCN, CurrencyIDCN,	VATTypeID, VATGroupID, RefNo02,
	ReVoucherID, Serial, InvoiceNo)
	VALUES
	(@VoucherID, @VoucherID, @TransactionID, 'AT9000', @DivisionID, 
	@TranMonth, @TranYear, @TransactionTypeID, @CurrencyID, @ObjectID,
	@DebitAccountID, @CreditAccountID, @ExchangeRate, 
	NULL, (@Amount+ @Amount*10/100), Round(@Amount * @ExchangeRate,@ConvertedDecimals) + Round(@Amount * @ExchangeRate,@ConvertedDecimals)*10/100,
	0, @TranDate, @TranDate, @VoucherTypeID, @VoucherNo,1,
	@EmployeeID,0,0,0,@TranNotes ,@TranNotes,@BankAccountNo,getDate(), @EmployeeID, getDate(), @EmployeeID, 
	Round(@Amount * @ExchangeRate,@ConvertedDecimals), @ExchangeRate, @CurrencyID, 
	'VHDTT1', 'T10',@RefNo02,
	@ReVoucherID, @Serial, @InvoiceNo)
	
			UPDATE	AT5567
			SET		EndAmount = EndAmount - @Amount
			WHERE	 ReVoucherID = @ReVoucherID AND DivisionID = @DivisionID
																		
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

