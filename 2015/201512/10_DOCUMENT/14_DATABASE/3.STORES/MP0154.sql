
/****** Object:  StoredProcedure [dbo].[MP0154]    Script Date: 08/02/2010 14:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



--Created by :Hoµng ThÞ Lan 
--Date : 19/12/2003
--Purpose:Dïng cho Report MR0154 (Chi phÝ dë dang cuèi kú s¶n xuÊt)

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0154]  @DivisionID as nvarchar(50),
				 @PeriodID as nvarchar(50)
 AS
Declare @sSQL as nvarchar(4000)

Set @sSQL = '

Select      AT1302_P.InventoryName as ProductName,  AT1302_P.UnitID,  
  AT1302_M.InventoryName as MaterialName,   
	MT0699.UserName,MT1613.* 
 From MT1613     left join At1302 AT1302_P on MT1613.ProductID=AT1302_P.InventoryID and MT1613.DivisionID=AT1302_P.DivisionID  
		left join AT1302 AT1302_M on MT1613.MaterialID = AT1302_M.InventoryID and MT1613.DivisionID = AT1302_M.DivisionID   
		left join MT0699 on MT1613.MaterialTypeID = MT0699.MaterialTypeID and MT1613.DivisionID = MT0699.DivisionID 
Where      AT1302_P.InventoryTypeID=''TP'' 
	 And AT1302_P.Disabled=0 And MT1613.Type=''E'' And MT1613.PeriodID='''+@PeriodID+''' and MT1613.DivisionID = '''+@DivisionID+''''

If not exists (Select top 1 1 From SysObjects Where name = 'MV0154' and Xtype ='V')
	Exec ('Create view MV0154 as '+@sSQL)
Else
	Exec ('Alter view MV0154 as '+@sSQL)


