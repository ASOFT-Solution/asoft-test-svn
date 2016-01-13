USE [HoangTran]
GO

/****** Object:  Table [dbo].[AT0047]    Script Date: 13/01/2016 3:06:47 PM
--- Thông tin giao hàng -CF0047 - Cập nhật đối tượng
-- <History>
---- Create on 13/01/2016 by Thị Phượng 
---- Modified on ... by 
 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AT0047](
	[APK] [uniqueidentifier] NOT NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[ObjectID] [nvarchar](50) NOT NULL,
	[StationID] [nvarchar](50) NOT NULL,
	[Orders] [int] NOT NULL,
	[InfoNotes] [nvarchar](250) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_AT0047] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[ObjectID] ASC,
	[StationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AT0047] ADD  DEFAULT (newid()) FOR [APK]
GO

ALTER TABLE [dbo].[AT0047] ADD  DEFAULT ((0)) FOR [Orders]
GO


