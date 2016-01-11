IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0128]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0128]
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
	MP0128 'DNP', '', 'CNC', 1
*/
CREATE PROCEDURE MP0128
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
    @CriteriaID VARCHAR(50) = NULL,
    @Mode TINYINT ----0: Thêm mới, 1: View/Edit
)
AS
IF @Mode = 0 ---- thêm mới
SELECT A26.TeamID, H01.TeamName, A26.PhaseID, A26.PhaseName, NULL MachineID, NULL HourAvg, NULL TCGCCoefficient, NULL HourCriteria, 
	NULL QtyCriteria1h, NULL QtyCriteria8h, NULL QtyCriteria12h, NULL Notes
FROM AT0126 A26
LEFT JOIN HT1101 H01 ON H01.DivisionID = A26.DivisionID AND H01.TeamID = A26.TeamID
WHERE A26.DivisionID = @DivisionID
AND ISNULL(A26.[Disabled], 0) = 0
ORDER BY A26.TeamID, A26.PhaseID

IF @Mode = 1 ---- View/Edit
SELECT A26.TeamID, H01.TeamName, A26.PhaseID, A26.PhaseName, M25.MachineID, M25.HourAvg, M25.TCGCCoefficient, M25.HourCriteria, 
	M25.QtyCriteria1h, M25.QtyCriteria8h, M25.QtyCriteria12h, M25.Notes
FROM AT0126 A26
LEFT JOIN MT0125 M25 ON M25.DivisionID = A26.DivisionID AND M25.PhaseID = A26.PhaseID
LEFT JOIN HT1101 H01 ON H01.DivisionID = A26.DivisionID AND H01.TeamID = A26.TeamID
WHERE A26.DivisionID = @DivisionID
AND M25.CriteriaID = @CriteriaID
AND ISNULL(A26.[Disabled], 0) = 0
ORDER BY A26.TeamID, A26.PhaseID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
