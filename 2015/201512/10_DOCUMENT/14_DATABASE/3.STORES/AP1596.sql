/****** Object:  StoredProcedure [dbo].[AP1596]    Script Date: 07/29/2010 13:48:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created by Nguyen Quoc Huy
---Created Date: 16/05/2007

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/
 
ALTER PROCEDURE [dbo].[AP1596]	 
				@DivisionID nvarchar(50),
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int
				
				
 AS

declare @FromPeriod as int,
	  @ToPeriod as int,
	  @sSQL as nvarchar(4000),
	  @Condition as nvarchar(100)	
  
SET @Condition = '(0, 1, 2, 3, 4, 5)'

SET @FromPeriod = @FromMonth + @FromYear * 100
SET @ToPeriod = @ToMonth + @ToYear * 100

----- Lay bao cao so chi tiet TSCD-----------------------
set @sSQL = '	
SELECT AT1503.DivisionID,
	AT1503.AssetID,
	AT1503.AssetName, 
	AT1503.AssetGroupID,
	AT1503.BeginMonth,  
	AT1503.BeginYear,
	AT1503.CauseID,
	AT1503.AssetStatus,
	(Case when exists (select top 1 AssetID 
						from AT1506 
						Where AssetID = AT1503.AssetID and DivisionID = AT1503.DivisionID
							and AT1506.TranMonth + 100 * AT1506.TranYear <= ' + str(@ToPeriod) + ')
	Then (select top 1 AT1506.ConvertedNewAmount
			From AT1506 
			Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
				and AT1506.TranMonth + 100*AT1506.TranYear <=' + str(@ToPeriod) + '
			Order by AT1506.TranYear Desc,AT1506.TranMonth Desc)
	Else AT1503.ConvertedAmount end) as ConvertedAmount, 

	AT1503.AssetAccountID,
	AccuDepAmount = ((Case when exists (select top 1 AssetID 
										from AT1506 
										Where AssetID = AT1503.AssetID and DivisionID = AT1503.DivisionID
					 						and AT1506.TranMonth + 100 * AT1506.TranYear <= ' + str(@ToPeriod) + ')
						Then (select top 1 AT1506.ConvertedNewAmount
								From AT1506 
								Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
									and AT1506.TranMonth + 100 * AT1506.TranYear <=' + str(@ToPeriod) + ' 
								Order by AT1506.TranYear Desc,AT1506.TranMonth Desc)
						Else AT1503.ConvertedAmount end) 
					- (Case when exists (Select top 1 AssetID 
											From AT1506 
											Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
												and AT1506.TranMonth + 100 * AT1506.TranYear <=' + str(@ToPeriod) + ')
						Then  (select top 1 isnull(AT1506.ConvertedNewAmount,0)  
								From AT1506 
								Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
									and AT1506.TranMonth + 100 * AT1506.TranYear <= ' + str(@ToPeriod) + '  
								Order by AT1506.TranYear Desc,AT1506.TranMonth Desc)
						Else isnull(AT1503.ResidualValue, 0) end)
					+ isnull((Select Sum(DepAmount) 
								From AT1504 
								Where DivisionID = AT1503.DivisionID and AssetID = At1503.AssetID 
									and	AT1504.TranMonth + AT1504.TranYear * 100 <= ' + str(@ToPeriod) + '), 0)),

	DepAmount = isnull((Select Sum(DepAmount) 
						From AT1504 
						Where DivisionID = AT1503.DivisionID and AssetID = At1503.AssetID 
							and	AT1504.TranMonth+AT1504.TranYear * 100 between ' + str(@FromPeriod) + ' and ' + str(@ToPeriod) + '), 0),
	
	(Case when exists (select top 1 AssetID 
						from AT1506 
						Where AssetID = AT1503.AssetID and DivisionID = AT1503.DivisionID
							and AT1506.TranMonth + 100 * AT1506.TranYear between ' + str(@FromPeriod) + ' and ' + str(@ToPeriod) + ')
	Then (select top 1 AT1506.ConvertedNewAmount  
			From AT1506 
			Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
				and AT1506.TranMonth + 100 * AT1506.TranYear between ' + str(@FromPeriod) + ' and ' + str(@ToPeriod) + '
			Order by AT1506.TranYear Desc,AT1506.TranMonth Desc)
	Else AT1503.ConvertedAmount end) as IncAmount
FROM AT1503 Left join AT1523 on AT1523.AssetID = AT1503.AssetID and AT1523.DivisionID = AT1503.DivisionID
WHERE AT1503.DivisionID like ''' + @DivisionID + ''' and AT1503.AssetStatus in '+ @Condition + '
	and AT1503.BeginMonth + AT1503.BeginYear * 100 <= ' + str(@ToPeriod) + '
	and AT1503.AssetID not in (select AssetID 
								from AT1523 
								where AT1523.ReduceMonth + AT1523.ReduceYear * 100 < ' + str(@ToPeriod)+ '
								and DivisionID = ' + @DivisionID + ') '

--Print @sSQL
     	

If Not Exists (Select 1 From sysObjects Where Name ='AV1596')
	Exec ('Create view AV1596 as '+@sSQL)
Else
	Exec( 'Alter view AV1596 as '+@sSQL)