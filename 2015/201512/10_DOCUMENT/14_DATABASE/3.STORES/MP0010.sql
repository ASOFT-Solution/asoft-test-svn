/****** Object:  StoredProcedure [dbo].[MP0010]    Script Date: 07/29/2010 17:10:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--- Created by Van Nhan, Date 10/08/2006

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0010] 
	@DivisionID nvarchar(50), 
	@VoucherID as nvarchar(50)
AS

Declare 
@PeriodID as nvarchar(50),
@Status as tinyint,
@Message as nvarchar(250)
	
Set @Status =0
Set @Message=''
	
Set @PeriodID = (Select PeriodID From MT0810 Where DivisionID = @DivisionID and VoucherID = @VoucherID)

Set @PeriodID =isnull(@PeriodID,'')

If @PeriodID <>''
	If Exists (Select top 1 1 From MT1601 Where PeriodID = @PeriodID and (IsDistribute = 1 or IsCost = 1 or IsInprocess =1) AND DivisionID = @DivisionID)
		Begin 
			set @Status = 1
			Set @Message ='MFML000037'
		End


Select @Status as Status, @Message as Message
