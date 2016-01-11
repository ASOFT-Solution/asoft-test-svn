IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CMP9999]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[CMP9999]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Created by Khanh Van on 18/12/2013
---- Modify on 08/06/2015 by Bảo Anh: Lấy PeriodNum từ thông tin đơn vị AT1101

CREATE PROCEDURE [dbo].[CMP9999] @DivisionID nvarchar(20), 
				@TranMonth as int, 
				@TranYear as int,
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
	From 	CMT9999
	Where 	DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear
		
	Select 	@MaxPeriod = Max(TranMonth + TranYear * 100)
 	From	CMT9999
	Where	DivisionID = @DivisionID

	If  @Closing <> 1 
	Begin	
		Update CMT9999
		Set 	Closing = 1
		From 	CMT9999
		Where 	DivisionID = @DivisionID And TranMonth =@TranMonth And TranYear = @TranYear

		IF	@MaxPeriod < (@NextMonth + @NextYear * 100)
		Begin
			Insert    	CMT9999  (TranMonth,TranYear, DivisionID,Closing, BeginDate, EndDate) 
			Values(@NextMonth,@NextYear, @DivisionID,0,@BeginDate,@EndDate)
			If Exists (Select 1 From AT0000 Where DefDivisionID = @DivisionID)
			Begin
				Update CMT0000
				Set 	DefTranMonth = @NextMonth,
					DefTranYear = @NextYear			
			End
		End	
		else
		Begin	
			Update 	CMT9999
			Set 	BeginDate = @BeginDate,
				EndDate = @EndDate
			From 	CMT9999
			Where 	DivisionID = @DivisionID And TranMonth = @NextMonth And TranYear = @NextYear
		end


	End
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON