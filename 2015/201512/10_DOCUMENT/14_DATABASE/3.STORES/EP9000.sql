/****** Object:  StoredProcedure [dbo].[EP9000]    Script Date: 07/29/2010 16:07:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


----- Created by Nguyen Quoc Huy.
---- Date 07/06/2008.
----  Purpose: tu dong Import but toan tong hop.
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ, tiền hạch toán theo thiết lập đơn vị-chi nhánh
'********************************************/


ALTER PROCEDURE [dbo].[EP9000]  	@DivisionID as nvarchar(50), @TranMonth as int, @TranYear as int,
				@BatchID as nvarchar(50), @VoucherTypeID as nvarchar(50),
				@TransactionTypeID as nvarchar(50), ---'T99' --- tong hop
				@UserID as nvarchar(50), @TempInvoiceDate as datetime
 AS

Declare 	@Tran_cur as cursor,
                                @CurrencyID nvarchar(50),
		@OriginalAmount as decimal (28,8),
		@ConvertedAmount as decimal (28,8),
		@VoucherID as nvarchar(50),
		@TransactionID nvarchar(50),
		@ObjectID as nvarchar(50),
		@ObjectName as nvarchar(250),
                                @CreditObjectID as nvarchar(50),
		@VDescription 	as nvarchar(250),
		@BDescription 	as nvarchar(250),
		@TDescription 	as nvarchar(250),
		@SenderReceiver as nvarchar(50),
		@Quantity as int,
		@VATGroupID as nvarchar(250),
		@VATTypeID as nvarchar(50),
		@VATNo as nvarchar(50),
		@VATPercent as decimal (28,8),
		@Serial as nvarchar(50),
		@VoucherNo as nvarchar(50),
		@InvoiceNo nvarchar(50),
		@InvoiceDate Datetime,
		@VoucherDate as  Datetime,
		@DebitAccountID as nvarchar(50),
		@CreditAccountID as nvarchar(50),
		@Auto as tinyint,
		@S1 nvarchar(50),
		@S2  nvarchar(50),
		@S3 nvarchar(50),
		@S1Type as int,
		@S2Type as int,
		@S3Type as int,
		@OutputOrder as int,
		@OutputLen as int,
		@Separated as tinyint,
		@separator as nvarchar(1),
		@CYear as nvarchar(20),
		@Orders as int,
		@VATObjectAddress as nvarchar(250),
                                @Ana01ID as nvarchar(50), 
                                @Ana02ID as nvarchar(50),
                                @Ana03ID as nvarchar(50), 
                                @Ana04ID as nvarchar(50),
                                @Ana05ID as nvarchar(50),
-----------------------------Cac bien lan tron so le----------------------
		@QuantityDecimals as int,
		@UnitCostDecimals as int,
		@ConvertedDecimals as int


Select @QuantityDecimals = QuantityDecimals, @UnitCostDecimals = UnitCostDecimals , @ConvertedDecimals = ConvertedDecimals From AT1101 WHERE DivisionID = @DivisionID

Set @CYear =ltrim(rtrim(str(@TranYear)))
Select top 1 @CurrencyID =BaseCurrencyID From AT1101 WHERE DivisionID = @DivisionID
Select @S1 =S1,@S2=S2,@S3 =S3, @S1Type= S1Type, @S2Type= S2Type, @S3Type= S3Type, @OutputLen= OutputLength, @OutputOrder=OutputOrder, @separator=separator, @Separated = Separated From AT1007 Where VoucherTypeID =@VouchertypeID
----------------------------------------------------BEGIN TAO BUT TOAN TONG HOP VA BUT TOAN THUE VAT NEU CO ---------------------------------------------------------------------------------------------------


iF @TransactionTypeID = 'T99'
BEGIN

		---- Sinh so phieu moi --------------
		If @Auto <>0
			Exec EP9001  @VoucherNo OUTPUT, 'AT9000',@S1,@S2,@S3, @S1Type, @S2Type, @S3Type, @OutputLen, @OutputOrder, @Separated, @separator, @TranMonth, @TranYear,@DivisionID
		Else
			Set @VoucherNo =''
		--------- Sinh ma ngam -----------------------
		Exec AP0000  @DivisionID, @VoucherID OUTPUT, 'AT9000','AH',@CYear,'',16, 3, ''
		Set @Orders = 0

		SET @Tran_cur  = Cursor Scroll KeySet FOR 	
				Select  DebitAccountID, CreditAccountID,OriginalAmount, ConvertedAmount, 
                                                                               ObjectID, VATObjectName , CreditObjectID, VATNo, VATGroupID, VDescription, BDescription, TDescription, SenderReceiver, 
					InvoiceDate, InvoiceNo, Serial, Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID 
				From AT9002 
				Where 	TemplateBatchID =@BatchID and TransactionTypeID ='E99' AND DivisionID = @DivisionID
				Order by Orders
                                                                

				Open @Tran_cur
				FETCH NEXT FROM @Tran_cur INTO  @DebitAccountID, @CreditAccountID, @OriginalAmount, @ConvertedAmount,
									@ObjectID, @ObjectName , @CreditObjectID,
                                                                                                                                                @VATNo, @VATGroupID, @VDescription, @BDescription, @TDescription, @SenderReceiver,
									@InvoiceDate, @InvoiceNo, @Serial,  @Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID
					
				WHILE @@Fetch_Status = 0 
				Begin

					Set @Orders = @Orders + 1
					Exec AP0000  @DivisionID, @TRansactionID OUTPUT, 'AT9000','BH',@CYear,'',16, 3, ''
                                                                                Set @VoucherDate = isnull(@InvoiceDate,GetDate())

					Insert AT9000 (TransactionID, VoucherID, BatchID, VoucherNo, VoucherDate, 
						InvoiceDate, InvoiceNo, Serial, VATTypeID, VoucherTypeID, TranMonth, TranYear, DivisionID, TransactionTypeID, TableID, 
						CurrencyID, CurrencyIDCN, ExchangeRate, OriginalAmount, OriginalAmountCN, ConvertedAmount,
						ObjectID, CreditObjectID, VATObjectName, 
						VATGroupID, VDescription, BDescription, TDescription,
						DebitAccountID, CreditAccountID, Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
						VATObjectID,VATNo,VATObjectAddress,
						ExchangeRateCN,DueDate, Orders, EmployeeID, 
						Quantity, InventoryID, UnitID, Status, IsAudit, 
						SenderReceiver, SRAddress, SRDivisionName,OrderID, PeriodID, ProductID,
						CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
					Values (@TransactionID, @VoucherID, @VoucherID, @VoucherNo, @VoucherDate, 
						@InvoiceDate, @InvoiceNo, @Serial, @VATTypeID,@VoucherTypeID, @TranMonth, @TranYear, @DivisionID, 'T99', 'AT9000', 
						@CurrencyID, @CurrencyID,1, round(@OriginalAmount,@ConvertedDecimals), round(@OriginalAmount,@ConvertedDecimals), round(@ConvertedAmount,@ConvertedDecimals),
						Isnull(@ObjectID,'VANGLAI') ,Isnull(@CreditObjectID,'VANGLAI') , @ObjectName,
                                                                                                @VATGroupID,	@VDescription, @BDescription, @TDescription,  
						@DebitAccountID, @CreditAccountID, @Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, 
					                 Isnull(@ObjectID,'VANGLAI') , @VATNo, Null,
						1, Null, @Orders, @UserID,
						Null, Null, Null, 0, 0 ,
						Null,Null, Null,Null,Null,Null,
						@UserID, getdate(), @UserID, getdate())
		
					FETCH NEXT FROM @Tran_cur INTO  @DebitAccountID, @CreditAccountID,@OriginalAmount, @ConvertedAmount,
									@ObjectID, @ObjectName , @CreditObjectID, @VATNo, @VATGroupID, @VDescription, @BDescription, @TDescription, @SenderReceiver,
									@InvoiceDate, @InvoiceNo, @Serial,  @Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID
				End
		
   Close @Tran_cur


END