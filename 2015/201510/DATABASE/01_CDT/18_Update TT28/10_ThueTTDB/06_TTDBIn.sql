USE [CDT]
declare @sysTableID as int
declare @sysFieldID as int
declare @MenuThueKhacID as int
declare @sysSiteIDPRO as int
declare @sysSiteIDSTD as int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

-- Them table TTDBin
if not exists (select top 1 1 from sysTable where TableName = 'TTDBin')
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) 
VALUES (N'TTDBin', N'Bảng thuế TTDB đầu vào', N'Bảng thuế TTDB đầu vào E', N'TTDBinID', NULL, N'MT21, MT22, MT23', 2, NULL, NULL, 0, NULL, 8, NULL, 2)

select @sysTableID = sysTableID from sysTable where TableName = 'TTDBin'

if not exists (select top 1 1 from sysField where FieldName = 'TTDBinID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TTDBinID', 0, NULL, NULL, NULL, NULL, 3, N'Khóa bảng', N'Khóa bảng E', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

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

if not exists (select top 1 1 from sysField where FieldName = 'MaNCC' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaNCC', 0, N'MaKH', N'DMKH', NULL, N'isNCC = 1', 1, N'Nhà cung cấp', N'Supplier', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_TTDBin_DMKH7', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TenNCC' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TenNCC', 0, NULL, NULL, NULL, NULL, 2, N'Tên nhà cung cấp', N'Supplier name', 6, NULL, N'MaNCC.TenKH', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MaVT' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaVT', 1, N'MaVT', N'DMVT', NULL, NULL, 1, N'Mã vật tư', N'Material codes', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_TTDBin_DMVT9', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TenVT' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TenVT', 1, NULL, NULL, NULL, NULL, 2, N'Tên vật tư', N'Material name', 8, NULL, N'MaVT.TenVT', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'SoLuong_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'SoLuong_TTDB', 1, NULL, NULL, NULL, NULL, 8, N'Số lượng', N'Quantity', 9, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0.##', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'GiaNT_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'GiaNT_TTDB', 0, NULL, NULL, NULL, NULL, 8, N'Giá bán nguyên tệ', N'Original selling price', 10, NULL, NULL, NULL, 0, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBin_GiaNT', N'### ### ### ##0.####', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'Gia_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'Gia_TTDB', 0, NULL, NULL, NULL, NULL, 8, N'Giá bán', N'Selling price', 11, N' @GiaNT_TTDB*@TyGia', NULL, NULL, 0, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBin_Gia', N'### ### ### ##0.####', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'PSNT_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PSNT_TTDB', 0, NULL, NULL, NULL, NULL, 8, N'Thành tiền NT', N'Original amount', 12, N'@GiaNT_TTDB*@SoLuong_TTDB', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBin_PSNT', N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'PS_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PS_TTDB', 0, NULL, NULL, NULL, NULL, 8, N'Thành tiền', N'Total amount', 13, N'@Gia_TTDB*@SoLuong_TTDB', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBin_PS', N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'PS1NT_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PS1NT_TTDB', 0, NULL, NULL, NULL, NULL, 8, N'Giá tính thuế TTDB NT', N'Original selling price excluding tax', 14, N'@PSNT_TTDB - @TienCKNT + @CtThueNkNT', NULL, NULL, 0, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBin_PS1NT', N'### ### ### ##0.####', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'PS1_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PS1_TTDB', 0, NULL, NULL, NULL, NULL, 8, N'Giá tính thuế TTDB', N'Selling price excluding tax', 15, N'@PS_TTDB - @TienCK + @CtThueNk', NULL, NULL, 0, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBin_PS1', N'### ### ### ##0.####', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'PS2NT_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PS2NT_TTDB', 0, NULL, NULL, NULL, NULL, 8, N'Giá bao gồm thuế TTDB NT', N'Original selling price including tax', 16, N'@PS1NT_TTDB + @TienTTDBNT', NULL, NULL, 0, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBin_PS2NT', N'### ### ### ##0.####', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'PS2_TTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PS2_TTDB', 0, NULL, NULL, NULL, NULL, 8, N'Giá bao gồm thuế TTDB', N'Selling price including tax', 17, N'@PS1_TTDB + @TienTTDB', NULL, NULL, 0, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBin_PS2', N'### ### ### ##0.####', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MaNhomTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaNhomTTDB', 0, N'MaNhomTTDB', N'DMThueTTDB', NULL, N'ThueSuatTTDB > 0', 1, N'Mã nhóm HH chịu thuế TTDB', N'Group code', 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_TTDBin_DMThueTTDB15', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ThueSuatTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ThueSuatTTDB', 0, NULL, NULL, NULL, NULL, 8, N'Thuế suất TTDB', N'Tax rate', 19, NULL, N'MaNhomTTDB.ThueSuatTTDB', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'#0.##', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TienTTDBNT' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TienTTDBNT', 0, NULL, NULL, NULL, NULL, 8, N'Tiền thuế TTDB NT', N'Original tax amount', 20, N'@PS1NT_TTDB * @ThueSuatTTDB/100', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBin_TienTTDBNT', N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TienTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TienTTDB', 0, NULL, NULL, NULL, NULL, 8, N'Tiền thuế TTDB', N'Tax amount', 21, N'@PS1_TTDB * @ThueSuatTTDB/100', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_TTDBin_TienTTDB', N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TkTTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TkTTTDB', 0, N'TK', N'DMTK', NULL, N'TK not in (select  TK=case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)', 1, N'Tk thuế TTDB', N'Special consumption account', 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'fk_TTDBin_TkTTTDB', NULL, N'&', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TkDuTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TkDuTTDB', 0, N'TK', N'DMTK', NULL, N'TK not in (select  TK=case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)', 1, N'Tk đối ứng', N'Corresponding account', 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'fk_TTDBin_TkDuTTDB', NULL, N'&', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MTID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MTID', 1, NULL, NULL, NULL, NULL, 6, N'Mã bảng', N'Mã bảng E', 24, NULL, NULL, NULL, NULL, NULL, N'MT21, MT22, MT23', NULL, 0, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MTIDDT' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MTIDDT', 1, NULL, NULL, NULL, NULL, 6, N'Mã chi tiết', NULL, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'GhiChu' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'GhiChu', 1, NULL, NULL, NULL, NULL, 2, N'Ghi chú', N'Notes', 26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)