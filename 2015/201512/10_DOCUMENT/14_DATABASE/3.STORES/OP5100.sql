
/****** Object:  StoredProcedure [dbo].[OP5100]    Script Date: 12/20/2010 15:47:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Create by:Thuy Tuyen, date: 28/12/2006
----Purpose:  so sanh SO va ID Lay ra mat hang chua co trong IO 
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP5100]  @DivisionID as nvarchar(50),
				  @IOrderID  as nvarchar(50)
				
				
AS

DECLARE
 @sSQL as  nvarchar(4000), 
 @InheritSOrderID as  nvarchar (4000)

Set  @InheritSOrderID =( Select Isnull( Replace (InheritSOrderID, ','  ,  ''',N'''),'a') From OT2001 Where SOrderID =  ''+@IOrderID+'')
Set  @InheritSOrderID = '(N''' + isnull(@InheritSOrderID,'a') + ''')'

---Print @InheritSOrderID
---Print 'tuyen'
---- Lay nhung phieu khong co don hang SX
Set @sSQL='
Select  
	OT2002.DivisionID,
	OT2002.SOrderID, 
	OT2002.InventoryID,OrderQuantity, 
	SalePrice, ConvertedAmount, 
	AT1302.UnitID,OT2002.Notes, 
	OrderDate,InventoryName,
	''-'' as IsStatus
From OT2002 
	Inner Join OT2001 on OT2001.SOrderID = OT2002.SOrderID
	Inner Join AT1302 on AT1302.InventoryID = OT2002.InventoryID
Where OT2002.SOrderID in  '+@InheritSOrderID+' and 
	OT2002.InventoryID not in 
	(
		Select InventoryID
		From OT2002 Inner Join OT2001 on OT2001.SOrderID = OT2002.SOrderID
		Where OrderType = 1 and 
			OT2001.SOrderID = N'''+@IOrderID+'''
	)'
----Print @sSQL

If not exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV5110')
	EXEC('Create View OV5110 ---tao boi OP5100 
	as ' + @sSQL )
else
	EXEC('Alter View OV5110 ---tao boi OP5100 
	as ' + @sSQL)
	
---- Lay nhung phieu khong co don hang ban
Set @sSQL='
Select  
	OT2002.DivisionID,
	OT2002.SOrderID, 
	OT2002.InventoryID,OrderQuantity, 
	SalePrice, ConvertedAmount, 
	AT1302.UnitID,OT2002.Notes, 
	OrderDate,InventoryName,
	''+'' as IsStatus
From OT2002 
	Inner Join OT2001 on OT2001.SOrderID = OT2002.SOrderID
	Inner Join AT1302 on AT1302.InventoryID = OT2002.InventoryID
Where OT2002.SOrderID =  N'''+@IOrderID+''' and 
	OT2002.InventoryID not in 
	(
		Select  InventoryID
		From OT2002  Inner Join OT2001 on OT2001.SOrderID = OT2002.SOrderID
		Where OrderType = 0 and OT2001.SOrderID in  '+@InheritSOrderID+'   
	)'
----Print @sSQL

If not exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV5120')
	EXEC('Create View OV5120 ---tao boi OP5100 
	as ' + @sSQL )
else
	EXEC('Alter View OV5120 ---tao boi OP5100 
	as ' + @sSQL)

Set @sSQL ='
Select DivisionID, SOrderID, InventoryID,OrderQuantity, SalePrice, ConvertedAmount, UnitID,Notes, OrderDate,InventoryName,IsStatus
From OV5110
union
Select DivisionID, SOrderID, InventoryID,OrderQuantity, SalePrice, ConvertedAmount, UnitID,Notes, OrderDate,InventoryName,IsStatus
From OV5120

'
If not exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV5100')
	EXEC('Create View OV5100 ---tao boi OP5100 
	as ' + @sSQL )
else
	EXEC('Alter View OV5100 ---tao boi OP5100 
	as ' + @sSQL)
