
/****** Object:  StoredProcedure [dbo].[MP1646]    Script Date: 07/30/2010 17:44:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoang Thi Lan
--Date 29/1/2004
--Purpose : Bao cao chi tiet Gia thanh san pham(MR1646)
-- Last Edit 01/03/2013 by Thiên Huỳnh: Đa chi nhánh

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP1646] 	@DivisionID as nvarchar(50),
					@PeriodID as nvarchar(50),
					@FromMonth as int,
					@FromYear as int,
					@ToMonth as int,
					@ToYear as int

AS
Declare  @sSQL as nvarchar(4000),
		 @FromPeriod as int,
		 @ToPeriod as int
Set @FromPeriod  = @FromMonth + @FromYear*100
Set @ToPeriod = @ToMonth +@ToYear*100
Set @sSQL = '
Select   MT1614.* , AT1302.InventoryName as ProductName, AT1302.UnitID as ProductUnitID,
MT1601.Description AS MT1601_Description
From    MT1614 left 
		join AT1302 on MT1614.ProductID = AT1302.InventoryID And MT1614.DivisionID = AT1302.DivisionID 
		left join MT1601 on MT1614.periodid = MT1601.periodid And MT1614.DivisionID = MT1601.DivisionID 
Where     MT1614.DivisionID = '''+@DivisionID+''' and
MT1614.PeriodID like '''+@PeriodID+''' And TranMonth + TranYear *100 between  '+str(@FromPeriod)+' and '+str(@ToPeriod)+''

If not exists (Select top 1 1 From SysObjects Where name = 'MV1646' and Xtype ='V')
	Exec ('Create view MV1646 as '+@sSQL)
Else
	Exec ('Alter view MV1646 as '+@sSQL)
