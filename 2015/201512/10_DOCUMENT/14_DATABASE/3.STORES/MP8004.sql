
/****** Object:  StoredProcedure [dbo].[MP8004]    Script Date: 08/02/2010 13:26:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





--Created by Hoang Thi Lan 
--Date 17/11/2003
--Purpose: Xem Tæng hîp Chi phÝ dë dang
--Edit by: Dang Le Bao Quynh; Date: 21/08/2007
--Purpose: Loai bo nhung san pham co so tien = 0

/********************************************
'* Edited by: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP8004] 
	@DivisionID as nvarchar(50),
	@PeriodID as nvarchar(50)
as

Declare 
	@Type as nvarchar(50),
	@sSQL1 as nvarchar(4000),
	@sSQL2 as nvarchar(4000)
	
Set @Type ='E'
Set @sSQL1=N'
--thong tin Master	
Select MT1613.DivisionID,MT1613.VoucherTypeID, MT1613.VoucherDate ,MT1613.PeriodID,MT1608.Description,MT1613.VoucherNo,MT1613.EmployeeID,
MT1601.InprocessID,
--thong tin Grid Tab 1	
	MT1613.ProductID, MT1613.ProductQuantity,Type, AT1302.InventoryName as ProductName,
	Sum(isnull( MT1613.ConvertedAmount ,0)) as TotalAmount,  --- Tong chi phi DD cuoi ky
	Sum( Case when MT1613.ExpenseID =''COST001'' then isnull( MT1613.ConvertedAmount ,0) else 0 End) as Amount621,
	Sum( Case when MT1613.ExpenseID =''COST002'' then isnull(MT1613.ConvertedAmount,0) else 0 End) as Amount622,
	Sum( Case when MT1613.ExpenseID =''COST003'' then isnull(MT1613.ConvertedAmount,0) else 0 End) as Amount627
From MT1613 inner join MT1601 on MT1601.PeriodID=MT1613.PeriodID and MT1601.DivisionID=MT1613.DivisionID
		left join MT1608 on MT1601.InprocessID=MT1608.InprocessID and MT1608.DivisionID=MT1613.DivisionID
		left join AT1302 on MT1613.ProductID = AT1302.InventoryID and AT1302.DivisionID=MT1613.DivisionID
		
Where 	Type =''B''   and MT1613.PeriodID='''+@PeriodID+''' and MT1613.DivisionID='''+@DivisionID+''' And isnull( MT1613.ConvertedAmount ,0) <> 0
group by MT1613.DivisionID,MT1613.VoucherTypeID, MT1613.VoucherDate, MT1613.PeriodID,MT1608.Description,MT1613.VoucherNo,MT1613.EmployeeID,MT1601.InprocessID,
MT1613.ProductID, MT1613.ProductQuantity,Type, AT1302.InventoryName
Union ALL
Select MT1613.DivisionID,MT1613.VoucherTypeID, MT1613.VoucherDate ,MT1613.PeriodID,MT1608.Description,MT1613.VoucherNo,MT1613.EmployeeID,
MT1601.InprocessID,
	MT1613.ProductID, MT1613.ProductQuantity,Type, AT1302.InventoryName as ProductName,
	Sum(isnull( MT1613.ConvertedAmount ,0)) as TotalAmount,  --- Tong chi phi DD cuoi ky
	Sum( Case when MT1613.ExpenseID =''COST001'' then isnull( MT1613.ConvertedAmount ,0) else 0 End) as Amount621,
	Sum( Case when MT1613.ExpenseID =''COST002'' then isnull(MT1613.ConvertedAmount,0) else 0 End) as Amount622,
	Sum( Case when MT1613.ExpenseID =''COST003'' then isnull(MT1613.ConvertedAmount,0) else 0 End) as Amount627
From MT1613 inner join MT1601 on MT1601.PeriodID=MT1613.PeriodID and MT1601.DivisionID=MT1613.DivisionID
		left join MT1608 on MT1601.InprocessID=MT1608.InprocessID and MT1608.DivisionID=MT1613.DivisionID
		left join AT1302 on MT1613.ProductID = AT1302.InventoryID and AT1302.DivisionID=MT1613.DivisionID' 
	
Set @sSQL2=N'
Where 	Type=''E''   and MT1613.PeriodID='''+@PeriodID+''' and MT1613.DivisionID='''+@DivisionID+''' and 
	 isnull( MT1613.ConvertedAmount ,0) <> 0
group by MT1613.DivisionID,MT1613.VoucherTypeID, MT1613.VoucherDate, MT1613.PeriodID,MT1608.Description,MT1613.VoucherNo,MT1613.EmployeeID,MT1601.InprocessID,
MT1613.ProductID, MT1613.ProductQuantity,Type, AT1302.InventoryName 
Union ALL
Select  MT0400.DivisionID,Null as VoucherTypeID, Null as VoucherDate , MT0400.PeriodID, Null as Description,
	NULL as VoucherNo, Null as EmployeeID, Null as InprocessID,
--thong tin Grid Tab 3	
	MT0400.ProductID, MT0400.ProductQuantity,''C'' as Type, AT1302.InventoryName as ProductName,
	Sum(isnull( MT0400.ConvertedAmount ,0)) as TotalAmount,  --- Tong chi phi DD cuoi ky
	Sum( Case when MT0400.ExpenseID =''COST001'' then isnull( MT0400.ConvertedAmount ,0) else 0 End) as Amount621,
	Sum( Case when MT0400.ExpenseID =''COST002'' then isnull(MT0400.ConvertedAmount,0) else 0 End) as Amount622,
	Sum( Case when MT0400.ExpenseID =''COST003'' then isnull(MT0400.ConvertedAmount,0) else 0 End) as Amount627
From MT0400  
	left join AT1302 on MT0400.ProductID = AT1302.InventoryID and MT0400.DivisionID = AT1302.DivisionID
Where 	MT0400.PeriodID=  '''+@PeriodID+''' and 
	MT0400.DivisionID= '''+@DivisionID+''' and 
	MT0400.ProductID  in (Select Distinct ProductID From MT1001 inner join MT0810 on MT0810.VoucherID = MT1001.VoucherID and MT0810.DivisionID = MT1001.DivisionID
				Where PeriodID = '''+@PeriodID+''' and ResultTypeID =''R03'') 
				
Group by MT0400.DivisionID,MT0400.ProductID, MT0400.ProductQuantity, MT0400.PeriodID, AT1302.InventoryName '

--print @sSQL1+@sSQL2

If not exists (Select top 1 1 From SysObjects Where name = 'MV8004' and Xtype ='V')
	Exec ('Create view MV8004 --MP8004
	 as '+@sSQL1+@sSQL2)
Else
	Exec ('Alter view MV8004 --MP8004
	as '+@sSQL1+@sSQL2)