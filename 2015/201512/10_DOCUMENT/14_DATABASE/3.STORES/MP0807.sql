
/****** Object:  StoredProcedure [dbo].[MP0807]    Script Date: 07/30/2010 10:20:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- 	Created by Van Nhan, Date 11/07/2008.
----	Purpose: In bao cao kqua san xuat chuyen sang ky sau va chuyen tu ky truoc sang
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0807] 	@DivisionID as nvarchar(50),
					@ProcdureID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int
 AS

Declare @sSQL as nvarchar(4000)

---- Chuyen den, so du dau ky
Set @sSQL='
Select Distinct	PeriodID as FromPeriodID, ProductID, TransferPeriodID as PeriodID,
	Quantity as BeginQuantity, MT1001.ConvertedAmount as BeginAmount, MT1001.DivisionID
From MT1001 inner join MT0810 on MT0810.VoucherID = MT1001.VoucherID and MT0810.DivisionID = MT1001.DivisionID
WHere MT0810.ResultTypeID =''R01'' and IsTransfer=1 and IsWarehouse=0 and
	MT1001.DivisionID ='''+@DivisionID+''' and	
	TransferPeriodID in (Select PeriodID From MT1631 Where ProcedureID='''+@ProcdureID+''') and
	PeriodID not in (Select PeriodID From MT1631 Where ProcedureID='''+@ProcdureID+''')  '

If not exists (Select top 1 1 From SysObjects Where name = 'MV0805' and Xtype ='V')
	Exec ('Create view MV0805 as '+@sSQL)
Else
	Exec ('Alter view MV0805 as '+@sSQL)


---- Chuyen di, so du cuoi ky
Set @sSQL='
Select Distinct	PeriodID as PeriodID, ProductID, TransferPeriodID as ToPeriodID,
	Quantity as EndQuantity, MT1001.ConvertedAmount as EndAmount, MT1001.DivisionID
From MT1001 inner join MT0810 on MT0810.VoucherID = MT1001.VoucherID and MT0810.DivisionID = MT1001.DivisionID
WHere MT0810.ResultTypeID =''R01'' and IsTransfer=1 and IsWarehouse=0 and
	MT1001.DivisionID ='''+@DivisionID+''' and	
	TransferPeriodID not in (Select PeriodID From MT1631 Where ProcedureID='''+@ProcdureID+''') and
	PeriodID  in (Select PeriodID From MT1631 Where ProcedureID='''+@ProcdureID+''')  '


	If not exists (Select top 1 1 From SysObjects Where name = 'MV0806' and Xtype ='V')
	Exec ('Create view MV0806 as '+@sSQL)
Else
	Exec ('Alter view MV0806 as '+@sSQL)

set @sSQL='
select Distinct	isnull(MV0805.ProductID, MV0806.ProductID) as ProductID,
	AT1302.InventoryName,AT1302.DivisionID,
	FromPeriodID, 
	isnull(MV0805.PeriodID,MV0806.PeriodID) as PeriodID, ToPeriodID,
	isnull(BeginQuantity, 0) as BeginQuantity, isnull(BeginAmount,0) as BeginAmount,
	isnull(EndQuantity,0) as EndQuantity, isnull(EndAmount,0) as EndAmount
 From MV0805 full join MV0806 on 	MV0806.ProductID = MV0805.ProductID and MV0806.DivisionID = MV0805.DivisionID and
					MV0806.PeriodID = MV0805.PeriodID
		Left join AT1302 on 	AT1302.InventoryID = isnull(MV0805.ProductID, MV0806.ProductID) and AT1302.DivisionID = MV0805.DivisionID '

If not exists (Select top 1 1 From SysObjects Where name = 'MV0807' and Xtype ='V')
	Exec ('Create view MV0807 as '+@sSQL)
Else
	Exec ('Alter view MV0807 as '+@sSQL)