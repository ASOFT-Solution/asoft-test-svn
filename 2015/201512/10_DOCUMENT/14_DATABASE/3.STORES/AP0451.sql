/****** Object:  StoredProcedure [dbo].[AP0451]    Script Date: 07/28/2010 17:40:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

------ 	Created by Nguyen Van Nhan. Date 26/09/2008
-----	Purpose: Giai tru cong no Ban tu dong Cong no phai tra
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [28/07/2010]
'********************************************/

ALTER PROCEDURE 	[dbo].[AP0451] @DivisionID as nvarchar(50),
				@UserID as nvarchar(50),
				@GiveUpdate datetime,
				@GiveUpEmployeeID as nvarchar(50),
				@AccountID as nvarchar(50),
				@CurrencyID as nvarchar(50),
				@FromObjectID as nvarchar(50),
				@ToObjectID nvarchar(50),
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int,
				@FromDate as Datetime,
				@ToDate as Datetime,
				@IsDate tinyint,			
				@Fomular as tinyint, 	-------------- 	 0 Uu tien cho Ngay hach toan. 
						-------------		1 Uu tien cho Ngay Dao han.
				@FromAna01ID as nvarchar(50),
				@ToAna01ID as nvarchar(50)
 AS
Set Nocount on

Declare @sSQL as nvarchar(4000),
	@Invoice_cur as cursor,
	@GiveUpID nvarchar(50),
	@VoucherID nvarchar(50), 
	@BatchID nvarchar(50),
	@TableID nvarchar(50),
	@ObjectID  nvarchar(50),	
	@ConvertedAmount decimal(28,8),
	@OriginalAmountCN decimal(28,8), 
	@GivedOriginalAmount  decimal(28,8),
	@GivedConvertedAmount  decimal(28,8),
	@VoucherDate Datetime,
	@DueDate Datetime,
	@CrVoucherID as nvarchar(50),
	@CrBatchID as nvarchar(50),
	@CrTableID  as nvarchar(50),
	@CrOriginalAmountRemain as decimal(28,8),
	@CrConvertedAmountRemain as decimal(28,8),
	@OriginalAmountRemain as decimal(28,8),
	@ConvertedAmountRemain as decimal(28,8),
	@GiveOriginal as decimal(28,8)	,
	@GiveConverted as decimal(28,8),
	@Ana01ID as nvarchar(50)

	----- Insert Du lieu vao bang tam.
	Exec AP0450  	@DivisionID, @AccountID, @CurrencyID, @FromObjectID, @ToObjectID, 
			@FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate , @ToDate, @IsDate,
			@FromAna01ID, @ToAna01ID


	SET @Invoice_cur = Cursor Scroll KeySet FOR 	
		Select 	 Ana01ID, VoucherID, BatchID, TableID, ObjectID, ConvertedAmount,
			OriginalAmountCN, RemainOriginal, RemainConverted, VoucherDate, DueDate
		From AT0333
		Where 	D_C ='C' and DivisionID = @DivisionID
		Order by DueDate, VoucherDate

	Open @Invoice_cur
	FETCH NEXT FROM @Invoice_cur INTO  @Ana01ID, @VoucherID, @BatchID, @TableID, @ObjectID, @ConvertedAmount,
	@OriginalAmountCN , @OriginalAmountRemain, @ConvertedAmountRemain, @VoucherDate, @DueDate
			
	WHILE @@Fetch_Status = 0 
	 BEGIN
			----print 'VoucherID ='+@VoucherID+ '   Con lai: '+str(@OriginalAmountRemain)

		EXEC AP0452 	@Ana01ID, @DivisionID,@AccountID, @CurrencyID,	@ObjectID, @ToYear, @GiveupDate, @GiveupEmployeeID,	@UserID,					
				@VoucherID, @BatchID,@TableID, @OriginalAmountRemain, @ConvertedAmountRemain 

			FETCH NEXT FROM @Invoice_cur INTO @Ana01ID,  @VoucherID, @BatchID, @TableID, @ObjectID, @ConvertedAmount,
			@OriginalAmountCN , @OriginalAmountRemain, @ConvertedAmountRemain, @VoucherDate, @DueDate
			
	END 
		Close @Invoice_cur
Set Nocount off