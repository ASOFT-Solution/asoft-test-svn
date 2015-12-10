USE [CDT]
declare @sysTableID as int
declare @MenuThueKhacID as int
declare @sysSiteIDPRO as int
declare @sysSiteIDSTD as int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

-- Them table TTDBout
if not exists (select top 1 1 from sysTable where TableName = 'TTDBout')
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) 
VALUES (N'TTDBout', N'Bảng thuế TTDB đầu ra', N'Bảng thuế TTDB đầu ra E', N'TTDBoutID', NULL, N'MT31, MT32, MT33', 2, NULL, NULL, 0, NULL, 8, NULL, 2)

select @sysTableID = sysTableID from sysTable where TableName = 'TTDBout'

if not exists (select top 1 1 from sysField where FieldName = 'TTDBoutID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TTDBoutID', 0, NULL, NULL, NULL, NULL, 3, N'Khóa bảng', N'Khóa bảng E', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'NgayHd' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'NgayHd', 0, NULL, NULL, NULL, NULL, 9, N'Ngày hóa đơn', N'Invoice date', 1, NULL, N'NgayHD', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'Sohoadon' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'Sohoadon', 0, NULL, NULL, NULL, NULL, 2, N'Số hóa đơn', N'Invoice number', 2, NULL, N'SoHoaDon', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'NgayCt' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'NgayCt', 0, NULL, NULL, NULL, NULL, 9, N'Ngày chứng từ', N'Voucher date', 3, NULL, N'NgayCT', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'SoSerie' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'SoSerie', 1, NULL, NULL, NULL, NULL, 2, N'Số seri', N'Seri number', 4, NULL, N'SoSeri', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MaKH' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaKH', 0, N'MaKH', N'DMKH', NULL, N'isKH = 1', 1, N'Khách hàng', N'Customer', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_TTDBout_DMKH7', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TenKH' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TenKH', 0, NULL, NULL, NULL, NULL, 2, N'Tên khách hàng', N'Customer name', 6, NULL, N'MaKH.TenKH', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MaVT' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaVT', 1, N'MaVT', N'DMVT', NULL, NULL, 1, N'Mã vật tư', N'Material codes', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_TTDBout_DMVT9', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TenVT' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TenVT', 1, NULL, NULL, NULL, NULL, 2, N'Tên vật tư', N'Material name', 8, NULL, N'MaVT.TenVT', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'SoLuong_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'SoLuong_TTDB', 1, NULL, NULL, NULL, NULL, 8, N'Số lượng', N'Quantity', 9, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0.##', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'GiaNT_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'GiaNT_TTDB', 0, NULL, NULL, NULL, NULL, 8, N'Giá bán nguyên tệ', N'Original selling price', 10, NULL, NULL, NULL, 0, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBout_GiaNT', N'### ### ### ##0.####', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'Gia_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'Gia_TTDB', 0, NULL, NULL, NULL, NULL, 8, N'Giá bán', N'Selling price', 11, N' @GiaNT_TTDB*@TyGia', NULL, NULL, 0, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBout_Gia', N'### ### ### ##0.####', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'PSNT_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PSNT_TTDB', 0, NULL, NULL, NULL, NULL, 8, N'Thành tiền NT', N'Original amount', 12, N'@GiaNT_TTDB*@SoLuong_TTDB', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBout_PSNT', N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'PS_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PS_TTDB', 0, NULL, NULL, NULL, NULL, 8, N'Thành tiền', N'Total amount', 13, N'@Gia_TTDB*@SoLuong_TTDB', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBout_PS', N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MaNhomTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaNhomTTDB', 0, N'MaNhomTTDB', N'DMThueTTDB', NULL, N'ThueSuatTTDB > 0', 1, N'Mã nhóm HH chịu thuế TTDB', N'Group code', 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_TTDBout_DMThueTTDB15', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ThueSuatTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ThueSuatTTDB', 0, NULL, NULL, NULL, NULL, 8, N'Thuế suất TTDB', N'Tax rate', 15, NULL, N'MaNhomTTDB.ThueSuatTTDB', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'#0.##', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TienTTDBNT' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TienTTDBNT', 0, NULL, NULL, NULL, NULL, 8, N'Tiền thuế TTDB NT', N'Original tax amount', 16, N'@PSNT_TTDB-@PS1NT_TTDB', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBout_TienTTDBNT', N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TienTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TienTTDB', 0, NULL, NULL, NULL, NULL, 8, N'Tiền thuế TTDB', N'Tax amount', 17, N'@PS_TTDB-@PS1_TTDB', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBout_TienTTDB', N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'PS1NT_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PS1NT_TTDB', 0, NULL, NULL, NULL, NULL, 8, N'Giá tính thuế TTDB NT', N'Original selling price excluding tax', 18, N'@PSNT_TTDB/(1+@ThueSuatTTDB)', NULL, NULL, 0, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBout_PS1NT', N'### ### ### ##0.####', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'PS1_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PS1_TTDB', 0, NULL, NULL, NULL, NULL, 8, N'Giá tính thuế TTDB', N'Selling price excluding tax', 19, N'@PS_TTDB/(1+@ThueSuatTTDB)', NULL, NULL, 0, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBout_PS1', N'### ### ### ##0.####', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MTID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MTID', 1, NULL, NULL, NULL, NULL, 6, N'Mã bảng', N'Mã bảng E', 20, NULL, NULL, NULL, NULL, NULL, N'MT31, MT32, MT33', NULL, 0, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MTIDDT' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MTIDDT', 1, NULL, NULL, NULL, NULL, 6, N'Mã chi tiết', NULL, 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

