if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT41'  and col.name = 'SoCTG')
BEGIN
	ALTER TABLE MT41 ADD  SoCTG nvarchar(512) NULL
END