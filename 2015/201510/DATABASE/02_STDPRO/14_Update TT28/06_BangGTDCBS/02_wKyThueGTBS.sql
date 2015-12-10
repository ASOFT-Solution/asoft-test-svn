IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wKyThueGTBS]'))
DROP VIEW [dbo].[wKyThueGTBS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[wKyThueGTBS] AS

select DISTINCT month(NgayCt) as Ky, Year(NgayCt) as Nam from MT36 where MaLCTThue IN (2,3,4,5)
