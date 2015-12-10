IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wQuyDaLapBK]'))
DROP VIEW [dbo].[wQuyDaLapBK]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[wQuyDaLapBK] as
SELECT DISTINCT [QuyBKMV] AS [Quy], [NamBKMV] AS [Nam], 
[MVATIn].[ToTalThueNT] AS [ThueMVNT], [MVATIn].[ToTalThue] AS [ThueMV],
[MVATOut].[ToTalThueNT] AS [ThueBRNT], [MVATOut].[ToTalThue] AS [ThueBR]
FROM [MVATIn] 
INNER JOIN [MVATOut] ON [MVATOut].[QuyBKBR] = [MVATIn].[QuyBKMV] AND [MVATOut].[NamBKBR] = [MVATIn].[NamBKMV]
Where [QuyBKMV] > 0 and [QuyBKBR] > 0 and [QuyBKMV] is not null and [QuyBKBR] is not null