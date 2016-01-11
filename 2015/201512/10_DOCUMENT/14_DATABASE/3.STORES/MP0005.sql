
/****** Object:  StoredProcedure [dbo].[MP0005]    Script Date: 07/29/2010 17:04:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-----  Created by Nguyen Ngoc My, Date 17/12/2003
----- Purpose: Ket thua bo he so san pham

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0005] 	
					@FromCoefficientID nvarchar(50), 		--- Bo he so duoc ke thua
					@NewCoefficientID  as nvarchar(50), 	--- Luu vao bo he so moi
					@TranMonth as int,
					@TranYear as int

AS

Declare @DeCoefficientID as nvarchar(50),
	@Coe_cur as cursor,
	@InventoryID as nvarchar(50),
	@CoValue as decimal(28,8),
	@Notes as nvarchar(100),
	@CMonth as nvarchar(20) ,
	@CYear as nvarchar(20)
Set @CYear =right(Ltrim(rtrim(str(@TranYear))),4)

SET @Coe_Cur = Cursor Scroll KeySet FOR 

Select
	InventoryID,
	CoValue,
	Notes
From MT1605
Where CoefficientID =   @FromCoefficientID
OPEN	@Coe_Cur

FETCH NEXT FROM @Coe_Cur INTO  
	@InventoryID,
	@CoValue,
	@Notes	
WHILE @@Fetch_Status = 0
	Begin
		Exec AP0000  @DeCoefficientID OUTPUT, 'MT1605', 'MI', @CYear ,'',16, 3, 0, '-'	

		Insert MT1605 	(DeCoefficientID,CoefficientID,	InventoryID,CoValue,Notes )
		Values (@DeCoefficientID, @NewCoefficientID, @InventoryID, @CoValue, @Notes )		

FETCH NEXT FROM @Coe_Cur INTO  
		@InventoryID,
		@CoValue,
		@Notes	
End

