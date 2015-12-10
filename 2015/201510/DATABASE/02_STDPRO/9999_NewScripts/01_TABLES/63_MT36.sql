if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT36'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE MT36 ADD  Saleman [varchar](16) NULL 
	ALTER TABLE [dbo].[MT36]  WITH NOCHECK ADD CONSTRAINT [fk_mt36_dmkh2] FOREIGN KEY([Saleman])
	REFERENCES [dbo].[DMKH] ([MaKH])
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT36'  and col.name = 'IsQuy')
BEGIN
	ALTER TABLE MT36 ADD  IsQuy [bit] NULL
	ALTER TABLE [dbo].[MT36] ADD  CONSTRAINT [DF_MT36_IsQuy]  DEFAULT ('0') FOR [IsQuy]
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT36'  and col.name = 'QuyKTT')
BEGIN
	ALTER TABLE MT36 ADD  QuyKTT [int] NULL
END