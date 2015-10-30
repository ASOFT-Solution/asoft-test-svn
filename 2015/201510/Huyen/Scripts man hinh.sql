USE [PRO1]
GO
/****** Object:  Table [dbo].[wDMDVTQD2]    Script Date: 10/28/2015 09:57:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
if not exists (select * from [dbo].[sysTable] where [TableName] = N'wDMDVTQD2')
CREATE TABLE [dbo].[wDMDVTQD2](
	[stt] [varchar](16) NOT NULL,
	[MaDVT] [nvarchar](512) NOT NULL,
	[TenDVT] [nvarchar](512) NULL,
	[TyLeQD] [decimal](28, 6) NULL,
	[MaVT] [nvarchar](512) NOT NULL,
 CONSTRAINT [PK_wDMDVTQD2] PRIMARY KEY CLUSTERED 
(
	[stt] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DMChinhSachGia]    Script Date: 10/28/2015 09:57:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
if not exists (select * from [dbo].[sysTable] where [TableName] = N'DMChinhSachGia')
CREATE TABLE [dbo].[DMChinhSachGia](
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[MaVT] [varchar](16) NOT NULL,
	[Gia] [decimal](28, 6) NULL,
	[MaKH] [varchar](16) NOT NULL,
	[MaDVT] [varchar](16) NOT NULL,
 CONSTRAINT [PK_DMChinhSachGia] PRIMARY KEY CLUSTERED 
(
	[Stt] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Default [DF_DMChinhSachGia_Gia]    Script Date: 10/28/2015 09:57:42 ******/
ALTER TABLE [dbo].[DMChinhSachGia] ADD  CONSTRAINT [DF_DMChinhSachGia_Gia]  DEFAULT ('0') FOR [Gia]
GO
/****** Object:  Default [DF_wDMDVTQD2_TyLeQD]    Script Date: 10/28/2015 09:57:42 ******/
ALTER TABLE [dbo].[wDMDVTQD2] ADD  CONSTRAINT [DF_wDMDVTQD2_TyLeQD]  DEFAULT ('0') FOR [TyLeQD]
GO
/****** Object:  ForeignKey [FK_DMChinhSachGia_DMKH4]    Script Date: 10/28/2015 09:57:42 ******/
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMKH4] FOREIGN KEY([MaKH])
REFERENCES [dbo].[DMKH] ([MaKH])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMKH4]
GO
/****** Object:  ForeignKey [FK_DMChinhSachGia_DMVT2]    Script Date: 10/28/2015 09:57:42 ******/
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMVT2] FOREIGN KEY([MaVT])
REFERENCES [dbo].[DMVT] ([MaVT])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMVT2]

declare 
-----------------------------------------------------------------------------------------

USE [CDT]
GO
if not exists (select * from [dbo].[sysTable] where [TableName] = N'DMChinhSachGia')
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) VALUES (N'DMChinhSachGia', N'DMChinhSachGia', N'List price policy', N'Stt', NULL, N'DMKH', 4, NULL, NULL, 0, NULL, 8, NULL, 0)
if not exists (select * from [dbo].[sysTable] where [TableName] = N'wDMDVTQD2')
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) VALUES (N'wDMDVTQD2', N'View danh mục đơn vị tính quy đổi', NULL, N'stt', NULL, NULL, 2, NULL, NULL, 0, NULL, 8, NULL, 0)

declare @sysTableID1 int
Select @sysTableID1 = sysTableID FROM sysTable WHERE TableName = 'DMChinhSachGia'

declare @sysTableID2 int
Select @sysTableID2 = sysTableID FROM sysTable WHERE TableName = 'wDMDVTQD2'

declare @sysMenuParent int
Select @sysMenuParent = sysMenuID FROM sysMenu WHERE MenuName = N'Bán Hàng'

INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image], [ListType], [ListTypeOrder]) VALUES (N'Thiết lập giá bán mặt hàng theo khách hàng', NULL, 10, NULL, @sysTableID1, NULL, 0, N'isKh = 1', @sysMenuParent, NULL, NULL, 4, NULL, NULL, NULL)

INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID1, N'MaVT', 0, N'MaVT', N'DMVT', N'TenVT', N'LoaiVt <> 6', 1, N'Mã vật tư', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 1, N'FK_DMChinhSachGia_DMVT2', NULL, NULL, 0, NULL)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID1, N'Gia', 1, NULL, NULL, NULL, NULL, 8, N'Đơn giá', NULL, 3, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DMChinhSachGia_Gia', N'### ### ### ##0.##', 0, NULL)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID1, N'MaKH', 0, N'MaKH', N'DMKH', NULL, NULL, 1, N'Mã khách hàng', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, N'FK_DMChinhSachGia_DMKH4', NULL, NULL, 0, N'MaKH = @MaKH')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID1, N'MaDVT', 0, N'MaDVT', N'wDMDVTQD2', NULL, NULL, 1, N'Đơn vị tính', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_DMChinhSachGia_wDMDVTQD15', NULL, NULL, 0, NULL)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID1, N'Stt', 0, NULL, NULL, NULL, NULL, 3, N'Số thứ tự', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID2, N'stt', 0, NULL, NULL, NULL, NULL, 0, N'stt', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID2, N'MaDVT', 0, NULL, NULL, NULL, NULL, 2, N'Đơn vị tính', N'Unit code', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID2, N'TenDVT', 1, NULL, NULL, NULL, NULL, 2, N'Tên đơn vị tính', N'Unit name', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID2, N'TyLeQD', 1, NULL, NULL, NULL, NULL, 8, N'Tỷ lệ quy đổi', N'Convert rate', 3, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_wDMDVTQD2_TyLeQD', NULL, 0, NULL)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID2, N'MaVT', 0, NULL, NULL, NULL, NULL, 2, N'Vật tư', N'Material code', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

---------------------------------------------------------------------------------------------------
USE [PRODEMO]
GO
/****** Object:  Table [dbo].[wDMDVTQD2]    Script Date: 10/28/2015 10:37:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
if not exists (select * from [dbo].[sysTable] where [TableName] = N'wDMDVTQD2')
CREATE TABLE [dbo].[wDMDVTQD2](
	[stt] [varchar](16) NOT NULL,
	[MaDVT] [nvarchar](512) NOT NULL,
	[TenDVT] [nvarchar](512) NULL,
	[TyLeQD] [decimal](28, 6) NULL,
	[MaVT] [nvarchar](512) NOT NULL,
 CONSTRAINT [PK_wDMDVTQD2] PRIMARY KEY CLUSTERED 
(
	[stt] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DMChinhSachGia]    Script Date: 10/28/2015 10:37:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
if not exists (select * from [dbo].[sysTable] where [TableName] = N'DMChinhSachGia')
CREATE TABLE [dbo].[DMChinhSachGia](
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[MaVT] [varchar](16) NOT NULL,
	[Gia] [decimal](28, 6) NULL,
	[MaKH] [varchar](16) NOT NULL,
	[MaDVT] [varchar](16) NOT NULL,
 CONSTRAINT [PK_DMChinhSachGia] PRIMARY KEY CLUSTERED 
(
	[Stt] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Default [DF_DMChinhSachGia_Gia]    Script Date: 10/28/2015 10:37:53 ******/
ALTER TABLE [dbo].[DMChinhSachGia] ADD  CONSTRAINT [DF_DMChinhSachGia_Gia]  DEFAULT ('0') FOR [Gia]
GO
/****** Object:  Default [DF_wDMDVTQD2_TyLeQD]    Script Date: 10/28/2015 10:37:53 ******/
ALTER TABLE [dbo].[wDMDVTQD2] ADD  CONSTRAINT [DF_wDMDVTQD2_TyLeQD]  DEFAULT ('0') FOR [TyLeQD]
GO
/****** Object:  ForeignKey [FK_DMChinhSachGia_DMKH4]    Script Date: 10/28/2015 10:37:53 ******/
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMKH4] FOREIGN KEY([MaKH])
REFERENCES [dbo].[DMKH] ([MaKH])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMKH4]
GO
/****** Object:  ForeignKey [FK_DMChinhSachGia_DMVT2]    Script Date: 10/28/2015 10:37:53 ******/
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMVT2] FOREIGN KEY([MaVT])
REFERENCES [dbo].[DMVT] ([MaVT])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMVT2]
GO
