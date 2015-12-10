if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBVT'  and col.name = 'MaDVT')
BEGIN
	ALTER TABLE OBVT ADD  MaDVT [varchar](16) NULL 
	ALTER TABLE [dbo].[OBVT]  WITH NOCHECK ADD CONSTRAINT [fk_obvt_dmdvt] FOREIGN KEY([MaDVT])
	REFERENCES [dbo].[DMDVT] ([MaDVT])
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBVT'  and col.name = 'TyLeQD')
BEGIN
	ALTER TABLE OBVT ADD  TyLeQD [decimal](28,6) NOT NULL CONSTRAINT [DF_OBVT_TyLeQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBVT'  and col.name = 'SoLuongQD')
BEGIN
	ALTER TABLE OBVT ADD  SoLuongQD [decimal](28,6) NOT NULL CONSTRAINT [DF_OBVT_SoLuongQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBVT'  and col.name = 'DVTQDID')
BEGIN
	ALTER TABLE OBVT ADD  [DVTQDID] [uniqueidentifier] NULL
END