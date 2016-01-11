
/****** Object:  StoredProcedure [dbo].[AP1304]    Script Date: 07/29/2010 17:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------- Created by Nguyen Quoc Huy
------- Created Date 15/10/2003
------- Purpose: KÕ thõa phiÕu xuÊt tõ phiÕu nhËp kho
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1304]  @DivisionID nvarchar(50), 
				@VoucherID as nvarchar(50),
				@WareHouseID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int
 AS

Declare @sSQL nvarchar(4000),
@sSQL1 nvarchar(4000);

Set @sSQL =N'

Select 
	AT07.Orders,
	AT07.InventoryID,
	AT02.InventoryName,
	AT02.MethodID,
	AT02.AccountID,	
	AT02.PrimeCostAccountID,
	AT02.DeliveryPrice,
	AT02.IsSource,
	AT02.IsLocation,
	AT02.IsLimitDate,
	ActEndQty = (Select Sum(EndQuantity) From AT2008 Where DivisionID =N''' + @DivisionID + N'''
							And WareHouseID = N''' + @WareHouseID + N'''
							And InventoryID = AT02.InventoryID
							And TranMonth = '+str(@TranMonth)+N' And TranYear = '+str(@TranYear)+N'),
	AT07.UnitID,
	AT07.ActualQuantity,
	AT07.UnitPrice,
	AT07.OriginalAmount,

	
	
	AT07.Ana01ID,
	AT07.Ana02ID,
	AT07.Ana03ID,

	AT07.TranMonth,
	AT07.TranYear,
	AT07.DivisionID

'
set @sSQL1 = 
N'From   AT2007  AT07 Inner  Join AT1302  AT02 On AT07.InventoryID = AT02.InventoryID and AT07.DivisionID = AT02.DivisionID

Where  AT07.DivisionID = N''' + @DivisionID +N''' And AT07.VoucherID =N''' +@VoucherID + N''' 
		And TranMonth = ' +str(@TranMonth)+' And TranYear = '+str(@TranYear)

--print @sSQL

If not exists (Select top 1 1 From SysObjects Where name = 'AV1304' and Xtype ='V')
	Exec ('Create view AV1304 as '+@sSQL + @sSQL1)
Else
	Exec ('Alter view AV1304 as '+@sSQL + @sSQL1)
GO
