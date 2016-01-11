/****** Object:  StoredProcedure [dbo].[OP9999]    Script Date: 08/04/2010 13:41:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created by: Vo Thanh Huong
----- Created date: 06/08/2004
----- Purpose: Khoa so ky ke toan
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/
----- Modify on 08/06/2015 by Bảo Anh: Lấy PeriodNum từ thông tin đơn vị AT1101

ALTER PROCEDURE [dbo].[OP9999] @DivisionID nvarchar(50), 
			@TranMonth as int,
			@TranYear as int,
			@BeginDate  as datetime,
			@EndDate as datetime	
 AS

Declare @Closing As Bit,
	@NextMonth 	tinyInt,
	@NextYear 	smallint,
	@PeriodNum 	tinyInt,
	@MaxPeriod	int 
	
	-- EXEC OP5001 @DivisionID, @TranMonth, @TranYear
	Select 	@PeriodNum = PeriodNum
	From	AT1101 ---AT0001
	Where DivisionID = @DivisionID
	
	If @PeriodNum Is Null 
		Set @PeriodNum = 12

	Set @NextMonth = @TranMonth % @PeriodNum + 1
	Set @NextYear = @TranYear + @TranMonth/@PeriodNum

	Select  	@Closing = Closing
	From 	OT9999
	Where 	DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear
		
	Select 	@MaxPeriod = Max(TranMonth + TranYear * 100)
 	From	OT9999
	Where	DivisionID = @DivisionID

	If  @Closing <> 1 
	Begin
				
		Update 	OT9999
		Set 	Closing = 1
		From 	OT9999
		Where 	DivisionID = @DivisionID And TranMonth =@TranMonth And TranYear = @TranYear

		IF	@MaxPeriod < (@NextMonth + @NextYear * 100)
		Begin
			Insert    	OT9999  (TranMonth,TranYear, DivisionID, Closing, BeginDate, EndDate) 
			Values(@NextMonth,@NextYear, @DivisionID,0, @BeginDate, @EndDate)

			If Exists (Select 1 From OT0000 Where DivisionID = @DivisionID)
			Begin
				Update OT0000
				Set 	TranMonth = @NextMonth,
					TranYear = @NextYear			
			End
		End	
	End
