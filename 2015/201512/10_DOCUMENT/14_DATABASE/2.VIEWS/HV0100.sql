IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HV0100]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HV0100]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- View chết phục vụ cho mục đích đổ combo
---- 1. Bậc lương : SalaryLevel
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 17/12/2013 by Lê Thị Thu Hiền
---- 
---- Modified on 17/12/2013 by 
-- <Example>
---- 
CREATE VIEW HV0100
AS 

SELECT 'SalaryLevel' AS TypeID, 'BAC01'  AS CodeID,  N'Bậc 1' AS [Description], N'Level 1' AS DescriptionE,0 AS [Disabled]
UNION ALL
SELECT 'SalaryLevel' AS TypeID, 'BAC02'  AS CodeID,  N'Bậc 2' AS [Description], N'Level 2' AS DescriptionE,0 AS [Disabled]
UNION ALL
SELECT 'SalaryLevel' AS TypeID, 'BAC03'  AS CodeID,  N'Bậc 3' AS [Description], N'Level 3' AS DescriptionE,0 AS [Disabled]
UNION ALL
SELECT 'SalaryLevel' AS TypeID, 'BAC04'  AS CodeID,  N'Bậc 4' AS [Description], N'Level 4' AS DescriptionE,0 AS [Disabled]
UNION ALL
SELECT 'SalaryLevel' AS TypeID, 'BAC05'  AS CodeID,  N'Bậc 5' AS [Description], N'Level 5' AS DescriptionE,0 AS [Disabled]
UNION ALL
SELECT 'SalaryLevel' AS TypeID, 'BAC06'  AS CodeID,  N'Bậc 6' AS [Description], N'Level 6' AS DescriptionE,0 AS [Disabled]
UNION ALL
SELECT 'SalaryLevel' AS TypeID, 'BAC07'  AS CodeID,  N'Bậc 7' AS [Description], N'Level 7' AS DescriptionE,0 AS [Disabled]
UNION ALL
SELECT 'SalaryLevel' AS TypeID, 'BAC08'  AS CodeID,  N'Bậc 8' AS [Description], N'Level 8' AS DescriptionE,0 AS [Disabled]
UNION ALL
SELECT 'SalaryLevel' AS TypeID, 'BAC09'  AS CodeID,  N'Bậc 9' AS [Description], N'Level 9' AS DescriptionE,0 AS [Disabled]
UNION ALL
SELECT 'SalaryLevel' AS TypeID, 'BAC10'  AS CodeID,  N'Bậc 10' AS [Description], N'Level 10' AS DescriptionE,0 AS [Disabled]
UNION ALL
SELECT 'SalaryLevel' AS TypeID, 'BAC11'  AS CodeID,  N'Bậc 11' AS [Description], N'Level 11' AS DescriptionE,0 AS [Disabled]
UNION ALL
SELECT 'SalaryLevel' AS TypeID, 'BAC12'  AS CodeID,  N'Bậc 12' AS [Description], N'Level 12' AS DescriptionE,0 AS [Disabled]
UNION ALL
SELECT 'SalaryLevel' AS TypeID, 'BAC13'  AS CodeID,  N'Bậc 13' AS [Description], N'Level 13' AS DescriptionE,0 AS [Disabled]
UNION ALL
SELECT 'SalaryLevel' AS TypeID, 'BAC14'  AS CodeID,  N'Bậc 14' AS [Description], N'Level 14' AS DescriptionE,0 AS [Disabled]
UNION ALL
SELECT 'SalaryLevel' AS TypeID, 'BAC15'  AS CodeID,  N'Bậc 15' AS [Description], N'Level 15' AS DescriptionE,0 AS [Disabled]

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

