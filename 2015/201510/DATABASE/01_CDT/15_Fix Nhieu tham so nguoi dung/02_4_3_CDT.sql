use [CDT]

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PK_sysPrintedInvoice1]') and OBJECTPROPERTY(id, N'IsPrimaryKey') = 1)
BEGIN
	ALTER TABLE [dbo].[sysPrintedInvoiceDt]  drop CONSTRAINT [PK_sysPrintedInvoice1]
	
	ALTER TABLE [dbo].[sysPrintedInvoiceDt]  Add CONSTRAINT [PK_sysPrintedInvoice1] PRIMARY KEY NONCLUSTERED
	(
		[sysSiteID] ASC,
		[sysReportID] ASC,
		[DbName] ASC
	) ON [PRIMARY]
END