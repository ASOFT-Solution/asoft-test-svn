IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CSP2022]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[CSP2022]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Change DeviceGroupID Load SystemID, Code

-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 09/07/2013 by Lê Thị Thu Hiền
---- 
---- Modified on 09/07/2013 by 
-- <Example>
---- 
CREATE PROCEDURE CSP2022
( 
	@DivisionID AS nvarchar(50),
	@UserID AS nvarchar(50),
	@DeviceGroupID AS nvarchar(50)
) 
AS 

DECLARE @CheckTypeID AS NVARCHAR(50)
SET @CheckTypeID  = (SELECT TOP 1 CheckTypeID FROM CST1030 WHERE DivisionID = @DivisionID AND DeviceGroupID = @DeviceGroupID)

SELECT	C.CheckTypeID, C.[Description] AS CheckTypeName,
		C.SystemID , C1.SystemName,
		C.OrderNo, 
		C1.Code , C2.[Description],
		'' AS StatusID,
		'' AS ProPosed,
		'' AS IsFinish,
		'' AS CheckPersonID,
		'' AS CheckNotes
		
FROM	CST1060 C
LEFT JOIN CST1050 C1 ON C1.DivisionID = C.DivisionID AND C1.SystemID = C.SystemID
LEFT JOIN CST1000 C2 ON C2.DivisionID = C.DivisionID AND C2.Code = C1.Code
LEFT JOIN CST2021 C3 ON C3.DivisionID = C2.DivisionID AND C3.Code = C2.Code
WHERE	C.DivisionID = @DivisionID
		AND C.CheckTypeID =@CheckTypeID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

