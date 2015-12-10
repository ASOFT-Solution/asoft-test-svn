IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_bltk_dmtk]') AND parent_object_id = OBJECT_ID(N'[dbo].[BLTK]'))
ALTER TABLE [dbo].[BLTK] DROP CONSTRAINT [fk_bltk_dmtk]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_bltk_dmtk_tkdu]') AND parent_object_id = OBJECT_ID(N'[dbo].[BLTK]'))
ALTER TABLE [dbo].[BLTK] DROP CONSTRAINT [fk_bltk_dmtk_tkdu]


if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'BLTK'  and col.name = 'TK')
BEGIN

	Alter Table BLTK Alter Column TK nvarchar(16) NULL
END

if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'BLTK'  and col.name = 'TKDu')
BEGIN
	Alter Table BLTK Alter Column TKDu nvarchar(16) NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'BLTK'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE BLTK ADD  Saleman [varchar](16) NULL 
	ALTER TABLE [dbo].[BLTK]  WITH NOCHECK ADD CONSTRAINT [fk_bltk_dmkh2] FOREIGN KEY([Saleman])
	REFERENCES [dbo].[DMKH] ([MaKH])
END