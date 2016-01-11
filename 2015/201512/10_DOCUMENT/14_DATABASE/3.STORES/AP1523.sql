/****** Object:  StoredProcedure [dbo].[AP1523]    Script Date: 07/29/2010 11:33:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Creater :Nguyen Thi Thuy Tuyen.
---Creadate:08/08/2006
-- Puppose :Lay du lieu cho man hinh giam TSCD   !
-- Last Edit : Thuy Tuyen 08/08/2008

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1523]  
				@DivisionID nvarchar(50),
				@TranMonth int,
				@TranYear int
				
				
				
AS
Declare @sSQL nvarchar(4000)
Set @sSQL = ' 
SELECT  
	DivisionID,
	AssetID,
 	AssetName,
	DepartmentID,
	EmployeeID,
	(Case when exists (select top 1 AssetID 
						from AT1506 
						Where AssetID = AT1503.AssetID and DivisionID = AT1503.DivisionID
							and AT1506.TranMonth + 100*AT1506.TranYear <=' + str(@TranMonth) + ' + 100 * ' + str(@TranYear) + ')
	Then (select top 1 AT1506.ConvertedNewAmount 
			From AT1506 
			Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
					and AT1506.TranMonth + 100 * AT1506.TranYear <= ' + str(@TranMonth) + ' + 100 * ' + str(@TranYear) + '
			Order by AT1506.TranYear Desc,AT1506.TranMonth Desc)
	Else AT1503.ConvertedAmount end) as ConvertedAmount, 
	(Case when exists (Select top 1 AssetID 
						From AT1506 
						Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
							and AT1506.TranMonth + 100 * AT1506.TranYear <= ' + str(@TranMonth) + '+ 100 * ' + str(@TranYear) + ')
	Then (select top 1 AT1506.DepNewPeriods
			From AT1506 
			Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
					and AT1506.TranMonth + 100 * AT1506.TranYear <= ' + str(@TranMonth) + ' + 100 * ' + str(@TranYear) + ' 
			Order by AT1506.TranYear Desc,AT1506.TranMonth Desc)
	Else AT1503.DepPeriods end) as DepPeriods,
	AssetStatus ,
	------ResidualValue- (Select sum(DepAmount) From AT1504 Where AssetID = AT1503.AssetID) as RemainAmount,
	(Case when exists (Select top 1 AssetID 
						From AT1506 
						Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
							and AT1506.TranMonth + 100 * AT1506.TranYear <= ' + str(@TranMonth) + '+ 100 * ' + str(@TranYear) + ')
	Then  (select top 1 AT1506.ResidualNewValue  
			From AT1506 
			Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
				and AT1506.TranMonth + 100 * AT1506.TranYear <= ' + str(@TranMonth) + ' + 100 * ' + str(@TranYear) + ' 
			Order by AT1506.TranYear Desc,AT1506.TranMonth Desc)
	Else AT1503.ResidualValue end)
	+ 
	(Case when exists (Select top 1 AssetID 
						From AT1506 
						Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
							and AT1506.TranMonth + 100 * AT1506.TranYear <= ' + str(@TranMonth) +  ' + 100 * ' + str(@TranYear) + ')
	Then (select top 1 AT1506.AccuDepAmount  - (Isnull(T03.ConvertedAmount, 0) - isnull(T03.ResidualValue,0))  
			From AT1506 Inner Join AT1503 T03 on T03.AssetID = AT1506.AssetID
			Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
				and AT1506.TranMonth + 100 * AT1506.TranYear <= ' + str(@TranMonth) + ' + 100 * ' + str(@TranYear) + ' 
			Order by AT1506.TranYear Desc,AT1506.TranMonth Desc)
	Else 0 end)
	- 
	(Select sum(DepAmount) From AT1504 Where AssetID = AT1503.AssetID) as RemainAmount,
	
	ConvertedAmount - ResidualValue + (Select sum(DepAmount) 
										From AT1504 
										Where AssetID = AT1503.AssetID) as AccuDepAmount,										
	DepreciatedMonths = isnull( (Select Count(*) 
									From (Select Distinct AssetID, TranMonth, TranYear 
											From AT1504
											Group by TranMonth, AssetID, TranYear)  A							 
									Where A.AssetID = AT1503.AssetID  
										and A.TranMonth + A.TranYear * 100 <= '+ str(@Tranmonth) + ' + ' + str(@TranYear) + ' * 100), 0)
						+ isnull(AT1503.DepMonths,0)	 		
FROM AT1503
WHERE DivisionID = ''' + @DivisionID + '''
	AND AssetStatus in (0,1,4) 
	and	AssetID not in (Select AssetID 
						From AT1523) 
	and	AssetID not in (Select AssetID 
						From AT1504 
						WHERE TranMonth + TranYear * 100 >= '+ str(@Tranmonth) + ' + ' + str(@TranYear ) + ' * 100)
	
'
---Print @sSQL
If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='AV1523')
	Exec(' Create view AV1523 as '+ @sSQL )
Else
	Exec(' Alter view AV1523 as '+@sSQL)