IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TonkhoTucThoi]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TonkhoTucThoi]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[TonkhoTucThoi] 
@ngayct datetime
as
select x.mavt, y.makho,y.MaDvt,y.slTon , y.slTonQD from 
(
	select rtrim(Makho) + rtrim(mavt) as stt,mavt, makho, MaDvt, sum(slTon) as slTon , sum(slTonQD) as slTonQD from 
	(
		select mavt,makho, MaDvt, sum(soluong-soluong_x) as slTon, sum(soluongQD-soluong_xQD) as slTonQD from blvt where NgayCT <= @ngayct group by mavt,makho, MaDvt
		union all
		select mavt,makho, MaDvt,sum(soluong) as slTon,sum(soluongQD) as slTonQD from obvt group by mavt,makho, MaDvt
		union all
		select mavt,makho,MaDvt,sum(soluong) as slTon,sum(soluongQD) as slTonQD from obNTXT group by mavt,makho, MaDvt
 	) x group by mavt,makho,MaDvt
)y inner join dmvt x on x.mavt=y.mavt	--where  y.slTon>0