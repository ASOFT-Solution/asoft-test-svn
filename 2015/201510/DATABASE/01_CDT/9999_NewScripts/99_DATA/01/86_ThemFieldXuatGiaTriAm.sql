USE [CDT]

declare @sysTableID int

-- 1) Thêm field table sysFormReport
select @sysTableID = sysTableID from sysTable where TableName = 'sysFormReport' and Type = 2 and sysPackageID = 8 and CollectType = 3

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'XuatGiaTriAm')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'XuatGiaTriAm', 1, NULL, NULL, NULL, NULL, 10, N'Xuất giá trị âm', N'Negative value', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- 2) Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp
Update sysReport set Query=N'select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh,  fr.CachTinh, fr.LoaiCT, fr.InBaoCao, fr.XuatGiaTriAm
	,999999999999999.000000  as [Kỳ trước]
	,999999999999999.000000 as [Kỳ này]
	into t
	from sysFormReport fr
	where fr.sysReportID = @@sysReportID
	order by Stt

declare @ngayCt1 datetime
declare @ngayCt2 datetime
declare @ngayCt3 datetime
declare @ngayCt4 datetime
	set @ngayCt1=@@NgayCt1--''03/01/2008''
	--set @ngayCt1= dateadd(day,-1,@ngayCt1)
	set @ngayCt2=dateadd(hh,23,@@NgayCt2)
	set @ngayCt3=@@Ngaydktruoc1--''01/01/2008''
	--set @ngayCt3= dateadd(day,-1,@ngayCt3)
	set @ngayCt4=dateadd(hh,23,@@Ngaydktruoc2)
declare cur cursor for select Maso,loaiCt,tk,tkdu,[Kỳ trước],[Kỳ này],XuatGiaTriAm from t
	open cur
declare @Maso nvarchar (50)
declare @LoaiCt int
declare @tk nvarchar (1000)
declare @tkdu nvarchar (1000)
declare @KyTruoc decimal(28,6)
declare @KyNay decimal(28,6)
--Tính các ch? tiêu
declare @psno decimal(28,6)
declare @psco decimal(28,6)
declare @XuatGiaTriAm int
fetch cur  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay,@XuatGiaTriAm
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
fetch cur  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay,@XuatGiaTriAm
end
close cur
deallocate cur
update t set [Kỳ trước]=0,[Kỳ này]=0 where loaict=0
select * from t
drop table t
--update t set daunam=0.1'
where ReportName=N'Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp'