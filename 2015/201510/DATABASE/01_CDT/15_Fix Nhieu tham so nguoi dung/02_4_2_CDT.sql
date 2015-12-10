use [CDT]

-- Alter Dbname column in sysPrintedInvoiceDt to [Not Null]
If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'DbName')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ALTER COLUMN  DbName [varchar](50) NOT NULL
END

			