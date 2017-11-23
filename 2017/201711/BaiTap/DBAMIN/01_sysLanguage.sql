/****** Object:  Table [dbo].[sysLanguage]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysLanguage]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysLanguage](
	[APK] [uniqueidentifier] ROWGUIDCOL  NOT NULL DEFAULT (newid()),
	[ScreenID] [nvarchar](50) NOT NULL,
	[ColumnName] [nvarchar](50) NOT NULL,
	[IDLanguage] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_sysLanguage_1] PRIMARY KEY CLUSTERED 
(
	[ScreenID] ASC,
	[ColumnName] ASC,
	[IDLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO