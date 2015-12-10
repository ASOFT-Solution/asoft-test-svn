USE [CDT]
GO

/****** Object:  Table [dbo].[sysPrintedInvoice]    Script Date: 05/05/2011 17:34:30 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sysPrintedInvoice]') AND type in (N'U'))
BEGIN
/****** Object:  Table [dbo].[sysPrintedInvoice]    Script Date: 05/05/2011 17:34:32 ******/
CREATE TABLE [dbo].[sysPrintedInvoice](
	[sysSiteID] [int] NOT NULL,
	[AllowRePrint] [bit] NULL,
	[Logo] [image] NULL,
	[CopyCaption] [nvarchar](50) NULL,
 CONSTRAINT [PK_sysPrintedInvoice] PRIMARY KEY CLUSTERED 
(
	[sysSiteID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]



ALTER TABLE [dbo].[sysPrintedInvoice] ADD  CONSTRAINT [DF_sysPrintedInvoice_CopyCaption]  DEFAULT (N'(BẢN SAO)') FOR [CopyCaption]

END
GO


