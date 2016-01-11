
/****** Object:  StoredProcedure [dbo].[MP0027]    Script Date: 07/29/2010 17:30:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


---- Created by Van Nhan, date 09.06.2008
---- Purpose: In chi tiet quy trinh san xuat

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0027] 	@DivisionID as nvarchar(50),
					@ProcedureID as nvarchar(50),
					@FromProductID as  nvarchar(50),
					@ToProductID as  nvarchar(50)
	
 AS

Declare @sSQL as nvarchar(4000)

Set @sSQL='
Select MT1632.DivisionID, ProductID, P.InventoryName as ProductName,
	MT1632.ExpenseID, 
	Case when MT1632.ExpenseID=''COST001'' then M.InventoryName else UserName end as MaterialName,
	Case when MT1632.ExpenseID=''COST001'' then MaterialID else MT1632.MaterialTypeID end as MaterialID,
	QuantityUnit,
	ConvertedUnit ,
	MT1632.MaterialTypeID,
	MT1632.ProcedureID, MT1630.Description
	
From MT1632 	inner join AT1302 P on P.InventoryID =MT1632.ProductID and P.DivisionID =MT1632.DivisionID
		 left join AT1302 M on M.InventoryID =MT1632.MaterialID and M.DivisionID =MT1632.DivisionID
		left join MT0699 on MT0699.MaterialTypeID=MT1632.MaterialTypeID and MT0699.DivisionID=MT1632.DivisionID 
		inner join MT1630 on MT1630.ProcedureID=MT1632.ProcedureID and MT1630.DivisionID=MT1632.DivisionID
Where 	MT1632.DivisionID ='''+@DivisionID+''' and
	MT1632.ProcedureID='''+@ProcedureID+''' and
	MT1632.ProductID between N'''+@FromProductID+''' and N'''+@ToProductID+'''  
'

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name ='MV0027')
	Exec (' Create view MV0027 as '+@sSQL)
Else
	Exec (' Alter view MV0027 as '+@sSQL)