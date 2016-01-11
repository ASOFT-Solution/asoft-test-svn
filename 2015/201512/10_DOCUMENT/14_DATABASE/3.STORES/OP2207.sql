
/****** Object:  StoredProcedure [dbo].[OP2207]    Script Date: 12/16/2010 13:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 23/02/2004
---purpose: Ke thua cac thanh pham tu don hang  ban cho don hang mua
/********************************************
'* Edited by: [GS] [Tố Oanh] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP2207]  @DivisionID nvarchar(50),
				@lstSOrderID nvarchar(50)
AS
Declare @sSQL  nvarchar(4000)

Set  @lstSOrderID = 	Replace(@lstSOrderID, ',', ''',''')
Set @sSQL ='Select T00.DivisionID, T00.InventoryID , InventoryName, T01.UnitID, 		
		 T01.VATPerCent, sum(T00.OrderQuantity) as OrderQuantity, T00.AdjustQuantity
	From OT2002 T00 inner join AT1302 T01 on T00.InventoryID = T01.InventoryID
		inner join OT2001 T02 on T02.SOrderID = T00.SOrderID 
	Where T02.DivisionID = ''' + @DivisionID + ''' and T00.SOrderID in (''' + @lstSOrderID + ''')
	Group by T00.DivisionID, T00.InventoryID , InventoryName, T01.UnitID,  T01.VATPerCent, T00.AdjustQuantity'


If not exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2207')
	EXEC('Create view OV2207 ----tao boi OP2207
			as ' + @sSQL)
Else	
	EXEC('Alter view OV2207 ----tao boi OP2207
			as ' + @sSQL)