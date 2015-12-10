IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wDMDVTQD]'))
DROP VIEW [dbo].[wDMDVTQD]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[wDMDVTQD] AS

Select v.MaVT + '_' + V.MaDVT as stt,  V.MaDVT, D.TenDVT, 1.000000 as TyLeQD , v.MaVT, NULL AS DVTQDID
From DMVT V inner join DMDVT D on V.MaDVT = D.MaDVT

Union all

Select v.MaVT + '_' + Q.MaDVTQD as stt, Q.MaDVTQD, Q.TenDVTQD, Q.TyLeQD, v.MaVT, DVTQDID
          From DMDVTQD Q inner join DMVT V on V.MaVT = Q.MaVT