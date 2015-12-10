if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT17'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE MT17 ADD  Saleman [varchar](16) NULL 
	ALTER TABLE [dbo].[MT17]  WITH NOCHECK ADD CONSTRAINT [fk_mt17_dmkh2] FOREIGN KEY([Saleman])
	REFERENCES [dbo].[DMKH] ([MaKH])
END