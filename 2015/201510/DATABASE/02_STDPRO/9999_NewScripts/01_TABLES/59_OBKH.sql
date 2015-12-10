if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBKH'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE OBKH ADD  Saleman [varchar](16) NULL 
	ALTER TABLE [dbo].[OBKH]  WITH NOCHECK ADD CONSTRAINT [fk_obkh_dmkh2] FOREIGN KEY([Saleman])
	REFERENCES [dbo].[DMKH] ([MaKH])
END