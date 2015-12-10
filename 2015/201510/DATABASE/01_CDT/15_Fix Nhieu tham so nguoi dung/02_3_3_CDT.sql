use [CDT]

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PK_sysPrintedInvoice]') and OBJECTPROPERTY(id, N'IsPrimaryKey') = 1)
BEGIN
	ALTER TABLE [dbo].[sysPrintedInvoice]  drop CONSTRAINT [PK_sysPrintedInvoice]
	
	ALTER TABLE [dbo].[sysPrintedInvoice]  Add CONSTRAINT [PK_sysPrintedInvoice] PRIMARY KEY NONCLUSTERED
	(
		[sysSiteID] ASC,
		[DbName] ASC
	) ON [PRIMARY]
END