USE [HoangTran]
GO

/****** Object:  Table [dbo].[CT0144]    
Script Date: 13/01/2016 5:07:09 PM 
--- Danh mục sơ đồ tuyến CF0143 Detail
******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CT0144](
	[APK] [uniqueidentifier] NOT NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[RouteID] [nvarchar](50) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[StationID] [nvarchar](50) NULL,
	[StationOrder] [int] NULL,
	[Notes] [nvarchar](250) NULL,
 CONSTRAINT [PK_CT0144] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CT0144] ADD  DEFAULT (newid()) FOR [APK]
GO


