
/****** Object:  StoredProcedure [dbo].[MP1658]    Script Date: 07/30/2010 17:47:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoang Thi Lan 
--Date 1/12/2003
--Purpose :In bao cao Xac dinh chi phi do dang(MR1618)

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP1658] @InProcessID as nvarchar(50)
 as 
Declare @sSQL as nvarchar(4000)
Set @sSQL ='
Select MT1618.InprocessID,MT1618.DivisionID, MT1618.IsUsed, MT0699.MaterialTypeID, MT0699.UserName,MT1618.ExpenseID,MT1608.BeginMethodID,
 MT1619.EndMethodID , MT1619.Description , MT1618.ApportionID, 
 MT1602.Description as ApportionName,
 InProcessDetailID,
 MT1608.Description as InprocessName
From MT1618     Right Join MT0699 On    MT1618.MaterialTypeID = MT0699.MaterialTypeID And MT1618.DivisionID = MT0699.DivisionID 
			 And (IsNull(MT1618.InProcessID,'''')='''+@InProcessID+'''  Or IsNull(MT1618.InProcessID,'''')='''')
		Left Join MT1619 On MT1618.EndMethodID=MT1619.EndMethodID And MT1618.DivisionID = MT1619.DivisionID
		inner join MT1608 on MT1608.InprocessID = MT1618.InprocessID And MT1608.DivisionID = MT1618.DivisionID
		left join MT1602 on MT1618.ApportionID = MT1602.ApportionID And MT1618.DivisionID = MT1602.DivisionID
Where  MT0699.Isused = 1 '

If not exists (Select top 1 1 From SysObjects Where name = 'MV1658' and Xtype ='V')
	Exec ('Create view MV1658   -----tao boi MP1658
	as '+@sSQL)
Else
	Exec ('Alter view MV1658   -----tao boi MP1658
	as '+@sSQL)



