If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT31'  and col.name = 'NgayBatDauTT')
BEGIN
	ALTER TABLE MT31 ADD  [NgayBatDauTT] smalldatetime NULL
END