if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT25'  and col.name = 'TotalCKNT')
BEGIN
	Update [MT25] set [TotalCKNT] = 0 where [TotalCKNT] is null
	ALTER TABLE [dbo].[MT25] ALTER COLUMN [TotalCKNT] [decimal](28,6) NOT NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT25'  and col.name = 'NgayBatDauTT')
BEGIN
	ALTER TABLE MT25 ADD  [NgayBatDauTT] smalldatetime NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT25'  and col.name = 'SoCTG')
BEGIN
	ALTER TABLE MT25 ADD  SoCTG nvarchar(512) NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT25'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE MT25 ADD  Saleman [varchar](16) NULL 
	ALTER TABLE [dbo].[MT25]  WITH NOCHECK ADD CONSTRAINT [fk_mt25_dmkh2] FOREIGN KEY([Saleman])
	REFERENCES [dbo].[DMKH] ([MaKH])
END