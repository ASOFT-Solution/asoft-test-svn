USE [CDT]
declare @sysReportID int,
		@sysFieldID int,
		@mtTableID int

-- Thêm báo cáo ngoại tệ

--1) Sổ chi tiết công nợ khách hàng
select @sysReportID = sysReportID from sysReport
where ReportName = N'Sổ chi tiết công nợ khách hàng' and sysPackageID = 8

if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and ReportFile = 'SCTCNMKHANG_NT')
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Sổ chi tiết công nợ khách hàng (Ngoại tệ)', N'SCTCNMKHANG_NT', N'Book detail receivables by customer (Foreign currency)', NULL)

Update sysReport set Query = N'declare @kh varchar(16)
declare @tkrp varchar(16)
declare @nocodk bit
declare @nocock bit
set @tkrp=@@TK
set @kh=@@MaKH
declare @ngayCt1 datetime
declare @ngayCt2 datetime
set @NgayCt1=cast(@@ngayct1 as datetime)
set @NgayCt2=cast(@@ngayct2 as datetime)
declare @dauky decimal(28,6), @daukynt decimal(28,6)
--tìm số dư đầu kỳ=Số dư đầu năm + số phát sinh trước ngàyCt1
	
	declare @daunam decimal(28,6), @daunamnt decimal(28,6)
	declare @count1 int 
	--Số phát inh đầu năm
	set @daunamnt=(SELECT sum(Dunont-Ducont) from obkh t where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunam=(SELECT sum(Duno-Duco) from obkh t where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @count1=(select count(*) from obkh t where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunamnt = case when @count1<>0 then @daunamnt else 0 end
	set @daunam = case when @count1<>0 then @daunam else 0 end
	set @daukynt=(select sum(case when t.TyGia = 1 then 0 else psNont end)-sum(case when t.TyGia = 1 then 0 else Pscont end) from bltk t where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @dauky=(select sum(psNo)-sum(Psco) from bltk t where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk t where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @daukynt=case when @count1>0 then @daukynt else 0 end
	set @dauky=case when @count1>0 then @dauky else 0 end

	set @daukynt=@daukynt + @daunamnt
	set @dauky=@dauky + @daunam
	set @nocodk = case when @dauky>=0 then 1 else 0 end

--tìm số dư cuối kỳ
	declare @psNo decimal(28,6), @psNont decimal(28,6)
	declare @psCo decimal(28,6), @psCont decimal(28,6)
	declare @cuoiky decimal(28,6), @cuoikynt decimal(28,6)
	set @psNont=(select sum(case when t.TyGia = 1 then 0 else psNont end) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCont=(select sum(case when t.TyGia = 1 then 0 else Pscont end) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNo=(select sum(psNo) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCo=(select sum(Psco) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNont=case when @count1>0 then @psNont else 0 end
	set @psCont=case when @count1>0 then @psCont else 0 end
	set @psNo=case when @count1>0 then @psNo else 0 end
	set @psCo=case when @count1>0 then @psCo else 0 end
	set @cuoikynt=@daukynt + @psNont-@psCont
	set @cuoiky=@dauky + @psNo-@psCo
	set @nocock = case when @cuoiky>=0 then 1 else 0 end

--Lấy số phát sinh

declare @nophatsinh decimal(28,6), @nophatsinhnt decimal(28,6)
declare @phatsinhco decimal(28,6), @phatsinhcont decimal(28,6)
select @nophatsinhnt=sum(case when t.TyGia = 1 then 0 else psnont end) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhcont=sum(case when t.TyGia = 1 then 0 else pscont end) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @nophatsinh=sum(psno) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhco=sum(psco) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps

select null as ngayct,null as MTID,null as MaCT,null as soct, case when @@lang = 1 then N''Beginning amount'' else N''Số dư đầu kỳ'' end as diengiai,
null as tkdu,psnont=case when @nocodk=0 then 0 else @daukynt end,psno=case when @nocodk=0 then 0 else @dauky end,
pscont=case when @nocodk=0 then abs(@daukynt) else 0 end,psco=case when @nocodk=0 then abs(@dauky) else 0 end, null as makh, null as tenkh, 0 as Stt,
NULL AS TenVT, NULL AS DVT, NULL AS SoLuong, NULL AS DonGia, NULL AS DonGiaNT
union  all
select t.ngayCt,t.MTID, t.maCT,t.SoCt,t.diengiai,t.tkdu,case when t.TyGia = 1 then 0 else t.psnont end,t.psno,case when t.TyGia = 1 then 0 else t.pscont end,t.psco ,t.maKH, 
(select case when @@lang = 1 then dm.TenKH2 else dm.TenKH end as tenkh from dmkh dm where dm.makh = t.maKH) as tenkh ,1, 
(select case when @@lang = 1 then dm.TenVT2 else dm.TenVT end as TenVT from DMVT dm where dm.MaVT = blvt.MaVT) as tenVT,
(select case when @@lang = 1 then dm.TenDVT2 else dm.TenDVT end as DVT from DMDVT dm where dm.MaDVT = blvt.MaDVT) as DVT,
case when blvt.SoLuong > 0 then blvt.SoLuong 
	 when blvt.SoLuong_x > 0 then blvt.SoLuong_x else 0 end as SoLuong, 
case when t.psno > 0 then t.psno/(case when blvt.SoLuong > 0 then blvt.SoLuong when blvt.SoLuong_x > 0 then blvt.SoLuong_x else NULL end)
	 when t.psco > 0 then t.psco/(case when blvt.SoLuong > 0 then blvt.SoLuong when blvt.SoLuong_x > 0 then blvt.SoLuong_x else NULL end)
else 0 end as DonGia,
(case when t.psno > 0 then t.psno/(case when blvt.SoLuong > 0 then blvt.SoLuong when blvt.SoLuong_x > 0 then blvt.SoLuong_x else NULL end)
	 when t.psco > 0 then t.psco/(case when blvt.SoLuong > 0 then blvt.SoLuong when blvt.SoLuong_x > 0 then blvt.SoLuong_x else NULL end)
else 0 end)/( case when t.TyGia = 0 then NULL else t.TyGia end) as DonGiaNT
from bltk t left join blvt on 
(cast(t.mtid as nvarchar(36)) +  cast(t.mtiddt as nvarchar(36))) = (cast(blvt.mtid as nvarchar(36)) +  cast(blvt.mtiddt as nvarchar(36)))
where  left(t.tk,len(@tkrp))=@tkrp and (t.ngayCt between @ngayCT1 and @ngayCT2 ) and t.maKH=@kh and @@ps
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Total of arinsing'' else N''Tổng phát sinh'' end as diengiai,
null as tkdu,@nophatsinhnt as sopsnt,@nophatsinh as sops,@phatsinhcont as pscont,@phatsinhco as psco, null as makh, null as tenkh,2,
NULL AS TenVT, NULL AS DVT, NULL AS SoLuong, NULL AS DonGia, NULL AS DonGiaNT
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Closing amount'' else N''Số dư cuối kỳ'' end as diengiai,
null as tkdu,sopsnt=case when @nocock=0 then 0 else @cuoikynt end,sops=case when @nocock=0 then 0 else @cuoiky end,
pscont=case when @nocock=0 then abs(@cuoikynt) else 0 end, psco=case when @nocock=0 then abs(@cuoiky) else 0 end, null as makh, null as tenkh, 3,
NULL AS TenVT, NULL AS DVT, NULL AS SoLuong, NULL AS DonGia, NULL AS DonGiaNT
order by stt,ngayCt, soct, tkdu'
where sysReportID = @sysReportID

--2) Tổng hợp công nợ phải thu
select @sysReportID = sysReportID from sysReport
where ReportName = N'Tổng hợp công nợ phải thu' and sysPackageID = 8

if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and ReportFile = 'THCNPTHU_NT')
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Tổng hợp công nợ phải thu (Ngoại tệ)', N'THCNPTHU_NT', N'Account receivable in general (Foreign currency)', NULL)

--3) Sổ chi tiết công nợ nhà cung cấp
select @sysReportID = sysReportID from sysReport
where ReportName = N'Sổ chi tiết công nợ nhà cung cấp' and sysPackageID = 8

if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and ReportFile = 'SCTCNMKHANG_NT')
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Sổ chi tiết công nợ nhà cung cấp (Ngoại tệ)', N'SCTCNMKHANG_NT', N'Book details the debt providers (Foreign currency)', NULL)

-- Thêm thông tin [Mặt hàng], [Đơn vị tính], [Số lượng], [Đơn giá] lấy từ BLVT
Update sysReport set Query = N'declare @kh varchar(16)
declare @tkrp varchar(16)
declare @nocodk bit
declare @nocock bit
set @tkrp=@@TK
set @kh=@@MaKH
declare @ngayCt1 datetime
declare @ngayCt2 datetime
set @NgayCt1=cast(@@ngayct1 as datetime)
set @NgayCt2=cast(@@ngayct2 as datetime)
declare @dauky decimal(28,6), @daukynt decimal(28,6)
--tìm số dư đầu kỳ=Số dư đầu năm + số phát sinh trước ngàyCt1
	
	declare @daunam decimal(28,6), @daunamnt decimal(28,6)
	declare @count1 int 
	--Số phát inh đầu năm
	set @daunamnt=(SELECT sum(Dunont-Ducont) from obkh t where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunam=(SELECT sum(Duno-Duco) from obkh t where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @count1=(select count(*) from obkh t where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunamnt = case when @count1<>0 then @daunamnt else 0 end
	set @daunam = case when @count1<>0 then @daunam else 0 end
	set @daukynt=(select sum(case when t.TyGia = 1 then 0 else psNont end)-sum(case when t.TyGia = 1 then 0 else Pscont end) from bltk t where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @dauky=(select sum(psNo)-sum(Psco) from bltk t where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk t where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @daukynt=case when @count1>0 then @daukynt else 0 end
	set @dauky=case when @count1>0 then @dauky else 0 end

	set @daukynt=@daukynt + @daunamnt
	set @dauky=@dauky + @daunam
	set @nocodk = case when @dauky>=0 then 1 else 0 end

--tìm số dư cuối kỳ
	declare @psNo decimal(28,6), @psNont decimal(28,6)
	declare @psCo decimal(28,6), @psCont decimal(28,6)
	declare @cuoiky decimal(28,6), @cuoikynt decimal(28,6)
	set @psNont=(select sum(case when t.TyGia = 1 then 0 else psNont end) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCont=(select sum(case when t.TyGia = 1 then 0 else Pscont end) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNo=(select sum(psNo) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCo=(select sum(Psco) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNont=case when @count1>0 then @psNont else 0 end
	set @psCont=case when @count1>0 then @psCont else 0 end
	set @psNo=case when @count1>0 then @psNo else 0 end
	set @psCo=case when @count1>0 then @psCo else 0 end
	set @cuoikynt=@daukynt + @psNont-@psCont
	set @cuoiky=@dauky + @psNo-@psCo
	set @nocock = case when @cuoiky>=0 then 1 else 0 end

--Lấy số phát sinh

declare @nophatsinh decimal(28,6), @nophatsinhnt decimal(28,6)
declare @phatsinhco decimal(28,6), @phatsinhcont decimal(28,6)
select @nophatsinhnt=sum(case when t.TyGia = 1 then 0 else psnont end) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhcont=sum(case when t.TyGia = 1 then 0 else pscont end) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @nophatsinh=sum(psno) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhco=sum(psco) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps

select null as ngayct,null as MTID,null as MaCT,null as soct, case when @@lang = 1 then N''Beginning amount'' else N''Số dư đầu kỳ'' end as diengiai,
null as tkdu,psnont=case when @nocodk=0 then 0 else @daukynt end,psno=case when @nocodk=0 then 0 else @dauky end,
pscont=case when @nocodk=0 then abs(@daukynt) else 0 end,psco=case when @nocodk=0 then abs(@dauky) else 0 end, null as makh, null as tenkh, 0 as Stt,
NULL AS TenVT, NULL AS DVT, NULL AS SoLuong, NULL AS DonGia, NULL AS DonGiaNT
union  all
select t.ngayCt,t.MTID, t.maCT,t.SoCt,t.diengiai,t.tkdu,case when t.TyGia = 1 then 0 else t.psnont end,t.psno,case when t.TyGia = 1 then 0 else t.pscont end,t.psco ,t.maKH,
(select case when @@lang = 1 then dm.tenkh2 else dm.tenkh end from dmkh dm where dm.makh = t.makh) as TenKH, 1,
(select case when @@lang = 1 then dm.TenVT2 else dm.TenVT end from DMVT dm where dm.MaVT = blvt.MaVT) as tenVT,
(select case when @@lang = 1 then dm.TenDVT2 else dm.TenDVT end from DMDVT dm where dm.MaDVT = blvt.MaDVT) as DVT,
case when blvt.SoLuong > 0 then blvt.SoLuong 
	 when blvt.SoLuong_x > 0 then blvt.SoLuong_x else 0 end as SoLuong, 
case when t.psno > 0 then t.psno/(case when blvt.SoLuong > 0 then blvt.SoLuong when blvt.SoLuong_x > 0 then blvt.SoLuong_x else NULL end)
	 when t.psco > 0 then t.psco/(case when blvt.SoLuong > 0 then blvt.SoLuong when blvt.SoLuong_x > 0 then blvt.SoLuong_x else NULL end)
else 0 end as DonGia,
(case when t.psno > 0 then t.psno/(case when blvt.SoLuong > 0 then blvt.SoLuong when blvt.SoLuong_x > 0 then blvt.SoLuong_x else NULL end)
	 when t.psco > 0 then t.psco/(case when blvt.SoLuong > 0 then blvt.SoLuong when blvt.SoLuong_x > 0 then blvt.SoLuong_x else NULL end)
else 0 end)/( case when t.TyGia = 0 then NULL else t.TyGia end) as DonGiaNT
 from bltk t left join blvt on 
 (cast(t.mtid as nvarchar(36)) +  cast(t.mtiddt as nvarchar(36))) = (cast(blvt.mtid as nvarchar(36)) +  cast(blvt.mtiddt as nvarchar(36)))
where  left(t.tk,len(@tkrp))=@tkrp and (t.ngayCt between @ngayCT1 and @ngayCT2 ) and t.maKH=@kh and @@ps
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Total of arinsing'' else N''Tổng phát sinh'' end as diengiai,
null as tkdu,@nophatsinhnt as sopsnt,@nophatsinh as sops,@phatsinhcont as pscont,@phatsinhco as psco, null as makh, null as tenkh,2,
NULL AS TenVT, NULL AS DVT, NULL AS SoLuong, NULL AS DonGia, NULL AS DonGiaNT
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Closing amount'' else N''Số dư cuối kỳ'' end as diengiai,
null as tkdu,sopsnt=case when @nocock=0 then 0 else @cuoikynt end,sops=case when @nocock=0 then 0 else @cuoiky end,
pscont=case when @nocock=0 then abs(@cuoikynt) else 0 end, psco=case when @nocock=0 then abs(@cuoiky) else 0 end, null as makh, null as tenkh, 3,
NULL AS TenVT, NULL AS DVT, NULL AS SoLuong, NULL AS DonGia, NULL AS DonGiaNT
order by stt,ngayCt, soct, tkdu',
mtAlias = N't'
where sysReportID = @sysReportID

--4) Tổng hợp công nợ phải trả
select @sysReportID = sysReportID from sysReport
where ReportName = N'Tổng hợp công nợ phải trả' and sysPackageID = 8

if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and ReportFile = 'THCNPTRA_NT')
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Tổng hợp công nợ phải trả (Ngoại tệ)', N'THCNPTRA_NT', N'Account payable in general (Foreign currency)', NULL)

--5) Báo cáo doanh số bán hàng
select @sysReportID = sysReportID from sysReport
where ReportName = N'Báo cáo doanh số bán hàng' and sysPackageID = 8

if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and ReportFile = 'BCDSBH_NT')
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Chi tiết doanh số bán hàng theo khách hàng (Ngoại tệ)', N'BCDSBH_NT', N'Details of sales revenue by customers (Foreign currency)', NULL)

-- Thêm điều kiện search MaNT
select @mtTableID = sysTableID from sysTable
where TableName = 'MT32' and sysPackageID = 8

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaNT'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 4, 1, 1, 0, NULL)

Update sysReport set Query = N'select x. ngayct, x.sohoadon, x.makh, 
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = x.makh) as tenkh, x.mavt, 
(select case when @@lang = 1 then k.tenvt2 else k.tenvt end from dmvt k where k.mavt = x.mavt) as tenvt, x.soluong, x.gia, x.GiaNT, x.ps, x.PsNT, x.ck, x.CKNT, x.ps - x.ck as [Doanh số], x.PsNT - x.CKNT as [Doanh số nguyên tệ], vo.thue, vo.thueNT, x.mabp, b.tenbp, x.MaNT from
(select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, soluong, gia, GiaNT, ps, PsNT, ck, CKNT, mabp, MaNT
from mt32, dt32, dmvt v
where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt
union all
select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, -soluong, gia, GiaNT, -ps, -PsNT, 0.0, 0.0, mabp, MaNT
from mt33, dt33, dmvt v
where  mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt
union all
select dt31id, ngayhd, sohoadon, makhct, tenkhct,'''', diengiaict, soluong, gia, GiaNT, ps, PsNT, case when ttienh <> 0 then tck*ps/ttienh else 0 end , case when ttienhNT <> 0 then tckNT*psNT/ttienhNT else 0 end, mabp, MaNT
from mt31, dt31
where mt31.mt31id = dt31.mt31id) x, vatout vo, dmbophan b
where dt32id *= vo.mtiddt and x.mabp *= b.mabp and @@ps
order by x.ngayct, x.sohoadon, x.mavt'
where sysReportID = @sysReportID