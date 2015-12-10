use [CDT]

Update sysReport set Query = N'
declare @KyKT int
declare @NamKT int

set @KyKT = @@KyBKBRTTDB
set @NamKT = @@NAM

select 
M.KyBKBRTTDB, 
M.NamBKBRTTDB, 
D.NgayHD, 
D.SoHoaDon, 
M.NgayBKBRTTDB, 
D.SoSeries, 
D.NgayCt as [Ngày chứng từ], 
D.TenKH, 
D.TenVT, 
D.SoLuong, 
D.Gia, 
D.Ps, 
D.MaNhomTTDB, 
D.ThueSuatTTDB, 
D.Ps1, 
D.TienTTDB, 
NT.TenNhomTTDB

from MTTDBout as M 
inner join DTTDBout as D on M. MTTDBoutID = D. MTTDBoutID 
left join DMThueTTDB as NT on NT.MaNhomTTDB = D.MaNhomTTDB

where M.KyBKBRTTDB = @KyKT
and M.NamBKBRTTDB = @NamKT'
where sysReportID = (select sysReportID from sysReport
					where ReportName = N'Bảng kê chứng từ thuế TTĐB bán ra')


