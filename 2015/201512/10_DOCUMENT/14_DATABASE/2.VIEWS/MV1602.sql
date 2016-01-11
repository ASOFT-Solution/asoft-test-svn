IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MV1602]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[MV1602]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- Tra du lieu ra View hien thi chi tiet dinh muc cac san pham cua bo dinh muc
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Nguyen Van Nhan on: 21/10/2003.
---- Modified on 20/09/2012 by Bao Anh: Them 3 cot tham so (VPS)
---- Modified on 03/03/2015 by Thanh Sơn: Thêm mã và tên công đoạn
-- <Example>
/*
	 
*/	

CREATE VIEW MV1602
AS 
SELECT MT1603.ApportionID, ProductID, ProductQuantity,
	--QuantityUnit,
	--ConvertedUnit,
	MT1602.Description, MT1603.DivisionID,
--	MT1603.ApportionProductID,
	InventoryTypeID, MT1603.PhaseID, A26.PhaseName,
	MT1603.MParameter01, MT1603.MParameter02, MT1603.MParameter03,
	TotalAmount = ( Select Sum(Case When A.ExpenseID ='COST001'  Or  A.ExpenseID <>'COST001' and MT0699.IsUsed = 1
 					then IsNull(MaterialAmount,0) Else 0 End )  	From  MT1603  A  Left join  MT0699 on MT0699.MaterialTypeID = A.MaterialTypeID  and MT0699.DivisionID = A.DivisionID
								 Where  A.ApportionID = MT1603.ApportionID And  A.ProductID = MT1603.ProductID  and A.DivisionID = MT1603.DivisionID
									),

	Sum(Case when MT1603.ExpenseID ='COST001'  then 	isnull(MaterialAmount,0) else 0 end) as TotalAmount621,
	Sum(Case when MT1603.ExpenseID ='COST002' And MT0699.IsUsed=1 then 	isnull(MaterialAmount,0) else 0 end) as TotalAmount622,
	Sum(Case when MT1603.ExpenseID ='COST003' And MT0699.IsUsed=1 then 	isnull(MaterialAmount,0) else 0 end) as TotalAmount627,
	ProductCost = ( Select Sum(Case When A.ExpenseID ='COST001'  Or  A.ExpenseID <>'COST001' and MT0699.IsUsed = 1
 					then IsNull(MaterialAmount,0) Else 0 End )  	From  MT1603  A  Left join  MT0699 on MT0699.MaterialTypeID = A.MaterialTypeID  and MT0699.DivisionID = A.DivisionID
								 Where  A.ApportionID = MT1603.ApportionID And  A.ProductID = MT1603.ProductID and A.DivisionID = MT1603.DivisionID)/isnull(ProductQuantity,1)

	
From MT1603
LEFT JOIN AT0126 A26 ON A26.DivisionID = MT1603.DivisionID AND A26.PhaseID = MT1603.PhaseID
	Left  join MT0699 on  MT0699.MaterialTypeID=MT1603.MaterialTypeID and MT0699.DivisionID=MT1603.DivisionID
	inner join MT1602 on MT1602.ApportionID = MT1603.ApportionID and MT1602.DivisionID = MT1603.DivisionID


Group by MT1603.DivisionID, MT1603.ApportionID, ProductID,	ProductQuantity, --	QuantityUnit,	ConvertedUnit,	
MT1602.Description,	InventoryTypeID, MT1603.MParameter01, MT1603.MParameter02, MT1603.MParameter03, MT1603.PhaseID, A26.PhaseName


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
