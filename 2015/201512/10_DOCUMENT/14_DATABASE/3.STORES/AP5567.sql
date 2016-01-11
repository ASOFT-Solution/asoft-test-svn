IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP5567]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP5567]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Purpose: chọn phiếu thu để xuất hóa đơn
--Customize theo khách hàng MVI
-- Import vào phiếu thu đồng thời vào bảng tạm, chọn trong bảng tạm để Import vào Hóa đơn bán hàng
-- File import 02_Template_ReceiptEntry.xls
/********************************************
'* Created by: [GS] [Thanh Nguyen] [29/07/2010]
Modified on 26/07/2011 by Le Thi Thu Hien : Sua Ana05ID thanh RefNo02
'********************************************/
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh


CREATE PROCEDURE [dbo].[AP5567] 
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
		TransactionID nvarchar(50),
		ReVoucherID NVARCHAR(50),
		ObjectID nvarchar(50),
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

	INSERT INTO @AT5569 (TransactionID,ReVoucherID,ObjectID,TranDate,CurrencyID,ExchangeRate,Amount,BankAccountNo, InvoiceAmount, EndAmount)	
	SELECT DISTINCT * 
	FROM (
	SELECT 	X.AT5569.query('TransactionID').value('.','nvarchar(50)') as TransactionID
		  , X.AT5569.query('ReVoucherID').value('.','nvarchar(50)') as ReVoucherID
		  , X.AT5569.query('ObjectID').value('.','nvarchar(250)') as ObjectID
		  , X.AT5569.query('TranDate').value('.','datetime') as TranDate
		  , X.AT5569.query('CurrencyID').value('.','nvarchar(50)') as CurrencyID
		  , X.AT5569.query('ExchangeRate').value('.','decimal(28,8)') as ExchangeRate
		  , X.AT5569.query('Amount').value('.','decimal(28,8)') as Amount
		  , X.AT5569.query('BankAccountNo').value('.','nvarchar(50)') as BankAccountNo
		  , X.AT5569.query('InvoiceAmount').value('.','decimal(28,8)') as InvoiceAmount
		  , X.AT5569.query('EndAmount').value('.','decimal(28,8)') as EndAmount
	From @xml.nodes('//AT5569') AS X(AT5569)
	) as XX


	-- Nếu không có dữ liệu thì không xử lý tiếp
	IF(SELECT COUNT(*) FROM @AT5569) = 0 GOTO Exist
	
	
DECLARE	@TransactionID nvarchar(50),
		@ReVoucherID NVARCHAR(50),
		@RefNo02 nvarchar(50),
		@ObjectID nvarchar(50),
		@TranDate DateTime,
		@CurrencyID nvarchar(50),
		@ExchangeRate decimal(28,8),
		@Amount decimal(28,8),
		@BankAccountNo nvarchar(50),
		@InvoiceAmount DECIMAL(28,8),
		@EndAmount DECIMAL(28,8)

DECLARE @VoucherTypeIDT01 nvarchar(50), --But toan thu tien mặt
		@StringKey1T01 nvarchar(50), 
		@StringKey2T01 nvarchar(50),
		@StringKey3T01 nvarchar(50), 
		@OutputLenT01 int, 
		@OutputOrderT01 int,
		@SeparatedT01 int, 
		@SeparatorT01 char(1),

		@VoucherTypeIDT21 nvarchar(50), --But toan thu tien qua ngan hang
		@StringKey1T21 nvarchar(50), 
		@StringKey2T21 nvarchar(50),
		@StringKey3T21 nvarchar(50), 
		@OutputLenT21 int, 
		@OutputOrderT21 int,
		@SeparatedT21 int, 
		@SeparatorT21 char(1),
		
		@VoucherTypeIDT04 nvarchar(50), --But toan ban hang
		@StringKey1T04 nvarchar(50),
		@StringKey2T04 nvarchar(50),
		@StringKey3T04 nvarchar(50), 
		@OutputLenT04 int, 
		@OutputOrderT04 int,
		@SeparatedT04 int, 
		@SeparatorT04 char(1),
	
		--@VoucherTypeIDT14 nvarchar(50), --But toan thuế VAT
		--@StringKey1T14 nvarchar(50), 
		--@StringKey2T14 nvarchar(50),
		--@StringKey3T14 nvarchar(50), 
		--@OutputLenT14 int, 
		--@OutputOrderT14 int,
		--@SeparatedT14 int, 
		--@SeparatorT14 char(1),
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
		@VoucherNoT04 nvarchar(50),
		@VoucherNoT01 nvarchar(50),
		@VoucherNoT21 nvarchar(50),
		--@VoucherNoT14 nvarchar(50),

		@OrderCur as cursor,

		@QuantityDecimals  as tinyint,
		@UnitCostDecimals  as tinyint, 
		@ConvertedDecimals as tinyint

SELECT	@QuantityDecimals = QuantityDecimals, @UnitCostDecimals = UnitCostDecimals, 
		@ConvertedDecimals = ConvertedDecimals
FROM	AT1101
WHERE DivisionID = @DivisionID
Set @QuantityDecimals =isnull( @QuantityDecimals,2)
Set @UnitCostDecimals = isnull( @UnitCostDecimals,2)
Set @ConvertedDecimals = isnull( @ConvertedDecimals,2)
	
SET NOCOUNT ON 

Set @VoucherTypeIDT01 = 'PT'
Set @VoucherTypeIDT21 = 'G1'
Set @VoucherTypeIDT04 = 'BH'
--Set @VoucherTypeIDT14 = 'PH'

--Lay chi so tang so chung tu phieu thu
SELECT	@Enabled1=Enabled1,@Enabled2=Enabled2,@Enabled3=Enabled3,@S1=S1,@S2=S2,@S3=S3,@S1Type=S1Type,@S2Type=S2Type,@S3Type=S3Type,
		@OutputLenT01 = OutputLength, @OutputOrderT01=OutputOrder,@SeparatedT01=Separated,@SeparatorT01=Separator
FROM	AT1007 WHERE VoucherTypeID = @VoucherTypeIDT01 AND DivisionID = @DivisionID

If @Enabled1 = 1
	Set @StringKey1T01 = 
	Case @S1Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT01
	When 4 Then @DivisionID
	When 5 Then @S1
	Else '' End
Else
	Set @StringKey1T01 = ''

If @Enabled2 = 1
	Set @StringKey2T01 = 
	Case @S2Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT01
	When 4 Then @DivisionID
	When 5 Then @S2
	Else '' End
Else
	Set @StringKey2T01 = ''

If @Enabled3 = 1
	Set @StringKey3T01 = 
	Case @S3Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT01
	When 4 Then @DivisionID
	When 5 Then @S3
	Else '' End
Else
	Set @StringKey3T01 = ''


--Lay chi so tang so chung tu phieu thu qua ngan hang
SELECT	@Enabled1=Enabled1,@Enabled2=Enabled2,@Enabled3=Enabled3,@S1=S1,@S2=S2,@S3=S3,@S1Type=S1Type,@S2Type=S2Type,@S3Type=S3Type,
		@OutputLenT21 = OutputLength, @OutputOrderT21=OutputOrder,@SeparatedT21=Separated,@SeparatorT21=Separator
FROM	AT1007 WHERE VoucherTypeID = @VoucherTypeIDT21 AND DivisionID = @DivisionID
If @Enabled1 = 1
	Set @StringKey1T21 = 
	Case @S1Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT21
	When 4 Then @DivisionID
	When 5 Then @S1
	Else '' End
Else
	Set @StringKey1T21 = ''

If @Enabled2 = 1
	Set @StringKey2T21 = 
	Case @S2Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT21
	When 4 Then @DivisionID
	When 5 Then @S2
	Else '' End
Else
	Set @StringKey2T21 = ''

If @Enabled3 = 1
	Set @StringKey3T21 = 
	Case @S3Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT21
	When 4 Then @DivisionID
	When 5 Then @S3
	Else '' End
Else
	Set @StringKey3T21 = ''


--Lay chi so tang so chung tu ban hang
SELECT	@Enabled1=Enabled1,@Enabled2=Enabled2,@Enabled3=Enabled3,@S1=S1,@S2=S2,@S3=S3,@S1Type=S1Type,@S2Type=S2Type,@S3Type=S3Type,
		@OutputLenT04 = OutputLength, @OutputOrderT04=OutputOrder,@SeparatedT04=Separated,@SeparatorT04=Separator
FROM	AT1007 WHERE VoucherTypeID = @VoucherTypeIDT04 AND DivisionID = @DivisionID
If @Enabled1 = 1
	Set @StringKey1T04 = 
	Case @S1Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT04
	When 4 Then @DivisionID
	When 5 Then @S1
	Else '' End
Else
	Set @StringKey1T04 = ''

If @Enabled2 = 1
	Set @StringKey2T04 = 
	Case @S2Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT04
	When 4 Then @DivisionID
	When 5 Then @S2
	Else '' End
Else
	Set @StringKey2T04 = ''

If @Enabled3 = 1
	Set @StringKey3T04 = 
	Case @S3Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT04
	When 4 Then @DivisionID
	When 5 Then @S3
	Else '' End
Else
	Set @StringKey3T04 = ''
	
-- Bat dau Import
DECLARE @TransactionTypeID  as nvarchar(50),
		@DebitAccountID  as nvarchar(50),
		@VoucherNo  as nvarchar(50),
		@VoucherTypeID  as nvarchar(50),
		@InvoiceNo AS NVARCHAR(50),
		@LasKey AS int
		
Set @OrderCur = cursor static for
SELECT ReVoucherID,TransactionID, ObjectID,TranDate,CurrencyID,ExchangeRate,Amount,BankAccountNo, InvoiceAmount, EndAmount 
FROM	@AT5569 

BEGIN TRAN
Open @OrderCur
--Fetch Next From @OrderCur Into @OrderID, @ObjectID, @VDescription
Fetch Next From @OrderCur Into @ReVoucherID, @RefNo02,@ObjectID,@TranDate,@CurrencyID,@ExchangeRate,@Amount,@BankAccountNo, @InvoiceAmount, @EndAmount
While @@Fetch_Status = 0
Begin
	-- Voucher No but toan thu tien
	EXEC AP0000 @DivisionID, @VoucherNoT01 Output, 'AT9000', @StringKey1T01, @StringKey2T01, @StringKey3T01, @OutputLenT01, @OutputOrderT01, @SeparatedT01, @SeparatorT01
	-- Voucher No but toan thu tien qua ngan hang
	EXEC AP0000 @DivisionID, @VoucherNoT21 Output, 'AT9000', @StringKey1T21, @StringKey2T21, @StringKey3T21, @OutputLenT21, @OutputOrderT21, @SeparatedT21, @SeparatorT21
	--Import Hoa don ban hang
	EXEC AP0000 @DivisionID, @VoucherNoT04 Output, 'AT9000', @StringKey1T04, @StringKey2T04, @StringKey3T04, @OutputLenT04, @OutputOrderT04, @SeparatedT04, @SeparatorT04
	-- Thuế VAT
	--EXEC AP0000 @DivisionID, @VoucherNoT14 Output, 'AT9000', @StringKey1T14, @StringKey2T14, @StringKey3T14, @OutputLenT14, @OutputOrderT14, @SeparatedT14, @SeparatorT14
	
	-- CBVN can not receive the total amount of commission from Investor
	IF(@Amount = 0)
		BEGIN
			-- Trường hợp số tiền hoa hồng nhận được = 0 thì  revert lại toàn bộ các bút toán tổng hợp
			EXEC AP5566 @DivisionID, @TranMonth, @TranYear, @EmployeeID, @RefNo02, @ObjectID
		END
	ELSE
		BEGIN -- CBVN received the total amount of commission from Investor 
			-- pay by bank
			IF(@BankAccountNo <> '')
				BEGIN
					set @TransactionTypeID = 'T21'
					set @DebitAccountID = '1121'
					set @VoucherNo  = @VoucherNoT21
					set @VoucherTypeID  = @VoucherTypeIDT21
				END
			ELSE
				BEGIN
					set @TransactionTypeID = 'T01'
					set @DebitAccountID = '1111'
					set @VoucherNo  = @VoucherNoT01
					set @VoucherTypeID  = @VoucherTypeIDT01
				END
				
				EXEC AP0000 @DivisionID, @VoucherID Output, 'AT9000', 'AV', @TranYear, '', 16, 3, 0, '-'
				-- EXEC AP0000 @DivisionID, @BatchID Output, 'AT9000', 'AB', @TranYear, '', 16, 3, 0, '-'
				EXEC AP0000 @DivisionID, @TransactionID Output, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'
		
			
			EXEC AP0000 @DivisionID, @VoucherID Output, 'AT9000', 'AV', @TranYear, '', 16, 3, 0, '-'
			EXEC AP0000 @DivisionID, @BatchID Output, 'AT9000', 'AB', @TranYear, '', 16, 3, 0, '-'
			EXEC AP0000 @DivisionID, @TransactionID Output, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'
			
			---Hóa đơn tăng tự động
			IF NOT EXISTS ( SELECT TOP 1 1 FROM AT4444 WHERE TABLENAME = 'SERIAL' AND KEYSTRING = @Serial)
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
					SET @LasKey = (SELECT MAX(LASTKEY) FROM AT4444 WHERE TABLENAME = 'SERIAL' AND KEYSTRING = @Serial)
				END
			SET @InvoiceNo = REPLACE(STR(@LasKey, 4), ' ', '0')	
			
			-- But toan hoa don ban hang
			INSERT INTO AT9000
				(VoucherID, BatchID, TransactionID, TableID, DivisionID, 
				TranMonth, TranYear, TransactionTypeID, CurrencyID, ObjectID,VATObjectID,
				DebitAccountID, CreditAccountID, ExchangeRate, 
				UnitPrice, OriginalAmount, ConvertedAmount,
				IsStock, VoucherDate, InvoiceDate, VoucherTypeID, VoucherNo, Orders,
				EmployeeID, Status,IsAudit,IsCost,  Quantity, InventoryID, UnitID, 
				CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, 
				OriginalAmountCN, ExchangeRateCN, CurrencyIDCN, VATTypeID, VATGroupID, [RefNo02], ReVoucherID,
				Serial, InvoiceNo	)
			VALUES
				(@VoucherID, @BatchID, @TransactionID, 'AT9000', @DivisionID, 
				@TranMonth, @TranYear, 'T04', @CurrencyID, @ObjectID,@ObjectID,
				'3387', '511', @ExchangeRate, 
				NULL, @Amount, Round(@Amount * @ExchangeRate,@ConvertedDecimals),
				0, @TranDate, @TranDate, @VoucherTypeIDT04, @VoucherNoT04, 1, 
				@EmployeeID,0,0,0, NULL, 'DV0001', NULL, 
				getDate(), @EmployeeID, getDate(), @EmployeeID, 
				@Amount, @ExchangeRate, @CurrencyID, 'RGTGT1', 'T10', @RefNo02, @ReVoucherID,
				@Serial, @InvoiceNo);
				
			--Import but toan thue VAT
			EXEC AP0000 @DivisionID, @TransactionID Output, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'
			INSERT INTO AT9000
					(VoucherID, BatchID, TransactionID, TableID, DivisionID, 
					TranMonth, TranYear, TransactionTypeID, CurrencyID, ObjectID, VATObjectID, 
					DebitAccountID, CreditAccountID, ExchangeRate, 
					OriginalAmount, ConvertedAmount,
					VoucherDate, InvoiceDate, VoucherTypeID, VoucherNo, Serial, InvoiceNo, Orders,
					EmployeeID, Status,IsAudit,IsCost,  VDescription, TDescription, 
					CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, 
					OriginalAmountCN, ExchangeRateCN, CurrencyIDCN, [RefNo01], VATTypeID, VATGroupID, RefNo02, ReVoucherID)
			VALUES
					(@VoucherID, @BatchID, @TransactionID, 'AT9000', @DivisionID, 
					@TranMonth, @TranYear, 'T14', @CurrencyID, @ObjectID, @ObjectID, 
					'3387', '33311', @ExchangeRate, 
					@Amount*10/100, Round(@Amount * @ExchangeRate,@ConvertedDecimals)*10/100,
					@TranDate, @TranDate, @VoucherTypeIDT04, @VoucherNoT04, @Serial, @InvoiceNo, 0,
					@EmployeeID,0,0,0,NULL, N'Thuế VAT', 
					getDate(), @EmployeeID, getDate(), @EmployeeID, 
					@Amount*10/100, @ExchangeRate, @CurrencyID, @VoucherNoT04, 'RGTGT1', 'T10', @RefNo02, @ReVoucherID)
					
			UPDATE	AT5567
			SET		EndAmount = EndAmount - @Amount
			WHERE	ReVoucherID = @ReVoucherID AND DivisionID = @DivisionID
		END
	FETCH NEXT FROM @OrderCur INTO @ReVoucherID,@RefNo02,@ObjectID,@TranDate,@CurrencyID,@ExchangeRate,@Amount,@BankAccountNo, @InvoiceAmount, @EndAmount
End

IF @@ERROR = 0
	COMMIT TRAN
ELSE
	ROLLBACK TRAN
		
CLOSE @OrderCur
END

Exist:
SET NOCOUNT OFF




GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

