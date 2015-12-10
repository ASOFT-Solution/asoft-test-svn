use [CDT]
if exists (select top 1 1 from sysReport where ReportName = N'Sổ quỹ tiền mặt')
	update sysReport Set Query = N'declare @tkrp nvarchar(20)
declare @dauky float,@daukynt float
declare @thu float,@thunt float
declare @chi float,@chint float
declare @ton float
declare @tonnt float
declare @id int
declare @tungayCt datetime,@ngaydk datetime
declare @denngayCt datetime
set @tuNgayCt=@@NgayCT1
set @denNgayCt=@@NgayCT2
set @ngaydk=dateadd(day,-1,@tungayct)
set @tkrp=@@TK

declare @nodk float,@nodknt float
declare @codk float,@codknt float
	exec sodutaikhoannt @tkrp,@ngaydk,''@@ps'',@Nodk output, @Codk output,@NoDkNt output, @CoDkNt output
set @dauky = @nodk
set @daukynt = @nodknt
declare cur cursor for 
SELECT min(bltkID) as  bltkID, sum(PsNo) as TienThu, sum(PsCo) as TienChi,sum(PsNoNt) as TienThuNt, sum(PsCoNt) as TienChiNt,0.0 as toncuoi,0.0 as toncuoint
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS group by MTID, NgayCT,SoCT order by NgayCT,SoCT

create table #t
 (
	[bltkID] [int]   NULL ,	
	[Thu] [decimal](18, 3) NULL ,
	[Chi] [decimal](18, 3) NULL ,
	[ThuNt] [decimal](18, 3) NULL ,
	[ChiNt] [decimal](18, 3) NULL ,
	[ton] [decimal](18, 3) NULL,
	[tonNt] [decimal](18, 3) NULL  
) ON [PRIMARY]

insert into #t select min(bltkID) as bltkID,sum(PsNo) as TienThu, sum(PsCo) as TienChi,sum(PsNoNt) as TienThuNt, sum(PsCoNt) as TienChiNt,0.0 as toncuoi,0.0 as toncuoint
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS group by MTID, NgayCT,SoCT order by ngayCT,SoCT
declare @tmp float,@tmpnt float
set @tmp=@dauky
set @tmpnt = @daukynt
open cur
fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt
while @@fetch_status=0
begin
	set @ton=@tmp+@thu-@chi
	set @tmp=@ton
	set @tonnt=@tmpnt+@thunt-@chint
	set @tmpnt=@tonnt
	UPDATE #t SET ton=@ton,tonnt=@tonnt where bltkid=@id
	fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt
	
end
close cur
deallocate cur

select x.*,dmkh.tenkh
from
((
select '''' as bltkid ,'''' as soct,null as ngayct,'''' as ongba , '''' as maKH, N''Đầu kỳ'' as diengiai, '''' as tkdu,'''' as MaNt,null as TyGia,null as N''Ps nợ'',null as N''Ps có'', @dauky as  N''Số dư'' ,null as N''Ps nợ nt'',null as N''Ps có nt'', @daukynt as  N''Số dư nt'', 0 as Stt)
union all
(SELECT a.bltkid, a.SoCT, a.NgayCT,a.OngBa as N''Người nộp/nhận tiền'' , a.MaKH, a.DienGiai,a.TKDu, a.MaNt,a.TyGia,b.Thu as N''Ps nợ'', b.Chi as N''PS có'',b.ton as N''Số dư'',b.ThuNt as N''Ps nợ nt'', b.ChiNt as N''PS có nt'',b.tonNt as N''Số dư nt'', 1
from bltk a, #t b 
where a.bltkid = b.bltkid and @@ps
))x, dmkh
 where x.makh *= dmkh.makh
order by stt, ngayct,soct
drop table #t
				'
	where ReportName = N'Sổ quỹ tiền mặt'