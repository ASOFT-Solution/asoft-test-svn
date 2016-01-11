IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP03031]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP03031]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


------ Created by Khanh Van
------ Modify by Phuong Thao on 14/10/2015 : Bo sung giai tru theo ma phan tich (Customize Sieu Thanh)

CREATE PROCEDURE [dbo].[AP03031]	
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
		@VoucherDate Datetime,
		@CustomerName INT

CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)
IF @CustomerName = 16 --- Customize Sieu Thanh
	EXEC AP03031_ST @DivisionID, @AccountID, @CurrencyID, @ObjectID, @TranYear, @GiveupDate, @GiveupEmployeeID, @UserID, 
					@VoucherID, @BatchID, @TableID, @OriginalAmountRemain, @ConvertedAmountRemain, @TVoucherID, @TBatchID,
					@Ana01ID ,	@Ana02ID ,	@Ana03ID ,	@Ana04ID ,	@Ana05ID ,
					@Ana06ID ,	@Ana07ID ,	@Ana08ID ,	@Ana09ID ,	@Ana10ID 

ELSE
BEGIN
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
						CreateDate, CreateUseID, LastModifyDate, LastModifyUserID)

		VALUES (	@GiveUpID,  @GiveUpDate, @GiveUpEmployeeID, @DivisionID,
					@ObjectID, @AccountID, @CurrencyID, @VoucherID, @BatchID, @CrTableID,
					@TVoucherID, @TBatchID, @TableID,
					@OriginalAmountRemain , @ConvertedAmountRemain, @CreditVoucherDate, @VoucherDate,
					getdate(), @UserID, getdate(), @UserID)
					
				UPDATE	AT9000 
				SET		Status = 1
				WHERE 	DivisionID = @DivisionID AND VoucherID =@TVoucherID AND	
						BatchID =@TBatchID AND TableID = @TableID AND 
						ObjectID = @ObjectID				
						AND CurrencyIDCN = @CurrencyID AND Status = 0
						
				UPDATE	AT9000 
				SET		Status = 1
				WHERE 	DivisionID = @DivisionID AND VoucherID = @VoucherID AND	
						BatchID =@BatchID AND TableID = @CrTableID AND 
						ObjectID  = @ObjectID 
						AND CurrencyIDCN = @CurrencyID AND Status = 0
					
		End
		Else
		Begin
			If @IsMultiTax <>1 
			Begin
				INSERT AT0303 	(GiveUpID,  GiveUpDate, GiveUpEmployeeID, DivisionID,
						ObjectID, AccountID, CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID,
						CreditVoucherID, CreditBatchID, CreditTableID,
						OriginalAmount ,ConvertedAmount, DebitVoucherDate, CreditVoucherDate,
						CreateDate, CreateUseID, LastModifyDate, LastModifyUserID)

				VALUES (	@GiveUpID,  @GiveUpDate, @GiveUpEmployeeID, @DivisionID,
					@ObjectID, @AccountID, @CurrencyID, @TVoucherID, @TBatchID, @TableID,
					@VoucherID, @BatchID, @CrTableID,
					@OriginalAmountRemain , @ConvertedAmountRemain, @VoucherDate, @CreditVoucherDate,
					getdate(), @UserID, getdate(), @UserID)
					
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
						CreateDate, CreateUseID, LastModifyDate, LastModifyUserID)

				VALUES (	@GiveUpID,  @GiveUpDate, @GiveUpEmployeeID, @DivisionID,
					@ObjectID, @AccountID, @CurrencyID, @TVoucherID, @TBatchID, @TableID,
					@VoucherID, @BatchID, @CrTableID,
					@OriginalAmountRemain+@VATOriginalAmount , @ConvertedAmountRemain+@VatConvertedAmount, @VoucherDate, @CreditVoucherDate,
					getdate(), @UserID, getdate(), @UserID)			
			End
			End
				UPDATE	AT9000 
				SET		Status = 1
				WHERE 	DivisionID = @DivisionID AND VoucherID =@TVoucherID AND	
						BatchID =@TBatchID AND TableID = @TableID AND 
						(Case when TransactionTypeID <>'T99' then ObjectID Else CreditObjectID End) = @ObjectID							AND CurrencyIDCN = @CurrencyID AND Status = 0
						
				UPDATE	AT9000 
				SET		Status = 1
				WHERE 	DivisionID = @DivisionID AND VoucherID = @VoucherID AND	
						BatchID =@BatchID AND TableID = @CrTableID AND 
						(Case when TransactionTypeID <>'T99' then ObjectID Else CreditObjectID End) = @ObjectID 
						AND CurrencyIDCN = @CurrencyID AND Status = 0
		End
			
		FETCH NEXT FROM @Cor_cur INTO  @TransactionTypeID
		End
	Close @Cor_cur
						
End
END
GO


