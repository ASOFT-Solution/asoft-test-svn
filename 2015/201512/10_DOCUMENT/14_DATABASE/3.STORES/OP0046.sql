IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0046]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0046]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Đối chiếu dự trù nguyên vật liệu với tồn kho
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 22/11/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 22/11/2012 by 
-- <Example>
---- 
CREATE PROCEDURE OP0046
( 
	@DivisionID AS NVARCHAR(4000),
	@TranMonth AS INT,
	@TranYear AS INT,
	@EstimateID AS NVARCHAR(4000)
) 
AS 

SELECT DISTINCT O.MaterialID, A.InventoryName AS MaterialName, O.WareHouseID, 
		O.MaterialQuantity, A1.EndQuantity, A2.TotalEndQuantity, O.TranMonth, O.TranYear
FROM	OT2203 O 
LEFT JOIN AT1302 A ON A.DivisionID = O.DivisionID AND O.MaterialID = A.InventoryID
LEFT JOIN AT2008 A1 ON A1.DivisionID = O.DivisionID AND A1.InventoryID = O.MaterialID 
						AND A1.WareHouseID = O.WareHouseID 
						AND A1.TranMonth = O.TranMonth AND A1.TranYear = O.TranYear
LEFT JOIN (SELECT	DivisionID, InventoryID, TranMonth, TranYear, SUM(EndQuantity) AS TotalEndQuantity  
           FROM		AT2008
           GROUP BY	DivisionID, InventoryID , TranMonth, TranYear
			) A2
     ON		A2.DivisionID = O.DivisionID 
			AND A2.TranMonth = O.TranMonth 
			AND A2.TranYear = O.TranYear 
			AND A2.InventoryID = O.MaterialID
WHERE	ExpenseID = 'COST001' 
		AND EstimateID = @EstimateID
		AND O.DivisionID = @DivisionID
		AND O.TranMonth = @TranMonth
		AND O.TranYear = @TranYear

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

