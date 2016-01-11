/****** Object:  StoredProcedure [dbo].[MP5001]    Script Date: 01/21/2011 15:44:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----- Created by Nguyen Van Nhan,  Date 14/10/2003
----- Purpose: Loc ra ca dong de edit len Form "Thiet lap PP phan bo chi phi"
--Edited by: Vo Thanh Huong, xu ly lai truong hop them vao dinh nghia  ma chi phi, date : 20/04/2005 
/********************************************
'* Edited by: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP5001] @DistributionID as nvarchar(50)
 AS

Declare  @sSQL as nvarchar(max)

Set @sSQL ='
Select 	MT5001.DivisionID, isnull(MT5001.MaterialTypeID, MT0699.MaterialTypeID) as MaterialTypeID, MT0699.UserName,
	MT0699.IsUsed,
	IsCoefficient = isnull((Select top 1 IsCoefficient From MT5002 Where DistributedMethod = MT5001.MethodID and DivisionID = MT5001.DivisionID),0),
	IsApportion = isnull((Select top 1 IsApportion From MT5002 Where DistributedMethod = MT5001.MethodID and DivisionID=MT5001.DivisionID),0),
	MT5001.DeDistributionID,
	MT5001.DistributionID,
	MT0699.ExpenseID,	
	MT5001.MethodID as DistributedMethod,
	MT5002.Description,
	MT5001.CoefficientID,
	MT5001. ApportionID,
	MT5001.IsDistributed 
From MT5001 	inner join MT5000 on MT5000.DistributionID = MT5001.DistributionID and MT5000.DivisionID = MT5001.DivisionID
		right join MT0699 on MT0699.MaterialTypeID = MT5001.MaterialTypeID And MT0699.DivisionID = MT5001.DivisionID And MT5001.DistributionID = N'''+@DistributionID+'''
		Left join MT5002 on MT5002.DistributedMethod = MT5001.MethodID and MT5002.DivisionID = MT5001.DivisionID
Where  MT0699.IsUsed = 1'

If not exists (Select top 1  1 From SysObjects Where name = 'MV5001' and Xtype ='V')
	Exec ('Create view MV5001 as '+@sSQL)
Else
	Exec ('Alter view MV5001 as '+@sSQL)
