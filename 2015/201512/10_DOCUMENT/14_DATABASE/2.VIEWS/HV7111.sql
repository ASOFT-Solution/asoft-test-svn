
/****** Object:  View [dbo].[HV7111]    Script Date: 01/03/2012 14:53:14 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[HV7111]'))
DROP VIEW [dbo].[HV7111]
GO

/****** Object:  View [dbo].[HV7111]    Script Date: 01/03/2012 14:53:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[HV7111]
AS
SELECT     TOP 100 PERCENT COL1, COL2, DivisionID
FROM         dbo.HT7111
ORDER BY ID

GO


