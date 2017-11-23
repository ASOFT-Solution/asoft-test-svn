/****** Object:  Table [dbo].[sysToolBar]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysToolBar]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysToolBar](
	[sysToolBarID] [int] IDENTITY(1,1) NOT NULL,
	[sysToolBarName] [varchar](50) NOT NULL,
	[ToolBarID] [varchar](50) NULL,
 CONSTRAINT [PK_sysToolBar] PRIMARY KEY CLUSTERED 
(
	[sysToolBarID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END