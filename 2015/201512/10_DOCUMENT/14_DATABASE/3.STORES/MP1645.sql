
/****** Object:  StoredProcedure [dbo].[MP1645]    Script Date: 07/29/2010 16:21:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoang Thi Lan
--Date 27/11/2003
--Purpose : Bao cao chi tiet Gia thanh san pham(MR1645)
--Edit by: Vo Thanh Huong, date: 24/05/2005

/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[MP1645] 	@DivisionID as nvarchar(50),
					@PeriodID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int
AS
Declare  @sSQL as nvarchar(max)

Set @sSQL = '
Select   MT1614.* , AT1302.InventoryName as ProductName, AT1302.UnitID as ProductUnitID
 From      MT1614 left join AT1302 on MT1614.ProductID = AT1302.InventoryID And MT1614.DivisionID = AT1302.DivisionID 
Where     MT1614.DivisionID = '''+@DivisionID+''' and
 PeriodID  = '''+@PeriodID+''''

If  exists (Select top 1 1 From SysObjects Where name = 'MV1645' and Xtype ='V')
	DROP VIEW MV1645

Exec ('Create view MV1645 as '+@sSQL)