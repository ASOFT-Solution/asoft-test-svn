use [CDT]

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysDatabase'  and col.name = 'OrginalCompanyName')
BEGIN
	ALTER TABLE sysDatabase ADD  OrginalCompanyName [nvarchar](128) NULL
END
	