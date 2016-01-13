USE [HoangTran]
GO

/****** Object:  Table [dbo].[CT0141]    Script Date: 13/01/2016 8:38:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CT0141](
	[APK] [uniqueidentifier] NOT NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[StationID] [nvarchar](50) NOT NULL,
	[StationName] [nvarchar](250) NULL,
	[Address] [nvarchar](500) NULL,
	[StreetNo] [nvarchar](100) NULL,
	[Street] [nvarchar](250) NULL,
	[Ward] [nvarchar](250) NULL,
	[District] [nvarchar](250) NULL,
	[CityID] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[Disabled] [tinyint] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_CT0141] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[StationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CT0141] ADD  DEFAULT (newid()) FOR [APK]
GO

ALTER TABLE [dbo].[CT0141] ADD  DEFAULT ((0)) FOR [Disabled]
GO


