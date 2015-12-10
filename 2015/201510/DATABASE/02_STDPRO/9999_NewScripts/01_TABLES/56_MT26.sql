if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT26'  and col.name = 'SoCTG')
BEGIN
	ALTER TABLE MT26 ADD  SoCTG nvarchar(512) NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT26'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE MT26 ADD  Saleman [varchar](16) NULL 
	ALTER TABLE [dbo].[MT26]  WITH NOCHECK ADD CONSTRAINT [fk_mt26_dmkh2] FOREIGN KEY([Saleman])
	REFERENCES [dbo].[DMKH] ([MaKH])
END