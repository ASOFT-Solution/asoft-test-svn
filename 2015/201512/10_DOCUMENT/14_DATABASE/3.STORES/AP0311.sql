IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0311]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0311]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
------ 	Created by Nguyen Van Nhan. Date 25/04/2005
-----	Purpose: Giai tru cong no Ban tu dong Cong no phat Th
-----	Edit by: Nguyen Quoc Huy, Date 26/08/2008
---- Modified on 08/02/2012 by Le Thi Thu Hien : Bo sung them JOIN DivisionID
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [28/07/2010]
'**************************************************************/

CREATE PROCEDURE 	[dbo].[AP0311] 
			@DivisionID AS nvarchar(50),
			@UserID AS nvarchar(50),
			@GiveUpdate datetime,
			@GiveUpEmployeeID AS nvarchar(50),
			@AccountID AS nvarchar(50),
			@CurrencyID AS nvarchar(50),
			@FromObjectID AS nvarchar(50),
			@ToObjectID nvarchar(50),
			@FromMonth AS int,
			@FromYear AS int,
			@ToMonth AS int,
			@ToYear AS int,
			@FromDate AS Datetime,
			@ToDate AS Datetime,
			@IsDate tinyint,
			@Fomular AS tinyint, 	-------------- 	0 Uu tien cho Ngay hach toan. 
									-------------	1 Uu tien cho Ngay Dao han.
			@FromAna01ID AS nvarchar(50),
			@ToAna01ID AS nvarchar(50),
			@FromAna02ID AS nvarchar(50),
			@ToAna02ID AS nvarchar(50),
			@FromAna03ID AS nvarchar(50),
			@ToAna03ID AS nvarchar(50)



 AS
Set Nocount on

Declare @sSQL AS varchar(8000),
	@Invoice_cur AS cursor,
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
	@CrVoucherID AS nvarchar(50),
	@CrBatchID AS nvarchar(50),
	@CrTableID  AS nvarchar(50),
	@CrOriginalAmountRemain AS decimal(28,8),
	@CrConvertedAmountRemain AS decimal(28,8),
	@OriginalAmountRemain AS decimal(28,8),
	@ConvertedAmountRemain AS decimal(28,8),
	@GiveOriginal AS decimal(28,8)	,
	@GiveConverted AS decimal(28,8),
	@Ana02ID AS nvarchar(50)

	----- Insert Du lieu vao bang tam.
	Exec AP0300  	@DivisionID, @AccountID, @CurrencyID, @FromObjectID, @ToObjectID, 
					@FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate , @ToDate, @IsDate,
					@FromAna01ID, @ToAna01ID, @FromAna02ID,@ToAna02ID,@FromAna03ID,@ToAna03ID


	SET @Invoice_cur = Cursor Scroll KeySet FOR 	
		SELECT 	Ana02ID, VoucherID, BatchID, TableID, ObjectID, ConvertedAmount,
				OriginalAmountCN, RemainOriginal, RemainConverted, VoucherDate, DueDate
		FROM	AT0333
		WHERE 	D_C ='D' AND DivisionID = @DivisionID
		ORDER BY DueDate, VoucherDate

	Open @Invoice_cur
	FETCH NEXT FROM @Invoice_cur INTO  @Ana02ID, @VoucherID, @BatchID, @TableID, @ObjectID, @ConvertedAmount,
				@OriginalAmountCN , @OriginalAmountRemain, @ConvertedAmountRemain, @VoucherDate, @DueDate
			
	WHILE @@Fetch_Status = 0 
	 BEGIN

		EXEC AP0301 	@Ana02ID, @DivisionID,@AccountID, @CurrencyID,	@ObjectID, @ToYear, @GiveupDate, @GiveupEmployeeID,	@UserID,					
						@VoucherID, @BatchID,@TableID, @OriginalAmountRemain, @ConvertedAmountRemain , @VoucherDate

			FETCH NEXT FROM @Invoice_cur INTO @Ana02ID,  @VoucherID, @BatchID, @TableID, @ObjectID, @ConvertedAmount,
			@OriginalAmountCN , @OriginalAmountRemain, @ConvertedAmountRemain, @VoucherDate, @DueDate
			
	END 
		Close @Invoice_cur
		
SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

