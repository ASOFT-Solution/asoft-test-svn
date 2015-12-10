/****** Object:  View [dbo].[wTonkhoTucThoi]    Script Date: 04/29/2011 20:03:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER    VIEW [dbo].[wTonkhoTucThoi] as
select x.mavt +'_'+ y.makho as stt,x.*, y.makho,y.slTon as slTon  from 
(
	select rtrim(Makho) + rtrim(mavt) as stt,mavt, makho, sum(slTon) as slTon from 
	(
		select mavt,makho, sum(soluong-soluong_x) as slTon from blvt group by mavt,makho
		union all
		select mavt,makho,sum(soluong) as slTon from obvt group by mavt,makho
		union all
		select mavt,makho,sum(soluong) as slTon from obNTXT group by mavt,makho
 	) x group by mavt,makho
)y inner join dmvt x on x.mavt=y.mavt





GO


