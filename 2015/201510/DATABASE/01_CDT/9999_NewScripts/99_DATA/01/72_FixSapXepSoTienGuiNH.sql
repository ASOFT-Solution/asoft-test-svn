use [CDT]

-- Fix lại thứ tự khi lên báo cáo (CRM: TT3624)

-- Sổ tiền gởi ngân hàng
Update sysReport set Query = N'declare @tkrp nvarchar(20)
declare @dauky float,@daukynt float

declare @thu float,@thunt float
declare @chi float,@chint float
declare @ton float
declare @tonnt float
declare @id int
declare @tungayCt datetime,@ngaydk datetime
declare @denngayCt datetime
declare @stt int
set @tuNgayCt=@@NgayCT1
set @denNgayCt=dateadd(hh,23,@@NgayCT2)
set @ngaydk=dateadd(hh,-1,@tungayct)
set @tkrp=@@TK

declare @nodk float,@nodknt float
declare @codk float,@codknt float
	exec sodutaikhoannt @tkrp,@ngaydk,''@@ps'',@Nodk output, @Codk output,@NoDkNt output, @CoDkNt output
set @dauky = @nodk
set @daukynt = @nodknt
declare cur cursor for 
SELECT bltkID, PsNo as TienThu, PsCo as TienChi,PsNoNt as TienThuNt, PsCoNt as TienChiNt,0.0 as toncuoi,0.0 as toncuoint, 
case when PsNo != 0 then 1 else 2 end as STT

FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS 
order by NgayCT,STT,SoCT

create table #t
 (
	[bltkID] [int]   NULL ,	
	[Thu] [decimal](28, 6) NULL ,
	[Chi] [decimal](28, 6) NULL ,
	[ThuNt] [decimal](28, 6) NULL ,
	[ChiNt] [decimal](28, 6) NULL ,
	[ton] [decimal](28, 6) NULL,
	[tonNt] [decimal](28, 6) NULL,
	[stt] [int] null
) ON [PRIMARY]

insert into #t select bltkID ,PsNo as TienThu, PsCo as TienChi,PsNoNt as TienThuNt, PsCoNt as TienChiNt,0.0 as toncuoi,0.0 as toncuoint, case when PsNo != 0 then 1 else 2 end as STT
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS 
order by ngayCT,STT, SoCT
declare @tmp float,@tmpnt float
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
	UPDATE #t SET ton=@ton,tonnt=@tonnt where bltkid=@id
	fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt, @stt
	
end
close cur
deallocate cur

select x.*, (select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = x.makh) as tenkh
from
((
select N'''' as bltkid ,N'''' as soct,null as ngayct,N'''' as ongba , N'''' as maKH, case when @@lang = 1 then N''Begin of Period'' else N''Số dư đầu kỳ'' end as diengiai, N'''' as tkdu,N'''' as MaNt,null as TyGia,null as N''Ps nợ'',null as N''Ps có'', @dauky as  N''Số dư'' ,null as N''Ps nợ nt'',null as N''Ps có nt'', @daukynt as  N''Số dư nt'', 0 as Stt, 0 as Stt2)
union all
(SELECT a.bltkid, a.SoCT, a.NgayCT,
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = a.makh) as N''Người nộp/nhận tiền'' , a.MaKH, a.DienGiai,a.TKDu, a.MaNt,a.TyGia,b.Thu as N''Ps nợ'', b.Chi as N''PS có'',b.ton as N''Số dư'',b.ThuNt as N''Ps nợ nt'', b.ChiNt as N''PS có nt'',b.tonNt as N''Số dư nt'', 1, b.stt as Stt2
from bltk a, #t b 
where a.bltkid = b.bltkid and @@ps
))x, dmkh
 where x.makh *= dmkh.makh
order by Stt, ngayct, stt2, soct
drop table #t'
where ReportName = N'Sổ tiền gởi ngân hàng'
