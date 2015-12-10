USE [CDT]
GO


If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Page1Eng')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Page1Eng [nvarchar](150) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Page2Eng')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Page2Eng [nvarchar](150) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Page3Eng')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Page3Eng [nvarchar](150) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Page4Eng')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Page4Eng [nvarchar](150) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Page5Eng')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Page5Eng [nvarchar](150) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Page6Eng')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Page6Eng [nvarchar](150) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Page7Eng')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Page7Eng [nvarchar](150) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Page8Eng')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Page8Eng [nvarchar](150) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysPrintedInvoiceDt'  and col.name = 'Page9Eng')
BEGIN
	ALTER TABLE sysPrintedInvoiceDt ADD  Page9Eng [nvarchar](150) NULL
END
