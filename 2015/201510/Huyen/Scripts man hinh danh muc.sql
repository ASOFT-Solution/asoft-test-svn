USE [PRO1]
GO
/****** Object:  Table [dbo].[wDMDVTQD2]    Script Date: 10/28/2015 09:57:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
INSERT [dbo].[wDMDVTQD2] ([stt], [MaDVT], [TenDVT], [TyLeQD], [MaVT]) VALUES (N'1', N'LON', N'lon', CAST(1.000000 AS Decimal(28, 6)), N'134')
INSERT [dbo].[wDMDVTQD2] ([stt], [MaDVT], [TenDVT], [TyLeQD], [MaVT]) VALUES (N'2', N'KG', N'kg', CAST(1.000000 AS Decimal(28, 6)), N'125')
/****** Object:  Table [dbo].[DMChinhSachGia]    Script Date: 10/28/2015 09:57:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
SET IDENTITY_INSERT [dbo].[DMChinhSachGia] ON
INSERT [dbo].[DMChinhSachGia] ([Stt], [MaVT], [Gia], [MaKH], [MaDVT]) VALUES (6, N'134', CAST(7.000000 AS Decimal(28, 6)), N'1', N'KG')
INSERT [dbo].[DMChinhSachGia] ([Stt], [MaVT], [Gia], [MaKH], [MaDVT]) VALUES (7, N'125', CAST(0.000000 AS Decimal(28, 6)), N'1', N'LON')
INSERT [dbo].[DMChinhSachGia] ([Stt], [MaVT], [Gia], [MaKH], [MaDVT]) VALUES (8, N'125', CAST(85.000000 AS Decimal(28, 6)), N'2', N'KG')
INSERT [dbo].[DMChinhSachGia] ([Stt], [MaVT], [Gia], [MaKH], [MaDVT]) VALUES (9, N'134', CAST(456.000000 AS Decimal(28, 6)), N'2', N'LON')
SET IDENTITY_INSERT [dbo].[DMChinhSachGia] OFF
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
GO

-----------------------------------------------------------------------------------------

USE [CDT]
GO
INSERT [dbo].[sysMenu] ([sysMenuID], [MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image], [ListType], [ListTypeOrder]) VALUES (16160, N'Thiết lập giá bán mặt hàng theo khách hàng', NULL, 10, NULL, 2226, NULL, 0, N'isKh = 1', 15856, NULL, NULL, 4, NULL, NULL, NULL)

INSERT [dbo].[sysField] ([sysFieldID], [sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (35215, 2226, N'MaVT', 0, N'MaVT', N'DMVT', N'TenVT', N'LoaiVt <> 6', 1, N'Mã vật tư', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 1, N'FK_DMChinhSachGia_DMVT2', NULL, NULL, 0, NULL)
INSERT [dbo].[sysField] ([sysFieldID], [sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (35216, 2226, N'Gia', 1, NULL, NULL, NULL, NULL, 8, N'Đơn giá', NULL, 3, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DMChinhSachGia_Gia', N'### ### ### ##0.##', 0, NULL)
INSERT [dbo].[sysField] ([sysFieldID], [sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (35217, 2226, N'MaKH', 0, N'MaKH', N'DMKH', NULL, NULL, 1, N'Mã khách hàng', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, N'FK_DMChinhSachGia_DMKH4', NULL, NULL, 0, N'MaKH = @MaKH')
INSERT [dbo].[sysField] ([sysFieldID], [sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (35218, 2226, N'MaDVT', 0, N'MaDVT', N'wDMDVTQD2', NULL, NULL, 1, N'Đơn vị tính', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_DMChinhSachGia_wDMDVTQD15', NULL, NULL, 0, NULL)
INSERT [dbo].[sysField] ([sysFieldID], [sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (35216, 2226, N'Gia', 1, NULL, NULL, NULL, NULL, 8, N'Đơn giá', NULL, 3, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DMChinhSachGia_Gia', N'### ### ### ##0.##', 0, NULL)
INSERT [dbo].[sysField] ([sysFieldID], [sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (35214, 2226, N'Stt', 0, NULL, NULL, NULL, NULL, 3, N'Số thứ tự', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

INSERT [dbo].[sysField] ([sysFieldID], [sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (35220, 2227, N'MaDVT', 0, NULL, NULL, NULL, NULL, 2, N'Đơn vị tính', N'Unit code', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
INSERT [dbo].[sysField] ([sysFieldID], [sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (35221, 2227, N'TenDVT', 1, NULL, NULL, NULL, NULL, 2, N'Tên đơn vị tính', N'Unit name', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
INSERT [dbo].[sysField] ([sysFieldID], [sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (35222, 2227, N'TyLeQD', 1, NULL, NULL, NULL, NULL, 8, N'Tỷ lệ quy đổi', N'Convert rate', 3, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_wDMDVTQD2_TyLeQD', NULL, 0, NULL)
INSERT [dbo].[sysField] ([sysFieldID], [sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (35223, 2227, N'MaVT', 0, NULL, NULL, NULL, NULL, 2, N'Vật tư', N'Material code', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

INSERT [dbo].[sysTable] ([sysTableID], [TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) VALUES (2226, N'DMChinhSachGia', N'DMChinhSachGia', N'List price policy', N'Stt', NULL, N'DMKH', 4, NULL, NULL, 0, NULL, 8, NULL, 0)
INSERT [dbo].[sysTable] ([sysTableID], [TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) VALUES (2227, N'wDMDVTQD2', N'View danh mục đơn vị tính quy đổi', NULL, N'stt', NULL, NULL, 2, NULL, NULL, 0, NULL, 8, NULL, 0)
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
