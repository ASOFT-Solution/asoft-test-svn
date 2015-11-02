USE [PRO1]
GO
/****** Object:  Table [dbo].[DMChinhSachGia]    Script Date: 11/02/2015 11:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF  NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[DMChinhSachGia]'))
CREATE TABLE [dbo].[DMChinhSachGia](
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[MaVT] [varchar](16) NOT NULL,
	[MaDVT] [varchar](16) NOT NULL,
	[Gia] [decimal](28, 6) NULL,
	[MaKH] [varchar](16) NOT NULL,
 CONSTRAINT [PK_DMChinhSachGia] PRIMARY KEY CLUSTERED 
(
	[Stt] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Default [DF_DMChinhSachGia_Gia]    Script Date: 11/02/2015 11:56:39 ******/
ALTER TABLE [dbo].[DMChinhSachGia] ADD  CONSTRAINT [DF_DMChinhSachGia_Gia]  DEFAULT ('0') FOR [Gia]
GO
/****** Object:  ForeignKey [FK_DMChinhSachGia_DMKH5]    Script Date: 11/02/2015 11:56:39 ******/
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMKH5] FOREIGN KEY([MaKH])
REFERENCES [dbo].[DMKH] ([MaKH])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMKH5]
GO
/****** Object:  ForeignKey [FK_DMChinhSachGia_DMVT2]    Script Date: 11/02/2015 11:56:39 ******/
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMVT2] FOREIGN KEY([MaVT])
REFERENCES [dbo].[DMVT] ([MaVT])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMVT2]
GO
/****** Object:  ForeignKey [FK_DMChinhSachGia_wDMDVTQD3]    Script Date: 11/02/2015 11:56:39 ******/
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_wDMDVTQD3] FOREIGN KEY([MaDVT])
REFERENCES [dbo].[DMDVT] ([MaDVT])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_wDMDVTQD3]
GO

-----------------------------------------------------------------------------------------

USE [CDT]
GO
if not exists (select * from [dbo].[sysTable] where [TableName] = N'DMChinhSachGia')
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) VALUES (N'DMChinhSachGia', N'DMChinhSachGia', N'List price policy', N'Stt', NULL, N'DMKH', 4, NULL, NULL, 0, NULL, 8, NULL, 0)

declare @sysTableID1 int
Select @sysTableID1 = sysTableID FROM sysTable WHERE TableName = 'DMChinhSachGia'

declare @sysMenuParent int
Select @sysMenuParent = sysMenuID FROM sysMenu WHERE MenuName = N'Bán Hàng'
if not exists (select * form [dbo].[sysMenu] where [MenuName] = N'Thiết lập giá bán mặt hàng theo khách hàng')
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image], [ListType], [ListTypeOrder]) VALUES (N'Thiết lập giá bán mặt hàng theo khách hàng', NULL, 10, NULL, @sysTableID1, NULL, 0, N'isKh = 1', @sysMenuParent, NULL, NULL, 4, NULL, NULL, NULL)
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'MaVT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID1, N'MaVT', 0, N'MaVT', N'DMVT', N'TenVT', N'LoaiVt <> 6', 1, N'Mã vật tư', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 1, N'FK_DMChinhSachGia_DMVT2', NULL, NULL, 0, NULL)
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'Gia')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID1, N'Gia', 1, NULL, NULL, NULL, NULL, 8, N'Đơn giá', NULL, 3, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DMChinhSachGia_Gia', N'### ### ### ##0.##', 0, NULL)
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'MaKH')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID1, N'MaKH', 0, N'MaKH', N'DMKH', NULL, NULL, 1, N'Mã khách hàng', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, N'FK_DMChinhSachGia_DMKH4', NULL, NULL, 0, N'MaKH = @MaKH')
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'MaDVT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID1, N'MaDVT', 0, N'MaDVT', N'wDMDVTQD2', NULL, NULL, 1, N'Đơn vị tính', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_DMChinhSachGia_wDMDVTQD15', NULL, NULL, 0, NULL)
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'Stt')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID1, N'Stt', 0, NULL, NULL, NULL, NULL, 3, N'Số thứ tự', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)


---------------------------------------------------------------------------------------------------
USE [PRODEMO]
GO
/****** Object:  Table [dbo].[DMChinhSachGia]    Script Date: 11/02/2015 12:03:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF  NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[DMChinhSachGia]'))
CREATE TABLE [dbo].[DMChinhSachGia](
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[MaVT] [varchar](16) NOT NULL,
	[MaDVT] [varchar](16) NOT NULL,
	[Gia] [decimal](28, 6) NULL,
	[MaKH] [varchar](16) NOT NULL,
 CONSTRAINT [PK_DMChinhSachGia] PRIMARY KEY CLUSTERED 
(
	[Stt] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Default [DF_DMChinhSachGia_Gia]    Script Date: 11/02/2015 12:03:47 ******/
ALTER TABLE [dbo].[DMChinhSachGia] ADD  CONSTRAINT [DF_DMChinhSachGia_Gia]  DEFAULT ('0') FOR [Gia]
GO
/****** Object:  ForeignKey [FK_DMChinhSachGia_DMKH5]    Script Date: 11/02/2015 12:03:47 ******/
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMKH5] FOREIGN KEY([MaKH])
REFERENCES [dbo].[DMKH] ([MaKH])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMKH5]
GO
/****** Object:  ForeignKey [FK_DMChinhSachGia_DMVT2]    Script Date: 11/02/2015 12:03:47 ******/
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMVT2] FOREIGN KEY([MaVT])
REFERENCES [dbo].[DMVT] ([MaVT])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMVT2]
GO
/****** Object:  ForeignKey [FK_DMChinhSachGia_wDMDVTQD3]    Script Date: 11/02/2015 12:03:47 ******/
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_wDMDVTQD3] FOREIGN KEY([MaDVT])
REFERENCES [dbo].[DMDVT] ([MaDVT])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_wDMDVTQD3]
GO
