
/****** Object:  StoredProcedure [dbo].[AP1606]    Script Date: 07/28/2010 14:40:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1606]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1606]
GO

/****** Object:  StoredProcedure [dbo].[AP1606]    Script Date: 07/28/2010 14:40:21 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


---- Created by Nguyen Van Nhan, Date 25.12.2004
--- Purpose : Ket chuyen but toan phan bo cong cu dung cu vao so cai.
----Last edit Nguyen Van Nhan date 17/10/2007

/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
** Edited by: [GS] [Thanh Tùng] [13/12/2010]
***********************************************/
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần tiền hạch toán theo thiết lập đơn vị-chi nhánh


CREATE PROCEDURE [dbo].[AP1606] @DivisionID as nvarchar(50), 
				@TranMonth as int, 
				@TranYear as int, 
				@UserID as nvarchar(50)
		
 AS

Declare @Tool_cur as cursor,
	@DepreciationID nvarchar(50),
	@VoucherTypeID nvarchar(50), 
	@ToolID  nvarchar(50),
	@VoucherNo  nvarchar(50),
	@VoucherDate as Datetime,	
	@CreditAccountID  nvarchar(50),
	@DebitAccountID  nvarchar(50), @ConvertedAmount decimal(28,8), @Description as nvarchar(250),
	@Ana01ID  nvarchar(50), @Ana02ID  nvarchar(50), @Ana03ID  nvarchar(50), @PeriodID  nvarchar(50), @ObjectID  nvarchar(50),
	@TransactionID as nvarchar(50),
	@CurrencyID as nvarchar(50),
	@VoucherID as nvarchar(50)

Set @CurrencyID = (Select Top 1 BaseCurrencyID From AT1101 where DivisionID = @DivisionID)
Set @CurrencyID = isnull(@CurrencyID,'VND')
SET @Tool_cur = Cursor Scroll KeySet FOR 
	Select 	
		DebitAccountID, CreditAccountID, Sum(DepAmount) as ConvertedAmount,
		VoucherNo, VoucherTypeID, Description, VoucherDate,
		Ana01ID,              Ana02ID,              Ana03ID,             
		ObjectID,             PeriodID         
		
	From AT1604
	Where DivisionID =@DivisionID and
		TranMonth = @TranMonth and
		TranYear =@TranYear and
		Status =0
	Group by DebitAccountID, CreditAccountID, VoucherNo, VoucherTypeID, Description, VoucherDate,
		Ana01ID,              Ana02ID,             Ana03ID ,              ObjectID,             PeriodID         
OPEN	@Tool_cur
FETCH NEXT FROM @Tool_cur INTO  @DebitAccountID, @CreditAccountID, @ConvertedAmount,
		@VoucherNo, @VoucherTypeID, @Description, @VoucherDate,
		@Ana01ID,              @Ana02ID,              @Ana03ID,             
		@ObjectID,             @PeriodID     

WHILE @@Fetch_Status = 0
	Begin	
	Exec AP0000 @DivisionID, @VoucherID  OUTPUT, 'AT9000', 'AV', @TranYear ,'',15, 3, 0, '-'
	Exec AP0000 @DivisionID, @TransactionID  OUTPUT, 'AT1504', 'AT', @TranYear ,'',15, 3, 0, '-'
	Insert AT9000 	(TransactionID, TableID, BatchID, VoucherID, TDescription, BDescription, VDescription,
			CurrencyID, ExchangeRate, VoucherDate, VoucherTypeID, VoucherNo,
			TransactionTypeID, TranMOnth, TranYear, DivisionID,
			DebitAccountID, CreditAccountID, 
			Ana01ID, Ana02ID, Ana03ID,
			 OriginalAmount, ConvertedAmount, 
			CurrencyIDCN, OriginalAmountCN, ExchangeRateCN,
			CreateDate, CreateUserID, LastModifyDate, LastModifyUserID)

	Values 		( @TransactionID, 'AT1604', @VoucherID, @VoucherID, @Description, @Description, @Description,
			@CurrencyID, 1 , @VoucherDate, @VoucherTypeID, @VoucherNo,
			'T18', @TranMonth, @TranYear, @DivisionID,  --- But toan phan bo chi phi cong cu dung cu
			@DebitAccountID, @CreditAccountID, 
			@Ana01ID,              @Ana02ID,              @Ana03ID,             
			 @ConvertedAmount, @ConvertedAmount, 
			@CurrencyID, @ConvertedAmount, 1,
			GetDate(), @UserID, GetDate(), @UserID)

	FETCH NEXT FROM @Tool_cur INTO  @DebitAccountID, @CreditAccountID, @ConvertedAmount,
		@VoucherNo, @VoucherTypeID, @Description, @VoucherDate,
		@Ana01ID,              @Ana02ID,              @Ana03ID,             
		@ObjectID,             @PeriodID     

	End
CLOSE @Tool_cur
--------- Cap nhËt bót to¸n khÊu hao ®· ®­îc chuyÓn
Update AT1604 Set  Status =1
Where TranMonth = @TranMonth and
	TranYear = @TranYear and
	DivisionID =@DivisionID
GO

