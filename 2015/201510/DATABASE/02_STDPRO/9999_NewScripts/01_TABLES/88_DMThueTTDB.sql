if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DMThueTTDB'  and col.name = 'MaHTKK')
BEGIN
	ALTER TABLE DMThueTTDB ADD  MaHTKK varchar(50) NULL
END