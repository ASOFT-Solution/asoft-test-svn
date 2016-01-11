
/****** Object:  StoredProcedure [dbo].[OP2009]    Script Date: 12/16/2010 11:26:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created byVo Thanh Huong, date: 15/11/2004
---purpose :Tao du lieu ke thua du lieu mat hang va so luong con lai cua don hang ban cho phieu xuat
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/
 
ALTER PROCEDURE [dbo].[OP2009] 	@DivisionID nvarchar(50),
				@OrderID nvarchar(50)
	
AS 
DECLARE @sSQL nvarchar(4000)

 
Select  @sSQL = ''

Set @sSQL = 'Select T00.DivisionID, T00.InventoryID, A00.InventoryName, isnull(A00.UnitID, '''') as UnitID, 
	sum(T00.SalePrice * T00.OrderQuantity/T01.OrderQuantity) as UnitPrice ,	
	avg(T01.OrderQuantity) as OrderQuantity,
	avg(isnull(T01.ActualQuantity, 0)) as ActualQuantity,
avg(T01.OrderQuantity - isnull(T01.ActualQuantity,0)) as RemainQuantity
From OT2002  T00 inner join 
	(SELECT DivisionID, InventoryID, OrderQuantity, ActualQuantity From OT2009  
Where SOrderID = ''' + @OrderID + ''' and DivisionID = ''' + @DivisionID + '''and 
	OrderQuantity - isnull(ActualQuantity,0) <> 0 )  
	T01 on T00.InventoryID = T01.InventoryID 
	inner join AT1302  A00 on A00.InventoryID = T00.InventoryID 
Where 	T00.SOrderID = ''' + @OrderID + '''
Group by T00.DivisionID, T00.InventoryID,  A00.InventoryName,  A00.UnitID, T01.OrderQuantity'


If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2009')
	Drop view OV2009 
EXEC('Create view OV2009 ----tao boi OP2009
		as ' + @sSQL)





