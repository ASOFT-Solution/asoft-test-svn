
/****** Object:  StoredProcedure [dbo].[MP0160]    Script Date: 08/02/2010 14:23:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


----- Create by: Dang Le Bao Quynh; Date: 15/082007
----- Purpose: Tao view in bao cao chi phi NVL phat sinh theo lo

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0160] 	@DivisionID as nvarchar(50),
					@FromMonth as int,
					@FromYear as int,
					@ToMonth as int,
					@ToYear as int,
					@FromProductID as nvarchar(50),
					@ToProductID as nvarchar(50),
					@FromMaterialID as nvarchar(50),
					@ToMaterialID as nvarchar(50)

AS

DECLARE
	@sSQL as nvarchar(4000)

Set @sSQL = 	'SELECT MV9000.*, 
		(Select InventoryName From AT1302 Where InventoryID = MV9000.ProductID and DivisionID = MV9000.DivisionID) As ProductName, 
		(Select InventoryName From AT1302 Where InventoryID = MV9000.InventoryID and DivisionID = MV9000.DivisionID) As InventoryName 
		FROM MV9000
		WHERE ProductID Between N''' + @FromProductID + ''' And N''' + @ToProductID + ''' 
		And InventoryID Between N''' + @FromMaterialID + ''' And N''' + @ToMaterialID + ''' 
		and DivisionID = N''' + @DivisionID + ''' 
		And TranMonth + TranYear*12 Between ' + ltrim(@FromMonth + @FromYear*12) + ' And '  + ltrim(@FromMonth + @FromYear*12) + ''
		-----ORDER BY Mv9000.ProductID, MV9000.SourceNo, MV9000.InventoryID'

----print @sSQL
If exists (Select id From Sysobjects Where id = Object_ID('MV0160') And xType = 'V')
	Exec (	'Alter View MV0160 --Create by MP0160 
		As 
		' + @sSQL
		)
Else		
	Exec (	'Create View MV0160 --Create by MP0160 
		As 
		' + @sSQL
		)