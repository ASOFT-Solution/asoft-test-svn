IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TinhGiaBQDD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TinhGiaBQDD]
GO

/****** Object:  StoredProcedure [dbo].[TinhGiaBQDD]    Script Date: 02/14/2012 14:57:31 ******/
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
@DonGia float output
AS

if (@mtiddt is null)
	select @DonGia = case when Sum(Soluong)>0 then Sum(psno)/sum(soluong) else 0 end
	from (
		(select b.makho, b.mavt, b.soluong, b.psno from blvt b
		where b.ngayct between @tungay and @denngay and b.makho = @makho and b.mavt = @mavt)
		union all
		(	
			select makho, mavt, (Sum(Soluong) - Sum(Soluong_x)) as Soluong, (Sum(Psno)-Sum(Psco))as PSno
			from
			(
	
			select makho,mavt,soluong, 0.0 as soluong_x, dudau as psno,0.0 as psco
			from obvt
			where makho = @makho and mavt = @mavt
			union all
			select  b.makho, b.mavt, b.soluong, b.soluong_x, b.psno,b.psco
			from blvt b
			where b.ngayct < @tungay and b.makho = @makho and b.mavt = @mavt)x
			where @tungay < @denngay
			group by makho, mavt
		))y
else
	select @DonGia = case when Sum(Soluong)>0 then Sum(psno)/sum(soluong) else 0 end
	from (
		(select b.makho, b.mavt, b.soluong, b.psno from blvt b
		where b.ngayct between @tungay and @denngay and b.makho = @makho and b.mavt = @mavt
		and (MTIDDT is null or MTIDDT <> @mtiddt))
		union all
		(	
			select makho, mavt, (Sum(Soluong) - Sum(Soluong_x)) as Soluong, (Sum(Psno)-Sum(Psco))as PSno
			from
			(
	
			select makho,mavt,soluong, 0.0 as soluong_x, dudau as psno,0.0 as psco
			from obvt
			where makho = @makho and mavt = @mavt
			union all
			select  b.makho, b.mavt, b.soluong, b.soluong_x, b.psno,b.psco
			from blvt b
			where b.ngayct < @tungay and b.makho = @makho and b.mavt = @mavt)x
			where @tungay < @denngay
			group by makho, mavt
		))y
		



















