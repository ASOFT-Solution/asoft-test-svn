
/****** Object:  StoredProcedure [dbo].[MP1609]    Script Date: 07/29/2010 14:48:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by :Hoang Thi Lan
--Date 27/11/2003
--Purpose: Bao cao chi tiet bo dinh muc (MR1603)
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[MP1609]  @ApportionID as nvarchar(50)

 AS 
Declare @sSQL as nvarchar(4000)
Set @sSQL='
	Select MV1602.*, AT1302.InventoryName as ProductName, AT1302.DivisionID
	From MV1602 Inner Join AT1302 On AT1302.InventoryID=MV1602.ProductID 
	Where MV1602.ApportionID= '''+@ApportionID+''''
	

If not exists (Select top 1 1 From SysObjects Where name = 'MV1609' and Xtype ='V')
	Exec ('Create view MV1609 as '+@sSQL)
Else
	Exec ('Alter view MV1609 as '+@sSQL)

