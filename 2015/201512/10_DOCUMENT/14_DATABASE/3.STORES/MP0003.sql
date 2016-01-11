
/****** Object:  StoredProcedure [dbo].[MP0003]    Script Date: 07/29/2010 17:00:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



------- Created by Hoang Thi Lan Date 1/12/2003
------- Purpose: In chi phi SXC

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/


ALTER PROCEDURE [dbo].[MP0003] 
				@DivisionID nvarchar(50),
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int,
				@PeriodID as nvarchar(50),
				@IsPeriod as tinyint			
			
AS
Declare @sSQL as nvarchar(4000),
	@strWhere as nvarchar(4000)

If @IsPeriod = 1
	Set @strWhere = ' and MV9000.PeriodID like '''+@PeriodID+''' '
Else
	Set @strWhere = ' and ( MV9000.TranMonth + 100*MV9000.TranYear between  '+str(@FromMonth)+' + 100*'+str(@FromYear)+' and  '+str(@ToMonth)+' + 100*'+str(@ToYear)+')  '


Set @sSQL ='
Select    MV9000.DivisionID, MV9000.PeriodID,
		MV9000.ProductID ,
		MV9000.DebitAccountID,
		MV9000.CreditAccountID,
		AT1302.InventoryName as ProductName,
		MV9000.MaterialTypeID,
		MT0699.UserName,
		
		Sum(Isnull(ConvertedAmount,0)) as ConvertedAmount
From MV9000  left  join AT1302 on AT1302.InventoryID = MV9000.ProductID and AT1302.DivisionID = MV9000.DivisionID
		left join MT0699 on MV9000.MaterialTypeID =MT0699.MaterialTypeID and MV9000.DivisionID =MT0699.DivisionID
Where 	MV9000.ExpenseID = ''COST003'' and
	MV9000.DivisionID = '''+@DivisionID+''' '
Set @sSQL = @sSQL+ @strWhere+' 
Group by MV9000.DivisionID, MV9000.DebitAccountID,MV9000.PeriodID, MT0699.UserName,MV9000.CreditAccountID, AT1302.InventoryName,MV9000.MaterialTypeID,MV9000.ProductID '
	
	--Print @sSQL

If not exists (Select top 1 1 From SysObjects Where name = 'MV0003' and Xtype ='V')
	Exec ('Create view MV0003 as '+@sSQL)
Else
	Exec ('Alter view MV0003 as '+@sSQL)

