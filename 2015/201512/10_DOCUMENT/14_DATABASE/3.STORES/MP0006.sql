
/****** Object:  StoredProcedure [dbo].[MP0006]    Script Date: 07/29/2010 17:06:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-----  Created by Nguyen Ngoc My, Date 18/12/2003
----- Purpose: Ket thua bo he so doi tuong

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0006] 	
					@DivisionID nvarchar(50),
					@FromCoefficientID nvarchar(50), 		--- Bo he so duoc ke thua
					@NewCoefficientID  as nvarchar(50), 	--- Luu vao bo he so moi
					@TranMonth as int,
					@TranYear as int

AS

Declare @DeCoefficientID as nvarchar(50),
	@Coe_cur as cursor,
	@PeriodID as nvarchar(520),
	@CoValue as decimal(28,8),
	@Notes as nvarchar(100),
	@CMonth as nvarchar(20) ,
	@CYear as nvarchar(20)
Set @CYear =right(Ltrim(rtrim(str(@TranYear))),4)
SET @Coe_Cur = Cursor Scroll KeySet FOR 

Select
	PeriodID,
	CoValue,
	Notes
From MT1607
Where CoefficientID =   @FromCoefficientID AND DivisionID = @DivisionID

OPEN	@Coe_Cur

FETCH NEXT FROM @Coe_Cur INTO  
	@PeriodID,
	@CoValue,
	@Notes	
WHILE @@Fetch_Status = 0
	Begin
		Exec AP0000  @DivisionID, @DeCoefficientID OUTPUT, 'MT1607', 'MP', @CYear ,'',16, 3, 0, '-'	

		Insert MT1607 	(DivisionID, DeCoefficientID,CoefficientID,	PeriodID, CoValue, Notes )
		Values (@DivisionID, @DeCoefficientID, @NewCoefficientID, @PeriodID, @CoValue, @Notes )		

FETCH NEXT FROM @Coe_Cur INTO  
		@PeriodID,
		@CoValue,
		@Notes	
End


