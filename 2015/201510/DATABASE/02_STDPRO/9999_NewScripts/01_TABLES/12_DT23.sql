if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT23'  and col.name = 'TyLeQD')
BEGIN
	ALTER TABLE DT23 ADD  TyLeQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT23_TyLeQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT23'  and col.name = 'SoLuongQD')
BEGIN
	ALTER TABLE DT23 ADD  SoLuongQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT23_SoLuongQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT23'  and col.name = 'GiaQDNT')
BEGIN
	ALTER TABLE DT23 ADD  GiaQDNT [decimal](28,6) NOT NULL CONSTRAINT [DF_DT23_GiaQDNT] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT23'  and col.name = 'GiaQD')
BEGIN
	ALTER TABLE DT23 ADD  GiaQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT23_GiaQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT23'  and col.name = 'DVTQDID')
BEGIN
	ALTER TABLE DT23 ADD  [DVTQDID] [uniqueidentifier] NULL
END

if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT23'  and col.name = 'TienCKNT')
BEGIN
	Update [DT23] set [TienCKNT] = 0 where [TienCKNT] is null
	ALTER TABLE [dbo].[DT23] ALTER COLUMN [TienCKNT] [decimal](28,6) NOT NULL
END

if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT23'  and col.name = 'TienNKNT')
BEGIN
	Update [DT23] set [TienNKNT] = 0 where [TienNKNT] is null
	ALTER TABLE [dbo].[DT23] ALTER COLUMN [TienNKNT] [decimal](28,6) NOT NULL
END

if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT23'  and col.name = 'CPCtNT')
BEGIN
	Update [DT23] set [CPCtNT] = 0 where [CPCtNT] is null
	ALTER TABLE [dbo].[DT23] ALTER COLUMN [CPCtNT] [decimal](28,6) NOT NULL
END