IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[FP9999]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[FP9999]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created by  Nguyen Quoc Huy, Date 13/06/2007
----- Purpose: Khoa so ky ke toan ASOFT-FA
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/
---- Modified on 12/08/2013 by Le Thi Thu Hien : Bổ sung Where DivisionID khi Update FT0000
---- Modify on 08/06/2015 by Bảo Anh: Lấy PeriodNum từ thông tin đơn vị AT1101  

CREATE PROCEDURE [dbo].[FP9999] 
				@DivisionID nvarchar(50), 
				@TranMonth as int, 
				@TranYear as int,
				@BeginDate as datetime,
				@EndDate as datetime
	
 AS


Declare @Closing As TinyInt,
		@NextMonth 	Int,
		@NextYear 	int,
		@PeriodNum 	TinyInt,
		@MaxPeriod	Int 
	
	
	SELECT 	@PeriodNum = PeriodNum
	FROM	AT1101 ---AT0001
	
	If @PeriodNum Is Null 
		Set @PeriodNum = 12

	Set @NextMonth = @TranMonth % @PeriodNum + 1
	Set @NextYear = @TranYear + @TranMonth/@PeriodNum

	SELECT  @Closing = Closing
	From 	FT9999
	Where 	DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear
		
	Select 	@MaxPeriod = Max(TranMonth + TranYear * 100)
 	From	FT9999
	Where	DivisionID = @DivisionID

	If  @Closing <> 1 
	Begin
		
		
		Update 	FT9999
		Set 	Closing = 1
		From 	FT9999
		Where 	DivisionID = @DivisionID And TranMonth =@TranMonth And TranYear = @TranYear

		IF	@MaxPeriod < (@NextMonth + @NextYear * 100)
		Begin
			INSERT  FT9999  (TranMonth,TranYear, DivisionID,Closing, BeginDate, EndDate) 
			VALUES	(@NextMonth,@NextYear, @DivisionID,0,@BeginDate, @EndDate)

			IF EXISTS (SELECT 1 FROM FT0000 WHERE DefDivisionID = @DivisionID)
			Begin
				UPDATE FT0000
				SET 	DefTranMonth = @NextMonth,
						DefTranYear = @NextYear
				WHERE	DefDivisionID = @DivisionID			
			End

		
		End
		
		IF	@MaxPeriod >= (@NextMonth + @NextYear * 100)
		Begin	
			UPDATE 	FT9999
			SET 	BeginDate = @BeginDate,
					EndDate = @EndDate
			FROM 	FT9999
			WHERE 	DivisionID = @DivisionID 
					AND TranMonth = @NextMonth 
					AND TranYear = @NextYear
		end


	
	End

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

