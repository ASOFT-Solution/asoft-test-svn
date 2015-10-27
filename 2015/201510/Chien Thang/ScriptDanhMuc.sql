USE [PRO1]
GO
/****** Object:  Table [dbo].[DMChinhSachGia]    Script Date: 10/26/2015 11:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMDVT4] FOREIGN KEY([MaDVT])
REFERENCES [dbo].[DMDVT] ([MaDVT])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMDVT4]
GO
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMKH3] FOREIGN KEY([MaKH])
REFERENCES [dbo].[DMKH] ([MaKH])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMKH3]
GO
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMVT2] FOREIGN KEY([MaVT])
REFERENCES [dbo].[DMVT] ([MaVT])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMVT2]
---------------------------------------------------------------------------------------
USE [PRODEMO]
GO
/****** Object:  Table [dbo].[DMChinhSachGia]    Script Date: 10/26/2015 11:43:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMDVT4] FOREIGN KEY([MaDVT])
REFERENCES [dbo].[DMDVT] ([MaDVT])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMDVT4]
GO
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMKH3] FOREIGN KEY([MaKH])
REFERENCES [dbo].[DMKH] ([MaKH])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMKH3]
GO
ALTER TABLE [dbo].[DMChinhSachGia]  WITH CHECK ADD  CONSTRAINT [FK_DMChinhSachGia_DMVT2] FOREIGN KEY([MaVT])
REFERENCES [dbo].[DMVT] ([MaVT])
GO
ALTER TABLE [dbo].[DMChinhSachGia] CHECK CONSTRAINT [FK_DMChinhSachGia_DMVT2]
----------------------------------------------------------------------------------------
use CDT

Insert into sysTable
Values('DMChinhSachGia', N'Danh mục thiết lập chính sách giá bán cho từng khách hàng', null, 'Stt', null, 'DMKH', 4, 'Stt', null, 0, null, 8, null, 0)

declare @sysTableID int
Select @sysTableID = sysTableID FROM sysTable WHERE TableName = 'DMChinhSachGia'

declare @sysMenuParent int
Select @sysMenuParent = sysMenuID FROM sysMenu WHERE MenuName = N'Bán Hàng'

Insert into sysMenu
Values(N'Thiết lập giá bán mặt hàng theo khách hàng', null, 10, 4, @sysTableID, null, 5, null, @sysMenuParent, null, null, 4, null, null, null)

Insert into sysField
Values(@sysTableID, 'Stt', 0, null, null, null, null, 3, N'Số thứ tự', null, 0, null, null, null, null, null, null, null, 0, 0, 0, 0, 1, null, null, null, 0, null)

Insert into sysField
Values(@sysTableID, 'MaVT', 0, 'MaVT', 'DMVT', 'TenVT', null, 1, N'Mã vật tư', null, 1, null, null, null, null, null, null, null, 1, 0, 0, 0, 1, 'FK_DMChinhSachGia_DMVT2', null, null, 0, null)

Insert into sysField
Values(@sysTableID, 'MaKH', 0, 'MaKH', 'DMKH', null, null, 1, N'Mã khách hàng', null, 2, null, null, null, null, null, null, null, 0, 0, 0, 0, 1, 'FK_DMChinhSachGia_DMKH3', null, null, 0, null)

Insert into sysField
Values(@sysTableID, 'MaDVT', 0, 'MaDVT', 'DMDVT', 'TenDVT', null, 1, N'Mã đơn vị tính', null, 3, null, null, null, null, null, null, null, 1, 0, 0, 0, 1, 'FK_DMChinhSachGia_DMDVT4', null, null, 0, null)

Insert into sysField
Values(@sysTableID, 'Gia', 1, null, null, null, null, 5, N'Đơn giá', null, 4, null, null, null, null, null, null, null, 1, 0, 0, 0, 1, null, null, null, 0, null)
GO