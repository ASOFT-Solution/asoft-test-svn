use [CDT]

-- Alter Dbname column in sysPrintedInvoice to [Not Null]
If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoice'  and col.name = 'DbName')
BEGIN
	ALTER TABLE sysPrintedInvoice ALTER COLUMN  DbName [varchar](50) NOT NULL
END