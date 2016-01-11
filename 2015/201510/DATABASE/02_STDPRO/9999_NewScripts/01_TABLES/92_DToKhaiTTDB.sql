if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DToKhaiTTDB'  and col.name = 'TaxCheck')
BEGIN
	ALTER TABLE DToKhaiTTDB ADD TaxCheck [bit] NULL
END