/****** Object:  Table [dbo].[sysGroup]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysGroup]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysGroup](
	[sysGroupID] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[ModuleID] [nvarchar](50) NOT NULL,
	[ScreenID] [nvarchar](50) NULL,
	[TabIndex] [int] NULL,
	[GroupID] [varchar](50) NULL,
 CONSTRAINT [PK_sysGroup] PRIMARY KEY CLUSTERED 
(
	[sysGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysGroup'  and col.name = 'sysTable')
BEGIN
 ALTER TABLE sysGroup ADD sysTable varchar(200) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysGroup'  and col.name = 'PartialView')
BEGIN
 ALTER TABLE sysGroup ADD PartialView varchar(200) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysGroup'  and col.name = 'IsFields')
BEGIN
 ALTER TABLE sysGroup ADD IsFields tinyint NULL
END
