USE [CDT]

IF EXISTS (SELECT *
           FROM   sysobjects
           WHERE  name = 'ListType'
                  AND xtype = 'U')
BEGIN

	If not exists (select * from syscolumns col inner join sysobjects tab On col.id = tab.id where tab.name = 'sysMenu' and col.name = 'ListType')
	BEGIN
		Alter Table sysMenu Add ListType int Null
	END
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[FK_sysMenu_ListType]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	BEGIN
		ALTER TABLE [dbo].[sysMenu] WITH CHECK ADD CONSTRAINT [FK_sysMenu_ListType] FOREIGN KEY([ListType]) REFERENCES [dbo].[ListType] ([ListTypeID])
		ALTER TABLE [dbo].[sysMenu] CHECK CONSTRAINT [FK_sysMenu_ListType]
	END
END

If not exists (select * from syscolumns col inner join sysobjects tab On col.id = tab.id where tab.name = 'sysMenu' and col.name = 'ListTypeOrder')
BEGIN
	Alter Table sysMenu Add ListTypeOrder int Null
END