USE [CDT]

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
	set @daukynt=(select sum(psNont)-sum(Pscont) from bltk t where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
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
	set @psNont=(select sum(psNont) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCont=(select sum(Pscont) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
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
select @nophatsinhnt=sum(psnont) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhcont=sum(pscont) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @nophatsinh=sum(psno) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhco=sum(psco) from bltk t where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps

select null as ngayct,null as MTID,null as MaCT,null as soct, case when @@lang = 1 then N''Beginning amount'' else N''Số dư đầu kỳ'' end as diengiai,
null as tkdu,psnont=case when @nocodk=0 then 0 else @daukynt end,psno=case when @nocodk=0 then 0 else @dauky end,
pscont=case when @nocodk=0 then abs(@daukynt) else 0 end,psco=case when @nocodk=0 then abs(@dauky) else 0 end, null as makh, null as tenkh, 0 as Stt,
NULL AS TenVT, NULL AS DVT, NULL AS SoLuong, NULL AS DonGia
union  all
select t.ngayCt,t.MTID, t.maCT,t.SoCt,t.diengiai,t.tkdu,t.psnont,t.psno,t.pscont,t.psco ,t.maKH, 
(select case when @@lang = 1 then dm.TenKH2 else dm.TenKH end as tenkh from dmkh dm where dm.makh = t.maKH) as tenkh ,1, 
(select case when @@lang = 1 then dm.TenVT2 else dm.TenVT end as TenVT from DMVT dm where dm.MaVT = blvt.MaVT) as tenVT,
(select case when @@lang = 1 then dm.TenDVT2 else dm.TenDVT end as DVT from DMDVT dm where dm.MaDVT = blvt.MaDVT) as DVT,
case when blvt.SoLuong > 0 then blvt.SoLuong 
	 when blvt.SoLuong_x > 0 then blvt.SoLuong_x else 0 end as SoLuong, 
case when t.psno > 0 then t.psno/(case when blvt.SoLuong > 0 then blvt.SoLuong when blvt.SoLuong_x > 0 then blvt.SoLuong_x else NULL end)
	 when t.psco > 0 then t.psco/(case when blvt.SoLuong > 0 then blvt.SoLuong when blvt.SoLuong_x > 0 then blvt.SoLuong_x else NULL end)
else 0 end as DonGia
from bltk t left join blvt on 
(cast(t.mtid as nvarchar(36)) +  cast(t.mtiddt as nvarchar(36))) = (cast(blvt.mtid as nvarchar(36)) +  cast(blvt.mtiddt as nvarchar(36)))
where  left(t.tk,len(@tkrp))=@tkrp and (t.ngayCt between @ngayCT1 and @ngayCT2 ) and t.maKH=@kh and @@ps
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Total of arinsing'' else N''Tổng phát sinh'' end as diengiai,
null as tkdu,@nophatsinhnt as sopsnt,@nophatsinh as sops,@phatsinhcont as pscont,@phatsinhco as psco, null as makh, null as tenkh,2,
NULL AS TenVT, NULL AS DVT, NULL AS SoLuong, NULL AS DonGia
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Closing amount'' else N''Số dư cuối kỳ'' end as diengiai,
null as tkdu,sopsnt=case when @nocock=0 then 0 else @cuoikynt end,sops=case when @nocock=0 then 0 else @cuoiky end,
pscont=case when @nocock=0 then abs(@cuoikynt) else 0 end, psco=case when @nocock=0 then abs(@cuoiky) else 0 end, null as makh, null as tenkh, 3,
NULL AS TenVT, NULL AS DVT, NULL AS SoLuong, NULL AS DonGia
order by stt,ngayCt, soct, tkdu',
mtAlias = N't'
where ReportName = N'Sổ chi tiết công nợ khách hàng'