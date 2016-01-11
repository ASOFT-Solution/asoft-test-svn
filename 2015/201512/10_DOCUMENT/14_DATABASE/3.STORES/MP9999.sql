/****** Object:  StoredProcedure [dbo].[MP9999]    Script Date: 07/29/2010 17:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/
----- Modify on 08/06/2015 by Bảo Anh: Lấy PeriodNum từ thông tin đơn vị AT1101  

ALTER PROCEDURE [dbo].[MP9999] @DivisionID nvarchar(20), @TranMonth as int, @TranYear as int,
				@BeginDate as datetime,
				@EndDate as datetime

	
 AS

Declare @Closing As TinyInt,
	@NextMonth 	TinyInt,
	@NextYear 	Smallint,
	@PeriodNum 	TinyInt,
	@MaxPeriod	Int 
	
	
	Select 	@PeriodNum = PeriodNum
	From	AT1101 ---AT0001
	If @PeriodNum Is Null 
		Set @PeriodNum = 12

	Set @NextMonth = @TranMonth % @PeriodNum + 1
	Set @NextYear = @TranYear + @TranMonth/@PeriodNum

	Select  	@Closing = Closing
	From 	MT9999
	Where 	DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear
		
	Select 	@MaxPeriod = Max(TranMonth + TranYear * 100)
 	From	MT9999
	Where	DivisionID = @DivisionID

	If  @Closing <> 1 
	Begin	
		Update MT9999
		Set 	Closing = 1
		From 	MT9999
		Where 	DivisionID = @DivisionID And TranMonth =@TranMonth And TranYear = @TranYear

		IF	@MaxPeriod < (@NextMonth + @NextYear * 100)
		Begin
			Insert    	MT9999  (TranMonth,TranYear, DivisionID,Closing, BeginDate, EndDate) 
			Values(@NextMonth,@NextYear, @DivisionID,0,@BeginDate,@EndDate)
			If Exists (Select 1 From AT0000 Where DefDivisionID = @DivisionID)
			Begin
				Update MT0000
				Set 	TranMonth = @NextMonth,
					TranYear = @NextYear			
			End
		End	
		else
		Begin	
			Update 	MT9999
			Set 	BeginDate = @BeginDate,
				EndDate = @EndDate
			From 	MT9999
			Where 	DivisionID = @DivisionID And TranMonth = @NextMonth And TranYear = @NextYear
		end


	End	












