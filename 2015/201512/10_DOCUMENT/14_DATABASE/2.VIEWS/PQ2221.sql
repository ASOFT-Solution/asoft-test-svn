IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[PQ2221]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[PQ2221]
GO
/****** Object:  View [dbo].[PQ2221]    Script Date: 12/16/2010 15:39:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Create By: Dang Le Bao Quynh; Date: 06/05/2009
--Purpose: View chet luu tru danh muc don vi tinh

CREATE VIEW [dbo].[PQ2221]
AS
SELECT     'Met' AS UnitID, 'Mét' AS UnitName, 1 AS Coefficient, 0 AS Orders, DivisionID from AT1101
UNION
SELECT     'Yard' AS UnitID, 'Yard' AS UnitName, 0.914 AS Coefficient, 1 AS Orders, DivisionID from AT1101

GO


