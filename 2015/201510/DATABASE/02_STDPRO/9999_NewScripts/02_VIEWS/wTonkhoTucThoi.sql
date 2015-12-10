IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wTonkhoTucThoi]'))
DROP VIEW [dbo].[wTonkhoTucThoi]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[wTonkhoTucThoi] as
select x.mavt +'_'+ y.makho+'_'+y.MaDVT as stt,y.makho,x.MaVT ,y.MaDVT,y.slTon as slTon,y.slTonQD as slTonQD ,x.LoaiVt,x.Nhom,x.Tonkho,x.TKkho ,x.TkGv,x.TkDt,x.TonMax,x.TonMin,x.NhomGT ,x.TenVT,x.TenVT2,x.PNo,x.BaoHanh,IsTon,x.GiaMua,x.GiaBan
from
(
	select rtrim(Makho) + rtrim(mavt) as stt,mavt, makho,MaDvt, sum(slTon) as slTon, sum(slTonQD) as slTonQD from 
	(
		select mavt,makho,MaDvt, sum(soluong-soluong_x) as slTon,sum(soluongQD-soluong_xQD) as slTonQD  from blvt group by mavt,makho,MaDvt
		union all
		select mavt,makho,MaDvt,sum(soluong) as slTon, sum(soluongQD) as slTonQD from obvt group by mavt,makho,MaDvt
		union all
		select mavt,makho,MaDvt,sum(soluong) as slTon, sum(soluongQD) as slTonQD from obNTXT group by mavt,makho,MaDvt
 	) x group by mavt,makho,MaDvt
)y inner join dmvt x on x.mavt=y.mavt