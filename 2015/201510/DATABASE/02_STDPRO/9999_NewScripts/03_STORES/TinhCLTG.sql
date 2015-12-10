IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TinhCLTG]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TinhCLTG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[TinhCLTG]
@month int,
@maNT varchar(16),
@TyGiaCK decimal(28,6)
as

create table #t (
tk varchar(16), 
makh varchar(16),
tienLai decimal(28,6),
tienLo decimal(28,6),
mabp varchar(16), 
mavv varchar(16), 
maphi varchar(16))
declare @tk varchar(16),@makh varchar(16), @a decimal(28,6), @b decimal(28,6)
declare @mabp varchar(16), @mavv varchar(16), @maphi varchar(16)

declare curData cursor for 
select tk, null as maKH, @tygiaCK*sum(psnont - pscont) as a, sum(psno-psco) as b, mabp, mavv, maphi 
from bltk where month(ngayct) = @month and mant = @mant group by tk, mabp, mavv, maphi 

-- Cập nhật nhóm tài khoản chênh lệch tỷ giá theo TT179
--having left(tk,1) in ('1','2','3','4') 
having (left(tk,4) in ('1112','1122','1132') or  left(tk,3) in ('331','334','335','336','337','338','131','136','138','139','141','142','144','242','244','311','315','341','342','344'))
and tk in (select tk from dmtk where tkCongNo = 0)
union
select tk, maKH, @tygiaCK*sum(psnont - pscont) as a, sum(psno-psco) as b , mabp, mavv, maphi
from bltk where month(ngayct) = @month and mant = @mant group by tk, mabp, mavv, maphi, makh

-- Cập nhật nhóm tài khoản chênh lệch tỷ giá theo TT179
--having left(tk,1) in ('1','2','3','4') 
having (left(tk,4) in ('1112','1122','1132') or  left(tk,3) in ('331','334','335','336','337','338','131','136','138','139','141','142','144','242','244','311','315','341','342','344'))
and tk in (select tk from dmtk where tkCongNo = 1)

open curData
fetch next from curData into @tk, @makh, @a, @b, @mabp, @mavv, @maphi
while (@@fetch_status = 0)
begin
	if @a<>0 and @a <> @b
	begin
		if @a>0
		begin
			if @a>@b
				insert into #t values(@tk,@makh,@a-@b,0, @mabp, @mavv, @maphi)
			else
				insert into #t values(@tk,@makh,0,@b-@a, @mabp, @mavv, @maphi)
		end
		else
		begin
			set @a = abs(@a)
			set @b = abs(@b)
			if @a>@b
				insert into #t values(@tk,@makh,0,@a-@b, @mabp, @mavv, @maphi)
			else
				insert into #t values(@tk,@makh,@b-@a,0, @mabp, @mavv, @maphi)
		end
	end
	fetch next from curData into @tk, @makh, @a, @b, @mabp, @mavv, @maphi
end
close curData
deallocate curData

select tk, #t.makh, tenkh, tienLai, tienLo, mabp, mavv, maphi from #t, dmkh where #t.makh *= dmkh.makh