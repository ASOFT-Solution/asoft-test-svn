USE [CDT]
declare @sysReportID int

select @sysReportID = sysReportID from sysReport
where ReportName = N'Sổ chi tiết vật tư' and sysPackageID = 8

-- 1) Sổ chi tiết vật tư
Update sysReport set Query=N'declare @ngayct1 datetime, 
  @ngayct2 datetime
set @ngayct1 = @@ngayct1
set @ngayct2 = dateadd(hh,23,@@ngayct2)
declare @sln decimal(28,6),
  @slnQD decimal(28,6),
  @gtnhap decimal(28,6),
  @slx decimal(28,6), 
  @slxQD decimal(28,6), 
  @gtxuat decimal(28,6),
  @slton decimal(28,6),
  @sltonQD decimal(28,6),
  @gtton decimal(28,6), 
  @id int,
  @mavt [varchar](16), 
  @madvt [varchar](16),
  @madvtQD [varchar](16),
  @makho [varchar](16),
  @tmp decimal(28,6), 
  @tmpQD decimal(28,6), 
  @tmp1 decimal(28,6),
  @mavtLoop [varchar](16), 
  @makhoLoop [varchar](16),
  @madvtLoop [varchar](16),
  @STT int
DECLARE @Ton TABLE
(
  NgayCT smalldatetime,
  MACT nvarchar(512),
  MTID uniqueidentifier,
  SoCT [nvarchar](512),
  TenKH [nvarchar](512),
  DienGiai [nvarchar](512),
  DonGia [decimal](28, 6),
  mavt [varchar](16),
  madvt [varchar](16),
  madvtQD [varchar](16),
  makho [varchar](16),
  SoLuong [decimal](28, 6),
  SoLuongQD [decimal](28, 6),
  gtn [decimal](28, 6),
  SoLuong_X [decimal](28, 6),
  SoLuong_XQD [decimal](28, 6),
  gtx [decimal](28, 6),
  SlTon [decimal](28, 6),
  SlTonQD [decimal](28, 6),
  gtt [decimal](28, 6),
  STT int
)
DECLARE @t TABLE
(
 [blvtID] [int]   NULL , 
 [sln] [decimal](28, 6) NULL ,
 [slnQD] [decimal](28, 6) NULL ,
 [gtnhap] [decimal](28, 6) NULL ,
 [slx] [decimal](28, 6) NULL ,
 [slxQD] [decimal](28, 6) NULL ,
 [gtxuat] [decimal](28, 6) NULL ,
 [slton] [decimal](28, 6) NULL ,
 [sltonQD] [decimal](28, 6) NULL ,
 [gtton] [decimal](28, 6) NULL ,
 --mavt [varchar](16), 
 makho [varchar](16),
 STT int
)
-- Lấy giá trị tồn kho
insert into @Ton(NgayCT, MACT, MTID, SoCT, TenKH, DienGiai, DonGia, mavt,madvt,madvtQD, makho, SoLuong, SoLuongQD, gtn, SoLuong_X, SoLuong_XQD, gtx, SlTon,SlTonQD, gtt,stt)
select null, null, null, null , null , case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end, null, MaVT,madvt,madvtQD, MaKho, null,null, null, null ,null, null , Sum(Soluong) - Sum(SoLuong_x),Sum(SoluongQD) - Sum(SoLuong_xQD), sum(psno) - sum(psco),0 as stt
 from(
 select soluong,case when t.madvt = A.madvt and (soluongQD = 0 or soluongQD is null) then soluong else soluongQD end as soluongQD, soluong_x,case when t.madvt = A.madvt and (soluong_xQD = 0 or soluong_xQD is null) then soluong_x else soluong_xQD end as soluong_xQD, psno, psco, t.MaVT,t.madvt,A.madvt as madvtQD, MaKho from blvt t inner join DMVT A On t.maVT=A.maVT  where NgayCT < @ngayct1 and @@ps
 union all
 select soluong,case when t.madvt = A.madvt and (soluongQD = 0 or soluongQD is null) then soluong else soluongQD end as soluongQD, 0.0 as soluong_x,0.0 as soluong_xQD, dudau as psno, 0.0 as psco, t.MaVT,t.madvt, A.madvt as madvtQD, MaKho from obvt t inner join DMVT A On t.maVT=A.maVT where @@ps
 union all
 select soluong,case when t.madvt = A.madvt and (soluongQD = 0 or soluongQD is null) then soluong else soluongQD end as soluongQD, 0.0 as soluong_x,0.0 as soluong_xQD, dudau as psno, 0.0 as psco, t.MaVT,t.madvt, A.madvt as madvtQD, MaKho from obntxt t inner join DMVT A On t.maVT=A.maVT where @@ps
 ) x
 group by MaKho, MaVT, madvt, madvtQD
 
-- Lấy số phát sinh
insert into @t 
select blvtid, soluong, case when t.madvt = A.madvt and (soluongQD = 0 or soluongQD is null) then soluong else soluongQD end as soluongQD, psno, soluong_x,case when t.madvt = A.madvt and (soluong_xQD = 0 or soluong_xQD is null) then soluong_x else soluong_xQD end as soluong_xQD,psco, 0.0 as slton,0.0 as sltonQD, 0.0 as gtton, makho
, case when soluong_x > 0 then 2 else 1 end as STT
from blvt t inner join DMVT A On t.maVT=A.maVT
where NgayCT between @ngayct1 and @ngayct2 and @@ps
order by makho, t.mavt, t.madvt,NgayCT,STT, SoCT


-- Tính toán lại giá trị tồn kho
declare cur cursor for 
select blvtid, soluong, case when t.madvt = A.madvt and (soluongQD = 0 or soluongQD is null) then soluong else soluongQD end as soluongQD, psno, soluong_x, case when t.madvt = A.madvt and (soluong_xQD = 0 or soluong_xQD is null) then soluong_x else soluong_xQD end as soluong_xQD, psco, 0.0 as slton,0.0 as sltonQD, 0.0 as gtton, t.mavt,t.madvt, A.madvt as madvtQD, makho
, case when soluong_x > 0 then 2 else 1 end as STT
from blvt t Inner join DMVT A On A.maVT=t.maVT
where NgayCT between @ngayct1 and @ngayct2 and @@ps
order by makho, t.mavt, t.madvt,NgayCT,STT, SoCT
open cur
fetch cur  into @ID,@sln, @slnQD, @gtnhap, @slx,@slxQD,@gtxuat, @slton,@sltonQD, @gtton, @mavt,@madvt,@madvtQD, @makho, @stt
set @mavtLoop = ''''
set @makhoLoop = ''''
Set @madvtLoop = ''''
while @@fetch_status=0
begin
 -- Tính qua vật tư khác hoặc kho khác
 if @makhoLoop <> @makho or @mavtLoop <> @mavt  or @madvtLoop <> @madvt
 BEGIN
  set @makhoLoop = @makho
  set @tmp1 = 0
  set @mavtLoop = @mavt
  set @madvtLoop = @madvt
  set @tmp = 0
  set @tmpQD = 0
  select @tmp1 = isnull(gtt,0), @tmp = isnull(SlTon,0),@tmpQD = isnull(SlTonQD,0) from @Ton where MaKho = @makho and MaVT = @mavt and madvt = @madvt
 END
 set @slton=@tmp+@sln-@slx
 set @sltonQD=@tmpQD+@slnQD-@slxQD
 set @tmp=@slton
 set @tmpQD=@sltonQD
 set @gtton=@tmp1+@gtnhap-@gtxuat
 set @tmp1=@gtton
  UPDATE @t SET slton=@slton, sltonQD=@sltonQD, gtton=@gtton where blvtid=@id
 fetch cur  into @ID,@sln, @slnQD, @gtnhap, @slx,@slxQD,@gtxuat, @slton,@sltonQD, @gtton, @mavt,@madvt,@madvtQD, @makho, @stt
end
close cur
deallocate cur

-- Lấy kết quả
select  x.*, 
case when @@lang = 1 then y.tenvt2 else y.tenvt end as tenvt,
case when @@lang = 1 then t.tendvt2 else t.tendvt end as tendvt,
case when @@lang = 1 then z.tenkho2 else z.tenkho end as tenkho,
case when @@lang = 1 then t2.tendvt2 else t2.tendvt end as tendvtQD
from (
  -- Bảng các vật tư có giá trị tồn
   select NgayCT, MACT, MTID, SoCT, TenKH, DienGiai, DonGia,mavt,madvt, madvtQd, makho, SoLuong,soluongQD, gtn as [Giá trị nhập], SoLuong_X,SoLuong_XQD, gtx as [Giá trị xuất],SlTon,SlTonQD as [Số lượng tồn quy đổi], gtt as [Giá trị tồn], stt
     from @Ton
   union all
  -- Insert dòng tồn đầu kỳ = 0 cho các vật tư không có giá trị tồn
   Select distinct null, null, null, null, null ,  case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end, null, t.mavt,t.madvt,A.madvt as madvtQD, makho,null,null, null, null,null, null, 0, 0, 0, 0
     from blvt t , DMVT A 
     where t.NgayCT between @ngayct1 and @ngayct2 and A.maVT= t.maVT and @@ps 
     and not exists(select * from @Ton ton where t.Makho = ton.Makho and t.Mavt = ton.Mavt and t.Madvt = ton.Madvt)
   union all
  -- Bảng nhập xuất
   Select t.NgayCT, MACT, MTID, SoCT, case when @@lang = 1 then dmkh.TenKH2 else dmkh.TenKH end as TenKH , DienGiai, DonGia, t.mavt,t.madvt ,d.madvt as madvtQD, tmp.makho, tmp.sln,tmp.slnQD, case when PsNo > 0 then PsNo else null end, tmp.slx,tmp.slxQD, case when PsCo > 0 then PsCo else null end, tmp.SlTon,tmp.SlTonQD, tmp.gtton, stt
     from blvt t, dmkh, @t tmp , dmvt d
     where tmp.blvtid = t.blvtid and t.MaKH *= dmkh.MaKH and t.maVT = d.maVT and NgayCT between @ngayct1 and @ngayct2 and @@ps
 ) x, dmvt y,dmkho z, dmdvt t , dmdvt t2 
where x.mavt =y.mavt and x.makho=z.makho and x.madvt = t.madvt and x.madvtQd = t2.madvt
order by x.makho, x.mavt, x.madvt,  NgayCT,stt, SoCT'
where sysReportID = @sysReportID

Update [sysFormReport] set ReportFile = 'SCTVTU'
where sysReportID = @sysReportID and ReportFile is null

-- 2) Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and ReportFile = 'SCTVTU_QD')
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Sổ chi tiết vật tư(Quy đổi)', N'SCTVTU_QD', N'Detailed book of materials(Converted Unit)', NULL)

-- 3) Bảng cân đối nhập xuất tồn
Update sysReport set LinkTableAlias = 't'
where ReportName=N'Bảng cân đối nhập xuất tồn'
and LinkTableAlias is null

-- Dictionary
declare @sysTableID int,
		@lang_vn nvarchar(255),
		@lang_en nvarchar(255),
		@formatSoLuong nvarchar(128)
select @sysTableID = sysTableID from sysTable where TableName = 'wReportRvCtrl'

set @formatSoLuong = dbo.GetFormatString('SoLuong')
set @lang_vn = N'Số lượng tồn quy đổi'
set @lang_en = N'Converted Inventory Quantity'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 8, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, @formatSoLuong, 0, NULL)

--Insert format string
if not exists (select top 1 1 from sysFormatString where _Key = 'SoLuong' and Fieldname=N'SoLuong_XQD') 
 insert into sysFormatString(_Key, Fieldname) Values ('SoLuong',N'SoLuong_XQD')
 
if not exists (select top 1 1 from sysFormatString where _Key = 'SoLuong' and Fieldname=N'SlTonQD') 
 insert into sysFormatString(_Key, Fieldname) Values ('SoLuong',N'SlTonQD')

if not exists (select top 1 1 from sysFormatString where _Key = 'SoLuong' and Fieldname=N'Số lượng tồn quy đổi') 
 insert into sysFormatString(_Key, Fieldname) Values ('SoLuong',N'Số lượng tồn quy đổi') 
 