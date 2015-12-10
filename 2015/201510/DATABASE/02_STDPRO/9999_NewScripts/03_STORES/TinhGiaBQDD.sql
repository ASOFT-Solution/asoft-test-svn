IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TinhGiaBQDD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TinhGiaBQDD]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[TinhGiaBQDD]
@mtiddt uniqueidentifier = null,
@tungay datetime,
@denngay datetime,
@makho varchar(16),
@mavt varchar(16),
@madvt varchar(16),
@DonGia decimal(28, 6) output
AS

if (@mtiddt is null)
	select @DonGia = case when Sum(Soluong)>0 then Sum(psno)/sum(soluong) else 0 end
	from (
		(select b.makho, b.mavt, b.madvt, sum(b.soluong) - sum(b.soluong_x) as soluong, sum(b.psno) - sum(b.psco) as psno from blvt b
		where b.ngayct between @tungay and @denngay and b.makho = @makho and b.mavt = @mavt and b.madvt = @madvt
		group by b.makho, b.mavt, b.madvt)
		
		union all
		(	
			select makho, mavt, madvt, (Sum(Soluong) - Sum(Soluong_x)) as Soluong, (Sum(Psno)-Sum(Psco))as PSno
			from
			(
	
			select makho,mavt, madvt, soluong, 0.0 as soluong_x, dudau as psno,0.0 as psco
			from obvt
			where makho = @makho and mavt = @mavt and madvt = @madvt
			union all
			select  b.makho, b.mavt, b.madvt, b.soluong, b.soluong_x, b.psno,b.psco
			from blvt b
			where b.ngayct < @tungay and b.makho = @makho and b.mavt = @mavt and madvt = @madvt)x
			where @tungay <= @denngay
			group by makho, mavt, madvt
		))y
else
	select @DonGia = case when Sum(Soluong)>0 then Sum(psno)/sum(soluong) else 0 end
	from (
		(select b.makho, b.mavt, b.madvt, sum(b.soluong) - sum(b.soluong_x) as soluong, sum(b.psno) - sum(b.psco) as psno from blvt b
		where b.ngayct between @tungay and @denngay and b.makho = @makho and b.mavt = @mavt and b.madvt = @madvt
		and (MTIDDT is null or MTIDDT <> @mtiddt)
		group by b.makho, b.mavt, b.madvt)
		
		union all
		(	
			select makho, mavt, madvt, (Sum(Soluong) - Sum(Soluong_x)) as Soluong, (Sum(Psno)-Sum(Psco))as PSno
			from
			(
			select makho,mavt, madvt, soluong, 0.0 as soluong_x, dudau as psno,0.0 as psco
			from obvt
			where makho = @makho and mavt = @mavt and madvt = @Madvt
			union all
			select  b.makho, b.mavt, b.madvt, b.soluong, b.soluong_x, b.psno,b.psco
			from blvt b
			where b.ngayct < @tungay and b.makho = @makho and b.mavt = @mavt and madvt = @Madvt)x
			where @tungay <= @denngay
			group by makho, mavt, madvt
		))y