use CDT
IF NOT EXISTS(Select * From sysReport Where ReportName = N'Chi tiết công nợ phải thu theo nhân viên')
Begin

declare @mtTableID int
Select @mtTableID = sysTableID FROM sysTable WHERE TableName = 'BLTK'

INSERT INTO [CDT].[dbo].[sysReport]
           ([ReportName],[RpType],[mtTableID],[dtTableID],[Query],[ReportFile],[ReportName2],[ReportFile2],[sysReportParentID],[LinkField],[ColField],[ChartField1],[ChartField2] ,[ChartField3],[sysPackageID],[mtAlias],[dtAlias],[TreeData],[LinkTableAlias])
VALUES
           (N'Chi tiết công nợ phải thu theo nhân viên'
           ,0
           ,@mtTableID
           ,null
           ,'declare @tkrp nvarchar(16),
		@FromSaleman varchar(16),
		@ToSaleman varchar(16),
		@MaKH varchar(16),
		@Saleman varchar(16),
		@TK varchar(16),
		@psno decimal(28,6),
		@psnont decimal(28,6),
		@psco decimal(28,6),
		@pscont decimal(28,6),
		@ton decimal(28,6),
		@tonnt decimal(28,6),
		@stt int, 
		@stt2 int,
		@tungayCt datetime,
		@denngayCt datetime,
		@MaNT varchar(16),
	    @MaPhi varchar(16),
	    @MaBP varchar(16),
	    @MaVV varchar(16),
	    @MaCongTrinh varchar(16) ,
	    @MaSP varchar(16),
	    @Diengiai nvarchar(50)
set @tuNgayCt=@@ngayct1
set @denNgayCt=dateadd(hh,23,@@ngayct2)
set @tkrp=@@TK
set @FromSaleman = @@Saleman1
set @ToSaleman = @@Saleman2
--Duyệt con trỏ 1 lấy danh sách nhân viên
declare cur1 cursor for 
Select MaKH as Saleman from DMKH where isNV = 1 and (MaKH between @FromSaleman and @ToSaleman)
--Tạo bảng #t để lấy kết quả trả về
 create table #t
  (
   [bltkID] [int]   NULL ,
   [MaKH] varchar(16) null,
   [Saleman] varchar(16) null,
   [psno] decimal(28, 6) NULL ,
   [psco] decimal(28, 6) NULL ,
   [psnoNt] decimal(28, 6) NULL ,
   [pscoNt] decimal(28, 6) NULL ,
   [ton] decimal(28, 6) NULL,
   [tonNt] decimal(28, 6) NULL, 
   [STT] int null,
   [STT2] int null,
   MaNT varchar(16) null,
   MaPhi varchar(16) null,
   MaBP varchar(16) null,
   MaVV varchar(16) null,
   MaCongTrinh varchar(16) null,
   MaSP varchar(16) null
  ) ON [PRIMARY]

  insert into #t([bltkID],
   [MaKH],
   [Saleman],
   [psno],
   [psco],
   [psnoNt],
   [pscoNt],
   [ton],
   [tonNt], 
   [STT],
   [STT2],
   [MaNT],
   MaPhi,
   MaBP,
   MaVV,
   MaCongTrinh,
   MaSP
   )
  SELECT min(bltkID), MaKH, Saleman, sum(PsNo), sum(PsCo),sum(case when TyGia = 1 then 0 else PsNoNt end) as psnoNt, sum(case when TyGia = 1 then 0 else PsCoNt end) as pscoNt,0.0 as toncuoi,0.0 as toncuoint,
  case when sum(PsNo) != 0 then 1 else 2 end as STT, 1 as STT2, b.MaNT, b.MaPhi, b.MaBP, b.MaVV, b.MaCongTrinh, b.MaSP
  FROM  BLTK b
  where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and (Saleman between @FromSaleman and @ToSaleman) and @@ps
  group by MTID, Saleman, MaKH, NgayCT,SoCT, b.MaNT, b.MaPhi, b.MaBP, b.MaVV, b.MaCongTrinh, b.MaSP
  order by NgayCT,STT, SoCT, Saleman, MaKH
  
open cur1
fetch next from cur1  into @Saleman
while @@fetch_status=0
begin
  declare @dauky1 decimal(28, 6), 
		  @dauky2 decimal(28, 6), 
		  @dauky decimal(28, 6),
		  @dauky1NT decimal(28, 6), 
		  @dauky2NT decimal(28, 6), 
		  @daukyNT decimal(28, 6)
  --Duyệt con trỏ 2 để lấy khách hàng theo nhân viên
  declare cur2 cursor for 
  SELECT MaKH, b.MaNT, b.MaPhi, b.MaBP, b.MaVV, b.MaCongTrinh FROM  BLTK b
  where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and Saleman = @Saleman and @@ps 
  group by Saleman, MaKH, b.MaNT, b.MaPhi, b.MaBP, b.MaVV, b.MaCongTrinh
  union 
  SELECT MaKH, b.MaNT, b.MaPhi, b.MaBP, b.MaVV, b.MaCongTrinh from obkh b where  left(tk,len(@tkrp))=@tkrp  and Saleman =@Saleman and @@ps
  group by Saleman, MaKH, b.MaNT, b.MaPhi, b.MaBP, b.MaVV, b.MaCongTrinh
  
  open cur2
  fetch next from cur2  into @MaKH, @MaNT, @MaPhi, @MaBP, @MaVV, @MaCongTrinh
  while @@fetch_status=0
  begin
	set @dauky1 = 0
	set @dauky2 = 0
	set @dauky= 0
	set @daukyNT= 0
   SELECT @dauky1 = sum(Duno-Duco), @dauky1NT = sum(Dunont-Ducont) from obkh b where  left(tk,len(@tkrp))=@tkrp  and Saleman =@Saleman and MaKH = @MaKH and @@ps group by Saleman, MaKH, b.MaNT, b.MaPhi, b.MaBP, b.MaVV, b.MaCongTrinh
   select @dauky2 = sum(psNo)-sum(Psco), @dauky2NT = sum(psNont)-sum(Pscont) from bltk b where left(tk,len(@tkrp))=@tkrp and ngayCt<@tuNgayCt and Saleman =@Saleman and MaKH = @MaKH and @@ps group by Saleman, MaKH, b.MaNT, b.MaPhi, b.MaBP, b.MaVV, b.MaCongTrinh
   set @dauky=(case when @dauky1!=0 then @dauky1 else 0 end)  + (case when @dauky2!=0 then @dauky2 else 0 end) 
   set @daukyNT=(case when @dauky1NT!=0 then @dauky1NT else 0 end)  + (case when @dauky2NT!=0 then @dauky2NT else 0 end) 
   --Duyệt con trỏ 3 để tính toán số dư
   declare @bltkid int
   declare cur3 cursor for Select bltkid,makh, Saleman, psno, psco, psnont, pscont, stt, stt2 from #t b where Saleman =@Saleman and MaKH = @MaKH and @@ps order by Saleman,b.makh,stt2, stt
   declare @tmp decimal(28,6),@tmpnt decimal(28,6)
   set @tmp=@dauky
   set @tmpnt = @daukyNT
   open cur3
   fetch next from cur3  into @bltkid, @MaKH, @Saleman, @psno, @psco, @psnont, @pscont, @stt, @stt2
   while @@fetch_status=0
   begin
    set @ton=@tmp+@psno-@psco
    set @tmp=@ton
    set @tonnt=@tmpnt+@psnont-@pscont
    set @tmpnt=@tonnt
    UPDATE #t SET ton=@ton,tonnt=@tonnt where bltkid=@bltkid
    fetch next from cur3  into @bltkid, @MaKh, @Saleman, @Psno, @psco, @psnont, @pscont, @stt, @stt2
   end
   close cur3
   deallocate cur3
   --Insert số dư ban đầu vào bảng #t
   insert into #t([bltkID],
   [MaKH],
   [Saleman],
   [psno],
   [psco],
   [psnoNt],
   [pscoNt],
   [ton],
   [tonNt], 
   [STT],
   [STT2],
   [MaNT],
   MaPhi,
   MaBP,
   MaVV,
   MaCongTrinh,
   MaSP
   )
   select 0,@MaKH, @Saleman,NULL,NULL,NULL,NULL,@dauky,@daukyNT,0,0,@MaNT,@MaPhi,@MaBP,@MaVV,@MaCongTrinh,@MaSP
  fetch next from cur2  into @MaKH, @MaNT, @MaPhi, @MaBP, @MaVV, @MaCongTrinh
  end
  close cur2
  deallocate cur2
  
  fetch next from cur1  into @Saleman
end
close cur1
deallocate cur1

if @@lang = 1 
set @Diengiai = N"Beginning amount"
else
set @Diengiai = NSố dư đầu kỳ"

	select b.NgayCT, b.SoCT, case when b.stt = 0 then @Diengiai else b.Diengiai end as Diengiai,b.TK, b.TKdu,b.Psno,b.Psco,b.Ton,b.PsnoNT,b.PscoNT,b.TonNT ,
    b.MaNT, b.MaKH, b.TenKH, b.Saleman, b.TenNhanVien, b.MaPhi, b.MaBP, b.MaVV, b.MaCongTrinh, b.MaSP, b.stt, b.stt2 from (
  select b.NgayCT, b.SoCT, b.Diengiai,b.TK, b.TKdu,t.Psno,t.Psco,t.Ton,t.PsnoNT,t.PscoNT,t.TonNT ,
    t.MaNT, t.MaKH,kh.TenKH, t.Saleman,nv.Tenkh as TenNhanVien,t.MaPhi,t.MaBP,t.MaVV,t.MaCongTrinh,b.MaSP, t.stt, t.stt2
  from #t t left join dmkh kh on t.MaKH = kh.MaKH left join dmkh nv on t.Saleman = nv.makh left join bltk b on t.bltkid = b.bltkid
  )b
  where @@ps
  order by b.saleman,b.makh, b.stt2, b.stt
drop table #t'
           ,'ChiTietCongNoPTNV'
           ,'Details of receivables by staff'
           ,null
           ,null
           ,null
           ,null
           ,null
           ,null
           ,null
           ,8
           ,null
           ,null
           ,null
           ,null)

declare @sysReportID int
Select @sysReportID = sysReportID FROM sysReport WHERE ReportName = N'Chi tiết công nợ phải thu theo nhân viên'

--Thêm điều kiện báo cáo field ngày chứng từ
declare @FieldNgayCT int 
Select @FieldNgayCT = sysFieldID FROM sysField WHERE FieldName = 'NgayCT' and sysTableID = @mtTableID
IF NOT EXISTS(Select * From sysReportFilter Where sysReportID = @sysReportID and sysFieldID = @FieldNgayCT)
	INSERT INTO [CDT].[dbo].[sysReportFilter]
           ([sysFieldID],[AllowNull],[DefaultValue],[sysReportID],[IsBetween],[TabIndex],[Visible],[IsMaster],[SpecialCond],[FilterCond])
     VALUES(@FieldNgayCT,0,null,@sysReportID,1,0,1,1,1,null)

--Thêm điều kiện báo cáo field tài khoản
declare @FieldTK int
Select @FieldTK = sysFieldID FROM sysField WHERE FieldName = 'TK' and sysTableID = @mtTableID
IF NOT EXISTS(Select * From sysReportFilter Where sysReportID = @sysReportID and sysFieldID = @FieldTK)
	INSERT INTO [CDT].[dbo].[sysReportFilter]
           ([sysFieldID],[AllowNull],[DefaultValue],[sysReportID],[IsBetween],[TabIndex],[Visible],[IsMaster],[SpecialCond],[FilterCond])
     VALUES(@FieldTK,0,null,@sysReportID,0,1,1,1,1,'TKCongNo = 1')

--Thêm điều kiện báo cáo field nhân viên
declare @FieldSaleMan int
Select @FieldSaleMan = sysFieldID FROM sysField WHERE FieldName = 'Saleman' and sysTableID = @mtTableID
IF NOT EXISTS(Select * From sysReportFilter Where sysReportID = @sysReportID and sysFieldID = @FieldSaleMan)
	INSERT INTO [CDT].[dbo].[sysReportFilter]
           ([sysFieldID],[AllowNull],[DefaultValue],[sysReportID],[IsBetween],[TabIndex],[Visible],[IsMaster],[SpecialCond],[FilterCond])
     VALUES(@FieldSaleMan,0,null,@sysReportID,1,2,1,1,1,'isNV = 1')


--Thêm điều kiện báo cáo field đối tượng
declare @FieldMaKH int
Select @FieldMaKH = sysFieldID FROM sysField WHERE FieldName = 'MaKH' and sysTableID = @mtTableID
IF NOT EXISTS(Select * From sysReportFilter Where sysReportID = @sysReportID and sysFieldID = @FieldMaKH)
	INSERT INTO [CDT].[dbo].[sysReportFilter]
           ([sysFieldID],[AllowNull],[DefaultValue],[sysReportID],[IsBetween],[TabIndex],[Visible],[IsMaster],[SpecialCond],[FilterCond])
     VALUES(@FieldMaKH,1,null,@sysReportID,1,3,1,0,0,'isKH = 1')


--Thêm điều kiện báo cáo field nguyên tệ
declare @FieldMaNT int
Select @FieldMaNT = sysFieldID FROM sysField WHERE FieldName = 'MaNT' and sysTableID = @mtTableID
IF NOT EXISTS(Select * From sysReportFilter Where sysReportID = @sysReportID and sysFieldID = @FieldMaNT)
	INSERT INTO [CDT].[dbo].[sysReportFilter]
           ([sysFieldID],[AllowNull],[DefaultValue],[sysReportID],[IsBetween],[TabIndex],[Visible],[IsMaster],[SpecialCond],[FilterCond])
     VALUES(@FieldMaNT,1,null,@sysReportID,0,4,1,0,0,null)


--Thêm điều kiện báo cáo field mã phí
declare @FieldMaPhi int
Select @FieldMaPhi = sysFieldID FROM sysField WHERE FieldName = 'MaPhi' and sysTableID = @mtTableID
IF NOT EXISTS(Select * From sysReportFilter Where sysReportID = @sysReportID and sysFieldID = @FieldMaPhi)
	INSERT INTO [CDT].[dbo].[sysReportFilter]
           ([sysFieldID],[AllowNull],[DefaultValue],[sysReportID],[IsBetween],[TabIndex],[Visible],[IsMaster],[SpecialCond],[FilterCond])
     VALUES(@FieldMaPhi,1,null,@sysReportID,0,5,1,0,0,null)


--Thêm điều kiện báo cáo field mã vụ việc
declare @FieldMaVV int
Select @FieldMaVV = sysFieldID FROM sysField WHERE FieldName = 'MaVV' and sysTableID = @mtTableID
IF NOT EXISTS(Select * From sysReportFilter Where sysReportID = @sysReportID and sysFieldID = @FieldMaVV)
	INSERT INTO [CDT].[dbo].[sysReportFilter]
           ([sysFieldID],[AllowNull],[DefaultValue],[sysReportID],[IsBetween],[TabIndex],[Visible],[IsMaster],[SpecialCond],[FilterCond])
     VALUES(@FieldMaVV,1,null,@sysReportID,0,6,1,0,0,null)


--Thêm điều kiện báo cáo field mã bộ phận
declare @FieldMaBP int
Select @FieldMaBP = sysFieldID FROM sysField WHERE FieldName = 'MaBP' and sysTableID = @mtTableID
IF NOT EXISTS(Select * From sysReportFilter Where sysReportID = @sysReportID and sysFieldID = @FieldMaBP)
	INSERT INTO [CDT].[dbo].[sysReportFilter]
           ([sysFieldID],[AllowNull],[DefaultValue],[sysReportID],[IsBetween],[TabIndex],[Visible],[IsMaster],[SpecialCond],[FilterCond])
     VALUES(@FieldMaBP,1,null,@sysReportID,0,7,1,0,0,null)


--Thêm điều kiện báo cáo field mã công trình
declare @FieldMaCongTrinh int
Select @FieldMaCongTrinh = sysFieldID FROM sysField WHERE FieldName = 'MaCongTrinh' and sysTableID = @mtTableID
IF NOT EXISTS(Select * From sysReportFilter Where sysReportID = @sysReportID and sysFieldID = @FieldMaCongTrinh)
	INSERT INTO [CDT].[dbo].[sysReportFilter]
           ([sysFieldID],[AllowNull],[DefaultValue],[sysReportID],[IsBetween],[TabIndex],[Visible],[IsMaster],[SpecialCond],[FilterCond])
     VALUES(@FieldMaCongTrinh,1,null,@sysReportID,0,8,1,0,0,null)


--Thêm vào sysFormReport
IF NOT EXISTS(Select * From sysFormReport Where sysReportID = @sysReportID)
INSERT INTO [CDT].[dbo].[sysFormReport]
           ([sysReportID],[ReportName],[ReportFile],[ReportName2],[ReportFile2])
     VALUES(@sysReportID,N'Chi tiết công nợ phải thu theo nhân viên','ChiTietCongNoPTNV','Details of receivables by staff',null)

--Thêm vào menu báo cáo
declare @MenuCongNoPhaiThu int
Select @MenuCongNoPhaiThu = sysMenuID FROM sysMenu WHERE MenuName = N'Công nợ phải thu'

declare @sysMenuParent int
Select @sysMenuParent = sysMenuID FROM sysMenu WHERE MenuName = N'Báo cáo' and sysMenuParent = @MenuCongNoPhaiThu

--Tạo con trỏ duyệt qua các phiên bản trong sysSite
declare @sysSiteID int
declare cur1 cursor for
Select sysSiteID from sysSite where sysSiteID <> 1
open cur1
fetch next from cur1  into @sysSiteID
while @@fetch_status=0
begin
	IF NOT EXISTS(Select * From sysMenu Where MenuName = N'Chi tiết công nợ phải thu theo nhân viên' and sysSiteID = @sysSiteID )
		Insert into sysMenu(MenuName, MenuName2, sysSiteID, CustomType, sysTableID, sysReportID, MenuOrder, ExtraSql, sysMenuParent, MenuPluginID, PluginName, UIType, Image, ListType, ListTypeOrder)
			Values(N'Chi tiết công nợ phải thu theo nhân viên', 'Details of receivables by staff', @sysSiteID, null, null, @sysReportID, 0, null, @sysMenuParent, null, null, 5, null, null, null)
	fetch next from cur1  into @sysSiteID
end
close cur1
deallocate cur1
end

