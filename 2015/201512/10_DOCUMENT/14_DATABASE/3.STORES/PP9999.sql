IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[PP9999]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[PP9999]
GO
/****** Object:  StoredProcedure [dbo].[PP9999]    Script Date: 08/04/2010 13:41:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/
----- Modify on 08/06/2015 by Bảo Anh: Lấy PeriodNum từ thông tin đơn vị AT1101  

CREATE PROCEDURE [dbo].[PP9999] @DivisionID nvarchar(50), @TranMonth as int, @TranYear as int,
				@BeginDate as datetime,
				@EndDate as datetime

	
 AS

Declare @Closing As tinyint,
	@NextMonth 	tinyInt,
	@NextYear 	smallint,
	@PeriodNum 	tinyInt,
	@MaxPeriod	int 
	
	
	Select 	@PeriodNum = PeriodNum
	From	AT1101 ---AT0001
	If @PeriodNum Is Null 
		Set @PeriodNum = 12

	Set @NextMonth = @TranMonth % @PeriodNum + 1
	Set @NextYear = @TranYear + @TranMonth/@PeriodNum

	Select  	@Closing = Closing
	From 	PT9999
	Where 	DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear
		
	Select 	@MaxPeriod = Max(TranMonth + TranYear * 100)
 	From	PT9999
	Where	DivisionID = @DivisionID

	If  @Closing <> 1 
	Begin	
		Update PT9999
		Set 	Closing = 1
		From 	PT9999
		Where 	DivisionID = @DivisionID And TranMonth =@TranMonth And TranYear = @TranYear

		IF	@MaxPeriod < (@NextMonth + @NextYear * 100)
		Begin
			Insert    	PT9999  (TranMonth,TranYear, DivisionID,Closing, BeginDate, EndDate) 
			Values(@NextMonth,@NextYear, @DivisionID,0,@BeginDate,@EndDate)
			If Exists (Select 1 From AT0000 Where DefDivisionID = @DivisionID)
			Begin
				Update PT0000
				Set 	TranMonth = @NextMonth,
					TranYear = @NextYear			
			End
		End	
		else
		Begin	
			Update 	PT9999
			Set 	BeginDate = @BeginDate,
				EndDate = @EndDate
			From 	PT9999
			Where 	DivisionID = @DivisionID And TranMonth = @NextMonth And TranYear = @NextYear
		end


	End
GO
