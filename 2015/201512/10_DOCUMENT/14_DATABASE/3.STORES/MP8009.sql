
/****** Object:  StoredProcedure [dbo].[MP8009]    Script Date: 08/02/2010 13:42:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoang Thi Lan
--Date 05/11/2003
--Purpose:Bao cao ket qua phan bo cho doi tuong THCP

/********************************************
'* Edited by: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP8009] 
	@PeriodID as nvarchar(50),
	@VoucherNo as nvarchar(50),
	@VoucherTypeID as nvarchar(50)
as
Declare @sSQL as nvarchar(4000)
Set @sSQL =N'
	Select AT1302_P.InventoryName as ProductName,AT1302_M.InventoryName as MaterialName ,
	Case when MT0400.ExpenseID =''COST001'' then isnull( MT0400.ConvertedAmount ,0) else 0 End as Amount621,
	Case when MT0400.ExpenseID =''COST001'' then isnull( MT0400.ConvertedUnit ,0) else 0 End as AmountUnit621,
	Case when MT0400.ExpenseID =''COST002'' then isnull( MT0400.ConvertedAmount ,0) else 0 End as Amount622,
	Case when MT0400.ExpenseID =''COST002'' then isnull( MT0400.ConvertedUnit ,0) else 0 End as AmountUnit622,
	Case when MT0400.ExpenseID =''COST003'' then isnull( MT0400.ConvertedAmount ,0) else 0 End as Amount627,
	Case when MT0400.ExpenseID =''COST003'' then isnull( MT0400.ConvertedUnit ,0) else 0 End as AmountUnit627,
	Case when MT0400.ExpenseID =''COST001'' then  MT0699.UserName else ''''  End as UserName621,
	Case when MT0400.ExpenseID =''COST002'' then  MT0699.UserName else ''''  End as UserName622,
	Case when MT0400.ExpenseID =''COST003'' then  MT0699.UserName else ''''  End as UserName627,
	UserName,
	MT0400.* 
	From MT0400	 left join AT1302 AT1302_P on MT0400.ProductID = AT1302_P.InventoryID
			left join AT1302 AT1302_M on MT0400.MaterialID = AT1302_M.InventoryID	
			left join MT0699 on MT0400.ExpenseID = MT0699.ExpenseID and MT0699.MaterialTypeID = MT0400.MaterialTypeID

	Where PeriodID ='''+@PeriodID+''' and VoucherNo = '''+@VoucherNo+''' and VoucherTypeID ='''+@VoucherTypeID+''''
If not exists (Select top 1 1 From SysObjects Where name = 'MV8009' and Xtype ='V')
	Exec ('Create view MV8009 as '+@sSQL)
Else
	Exec ('Alter view MV8009 as '+@sSQL)



