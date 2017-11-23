/****** Object:  Table [dbo].[sysTable]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysTable]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysTable](
	[TableName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[PK] [varchar](50) NULL,
	[ModuleID] [nvarchar](50) NULL,
	[ParentTable] [nvarchar](MAX) NULL,
	[RefLink] [nvarchar](50) NULL,
 CONSTRAINT [PK_sysTable] PRIMARY KEY CLUSTERED 
(
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END


If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysTable'  and col.name = 'RelTable')
BEGIN
 ALTER TABLE sysTable ADD RelTable varchar(200) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysTable'  and col.name = 'RelColumn')
BEGIN
 ALTER TABLE sysTable ADD RelColumn varchar(200) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysTable'  and col.name = 'RefUrl')
BEGIN
 ALTER TABLE sysTable ADD RefUrl varchar(200) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysTable'  and col.name = 'TableDelete')
BEGIN
 ALTER TABLE sysTable ADD TableDelete varchar(MAX) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysTable'  and col.name = 'TypeREL')
BEGIN
 ALTER TABLE sysTable ADD TypeREL int NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysTable'  and col.name = 'RealRelColumn')
BEGIN
 ALTER TABLE sysTable ADD RealRelColumn varchar(200) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysTable'  and col.name = 'StartRowImport')
BEGIN
 ALTER TABLE sysTable ADD StartRowImport int NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysTable'  and col.name = 'PKDetail')
BEGIN
 ALTER TABLE sysTable ADD PKDetail varchar(200)  NULL
END


--------------Dùng để phân biệt màn hình chính để insert----------------------------------

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysTable'  and col.name = 'RefScreenMainID')
BEGIN
 ALTER TABLE sysTable ADD RefScreenMainID varchar(MAX) NULL
END

-----------------------------------------------------------------------------------------