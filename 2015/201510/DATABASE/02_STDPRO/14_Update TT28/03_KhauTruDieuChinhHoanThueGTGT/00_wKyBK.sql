IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wKyDaLapBK]'))
DROP VIEW [dbo].[wKyDaLapBK]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[wKyDaLapBK] AS
SELECT DISTINCT [KyBKMV] AS [Ky], [NamBKMV] AS [Nam], 
[MVATIn].[ToTalThueNT] AS [ThueMVNT], [MVATIn].[ToTalThue] AS [ThueMV],
[MVATOut].[ToTalThueNT] AS [ThueBRNT], [MVATOut].[ToTalThue] AS [ThueBR]
FROM [MVATIn] 
INNER JOIN [MVATOut] ON [MVATOut].[KyBKBR] = [MVATIn].[KyBKMV] AND [MVATOut].[NamBKBR] = [MVATIn].[NamBKMV]
