USE CDT

--Sổ nhật kí mua hàng
Update sysReport set Query = N'declare @tk nvarchar(16)
set @tk=@@TK

IF OBJECT_ID(''tempdb..#Dichvu'') IS NOT NULL
BEGIN
	DROP TABLE #Dichvu
END

IF OBJECT_ID(''tempdb..#VTHH'') IS NOT NULL
BEGIN
	DROP TABLE #VTHH
END

-- Lấy ra số liệu vật tư hàng mua vào nhưng không nhập kho(bảng MT22 va MT23) và mua dịch vụ, chi phí mua hàng (Bảng MT21 và MT25)
select * into #Dichvu from (
select mt21.Ngayct, mt21.soct,mt21.sohoadon,mt21.ngayhd,mt21.diengiai,mt21.makh, dt21.tkno as [TK],mt21.tkco as [TKDu], dt21.maphi, dt21.mabp, dt21.mavv ,mt21.MaNT,'''' as Makho, (ps-tienCK) as Tien, (psNT-tienCKNt) as TienNT from Mt21 inner join dt21 on mt21.mt21id=dt21.mt21id 
union all
select mt25.Ngayct, mt25.soct,mt25.sohoadon,mt25.ngayhd,mt25.diengiai,mt25.makh,  dt25.tkno as [TK],mt25.tkco as [TKDu], dt25.maphi, dt25.mabp ,dt25.mavv ,mt25.MaNT, '''' as Makho, ps as Tien, psnt as TienNT from Mt25 inner join dt25 on mt25.mt25id=dt25.mt25id
union all
select mt22.Ngayct, mt22.soct,mt22.sohoadon,mt22.ngayhd,mt22.diengiai,mt22.makh,  dt22.tkno as [TK],mt22.tkco as [TKDu], dt22.maphi, dt22.mabp ,dt22.mavv ,mt22.MaNT, dt22.makho , dt22.TienNK as Tien, dt22.TienNKNT as TienNT from Mt22 inner join dt22 on mt22.mt22id=dt22.mt22id where dt22.makho is null
union all
select mt23.Ngayct, mt23.soct,mt23.sohoadon,mt23.ngayhd,mt23.diengiai,mt23.makh,  dt23.tkno as [TK],mt23.tkco as [TKDu], dt23.maphi, dt23.mabp ,dt23.mavv ,mt23.MaNT, dt23.makho , dt23.TienNK as Tien, dt23.TienNkNT as TienNT from Mt23 inner join dt23 on mt23.mt23id=dt23.mt23id where dt23.makho is null
) x1

-- Lấy ra số liệu vật tư,  hàng nhập mua nhập vào trong kho bảng MT22 va MT23
select * into #VTHH from (
select mt22.Ngayct, mt22.soct,mt22.sohoadon,mt22.ngayhd,mt22.diengiai, mt22.makh, dt22.tkno as [TK],mt22.tkco as [TKDu], dt22.maphi, dt22.mabp ,dt22.mavv ,mt22.MaNT, dt22.makho,dt22.tienNK, dt22.tienNkNt  from Mt22 inner join dt22 on mt22.mt22id=dt22.mt22id where dt22.makho is not null
union all
select mt23.Ngayct, mt23.soct,mt23.sohoadon,mt23.ngayhd,mt23.diengiai, mt23.makh, dt23.tkno as [TK],mt23.tkco as [TKDu],  dt23.maphi, dt23.mabp ,dt23.mavv ,mt23.MaNT,dt23.makho, dt23.TienNK, dt23.tienNkNt from Mt23 inner join dt23 on mt23.mt23id=dt23.mt23id where dt23.makho is not null
) x2

--kết quả 
if @tk<>''''
begin
select * from (
select Ngayct, soct,sohoadon,ngayhd,makh, diengiai,maphi, mabp,mavv,mant, makho, TK,TKDu, 0 as [Tiền hàng hóa], 0 as [Tiền vật tư], Tien as [Tiền Khác], Tien as [Phải trả], 0 as [Tiền hàng hóa NT], 0 as [Tiền vật tư NT], TienNT as [Tiền khác NT], TienNT as [Phải trả NT] from #Dichvu 
union all
select Ngayct, soct,sohoadon,ngayhd,makh, diengiai,maphi, mabp,mavv,mant, makho, '''' as TK,TKDu, 0 as TienHangHoa, TienNK as TienVatTu, 0 as TienKhac, tienNK as PhaiTra, 0 as TienHangHoaNT, TienNKNT as TienVatTuNT, 0 as TienKhacNT, tienNKNT as PhaiTraNT from #VTHH where TK like ''152%''
union all
select Ngayct, soct,sohoadon,ngayhd,makh, diengiai, maphi, mabp,mavv,mant, makho, '''' as TK,TKDu, TienNK as TienHangHoa, 0 as TienVatTu, 0 as TienKhac, tienNK as PhaiTra, TienNKNT as TienHangHoaNT, 0 as TienVatTuNT, 0 as TienKhacNT, tienNKNT as PhaiTraNT from #VTHH where TK like ''156%''
) a
where @@ps and left(a.tk,len(@tk))=@tk
order by Ngayct, soct
END
ELSE
BEGIN
select * from (
select Ngayct, soct,sohoadon,ngayhd,makh, diengiai,maphi, mabp,mavv,mant, makho, TK,TKDu, 0 as [Tiền hàng hóa], 0 as [Tiền vật tư], Tien as [Tiền Khác], Tien as [Phải trả], 0 as [Tiền hàng hóa NT], 0 as [Tiền vật tư NT], TienNT as [Tiền khác NT], TienNT as [Phải trả NT] from #Dichvu 
union all
select Ngayct, soct,sohoadon,ngayhd,makh, diengiai,maphi, mabp,mavv,mant, makho, '''' as TK,TKDu, 0 as TienHangHoa, TienNK as TienVatTu, 0 as TienKhac, tienNK as PhaiTra, 0 as TienHangHoaNT, TienNKNT as TienVatTuNT, 0 as TienKhacNT, tienNKNT as PhaiTraNT from #VTHH where TK like ''152%''
union all
select Ngayct, soct,sohoadon,ngayhd,makh, diengiai, maphi, mabp,mavv,mant, makho, '''' as TK,TKDu, TienNK as TienHangHoa, 0 as TienVatTu, 0 as TienKhac, tienNK as PhaiTra, TienNKNT as TienHangHoaNT, 0 as TienVatTuNT, 0 as TienKhacNT, tienNKNT as PhaiTraNT from #VTHH where TK like ''156%''
) a
where @@ps
order by Ngayct, soct
END

drop table #Dichvu
drop table #VTHH
'
where ReportName = N'Sổ nhật kí mua hàng'








               
               
                              
               


