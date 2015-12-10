use [CDT]

-- Add column DbName to sysConfig
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysConfig'  and col.name = 'DbName')
BEGIN
	ALTER TABLE sysConfig ADD  DbName [varchar](50) NULL
END

-- Add column DbName to sysHistory
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysHistory'  and col.name = 'DbName')
BEGIN
	ALTER TABLE sysHistory ADD  DbName [varchar](50) NULL
END

-- Add column DbName to sysPrintedInvoice
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoice'  and col.name = 'DbName')
BEGIN
	ALTER TABLE sysPrintedInvoice ADD  DbName [varchar](50) NULL
END

-- Add column DbName to sysPrintedInvoiceDt
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'DbName')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  DbName [varchar](50) NULL
END