if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT45'  and col.name = 'SoCTG')
BEGIN
	ALTER TABLE MT45 ADD  SoCTG nvarchar(512) NULL
END