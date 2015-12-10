If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT24'  and col.name = 'NgayBatDauTT')
BEGIN
	ALTER TABLE MT24 ADD  [NgayBatDauTT] smalldatetime NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT24'  and col.name = 'SoCTG')
BEGIN
	ALTER TABLE MT24 ADD  SoCTG nvarchar(512) NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT24'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE MT24 ADD  Saleman [varchar](16) NULL 
	ALTER TABLE [dbo].[MT24]  WITH NOCHECK ADD CONSTRAINT [fk_mt24_dmkh2] FOREIGN KEY([Saleman])
	REFERENCES [dbo].[DMKH] ([MaKH])
END