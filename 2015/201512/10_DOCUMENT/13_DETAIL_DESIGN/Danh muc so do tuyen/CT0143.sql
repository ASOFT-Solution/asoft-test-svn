USE [HoangTran]
GO

/****** Object:  Table [dbo].[CT0143]    Script Date: 13/01/2016 2:28:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CT0143]
(
	[APK] [uniqueidentifier] NOT NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[RouteID] [nvarchar](50) NOT NULL,
	[RouteName] [nvarchar](250) NULL,
	[Description] [nvarchar](500) NULL,
	[EmployeeID] [varchar](50) NULL,
	[Disabled] [tinyint] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_CT0143] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[RouteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CT0143] ADD  CONSTRAINT [DF__CT0143__APK__28B508E6]  DEFAULT (newid()) FOR [APK]
GO


