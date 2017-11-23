/****** Object:  Table [dbo].[sysMenu]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysMenu]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysMenu](
	[sysMenuID] [int] IDENTITY(1,1) NOT NULL,
	[MenuText] [nvarchar](100) NULL,
	[sysScreenID] [nvarchar](50) NULL,
	[MenuOder] [int] NULL,
	[sysMenuParent] [int] NULL,
	[CustomerIndex] [int] NULL,
	[MenuName] [nvarchar](50) NULL,
	[ModuleID] [nvarchar](50) NULL,
	[MenuID] [varchar](50) NULL,
 CONSTRAINT [PK_sysMenu] PRIMARY KEY CLUSTERED 
(
	[sysMenuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END


If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysMenu'  and col.name = 'MenuLevel')
BEGIN
 ALTER TABLE sysMenu ADD MenuLevel int NULL
END