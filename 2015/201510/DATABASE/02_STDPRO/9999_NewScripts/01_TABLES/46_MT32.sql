if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT32'  and col.name = 'BankID')
BEGIN
	ALTER TABLE MT32 ADD  BankID [varchar](16) NULL 
	ALTER TABLE [dbo].[MT32]  WITH NOCHECK ADD CONSTRAINT [FK_MT32_DMNH] FOREIGN KEY([BankID])
	REFERENCES [dbo].[DMNH] ([BankID])
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT32'  and col.name = 'BankAccountID')
BEGIN
	ALTER TABLE MT32 ADD  BankAccountID [varchar](16) NULL 
	ALTER TABLE [dbo].[MT32]  WITH NOCHECK ADD CONSTRAINT [FK_MT32_DMTKNH] FOREIGN KEY([BankAccountID])
	REFERENCES [dbo].[DMTKNH] ([BankAccountID])
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT32'  and col.name = 'KiemDC')
BEGIN
	ALTER TABLE MT32 ADD  KiemDC bit NULL CONSTRAINT [DF_MT32_KiemDC] DEFAULT ('0')
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT32'  and col.name = 'PCKID')
BEGIN
	ALTER TABLE MT32 ADD  PCKID [uniqueidentifier] NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT32'  and col.name = 'SoCTG')
BEGIN
	ALTER TABLE MT32 ADD  SoCTG nvarchar(512) NULL
END