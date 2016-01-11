IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0121_1]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0121_1]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- 
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: on:
---- Modified on 
-- <Example>
/*
	
*/
CREATE PROCEDURE MP0121_1
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50)
)
AS
SELECT DISTINCT PlanID, VoucherNo
FROM
(
SELECT M21.PlanID, M21.VoucherNo
FROM MT2001 M21
LEFT JOIN MT2002 M22 ON M22.DivisionID = M21.DivisionID AND M22.PlanID = M21.PlanID
LEFT JOIN MT0121 M01 ON M01.DivisionID = M22.DivisionID AND M01.PlanDetailID = M22.PlanDetailID AND M01.PlanID = M22.PlanID
WHERE M21.DivisionID = @DivisionID
AND M01.VoucherID IS NULL
) A

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
