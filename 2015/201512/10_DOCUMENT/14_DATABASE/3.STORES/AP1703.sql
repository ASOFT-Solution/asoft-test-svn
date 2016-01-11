IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1703]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1703]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


------ Created by Nguyen Van Nhan and Thuy Tuyen, Date 13/12/2006
------ Purpose: Tinh phan bo chi phi tra truoc va doanh thu nhan truoc
------ Edit by: Dang Le Bao Quynh ; Date: 25/04/2007
------ Purpose: Tinh phan bo chi phi chi tiet cho tung doi tuong
------ Edit by Nguyen Quoc Huy, Date 20/08/2008 (Them doi tuong THCP)
------ Edit by: Dang Le Bao Quynh ; Date: 17/10/2008
------ Purpose: Bo sung tinh theo so tien phan bo
------ Edit by: Dang Le Bao Quynh ; Date: 04/11/2008
------ Purpose: Bo sung phan bo theo nguyen te
------ Edit by B.Anh 	date: 21/06/2010	Bo sung cho truong hop phan bo nhieu TK
------ Edit by: Dang Le Bao Quynh ; Date: 28/11/2011
------ Purpose: Lam tron trong truong hop phan bo nhieu tai khoan
------ Edited by Bao Anh	Date: 18/12/2012
------ Purpose: Sua loi phan bo sai khi sua khai bao phan bo tu nhieu TK thanh 1 TK
------ Edit by: Dang Le Bao Quynh; 20/03/2013, xu ly phat hien ky cuoi cung trong truong hop phan bo nhieu tai khoan
------ Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh

CREATE PROCEDURE [dbo].[AP1703] @DivisionID as nvarchar(50), 
				@TranMonth as int, 
				@TranYear as int,
				@D_C as nvarchar(50), 
				@VoucherTypeID nvarchar(50), 
				@VoucherNo as nvarchar(50), 
				@VoucherDate as Datetime,
				@BDescription as nvarchar(250),
				@UserID nvarchar(50),
				@JobIDInput nvarchar(50)
AS


Declare 	@Job_cur as Cursor,
		@JobID as varchar(50),
		@ConvertedAmount as money, --- Nguyen gia
		@ResidualValue as money, ---Gia tri con lai
		@TotalDepAmount as money,
		@RemainAmount as money,
		@Ana01ID as varchar(50),
		@Ana02ID as varchar(50),
		@Ana03ID as varchar(50),
		@Ana04ID as varchar(50),
		@Ana05ID as varchar(50),	
		@Ana06ID as varchar(50),
		@Ana07ID as varchar(50),
		@Ana08ID as varchar(50),
		@Ana09ID as varchar(50),
		@Ana10ID as varchar(50),	
		@CreditAccountID As varchar(50),
		@DebitAccountID as  varchar(50),
		@MethodID as tinyint,
		@ObjectID as varchar(50),
		@PeriodID as varchar(50),
		@SerialNo as varchar(50),
		@InvoiceNo as varchar(50),
		@InvoiceDate as datetime,
		@ApportionRate as money,
		@Periods as int, 
		@ResidualMonths as int,
		@BeginMonth as int,
		@BeginYear as int,
		@ConvertedDecimals as tinyint,
		@DepAmount as money,
		@DepType as tinyint,
		@TempDepAmount as money,
		@DepreciationID as varchar(50),	
		@ApportionAmount as money,
		@CurrencyID varchar(50),
		@ExchangeRate money,
		@DepOriginalAmount as money,
		@UseStatus as int, -- 0 : Chua phan bo, 1 : Dang phan bo, 8 : Ngung phan bo, 9 : Phan bo het.
		@IsMultiAccount as tinyint,

		--- Dung cho phan bo theo nhieu TK:
		@Account_cur as Cursor,
		@AccountID_D as varchar(50),
		@AccountID_C as varchar(50),
		@DepPercent as money,
		@Ana01ID_MA as varchar(50),
		@Ana02ID_MA as varchar(50),
		@Ana03ID_MA as varchar(50),
		@Ana04ID_MA as varchar(50),
		@Ana05ID_MA as varchar(50),
		@Ana06ID_MA as varchar(50),
		@Ana07ID_MA as varchar(50),
		@Ana08ID_MA as varchar(50),
		@Ana09ID_MA as varchar(50),
		@Ana10ID_MA as varchar(50),
		@PeriodID_MA as varchar(50)

---------- Lay cach thuc lam tron cua he thong --------------------
Set @ConvertedDecimals = (select top 1 ConvertedDecimals From AT1101 Where DivisionID = @DivisionID)

Set @ConvertedDecimals =isnull(@ConvertedDecimals,0)
------------------------------------------------------------------------------------------
SET @Job_cur = Cursor Scroll KeySet FOR 
	Select 		JobID, ConvertedAmount, ResidualValue, CreditAccountID, DebitAccountID, Periods, ResidualMonths, 
			BeginMonth, BeginYear, Ana01ID, Ana02ID, Ana03ID, Ana04ID,  Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana08ID, Ana10ID, 
			ObjectID, SerialNo, InvoiceNo, InvoiceDate, UseStatus, PeriodID,ApportionAmount, 
			(Select Top 1 CurrencyID From AT9000 Where VoucherID = AT1703.VoucherID And TransactionID = AT1703.TransactionID And TableID = 'AT9000' and AT9000.DivisionID = @DivisionID) As CurrencyID,
			(Select Top 1 ExchangeRate From AT9000 Where VoucherID = AT1703.VoucherID And TransactionID = AT1703.TransactionID And TableID = 'AT9000' and AT9000.DivisionID = @DivisionID) As ExchangeRate,
			--(Select Top 1 CurrencyID From AT9000 Where VoucherID = AT1703.VoucherID And Case When AT9000.TransactionTypeID = 'T99' And AT1703.D_C = 'C' Then AT9000.CreditObjectID Else AT9000.ObjectID End = AT1703.ObjectID And TableID = 'AT9000') As CurrencyID,
			--(Select Top 1 ExchangeRate From AT9000 Where VoucherID = AT1703.VoucherID And Case When AT9000.TransactionTypeID = 'T99' And AT1703.D_C = 'C' Then AT9000.CreditObjectID Else AT9000.ObjectID End = AT1703.ObjectID And TableID = 'AT9000') As ExchangeRate
			Isnull(IsMultiAccount,0)
	From 	AT1703
	Where 	DivisionID = @DivisionID
		And (BeginMonth + BeginYear*100)<= (@TranMonth + @TranYear*100)
		And AT1703.D_C =@D_C
		And UseStatus not In (8,9)
		And JobID Like @JobIDInput
		
		
OPEN	@Job_cur
FETCH NEXT FROM @Job_cur INTO  @JobID, @ConvertedAmount, @ResidualValue, @CreditAccountID, @DebitAccountID, @Periods, @ResidualMonths, 
					@BeginMonth, @BeginYear, @Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, @Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID, 
					@ObjectID, @SerialNo, @InvoiceNo, @InvoiceDate, @UseStatus, @PeriodID,@ApportionAmount, @CurrencyID, @ExchangeRate, @IsMultiAccount


WHILE @@Fetch_Status = 0
----Print @JobID+' khoan tien: '+str(@ConvertedAmount)	
	Begin	
		
		If @ResidualMonths <> 0 
			Set @TempDepAmount = isnull(@ApportionAmount,Round (@ResidualValue/@ResidualMonths,@ConvertedDecimals))
		Else 
			Set @TempDepAmount  =0

		If @ResidualValue -  isnull((Select Sum(isnull(DepAmount,0)) From AT1704 Where DivisionID =@DivisionID and JobID = @JobID),0) >=@TempDepAmount
			Begin
				--Edit by: Dang Le Bao Quynh; 20/03/2013, xu ly phat hien ky cuoi cung trong truong hop phan bo nhieu tai khoan
				If   @ResidualMonths - 1 = isnull((Select Count(*) From (Select 1 as A From At1704 Group By DivisionID, TranMonth, TranYear, JobID Having JobID =@JobID and DivisionID =@DivisionID) T ),0)
					Begin
				  		Set @DepAmount = @ResidualValue -  isnull((Select Sum(DepAmount) From At1704 Where DivisionID =@DivisionID and JobID = @JobID),0)
						Set @UseStatus = 9
					End
				Else 
					Begin
						Set @DepAmount = @TempDepAmount
						Set @UseStatus = 1
					End
			End
		Else    
			Begin
				Set @DepAmount = @ResidualValue -  isnull((Select Sum(DepAmount) From AT1704 Where DivisionID =@DivisionID and JobID =@JobID),0) 			
				Set @UseStatus = 1
			End
					
		---Print 'HELLO'+str(@DepAmount)
		IF @DepAmount >0 
			Begin	
				Select @DepOriginalAmount = 	Case When Operator <> 0 Then Round(@DepAmount * ExchangeRate,ExchangeRateDecimal) 
								Else 
									Case When ExchangeRate <> 0 Then Round(@DepAmount / ExchangeRate,ExchangeRateDecimal) Else 0 End 
								End
				From AT1004 Where CurrencyID = @CurrencyID and DivisionID = @DivisionID
				
				IF @IsMultiAccount = 0 Or not exists (Select top 1 1 from AT1705 Where JobID = @JobID and DivisionID = @DivisionID)
					Begin
						Exec AP0000  @DivisionID, @DepreciationID  OUTPUT, 'AT1704', 'AD', @TranYear ,'',15, 3, 0, '-'		
						Insert AT1704 (
						DepreciationID, VoucherNo, VoucherDate, TranMonth, TranYear,
						DivisionID, Status, CreditAccountID, DebitAccountID, DepAmount,
						Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, VoucherTypeID, Description,
						JobID , CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,D_C, ObjectID, SerialNo, InvoiceNo, InvoiceDate,PeriodID, CurrencyID, ExchangeRate, DepOriginalAmount)
						Values (
						@DepreciationID, @VoucherNo, @VoucherDate, @TranMonth, @TranYear,
						@DivisionID, 0, @CreditAccountID, @DebitAccountID, @DepAmount,
						@Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID,  @Ana05ID, @Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID,  @Ana10ID,  @VoucherTypeID, @BDescription,
						@JobID, getdate(), @UserID, getdate(), @UserID,@D_C, @ObjectID, @SerialNo, @InvoiceNo, @InvoiceDate, @PeriodID, @CurrencyID, @ExchangeRate, @DepOriginalAmount)
					End
				ELSE
					Begin
						SET @Account_cur = Cursor Scroll KeySet FOR
						Select case when AT1703.D_C='D' then AT1705.AccountID else AT1703.DebitAccountID end as DebitAccountID,
						           case when AT1703.D_C='D' then AT1703.CreditAccountID else AT1705.AccountID end as CreditAccountID,
						           DepPercent, AT1705.Ana01ID, AT1705.Ana02ID, AT1705.Ana03ID, AT1705.Ana04ID, AT1705.Ana05ID, 
						           AT1705.Ana06ID, AT1705.Ana07ID, AT1705.Ana08ID, AT1705.Ana09ID, AT1705.Ana10ID, AT1705.PeriodID
						 From AT1705 inner join AT1703 on AT1705.JobID = AT1703.JobID and AT1705.DivisionID = AT1703.DivisionID Where AT1705.JobID = @JobID	and AT1705.DivisionID = @DivisionID			
						
						OPEN	@Account_cur
						FETCH NEXT FROM @Account_cur INTO @AccountID_D, @AccountID_C, @DepPercent, @Ana01ID_MA, @Ana02ID_MA, @Ana03ID_MA, @Ana04ID_MA, @Ana05ID_MA, 
														@Ana06ID_MA, @Ana07ID_MA, @Ana08ID_MA, @Ana09ID_MA, @Ana10ID_MA, @PeriodID_MA
						WHILE @@Fetch_Status = 0
							Begin		
								Exec AP0000  @DivisionID,@DepreciationID  OUTPUT, 'AT1704', 'AD', @TranYear ,'',15, 3, 0, '-'		
								Insert AT1704 (
								DepreciationID, VoucherNo, VoucherDate, TranMonth, TranYear,
								DivisionID, Status, CreditAccountID, DebitAccountID, DepAmount,
								Ana01ID, Ana02ID, Ana03ID, Ana04ID,  Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,  VoucherTypeID, Description,
								JobID , CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,D_C, ObjectID, SerialNo, InvoiceNo, InvoiceDate,PeriodID, CurrencyID, ExchangeRate, DepOriginalAmount)
								Values (
								@DepreciationID, @VoucherNo, @VoucherDate, @TranMonth, @TranYear,
								@DivisionID, 0, @AccountID_C, @AccountID_D, Round(@DepAmount*@DepPercent/100,@ConvertedDecimals) ,
								@Ana01ID_MA, @Ana02ID_MA, @Ana03ID_MA, @Ana04ID_MA,  @Ana05ID_MA,  
								@Ana06ID_MA, @Ana07ID_MA, @Ana08ID_MA, @Ana09ID_MA,  @Ana10ID_MA, 
								@VoucherTypeID, @BDescription,
								@JobID, getdate(), @UserID, getdate(), @UserID,@D_C, @ObjectID, @SerialNo, @InvoiceNo, @InvoiceDate, @PeriodID_MA, @CurrencyID, @ExchangeRate, @DepOriginalAmount*@DepPercent/100)
		
								FETCH NEXT FROM @Account_cur INTO @AccountID_D, @AccountID_C, @DepPercent, @Ana01ID_MA, @Ana02ID_MA, @Ana03ID_MA, @Ana04ID_MA, @Ana05ID_MA, 
												@Ana06ID_MA, @Ana07ID_MA, @Ana08ID_MA, @Ana09ID_MA, @Ana10ID_MA, @PeriodID_MA
							END
							Update AT1704 
							Set DepAmount = DepAmount + (@DepAmount - (Select Sum(isnull(DepAmount,0)) From AT1704 Where JobID =@JobID And TranMonth=@TranMonth And TranYear=@TranYear))
							From AT1704 Where JobID =@JobID And TranMonth=@TranMonth And TranYear=@TranYear And DepreciationID = @DepreciationID 
						Close @Account_cur
					End

				Update AT1703  Set UseStatus = @UseStatus Where JobID =@JobID and DivisionID = @DivisionID				
				
				
	
			End
	
		FETCH NEXT FROM @Job_cur INTO  @JobID, @ConvertedAmount, @ResidualValue, @CreditAccountID, @DebitAccountID, @Periods, @ResidualMonths, 
					@BeginMonth, @BeginYear, @Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID,  @Ana05ID, @Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID, 
					@ObjectID, @SerialNo, @InvoiceNo, @InvoiceDate, @UseStatus,@PeriodID,@ApportionAmount, @CurrencyID, @ExchangeRate, @IsMultiAccount
		
	End
	
	
Close @Job_cur

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

