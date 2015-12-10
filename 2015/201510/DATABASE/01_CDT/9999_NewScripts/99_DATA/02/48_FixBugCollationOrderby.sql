USE [CDT]

-- [ACC_THÀNH PHÁT] Lỗi báo cáo Sổ quỹ tiền mặt: Collation conflict -> Không sử dụng bảng tạm, xài biến bảng
Update sysReport
set Query = N'declare @tkrp nvarchar(20)
declare @dauky decimal(28,6),@daukynt decimal(28,6)
declare @thu decimal(28,6),@thunt decimal(28,6)
declare @chi decimal(28,6),@chint decimal(28,6)
declare @ton decimal(28,6)
declare @tonnt decimal(28,6)
declare @id int
declare @stt int
declare @tungayCt datetime,@ngaydk datetime
declare @denngayCt datetime
set @tuNgayCt=@@NgayCT1
set @denNgayCt=dateadd(hh,23,@@NgayCT2)
set @ngaydk=dateadd(hh,-1,@tungayct)
set @tkrp=@@TK

declare @nodk decimal(28,6),@nodknt decimal(28,6)
declare @codk decimal(28,6),@codknt decimal(28,6)
	exec sodutaikhoannt @tkrp,@ngaydk,''@@ps'',@Nodk output, @Codk output,@NoDkNt output, @CoDkNt output
set @dauky = @nodk
set @daukynt = @nodknt
declare cur cursor for 
SELECT min(bltkID) as  bltkID, sum(PsNo) as TienThu, sum(PsCo) as TienChi,sum(case when TyGia = 1 then 0 else PsNoNt end) as TienThuNt, sum(case when TyGia = 1 then 0 else PsCoNt end) as TienChiNt,0.0 as toncuoi,0.0 as toncuoint,
case when sum(PsNo) != 0 then 1 else 2 end as STT
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS 
group by MTID, NgayCT,SoCT 
order by NgayCT,STT, SoCT

Declare @t TABLE
 (
	[bltkID] [int]   NULL ,	
	[Thu] decimal(28, 6) NULL ,
	[Chi] decimal(28, 6) NULL ,
	[ThuNt] decimal(28, 6) NULL ,
	[ChiNt] decimal(28, 6) NULL ,
	[ton] decimal(28, 6) NULL,
	[tonNt] decimal(28, 6) NULL, 
	[STT] int null
) 

Declare @SoCT11_32 TABLE
 (
	[SOCT] [nvarchar](512)  NULL ,	
	MTID uniqueidentifier
) 

insert into @t select min(bltkID) as bltkID,sum(PsNo) as TienThu, sum(PsCo) as TienChi,sum(case when TyGia = 1 then 0 else PsNoNt end) as TienThuNt, sum(case when TyGia = 1 then 0 else PsCoNt end) as TienChiNt,0.0 as toncuoi,0.0 as toncuoint, 
case when sum(PsNo) != 0 then 1 else 2 end as STT
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS 
group by MTID, NgayCT,SoCT 
order by ngayCT,Stt, SoCT
declare @tmp decimal(28,6),@tmpnt decimal(28,6)
set @tmp=@dauky
set @tmpnt = @daukynt
open cur
fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt, @stt
while @@fetch_status=0
begin
	set @ton=@tmp+@thu-@chi
	set @tmp=@ton
	set @tonnt=@tmpnt+@thunt-@chint
	set @tmpnt=@tonnt
	UPDATE @t SET ton=@ton,tonnt=@tonnt where bltkid=@id
	fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt, @stt
	
end
close cur
deallocate cur

Insert into @SoCT11_32
select distinct SOCT as SoCT, MT11ID as MTID from MT11
union all
select distinct SOCT as SoCT, MT15ID as MTID from MT15
union all
select distinct SOCT, MT32ID from MT32

select x.bltkid, x.SoCT,x.NgayCT,
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = x.makh) as ongba,
 x.maKH, x.diengiai, x.tkdu, x.MaNt, x.TyGia,x.[Ps nợ],x.[Ps có],x.[Số dư],x.[Ps nợ nt], x.[PS có nt],x.[Số dư nt],x.Stt,
 case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as tenkh
from
((
select N'''' as bltkid ,N'''' as soct,null as ngayct,N'''' as ongba , N'''' as maKH, case when @@lang = 1 then N''Begin of Period'' else N''Đầu kỳ'' end as diengiai, N'''' as tkdu,N'''' as MaNt,null as TyGia,null as N''Ps nợ'',null as N''Ps có'', @dauky as  N''Số dư'' ,null as N''Ps nợ nt'',null as N''Ps có nt'', @daukynt as  N''Số dư nt'', 0 as Stt, 0 as STT2)
union all
(SELECT a.bltkid, 
case when a.NhomDK = ''HDB5'' or a.NhomDK = ''HDB6'' then (select top 1 SoCT from @SoCT11_32 soCT11_32 where a.MTID = soCT11_32.MTID) else a.SoCT end as SoCT, 
a.NgayCT,a.OngBa as N''Người nộp/nhận tiền'' , a.MaKH, a.DienGiai,a.TKDu, a.MaNt,a.TyGia,b.Thu as N''Ps nợ'', b.Chi as N''PS có'',b.ton as N''Số dư'',b.ThuNt as N''Ps nợ nt'', b.ChiNt as N''PS có nt'',b.tonNt as N''Số dư nt'', 1,case when b.Thu != 0 then 1 else 2 end
from bltk a, @t b 
where a.bltkid = b.bltkid and @@ps
))x, dmkh
 where x.makh *= dmkh.makh
order by stt, ngayct, stt2, soct
--drop table @t
--drop table @SoCT11_32'
where ReportName = N'Sổ quỹ tiền mặt'