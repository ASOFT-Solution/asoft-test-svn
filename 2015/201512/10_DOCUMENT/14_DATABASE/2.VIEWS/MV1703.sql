IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MV1703]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[MV1703]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Created by Nguyen Van Nhan 
--Purpose:Dung cho Report MR1605(Bo dinh muc)
--Edit by: Mai Duyen, Date 16/09/2014: Bo sung M.I02ID,M.Specification  (KH Jacon)

CREATE VIEW [dbo].[MV1703] as 
Select  
	( MT1603.ExpenseID) as GroupID ,
	(Case when MT1603.ExpenseID = 'COST001' then 'MFML000039' else 
		Case when MT1603.ExpenseID ='COST002' then 'MFML000040' else
		'MFML000041' end end ) as GroupName,
	MT1603.ApportionID,
	MT1603.DivisionID,
	MT1602.Description,
	MT1603.ExpenseID,		
	ProductID,
	P.InventoryName as ProductName,
	IsNull(MT1603.UnitID, P.UnitID) AS ProductUnitID, 
	(Case when MT1603.ExpenseID ='COST001' then MaterialID else MT1603.MaterialTypeID End) as MaterialID, 
	(Case when MT1603.ExpenseID ='COST001' then M.InventoryName else UserName End) as MaterialName,
	IsNull(MT1603.MaterialUnitID, M.UnitID) AS MaterialUnitID, 
	MT1603.ProductQuantity,
	MT1603.MaterialQuantity,
	MT1603.QuantityUnit,
	MT1603.MaterialAmount,
	MT1603.ConvertedUnit,
	M.I02ID,M.Specification 	
 From MT1603  	
		Left join AT1302 P on P.InventoryID = MT1603.ProductID and  P.DivisionID = MT1603.DivisionID
		Left join AT1302 M on M.InventoryID = MT1603.MaterialID and  M.DivisionID = MT1603.DivisionID
		Left join MT1602 on MT1602.ApportionID = MT1603.ApportionID and  MT1602.DivisionID = MT1603.DivisionID
		Left join MT0699 on  MT0699.MaterialTypeID = MT1603.MaterialTypeID and  MT0699.DivisionID = MT1603.DivisionID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

