IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wGetVoucherLRTD]'))
DROP VIEW [dbo].[wGetVoucherLRTD]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[wGetVoucherLRTD] as
Select Distinct MTID, MaCT, SoCT, NgayCT, Diengiai, 0 as NhapXuat  from BLTK Where NhomDK in ('PTR7', 'PTR8')
Union all
Select Distinct MTID, MaCT, SoCT, NgayCT, Diengiai, 1 as NhapXuat from BLTK Where NhomDK in ('PTR5', 'PTR6')
Union all
Select Distinct MTID, MaCT, SoCT, NgayCT, Diengiai, 0 as NhapXuat from BLTK Where NhomDK in ('PTR9', 'PTR10')
Union all
Select Distinct MTID, MaCT, SoCT, NgayCT, Diengiai, 1 as NhapXuat from BLTK Where NhomDK in ('PTR11', 'PTR12')