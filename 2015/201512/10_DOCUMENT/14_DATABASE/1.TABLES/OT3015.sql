-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT3015]') AND type in (N'U'))
CREATE TABLE [dbo].[OT3015](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[POrderID] [nvarchar](50) NULL,
	[Orders] [int] NULL,
	[InventoryName] [nvarchar](250) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[Source] [nvarchar](100) NULL,
	[Quantity] [decimal](28, 8) NULL,
	[UnitName] [nvarchar](250) NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[ImTaxConvertedAmount] [decimal](28, 8) NULL,
	[ImTaxPercent] [decimal](28, 8) NULL,
	[ImTaxAmount] [decimal](28, 8) NULL,
	[VATConvertedAmount] [decimal](28, 8) NULL,
	[VATPercent] [decimal](28, 8) NULL,
	[VATAmount] [decimal](28, 8) NULL,
	[OtherPercent] [decimal](28, 8) NULL,
	[OtherAmount] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	CONSTRAINT [PK_OT3015] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
