use [CDT]

-- Alter Dbname column in sysConfig to [Not Null] then add foreign constraint
If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysConfig'  and col.name = 'DbName')
BEGIN
	ALTER TABLE sysConfig ALTER COLUMN  DbName [varchar](50) NOT NULL
END

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PK_sysConfig]') and OBJECTPROPERTY(id, N'IsPrimaryKey') = 1)
BEGIN
	ALTER TABLE [dbo].[sysConfig]  drop CONSTRAINT [PK_sysConfig]
	
	ALTER TABLE [dbo].[sysConfig]  Add CONSTRAINT [PK_sysConfig] PRIMARY KEY NONCLUSTERED
	(
		[sysConfigID] ASC,
		[DbName] ASC
	) ON [PRIMARY]
END

-- Modify delete cascade in foreign key in sysConfig
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_sysConfig_sysSite]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
	ALTER TABLE [dbo].[sysConfig]  DROP CONSTRAINT [FK_sysConfig_sysSite]
END

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_sysConfig_sysDatabase]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
	ALTER TABLE [dbo].[sysConfig]  WITH NOCHECK ADD  CONSTRAINT [FK_sysConfig_sysDatabase] FOREIGN KEY ([DbName])
	REFERENCES [dbo].[sysDatabase] ([DbName])
	ON DELETE CASCADE
END

-- Alter Dbname column in sysHistory to [Not Null] then add foreign constraint
If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysHistory'  and col.name = 'DbName')
BEGIN
	ALTER TABLE sysHistory ALTER COLUMN  DbName [varchar](50) NOT NULL
END

-- Modify delete cascade in foreign key in sysHistory
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_sysHistory_sysSite]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
	ALTER TABLE [dbo].[sysHistory]  DROP CONSTRAINT [FK_sysHistory_sysSite]
END

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_sysHistory_sysDatabase]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
	ALTER TABLE [dbo].[sysHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_sysHistory_sysDatabase] FOREIGN KEY([DbName])
	REFERENCES [dbo].[sysDatabase] ([DbName])
	ON DELETE CASCADE
END
