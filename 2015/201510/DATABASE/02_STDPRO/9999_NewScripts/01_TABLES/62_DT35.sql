if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT35'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE DT35 ADD  Saleman [varchar](16) NULL 
	ALTER TABLE [dbo].[DT35]  WITH NOCHECK ADD CONSTRAINT [fk_dt35_dmkh2] FOREIGN KEY([Saleman])
	REFERENCES [dbo].[DMKH] ([MaKH])
END