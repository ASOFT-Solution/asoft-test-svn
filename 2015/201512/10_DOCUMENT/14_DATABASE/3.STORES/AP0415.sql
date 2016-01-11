
/****** Object:  StoredProcedure [dbo].[AP0415]    Script Date: 07/28/2010 14:12:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





---- Xu ly but toan chenh lech ty gia  cho cac phieu no phai thu va phai tra
------ Created by Nguyen Thi Ngoc Minh, Date 01/07/2004, 
----- Lasted Update by Van Nhan, date 29/12/2007
----- Update by : Dang Le Bao Quynh; Date 19/03/2009
----- Purpose: Them dieu kien xu ly cho hoa don giai tru
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [28/07/2010]
					[Hoang Phuoc] [05/11/2010]
					Noi dung: AP0000  @NewVoucherID OUTPUT, 'AT9000', 'CV', @TranYear ,'',15, 3, 0, '-'
						sua thanh AP0000  @Division, @NewVoucherID OUTPUT, 'AT9000', 'CV', @TranYear ,'',15, 3, 0, '-'
'********************************************/

ALTER PROCEDURE [dbo].[AP0415] 	@DivisionID nvarchar(50), 
				@TranMonth as int, 
				@TranYear as int, 
				@UserID as nvarchar(50),
				@VoucherDate as datetime,
				@VoucherNo as nvarchar(50),
				@VoucherTypeID as nvarchar(50),
				@LossDiffAcc as nvarchar(50),
				@InterestDiffAcc as nvarchar(50),
				@Description as nvarchar(250),
				@IsGiveUp as tinyint,  --- bo sung them
				@AccountID as nvarchar(50),
				@CurrencyID as nvarchar(50),
				@FromObjectID as nvarchar(50),
				@ToObjectID as nvarchar(50)
				


 AS
Declare 
	@CMonth as nvarchar(20),
	@CYear as nvarchar(20),
	@NewVoucherID as nvarchar(50),
	@AccountGroupID as nvarchar(50)

Select @AccountGroupID = GroupID From AT1005 Where AccountID =@AccountID

Set @CMonth =  Case when @TranMonth < 10 then '0' + ltrim(str(@TranMonth))
							else ltrim(str(@TranMonth)) end
Set  @CYear = str(@TranYear)

Exec AP0000  @DivisionID, @NewVoucherID OUTPUT, 'AT9000', 'CV', @TranYear ,'',15, 3, 0, '-'
If @IsGiveUp<>0 
Begin
	---- Chenh lech ty gi cong no phat thu
	 Exec AP0416 	@DivisionID, @TranMonth,@TranYear, @UserID, @VoucherDate, @VoucherNo,@VoucherTypeID,	@LossDiffAcc,@InterestDiffAcc,	@Description, @NewVoucherID, @FromObjectID, @ToObjectID, @AccountID, @CurrencyID
	---- Chenh lech ty gi cong no phat Tra
	 Exec AP0417 	@DivisionID, @TranMonth,@TranYear, @UserID, @VoucherDate, @VoucherNo,@VoucherTypeID,	@LossDiffAcc,@InterestDiffAcc,	@Description, @NewVoucherID, @FromObjectID, @ToObjectID, @AccountID, @CurrencyID
End
Else
Begin

	If @AccountGroupID='G03' -- phai thu
		 Exec AP0426 	@DivisionID, @TranMonth,@TranYear, @UserID, @VoucherDate, @VoucherNo,@VoucherTypeID,	@LossDiffAcc,@InterestDiffAcc,	
		@Description, @NewVoucherID, @FromObjectID ,@ToObjectID, @AccountID, @CurrencyID
	If @AccountGroupID='G04'  -- phai tra
		 Exec AP0427 	@DivisionID, @TranMonth,@TranYear, @UserID, @VoucherDate, @VoucherNo,@VoucherTypeID,	@LossDiffAcc,@InterestDiffAcc,	
			@Description, @NewVoucherID,  @FromObjectID, @ToObjectID, @AccountID, @CurrencyID

End