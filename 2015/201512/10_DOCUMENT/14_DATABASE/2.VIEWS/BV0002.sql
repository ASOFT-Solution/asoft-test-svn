IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[BV0002]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[BV0002]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- ChartType
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 21/09/2011 by Le Thi Thu Hien
---- 
---- Modified on 21/09/2011 by 
-- <Example>
---- 
CREATE VIEW BV0002

AS 
SELECT 1 AS Code, N'Biểu đồ cột' AS Description, 'BAR' AS DescriptionE
UNION ALL
SELECT 2 AS Code, N'Biểu đồ cột ngang' AS Description, 'STACKBAR' AS DescriptionE
UNION ALL
SELECT 3 AS Code, N'Biểu đồ dòng' AS Description, 'LINE' AS DescriptionE
UNION ALL
SELECT 4 AS Code, N'Biểu đồ tròn' AS Description, 'PIE' AS DescriptionE
UNION ALL
SELECT 11 AS Code, N'Biểu đồ cột 3D' AS Description, '3D BAR' AS DescriptionE
UNION ALL
SELECT 13 AS Code, N'Biểu đồ dòng 3D' AS Description, '3D LINE' AS DescriptionE
UNION ALL
SELECT 14 AS Code, N'Biểu đồ tròn 3D' AS Description, '3D PIE' AS DescriptionE


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

