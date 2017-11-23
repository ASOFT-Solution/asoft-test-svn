/****** Object:  Table [dbo].[sysReportFilter]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysReportFilter]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysReportFilter](
	[sysReportFilterID] [int] IDENTITY(1,1) NOT NULL,
	[ReportID] [varchar](50) NOT NULL,
	[sysFieldID] [int] NOT NULL,
	[SpecialFilter] [tinyint] NULL,
 CONSTRAINT [PK_sysReportFilter] PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC,
	[sysFieldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END