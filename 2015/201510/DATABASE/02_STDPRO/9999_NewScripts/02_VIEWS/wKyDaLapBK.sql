IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wKyDaLapBK]'))
DROP VIEW [dbo].[wKyDaLapBK]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[wKyDaLapBK] as
SELECT DISTINCT [KyBKMV] AS [Ky], [NamBKMV] AS [Nam], 
[MVATIn].[ToTalThueNT] AS [ThueMVNT], [MVATIn].[ToTalThue] AS [ThueMV],
[MVATOut].[ToTalThueNT] AS [ThueBRNT], [MVATOut].[ToTalThue] AS [ThueBR]
FROM [MVATIn] 
INNER JOIN [MVATOut] ON [MVATOut].[KyBKBR] = [MVATIn].[KyBKMV] AND [MVATOut].[NamBKBR] = [MVATIn].[NamBKMV]
Where [KyBKMV] > 0 and [KyBKBR] > 0 and [KyBKMV] is not null and [KyBKBR] is not null