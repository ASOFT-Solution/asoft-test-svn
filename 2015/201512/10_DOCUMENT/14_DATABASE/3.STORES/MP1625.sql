
/****** Object:  StoredProcedure [dbo].[MP1625]    Script Date: 07/29/2010 15:29:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoang Thi Lan
--Purpose :Xem lai 
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'**************************************************************/
ALTER procedure [dbo].[MP1625] @DivisionID as nvarchar(50),@PeriodID as nvarchar(50),@FromMonth as int,@FromYear as int,@ToMonth as int,@ToYear as int 
as
declare @Status as tinyint,@sSQL as nvarchar(4000),
@FromPeriod as int,@ToPeriod as int

Set @FromPeriod=@FromMonth+@FromYear*100
Set @ToPeriod=@ToMonth+@ToYear*100
Set @Status=0
set @sSQL='
Select ProductID,PeriodID, AT9000.DivisionID
From AT9000
Where PeriodID='''+@PeriodID+''' and 
	 AT9000.TranMonth+AT9000.TranYear*100 between '+str(@FromPeriod)+' and '+str(@ToPeriod)+'
	and AT9000.DivisionID='''+@DivisionID+'''
	and (AT9000.ExpenseID=''COST001'' or (Isnull(AT9000.ExpenseID,'''')='''' and
							DebitAccountID in (Select AccountID 
								  From MT0700
							 Where MT0700.ExpenseID=''COST001'' 	)))
		and IsNull(AT9000.MaterialTypeID,'''')='''''
--print @sSQL
If not exists (Select top 1 1 From SysObjects Where name = 'MV1625' and Xtype ='V')
	Exec ('Create view MV1625 as '+@sSQL)
Else
	Exec ('Alter view MV1625 as '+@sSQL)





