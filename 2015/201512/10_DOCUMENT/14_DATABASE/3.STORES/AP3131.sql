/****** Object:  StoredProcedure [dbo].[AP3131]    Script Date: 07/29/2010 14:02:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



------ Created by Nguyen Van Nhan, Date 03/05/2005
----- Tinh lai suat phat No phai thu
----- Edited By Nguyen Quoc Huy, Date 17/08/2006
----- Edited By Tan Phu, Date 15/06/2011 ---Bo sung tinh lai phat theo nac thang
-- Last edit by Thiên Huỳnh on [04/06/2012]: Bổ sung khoản mục Ana03ID - Ana10ID
--- Edit by Khanh Van: Luu them AccountID
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[AP3131]	 	@DivisionID as nvarchar(50), 
					@FromObjectID as nvarchar(50),
					@ToObjectID as nvarchar(50),		
					@AccountID as nvarchar(50),		
					@CurrencyID as nvarchar(50),
					@Month as int,
					@Year as int,					
					@NowAday as Datetime,  --ngay chot lai
					@InterestID as nvarchar(50),									
					@FromDate as datetime,
					@ToDate as datetime			
AS
Set Nocount on
Declare @InPercent as decimal (28,8),
	@Invoice_Cur as cursor,
	@VoucherID as nvarchar(50),
	@ObjectID  as nvarchar(50),
	@VoucherNo  as nvarchar(50),
	@InvoiceNo  as nvarchar(50),
	@InvoiceDate as Datetime,
	@VoucherDate as Datetime,
	@TableID as nvarchar(50),
	@DueDate as DateTime,	
	@BatchID as nvarchar(50),
	@TranMonth int,	
	@TranYear int,
	@ConvertedAmount as decimal (28,8),
	@OriginalAmountCN as decimal (28,8),
	@Payment_cur as cursor,
	@Day as int ,			--So ngay tre
	@LaterDays as int ,			--So ngay gia han
	@PayDate as Datetime,		--Ngay tra
	@PaymentAmount as decimal (28,8),
	@BonusAmount as decimal (28,8),
	@InterestAmount as decimal (28,8),
	@RemainAmount as decimal (28,8),	
	@GiveOriginalAmount as decimal (28,8),
	@GiveConvertedAmount as decimal (28,8),
	@RemainOriginalAmount as decimal (28,8),
	@RemainConvertedAmount as decimal (28,8),
	@Serial as nvarchar(50),
	@Ana01ID as nvarchar(50),  
	@Ana02ID as nvarchar(50),
	@Ana03ID as nvarchar(50),
	@Ana04ID as nvarchar(50),
	@Ana05ID as nvarchar(50),  
	@Ana06ID as nvarchar(50),
	@Ana07ID as nvarchar(50),
	@Ana08ID as nvarchar(50),
	@Ana09ID as nvarchar(50),  
	@Ana10ID as nvarchar(50),
	@CalID as nvarchar(50),
	@IsConstant as tinyint,
	@CYear as nvarchar(50),
	@CreditVoucherNo as nvarchar(50),
	@BonusPercent as decimal (28,8),
	@ExcludeVoucherTypeID1 as nvarchar(50),
	@ExcludeVoucherTypeID2 as nvarchar(50),
	@ExcludeVoucherTypeID3 as nvarchar(50),
	@ExcludeVoucherTypeID4 as nvarchar(50),
	@ExcludeVoucherTypeID5 as nvarchar(50)
	
Set @CYear = ltrim(rtrim(str(@Year)))


------------------------ Xoa.

Select @IsConstant = IsConstant, @InPercent = PercentValues, @BonusPercent = BonusPercent, @LaterDays = LaterDays,
@ExcludeVoucherTypeID1=  isnull(VoucherTypeID1,'**'), @ExcludeVoucherTypeID2=  isnull(VoucherTypeID2,'**'),
@ExcludeVoucherTypeID3=  isnull(VoucherTypeID3,'**'), @ExcludeVoucherTypeID4=  isnull(VoucherTypeID4,'**'), @ExcludeVoucherTypeID5=  isnull(VoucherTypeID5,'**')
From AT1018 Where InterestID = @InterestID AND DivisionID = @DivisionID

Set @InPercent = round(@InPercent/100,20,4)
Set @BonusPercent = round(@BonusPercent/100,20,4)


SET @Invoice_Cur = Cursor Scroll KeySet FOR 
SELECT 	Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, 
		DueDate, VoucherID, BatchID,  TableID,   TranMonth,TranYear,
		 AT9000.ObjectID as ObjectID,	
		Sum(isnull(ConvertedAmount,0)) as ConvertedAmount, 
		Sum(isnull(OriginalAmountCN,0)) as OriginalAmountCN,	
		 VoucherNo, VoucherDate,InvoiceDate,InvoiceNo , Serial
FROM AT9000 
WHERE  AT9000.DivisionID =@DivisionID and
	  DebitAccountID = @AccountID and						---  Chi lay phat sinh No
	  CurrencyIDCN = @CurrencyID and 
	 ---(DueDate <= @NowAday) and  
	 DueDate  is not null and             			--- Ngay dao han nho hon ngay chot
	  AT9000.ObjectID Between @FromObjectID and @ToObjectID and	
	  (DueDate between @FromDate and @ToDate or VoucherDate between @FromDate and @ToDate) 					--- Ngay dao han trong khoan thoi gian
Group by Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, 
	VoucherID,BatchID,  TableID, TranMonth,TranYear,  AT9000.DivisionID, 
	AT9000.ObjectID,   DebitAccountID,   CurrencyIDCN, ExchangeRateCN,
	VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,
	VDescription,    AT9000.DueDate 
Order by DueDate

OPEN	@Invoice_Cur

FETCH NEXT FROM @Invoice_Cur INTO @Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, @Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID,  
	@DueDate, @VoucherID, @BatchID,  @TableID,   @TranMonth,@TranYear,
	@ObjectID,  @ConvertedAmount, @OriginalAmountCN, @VoucherNo, @VoucherDate,@InvoiceDate,@InvoiceNo , @Serial
WHILE @@Fetch_Status = 0
	Begin	
		--Print 'TEST'
		
		set @InterestAmount =0
		Set @BonusAmount  =0
		Set @ReMainAmount = @OriginalAmountCN
		Set @GiveOriginalAmount =0	
		
		----- Lay cac lan thanh toan neu co
		Set @Payment_Cur  = Cursor Scroll KeySet FOR 
		Select A.VoucherDate , A.VoucherNo,  AT0303.OriginalAmount 
		From AT0303 inner join (select Distinct VoucherNo, VoucherID, ObjectID,  CreditAccountID, VoucherDate, DivisionID From AT9000 Where TransactionTypeID <>'T99') A 
				 on 	A.VoucherID = AT0303.CreditVoucherID AND A.DivisionID = AT0303.DivisionID AND 
					A.ObjectID = @ObjectID and A.CreditAccountID = @AccountID

		Where AT0303.ObjectID =  @ObjectID  and DebitVoucherID = @VoucherID and VoucherDate <= @NowAday AND AT0303.DivisionID = @DivisionID
		Union all 
		Select A.VoucherDate , A.VoucherNo, AT0303.OriginalAmount 
		From AT0303 inner join (select Distinct VoucherNo,  VoucherID, CreditObjectID as ObjectID,  CreditAccountID, VoucherDate, DivisionID From AT9000 Where TransactionTypeID ='T99') A 
				 on 	A.VoucherID = AT0303.CreditVoucherID AND A.DivisionID = AT0303.DivisionID AND 
					A.ObjectID = @ObjectID and A.CreditAccountID = @AccountID
		Where AT0303.ObjectID =  @ObjectID  and DebitVoucherID = @VoucherID and VoucherDate <= @NowAday AND AT0303.DivisionID = @DivisionID		Order by A.VoucherDate
		OPEN	@Payment_Cur		FETCH NEXT FROM @Payment_Cur INTO @PayDate , @CreditVoucherNo, @PaymentAmount		WHILE @@Fetch_Status = 0
			Begin	---- Tinh toan so ngay  tre    
				-- tanphu 25052011 sửa phần tính số ngày trể
				Set @Day =  datediff(day, @DueDate, @PayDate)
				-- convert(int,@PayDate, 101) - convert(int, @DueDate, 101)
				-- print 'Day:' + str(@Day)
				If @Day<=0   --- Tra som 
					begin
					--if  @CreditVoucherNo like 'HL%'   --- Hang ban tra lai
					--- Hang ban tra lai
					if  	Left(@CreditVoucherNo,Len(@ExcludeVoucherTypeID1)) = @ExcludeVoucherTypeID1
						or Left(@CreditVoucherNo,Len(@ExcludeVoucherTypeID2)) = @ExcludeVoucherTypeID2 
						or Left(@CreditVoucherNo,Len(@ExcludeVoucherTypeID3)) = @ExcludeVoucherTypeID3 
						or Left(@CreditVoucherNo,Len(@ExcludeVoucherTypeID4)) = @ExcludeVoucherTypeID4 
						or Left(@CreditVoucherNo,Len(@ExcludeVoucherTypeID5)) = @ExcludeVoucherTypeID5
					    Begin
						     Set @BonusAmount = @BonusAmount+0
					    End
					Else
					    Begin	
						
	   					     Set @BonusAmount = @BonusAmount+ round( (@BonusPercent* @PaymentAmount),20,2) 
					    End
					    
					    --print 'BonusAmount' + str(@BonusAmount)
					 end
				Else ---Tra tre
					begin
					
						--print 'LaterDays:' + str(@LaterDays)
					  If @DueDate<@NowAday and @Day>=@LaterDays  --- ngay gia han
						begin
							IF @IsConstant=0 ------Theo nac thang				
					  		BEGIN
						  		SELECT @InPercent=CONVERT(MONEY,PercentValues)  FROM AT1019 
						  		WHERE InterestID=@InterestID AND FromValues <= @Day 
						  		AND ToValues>=@Day 
						  		and DivisionID =@DivisionID
						   		Set @InPercent = round(@InPercent/100,20,4)
						   		Set @InterestAmount = @InterestAmount +  (@InPercent*@PaymentAmount)
					  		END
						  	ELSE
								Set @InterestAmount = @InterestAmount +  (@InPercent*@Day*@PaymentAmount)/30
							--print '@InterestAmount1' + str(@InterestAmount)
							--print '@Day' + str(@Day)
							--print '@PaymentAmount' + str(@PaymentAmount)
						end
					end
				Set 	@ReMainAmount = @ReMainAmount - @PaymentAmount
				
				FETCH NEXT FROM @Payment_Cur INTO @PayDate, @CreditVoucherNo, @PaymentAmount
			End
		  Close @Payment_Cur

			If @ReMainAmount  > 0   ---Tinh lai phat cho so tien con lai chua thanh toan.
				Begin
					--Chot lai so ngay tinh lai phat.
					--print '@NowADay:''' + convert(nvarchar, @NowADay, 103) +''''
					-- tan phu 25052011 sửa cách tính số ngày lãi
					Set @Day = datediff(day, @DueDate, @NowADay)
					IF @IsConstant =0 ---Theo nac thang			 				 	
			 		BEGIN 	
				 		SELECT @InPercent=CONVERT(MONEY,PercentValues)  FROM AT1019 
				 		WHERE InterestID=@InterestID AND FromValues <= @Day 
				 		AND ToValues>=@Day and DivisionID =@DivisionID
				 		Set @InPercent = round(@InPercent/100,20,4)
			   		END	
			   	IF (@DueDate<@NowAday AND @Day>@LaterDays)	
			   		IF @IsConstant =0 ---Theo nac thang	   	
				   		Set @InterestAmount = @InterestAmount +  round((@InPercent*@ReMainAmount),20,4)
				   	ELSE
				   		Set @InterestAmount = @InterestAmount +  round((@InPercent*@Day* @ReMainAmount)/30,20,4)
					--convert(int,@NowADay, 101) - convert(int, @DueDate, 101)		
					--If @DueDate<@NowAday and @Day>@LaterDays
					  -- Set @InterestAmount = @InterestAmount +  round((@InPercent*@Day* @ReMainAmount)/30,20,2)--- Custermize cho Hoang Viet
					
				 End 
		
			If @InterestAmount<>0 or @BonusAmount<>0   --- Insert vao lai phat va tien thuong
			Begin
			Exec AP0000  @DivisionID, @CalID  OUTPUT, 'AT3131', 'CA', @CYear ,'', 16, 3, 0, '-'		
			print @CalID
			Insert AT3131 (VoucherID, CalID, DivisionID, TranMonth, TranYear, ObjectID,  ConvertedAmount, OriginalAmount,
			GiveOriginalAmount, GiveConvertedAmount, RemainOriginalAmount, RemainConvertedAmount,
			BonusAmount, InterestAmount, VoucherNo, VoucherDate, InvoiceNo, InvoiceDate, Serial, DueDate, 
			Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, 
			CalMonth, CalYear, AccountID )
			Values (@VoucherID, @CalID, @DivisionID, @TranMonth, @TranYear, @ObjectID,  @ConvertedAmount, @OriginalAmountCN,
				@OriginalAmountCN - @RemainAmount, @ConvertedAmount- @RemainAmount,@RemainAmount, @ReMainAmount,
			 @BonusAmount, @InterestAmount, @VoucherNo, @VoucherDate, @InvoiceNo, @InvoiceDate, @Serial , @DueDate,
			@Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, @Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID, 
			@Month, @Year , @AccountID)
			End
		
		FETCH NEXT FROM @Invoice_Cur INTO  @Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, @Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID, 
		@DueDate, @VoucherID, @BatchID,  @TableID,   @TranMonth,@TranYear,
		@ObjectID,   @ConvertedAmount, @OriginalAmountCN, @VoucherNo, @VoucherDate,@InvoiceDate,@InvoiceNo , @Serial

	End
Close @Invoice_Cur

----- Xu ly tru bot di
Exec AP3130 @DivisionID, @FromObjectID, @ToObjectID, @AccountID, @CurrencyID,@Month,@Year
Set Nocount off