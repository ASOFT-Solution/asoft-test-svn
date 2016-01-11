
/****** Object:  StoredProcedure [dbo].[MP4003]    Script Date: 12/16/2010 15:28:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Created by Hoàng Thị Lan 
---Date  29/01/2004
--Purpose: Báo cáo chiết tính giá thành
--- Edit by B.Anh, bo sung them xu ly % cho PeriodID
/********************************************
'* Edited by: [GS] [Thành Nguyên] [03/08/2010]
* Edited by: [GS] [Tố Oanh] [16/12/2010]
'********************************************/
-- Last Edit 01/03/2013 by Thiên Huỳnh: Đa chi nhánh

ALTER Procedure  [dbo].[MP4003]	@DivisionID as nvarchar(50),
				@PeriodID as nvarchar(50),
				@FromMonth	as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int
As
Declare @sSQL nvarchar(4000) ,	
	@FromPeriod as int,
	@ToPeriod as int
Set @FromPeriod = @FromMonth +@FromYear *100
Set @ToPeriod = @ToMonth + @ToYear *100

set @sSQL='Select  T00.DivisionID,VoucherTypeID,VoucherNo,VoucherDate,
	T00.PeriodID,T00.Description,ProductID, 
	T01.Description as PeriodName,       
	T02.InventoryName As ProductName,T02.UnitID As ProductUnitID,        
	T00.MaterialTypeID, 
	UserName,
	Case when T99.ExpenseID = ''COST001'' then MaterialID else T00.MaterialTypeID End as MaterialID,
	Case when T99.ExpenseID = ''COST001'' then T03.InventoryName else UserName End As MaterialName,        
	T03.UnitID As MaterialUnitID,
	ConvertedUnit,
	QuantityUnit,
	DetailCostID,
	VoucherID,    
	T99.ExpenseID
From         MT4000 T00  
	Left Join AT1302 T02 On T00.ProductID=T02.InventoryID And T00.DivisionID=T02.DivisionID
	Left Join MT0699 T99 On T00.MaterialTypeID=T99.MaterialTypeID And T00.DivisionID=T99.DivisionID                 
	Left Join AT1302 T03 On T00.MaterialID=T03.InventoryID And T00.DivisionID=T03.DivisionID   
	Left Join MT1601 T01 On T00.PeriodID=T01.PeriodID And T00.DivisionID=T01.DivisionID
	Where         T00.PeriodID like N'''+ @PeriodID + ''' And T00.DivisionID=N'''+ @DivisionID +''' And TranMonth + TranYear *100 between  '+str(@FromPeriod)+' and '+str(@ToPeriod)+''

--print @sSQL
If not exists (Select top 1 1 From SysObjects Where name = 'MV4003' and Xtype ='V')
	Exec ('Create view MV4003 as '+@sSQL)
Else
	Exec ('Alter view MV4003 as '+@sSQL)
