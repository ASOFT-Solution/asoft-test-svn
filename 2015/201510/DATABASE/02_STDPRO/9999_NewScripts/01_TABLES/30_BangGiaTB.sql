if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'BangGiaTB'  and col.name = 'madvt')
BEGIN
	ALTER TABLE BangGiaTB ADD  madvt [varchar](16) NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'BangGiaTB'  and col.name = 'soluongQD')
BEGIN
	ALTER TABLE BangGiaTB ADD  soluongQD [decimal](28, 6) NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'BangGiaTB'  and col.name = 'DongiaQD')
BEGIN
	ALTER TABLE BangGiaTB ADD  DongiaQD [decimal](28, 6) NULL
END
