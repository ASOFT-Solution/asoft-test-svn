use [CDT]

Update [sysReport] set [Query] = N'declare @tungay datetime
declare @denngay datetime 

set @tungay = @@Ngayct1
set @denngay = @@Ngayct2

set @denngay = DATEADD(hh, 23, @denngay)
set @denngay = DATEADD(ss, 3599, @denngay)

Select mact, dbo.LayNgayGhiSo(NgayCT) as [Ngày ghi sổ], SoCt, NgayCT, DienGiai, Tk, Tkdu, PsNo, Psco, '''' as [Ghi chú]
from bltk
where NgayCt between @tungay and @denngay'
where ReportName = N'Sổ nhật ký chung'
