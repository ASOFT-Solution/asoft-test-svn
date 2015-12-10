USE [CDT]
declare @sysReportID int

select @sysReportID = sysReportID from sysReport
where ReportName = N'Thẻ Kho' and sysPackageID = 8

-- 1) Thẻ Kho
Update sysReport set Query=N'declare @mavt  VARCHAR(16),@madvt VARCHAR(16),@makho VARCHAR(16),
  @MadvtQD Varchar(16),
  @slnQD decimal(28,6), @slxQD decimal(28,6), @sltonQD decimal(28,6),
  @sln decimal(28,6), @slx decimal(28,6), @slton decimal(28,6),
  @tmp decimal(28,6), 
  @tmpQD decimal(28,6),
  @mavtLoop [varchar](16), 
  @makhoLoop [varchar](16),
  @madvtLoop [varchar](16),
  @STT int,
  @id int,@ngayct1 datetime, @ngayct2 datetime
set @mavt = @@mavt
set @makho = @@makho
set @ngayct1 = @@ngayct1
set @ngayct2 = dateadd(hh,23,@@ngayct2)
--Bảng tồn giá trị đầu
DECLARE @Ton TABLE (
     mavt      [VARCHAR](16),
     madvt     [VARCHAR](16),
     madvtQD [VARCHAR] (16),
     sltonQD [DECIMAL](28, 6),
     makho     [VARCHAR](16),
     SlTon     [DECIMAL](28, 6),
     gtton      [DECIMAL](28, 6),
     STT int
     )
INSERT INTO @Ton (mavt, madvt, madvtQD, makho, SlTon,sltonQD, gtton, STT )
 select Mavt, MaDvt, madvtQD, Makho, Sum(Soluong) - Sum(SoLuong_x) as Slton, Sum(SoluongQD) - Sum(SoLuong_xQD) as SltonQD, sum(psno) - sum(psco) as gtton, 0 as STT
 from(
   select A.mavt, makho, A.madvt, B.madvt as MaDVTQD , soluong, soluong_x,case when A.madvt = B.madvt and (soluongQD = 0 or soluongQD is null) then soluong else soluongQD end as soluongQD, case when A.madvt = B.madvt and (soluong_xQD = 0 or soluong_xQD is null) then soluong_x else soluong_xQD end as soluong_xQD, psno, psco 
   from blvt A Inner join DMVT B on A.maVT = B.maVT Where NgayCT < @ngayct1 and MaKho=@makho and  A.MaVT = @mavt
   union all
   select C.mavt, makho, C.madvt,D.madvt as MaDVTQD, soluong, 0.0 as soluong_x,case when C.madvt = D.madvt and (soluongQD = 0 or soluongQD is null) then soluong else soluongQD end as soluongQD,0.0 as soluong_xQD, dudau as psno, 0.0 as psco 
   from obvt C Inner join DMVT D on C.maVT = D.maVT where MaKho=@makho and  C.MaVT = @mavt
   union all
   select E.mavt, makho, E.madvt, F.madvt as MaDVTQD , soluong, 0.0 as soluong_x, case when E.madvt = F.madvt and (soluongQD = 0 or soluongQD is null) then soluong else soluongQD end as soluongQD, 0.0 as soluong_xQD, dudau as psno, 0.0 as psco 
   from obntxt E Inner join DMVT F on E.maVT = F.maVT where MaKho=@makho and  E.MaVT = @mavt) x
 Group by Mavt, MaDvt,MaDvtQD, Makho
     
--Tạo bảng lưu giá trị nhập xuất 
create table #t
 (
 [blvtID] [int]   NULL , 
 [makho] [varchar] (16) COLLATE database_default NULL,
 [mavt] [varchar] (16) COLLATE database_default NULL,
 [madvt] [varchar] (16) COLLATE database_default NULL,
 [madvtqd] [varchar] (16) COLLATE database_default NULL,
 
 [sln] [decimal](28, 6) NULL ,
 [slnQD] [decimal](28, 6) NULL ,
 [slx] [decimal](28, 6) NULL ,
 [slxQD] [decimal](28, 6) NULL ,
 [slton] [decimal](28, 6) NULL,
 [sltonQD] [decimal](28, 6) NULL,
 STT int
) ON [PRIMARY]
insert into #t 
select blvtid, makho, A.mavt, A.madvt, B.madvt as madvtQD,soluong,case when A.madvt = B.madvt and (soluongQD = 0 or soluongQD is null) then soluong else soluongQD end as soluongQD, soluong_x, case when A.madvt = B.madvt and (soluong_xQD = 0 or soluong_xQD is null) then soluong_x else soluong_xQD end as soluong_xQD, 0.0 as slton,0.0 as sltonQD
, case when soluong_x > 0 then 2 else 1 end as STT
from blvt A
Inner join DMVT B on A.maVT = B.maVT
where NgayCT between @ngayct1 and @ngayct2 and MaKho=@makho and A.MaVT = @mavt
order by NgayCT,STT, SoCT, makho, A.Mavt, A.Madvt

-- Tính toán lại giá trị tồn kho
declare cur cursor for 
select blvtid, soluong,case when t.madvt = B.madvt and (soluongQD = 0 or soluongQD is null) then soluong else soluongQD end as soluongQD, soluong_x,case when t.madvt = B.madvt and (soluong_xQD = 0 or soluong_xQD is null) then soluong_x else soluong_xQD end as soluong_xQD, 0.0 as slton, 0.0 as sltonQD, t.mavt,t.madvt,B.Madvt as madvtQD ,makho
, case when soluong_x > 0 then 2 else 1 end as STT
from blvt t Inner join DMVT B On t.maVT=B.MaVT
where NgayCT between @ngayct1 and @ngayct2 and t.MaVT = @mavt  and  t.MaKho = @makho 
order by makho, t.mavt, t.madvt,NgayCT,STT, SoCT
open cur
fetch cur  into @ID,@sln,@slnQD, @slx,@slxQD, @slton,@sltonQD, @mavt,@madvt,@madvtQD, @makho,@stt
set @mavtLoop = ''''
set @makhoLoop = ''''
Set @madvtLoop = ''''
while @@fetch_status=0
begin
 -- Tính qua vật tư khác hoặc kho khác
 if @makhoLoop <> @makho or @mavtLoop <> @mavt  or @madvtLoop <> @madvt
  BEGIN
   set @makhoLoop = @makho
   set @mavtLoop = @mavt
   set @madvtLoop = @madvt
   set @tmp = 0
   set @tmpQD = 0
   select  @tmp = isnull(SlTon,0), @tmpQD = isnull(SlTonQD,0) from @Ton where MaKho = @makho and MaVT = @mavt and madvt = @madvt 
  END
 set @slton=@tmp+@sln-@slx
 set @sltonQD=@tmpQD+@slnQD-@slxQD
 set @tmp=@slton
 set @tmpQD=@sltonQD
 UPDATE #t SET slton=@slton, sltonQD=@sltonQD where blvtid=@id
 fetch cur  into @ID,@sln,@slnQD, @slx,@slxQD, @slton,@sltonQD,  @mavt,@madvt,@madvtQD, @makho, @stt
end
close cur
deallocate cur

select case when @@lang = 1 then y.tenvt2 else y.tenvt end as tenvt, 
case when @@lang = 1 then z.tenkho2 else z.tenkho end as tenkho, 
case when @@lang = 1 then d.tendvt2 else d.tendvt end as tendvt,
case when @@lang = 1 then d2.tendvt2 else d2.tendvt end as tendvtQD,
x.*
from (
 -- Insert dòng tồn đầu kỳ <> 0 cho các vật tư có giá trị tồn
  select null as NgayCT, null as SoCT,null as TenKH,case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end as DienGiai, mavt,madvt,madvtQD, makho, null as Dongia ,null SoLuong,null SoLuongQD, gtton as [Giá trị nhập] ,NULL SoLuong_X,NULL SoLuong_XQD, NULL [Giá trị xuất] , SlTon,SlTonQD as [Số lượng tồn quy đổi],STT
  from @Ton
  
  union all
  
  -- Insert dòng tồn đầu kỳ = 0 cho các vật tư không có giá trị tồn
   Select distinct null, null, null, case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end, t.mavt,t.madvt,D.madvt as madvtQD , makho,null, null,null,null, null, null, 0, 0,0,0
     from blvt t , DMVT D 
     where t.mavt=D.mavt
     and t.NgayCT between @ngayct1 and @ngayct2
     and not exists(select * from @Ton ton where t.Makho = ton.Makho and t.Mavt = ton.Mavt and t.Madvt = ton.Madvt)
     and t.MaKho=@makho and t.MaVT = @mavt
  
  union all
  
 -- Insert số phát sinh nhập xuất
  Select NgayCT, SoCT,case when @@lang = 1 then dmkh.TenKH2 else dmkh.TenKH end as TenKH,DienGiai, @mavt mavt,blvt.madvt,#t.maDVTqD as maDVTqD,@makho makho, Dongia ,
   SoLuongN = #t.sln,SoLuongNQD = #t.slnQD,GiaTriN = case when PsNo > 0 then PsNo else null end, 
   SoLuongX = #t.slx,SoLuongXQD = #t.slxQD,GiaTriX = case when PsCo > 0 then PsCo else null end, 
   SlTon = #t.SlTon,SlTonQD = #t.SlTonQD,stt
  from blvt, #t, dmkh
  where #t.blvtid = blvt.blvtid and blvt.MaKH *= dmkh.MaKH and NgayCT between @ngayct1 and @ngayct2 and #t.MaKho=@makho and #t.MaVT = @mavt and #t.madvt = blvt.madvt
 ) x, dmvt y,dmkho z, dmdvt d, dmdvt d2 
where x.mavt =y.mavt and x.makho=z.makho and x.madvt = d.madvt and x.madvtQD = d2.madvt
order by x.makho, x.mavt, x.madvt,NgayCT,stt, SoCT
drop table #t'
where sysReportID = @sysReportID

Update [sysFormReport] set ReportFile = 'TKHO'
where sysReportID = @sysReportID and ReportFile is null

-- 2) Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and ReportFile = 'TKHO_QD')
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Thẻ kho (Quy đổi)', N'TKHO_QD', N'Card stock (Converted Unit)', NULL)

---- Dictionary
--declare @sysTableID int,
--		@lang_vn nvarchar(255),
--		@lang_en nvarchar(255),
--		@formatSoLuong nvarchar(128)
--select @sysTableID = sysTableID from sysTable where TableName = 'wReportRvCtrl'

--set @formatSoLuong = dbo.GetFormatString('SoLuong')
--set @lang_vn = N'Số lượng tồn quy đổi'
--set @lang_en = N'Converted Inventory Quantity'
--if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
--INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
--VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 8, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, @formatSoLuong, 0, NULL)

----Insert format string
--if not exists (select top 1 1 from sysFormatString where _Key = 'SoLuong' and Fieldname=N'SoLuong_XQD') 
-- insert into sysFormatString(_Key, Fieldname) Values ('SoLuong',N'SoLuong_XQD')
 
--if not exists (select top 1 1 from sysFormatString where _Key = 'SoLuong' and Fieldname=N'SlTonQD') 
-- insert into sysFormatString(_Key, Fieldname) Values ('SoLuong',N'SlTonQD')

--if not exists (select top 1 1 from sysFormatString where _Key = 'SoLuong' and Fieldname=N'Số lượng tồn quy đổi') 
-- insert into sysFormatString(_Key, Fieldname) Values ('SoLuong',N'Số lượng tồn quy đổi') 
 