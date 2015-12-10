-- [ACC_DAVIETCUONG] Lỗi sổ nhật ký bán hàng lấy thiếu dữ liệu -> Do union
USE [CDT]

Update sysReport
set Query = N'declare @tk nvarchar(16)
declare @ngayCT1 datetime
declare @ngayCT2 datetime

set @ngayCT1=@@NgayCT1
set @ngayCT2=@@NgayCT2
set @tk=@@TK

IF OBJECT_ID(''tempdb..#result'') IS NOT NULL
BEGIN
	DROP TABLE #result
END

select * into #result from
(
select m.ngayct, m.soct,m.sohoadon, m.ngayhd,m.makh,m.ongba, m.diengiai, m.tkno as TK, d.TKco as TKDu, d.maphi, d.mabp, d.mavv, m.mant,
case when d.tkco like ''5111%'' then d.ps else 0 end as HangHoa5111, 
case when d.tkco like ''5112%'' then d.ps else 0 end as ThanhPham5112, 
case when d.tkco like ''5113%'' then d.ps else 0 end as DichVu5113, 
0 as DoanhThuKhac, d.ps as Phaithu, 
case when d.tkco like ''5111%'' then d.psNt else 0 end as HangHoa5111NT,
case when d.tkco like ''5112%'' then d.psNt else 0 end as ThanhPham5112NT, 
case when d.tkco like ''5113%'' then d.psNt else 0 end as DichVu5113NT, 0 as DoanhThuKhacNT, d.psNt as PhaithuNT 
from MT31 m inner join DT31 d on m.mt31id=d.mt31id  Where d.tkco like ''5111%'' or d.tkco like ''5112%'' or d.tkco like ''5113%'' 

union all

select m.ngayct, m.soct,m.sohoadon, m.ngayhd,m.makh,m.ongba, m.diengiai, m.tkno, d.TKdt, d.maphi, d.mabp, d.mavv, m.mant,
case when d.tkdt like ''5111%'' then d.ps else 0 end as HangHoa5111, 
case when d.tkdt like ''5112%'' then d.ps else 0 end as ThanhPham5112, 
case when d.tkdt like ''5113%'' then d.ps else 0 end as DichVu5113, 
0 as DoanhThuKhac, d.ps as Phaithu,
case when d.tkdt like ''5111%'' then d.psNt else 0 end as HangHoa5111NT, 
case when d.tkdt like ''5112%'' then d.psNt else 0 end as ThanhPham5112NT,
case when d.tkdt like ''5113%'' then d.psNt else 0 end as DichVu5113NT, 0 as DoanhThuKhacNT, d.psNt as PhaithuNT  
from MT32 m inner join DT32 d on m.mt32id=d.mt32id  Where d.tkdt like ''5111%'' or d.tkdt like ''5112%'' or d.tkdt like ''5113%'' 

union all

select m.ngayct, m.soct,m.sohoadon, m.ngayhd,m.makh,m.ongba, m.diengiai, m.tkno, d.TKco, d.maphi, d.mabp, d.mavv, m.mant,0 as HangHoa5111, 0 as ThanhPham5112, 0 as DichVu5113, d.ps as DoanhThuKhac, d.ps as Phaithu , 
0 as HangHoa5111NT, 0 as ThanhPham5112NT, 0 as DichVu5113NT, d.psNt as DoanhThuKhacNT, d.psNt as PhaithuNT  
from MT31 m inner join DT31 d on m.mt31id=d.mt31id  
Where d.tkco not like ''5111%'' and d.tkco not like ''5112%''  and d.tkco not like ''5113%''  

union all

select m.ngayct, m.soct,m.sohoadon, m.ngayhd,m.makh,m.ongba, m.diengiai, m.tkno, d.TKdt, d.maphi, d.mabp, d.mavv, m.mant, 0 as HangHoa5111, 0 as ThanhPham5112, 0 as DichVu5113, d.ps as DoanhThuKhac, d.ps as Phaithu , 
0 as HangHoa5111NT, 0 as ThanhPham5112NT, 0 as DichVu5113NT, d.psNt as DoanhThuKhacNT, d.psNt as PhaithuNT 
from MT32 m inner join DT32 d on m.mt32id=d.mt32id  
Where d.tkdt not like ''5111%'' and d.tkdt not like ''5112%'' and d.tkdt not like ''5113%''
) a

if @tk <> ''''
BEGIN
	select * from #result a
	where @@ps and a.NgayCT between @ngayCT1 and @ngayCT2
				and left(a.tk,len(@tk))=@tk
	order by a.ngayct,a.soct
END
ELSE
BEGIN
	select * from #result a
	where @@ps and a.NgayCT between @ngayCT1 and @ngayCT2
	order by a.ngayct,a.soct
END'
where ReportName = N'Sổ nhật kí bán hàng'