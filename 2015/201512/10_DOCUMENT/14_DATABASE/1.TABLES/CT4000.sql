-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CT4000]') AND type in (N'U'))
CREATE TABLE [dbo].[CT4000](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[S1] [nvarchar](50) NULL,
	[S2] [nvarchar](50) NULL,
	[S3] [nvarchar](50) NULL,
	[WMFileID] [nvarchar](50) NOT NULL,
	[WMFileName] [nvarchar](250) NULL,
	[WMFileDate] [datetime] NULL,
	[ReVoucherID] [nvarchar](50) NULL,
	[ReVoucherNo] [nvarchar](50) NULL,	
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[CObjectID] [nvarchar](50) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[ObjectName] [nvarchar](250) NULL,
	[Contact] [nvarchar](100) NULL,
	[Site] [nvarchar](250) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[SupContractNo] [nvarchar](50) NULL,
	[SupContractDate] [datetime] NULL,
	[SupStartDate] [datetime] NULL,
	[SupEndDate] [datetime] NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[ContractNo] [nvarchar](50) NULL,
	[ContractDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[ServiceTypeID] [nvarchar](50) NOT NULL,
	[ServiceLevelID] [nvarchar](50) NULL,
	[ToPay] [tinyint] NULL,
	[Features] [nvarchar](250) NULL,
	[Description] [nvarchar](250) NULL,
	[InventoryTypeID] [nvarchar](50) NULL,
	[Disabled] [tinyint] NULL,
	[IsUpdateName] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[Phonenumber] [nvarchar](50) NULL,
 CONSTRAINT [PK_CT4000] PRIMARY KEY CLUSTERED 
(
	[WMFileID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]