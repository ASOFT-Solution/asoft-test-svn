USE [CDT]
declare @sysTableID int,
		@sysSiteIDPRO int,
		@sysSiteIDSTD int,
		@sysMenuParent int,
		@formatDonGia nvarchar(128)

set @formatDonGia = dbo.GetFormatString('DonGia')
		
select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = 'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = 'STD'

--1) Them table DMChinhSachGia
if not exists (select top 1 1 from sysTable where TableName = 'DMChinhSachGia')
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) 
VALUES (N'DMChinhSachGia', N'Danh mục chính sách giá', N'List of price policies', N'Stt', NULL, N'DMKH', 4, NULL, NULL, 0, NULL, 8, NULL, 0)

select @sysTableID = sysTableID from sysTable where TableName = 'DMChinhSachGia'

if not exists (select top 1 1 from sysField where FieldName = 'Stt' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'Stt', 0, NULL, NULL, NULL, NULL, 3, N'Stt', N'No.', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MaVT' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaVT', 0, N'MaVT', N'DMVT', N'TenVT', N'LoaiVt <> 6', 1, N'Mã vật tư', N'Material', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 1, N'FK_DMChinhSachGia_DMVT', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MaDVT' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaDVT', 0, N'MaDVT', N'wDMDVTQD', NULL, NULL, 1, N'Đơn vị tính', N'Unit', 2, NULL, N'MaVT.MaDVT', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_DMChinhSachGia_DMDVT', NULL, NULL, 0, N'MaVT=@MaVT')

if not exists (select top 1 1 from sysField where FieldName = 'Gia' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'Gia', 1, NULL, NULL, NULL, NULL, 8, N'Đơn giá', N'Price', 3, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DMChinhSachGia_Gia', @formatDonGia, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MaKH' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaKH', 0, N'MaKH', N'DMKH', N'TenKH', N'IsKH = 1', 1, N'Mã khách hàng', N'Customer', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, N'FK_DMChinhSachGia_DMKH', NULL, NULL, 0, NULL)

--2) Thêm Menu
if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

-- Site PRO
select @sysMenuParent = sysMenuID 
from sysMenu 
where  MenuName = N'Bán hàng' and sysSiteID = @sysSiteIDPRO

if isnull(@sysMenuParent,'') <> ''
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Thiết lập bảng giá' and sysSiteID = @sysSiteIDPRO)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [ListType], [ListTypeOrder], [Image]) 
VALUES (N'Thiết lập bảng giá', N'Price policies', @sysSiteIDPRO, NULL, @sysTableID, NULL, 3, N'IsKH = 1', @sysMenuParent, NULL, NULL, 4, NULL, NULL, NULL)
END

END

if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

-- Site STD
select @sysMenuParent = sysMenuID 
from sysMenu 
where  MenuName = N'Bán hàng' and sysSiteID = @sysSiteIDSTD

if isnull(@sysMenuParent,'') <> ''
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Thiết lập bảng giá' and sysSiteID = @sysSiteIDSTD)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [ListType], [ListTypeOrder], [Image]) 
VALUES (N'Thiết lập bảng giá', N'Price policies', @sysSiteIDSTD, NULL, @sysTableID, NULL, 3, N'IsKH = 1', @sysMenuParent, NULL, NULL, 4, NULL, NULL, NULL)
END

END