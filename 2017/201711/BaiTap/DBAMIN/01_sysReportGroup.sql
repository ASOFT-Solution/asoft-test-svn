/****** Object:  Table [dbo].[sysReportGroup]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysReportGroup]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysReportGroup](
	[sysReportGroupID] [int] IDENTITY(1,1) NOT NULL,
	[Module] [nvarchar](50) NOT NULL,
	[GroupID] [nvarchar](50) NOT NULL,
	[GroupName] [nvarchar](500) NULL,
 CONSTRAINT [PK_sysReportGroup] PRIMARY KEY CLUSTERED 
(
	[Module] ASC,
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END