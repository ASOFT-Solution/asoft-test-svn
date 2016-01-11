IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[PQ2220]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[PQ2220]
GO

/****** Object:  View [dbo].[PQ2220]    Script Date: 12/16/2010 15:38:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Create By: Dang Le Bao Quynh; Date: 20/05/2009
--Purpose: View chet luu tru danh muc xuong san xuat

CREATE VIEW [dbo].[PQ2220]
AS
SELECT     '1' AS FactoryID, N'Xưởng 1' AS FactoryName, 0 AS Orders, DivisionID from AT1101
UNION
SELECT     '2' AS FactoryID, N'Xưởng 2' AS FactoryName, 1 AS Orders, DivisionID from AT1101
UNION
SELECT     '3' AS FactoryID, N'Xưởng 3' AS FactoryName, 2 AS Orders, DivisionID from AT1101

GO


