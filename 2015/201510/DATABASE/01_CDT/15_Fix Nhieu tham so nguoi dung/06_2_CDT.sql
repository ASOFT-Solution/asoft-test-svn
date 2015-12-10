use [CDT]

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PK_sysConfig]') and OBJECTPROPERTY(id, N'IsPrimaryKey') = 1)
BEGIN
	ALTER TABLE [dbo].[sysConfig]  drop CONSTRAINT [PK_sysConfig]
	
	ALTER TABLE [dbo].[sysConfig]  Add CONSTRAINT [PK_sysConfig] PRIMARY KEY NONCLUSTERED
	(
		[sysConfigID] ASC
	) ON [PRIMARY]
END
