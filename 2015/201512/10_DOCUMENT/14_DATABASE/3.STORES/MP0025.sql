
/****** Object:  StoredProcedure [dbo].[MP0025]    Script Date: 07/29/2010 17:27:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by Van Nhan and Bao Anh, date 05.06.2008
---- Purpose In bao cao chiet tinh gia thanh theo Quy trinh

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0025] 
		@DivisionID as nvarchar(50), 
		@TranMonth as int, 
		@TranYear as int, 
		@ProcedureID as nvarchar(50)
 AS

Declare @sSQL as nvarchar(4000)

Set @sSQL='
Select MT1632.DivisionID, MT1632.ProcedureID, MT1630.Description, VoucherNo, VoucherDate, VoucherTypeID,
	 ProductID, P.InventoryName as ProductName, MT1632.ExpenseID, 
	Case when MT1632.ExpenseID=''COST001'' then M.InventoryName else UserName end as MaterialName,
	Case when MT1632.ExpenseID=''COST001'' then MaterialID else MT1632.MaterialTypeID end as MaterialID,
	QuantityUnit,
	ConvertedUnit ,
	MT1632.MaterialTypeID
	
From MT1632 	inner join MT1630 on MT1630.ProcedureID=MT1632.ProcedureID and MT1630.DivisionID=MT1632.DivisionID
		inner join AT1302 P on P.InventoryID =MT1632.ProductID and P.DivisionID =MT1632.DivisionID
		left join AT1302 M on M.InventoryID =MT1632.MaterialID and M.DivisionID =MT1632.DivisionID
		left join MT0699 on MT0699.MaterialTypeID=MT1632.MaterialTypeID and MT0699.DivisionID=MT1632.DivisionID 
Where 	MT1632.DivisionID ='''+@DivisionID+''' and
	MT1632.TranMonth='+ltrim(@TranMonth)+' and
	MT1632.TranYear='+ltrim(@TranYear)+' and
	MT1632.ProcedureID='''+@ProcedureID+'''
'

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name ='MV0025')
	Exec (' Create view MV0025 as '+@sSQL)
Else
	Exec (' Alter view MV0025 as '+@sSQL)