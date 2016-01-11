
/****** Object:  StoredProcedure [dbo].[MP1626]    Script Date: 07/29/2010 15:32:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


--Created by Hoang Thi Lan
--Date 8/1/2004
--Purpose :Dïng hiÓn thÞ d÷ liÖu lªn Grid cña Form (Danh môc phiÕu CPDDCKú)
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[MP1626] @DivisionID as nvarchar(50),@PeriodID as nvarchar(50),
			@FromMonth as int,
			@FromYear as int,
			@ToMonth as int,
			@ToYear as int
as
Declare @FromPeriod as int,
	@ToPeriod as int,
	@sSQL as nvarchar(4000)
Set @FromPeriod=@FromMonth+@FromYear*100
Set @ToPeriod=@ToMonth+@ToYear*100
	

Set @sSQL = '
Select  VoucherID,
	VoucherTypeID,
	VoucherNo,
	EmployeeID,
	VoucherDate,
	MT1613.DivisionID,
	MT1613.PeriodID,
	ProductID,
	AT1302.InventoryName as ProductName,at1302.UnitID,
	ProductQuantity, sum(ConvertedAmount)  as ConvertedAmount

	
From MT1613 left join AT1302 on MT1613.ProductID = AT1302.InventoryID
		inner join MT1601 on MT1613.PeriodID = MT1601.PeriodID and MT1601.IsInprocess = 1
Where MT1613.DivisionID='''+ @DivisionID +'''
	and TranMonth+TranYear*100 between '+str(@FromPeriod)+' and '+str(@ToPeriod)+'
	and MT1613.Type = ''E''	
	and MT1613.PeriodID like '''+@PeriodID+'''
Group by
VoucherID,
	VoucherTypeID,
	VoucherNo,
	EmployeeID,
	VoucherDate,
	MT1613.DivisionID,
	MT1613.PeriodID,
	ProductID,UnitID,
	AT1302.InventoryName,
	ProductQuantity'

--print @sSQL
If not Exists (Select top 1 1 From SysObjects Where Xtype ='V' and name ='MV1626')
	 Exec ('Create view MV1626 as '  +@sSQL)
Else
	Exec ('Alter view MV1626 as '+@sSQL)






