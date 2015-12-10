if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT15'  and col.name = 'BankID')
BEGIN
	ALTER TABLE MT15 ADD  BankID [varchar](16) NULL 
	ALTER TABLE [dbo].[MT15]  WITH NOCHECK ADD CONSTRAINT [FK_MT15_DMNH] FOREIGN KEY([BankID])
	REFERENCES [dbo].[DMNH] ([BankID])
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT15'  and col.name = 'BankAccountID')
BEGIN
	ALTER TABLE MT15 ADD  BankAccountID [varchar](16) NULL 
	ALTER TABLE [dbo].[MT15]  WITH NOCHECK ADD CONSTRAINT [FK_MT15_DMTKNH] FOREIGN KEY([BankAccountID])
	REFERENCES [dbo].[DMTKNH] ([BankAccountID])
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT15'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE MT15 ADD  Saleman [varchar](16) NULL 
	ALTER TABLE [dbo].[MT15]  WITH NOCHECK ADD CONSTRAINT [fk_mt15_dmkh2] FOREIGN KEY([Saleman])
	REFERENCES [dbo].[DMKH] ([MaKH])
END