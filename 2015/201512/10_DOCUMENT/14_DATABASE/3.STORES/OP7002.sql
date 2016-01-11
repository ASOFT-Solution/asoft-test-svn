
/****** Object:  StoredProcedure [dbo].[OP7002]    Script Date: 08/04/2010 13:41:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Created by: Vo Thanh Huong, date: 15/11/2004
---purpose: Duoc goi  khi AddNew, Edit phieu nhap  cho don hang mua
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP7002] 		@OrderID nvarchar(50),
					@DivisionID as nvarchar(50),
					@InventoryID as  nvarchar(50),
					@OldQuantity	Decimal(28,8),
					@NewQuantity	Decimal(28,8)
AS	
Declare @RemainQuantity_New as decimal(28,8),
	@RemainQuantity_Old as decimal(28,8),
	@VietMess as nvarchar(250),
	@EngMess as nvarchar(250),
	@Status as tinyint

Select @Status = 0, @VietMess = '', @EngMess = '' 

Select	@RemainQuantity_New = isnull(OrderQuantity, 0)  -  isnull(ActualQuantity, 0) + isnull(@OldQuantity, 0) - isnull(@NewQuantity, 0) ,	
	@RemainQuantity_Old = isnull(OrderQuantity, 0)  -  isnull(ActualQuantity, 0)
		From OT3009
		Where  POrderID = @OrderID and
			DivisionID = @DivisionID and
			InventoryID = @InventoryID	

	If @RemainQuantity_New < 0 
		Select @Status = 1, @VietMess = N'MÆt hµng ' + @InventoryID + N' ®· xuÊt v­ît qu¸ sè l­îng cßn l¹i cña ®¬n hµng lµ :  ' + cast(abs(@RemainQuantity_New) as varchar(30))  ,
		 @EngMess = N'InventoryID ' + @InventoryID + N'excess of delivery over  order :  ' + cast(abs(@RemainQuantity_New) as varchar(30))  
Return_Values:
	Select @Status as Status,@VietMess as VietMess,@EngMess as  EngMess
GO
