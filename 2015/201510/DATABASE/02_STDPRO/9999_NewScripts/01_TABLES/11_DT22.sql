if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT22'  and col.name = 'TyLeQD')
BEGIN
	ALTER TABLE DT22 ADD  TyLeQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT22_TyLeQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT22'  and col.name = 'SoLuongQD')
BEGIN
	ALTER TABLE DT22 ADD  SoLuongQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT22_SoLuongQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT22'  and col.name = 'GiaQDNT')
BEGIN
	ALTER TABLE DT22 ADD  GiaQDNT [decimal](28,6) NOT NULL CONSTRAINT [DF_DT22_GiaQDNT] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT22'  and col.name = 'GiaQD')
BEGIN
	ALTER TABLE DT22 ADD  GiaQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT22_GiaQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT22'  and col.name = 'DVTQDID')
BEGIN
	ALTER TABLE DT22 ADD  [DVTQDID] [uniqueidentifier] NULL
END

if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT22'  and col.name = 'TienCKNT')
BEGIN
	Update DT22 set [TienCKNT] = 0 where [TienCKNT] is null
	ALTER TABLE [dbo].[DT22] ALTER COLUMN [TienCKNT] [decimal](28,6) NOT NULL
END

if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT22'  and col.name = 'TienNKNT')
BEGIN
	Update DT22 set [TienNKNT] = 0 where [TienNKNT] is null
	ALTER TABLE [dbo].[DT22] ALTER COLUMN [TienNKNT] [decimal](28,6) NOT NULL
END