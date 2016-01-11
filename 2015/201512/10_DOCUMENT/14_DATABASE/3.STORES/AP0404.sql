IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0404]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0404]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- 	Created by Nguyen Van Nhan, Date 15/11/2003
----- 	Purpose: Xoa but toan giai tru cong no phai tra
---- Modified on 11/10/2011 by Le Thi Thu Hien : Xoa but toan chenh lech No tu CreditObjectID -> ObjectID
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [28/07/2010]
'********************************************/


CREATE PROCEDURE [dbo].[AP0404] 
		@DivisionID nvarchar(50), 
		@VoucherID nvarchar(50),
		@BatchID AS nvarchar(50),
		@TableID AS  nvarchar(50),
		@ObjectID nvarchar(50),
		@CurrencyID nvarchar(50),
		@AccountID nvarchar(50),
		@D_C AS nvarchar(1)  ---- 'D' neu la o phieu PS NO
							--- 'C' neu la phat sinh co

 AS

DECLARE @CorVoucherID AS nvarchar(50),
		@CorBatchID AS nvarchar(50),
		@CorTableID AS nvarchar(50),
		@OriginalAmount AS decimal (28,8),
		@GivedOriginalAmount AS decimal (28,8),
		@Cor_cur AS cursor


IF @D_C ='D'   ---- Truong ho o ben No bo giai tru ----------------------------------------------------------------
BEGIN
	SET @Cor_cur = Cursor Scroll KeySet FOR 
	SELECT 	CreditVoucherID, CreditBatchID, CreditTableID,  Sum(OriginalAmount)
	FROM	AT0404 
	WHERE	DebitVoucherID = @VoucherID  AND
			DebitBatchID = @BatchID AND
			DebitTableID = @TableID AND
			AccountID =@AccountID AND
			ObjectID = @ObjectID AND
			DivisionID =@DivisionID AND
			CurrencyID =@CurrencyID

	GROUP BY CreditVoucherID, CreditBatchID, CreditTableID

	OPEN	@Cor_cur
	FETCH NEXT FROM @Cor_cur INTO  @CorVoucherID,  @CorBatchID,  @CorTableID, @OriginalAmount
	WHILE @@Fetch_Status = 0
	BEGIN	
			SET @GivedOriginalAmount =0
			SET @GivedOriginalAmount  = (	SELECT Sum(isnull(OriginalAmount,0)) 
											FROM  AT0404 
			                             	WHERE 	DivisionID = @DivisionID AND
													ObjectID = @ObjectID  AND
													CreditVoucherID = @CorVoucherID AND
													CreditBatchID = @CorBatchID AND
													CreditTableID = @CorTableID AND
													AccountID = @AccountID AND
													CurrencyID =  @CurrencyID
										)			
			IF @GivedOriginalAmount = @OriginalAmount	
			UPDATE	AT9000 
			SET		Status = 0
			WHERE 	DivisionID = @DivisionID AND
					VoucherID = @CorVoucherID AND
					BatchID = @CorBatchID AND
					TableID = @CorTableID AND 
					(Case When TransactionTypeID ='T99' then CreditObjectID else ObjectID end) = @ObjectID AND 
					CreditAccountID =@AccountID AND
					CurrencyIDCN = @CurrencyID
		
			DELETE AT9000 
			WHERE	(VoucherID = @CorVoucherID or VoucherID = @VoucherID)  AND
					(BatchID = @CorBatchID or BatchID = @BatchID) AND
					(TableID = @CorTableID or TableID = @TableID) AND
					TransactionTypeID = 'T10' AND
					ObjectID = @ObjectID AND
					DivisionID = @DivisionID AND
					CurrencyID = @CurrencyID
		--Print '@CorVoucherID   '+@CorVoucherID

		FETCH NEXT FROM @Cor_cur INTO  @CorVoucherID ,  @CorBatchID ,  @CorTableID, @OriginalAmount
	End

	Close @Cor_cur



	
	DELETE	AT0404 
	WHERE 	DebitVoucherID = @VoucherID  AND
			DebitBatchID = @BatchID AND
			DebitTableID = @TableID AND
			AccountID =@AccountID AND
			ObjectID = @ObjectID AND
			DivisionID =@DivisionID AND
			CurrencyID =@CurrencyID
	--- Cap nhat trang thai
	
	UPDATE	AT9000 
	SET		Status = 0
	WHERE 	DivisionID = @DivisionID AND
			VoucherID =@VoucherID AND
			TableID = @TableID AND 
			ObjectID = @ObjectID AND
			BatchID =@BatchID AND
			DebitAccountID =@AccountID AND
			CurrencyIDCN = @CurrencyID
	

	
	
END
IF  @D_C ='C'   ----------------------------- Truong hop o ben Co bo giai tru cong no -------------------------------------------------------------------------------------------------
BEGIN

SET @Cor_cur = Cursor Scroll KeySet FOR 
	SELECT 	DebitVoucherID, DebitBatchID, DebitTableID,  Sum(OriginalAmount)
	FROM	AT0404 
	WHERE 	CreditVoucherID = @VoucherID  AND
			CreditBatchID = @BatchID AND
			CreditTableID = @TableID AND
			AccountID =@AccountID AND
			ObjectID = @ObjectID AND
			DivisionID =@DivisionID AND
			CurrencyID =@CurrencyID

	GROUP BY DebitVoucherID, DebitBatchID, DebitTableID  

	OPEN	@Cor_cur
	FETCH NEXT FROM @Cor_cur INTO  @CorVoucherID,  @CorBatchID,  @CorTableID, @OriginalAmount
	WHILE @@Fetch_Status = 0
	BEGIN	
			SET @GivedOriginalAmount =0
			SET @GivedOriginalAmount  = (	SELECT	SUM(ISNULL(OriginalAmount,0)) 
											FROM	AT0404 
			                             	WHERE 	DivisionID = @DivisionID AND
													ObjectID = @ObjectID  AND
													DebitVoucherID = @CorVoucherID AND
													DebitBatchID = @CorBatchID AND
													DebitTableID = @CorTableID AND
													AccountID = @AccountID AND
													CurrencyID =  @CurrencyID)			
			IF @GivedOriginalAmount = @OriginalAmount	
			UPDATE	AT9000 
			SET		Status = 0
			WHERE 	DivisionID = @DivisionID AND
					VoucherID = @CorVoucherID AND
					BatchID = @CorBatchID AND
					TableID = @CorTableID AND 
					ObjectID = @ObjectID AND 
					DebitAccountID =@AccountID AND
					CurrencyIDCN = @CurrencyID

			DELETE	AT9000 
			WHERE	(VoucherID = @CorVoucherID or VoucherID = @VoucherID)  AND
					(BatchID = @CorBatchID or BatchID = @BatchID) AND
					(TableID = @CorTableID or TableID = @TableID) AND
					TransactionTypeID = 'T10' AND
					ObjectID = @ObjectID AND
					DivisionID = @DivisionID AND
					CurrencyID = @CurrencyID
		--Print '@CorVoucherID   '+@CorVoucherID

		FETCH NEXT FROM @Cor_cur INTO  @CorVoucherID ,  @CorBatchID ,  @CorTableID, @OriginalAmount
	End

	Close @Cor_cur





	DELETE	AT0404
	WHERE 	CreditVoucherID = @VoucherID  AND
			CreditBatchID = @BatchID AND
			CreditTableID = @TableID AND
			AccountID =@AccountID AND
			ObjectID = @ObjectID AND
			DivisionID =@DivisionID AND
			CurrencyID =@CurrencyID
	--- Cap nhat trang thai
	UPDATE	AT9000 
	SET		Status = 0
	WHERE 	DivisionID = @DivisionID AND
			VoucherID =@VoucherID AND
			BatchID =@BatchID AND
			TableID = @TableID AND 
			(Case When TransactionTypeID ='T99' then CreditObjectID else ObjectID end) = @ObjectID AND 
			CreditAccountID =@AccountID AND
			CurrencyIDCN = @CurrencyID


End
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

