use [CDT]

-- Sổ chi tiết vật tư
Update sysReport set Query = N'declare @ngayct1 datetime, 
		@ngayct2 datetime
set @ngayct1 = @@ngayct1
set @ngayct2 = dateadd(hh,23,@@ngayct2)

declare @sln decimal(28,6),
		@gtnhap decimal(28,6),
		@slx decimal(28,6), 
		@gtxuat decimal(28,6),
		@slton decimal(28,6),
		@gtton decimal(28,6), 
		@id int,
		@mavt [varchar](16), 
		@makho [varchar](16),
		@tmp decimal(28,6), 
		@tmp1 decimal(28,6),
		@mavtLoop [varchar](16), 
		@makhoLoop [varchar](16)
				
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
  makho [varchar](16),
  SoLuong [decimal](28, 6),
  gtn [decimal](28, 6),
  SoLuong_X [decimal](28, 6),
  gtx [decimal](28, 6),
  SlTon [decimal](28, 6),
  gtt [decimal](28, 6)
)

DECLARE @t TABLE
(
 [blvtID] [int]   NULL , 
 [sln] [decimal](28, 6) NULL ,
 [gtnhap] [decimal](28, 6) NULL ,
 [slx] [decimal](28, 6) NULL ,
 [gtxuat] [decimal](28, 6) NULL ,
 [slton] [decimal](28, 6) NULL ,
 [gtton] [decimal](28, 6) NULL ,
 --mavt [varchar](16), 
 makho [varchar](16)
)

-- Lấy giá trị tồn kho
insert into @Ton(NgayCT, MACT, MTID, SoCT, TenKH, DienGiai, DonGia, mavt, makho, SoLuong, gtn, SoLuong_X, gtx, SlTon, gtt)
select null, null, null, null , null , case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end, null,
		MaVT, MaKho, null, null, null , null , 
		Sum(Soluong) - Sum(SoLuong_x), sum(psno) - sum(psco)
 from(
 select soluong, soluong_x, psno, psco, MaVT, MaKho from blvt t where NgayCT < @ngayct1 and @@ps
 union
 select soluong, 0.0 as soluong_x, dudau as psno, 0.0 as psco, MaVT, MaKho from obvt t where @@ps
 union
 select soluong, 0.0 as soluong_x, dudau as psno, 0.0 as psco, MaVT, MaKho from obntxt t where @@ps
 ) x
 group by MaKho, MaVT

-- Lấy số phát sinh
insert into @t select blvtid, soluong,psno, soluong_x,psco, 0.0 as slton, 0.0 as gtton, makho
from blvt t
where NgayCT between @ngayct1 and @ngayct2 and @@ps
order by makho, mavt, NgayCT, SoCT

-- Tính toán lại giá trị tồn kho
declare cur cursor for 
select blvtid, soluong,psno, soluong_x,psco, 0.0 as slton, 0.0 as gtton, mavt, makho
from blvt t
where NgayCT between @ngayct1 and @ngayct2 and @@ps
order by makho, mavt, NgayCT, SoCT

open cur
fetch cur  into @ID,@sln,@gtnhap, @slx,@gtxuat, @slton, @gtton, @mavt, @makho

set @mavtLoop = ''''
set @makhoLoop = ''''

while @@fetch_status=0
begin

 -- Tính qua vật tư khác hoặc kho khác
 if @makhoLoop <> @makho or @mavtLoop <> @mavt 
 BEGIN
	 set @makhoLoop = @makho
	 set @tmp1 = 0
	 
	 set @mavtLoop = @mavt
	 set @tmp = 0
	 
	 select @tmp1 = isnull(gtt,0), @tmp = isnull(SlTon,0) from @Ton where MaKho = @makho and MaVT = @mavt
 END

 set @slton=@tmp+@sln-@slx
 set @tmp=@slton
 set @gtton=@tmp1+@gtnhap-@gtxuat
 set @tmp1=@gtton
 
 UPDATE @t SET slton=@slton, gtton=@gtton where blvtid=@id
 fetch cur  into @ID,@sln,@gtnhap, @slx,@gtxuat, @slton, @gtton, @mavt, @makho
 
end
close cur
deallocate cur

-- Lấy kết quả
select y.tenvt, case when ngayCT is not null then y.madvt else null end as madvt,z.tenkho, x.* 
from (
	-- Bảng các vật tư có giá trị tồn
	select NgayCT, MACT, MTID, SoCT, TenKH, DienGiai, DonGia,
			mavt, makho, SoLuong, gtn as [Giá trị nhập], SoLuong_X, gtx as [Giá trị xuất], 
			SlTon, gtt as [Giá trị tồn]
	 from @Ton
	 
	union
	 
	 -- Insert dòng tồn đầu kỳ = 0 cho các vật tư không có giá trị tồn
	 Select distinct null, null, null, null, null ,  case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end, null, mavt, makho,
	  null, null, null, null, 0, 0
	 from blvt t
	 where t.NgayCT between @ngayct1 and @ngayct2 and @@ps and
		   (t.MaKho not in (select makho from @Ton)
		   or t.Mavt not in (select mavt from @Ton))
	 
	union
	 
	-- Bảng nhập xuất
	Select NgayCT, MACT, MTID, SoCT, dmkh.TenKH , DienGiai, DonGia, t.mavt, tmp.makho,
	  tmp.sln, case when PsNo > 0 then PsNo else null end,
	  tmp.slx, case when PsCo > 0 then PsCo else null end, tmp.SlTon, tmp.gtton
	 from blvt t, dmkh, @t tmp
	 where tmp.blvtid = t.blvtid and t.MaKH *= dmkh.MaKH and 
			NgayCT between @ngayct1 and @ngayct2 and @@ps
 ) x, dmvt y,dmkho z
where x.mavt =y.mavt and x.makho=z.makho
order by x.makho, x.mavt, NgayCT, SoCT
', mtAlias = 't'
where ReportName = N'Sổ chi tiết vật tư'

-- Tham số báo cáo
declare @sysReportID int,
		@sysFieldID int

select @sysReportID = sysReportID from sysReport
where ReportName = N'sổ chi tiết vật tư'

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaKho'
				and sysTableID = (select sysTableID from sysTable where TableName = 'OBNTXT')
				
Update [sysReportFilter] set IsMaster = 1, AllowNull = 0, IsBetween = 1, SpecialCond = 0
where [sysFieldID] = @sysFieldID and sysReportID = @sysReportID

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaVT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLVT')
				
Update [sysReportFilter] set IsMaster = 1, AllowNull = 1, IsBetween = 1, SpecialCond = 0
where [sysFieldID] = @sysFieldID and sysReportID = @sysReportID