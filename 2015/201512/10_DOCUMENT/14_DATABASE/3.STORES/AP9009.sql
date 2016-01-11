IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP9009]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP9009]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--------- Created by Nguyen Van Nhan. Date 29.06.2004
--------- Insert but toan phan bo.
---- Modified on 21/02/2012 by Lê Thị Thu Hiền : Bổ sung format số lẻ
/********************************************
'* Edited by: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần tiền hạch toán theo thiết lập đơn vị-chi nhánh

CREATE PROCEDURE [dbo].[AP9009]
	 	
		@DivisionID nvarchar(50),			
		@TranMonth tinyint,			
		@TranYear smallint,
		@VoucherID nvarchar(50),	
		@VoucherTypeID nvarchar(50), 		
		@VoucherNo nvarchar(50),		
		@VoucherDate as Datetime,
		@VDescription as nvarchar(250), 		
		@BDescription as nvarchar(250), 		
		@TDescription as nvarchar(250),
		@DebitAccountID nvarchar(50),		
		@CreditAccountID nvarchar(50),  		
		@Ana01ID as  nvarchar(50),@Ana02ID as  nvarchar(50),@Ana03ID as  nvarchar(50),@Ana04ID as  nvarchar(50),@Ana05ID as  nvarchar(50),
		@ConvertedAmount decimal(28,8),
		@CreateUserID nvarchar(50),
		@LastModifyUserID nvarchar(50)

AS

--Print 	'@DebitAccountID '+@DebitAccountID+' @CreditAccountID :'+@CreditAccountID+' @ConvertedAmount+ '+str(@ConvertedAmount)


SET NOCOUNT ON



DECLARE
	@BatchID as nvarchar(50),
	@TransactionID as nvarchar(50),
	@CurrencyID as nvarchar(50)
	

	SELECT @CurrencyID = BaseCurrencyID
	FROM	AT1101
	WHERE DivisionID = @DivisionID

Exec AP0000  @DivisionID,@TransactionID OUTPUT, 'AT9001', 'AT', @TranYear ,'',15, 3, 0, '-'
SET @BatchID = @TransactionID
------------>> Format số lẻ	
DECLARE	@OriginalDecimal AS TINYINT,
		@ConvertedDecimals AS TINYINT
SET @OriginalDecimal = ISNULL((SELECT TOP 1 OriginalDecimal FROM AV1004 WHERE CurrencyID = @CurrencyID AND DivisionID = @DivisionID),0)
SET @ConvertedDecimals = ISNULL((SELECT TOP 1 ConvertedDecimals FROM AV1004 WHERE CurrencyID = @CurrencyID AND DivisionID = @DivisionID),0)
------------<< Format số l
While  Exists (Select 1 From AT9000 Where TableID ='AT9001' and TransactionID =@TransactionID)
	Begin
		Exec AP0000  @DivisionID, @TransactionID OUTPUT, 'AT9001', 'AT', @TranYear ,'',15, 3, 0, '-'
		SET @BatchID = @TransactionID
	End
INSERT INTO AT9001 (
	VoucherID, TransactionID,	 LastModifyDate,
	BatchID,	TransactionTypeID,
	CreateUserID,	LastModifyUserID,
	TranMonth,	TranYear,
	
	DebitAccountID, 	CreditAccountID, Ana01ID,Ana02ID,Ana03ID,Ana04ID,Ana05ID,
	CurrencyID,	
	VoucherNo,	VoucherTypeID,
	ObjectID,
	Description,	
	ConvertedAmount,	ExchangeRate,	OriginalAmount,
	DivisionID,
	
	VoucherDate	
	)
VALUES	(@VoucherID,
	@TransactionID, 
	convert(char,getdate(),101),				
	@BatchID,
	'T98',	---- But toan ket chuyen
	@CreateUserID,	@LastModifyUserID,
	@TranMonth,	@TranYear,
	
	@DebitAccountID,	@CreditAccountID, @Ana01ID, @Ana02ID,@Ana03ID,@Ana04ID,@Ana05ID,
	@CurrencyID,				
	@VoucherNo,	@VoucherTypeID,			
	NULL,					
	@VDescription, 
	ROUND(@ConvertedAmount,@ConvertedDecimals), 1,	ROUND(@ConvertedAmount,@OriginalDecimal),			
	@DivisionID,
					-- Module Table Name
	@VoucherDate)


SET NOCOUNT OFF












GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

