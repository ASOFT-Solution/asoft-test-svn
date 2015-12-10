IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTonKho]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetTonKho]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
 * Kiểm tra theo nhiều đơn vị tính
**/
CREATE FUNCTION [dbo].[GetTonKho]
(	
	-- Add the parameters for the function here
	@ngayct DateTime, 
	@soct nvarchar(50),
	@mavt nvarchar(max)
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select a.Data as MaVT, x.IsTon, x.TonMin , x.TonMax , y.makho,y.slTon from 
	Split(@mavt,',') a left join
	(
	(
		select Makho + mavt as stt,mavt,makho, sum(slTon) as slTon
		from 
		(
			select b.mavt,b.makho,sum(case when Q.DVTQDID is null then soluong - soluong_x else soluongQD - soluong_xQD end) as slTon
			from blvt b left join DMDVTQD Q on b.DVTQDID   = Q.DVTQDID
			where NgayCT<= @ngayct and (isnull(@soct,'') = '' or SoCT <> @soct)
			group by b.mavt,b.makho
			union all
			select b.mavt,b.makho,sum(case when Q.DVTQDID is null then soluong else soluongQD end) as slTon
			from obvt b left join DMDVTQD Q on b.DVTQDID   = Q.DVTQDID
			group by b.mavt,b.makho
			union all
			select b.mavt,b.makho,sum(case when Q.DVTQDID is null then soluong else soluongQD end) as slTon
			from obNTXT b left join DMDVTQD Q on b.DVTQDID   = Q.DVTQDID
			where NgayCT<= @ngayct and (isnull(@soct,'') = '' or SoCT <> @soct)
			group by b.mavt,b.makho
 		) x group by mavt,makho
	) y 
	 inner join dmvt x on x.mavt=y.mavt and x.IsTon = 1
	 ) on a.Data = y.mavt 
)