
/****** Object:  StoredProcedure [dbo].[MP0020]    Script Date: 07/29/2010 17:11:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

---- Kiem tra dieu kien truoc khi Chiet tinh.

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/


ALTER PROCEDURE [dbo].[MP0020]  	
		@DivisionID as nvarchar(50),
		@ProcedureID as nvarchar(50)					
 AS

Declare @sSQL as nvarchar(4000),
	@PeriodID as nvarchar(50),
	@Cur as Cursor,
	@Status as tinyint,
	@Message as nvarchar(4000)	

	Set @Status=0

SET @Cur = Cursor Scroll KeySet FOR 
	Select 	PeriodID
	From MT1631
	Where ProcedureID=@ProcedureID AND DivisionID = @DivisionID
	Order by StepID

OPEN	@Cur
FETCH NEXT FROM @Cur INTO  @PeriodID
WHILE @@Fetch_Status = 0
	Begin	
		----Print 'test '+@PeriodID
		if Exists (select top 1 1 From MT1601 where PeriodID =@PeriodID and IsDetailCost =0 AND DivisionID = @DivisionID)
			Begin
					Set @Status =1
					--Set @Message= 'Tồn tại đối tượng THCP: '+@PeriodID+' chưa có chiết tính giá thành. Không thêt thực hiện chiết tính giá thành quy trình sản xuất được.'
					Set @Message= 'MFML000119'
			End 
	FETCH NEXT FROM @Cur INTO  @PeriodID
	End

-- giống table AT7777
Select @DivisionID as DivisionID, '' as UserID, @Status as [Status], @Message as [Message], @PeriodID as PeriodID
 
        
