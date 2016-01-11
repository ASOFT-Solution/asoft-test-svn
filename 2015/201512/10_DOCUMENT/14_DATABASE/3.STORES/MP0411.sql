
/****** Object:  StoredProcedure [dbo].[MP0411]    Script Date: 07/30/2010 10:00:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-----Created by: Vo Thanh Huong, date: 12/4/2006
-----purpose: Lay du lieu load len man hinh Xem tong hop do dang
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0411]  @DivisionID nvarchar(50),
				@PeriodID nvarchar(50)	
 AS

Declare 	@sSQL as nvarchar(4000)

Set @sSQL='
Select 		MT0400.PeriodID, 	 
		MT0400.DivisionID, 	
		MT0400.TranMonth, 	
		MT0400.TranYear, 	
		MT0400.VoucherTypeID,  	 
		MT0400.VoucherNo, 	
		MT0400.VoucherDate, 		
		MT0400.ResultTypeID, 		
		MT1601.Description as PeriodName,	
		MT0400.Description, 	
		MT0400.EmployeeID, 	
		AT1103.FullName,
		MT1601.DistributionID,
		MT1601.InProcessID,
		
		MT0400.ProductID, 	
		AT1302.InventoryName as ProductName,
		AT1302.UnitID, 		
		sum(isnull(MT0400.ProductQuantity, 0) + isnull(MT0400.InProcessQuantity,0)) as ProductQuantity,	
		sum(isnull(MT0400.ProductQuantity, 0) + isnull(MT0400.InProcessQuantity,0)) as InProcessQuantity,	
		Sum(isnull( MT0400.ConvertedAmount ,0)) as TotalAmount,  --- Tong chi phi DD cuoi ky
		Sum( Case when MT0400.ExpenseID =''COST001'' then isnull( MT0400.ConvertedAmount ,0) else 0 End) as Amount621,
		Sum( Case when MT0400.ExpenseID =''COST002'' then isnull(MT0400.ConvertedAmount,0) else 0 End) as Amount622,
		Sum( Case when MT0400.ExpenseID =''COST003'' then isnull(MT0400.ConvertedAmount,0) else 0 End) as Amount627
From MT0400 left  join AT1103 on AT1103.EmployeeID = MT0400.EmployeeID and AT1103.DivisionID = MT0400.DivisionID 
		left join AT1302 on AT1302.InventoryID = MT0400.ProductID and AT1302.DivisionID = MT0400.DivisionID 
		inner join MT1601 on MT1601.PeriodID= MT0400.PeriodID and MT1601.DivisionID= MT0400.DivisionID
Where MT0400.DivisionID = ''' + @DivisionID + ''' and 	MT0400.PeriodID = ''' + @PeriodID + '''
GROUP BY MT0400.PeriodID, 	 
		MT0400.DivisionID, 	
		MT0400.TranMonth, 	
		MT0400.TranYear, 	
		MT0400.VoucherTypeID,  	 
		MT0400.VoucherNo, 	
		MT0400.VoucherDate, 		
		MT0400.ResultTypeID, 		
		MT1601.Description,  	 
		MT0400.Description, 	
		MT0400.EmployeeID, 	
		AT1103.FullName,
		MT1601.DistributionID,
		MT1601.InProcessID,		
		MT0400.ProductID, 	
		AT1302.InventoryName,
		AT1302.UnitID' 		


If not exists (Select top 1 1 From SysObjects Where name = 'MV0411' and Xtype ='V')
	Exec ('Create view MV0411 as '+@sSQL)
Else
	Exec ('Alter view MV0411 as '+@sSQL)