if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT33'  and col.name = 'TyLeQD')
BEGIN
	ALTER TABLE DT33 ADD  TyLeQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT33_TyLeQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT33'  and col.name = 'SoLuongQD')
BEGIN
	ALTER TABLE DT33 ADD  SoLuongQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT33_SoLuongQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT33'  and col.name = 'GiaQDNT')
BEGIN
	ALTER TABLE DT33 ADD  GiaQDNT [decimal](28,6) NOT NULL CONSTRAINT [DF_DT33_GiaQDNT] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT33'  and col.name = 'GiaQD')
BEGIN
	ALTER TABLE DT33 ADD  GiaQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT33_GiaQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT33'  and col.name = 'DVTQDID')
BEGIN
	ALTER TABLE DT33 ADD  [DVTQDID] [uniqueidentifier] NULL
END

if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT33'  and col.name = 'TienCKNT')
BEGIN
	Update [DT33] set [TienCKNT] = 0 where [TienCKNT] is null
	ALTER TABLE [dbo].[DT33] ALTER COLUMN [TienCKNT] [decimal](28,6) NOT NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT33'  and col.name = 'GhiChu')
BEGIN
	ALTER TABLE DT33 ADD  [GhiChu] nvarchar(512) NULL
END