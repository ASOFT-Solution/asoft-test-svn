-- CoCongtrinhDD
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'CoCongtrinhDD'  and col.name = 'TK')
BEGIN
	ALTER TABLE CoCongtrinhDD ADD  TK [varchar](16) NULL 
	ALTER TABLE [dbo].[CoCongtrinhDD]  WITH NOCHECK ADD CONSTRAINT [fk_CoCongtrinhDD_dmtk] FOREIGN KEY([TK])
	REFERENCES [dbo].[DMTK] ([TK])
END
