-- Add column DienGiai2

-- DmKetchuyen
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DmKetchuyen'  and col.name = 'DienGiai2')
BEGIN
	ALTER TABLE DmKetchuyen ADD  DienGiai2 [nvarchar](128) NULL
END
