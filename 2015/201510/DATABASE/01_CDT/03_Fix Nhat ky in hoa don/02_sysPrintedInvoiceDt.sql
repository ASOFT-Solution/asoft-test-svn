USE [CDT]
GO

/****** Object:  Table [dbo].[sysPrintedInvoiceDt]    Script Date: 05/05/2011 17:37:12 ******/
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sysPrintedInvoiceDt]') AND type in (N'U'))
begin
/****** Object:  Table [dbo].[sysPrintedInvoiceDt]    Script Date: 05/05/2011 17:37:12 ******/

CREATE TABLE [dbo].[sysPrintedInvoiceDt](
	[sysSiteID] [int] NOT NULL,
	[sysReportID] [nvarchar](50) NOT NULL,
	[ReportName] [nvarchar](150) NULL,
	[ReportName2] [nvarchar](150) NULL,
	[Pages] [int] NULL,
	[Page1] [nvarchar](150) NULL,
	[Background1] [image] NULL,
	[Page2] [nvarchar](150) NULL,
	[Background2] [image] NULL,
	[Page3] [nvarchar](150) NULL,
	[Background3] [image] NULL,
	[Page4] [nvarchar](150) NULL,
	[Background4] [image] NULL,
	[Page5] [nvarchar](150) NULL,
	[Background5] [image] NULL,
	[Page6] [nvarchar](150) NULL,
	[Background6] [image] NULL,
	[Page7] [nvarchar](150) NULL,
	[Background7] [image] NULL,
	[Page8] [nvarchar](150) NULL,
	[Background8] [image] NULL,
	[Page9] [nvarchar](150) NULL,
	[Background9] [image] NULL,
	[Disabled] [bit] NULL,
 CONSTRAINT [PK_sysPrintedInvoice1] PRIMARY KEY CLUSTERED 
(
	[sysSiteID] ASC,
	[sysReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

end


