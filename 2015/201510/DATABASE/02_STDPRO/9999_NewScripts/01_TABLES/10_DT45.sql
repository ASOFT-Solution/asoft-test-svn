if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT45'  and col.name = 'TyLeQD')
BEGIN
	ALTER TABLE DT45 ADD  TyLeQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT45_TyLeQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT45'  and col.name = 'SoLuongQD')
BEGIN
	ALTER TABLE DT45 ADD  SoLuongQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT45_SoLuongQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT45'  and col.name = 'GiaQDNT')
BEGIN
	ALTER TABLE DT45 ADD  GiaQDNT [decimal](28,6) NOT NULL CONSTRAINT [DF_DT45_GiaQDNT] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT45'  and col.name = 'GiaQD')
BEGIN
	ALTER TABLE DT45 ADD  GiaQD [decimal](28,6) NOT NULL CONSTRAINT [DF_DT45_GiaQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT45'  and col.name = 'DVTQDID')
BEGIN
	ALTER TABLE DT45 ADD  [DVTQDID] [uniqueidentifier] NULL
END