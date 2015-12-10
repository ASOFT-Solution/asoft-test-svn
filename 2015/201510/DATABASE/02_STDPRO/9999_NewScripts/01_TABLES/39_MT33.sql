If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT33'  and col.name = 'NgayBatDauTT')
BEGIN
	ALTER TABLE MT33 ADD  [NgayBatDauTT] smalldatetime NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT33'  and col.name = 'SoCTG')
BEGIN
	ALTER TABLE MT33 ADD  SoCTG nvarchar(512) NULL
END