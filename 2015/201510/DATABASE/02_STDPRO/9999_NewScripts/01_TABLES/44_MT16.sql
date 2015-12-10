if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT16'  and col.name = 'BankID')
BEGIN
	ALTER TABLE MT16 ADD  BankID [varchar](16) NULL 
	ALTER TABLE [dbo].[MT16]  WITH NOCHECK ADD CONSTRAINT [FK_MT16_DMNH19] FOREIGN KEY([BankID])
	REFERENCES [dbo].[DMNH] ([BankID])
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT16'  and col.name = 'BankAccountID')
BEGIN
	ALTER TABLE MT16 ADD  BankAccountID [varchar](16) NULL 
	ALTER TABLE [dbo].[MT16]  WITH NOCHECK ADD CONSTRAINT [FK_MT16_DMTKNH20] FOREIGN KEY([BankAccountID])
	REFERENCES [dbo].[DMTKNH] ([BankAccountID])
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT16'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE MT16 ADD  Saleman [varchar](16) NULL 
	ALTER TABLE [dbo].[MT16]  WITH NOCHECK ADD CONSTRAINT [fk_mt16_dmkh2] FOREIGN KEY([Saleman])
	REFERENCES [dbo].[DMKH] ([MaKH])
END