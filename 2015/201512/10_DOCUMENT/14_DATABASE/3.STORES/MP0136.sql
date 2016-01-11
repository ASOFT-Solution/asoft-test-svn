IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0136]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0136]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load thiết lập bộ định mức theo quy cách - MF0136
-- <History>
---- Created by Tiểu Mai on 02/12/2015
---- Modified on ... by 
-- <Example>


CREATE PROCEDURE [dbo].[MP0136] 	
	@DivisionID NVARCHAR(50),
	@ListApportionID NVARCHAR(500)
AS
DECLARE @sSQL1 NVARCHAR(MAX)

---- Load bộ định mức theo quy cách MT0136
SET @sSQL1 = '
SELECT MT0135.DivisionID, MT0135.ApportionID, MT0135.[Description], MT0135.ObjectID, AT1202.ObjectName,MT0135.InventoryTypeID,AT1301.InventoryTypeName, MT0135.[Disabled], MT0135.ApportionTypeID,
MT0135.IsBOM, MT0136.TransactionID, MT0136.ProductID,AT1302.InventoryName, MT0136.UnitID, MT0136.ProductQuantity,MT0136.S01ID, MT0136.S02ID, MT0136.S03ID, MT0136.S04ID, MT0136.S05ID,
MT0136.S06ID, MT0136.S07ID, MT0136.S08ID, MT0136.S09ID, MT0136.S10ID, MT0136.S11ID, MT0136.S12ID, MT0136.S13ID, MT0136.S14ID, MT0136.S15ID,
MT0136.S16ID, MT0136.S17ID, MT0136.S18ID, MT0136.S19ID, MT0136.S20ID, MT0136.Parameter01, MT0136.Parameter02, MT0136.Parameter03, MT0136.Orders,
TotalAmount = ( Select Sum(Case When A.ExpenseID =''COST001''  Or  A.ExpenseID <>''COST001'' and MT0699.IsUsed = 1
 				then IsNull(MaterialAmount,0) Else 0 End )  	From  MT0137  A  Left join  MT0699 on MT0699.MaterialTypeID = A.MaterialTypeID  and MT0699.DivisionID = A.DivisionID
								Where  A.ProductID = MT0137.ProductID  and A.DivisionID = MT0137.DivisionID AND A.ReTransactionID = MT0136.TransactionID
								),
Sum(Case when MT0137.ExpenseID =''COST001''  then 	isnull(MaterialAmount,0) else 0 end) as TotalAmount621,
Sum(Case when MT0137.ExpenseID =''COST002'' And MT0699.IsUsed=1 then 	isnull(MaterialAmount,0) else 0 end) as TotalAmount622,
Sum(Case when MT0137.ExpenseID =''COST003'' And MT0699.IsUsed=1 then 	isnull(MaterialAmount,0) else 0 end) as TotalAmount627,
ProductCost = ( Select Sum(Case When A.ExpenseID =''COST001''  Or  A.ExpenseID <>''COST001'' and MT0699.IsUsed = 1
 				then IsNull(MaterialAmount,0) Else 0 End )  	From  MT0137  A  Left join  MT0699 on MT0699.MaterialTypeID = A.MaterialTypeID  and MT0699.DivisionID = A.DivisionID
								Where A.ProductID = MT0137.ProductID and A.DivisionID = MT0137.DivisionID and A.ReTransactionID = MT0137.ReTransactionID)/isnull(MT0136.ProductQuantity,1)

	
From MT0135
LEFT JOIN MT0136 ON MT0135.DivisionID = MT0136.DivisionID AND MT0135.ApportionID = MT0136.ApportionID
LEFT JOIN MT0137 ON MT0136.DivisionID = MT0137.DivisionID AND MT0136.ProductID = MT0137.ProductID AND MT0137.ReTransactionID = MT0136.TransactionID
Left  join MT0699 on  MT0699.MaterialTypeID = MT0137.MaterialTypeID and MT0699.DivisionID = MT0137.DivisionID
LEFT JOIN AT1202 ON AT1202.ObjectID = MT0135.ObjectID AND AT1202.DivisionID = MT0135.DivisionID
LEFT JOIN AT1301 ON AT1301.DivisionID = AT1202.DivisionID AND AT1301.InventoryTypeID = MT0135.InventoryTypeID
LEFT JOIN AT1302 ON AT1302.DivisionID = MT0136.DivisionID AND At1302.InventoryID = Mt0136.ProductID
WHERE MT0135.ApportionID in ('''+@ListApportionID+''')
		AND MT0135.DivisionID = '''+@DivisionID+'''
Group by MT0137.DivisionID, MT0135.DivisionID, MT0135.ApportionID, MT0135.[Description], MT0135.ObjectID, AT1202.ObjectName,MT0135.InventoryTypeID,AT1301.InventoryTypeName, MT0135.[Disabled], MT0135.ApportionTypeID,
MT0135.IsBOM, MT0136.TransactionID, MT0136.ProductID,AT1302.InventoryName, MT0136.UnitID, MT0136.ProductQuantity,MT0136.S01ID, MT0136.S02ID, MT0136.S03ID, MT0136.S04ID, MT0136.S05ID,
MT0136.S06ID, MT0136.S07ID, MT0136.S08ID, MT0136.S09ID, MT0136.S10ID, MT0136.S11ID, MT0136.S12ID, MT0136.S13ID, MT0136.S14ID, MT0136.S15ID,
MT0136.S16ID, MT0136.S17ID, MT0136.S18ID, MT0136.S19ID, MT0136.S20ID,
MT0137.ProductID,	ProductQuantity, MT0136.TransactionID, MT0136.Parameter01, MT0136.Parameter02, MT0136.Parameter03, MT0137.ReTransactionID, MT0136.Orders
Order by MT0136.Orders
' 
EXEC (@sSQL1)
--PRINT @sSQL1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
