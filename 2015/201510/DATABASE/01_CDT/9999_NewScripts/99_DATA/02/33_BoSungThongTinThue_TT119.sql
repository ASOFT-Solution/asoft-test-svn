USE [CDT]

declare @sysTableID int,
		@Key varchar(128),
		@SortOrder int

select @sysTableID = sysTableID from sysTable
where TableName = 'sysConfig'

-- 1) Add column IsDaiLyThue
if not exists (select top 1 1 from sysField where FieldName = N'IsDaiLyThue' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 10, N'IsDaiLyThue', N'Thông tin đại lý thuế', N'Thông tin đại lý thuế', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- 2) Add column IsNopThueInfor
if not exists (select top 1 1 from sysField where FieldName = N'IsNopThueInfor' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 10, N'IsNopThueInfor', N'Là thông tin người nộp thuế', N'Là thông tin người nộp thuế', 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- 3) Update data IsDaiLyThue, IsNopThueInfor
declare @sysSiteIDPRO as int
declare @sysSiteIDSTD as int
declare @DbName as varchar(50)
declare @sysSiteID as int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

declare curDbName CURSOR FOR
select DbName, sysSiteID from sysDatabase where DbName <> 'CDT'

open curDbName 
fetch curDbName into @DbName, @sysSiteID

while @@FETCH_STATUS = 0
BEGIN

-- PRO
if isnull(@sysSiteIDPRO,'') <> '' AND @sysSiteID = @sysSiteIDPRO
BEGIN
	Update sysConfig set IsDaiLyThue = 1 where _Key IN ('TenDaiLyThue','MSTDLThue', 'DienThoaiDL', 'EmailDL', 'FaxDL', 'AddressTA', 'QuanHuyenDL', 'TinhThanhDL', 'HDDLThueSo', 'NgayHDDL', 'NVDLThue', 'CCHNThue') and IsUser = 1 and [sysSiteID] = @sysSiteIDPRO and [DbName] = @DbName and IsDaiLyThue is null

	-- Xoa data thua
	delete from sysConfig
	where _Key IN (N'NopThueInfor_NganhNgheKD', N'NopThueInfor_NgayBDNamTC',N'NopThueInfor_NguoiKyToKhai',N'NopThueInfor_ThueCuc',N'NopThueInfor_ThueCuc_ShortName',N'NopThueInfor_ThueQuanLy',N'NopThueInfor_ThueQuanLy_Ten',N'NopThueInfor_DVChuQuan', N'NopThueInfor_MSTChuQuan')
	and sysSiteID = @sysSiteIDPRO and DbName = @DbName and IsNopThueInfor is NULL

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_NganhNgheKD' and sysSiteID = @sysSiteIDPRO and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_NganhNgheKD', N'', 1, @sysSiteIDPRO, 0, N'Ngành nghề kinh doanh', N'Ngành nghề kinh doanh', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_NgayBDNamTC' and sysSiteID = @sysSiteIDPRO and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_NgayBDNamTC', N'', 1, @sysSiteIDPRO, 0, N'Ngày bắt đầu năm tài chính', N'Ngày bắt đầu năm tài chính', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_NguoiKyToKhai' and sysSiteID = @sysSiteIDPRO and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_NguoiKyToKhai', N'', 1, @sysSiteIDPRO, 0, N'Người ký tờ khai', N'Người ký tờ khai', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_ThueCuc' and sysSiteID = @sysSiteIDPRO and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_ThueCuc', N'', 1, @sysSiteIDPRO, 0, N'Cơ quan thuế cấp Cục', N'Cơ quan thuế cấp Cục', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_ThueCuc_ShortName' and sysSiteID = @sysSiteIDPRO and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_ThueCuc_ShortName', N'', 1, @sysSiteIDPRO, 0, N'Tên viết tắt cơ quan thuế cấp Cục', N'Tên viết tắt cơ quan thuế cấp Cục', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_ThueQuanLy' and sysSiteID = @sysSiteIDPRO and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_ThueQuanLy', N'', 1, @sysSiteIDPRO, 0, N'Cơ quan thuế quản lý', N'Cơ quan thuế quản lý', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_ThueQuanLy_Ten' and sysSiteID = @sysSiteIDPRO and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_ThueQuanLy_Ten', N'', 1, @sysSiteIDPRO, 0, N'Tên cơ quan thuế quản lý', N'Tên cơ quan thuế quản lý', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_DVChuQuan' and sysSiteID = @sysSiteIDPRO and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_DVChuQuan', N'', 1, @sysSiteIDPRO, 0, N'Đơn vị chủ quản', N'Đơn vị chủ quản', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_MSTChuQuan' and sysSiteID = @sysSiteIDPRO and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_MSTChuQuan', N'', 1, @sysSiteIDPRO, 0, N'Mã số thuế đơn vị chủ quản', N'Mã số thuế đơn vị chủ quản', @DbName, 1)
END

-- STD
if isnull(@sysSiteIDSTD,'') <> '' AND @sysSiteID = @sysSiteIDSTD
BEGIN
	Update sysConfig set IsDaiLyThue = 1 where _Key IN ('TenDaiLyThue','MSTDLThue', 'DienThoaiDL', 'EmailDL', 'FaxDL', 'AddressTA', 'QuanHuyenDL', 'TinhThanhDL', 'HDDLThueSo', 'NgayHDDL', 'NVDLThue', 'CCHNThue') and IsUser = 1 and [sysSiteID] = @sysSiteIDSTD and [DbName] = @DbName and IsDaiLyThue is null

	-- Xoa data thua
	delete from sysConfig
	where _Key IN (N'NopThueInfor_NganhNgheKD', N'NopThueInfor_NgayBDNamTC',N'NopThueInfor_NguoiKyToKhai',N'NopThueInfor_ThueCuc',N'NopThueInfor_ThueCuc_ShortName',N'NopThueInfor_ThueQuanLy',N'NopThueInfor_ThueQuanLy_Ten',N'NopThueInfor_DVChuQuan', N'NopThueInfor_MSTChuQuan')
	and sysSiteID = @sysSiteIDSTD and DbName = @DbName and IsNopThueInfor is NULL

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_NganhNgheKD' and sysSiteID = @sysSiteIDSTD and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_NganhNgheKD', N'', 1, @sysSiteIDSTD, 0, N'Ngành nghề kinh doanh', N'Ngành nghề kinh doanh', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_NgayBDNamTC' and sysSiteID = @sysSiteIDSTD and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_NgayBDNamTC', N'', 1, @sysSiteIDSTD, 0, N'Ngày bắt đầu năm tài chính', N'Ngày bắt đầu năm tài chính', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_NguoiKyToKhai' and sysSiteID = @sysSiteIDSTD and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_NguoiKyToKhai', N'', 1, @sysSiteIDSTD, 0, N'Người ký tờ khai', N'Người ký tờ khai', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_ThueCuc' and sysSiteID = @sysSiteIDSTD and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_ThueCuc', N'', 1, @sysSiteIDSTD, 0, N'Cơ quan thuế cấp Cục', N'Cơ quan thuế cấp Cục', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_ThueCuc_ShortName' and sysSiteID = @sysSiteIDSTD and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_ThueCuc_ShortName', N'', 1, @sysSiteIDSTD, 0, N'Tên viết tắt cơ quan thuế cấp Cục', N'Tên viết tắt cơ quan thuế cấp Cục', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_ThueQuanLy' and sysSiteID = @sysSiteIDSTD and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_ThueQuanLy', N'', 1, @sysSiteIDSTD, 0, N'Cơ quan thuế quản lý', N'Cơ quan thuế quản lý', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_ThueQuanLy_Ten' and sysSiteID = @sysSiteIDSTD and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_ThueQuanLy_Ten', N'', 1, @sysSiteIDSTD, 0, N'Tên cơ quan thuế quản lý', N'Tên cơ quan thuế quản lý', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_DVChuQuan' and sysSiteID = @sysSiteIDSTD and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_DVChuQuan', N'', 1, @sysSiteIDSTD, 0, N'Đơn vị chủ quản', N'Đơn vị chủ quản', @DbName, 1)

	if not exists (select top 1 1 from sysConfig where _Key = N'NopThueInfor_MSTChuQuan' and sysSiteID = @sysSiteIDSTD and DbName = @DbName and IsNopThueInfor = 1)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], IsNopThueInfor) 
	VALUES (N'NopThueInfor_MSTChuQuan', N'', 1, @sysSiteIDSTD, 0, N'Mã số thuế đơn vị chủ quản', N'Mã số thuế đơn vị chủ quản', @DbName, 1)
END

fetch curDbName into @DbName, @sysSiteID
END

close curDbName
deallocate curDbName