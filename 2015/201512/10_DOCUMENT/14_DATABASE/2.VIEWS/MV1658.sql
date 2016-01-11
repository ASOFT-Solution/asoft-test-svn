/****** Object:  View [dbo].[MV1658]    Script Date: 12/21/2010 14:02:53 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[MV1658]'))
DROP VIEW [dbo].[MV1658]
GO
/****** Object:  View [dbo].[MV1658]    Script Date: 12/21/2010 14:02:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[MV1658] as 
Select 
	MT1618.DivisionID,
	MT1618.InprocessID, 
	MT1618.IsUsed, 
	MT0699.MaterialTypeID, 
	MT0699.UserName,
	MT1618.ExpenseID,
	MT1608.BeginMethodID,
	MT1619.EndMethodID , 
	MT1619.Description , 
	MT1618.ApportionID, 
	MT1602.Description as ApportionName,
	InProcessDetailID
From MT1618     Right Join MT0699 On    MT1618.MaterialTypeID = MT0699.MaterialTypeID And MT1618.DivisionID = MT0699.DivisionID 
		 And (IsNull(MT1618.InProcessID,'')='111,bbb,222,ddd'  Or IsNull(MT1618.InProcessID,'')='')
	Left Join MT1619 On MT1618.EndMethodID=MT1619.EndMethodID And MT1618.DivisionID=MT1619.DivisionID
	inner join MT1608 on MT1608.InprocessID = MT1618.InprocessID And MT1608.DivisionID = MT1618.DivisionID
	left join MT1602 on MT1618.ApportionID = MT1602.ApportionID And MT1618.DivisionID = MT1602.DivisionID
Where  MT0699.Isused = 1

GO


