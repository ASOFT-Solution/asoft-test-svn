
/****** Object:  StoredProcedure [dbo].[MP0420]    Script Date: 07/30/2010 10:01:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-----Created by: Vo Thanh Huong, date: 24/4/2006
-----purpose: In bao cao phan bo thanh pham
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0420]  @DivisionID nvarchar(50),
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
		AT1302.UnitID as PUnitID, 		
		AT1302.InventoryName as ProductName,
		MT0400.ExpenseID,
		MT0400.MaterialTypeID, 
		MT0699.UserName as MaterialTypeName,
		MT0400.MaterialID,
		AT1302_M.InventoryName as MaterialName, 
		isnull(MT0400.InProcessQuantity,0) as InProcessQuantity,
		isnull(MT0400.ProductQuantity,0) as ProductQuantity,		
		isnull(MT0400.MaterialQuantity,  0) as MaterialQuantity,
		isnull(MT0400.QuantityUnit, 0) as QuantityUnit, 
		isnull(MT0400.ConvertedAmount, 0) as ConvertedAmount,
		isnull(MT0400.ConvertedUnit, 0) as ConvertedUnit
		
From MT0400 	left  join AT1103 on AT1103.EmployeeID = MT0400.EmployeeID and AT1103.DivisionID = MT0400.DivisionID 
		left join AT1302 on AT1302.InventoryID = MT0400.ProductID and AT1302.DivisionID = MT0400.DivisionID 
		left join AT1302 AT1302_M  on AT1302_M.InventoryID = MT0400.ProductID and AT1302_M.DivisionID = MT0400.DivisionID 
		inner join MT1601 on MT1601.PeriodID =  MT0400.PeriodID and MT1601.DivisionID =  MT0400.DivisionID
		inner join MT0699 on MT0699.MaterialTypeID = MT0400.MaterialTypeID and MT0699.DivisionID = MT0400.DivisionID 
Where MT0400.DivisionID = ''' + @DivisionID + ''' and 	MT0400.PeriodID = ''' + @PeriodID + ''' and MT0400.ResultTypeID= ''R01''' 		


If not exists (Select top 1 1 From SysObjects Where name = 'MV0420' and Xtype ='V')
	Exec ('Create view MV0420 as '+@sSQL)
Else
	Exec ('Alter view MV0420 as '+@sSQL)