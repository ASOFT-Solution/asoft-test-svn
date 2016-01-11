/****** Object:  StoredProcedure [dbo].[AP5558]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh


ALTER PROCEDURE [dbo].[AP5558]  @DivisionID nvarchar(50), @TranMonth int , @TranYear int, @EmployeeID nvarchar(50), 
				@VoucherDate datetime
				
					
AS

Declare @VoucherTypeIDT04 nvarchar(50), --But toan ban hang
	@StringKey1T04 nvarchar(50),
	@StringKey2T04 nvarchar(50),
	@StringKey3T04 nvarchar(50), 
	@OutputLenT04 int, 
	@OutputOrderT04 int,
	@SeparatedT04 int, 
	@SeparatorT04 char(1),

	@VoucherTypeIDT06 nvarchar(50), --But toan xuat kho
	@StringKey1T06 nvarchar(50), 
	@StringKey2T06 nvarchar(50),
	@StringKey3T06 nvarchar(50), 
	@OutputLenT06 int, 
	@OutputOrderT06 int,
	@SeparatedT06 int, 
	@SeparatorT06 char(1),

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
	@ImTaxAcc nvarchar(50),
	@SpecTaxAcc nvarchar(50),
	@VATTaxAcc nvarchar(50),

	@ImTaxAmount decimal(28,8),
	@SpecTaxAmount decimal(28,8),
	@VATTaxAmount decimal(28,8),

	@VoucherID nvarchar(50),
	@BatchID nvarchar(50),
	@TransactionID nvarchar(50),
	@VoucherNoT04 nvarchar(50),
	@VoucherNoT06 nvarchar(50),
	@VoucherNoT99 nvarchar(50),

	@DataName nvarchar(255),
	@OrderCur as cursor,
	@OrderCurDetail as cursor,
	@OrderID as nvarchar(50),

	@ObjectID as nvarchar(50),
	@Serial as nvarchar(50),
	@InvoiceNo as nvarchar(50),
	@VDescription as nvarchar(250),
	@InventoryID as nvarchar(50),
	@UnitID as nvarchar(50),
	@Quantity as decimal(28,8),
	@UnitPrice as decimal(28,8),
	@OriginalAmount as decimal(28,8),
	@ConvertedAmount as decimal(28,8),
	@CurrencyID as nvarchar(50),
	@ExchangeRate as money,
	@DebitAccountID as nvarchar(50),
	@CreditAccountID as nvarchar(50),
	@i int,
	@WareHouseID as nvarchar(50),

	@QuantityDecimals  as tinyint,
	@UnitCostDecimals  as tinyint, 
	@ConvertedDecimals as tinyint

Select @QuantityDecimals = QuantityDecimals, @UnitCostDecimals = UnitCostDecimals, @ConvertedDecimals = ConvertedDecimals
FROM AT1101
WHERE DivisionID = @DivisionID
Set @QuantityDecimals =isnull( @QuantityDecimals,2)
Set @UnitCostDecimals = isnull( @UnitCostDecimals,2)
Set @ConvertedDecimals = isnull( @ConvertedDecimals,2)
	
SET NOCOUNT ON 

EXEC AP5553 @DataName OUTPUT, 1

Set @VoucherTypeIDT04 = 'BH'
Set @VoucherTypeIDT06 = 'PX'
Set @VoucherTypeIDT99 = 'PH'
Set @ImTaxAcc = '3333'
Set @SpecTaxAcc = '3332'
Set @VATTaxAcc = '33311'

--Lay chi so tang so chung tu ban hang
Select @Enabled1=Enabled1,@Enabled2=Enabled2,@Enabled3=Enabled3,@S1=S1,@S2=S2,@S3=S3,@S1Type=S1Type,@S2Type=S2Type,@S3Type=S3Type,
	@OutputLenT04 = OutputLength, @OutputOrderT04=OutputOrder,@SeparatedT04=Separated,@SeparatorT04=Separator
From AT1007 Where VoucherTypeID = @VoucherTypeIDT04 AND DivisionID = @DivisionID
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

--Lay chi so tang so chung tu xuat kho
Select @Enabled1=Enabled1,@Enabled2=Enabled2,@Enabled3=Enabled3,@S1=S1,@S2=S2,@S3=S3,@S1Type=S1Type,@S2Type=S2Type,@S3Type=S3Type,
	@OutputLenT06 = OutputLength, @OutputOrderT06=OutputOrder,@SeparatedT06=Separated,@SeparatorT06=Separator
From AT1007 Where VoucherTypeID = @VoucherTypeIDT06 AND DivisionID = @DivisionID
If @Enabled1 = 1
	Set @StringKey1T06 = 
	Case @S1Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT06
	When 4 Then @DivisionID
	When 5 Then @S1
	Else '' End
Else
	Set @StringKey1T06 = ''

If @Enabled2 = 1
	Set @StringKey2T06 = 
	Case @S2Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT06
	When 4 Then @DivisionID
	When 5 Then @S2
	Else '' End
Else
	Set @StringKey2T06 = ''

If @Enabled3 = 1
	Set @StringKey3T06 = 
	Case @S3Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT06
	When 4 Then @DivisionID
	When 5 Then @S3
	Else '' End
Else
	Set @StringKey3T06 = ''

--Lay chi so tang so chung tu tong hop
Select @Enabled1=Enabled1,@Enabled2=Enabled2,@Enabled3=Enabled3,@S1=S1,@S2=S2,@S3=S3,@S1Type=S1Type,@S2Type=S2Type,@S3Type=S3Type,
	@OutputLenT99 = OutputLength, @OutputOrderT99=OutputOrder,@SeparatedT99=Separated,@SeparatorT99=Separator
From AT1007 Where VoucherTypeID = @VoucherTypeIDT99 AND DivisionID = @DivisionID
If @Enabled1 = 1
	Set @StringKey1T99 = 
	Case @S1Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT99
	When 4 Then @DivisionID
	When 5 Then @S1
	Else '' End
Else
	Set @StringKey1T99 = ''

If @Enabled2 = 1
	Set @StringKey2T99 = 
	Case @S2Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT99
	When 4 Then @DivisionID
	When 5 Then @S2
	Else '' End
Else
	Set @StringKey2T99 = ''

If @Enabled3 = 1
	Set @StringKey3T99 = 
	Case @S3Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeIDT99
	When 4 Then @DivisionID
	When 5 Then @S3
	Else '' End
Else
	Set @StringKey3T99 = ''

-- Bat dau Import
 
Set @OrderCur = cursor static for
Select OrderID, [Object_ID], left(dbo.af3339([Note]),250) From AT5558 Where OrderDate = @VoucherDate And OrderID not in (Select OrderID From AT5553 WHERE AT5558.DivisionID = @DivisionID) AND DivisionID = @DivisionID

Open @OrderCur
Fetch Next From @OrderCur Into @OrderID, @ObjectID, @VDescription
While @@Fetch_Status = 0
Begin
	
	--Import Hoa don ban hang
	EXEC AP0000 @VoucherNoT04 Output, 'AT9000', @StringKey1T04, @StringKey2T04, @StringKey3T04, @OutputLenT04, @OutputOrderT04, @SeparatedT04, @SeparatorT04
	EXEC AP0000 @VoucherID Output, 'AT9000', 'AV', @TranYear, '', 16, 3, 0, '-'
	EXEC AP0000 @BatchID Output, 'AT9000', 'AB', @TranYear, '', 16, 3, 0, '-'
	Set @i = 1
	
	Set @OrderCurDetail = cursor static for
	Select 	M.SoHieuHD As Serial, M.SoHD As InvoiceNo, 
		Product_ID As InventoryID, T3.UnitID As UnitID, 
		Round(Quantity,@QuantityDecimals) As Quantity, Round(Price,@UnitCostDecimals) As UnitPrice, 
		Round(Round(Quantity,@QuantityDecimals)*Round(Price,@UnitCostDecimals),@ConvertedDecimals) As OriginalAmount, 
		Round(Round(Quantity,@QuantityDecimals)*Round(Price,@UnitCostDecimals),@ConvertedDecimals) As ConvertedAmount,
		'VND' As CurrencyID, 1 As ExchangeRate, Case When Left(@ObjectID,2) In ('KH','C1','C2') Then '1311' Else '1111' End As DebitAccountID, isnull(T3.SalesAccountID,'5111') As CreditAccountID
	From 	AT5558 M Inner Join AT5559 D On M.OrderID = D.OrderID AND M.DivisionID = D.DivisionID inner Join AT1302 T3 On D.Product_ID = T3.InventoryID AND D.DivisionID = T3.DivisionID
	Where 	M.OrderID = @OrderID And M.OrderID Not In (Select OrderID From AT5553 WHERE M.DivisionID = @DivisionID) And M.OrderDate = @VoucherDate AND M.DivisionID = @DivisionID

	Open @OrderCurDetail
	Fetch Next From @OrderCurDetail Into 	@Serial, @InvoiceNo, 
						@InventoryID, @UnitID,
						@Quantity, @UnitPrice, @OriginalAmount, @ConvertedAmount,
						@CurrencyID, @ExchangeRate, @DebitAccountID, @CreditAccountID
	BEGIN TRAN
		While @@Fetch_Status = 0
		Begin
			EXEC AP0000 @TransactionID Output, 'AT9000', 'AT', @TranYear, '', 16, 3, 0, '-'
	
			Insert Into AT9000
			(VoucherID, BatchID, TransactionID, TableID, DivisionID, 
			TranMonth, TranYear, TransactionTypeID, CurrencyID, ObjectID,
			DebitAccountID, CreditAccountID, ExchangeRate, 
			UnitPrice, OriginalAmount, ConvertedAmount,
			IsStock, VoucherDate, InvoiceDate, VoucherTypeID, VoucherNo, Serial, InvoiceNo, Orders,
			EmployeeID, VDescription, Quantity, InventoryID, UnitID, 
			CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, 
			OriginalAmountCN, ExchangeRateCN, CurrencyIDCN)
			Values
			(@VoucherID, @BatchID, @TransactionID, 'AT9000', @DivisionID, 
			@TranMonth, @TranYear, 'T04', @CurrencyID, @ObjectID,
			@DebitAccountID, @CreditAccountID, @ExchangeRate, 
			@UnitPrice, @OriginalAmount, @ConvertedAmount,
			0, @VoucherDate, @VoucherDate, @VoucherTypeIDT04, @VoucherNoT04, @Serial, @InvoiceNo, @i, 
			@EmployeeID, @VDescription, @Quantity, @InventoryID, @UnitID, 
			getDate(), @EmployeeID, getDate(), @EmployeeID, 
			@OriginalAmount, @ExchangeRate, @CurrencyID)
	
	
			Set @i = @i + 1
			Fetch Next From @OrderCurDetail Into 	@Serial, @InvoiceNo, 
								@InventoryID, @UnitID,
								@Quantity, @UnitPrice, @OriginalAmount, @ConvertedAmount,
								@CurrencyID, @ExchangeRate, @DebitAccountID, @CreditAccountID
		End

		Close @OrderCurDetail
	
		--Import phieu xuat kho
		Select Top 1 @WareHouseID = Store_ID From AT5559 Where OrderID = @OrderID AND DivisionID = @DivisionID
		EXEC AP0000 @VoucherNoT06 Output, 'AT9000', @StringKey1T06, @StringKey2T06, @StringKey3T06, @OutputLenT06, @OutputOrderT06, @SeparatedT06, @SeparatorT06
	
		
			--Insert Master
			Insert Into AT2006
				(VoucherID,TableID,TranMonth,TranYear,
				DivisionID,VoucherTypeID,VoucherDate,VoucherNo,ObjectID,
				WareHouseID,KindVoucherID,EmployeeID,[Description],
				CreateDate,CreateUserID,LastModifyUserID,LastModifyDate, RefNo01)
			Values
				(@VoucherID,'AT2006',@TranMonth,@TranYear,
				@DivisionID,@VoucherTypeIDT06,@VoucherDate,@VoucherNoT06,@ObjectID,
				@WareHouseID,4,@EmployeeID,@VDescription,
				getDate(),@EmployeeID,@EmployeeID,getDate(), @VoucherNoT04)
			--Insert Detail
			Insert Into AT2007
				(TransactionID, VoucherID, InventoryID, UnitID, ActualQuantity, 
				TranMonth, TranYear, DivisionID, CurrencyID, ExchangeRate, 
				DebitAccountID,CreditAccountID, Orders)
			Select 
				TransactionID, VoucherID, AT9000.InventoryID, AT9000.UnitID, Quantity, 
				TranMonth, TranYear, AT9000.DivisionID, CurrencyID, ExchangeRate, 
				isnull(AT1302.PrimeCostAccountID,'6321'),isnull(AT1302.AccountID,'1561'), Orders
			From AT9000 Left Join AT1302 On AT9000.InventoryID = AT1302.InventoryID AND AT9000.DivisionID = AT1302.DivisionID
			Where VoucherID = @VoucherID And TableID = 'AT9000' And TransactionTypeID = 'T04' AND AT9000.DivisionID = @DivisionID
	
			Update AT9000 Set IsStock = 1 Where VoucherID = @VoucherID And TableID = 'AT9000' And TransactionTypeID = 'T04' AND AT9000.DivisionID = @DivisionID
	
		--Import but toan thue
		
		Select 	@ImTaxAmount = Sum(Round(isnull(((Quantity*Price-FreeTax)*TaxNK/100),0),@ConvertedDecimals)),
			@SpecTaxAmount = Sum(Round(isnull((((Quantity*Price-FreeTax) + ((quantity*price-FreeTax)*TaxNK/100))*TaxTTDB/100),0),@ConvertedDecimals)), 
			@VATTaxAmount = Sum(Round(isnull((((quantity*price-FreeTax) + ((quantity*price-FreeTax)*TaxNK/100) + (((quantity*price-FreeTax) + ((quantity*price-FreeTax)*TaxNK/100))*TaxTTDB/100))*VAT/100),0),@ConvertedDecimals)) 
		From AT5559 Where OrderID = @OrderID AND DivisionID = @DivisionID
	
		If isnull(@ImTaxAmount,0) <> 0 or isnull(@SpecTaxAmount,0) <> 0 or isnull(@VATTaxAmount,0) <> 0
		Begin
			EXEC AP0000 @VoucherID Output, 'AT9000', 'AH', @TranYear, '', 16, 3, 0, '-'
			EXEC AP0000 @VoucherNoT99 Output, 'AT9000', @StringKey1T99, @StringKey2T99, @StringKey3T99, @OutputLenT99, @OutputOrderT99, @SeparatedT99, @SeparatorT99
			--Import but toan thue nhap khau
			If isnull(@ImTaxAmount,0) <> 0
			Begin
				EXEC AP0000 @TransactionID Output, 'AT9000', 'BH', @TranYear, '', 16, 3, 0, '-'
				Insert Into AT9000
					(VoucherID, BatchID, TransactionID, TableID, DivisionID, 
					TranMonth, TranYear, TransactionTypeID, CurrencyID, ObjectID, CreditObjectID, 
					DebitAccountID, CreditAccountID, ExchangeRate, 
					OriginalAmount, ConvertedAmount,
					VoucherDate, InvoiceDate, VoucherTypeID, VoucherNo, Serial, InvoiceNo, 
					EmployeeID, VDescription, TDescription, 
					CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, 
					OriginalAmountCN, ExchangeRateCN, CurrencyIDCN, RefNo01)
				Values
					(@VoucherID, @VoucherID, @TransactionID, 'AT9000', @DivisionID, 
					@TranMonth, @TranYear, 'T99', @CurrencyID, @ObjectID, @ObjectID, 
					Case When Left(@ObjectID,2) In ('KH','C1','C2') Then '1311' Else '1111' End, @ImTaxAcc, @ExchangeRate, 
					@ImTaxAmount, @ImTaxAmount,
					@VoucherDate, @VoucherDate, @VoucherTypeIDT99, @VoucherNoT99, @Serial, @InvoiceNo, 
					@EmployeeID, N'Thu hộ thuế', N'Thuế nhập khẩu', 
					getDate(), @EmployeeID, getDate(), @EmployeeID, 
					@ImTaxAmount, @ExchangeRate, @CurrencyID, @VoucherNoT04)
			End

			--Import but toan thue tieu thu dac biet
			If isnull(@SpecTaxAmount,0) <> 0
			Begin
				EXEC AP0000 @TransactionID Output, 'AT9000', 'BH', @TranYear, '', 16, 3, 0, '-'
				Insert Into AT9000
					(VoucherID, BatchID, TransactionID, TableID, DivisionID, 
					TranMonth, TranYear, TransactionTypeID, CurrencyID, ObjectID, CreditObjectID, 
					DebitAccountID, CreditAccountID, ExchangeRate, 
					OriginalAmount, ConvertedAmount,
					VoucherDate, InvoiceDate, VoucherTypeID, VoucherNo, Serial, InvoiceNo, 
					EmployeeID, VDescription, TDescription, 
					CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, 
					OriginalAmountCN, ExchangeRateCN, CurrencyIDCN, RefNo01)
				Values
					(@VoucherID, @VoucherID, @TransactionID, 'AT9000', @DivisionID, 
					@TranMonth, @TranYear, 'T99', @CurrencyID, @ObjectID, @ObjectID, 
					Case When Left(@ObjectID,2) In ('KH','C1','C2') Then '1311' Else '1111' End, @SpecTaxAcc, @ExchangeRate, 
					@SpecTaxAmount, @SpecTaxAmount,
					@VoucherDate, @VoucherDate, @VoucherTypeIDT99, @VoucherNoT99, @Serial, @InvoiceNo, 
					@EmployeeID, N'Thu hộ thuế', N'Thuế TTĐB', 
					getDate(), @EmployeeID, getDate(), @EmployeeID, 
					@SpecTaxAmount, @ExchangeRate, @CurrencyID, @VoucherNoT04)
			End
			
			--Import but toan thue VAT
			If isnull(@VATTaxAmount,0) <> 0
			Begin
				EXEC AP0000 @TransactionID Output, 'AT9000', 'BH', @TranYear, '', 16, 3, 0, '-'
				Insert Into AT9000
					(VoucherID, BatchID, TransactionID, TableID, DivisionID, 
					TranMonth, TranYear, TransactionTypeID, CurrencyID, ObjectID, CreditObjectID, 
					DebitAccountID, CreditAccountID, ExchangeRate, 
					OriginalAmount, ConvertedAmount,
					VoucherDate, InvoiceDate, VoucherTypeID, VoucherNo, Serial, InvoiceNo, 
					EmployeeID, VDescription, TDescription, 
					CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, 
					OriginalAmountCN, ExchangeRateCN, CurrencyIDCN, RefNo01, VATTypeID)
				Values
					(@VoucherID, @VoucherID, @TransactionID, 'AT9000', @DivisionID, 
					@TranMonth, @TranYear, 'T99', @CurrencyID, @ObjectID, @ObjectID, 
					Case When Left(@ObjectID,2) In ('KH','C1','C2') Then '1311' Else '1111' End, @VATTaxAcc, @ExchangeRate, 
					@VATTaxAmount, @VATTaxAmount,
					@VoucherDate, @VoucherDate, @VoucherTypeIDT99, @VoucherNoT99, @Serial, @InvoiceNo, 
					@EmployeeID, N'Thu hộ thuế', N'Thuế VAT', 
					getDate(), @EmployeeID, getDate(), @EmployeeID, 
					@VATTaxAmount, @ExchangeRate, @CurrencyID, @VoucherNoT04, 'RGTGT')
			End
		End

	IF @@ERROR = 0
		Begin
			Insert Into AT5553 (VoucherID, OrderID, DivisionID) Values (@VoucherID, @OrderID,@DivisionID)
			COMMIT TRAN
		End
	ELSE
		ROLLBACK TRAN

	Fetch Next From @OrderCur Into @OrderID, @ObjectID, @VDescription
End

Close @OrderCur

SET NOCOUNT OFF
GO
