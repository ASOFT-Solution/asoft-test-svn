
/****** Object:  StoredProcedure [dbo].[OP7004]    Script Date: 08/04/2010 13:41:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Created by: Vo Thanh Huong, date: 31/12/2004
---purpose: Duoc goi  khi Edit don hang mua dang nhan hang
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP7004] 		@OrderID nvarchar(50),
					@DivisionID  nvarchar(50),
					@OldInventoryID   nvarchar(50),
					@NewInventoryID nvarchar(50),
					@OldQuantity	Decimal(28,8),
					@NewQuantity	Decimal(28,8)
AS	
Declare @RemainQuantity_New as decimal(28,8),
	@InventoryID nvarchar(50), 	
	@RemainQuantity_Old as decimal(28,8),
	@VietMess as varchar(250),
	@EngMess as varchar(250),
	@Status as tinyint

Select @Status = 0, @VietMess = '', @EngMess = '' 

If  @OldInventoryID = @NewInventoryID 
	Select	@RemainQuantity_New = isnull(OrderQuantity, 0)  -  isnull(ActualQuantity, 0) -  isnull(@OldQuantity, 0) + isnull(@NewQuantity, 0)
		From OT3009
		Where  POrderID = @OrderID and
			DivisionID = @DivisionID and
			InventoryID = @InventoryID	
else 
	Select	@RemainQuantity_New = isnull(OrderQuantity, 0)  -  isnull(ActualQuantity, 0) -  isnull(@OldQuantity, 0) 
		From OT3009
		Where  POrderID = @OrderID and
			DivisionID = @DivisionID and
			InventoryID = @InventoryID	

If @RemainQuantity_New < 0 
	Select @Status = 1, @VietMess = N'MÆt hµng ' + @InventoryID + N' ®· nhËp v­ît qu¸ sè l­îng ®Æt hµng :  ' +
		 cast(abs(@RemainQuantity_New) as varchar(30)) 

Return_Values:
	Select @Status as Status,@VietMess as VietMess,@EngMess as  EngMess
GO
