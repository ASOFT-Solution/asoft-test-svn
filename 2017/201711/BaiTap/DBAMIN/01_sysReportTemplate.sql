/****** Object:  Table [dbo].[sysReportTemplate]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysReportTemplate]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysReportTemplate](
	[sysReportTemplateID] [int] IDENTITY(1,1) NOT NULL,
	[ReportID] [varchar](50) NULL,
	[FileName] [varchar](100) NULL,
	[ReportTemplateID] [varchar](50) NULL,
 CONSTRAINT [PK_sysReportTemplate] PRIMARY KEY CLUSTERED 
(
	[sysReportTemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END