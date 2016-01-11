/****** Object:  StoredProcedure [dbo].[HP2225]    Script Date: 07/30/2010 14:02:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----Created by: Vo Thanh Huong
----Created date: 17/07/2004
----purpose: Tính B?ng d?i chi?u s? li?u n?p BHXH, BHYT

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2225]  @DivisionID  nvarchar(50),
				@TranQuater int,
				@TranYear int,
				@CreateUserID nvarchar(50)
 AS
DECLARE 	@MaxStep int,
	      	@MinStep int,
			@cur_Step cursor,
			@Step int,
			@Code nvarchar(50),
			@Amount1 decimal(28,8),
			@Amount2 decimal(28,8), 
			@Orders int

Select @MaxStep = MAX(Step)
From HT2226
Where DivisionID = @DivisionID and
	TranYear = @TranYear and
	TranQuater = @TranQuater 

SET @cur_Step =  CURSOR SCROLL KEYSET FOR
		Select distinct Step, Isnull(Code,'') as Code, Orders
		 From HT2226 
		Where DivisionID = @DivisionID and
				TranYear = @TranYear and
				TranQuater = @TranQuater and Step <> @MaxStep and  Isnull(Code,'') not like '' 
		Order by Step Desc
OPEN @cur_Step
FETCH NEXT FROM  @cur_Step INTO  @Step, @Code, @Orders

WHILE @@FETCH_STATUS = 0
	BEGIN
	Select 	@Amount1 = SUM(Amount1*Sign), @Amount2 = SUM(Amount2*Sign)
		 From HT2226
		Where DivisionID = @DivisionID and
			TranYear = @TranYear and
			TranQuater = @TranQuater and	
			Isnull(Code0,'') = @Code and Step > @Step

	Update HT2226 SET Amount1 = @Amount1, Amount2 = @Amount2,
			LastModifyUserID = @CreateUserID, 
			LastModifyDate = getdate()	 
		Where DivisionID = @DivisionID and
			TranYear = @TranYear and
			TranQuater = @TranQuater  and
			Step = @Step and Code = @Code  and Orders = @Orders
			

	FETCH NEXT FROM  @cur_Step INTO  @Step, @Code, @Orders
	END	

EXEC HP2226		 @DivisionID,		@TranQuater,  		  @TranYear , 	@CreateUserID