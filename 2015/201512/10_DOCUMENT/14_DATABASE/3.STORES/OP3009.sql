
/****** Object:  StoredProcedure [dbo].[OP3009]    Script Date: 12/16/2010 14:34:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created byVo Thanh Huong, date: 15/11/2004
---purpose :Tao du lieu ke thua  don hang mua cho phieu nhap
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [03/08/2010]
'**************************************************************/
 
ALTER PROCEDURE [dbo].[OP3009] 	@DivisionID nvarchar(50),
				@OrderID nvarchar(50)
	
AS 
DECLARE @sSQL nvarchar(4000)
	
 
Set  @sSQL = ''

Set @sSQL = 'Select T00.DivisionID, T00.InventoryID, A00.InventoryName, isnull(A00.UnitID, '''') as UnitID, 
	sum(T00.PurchasePrice * T00.OrderQuantity/T01.OrderQuantity) as UnitPrice ,	
	avg(T01.OrderQuantity) as OrderQuantity,
	avg(isnull(T01.ActualQuantity, 0)) as ActualQuantity,
	avg(T01.OrderQuantity - isnull(T01.ActualQuantity,0)) as RemainQuantity
From OT3002  T00 inner join 
	(SELECT InventoryID, OrderQuantity, ActualQuantity From OT3009  
Where POrderID = ''' + @OrderID + ''' and DivisionID = ''' + @DivisionID + '''and 
	OrderQuantity - isnull(ActualQuantity,0) <> 0 )  
	T01 on T00.InventoryID = T01.InventoryID 
	inner join AT1302  A00 on A00.InventoryID = T00.InventoryID 
Where 	T00.POrderID = ''' + @OrderID + '''
Group by T00.DivisionID, T00.InventoryID,  A00.InventoryName,  A00.UnitID, T01.OrderQuantity'

	If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV3009')
		Drop view OV3009 
	EXEC('Create view OV3009 ----tao boi OP2009
			as ' + @sSQL)






