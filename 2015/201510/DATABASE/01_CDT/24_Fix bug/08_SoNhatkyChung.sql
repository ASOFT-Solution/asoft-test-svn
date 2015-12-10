use [CDT]

Update sysReport set Query = N'declare @tungay datetime
declare @denngay datetime 

set @tungay = @@Ngayct1
set @denngay = DATEADD(hh,23,@@Ngayct2)

Select mact, dbo.LayNgayGhiSo(NgayCT) as [Ngày ghi sổ], SoCt, NgayCT, DienGiai, Tk, Tkdu, PsNo, Psco, '''' as [Ghi chú]
from bltk
where NgayCt between @tungay and @denngay
order by NgayCT, MTID, MTIDDT, NhomDK
'
where ReportName = N'Sổ nhật ký chung'


