/****** Object:  StoredProcedure [dbo].[OP5012]    Script Date: 12/20/2010 15:45:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Create Procedure : Nguyen Thi Thuy Tuyen
----Create Date :24/05/06
----Purpose :
---- Edit by :
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[OP5012]  
					@DivisionID nvarchar(50),
					@SOrderID as nvarchar(50)
AS

Declare @sSQL1 as nvarchar(4000) 

Set @sSQL1 ='
Select 	
	OT2001.DivisionID,
	OT2001.SOrderID,
	OT2001.ObjectID,
	AT1202.ObjectName,
	OT2001.OrderDate,
	OT2002.InventoryID,
	AT1302.InventoryName,
	OT2002.OrderQuantity,
	OT2001.Notes	
From OT2001 inner Join AT1202 on AT1202.ObjectID = OT2001.ObjectID
	inner Join OT2002 on OT2002.SOrderID= OT2001.SOrderID
	left join AT1302 on AT1302.InventoryID = OT2002.InventoryID
Where OT2001.SOrderID = N'''+@SOrderID+''' '

--print @sSQL1
-----------
If not exists (SELECT Top 1 1 From sysObjects Where XType = 'V'  and Name = 'OV5013')
	EXEC('Create view OV5013 ---tao boi OP5012 as ' + @sSQL1)
Else
	EXEC('Alter View OV5013 ---tao boi OP5012 as '+ @sSQL1)
