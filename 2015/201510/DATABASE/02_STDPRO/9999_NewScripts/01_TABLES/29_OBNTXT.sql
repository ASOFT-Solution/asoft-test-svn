if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBNTXT'  and col.name = 'MaDVT')
BEGIN
	ALTER TABLE OBNTXT ADD  MaDVT [varchar](16) NULL 
	ALTER TABLE [dbo].[OBNTXT]  WITH NOCHECK ADD CONSTRAINT [fk_obntxt_dmdvt] FOREIGN KEY([MaDVT])
	REFERENCES [dbo].[DMDVT] ([MaDVT])
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBNTXT'  and col.name = 'TyLeQD')
BEGIN
	ALTER TABLE OBNTXT ADD  TyLeQD [decimal](28,6) NOT NULL CONSTRAINT [DF_OBNTXT_TyLeQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBNTXT'  and col.name = 'SoLuongQD')
BEGIN
	ALTER TABLE OBNTXT ADD  SoLuongQD [decimal](28,6) NOT NULL CONSTRAINT [DF_OBNTXT_SoLuongQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBNTXT'  and col.name = 'DVTQDID')
BEGIN
	ALTER TABLE OBNTXT ADD  [DVTQDID] [uniqueidentifier] NULL
END