/****** Object:  Table [dbo].[sysReport]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysReport]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysReport](
	[sysReportID] [int] IDENTITY(1,1) NOT NULL,
	[ReportID] [varchar](50) NOT NULL,
	[ReportName] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[GroupID] [nvarchar](50) NULL,
	[IsCommon] [tinyint] NULL,
	[Disabled] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[StoreName] [varchar](20) NULL,
	[StoreParameter] [varchar](500) NULL,
	[SQLstring] [nvarchar](1000) NULL,
	[StaticFilter] [varchar](100) NULL,
	[DynamicFilter] [varchar](100) NULL,
 CONSTRAINT [PK_sysReport_1] PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END

IF EXISTS (SELECT * FROM sysobjects WHERE NAME='sysReport' AND xtype='U')
BEGIN
	IF EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='sysReport' AND col.name='ReportName')
	Alter Table sysReport
		Alter column ReportName varchar(MAX) NULL ;
    IF EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='sysReport' AND col.name='Description')
	Alter Table sysReport
		Alter column Description varchar(MAX) NULL ;
    IF EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='sysReport' AND col.name='StoreParameter')
	Alter Table sysReport
		Alter column StoreParameter varchar(MAX) NULL ;
END

