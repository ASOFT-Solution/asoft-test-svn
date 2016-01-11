IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP03031_ST]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP03031_ST]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


------ Created by Khanh Van
------ Modify by Phuong Thao on 14/10/2015 : Bo sung giai tru theo ma phan tich (Customize Sieu Thanh)

CREATE PROCEDURE [dbo].[AP03031_ST]	
					@DivisionID nvarchar(50), 
					@AccountID nvarchar(50), 
					@CurrencyID nvarchar(50), 
					@ObjectID nvarchar(50), 			
					@TranYear int, 							
					@GiveupDate AS Datetime,
					@GiveupEmployeeID AS nvarchar(50),
					@UserID AS nvarchar(50),
					@VoucherID nvarchar(50), 
					@BatchID nvarchar(50), 
					@TableID nvarchar(50), 
					@OriginalAmountRemain decimal (28,8),
					@ConvertedAmountRemain decimal (28,8),
					@TVoucherID nvarchar(50), 
					@TBatchID nvarchar(50),
					@Ana01ID Nvarchar(50) = '',
					@Ana02ID Nvarchar(50) = '',
					@Ana03ID Nvarchar(50) = '',
					@Ana04ID Nvarchar(50) = '',
					@Ana05ID Nvarchar(50) = '',
					@Ana06ID Nvarchar(50) = '',
					@Ana07ID Nvarchar(50) = '',
					@Ana08ID Nvarchar(50) = '',
					@Ana09ID Nvarchar(50) = '',
					@Ana10ID Nvarchar(50) = ''
AS			

Declare @GiveUpID nvarchar(50),	
		@CrTableID  AS nvarchar(50),
		@CreditVoucherDate Datetime,
		@TransactionTypeID as nvarchar(50),
		@VatConvertedAmount decimal (28,8),
		@VATOriginalAmount decimal (28,8),
		@Temp as nvarchar(50),
		@IsMultiTax as int,
		@Cor_cur as cursor,
		@VoucherDate Datetime

SET @CrTableID =''


	Select top 1  @CreditVoucherDate = voucherdate, @CrTableID = TableID from AT9000 where VoucherID =@VoucherID and DivisionID = @DivisionID and BatchID=@BatchID
	Select @IsMultiTax = MAX(ISNULL(IsMultiTax,0)) from AT9000 where DivisionID=@DivisionID and VoucherID = @VoucherID	
	IF ISNULL(@TVoucherID,'') <>''	and ISNULL(@TBatchID,'')<>''
	Begin
		SELECT  	@VoucherDate = VoucherDate
		FROM	AT9000	 
		Where VoucherID =@TVoucherID and DivisionID = @DivisionID 
		
		SET @Cor_cur = Cursor Scroll KeySet FOR 
		SELECT top 1(select top 1 TransactionTypeID From AT9000 a where a.VoucherID=b.TVoucherID and a.DivisionID=b.DivisionID)
		FROM AT9000 b
		Where VoucherID = @VoucherID and DivisionID = @DivisionID and BatchID=@BatchID and isnull(b.TvoucherID,'')<>''
		Group by b.TVoucherID, b.DivisionID, TransactionTypeID
		
		OPEN	@Cor_cur
		FETCH NEXT FROM @Cor_cur INTO   @TransactionTypeID
		WHILE @@Fetch_Status = 0
		Begin
		Exec AP0000  @DivisionID, @GiveUpID  OUTPUT, 'AT0303', 'G', @TranYear ,'',18, 3, 0, '-'
		
		If @TransactionTypeID in ('T01','T21')
		Begin
		INSERT AT0303 	(GiveUpID,  GiveUpDate, GiveUpEmployeeID, DivisionID,
						ObjectID, AccountID, CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID,
						CreditVoucherID, CreditBatchID, CreditTableID,
						OriginalAmount ,ConvertedAmount, DebitVoucherDate, CreditVoucherDate,
						CreateDate, CreateUseID, LastModifyDate, LastModifyUserID,
						Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, 
						Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID)

		VALUES (	@GiveUpID,  @GiveUpDate, @GiveUpEmployeeID, @DivisionID,
					@ObjectID, @AccountID, @CurrencyID, @VoucherID, @BatchID, @CrTableID,
					@TVoucherID, @TBatchID, @TableID,
					@OriginalAmountRemain , @ConvertedAmountRemain, @CreditVoucherDate, @VoucherDate,
					getdate(), @UserID, getdate(), @UserID,
					@Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, 
					@Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID)				
					
					
				UPDATE	AT9000 
				SET		Status = 1
				WHERE 	DivisionID = @DivisionID AND VoucherID =@TVoucherID AND	
						BatchID =@TBatchID AND TableID = @TableID AND ObjectID = @ObjectID				
						AND CurrencyIDCN = @CurrencyID AND Status = 0
						AND Isnull(Ana01ID,'') = Isnull(@Ana01ID,'') 
						AND Isnull(Ana02ID,'') = Isnull(@Ana02ID,'') 
						AND Isnull(Ana03ID,'') = Isnull(@Ana03ID,'') 
						AND Isnull(Ana04ID,'') = Isnull(@Ana04ID,'') 
						AND Isnull(Ana05ID,'') = Isnull(@Ana05ID,'') 
						AND Isnull(Ana06ID,'') = Isnull(@Ana06ID,'') 
						AND Isnull(Ana07ID,'') = Isnull(@Ana07ID,'') 
						AND Isnull(Ana08ID,'') = Isnull(@Ana08ID,'') 
						AND Isnull(Ana09ID,'') = Isnull(@Ana09ID,'') 
						AND Isnull(Ana10ID,'') = Isnull(@Ana10ID,'') 
						
				UPDATE	AT9000 
				SET		Status = 1
				WHERE 	DivisionID = @DivisionID AND VoucherID = @VoucherID AND	
						BatchID =@BatchID AND TableID = @CrTableID AND 
						ObjectID  = @ObjectID 
						AND CurrencyIDCN = @CurrencyID AND Status = 0
						AND Isnull(Ana01ID,'') = Isnull(@Ana01ID,'') 
						AND Isnull(Ana02ID,'') = Isnull(@Ana02ID,'') 
						AND Isnull(Ana03ID,'') = Isnull(@Ana03ID,'') 
						AND Isnull(Ana04ID,'') = Isnull(@Ana04ID,'') 
						AND Isnull(Ana05ID,'') = Isnull(@Ana05ID,'') 
						AND Isnull(Ana06ID,'') = Isnull(@Ana06ID,'') 
						AND Isnull(Ana07ID,'') = Isnull(@Ana07ID,'') 
						AND Isnull(Ana08ID,'') = Isnull(@Ana08ID,'') 
						AND Isnull(Ana09ID,'') = Isnull(@Ana09ID,'') 
						AND Isnull(Ana10ID,'') = Isnull(@Ana10ID,'') 
					
		End
		Else
		Begin
			If @IsMultiTax <>1 
			Begin
				INSERT AT0303 	(GiveUpID,  GiveUpDate, GiveUpEmployeeID, DivisionID,
						ObjectID, AccountID, CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID,
						CreditVoucherID, CreditBatchID, CreditTableID,
						OriginalAmount ,ConvertedAmount, DebitVoucherDate, CreditVoucherDate,
						CreateDate, CreateUseID, LastModifyDate, LastModifyUserID, 
						Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, 
						Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID)

				VALUES (	@GiveUpID,  @GiveUpDate, @GiveUpEmployeeID, @DivisionID,
					@ObjectID, @AccountID, @CurrencyID, @TVoucherID, @TBatchID, @TableID,
					@VoucherID, @BatchID, @CrTableID,
					@OriginalAmountRemain , @ConvertedAmountRemain, @VoucherDate, @CreditVoucherDate,
					getdate(), @UserID, getdate(), @UserID,
					@Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, 
					@Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID)
					
			End
			Else
			Begin
			Set @VATOriginalAmount = (Select top 1 VATOriginalAmount from AT9000 where DivisionID =@DivisionID and VoucherID =@VoucherID and BatchID = @BatchID and OriginalAmount =@OriginalAmountRemain)
			Set @VatConvertedAmount = (Select top 1 VatConvertedAmount from AT9000 where DivisionID =@DivisionID and VoucherID =@VoucherID and BatchID = @BatchID and ConvertedAmount =@ConvertedAmountRemain)	
			Set @Temp = (Select top 1 TransactionTypeID from AT9000 where DivisionID =@DivisionID and VoucherID =@VoucherID and BatchID = @BatchID and ConvertedAmount =@ConvertedAmountRemain)
			If	@Temp <>'T34'
			Begin			
				INSERT AT0303 	(GiveUpID,  GiveUpDate, GiveUpEmployeeID, DivisionID,
						ObjectID, AccountID, CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID,
						CreditVoucherID, CreditBatchID, CreditTableID,
						OriginalAmount ,ConvertedAmount, DebitVoucherDate, CreditVoucherDate,
						CreateDate, CreateUseID, LastModifyDate, LastModifyUserID,
						Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, 
						Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID)

				VALUES (	@GiveUpID,  @GiveUpDate, @GiveUpEmployeeID, @DivisionID,
					@ObjectID, @AccountID, @CurrencyID, @TVoucherID, @TBatchID, @TableID,
					@VoucherID, @BatchID, @CrTableID,
					@OriginalAmountRemain+@VATOriginalAmount , @ConvertedAmountRemain+@VatConvertedAmount, @VoucherDate, @CreditVoucherDate,
					getdate(), @UserID, getdate(), @UserID,
					@Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, 
					@Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID)			
			End
			End			
				UPDATE	AT9000 
				SET		Status = 1
				WHERE 	DivisionID = @DivisionID AND VoucherID =@TVoucherID AND	
						BatchID =@TBatchID AND TableID = @TableID AND 
						(Case when TransactionTypeID <>'T99' then ObjectID Else CreditObjectID End) = @ObjectID							
						AND CurrencyIDCN = @CurrencyID AND Status = 0
						AND Isnull(Ana01ID,'') = Isnull(@Ana01ID,'') 
						AND Isnull(Ana02ID,'') = Isnull(@Ana02ID,'') 
						AND Isnull(Ana03ID,'') = Isnull(@Ana03ID,'') 
						AND Isnull(Ana04ID,'') = Isnull(@Ana04ID,'') 
						AND Isnull(Ana05ID,'') = Isnull(@Ana05ID,'') 
						AND Isnull(Ana06ID,'') = Isnull(@Ana06ID,'') 
						AND Isnull(Ana07ID,'') = Isnull(@Ana07ID,'') 
						AND Isnull(Ana08ID,'') = Isnull(@Ana08ID,'') 
						AND Isnull(Ana09ID,'') = Isnull(@Ana09ID,'') 
						AND Isnull(Ana10ID,'') = Isnull(@Ana10ID,'') 						
						
				UPDATE	AT9000 
				SET		Status = 1
				WHERE 	DivisionID = @DivisionID AND VoucherID = @VoucherID AND	
						BatchID =@BatchID AND TableID = @CrTableID AND 
						(Case when TransactionTypeID <>'T99' then ObjectID Else CreditObjectID End) = @ObjectID 
						AND CurrencyIDCN = @CurrencyID AND Status = 0
						AND Isnull(Ana01ID,'') = Isnull(@Ana01ID,'') 
						AND Isnull(Ana02ID,'') = Isnull(@Ana02ID,'') 
						AND Isnull(Ana03ID,'') = Isnull(@Ana03ID,'') 
						AND Isnull(Ana04ID,'') = Isnull(@Ana04ID,'') 
						AND Isnull(Ana05ID,'') = Isnull(@Ana05ID,'') 
						AND Isnull(Ana06ID,'') = Isnull(@Ana06ID,'') 
						AND Isnull(Ana07ID,'') = Isnull(@Ana07ID,'') 
						AND Isnull(Ana08ID,'') = Isnull(@Ana08ID,'') 
						AND Isnull(Ana09ID,'') = Isnull(@Ana09ID,'') 
						AND Isnull(Ana10ID,'') = Isnull(@Ana10ID,'') 
		End
			
		FETCH NEXT FROM @Cor_cur INTO  @TransactionTypeID
		End
	Close @Cor_cur
						
End
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
