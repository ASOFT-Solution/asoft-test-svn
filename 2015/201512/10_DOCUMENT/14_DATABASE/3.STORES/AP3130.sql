/****** Object:  StoredProcedure [dbo].[AP3130]    Script Date: 07/29/2010 13:59:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---- 	Created by Nguyen Van Nhan.
----	Created Date 23/06/2005
-----	Purpose: Tru di Interest va Bonus da tinh o thang truoc
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[AP3130] @DivisionID as nvarchar(50), 
				@FromObjectID as nvarchar(50), 
				@ToObjectID as nvarchar(50), 
				@AccountID as nvarchar(50),  	
				@CurrencyID  as nvarchar(50), 
				@Month as int,
				@Year as int

AS

Declare 	@AT3131_cur as cursor,
		@InterestAmount as decimal (28,8),
		@BonusAmount as decimal (28,8),
		@LinkID as nvarchar(50),
		@CalID as nvarchar(50),
		@SumInterestAmount as decimal (28,8),
		@SumBonusAmount as decimal (28,8)

SET @AT3131_cur = Cursor Scroll KeySet FOR 
Select  CalID, VoucherID+ObjectID, InterestAmount, BonusAmount From AT3131
Where CalMonth = @Month and CalYear = @Year and DivisionID = @DivisionID 
and  ObjectID+VoucherID in ( Select  ObjectID+VoucherID From AT3131 Where CalMonth + CalYear*100< @Month + 100*@Year and DivisionID =@DivisionID )
Order by ObjectID+VoucherID

OPEN	@AT3131_cur

FETCH NEXT FROM @AT3131_cur  INTO @CalID, @LinkID, @InterestAmount, @BonusAmount
WHILE @@Fetch_Status = 0
	Begin	
		
		Set @SumInterestAmount =0 
		Set @SumBonusAmount = 0
		Select @SumInterestAmount = Sum(InterestAmount), @SumBonusAmount = sum(BonusAmount)
		From AT3131 
		Where DivisionID = @DivisionID and CalMonth + CalYear*100 < @Month + 100*@Year and 
			VoucherID+ObjectID = @LinkID 		

		Update AT3131 set	 InterestAmount = InterestAmount - isnull(@SumInterestAmount,0),
				 	BonusAmount = BonusAmount - isnull(@SumBonusAmount,0)
		Where CalID = @CalID and DivisionID = @DivisionID and CalMonth = @Month and CalYear = @Year 
		FETCH NEXT FROM @AT3131_cur  INTO @CalID, @LinkID, @InterestAmount, @BonusAmount
	End

Close @AT3131_cur

Delete AT3131 Where	 DivisionID = @DivisionID and CalMonth = @Month and CalYear = @Year and 
			 InterestAmount = 0 and BonusAmount = 0