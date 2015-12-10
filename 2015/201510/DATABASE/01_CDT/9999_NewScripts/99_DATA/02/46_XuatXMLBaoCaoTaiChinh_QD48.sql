Use CDT

declare @sysTableID int,
		@sysReportID int,
		@mtTableID int,
		@sysSiteIDPRO int,
		@sysSiteIDSTD int,
		@sysMenuParent int,
		@sysFieldID int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

select @sysTableID = sysTableID from sysTable
where TableName = 'sysReport'

-- 1) Thêm báo cáo [Lập báo cáo tài chính (QĐ 48/2006-BTC)]

select @mtTableID = sysTableID from sysTable
where TableName = 'BLTK' and sysPackageID = 8

if not exists (select top 1 1 from sysReport where ReportName = N'Lập báo cáo tài chính (QĐ 48/2006-BTC)' and sysPackageID = 8)
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData], [AttachedReport], HasExportXML, QueryXML, XMLTemplate, OutputXMLFileNamePattern) 
VALUES (N'Lập báo cáo tài chính (QĐ 48/2006-BTC)', 2, @mtTableID, NULL, N'', 
N'BCDKTOAN;BCKQHDKDOANH;BCLCTTPPTTIEP', N'Financial reporting', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, NULL, null, NULL,
N'Bảng cân đối kế toán;Báo cáo kết quả kinh doanh;Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp',
1, N'', N'', N'')

select @sysReportID = sysReportID from sysReport
where ReportName = N'Lập báo cáo tài chính (QĐ 48/2006-BTC)'

Update sysReport set Query = N'
-- Bảng cân đối kế toán
select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh, fr.CachTinh, fr.LoaiCT, fr.InBaoCao,iscn
	,999999999999999.000000  as [Đầu năm]
	,999999999999999.000000 as [Cuối kỳ]
	into t
	from sysFormReport fr
	where fr.sysReportID = @@sysReportID[0]
	order by Stt
declare @ngayCt1 datetime
declare @ngayCt2 datetime
	set @ngayCt1=@@NgayCt1
	set @ngayCt2=DATEADD(hh,23,@@NgayCt2)
set @ngayCt1= dateadd(hh,-1,@ngayCt1)
declare cur cursor for select Maso,cachtinh,loaiCt,tk,tkdu,iscn,[Đầu năm],[Cuối kỳ] from t
	open cur
declare @Maso nvarchar (50)
declare @Cachtinh nvarchar(256)
declare @LoaiCt int
declare @tk nvarchar (256)
declare @tkdu nvarchar (256)
declare @iscn bit 
declare @daunam decimal(28,6)
declare @cuoiky decimal(28,6)
--Tính các ch? tiêu
declare @duno decimal(28,6)
declare @duco decimal(28,6)
declare @duno1 decimal(28,6)
declare @duco1 decimal(28,6)
fetch cur  into @Maso,@Cachtinh,@LoaiCt,@tk,@tkdu,@iscn,@daunam,@cuoiky
while @@fetch_status=0
begin
	--L?y s? d?u nam
	if @tk is not null and @loaiCt<>0
	begin
		
		exec sodutaikhoan @tk, @ngayCt1, DEFAULT, @duno OUTPUT , @duco OUTPUT 
		if @iscn=1
			begin	
				set @daunam=0
				if @loaiCt=5 set @daunam=@duno
				if @loaiCt=6 set @daunam=@duco
			end
		if @iscn=0
			begin	
				set @duno1= @duno-@duco 
				set @duco1= @duco-@duno 
				set @daunam=0
				if @loaiCt=5 set @daunam=@duno1
				if @loaiCt=6 set @daunam=@duco1
			end
		

		--L?y s? cu?i k?
		exec sodutaikhoan @tk, @ngayCt2, DEFAULT, @duno OUTPUT , @duco OUTPUT
	 	if @iscn=1
			begin	
				set @cuoiky=0
				if @loaiCt=5 set @cuoiky=@duno
				if @loaiCt=6 set @cuoiky=@duco
			end
		if @iscn=0
			begin	
				set @duno1= @duno-@duco 
				set @duco1= @duco-@duno 
					set @cuoiky=0
				if @loaiCt=5 set @cuoiky=@duno1
				if @loaiCt=6 set @cuoiky=@duco1
			end

		UPDATE t SET [Đầu năm]=@daunam where Maso=@Maso
		UPDATE t SET [Cuối kỳ]=@cuoiky where Maso=@Maso
		
	end
	fetch cur  into @Maso,@cachtinh, @LoaiCt,@tk,@tkdu,@iscn,@daunam,@cuoiky
end
close cur
deallocate cur
update t set [Đầu năm]=0,[Cuối kỳ]=0 where loaict=0
select * from t
drop table t

-- Báo cáo kết quả kinh doanh
select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh, fr.CachTinh, fr.LoaiCT, fr.InBaoCao
	,999999999999999.000000  as [Kỳ trước]
	,999999999999999.000000 as [Kỳ này]
	into t
	from sysFormReport fr
	where fr.sysReportID = @@sysReportID[1]
	order by Stt

declare @ngayCt3 datetime
declare @ngayCt4 datetime
	set @ngayCt1=@@NgayCt1
	set @ngayCt2=DATEADD(hh,23,@@NgayCt2)
	set @ngayCt3=DATEADD(year,-1,@ngayCt1)
	set @ngayCt4=DATEADD(year,-1,@ngayCt2)
declare cur2 cursor for select Maso,loaiCt,tk,tkdu,[Kỳ trước],[Kỳ này] from t
	open cur2



declare @KyTruoc decimal(28,6)
declare @KyNay decimal(28,6)
--Tính các ch? tiêu
declare @psno decimal(28,6)
declare @psco decimal(28,6)
fetch cur2  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay
while @@fetch_status=0
begin
	--Lay so phat sinh ky truoc
	if @tk is not null and @loaiCt<>0
	begin
		if @tkdu is not null 
		begin		
			set @tkdu = replace(@tkdu,'' '','''')
			set @tkdu='' tkdu like'''''' +replace(@tkdu,'','',''%'''' or tkdu like'''''') + ''%'''''' 
			exec sopstaikhoan @tk, @ngayCt3,@ngayCt4,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
		else exec sopstaikhoan @tk, @ngayCt3,@ngayCt4, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		
		if @loaiCt=3 set @KyTruoc=@psno
		if @loaiCt=4 set @KyTruoc=@psco

		--L?y s? cu?i k?
if @tkdu is not null 
		begin					
			exec sopstaikhoan @tk, @ngayCt1,@ngayCt2,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
else 		exec sopstaikhoan @tk, @ngayCt1,@ngayCt2, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		if @loaiCt=3 set @KyNay=@psno
		if @loaiCt=4 set @KyNay=@psco

		UPDATE t SET [Kỳ trước]=@KyTruoc where Maso=@Maso
		UPDATE t SET [Kỳ này]=@KyNay where Maso=@Maso
		
	end
fetch cur2  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay
end
close cur2
deallocate cur2
update t set [Kỳ trước]=0,[Kỳ này]=0 where loaict=0
select * from t
drop table t

-- Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp
select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh,  fr.CachTinh, fr.LoaiCT, fr.InBaoCao, fr.XuatGiaTriAm
	,999999999999999.000000  as [Kỳ trước]
	,999999999999999.000000 as [Kỳ này]
	into t
	from sysFormReport fr
	where fr.sysReportID = @@sysReportID[2]
	order by Stt

	set @ngayCt1=@@NgayCt1
	set @ngayCt2=dateadd(hh,23,@@NgayCt2)
	set @ngayCt3=DATEADD(year,-1,@ngayCt1)
	set @ngayCt4=DATEADD(year,-1,@ngayCt2)
declare cur3 cursor for select Maso,loaiCt,tk,tkdu,[Kỳ trước],[Kỳ này],XuatGiaTriAm from t
	open cur3



--Tính các ch? tiêu
declare @XuatGiaTriAm int
fetch cur3  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay,@XuatGiaTriAm
while @@fetch_status=0
begin
	--Lay so phat sinh ky truoc
	if @tk is not null and @loaiCt<>0
	begin
		if @tkdu is not null 
		begin		
			set @tkdu = replace(@tkdu,'' '','''')
			set @tkdu='' tkdu like'''''' +replace(@tkdu,'','',''%'''' or tkdu like'''''') + ''%'''''' 
			exec sopstaikhoan @tk, @ngayCt3,@ngayCt4,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
		else exec sopstaikhoan @tk, @ngayCt3,@ngayCt4, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		
		if @loaiCt=3 set @KyTruoc=@psno
		if @loaiCt=4 set @KyTruoc=@psco

		if @loaict = 1 or @loaict = 2
		begin
			declare @ngayCt datetime
			set @ngayCt= dateadd(hh,-1,@ngayCt3)
			exec sodutaikhoan @tk, @ngayCt, DEFAULT, @PSNO OUTPUT , @PSCO OUTPUT 
			if @loaict = 1 set @KyTruoc = @psno
			if @loaict = 2 set @KyTruoc = @psco
		end
		--L?y s? cu?i k?
if @tkdu is not null 
		begin					
			exec sopstaikhoan @tk, @ngayCt1,@ngayCt2,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
else 		exec sopstaikhoan @tk, @ngayCt1,@ngayCt2, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		if @loaiCt=3 set @KyNay=@psno
		if @loaiCt=4 set @KyNay=@psco

		if @loaict = 1 or @loaict = 2
		begin
			set @ngayCt= dateadd(hh,-1,@ngayCt1)
			exec sodutaikhoan @tk, @ngayCt, DEFAULT, @PSNO OUTPUT , @PSCO OUTPUT 
			if @loaict = 1 set @KyNay = @psno
			if @loaict = 2 set @KyNay = @psco
		end
		
		if @XuatGiaTriAm = 1
		BEGIN
			if @KyTruoc > 0
				set @KyTruoc = -@KyTruoc
				
			if @KyNay > 0
				set @KyNay = -@KyNay
		END
		
		UPDATE t SET [Kỳ trước]=@KyTruoc where Maso=@Maso
		UPDATE t SET [Kỳ này]=@KyNay where Maso=@Maso
		
	end
fetch cur3  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay,@XuatGiaTriAm
end
close cur3
deallocate cur3
update t set [Kỳ trước]=0,[Kỳ này]=0 where loaict=0
select * from t
drop table t

'
where sysReportID = @sysReportID

-- Thiết lập các thuộc tính liên quan đến xuất XML
Update sysReport set HasExportXML = 1, XMLTemplate = N'48_01_CDKT_xml', OutputXMLFileNamePattern = '@@NopThueInfor_ThueCuc_ShortName,@@MaSoThue,48_01_CDKT,Y@@NamLamViec,L00',
QueryXML = N'-- Bảng cân đối kế toán
select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh, fr.CachTinh, fr.LoaiCT, fr.InBaoCao,iscn
	,999999999999999.000000  as [DauNam]
	,999999999999999.000000 as [CuoiKy]
	into t
	from sysFormReport fr
	where fr.sysReportID = @@sysReportID[0]
	order by Stt
declare @ngayCt1 datetime
declare @ngayCt2 datetime
	set @ngayCt1=@@NgayCt1
	set @ngayCt2=DATEADD(hh,23,@@NgayCt2)
set @ngayCt1= dateadd(hh,-1,@ngayCt1)
declare cur cursor for select Maso,cachtinh,loaiCt,tk,tkdu,iscn,[DauNam],[CuoiKy] from t
	open cur
declare @Maso nvarchar (50)
declare @Cachtinh nvarchar(256)
declare @LoaiCt int
declare @tk nvarchar (256)
declare @tkdu nvarchar (256)
declare @iscn bit 
declare @daunam decimal(28,6)
declare @cuoiky decimal(28,6)
--Tính các ch? tiêu
declare @duno decimal(28,6)
declare @duco decimal(28,6)
declare @duno1 decimal(28,6)
declare @duco1 decimal(28,6)
fetch cur  into @Maso,@Cachtinh,@LoaiCt,@tk,@tkdu,@iscn,@daunam,@cuoiky
while @@fetch_status=0
begin
	--L?y s? d?u nam
	if @tk is not null and @loaiCt<>0
	begin
		
		exec sodutaikhoan @tk, @ngayCt1, DEFAULT, @duno OUTPUT , @duco OUTPUT 
		if @iscn=1
			begin	
				set @daunam=0
				if @loaiCt=5 set @daunam=@duno
				if @loaiCt=6 set @daunam=@duco
			end
		if @iscn=0
			begin	
				set @duno1= @duno-@duco 
				set @duco1= @duco-@duno 
				set @daunam=0
				if @loaiCt=5 set @daunam=@duno1
				if @loaiCt=6 set @daunam=@duco1
			end
		

		--L?y s? cu?i k?
		exec sodutaikhoan @tk, @ngayCt2, DEFAULT, @duno OUTPUT , @duco OUTPUT
	 	if @iscn=1
			begin	
				set @cuoiky=0
				if @loaiCt=5 set @cuoiky=@duno
				if @loaiCt=6 set @cuoiky=@duco
			end
		if @iscn=0
			begin	
				set @duno1= @duno-@duco 
				set @duco1= @duco-@duno 
					set @cuoiky=0
				if @loaiCt=5 set @cuoiky=@duno1
				if @loaiCt=6 set @cuoiky=@duco1
			end

		UPDATE t SET [DauNam]=@daunam where Maso=@Maso
		UPDATE t SET [CuoiKy]=@cuoiky where Maso=@Maso
		
	end
	fetch cur  into @Maso,@cachtinh, @LoaiCt,@tk,@tkdu,@iscn,@daunam,@cuoiky
end
close cur
deallocate cur
update t set [DauNam]=0,[CuoiKy]=0 where loaict=0
select * from t
drop table t

-- Báo cáo kết quả kinh doanh
select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh, fr.CachTinh, fr.LoaiCT, fr.InBaoCao
	,999999999999999.000000  as [KyTruoc]
	,999999999999999.000000 as [KyNay]
	into t
	from sysFormReport fr
	where fr.sysReportID = @@sysReportID[1]
	order by Stt

declare @ngayCt3 datetime
declare @ngayCt4 datetime
	set @ngayCt1=@@NgayCt1
	set @ngayCt2=DATEADD(hh,23,@@NgayCt2)
	set @ngayCt3=DATEADD(year,-1,@ngayCt1)
	set @ngayCt4=DATEADD(year,-1,@ngayCt2)
declare cur2 cursor for select Maso,loaiCt,tk,tkdu,[KyTruoc],[KyNay] from t
	open cur2



declare @KyTruoc decimal(28,6)
declare @KyNay decimal(28,6)
--Tính các ch? tiêu
declare @psno decimal(28,6)
declare @psco decimal(28,6)
fetch cur2  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay
while @@fetch_status=0
begin
	--Lay so phat sinh ky truoc
	if @tk is not null and @loaiCt<>0
	begin
		if @tkdu is not null 
		begin		
			set @tkdu = replace(@tkdu,'' '','''')
			set @tkdu='' tkdu like'''''' +replace(@tkdu,'','',''%'''' or tkdu like'''''') + ''%'''''' 
			exec sopstaikhoan @tk, @ngayCt3,@ngayCt4,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
		else exec sopstaikhoan @tk, @ngayCt3,@ngayCt4, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		
		if @loaiCt=3 set @KyTruoc=@psno
		if @loaiCt=4 set @KyTruoc=@psco

		--L?y s? cu?i k?
if @tkdu is not null 
		begin					
			exec sopstaikhoan @tk, @ngayCt1,@ngayCt2,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
else 		exec sopstaikhoan @tk, @ngayCt1,@ngayCt2, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		if @loaiCt=3 set @KyNay=@psno
		if @loaiCt=4 set @KyNay=@psco

		UPDATE t SET [KyTruoc]=@KyTruoc where Maso=@Maso
		UPDATE t SET [KyNay]=@KyNay where Maso=@Maso
		
	end
fetch cur2  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay
end
close cur2
deallocate cur2
update t set [KyTruoc]=0,[KyNay]=0 where loaict=0
select * from t
drop table t

-- Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp
select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh,  fr.CachTinh, fr.LoaiCT, fr.InBaoCao, fr.XuatGiaTriAm
	,999999999999999.000000  as [KyTruoc]
	,999999999999999.000000 as [KyNay]
	into t
	from sysFormReport fr
	where fr.sysReportID = @@sysReportID[2]
	order by Stt

	set @ngayCt1=@@NgayCt1
	set @ngayCt2=dateadd(hh,23,@@NgayCt2)
	set @ngayCt3=DATEADD(year,-1,@ngayCt1)
	set @ngayCt4=DATEADD(year,-1,@ngayCt2)
declare cur3 cursor for select Maso,loaiCt,tk,tkdu,[KyTruoc],[KyNay],XuatGiaTriAm from t
	open cur3



--Tính các ch? tiêu
declare @XuatGiaTriAm int
fetch cur3  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay,@XuatGiaTriAm
while @@fetch_status=0
begin
	--Lay so phat sinh ky truoc
	if @tk is not null and @loaiCt<>0
	begin
		if @tkdu is not null 
		begin		
			set @tkdu = replace(@tkdu,'' '','''')
			set @tkdu='' tkdu like'''''' +replace(@tkdu,'','',''%'''' or tkdu like'''''') + ''%'''''' 
			exec sopstaikhoan @tk, @ngayCt3,@ngayCt4,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
		else exec sopstaikhoan @tk, @ngayCt3,@ngayCt4, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		
		if @loaiCt=3 set @KyTruoc=@psno
		if @loaiCt=4 set @KyTruoc=@psco

		if @loaict = 1 or @loaict = 2
		begin
			declare @ngayCt datetime
			set @ngayCt= dateadd(hh,-1,@ngayCt3)
			exec sodutaikhoan @tk, @ngayCt, DEFAULT, @PSNO OUTPUT , @PSCO OUTPUT 
			if @loaict = 1 set @KyTruoc = @psno
			if @loaict = 2 set @KyTruoc = @psco
		end
		--L?y s? cu?i k?
if @tkdu is not null 
		begin					
			exec sopstaikhoan @tk, @ngayCt1,@ngayCt2,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
else 		exec sopstaikhoan @tk, @ngayCt1,@ngayCt2, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		if @loaiCt=3 set @KyNay=@psno
		if @loaiCt=4 set @KyNay=@psco

		if @loaict = 1 or @loaict = 2
		begin
			set @ngayCt= dateadd(hh,-1,@ngayCt1)
			exec sodutaikhoan @tk, @ngayCt, DEFAULT, @PSNO OUTPUT , @PSCO OUTPUT 
			if @loaict = 1 set @KyNay = @psno
			if @loaict = 2 set @KyNay = @psco
		end
		
		if @XuatGiaTriAm = 1
		BEGIN
			if @KyTruoc > 0
				set @KyTruoc = -@KyTruoc
				
			if @KyNay > 0
				set @KyNay = -@KyNay
		END
		
		UPDATE t SET [KyTruoc]=@KyTruoc where Maso=@Maso
		UPDATE t SET [KyNay]=@KyNay where Maso=@Maso
		
	end
fetch cur3  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay,@XuatGiaTriAm
end
close cur3
deallocate cur3
update t set [KyTruoc]=0,[KyNay]=0 where loaict=0
select * from t
drop table t'
where sysReportID = @sysReportID

-- Step 2: Tham số báo cáo
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'NgayCT'
AND sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, NULL, @sysReportID, 1, 0, 1, 0, 1, NULL)


-- BCTC_ViewAttachedReport1
select @sysTableID = sysTableID from sysTable
where TableName = 'wFilterControl'

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'BCTC_ViewAttachedReport1'
				and sysTableID = @sysTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, 1, @sysReportID, 0, 1, 1, 0, 1, NULL)

-- BCTC_ViewAttachedReport2
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'BCTC_ViewAttachedReport2'
				and sysTableID = @sysTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, 1, @sysReportID, 0, 2, 1, 0, 1, NULL)

-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Lập báo cáo tài chính (QĐ 48/2006-BTC)', N'BCDKTOAN;BCKQHDKDOANH;BCLCTTPPTTIEP', N'Financial reporting', NULL)

-- Step 4: Tạo menu
-- PRO
if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Tổng hợp' and sysSiteID = @sysSiteIDPRO and sysMenuParent is null

if (isnull(@sysMenuParent,'') <> '')
BEGIN

if not exists (select top 1 1 from sysMenu where MenuName = N'Lập báo cáo tài chính (QĐ 48/2006-BTC)' and [sysSiteID] = @sysSiteIDPRO and [sysMenuParent] = @sysMenuParent)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image], VisibleCondition) 
VALUES (N'Lập báo cáo tài chính (QĐ 48/2006-BTC)', N'Financial reporting (Decission No: 48/2006/QĐ-BTC)', @sysSiteIDPRO, NULL, NULL, @sysReportID, 11, NULL, @sysMenuParent, NULL, NULL, 4, NULL, N'@QuyetDinh==15')
END

END

-- STD
if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Tổng hợp' and sysSiteID = @sysSiteIDSTD and sysMenuParent is null

if (isnull(@sysMenuParent,'') <> '')
BEGIN

if not exists (select top 1 1 from sysMenu where MenuName = N'Lập báo cáo tài chính (QĐ 48/2006-BTC)' and [sysSiteID] = @sysSiteIDSTD and [sysMenuParent] = @sysMenuParent)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image], VisibleCondition) 
VALUES (N'Lập báo cáo tài chính (QĐ 48/2006-BTC)', N'Financial reporting (Decission No: 48/2006/QĐ-BTC)', @sysSiteIDSTD, NULL, NULL, @sysReportID, 11, NULL, @sysMenuParent, NULL, NULL, 4, NULL, N'@QuyetDinh==15')
END

END