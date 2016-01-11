/****** Object:  StoredProcedure [dbo].[AP9006]    Script Date: 08/02/2010 15:03:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


------- Created By Nguyen Van Nhan.
------ Date 29.06.2004.
------- Chay but toan phan bo. theo ma phan tich (phuc vu viec quyet toan cong trinh)
----- Edited by Bao Anh		Date: 03/11/2012
----- Purpose: Sua loi ket chuyen len nhieu dong va so tien bi cong don khi thiet lap co nhieu MPT
----- Edited by Bao Anh		Date: 17/12/2012
----- Purpose: Sua loi khong thuc hien ket chuyen doi voi cac phieu phan bo theo MPT va tu 154 -> 155
----- Edited by Bao Anh		Date: 24/01/2013
----- Purpose: Sua loi khong thuc hien ket chuyen doi voi cac phieu co du lieu o cac MPT 2,3,4,5
----- Modify on 08/10/2014 by Bảo Anh: Sửa lỗi kết chuyển sai khi cần kết chuyển số lớn hơn
/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP9006]
			@AllocationID nvarchar(50),	
			@DivisionID nvarchar(50),
			@TranMonth as int,	
			@TranYear as int,
			@VoucherTypeID as nvarchar(50),	
			@VoucherNo as nvarchar(50), 
			@VoucherDate datetime,
			@VDescription as nvarchar(250), 
			@BDescription as nvarchar(250), 
			@TDescription as nvarchar(250),
			@SourceAccountIDFrom as nvarchar(50),	
			@SourceAccountIDTo as nvarchar(50),
			@TargetAccountID as nvarchar(50),
			@SourceAmountID as tinyint,
			@AllocationMode as tinyint,			
			@Percentage as decimal(28,8),
			@SequenceDesc as nvarchar(250),
			@CreateUserID as nvarchar(50),
			@LastModifyUserID as nvarchar(50),
			@Ana01ID as nvarchar(50),
			@Ana02ID as nvarchar(50),
			@Ana03ID as nvarchar(50),
			@Ana04ID as nvarchar(50),
			@Ana05ID as nvarchar(50)
AS

SET NOCOUNT ON

DECLARE
	@TranPeriodFrom as int,
	@TranPeriodTo as int

IF @AllocationMode = 0   ----- Lay so trong ky 
	BEGIN
		SET @TranPeriodFrom = @TranYear*12+@TranMonth
		SET @TranPeriodTo = @TranYear*12+@TranMonth
	END
Else
	IF @AllocationMode = 1 --- Lay so trong Nam
		BEGIN
			SET @TranPeriodFrom = @TranYear*12+1
			SET @TranPeriodTo = @TranYear*12+@TranMonth
		END

		IF @AllocationMode = 2  --- Lay so du
			BEGIN
				SET @TranPeriodFrom = 0
				SET @TranPeriodTo = @TranYear*12+@TranMonth
			END

DECLARE	@D90T0002Cursor as cursor,
		@AccountID as nvarchar(50),
		@VoucherID as nvarchar(50),
		@DebitAccountID as nvarchar(50),
		@CreditAccountID as nvarchar(50),
		@ConvertedAmount as decimal(28,8)


SET @D90T0002Cursor = CURSOR SCROLL KEYSET FOR
		SELECT A.AccountID, sum(A.ConvertedAmount) as ConvertedAmount
		FROM
		(SELECT	AccountID, sum(SignAmount) as ConvertedAmount
		FROM 		AV4301
		WHERE	AccountID >= @SourceAccountIDFrom AND AccountID <= @SourceAccountIDTo AND
				(TranYear*12+TranMonth) >= @TranPeriodFrom AND (TranYear*12+TranMonth) <= @TranPeriodTo AND
				DivisionID = @DivisionID And Isnull(Ana01ID,'') = (case when @Ana01ID = '' then Isnull(Ana01ID,'') else @Ana01ID end)
				And Isnull(Ana02ID,'') = (case when @Ana02ID = '' then Isnull(Ana02ID,'') else @Ana02ID end)
				And Isnull(Ana03ID,'') = (case when @Ana03ID = '' then Isnull(Ana03ID,'') else @Ana03ID end)
				And Isnull(Ana04ID,'') = (case when @Ana04ID = '' then Isnull(Ana04ID,'') else @Ana04ID end)
				And Isnull(Ana05ID,'') = (case when @Ana05ID = '' then Isnull(Ana05ID,'') else @Ana05ID end)
		GROUP BY AccountID
		UNION
		SELECT	CorAccountID as AccountID, Sum(case when D_C = 'D' then SignAmount else SignAmount * (-1) end) as ConvertedAmount
				---(case when D_C ='D' then AccountID else CorAccountID end) as AccountID, sum(SignAmount) as ConvertedAmount
		FROM 		AV4444
		WHERE	(CorAccountID between @SourceAccountIDFrom and @SourceAccountIDTo) and
				---(case when D_C ='D' then AccountID else CorAccountID end) >= @SourceAccountIDFrom AND (case when D_C ='D' then AccountID else CorAccountID end) <= @SourceAccountIDTo AND
				(TranYear*12+TranMonth) >= @TranPeriodFrom AND (TranYear*12+TranMonth) <= @TranPeriodTo AND
				DivisionID = @DivisionID And Isnull(Ana01ID,'') = (case when @Ana01ID = '' then Isnull(Ana01ID,'') else @Ana01ID end)
				And Isnull(Ana02ID,'') = (case when @Ana02ID = '' then Isnull(Ana02ID,'') else @Ana02ID end)
				And Isnull(Ana03ID,'') = (case when @Ana03ID = '' then Isnull(Ana03ID,'') else @Ana03ID end)
				And Isnull(Ana04ID,'') = (case when @Ana04ID = '' then Isnull(Ana04ID,'') else @Ana04ID end)
				And Isnull(Ana05ID,'') = (case when @Ana05ID = '' then Isnull(Ana05ID,'') else @Ana05ID end)
				And TableID='AT9001'
		GROUP BY CorAccountID) A
				---(case when D_C ='D' then AccountID else CorAccountID end)) A
		GROUP BY A.AccountID

		OPEN @D90T0002Cursor
		FETCH NEXT FROM @D90T0002Cursor INTO	@AccountID,@ConvertedAmount
		WHILE @@FETCH_STATUS = 0
		BEGIN
		---Print '@AllocationMode ='+str(@AllocationMode)		
		IF @SourceAmountID = 0   ---- Neu la lay do du No thi phai ket chuyen vao tai khoan Co (tai khoan dich)
			BEGIN
				SET @DebitAccountID = @TargetAccountID
				SET @CreditAccountID = @AccountID
			END
			ELSE		
			IF @SourceAmountID = 1  ---- Neu la lay so du co thi phai ket chuyen vao tai khoan No
				BEGIN
					SET @CreditAccountID = @TargetAccountID
					SET @DebitAccountID = @AccountID
					SET @ConvertedAmount = @ConvertedAmount*-1
				END
				ELSE
				IF @SourceAmountID = 2  ---- Tr­êng hîp lÊy sè lín h¬n
					BEGIN
						IF @ConvertedAmount >=0  --- Bªn Nî lín h¬n bªn Cã
							BEGIN
								SET @CreditAccountID = @AccountID
								SET @DebitAccountID = @TargetAccountID
							END
					ELSE
					BEGIN		---- Bªn Cã lín h¬n bªn Nî
						SET @CreditAccountID = @TargetAccountID
						SET @DebitAccountID = @AccountID
						SET @ConvertedAmount = @ConvertedAmount*-1	
					END
			END

		
		IF @ConvertedAmount <>0
		  BEGIN  
		    SET @ConvertedAmount = @ConvertedAmount*@Percentage/100
		    BEGIN

			Exec AP0000  @DivisionID, @VoucherID OUTPUT, 'AT900!', 'AV', @TranYear ,'',15, 3, 0, '-'
                                   --   Print ' @DebitAccountID,@CreditAccountID'+@DebitAccountID+' :' +@CreditAccountID

          
			EXEC AP9009 	@DivisionID, @TranMonth ,@TranYear,
					@VoucherID,@VoucherTypeID,@VoucherNo,@VoucherDate,	
					@VDescription, @BDescription,@TDescription,
					@DebitAccountID,@CreditAccountID,@Ana01ID,@Ana02ID,@Ana03ID,@Ana04ID,@Ana05ID,
					@ConvertedAmount,@CreateUserID,@LastModifyUserID
		    END			
		END	
		FETCH NEXT FROM @D90T0002Cursor INTO	@AccountID,@ConvertedAmount
		END
		CLOSE @D90T0002Cursor
		DEALLOCATE @D90T0002Cursor



SET NOCOUNT OFF























