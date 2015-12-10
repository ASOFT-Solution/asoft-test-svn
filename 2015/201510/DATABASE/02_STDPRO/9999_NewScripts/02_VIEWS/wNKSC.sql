/****** Object:  View [dbo].[wNKSC]    Script Date: 06/06/2012 14:20:56 ******/

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wNKSC]'))
DROP VIEW [dbo].[wNKSC]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[wNKSC] AS
SELECT [BLTKID],
         [MaCT],
         [MTID],
         [SoCT],
         [NgayCT],
         [DienGiai],
         [MaKH],
         [TK],
         [LoaiTK] = CASE
                       WHEN psno > 0 THEN N'Nợ'
                       ELSE N'Có'
                    END,
         [TKDu],
         [PsNo],
         [PsCo],
         [NhomDk],
         [MaPhi],
         [MaVV],
         [PsNoNT],
         [PsCoNT],
         [MaNT],
         [OngBa],
         [MaBP],
         [TyGia],
         [MTIDDT],
         [MaSP],
         [MaCongTrinh]
  FROM   bltk

GO
SET ANSI_NULLS ON

GO
