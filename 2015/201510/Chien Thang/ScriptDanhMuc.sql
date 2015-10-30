USE [PRO1]
GO
/****** Object:  Table [dbo].[DMChinhSachGia]    Script Date: 10/26/2015 11:42:15 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMChinhSachGia]') AND type in (N'U'))
BEGIN
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[DMChinhSachGia](
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[MaVT] [varchar](16) NULL,
	[MaKH] [varchar](16) NOT NULL,
	[MaDVT] [varchar](16) NOT NULL,
	[Gia] [int] NULL,
 CONSTRAINT [PK_DMChinhSachGia] PRIMARY KEY CLUSTERED 
(
	[Stt] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMDVT4] FOREIGN KEY([MaDVT])
REFERENCES [dbo].[DMDVT] ([MaDVT])

ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMDVT4]

ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMKH3] FOREIGN KEY([MaKH])
REFERENCES [dbo].[DMKH] ([MaKH])

ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMKH3]

ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMVT2] FOREIGN KEY([MaVT])
REFERENCES [dbo].[DMVT] ([MaVT])

ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMVT2]
END

Else
Print 'Da ton tai'
---------------------------------------------------------------------------------------
USE [PRODEMO]
GO
/****** Object:  Table [dbo].[DMChinhSachGia]    Script Date: 10/26/2015 11:43:04 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMChinhSachGia]') AND type in (N'U'))
BEGIN
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[DMChinhSachGia](
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[MaVT] [varchar](16) NULL,
	[MaKH] [varchar](16) NOT NULL,
	[MaDVT] [varchar](16) NOT NULL,
	[Gia] [int] NULL,
 CONSTRAINT [PK_DMChinhSachGia] PRIMARY KEY CLUSTERED 
(
	[Stt] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMDVT4] FOREIGN KEY([MaDVT])
REFERENCES [dbo].[DMDVT] ([MaDVT])

ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMDVT4]

ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMKH3] FOREIGN KEY([MaKH])
REFERENCES [dbo].[DMKH] ([MaKH])

ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMKH3]

ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMVT2] FOREIGN KEY([MaVT])
REFERENCES [dbo].[DMVT] ([MaVT])

ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMVT2]
END

Else
Print 'Da ton tai'
----------------------------------------------------------------------------------------
use CDT

IF NOT EXISTS(Select * From sysTable Where TableName ='DMChinhSachGia')
Insert into sysTable(TableName, DienGiai, DienGiai2, Pk, ParentPk, MasterTable, Type, SortOrder, DetailField, System, MaCT, sysPackageID, Report, CollectType)
Values('DMChinhSachGia', N'Danh mục thiết lập chính sách giá bán cho từng khách hàng', null, 'Stt', null, 'DMKH', 4, 'Stt', null, 0, null, 8, null, 0)

declare @sysTableID int
Select @sysTableID = sysTableID FROM sysTable WHERE TableName = 'DMChinhSachGia'

declare @sysMenuParent int
Select @sysMenuParent = sysMenuID FROM sysMenu WHERE MenuName = N'Bán Hàng'

IF NOT EXISTS(Select * From sysMenu Where MenuName = N'Thiết lập giá bán mặt hàng theo khách hàng')
Insert into sysMenu(MenuName, MenuName2, sysSiteID, CustomType, sysTableID, sysReportID, MenuOrder, ExtraSql, sysMenuParent, MenuPluginID, PluginName, UIType, Image, ListType, ListTypeOrder)
Values(N'Thiết lập giá bán mặt hàng theo khách hàng', null, 10, 4, @sysTableID, null, 5, null, @sysMenuParent, null, null, 4, null, null, null)

IF NOT EXISTS(Select * From sysField Where sysTableID = @sysTableID AND FieldName = 'Stt')
Insert into sysField(sysTableID, FieldName, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
Values(@sysTableID, 'Stt', 0, null, null, null, null, 3, N'Số thứ tự', null, 0, null, null, null, null, null, null, null, 0, 0, 0, 0, 1, null, null, null, 0, null)

IF NOT EXISTS(Select * From sysField Where sysTableID = @sysTableID AND FieldName = 'MaVT')
Insert into sysField(sysTableID, FieldName, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
Values(@sysTableID, 'MaVT', 0, 'MaVT', 'DMVT', 'TenVT', null, 1, N'Mã vật tư', null, 1, null, null, null, null, null, null, null, 1, 0, 0, 0, 1, 'FK_DMChinhSachGia_DMVT2', null, null, 0, null)

IF NOT EXISTS(Select * From sysField Where sysTableID = @sysTableID AND FieldName = 'MaKH')
Insert into sysField(sysTableID, FieldName, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
Values(@sysTableID, 'MaKH', 0, 'MaKH', 'DMKH', null, null, 1, N'Mã khách hàng', null, 2, null, null, null, null, null, null, null, 0, 0, 0, 0, 1, 'FK_DMChinhSachGia_DMKH3', null, null, 0, null)

IF NOT EXISTS(Select * From sysField Where sysTableID = @sysTableID AND FieldName = 'MaDVT')
Insert into sysField(sysTableID, FieldName, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
Values(@sysTableID, 'MaDVT', 0, 'MaDVT', 'DMDVT', 'TenDVT', null, 1, N'Mã đơn vị tính', null, 3, null, null, null, null, null, null, null, 1, 0, 0, 0, 1, 'FK_DMChinhSachGia_DMDVT4', null, null, 0, null)

IF NOT EXISTS(Select * From sysField Where sysTableID = @sysTableID AND FieldName = 'Gia')
Insert into sysField(sysTableID, FieldName, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
Values(@sysTableID, 'Gia', 1, null, null, null, null, 5, N'Đơn giá', null, 4, null, null, null, null, null, null, null, 1, 0, 0, 0, 1, null, null, null, 0, null)
GO