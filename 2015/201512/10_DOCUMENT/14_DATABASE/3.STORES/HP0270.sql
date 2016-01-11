IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0270]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0270]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Cap nhat phuong an luong
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 23/05/2013 by Le Thi Thu Hien :
---- 
---- Modified on 23/05/2013 by 
-- <Example>
---- 
CREATE PROCEDURE HP0270
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@SalaryPlanID AS NVARCHAR(50)
) 
AS 

SELECT	H.DivisionID,
		H.InventoryTypeID,	A.InventoryTypeName,
		H.InventoryID,		A2.InventoryName,
		H.WorkID,			H1.WorkName,
		H.PlanID,			P.PlanName,
		H.SubPlanID,		P1.SubPlanName,
		H.SalaryPlanID,
		H.SalaryPlanName,
		H.WorkTypeID,		P2.[Description] AS WorkTypeName,
		H.[Disabled]
		
FROM		HT0269 H
LEFT JOIN	AT1301 A
	ON		A.DivisionID = H.DivisionID AND A.InventoryTypeID = H.InventoryTypeID
LEFT JOIN	AT1302 A2
	ON		A2.DivisionID = H.DivisionID AND A2.InventoryID = H.InventoryID
LEFT JOIN	PST1000 P
	ON		P.DivisionID = H.DivisionID AND P.PlanID = H.PlanID
LEFT JOIN	HT0267 H1
	ON		H1.DivisionID = H.DivisionID AND H1.WorkID = H.WorkID
LEFT JOIN	PST2080 P1
	ON		P1.DivisionID = H.DivisionID AND P1.SubPlanID = H.SalaryPlanID
LEFT JOIN	PSV0001 P2
	ON		P2.Code = H.WorkTypeID
WHERE		H.DivisionID = @DivisionID
			AND H.SalaryPlanID = @SalaryPlanID

	
