if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT52'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE MT52 ADD  Saleman [varchar](16) NULL 
	ALTER TABLE [dbo].[MT52]  WITH NOCHECK ADD CONSTRAINT [fk_mt52_dmkh2] FOREIGN KEY([Saleman])
	REFERENCES [dbo].[DMKH] ([MaKH])
END