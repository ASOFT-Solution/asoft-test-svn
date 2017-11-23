/****** Object:  Table [dbo].[sysScreen]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysScreen]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysScreen](
	[APK] [uniqueidentifier] NOT NULL  DEFAULT (newid()),
	[DivisionID] [nvarchar](50) NOT NULL,
	[ModuleID] [nvarchar](50) NOT NULL,
	[ScreenID] [nvarchar](50) NOT NULL,
	[ScreenName] [nvarchar](250) NULL,
	[ScreenType] [tinyint] NOT NULL DEFAULT ((1)),
	[ScreenNameE] [nvarchar](250) NULL,
	[Parent] [nvarchar](50) NULL,
	[sysTable] [nvarchar](50) NULL,
	[Title] [nvarchar](50) NULL,
	[DisplayToolBar] [varchar](100) NULL,
	[TypeInput] [int] NULL,
	[DisplayToolBar2] [varchar](100) NULL,
	[ReportID] [varchar](50) NULL,
	[DeleteStoreName] [varchar](50) NULL,
	[sysCategoryBusinessID] [int] NULL,
	[SqlFilter] [text] NULL,
	[StoreFilter] [varchar](50) NULL,
	[StoreFilterParameter] [varchar](MAX) NULL,
	[Width] [int] NULL,
 CONSTRAINT [PK_sysScreen] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC,
	[ScreenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysScreen'  and col.name = 'sysActionID')
BEGIN
 ALTER TABLE sysScreen ADD sysActionID varchar(50) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysScreen'  and col.name = 'SQLPrint')
BEGIN
 ALTER TABLE sysScreen ADD SQLPrint varchar(MAX) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysScreen'  and col.name = 'StorePrint')
BEGIN
 ALTER TABLE sysScreen ADD StorePrint varchar(50) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysScreen'  and col.name = 'StorePrintParameter')
BEGIN
 ALTER TABLE sysScreen ADD StorePrintParameter varchar(Max) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysScreen'  and col.name = 'CountGridOneTable')
BEGIN
 ALTER TABLE sysScreen ADD CountGridOneTable int NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysScreen'  and col.name = 'IsAdvancedSearch')
BEGIN
 ALTER TABLE sysScreen ADD IsAdvancedSearch tinyint NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysScreen'  and col.name = 'TableDetailSelect')
BEGIN
 ALTER TABLE sysScreen ADD TableDetailSelect varchar(1000) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysScreen'  and col.name = 'SqlFilterDetail')
BEGIN
 ALTER TABLE sysScreen ADD SqlFilterDetail varchar(MAX) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysScreen'  and col.name = 'StoreFilterDetail')
BEGIN
 ALTER TABLE sysScreen ADD StoreFilterDetail varchar(50) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysScreen'  and col.name = 'StoreFilterParameterDetail')
BEGIN
 ALTER TABLE sysScreen ADD StoreFilterParameterDetail varchar(Max) NULL
END


