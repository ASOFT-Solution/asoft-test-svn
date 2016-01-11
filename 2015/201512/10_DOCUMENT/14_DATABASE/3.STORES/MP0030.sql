
/****** Object:  StoredProcedure [dbo].[MP0030]    Script Date: 08/02/2010 13:44:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


--- Created by Van Nhan. Date: 05/05/2009
--- Purpose: Tu dong bo chiet tinh theo quy trinh

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0030] 	@ProcedureID as nvarchar(50),
					@DivisionID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int
				
 AS

Declare @cur as cursor,
		@PeriodID as  nvarchar(50)



	SET @Cur = Cursor Scroll KeySet FOR 	
		Select PeriodID From MT1631 Where ProcedureID=@ProcedureID AND DivisionID = @DivisionID Order by StepID DESC
	Open @Cur
		FETCH NEXT FROM @Cur INTO  @PeriodID			
		WHILE @@Fetch_Status = 0 
		Begin
			Delete MT4000 Where PeriodID =@PeriodID and DivisionID =@DivisionID and TranMonth =@TranMonth and TranYear =@TranYear   --- Bang chiet tinh gia thanh san pham
			Delete MT1614 Where PeriodID =@PeriodID and DivisionID =@DivisionID and TranMonth =@TranMonth and TranYear =@TranYear  --- Bang Gia thanh san pham
			Delete MT0400 Where PeriodID =@PeriodID and DivisionID =@DivisionID and TranMonth =@TranMonth and TranYear =@TranYear --- Bang phan bo
			Update MT1601 set IsDistribute =0, IsCost =0, IsDetailCost=0 Where PeriodID =@PeriodID
			FETCH NEXT FROM @Cur INTO  @PeriodID
		End
	Close @Cur

Update MT1630 set IsDetailCost=0 Where ProcedureID=@ProcedureID
Delete MT1632 Where ProcedureID=@ProcedureID