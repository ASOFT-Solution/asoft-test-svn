IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CP9999]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[CP9999]
GO
/****** Object:  StoredProcedure [dbo].[CP9999]    Script Date: 07/29/2010 15:33:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by: Nguyen Thi Thuy Tuyen
----- Created date: 02/11/2006
----- Purpose: Khoa so ky ke toan
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/
----- Modify on 08/06/2015 by Bảo Anh: Lấy PeriodNum từ thông tin đơn vị AT1101  

CREATE PROCEDURE [dbo].[CP9999] @DivisionID nvarchar(50), 
			@TranMonth as int,
			@TranYear as int,
			@BeginDate  as datetime,
			@EndDate as datetime	
 AS

Declare @Closing As TinyInt,
	@NextMonth 	TinyInt,
	@NextYear 	int,
	@PeriodNum 	TinyInt,
	@MaxPeriod	Int 
	
	
	Select 	@PeriodNum = PeriodNum
	From	AT1101 ---AT0001
	If @PeriodNum Is Null 
		Set @PeriodNum = 12

	Set @NextMonth = @TranMonth % @PeriodNum + 1
	Set @NextYear = @TranYear + @TranMonth/@PeriodNum

	Select  	@Closing = Closing
	From 	CT9999
	Where 	DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear
		
	Select 	@MaxPeriod = Max(TranMonth + TranYear * 100)
 	From	CT9999
	Where	DivisionID = @DivisionID

	If  @Closing <> 1 
	Begin
				
		Update 	CT9999
		Set 	Closing = 1
		From 	CT9999
		Where 	DivisionID = @DivisionID And TranMonth =@TranMonth And TranYear = @TranYear

		IF	@MaxPeriod < (@NextMonth + @NextYear * 100)
		Begin
			Insert    	CT9999  (TranMonth,TranYear, DivisionID, Closing, BeginDate, EndDate) 
			Values(@NextMonth,@NextYear, @DivisionID,0, @BeginDate, @EndDate)

			If Exists (Select 1 From CT0000 Where DivisionID = @DivisionID)
			Begin
				Update CT0000
				Set 	DefTranMonth = @NextMonth,
					DefTranYear = @NextYear
			End
		End	
	End