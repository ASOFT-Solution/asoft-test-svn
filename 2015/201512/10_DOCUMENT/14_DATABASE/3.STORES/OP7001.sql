/****** Object:  StoredProcedure [dbo].[OP7001]    Script Date: 12/20/2010 16:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Created by: Vo Thanh Huong, date: 15/11/2004
---purpose: Duoc goi  khi AddNew, Edit phieu xuat cho don hang ban
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'* Edited by: [GS] [Thành Nguyên] [23/08/2010] 
'********************************************/

ALTER PROCEDURE [dbo].[OP7001] 		@OrderID nvarchar(50),
					@DivisionID as nvarchar(50),
					@InventoryID as  nvarchar(50),
					@OldQuantity	Decimal(28,8),
					@NewQuantity	Decimal(28,8),
                    @RemainQuantity_New as decimal(28,8) OUTPUT
AS	
Declare 
	@RemainQuantity_Old as decimal(28,8),
	@VietMess as varchar(250),
	@EngMess as varchar(250),
	@Status as tinyint

Select @Status = 0, @VietMess = '', @EngMess = '' 

Select	
	@RemainQuantity_New = isnull(OrderQuantity, 0) - isnull(ActualQuantity, 0) + isnull(@OldQuantity, 0)  - isnull(@NewQuantity, 0) ,	
	@RemainQuantity_Old = isnull(OrderQuantity, 0) - isnull(ActualQuantity, 0)
From OT2009
Where SOrderID = @OrderID and 
	DivisionID = @DivisionID and
	InventoryID = @InventoryID	

If @RemainQuantity_New < 0 
	Select @Status = 1, @VietMess = N'WFML000048'
--		Select @Status = 1, @VietMess = N'Mặt hàng ' + @InventoryID + N' đã xuất vượt quá số lượng còn lại của đơn hàng :  ' + cast(abs(@RemainQuantity_New) as varchar(30)) 

Return_Values:
	Select @Status as Status, @VietMess as VietMess,@EngMess as  EngMess
