
/****** Object:  StoredProcedure [dbo].[OP2010]    Script Date: 07/30/2010 14:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 15/11/2004
---Purpose: Update vao bang OT2009 khi luu phieu xuat kho cho don hang ban
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP2010] @DivisionID nvarchar(50),
				@OrderID nvarchar(50),
				@InventoryID_Old nvarchar(50),
				@InventoryID_New nvarchar(50),
				@Quantity_Old decimal (28,8),
				@Quantity_New decimal (28,8)			
 AS
Declare @sSQL nvarchar(4000)
If isnull(@InventoryID_Old, '')  =  isnull(@InventoryID_New, '')
	Update OT2009 Set ActualQuantity = ActualQuantity - @Quantity_Old + @Quantity_New
		Where DivisionID = @DivisionID and
			SOrderID = @OrderID and
			InventoryID = @InventoryID_Old
else
Begin	
	Update OT2009 Set ActualQuantity =  ActualQuantity - @Quantity_Old 
		Where DivisionID = @DivisionID and
			SOrderID = @OrderID and
			InventoryID = @InventoryID_Old	
	
	Update OT2009 Set ActualQuantity =  ActualQuantity + @Quantity_New
		Where DivisionID = @DivisionID and
			SOrderID = @OrderID and
			InventoryID = @InventoryID_New	
End








