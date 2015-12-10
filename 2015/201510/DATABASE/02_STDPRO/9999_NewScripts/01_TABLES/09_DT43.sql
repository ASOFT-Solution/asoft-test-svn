if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT43'  and col.name = 'TyLeQD')
BEGIN
	ALTER TABLE DT43 ADD  TyLeQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT43_TyLeQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT43'  and col.name = 'SoLuongQD')
BEGIN
	ALTER TABLE DT43 ADD  SoLuongQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT43_SoLuongQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT43'  and col.name = 'GiaQDNT')
BEGIN
	ALTER TABLE DT43 ADD  GiaQDNT [decimal](28,6) NOT NULL CONSTRAINT [DF_DT43_GiaQDNT] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT43'  and col.name = 'GiaQD')
BEGIN
	ALTER TABLE DT43 ADD  GiaQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT43_GiaQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT43'  and col.name = 'DVTQDID')
BEGIN
	ALTER TABLE DT43 ADD  [DVTQDID] [uniqueidentifier] NULL
END