/****** Object:  StoredProcedure [dbo].[AP9997]    Script Date: 07/30/2010 10:01:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Van Nhan, 09/12/2007
----  Kiem tra tinh hop le khi khoa so
---- Edit by Nguyen Quoc Huy, Date 01/09/2008
---- Modify on 08/06/2015 by Bảo Anh: Lấy PeriodNum từ thông tin đơn vị AT1101  
/********************************************
'* Edited by: [GS] [Thanh Trẫm] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP9997] @DivisionID nvarchar(50), 	
				@TranMonth as int, 
				@TranYear as int

 AS

Declare @Message as nvarchar(4000), 		
		@Status as tinyint,
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

---- Status =0,1,2 (0 OK, 1 OKOnly, 2 Yes_No)
		

Set	@Status=0
Set 	@Message =''


-----1. Kiem tra cac module da khoa so hay chua? -----------------------------

If Not Exists (Select top 1 1 From FT9999 Where DivisionID =@DivisionID and TranMonth =@NextMonth and TranYear =@NextYear) and Exists (Select top 1 1 From AT1503 Where DivisionID =@DivisionID)
   Begin
	Set	@Status=1
	Set 	@Message ='AFML000109'	
End

If Not Exists (Select top 1 1 From WT9999 Where DivisionID =@DivisionID and TranMonth =@NextMonth and TranYear =@NextYear) 
   Begin
	Set	@Status=1
	Set 	@Message ='AFML000110'	
End

-----2. Kiem tra da ket chuyen hay chua?  ------------------------------------------------


---------- Tra ra gia tri --------------------------------------------------------------------------------------------------------

RESULT:
Select @Status as Status, @Message as Message