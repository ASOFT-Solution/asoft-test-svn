if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT31'  and col.name = 'BankID')
BEGIN
	ALTER TABLE MT31 ADD  BankID [varchar](16) NULL 
	ALTER TABLE [dbo].[MT31]  WITH NOCHECK ADD CONSTRAINT [FK_MT31_DMNH] FOREIGN KEY([BankID])
	REFERENCES [dbo].[DMNH] ([BankID])
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT31'  and col.name = 'BankAccountID')
BEGIN
	ALTER TABLE MT31 ADD  BankAccountID [varchar](16) NULL 
	ALTER TABLE [dbo].[MT31]  WITH NOCHECK ADD CONSTRAINT [FK_MT31_DMTKNH] FOREIGN KEY([BankAccountID])
	REFERENCES [dbo].[DMTKNH] ([BankAccountID])
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT31'  and col.name = 'SoCTG')
BEGIN
	ALTER TABLE MT31 ADD  SoCTG nvarchar(512) NULL
END