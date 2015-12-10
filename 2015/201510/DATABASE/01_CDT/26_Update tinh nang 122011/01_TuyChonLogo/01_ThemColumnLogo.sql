USE [CDT]

-- Add column Logo1 -> 9

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Logo1')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Logo1 [image] NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Logo2')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Logo2 [image] NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Logo3')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Logo3 [image] NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Logo4')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Logo4 [image] NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Logo5')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Logo5 [image] NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Logo6')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Logo6 [image] NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Logo7')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Logo7 [image] NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Logo8')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Logo8 [image] NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Logo9')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Logo9 [image] NULL
END