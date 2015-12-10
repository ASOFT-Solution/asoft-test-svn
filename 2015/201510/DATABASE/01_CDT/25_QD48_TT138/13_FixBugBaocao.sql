use [CDT]

-- Báo cáo chi tiết chênh lệch giá vốn và giá bán
Update sysReport set Query = N'BEGIN TRY
	select x.mavt, x.tenvt, SUM(x.soluong) as [Số lượng tiêu thụ], SUM(x.tienvon) / SUM(x.soluong) as [Đơn giá (Giá vốn)], SUM(x.tienvon) as [Giá vốn], SUM(x.ps - x.ck) / SUM(x.soluong) as [Đơn giá (Giá bán)], SUM(x.ps - x.ck) as [Giá bán], SUM(x.ps - x.ck - x.tienvon) as [Chênh lệch],  x.loaiVT
	from (select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, ck, giavon, tienvon, mabp, loaiVT
		from mt32, dt32, dmvt v
		where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt
		union all
		select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, -soluong, gia, -ps, 0.0, giavon, -tienvon, mabp, loaiVT
		from mt33, dt33, dmvt v
		where  mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt) x, 
		vatout vo, dmbophan b
	where dt32id *= vo.mtiddt and x.mabp *= b.mabp and @@ps
	Group by x.mavt, x.tenvt, x.loaiVT
	order by x.mavt
END TRY
BEGIN CATCH
-- Divide by zero
if ERROR_NUMBER() = 8134
BEGIN
	select x.mavt, x.tenvt, SUM(x.soluong) as [Số lượng tiêu thụ], 0 as [Đơn giá (Giá vốn)], SUM(x.tienvon) as [Giá vốn], 0 as [Đơn giá (Giá bán)], SUM(x.ps - x.ck) as [Giá bán], SUM(x.ps - x.ck - x.tienvon) as [Chênh lệch],  x.loaiVT
	from (select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, ck, giavon, tienvon, mabp, loaiVT
		from mt32, dt32, dmvt v
		where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt
		union all
		select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, -soluong, gia, -ps, 0.0, giavon, -tienvon, mabp, loaiVT
		from mt33, dt33, dmvt v
		where  mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt) x, 
		vatout vo, dmbophan b
	where dt32id *= vo.mtiddt and x.mabp *= b.mabp and @@ps
	Group by x.mavt, x.tenvt, x.loaiVT
	order by x.mavt
END

END CATCH
'
where ReportName = N'Báo cáo chi tiết chênh lệch giá vốn và giá bán'

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
SELECT bltkID, PsNo as TienThu, PsCo as TienChi,PsNoNt as TienThuNt, PsCoNt as TienChiNt,0.0 as toncuoi,0.0 as toncuoint
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS order by NgayCT,SoCT

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

insert into #t select bltkID ,PsNo as TienThu, PsCo as TienChi,PsNoNt as TienThuNt, PsCoNt as TienChiNt,0.0 as toncuoi,0.0 as toncuoint
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS order by ngayCT,SoCT
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
select '''' as bltkid ,'''' as soct,null as ngayct,'''' as ongba , '''' as maKH, case when @@lang = 1 then N''Begin of Period'' else N''Số dư đầu kỳ'' end as diengiai, '''' as tkdu,'''' as MaNt,null as TyGia,null as N''Ps nợ'',null as N''Ps có'', @dauky as  N''Số dư'' ,null as N''Ps nợ nt'',null as N''Ps có nt'', @daukynt as  N''Số dư nt'', 0 as Stt )
union all
(SELECT a.bltkid, a.SoCT, a.NgayCT,a.OngBa as N''Người nộp/nhận tiền'' , a.MaKH, a.DienGiai,a.TKDu, a.MaNt,a.TyGia,b.Thu as N''Ps nợ'', b.Chi as N''PS có'',b.ton as N''Số dư'',b.ThuNt as N''Ps nợ nt'', b.ChiNt as N''PS có nt'',b.tonNt as N''Số dư nt'', 1
from bltk a, #t b 
where a.bltkid = b.bltkid and @@ps
))x, dmkh
 where x.makh *= dmkh.makh
order by Stt, ngayct,soct
drop table #t
'
where ReportName = N'Sổ tiền gởi ngân hàng'

-- Sổ nhật ký thu tiền
Update sysReport set Query = N'Select * from 
(Select SoCt, NgayCt,  DienGiai, B.MaKH, KH.TenKH, B.TK, TK.TenTK,TK.TenTK2, TKDu, PsNo, PsCo, 
B.MaPhi,P.Tenphi, B.MaVV, VV.TenVV, B.MaBP, PB.TenBP, MaNT, TyGia 
From BLTK as B left join DMPhi as P on B.MaPhi=P.MaPhi
  left join DMVuViec as VV on B.MaVV=VV.MaVV
  left join DMBoPhan as PB on B.MaBP=PB.MaBP
  left join DMKH as KH on B.MaKH=KH.MaKH
  left join DMTK as TK on B.TK=TK.TK
where B.TK like ''11%'' and psno > 0) x 
where @@ps
'
where ReportName = N'Sổ nhật ký thu tiền'

-- Sổ nhật ký chi tiền
Update sysReport set Query = N'Select * from 
(Select SoCt, NgayCt,  DienGiai, B.MaKH, KH.TenKH, B.TK,TK.TenTK,TK.TenTK2, TKDu, PsNo, PsCo, 
B.MaPhi,P.Tenphi, B.MaVV, VV.TenVV, B.MaBP, PB.TenBP, MaNT, TyGia 
From BLTK as B left join DMPhi as P on B.MaPhi=P.MaPhi
  left join DMVuViec as VV on B.MaVV=VV.MaVV
  left join DMBoPhan as PB on B.MaBP=PB.MaBP
  left join DMKH as KH on B.MaKH=KH.MaKH
  left join DMTK as TK on B.TK=TK.TK
where B.TK like ''11%'' and psco > 0) x
where @@ps
'
where ReportName = N'Sổ nhật ký chi tiền'

-- Bảng kê hàng xuất kho
Update sysReport set Query = N'select x.*, c.TenKH, b.TenVT, d.TenDVT, b.Nhom, n.TenNhom, h.TenVV
from
(Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH,
	mt.DienGiai, dt.MaKho, mt.Ttien as [Thành tiền], dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT TienNT, dt.Gia, dt.Ps Tien, dt.MaVV
from mt24 mt, dt24 dt
where mt.mt24id *= dt.mt24id

union all

Select mt.NgayCT, mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT TienNT, dt.Gia, dt.Ps Tien, dt.MaVV
from mt32 mt, dt32 dt
where mt.mt32id *= dt.mt32id

union all

Select mt.NgayCT, mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT TienNT, dt.Gia, dt.Ps Tien, dt.MaVV
from mt43 mt, dt43 dt
where mt.mt43id *= dt.mt43id

union all

Select mt.NgayCT, mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, mt.MaKho MaKho, mt.Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT TienNT, dt.Gia, dt.Ps Tien, dt.MaVV
from mt44 mt, dt44 dt
where mt.mt44id *= dt.mt44id

union all

Select mt.NgayCT, mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT TienNT, dt.Gia, dt.Ps Tien, dt.MaVV
from mt45 mt, dt45 dt
where mt.mt45id *= dt.mt45id
)x, DMKH c, DMVT b, DMDVT d, DMNhomVT n, DMVuViec h
where x.MaKH = c.MaKH and x.MaVT = b.MaVT and b.MaDVT = d.MaDVT and b.Nhom *= n.MaNhomVT and x.MaVV *= h.MaVV and [Ngày chứng từ] between @@NgayCT1 and @@NgayCT2 and @@PS
order by x.[Ngày chứng từ], x.SoCT, x.MaKho, x.MaVT
'
where ReportName = N'Bảng kê hàng xuất kho'