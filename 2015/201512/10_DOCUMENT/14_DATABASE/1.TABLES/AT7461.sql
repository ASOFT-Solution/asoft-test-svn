-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7461]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7461](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[VoucherID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[Description] [nvarchar](250) NULL,
	[AccountID] [nvarchar](50) NULL,
	[CorAccountID] [nvarchar](50) NULL,
	[ProductID] [nvarchar](50) NULL,
	[InventoryName] [nvarchar](250) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[ObjectName] [nvarchar](250) NULL,
	[Criteria] [nvarchar](100) NULL,
	[SelectionName] [nvarchar](250) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[Orders] [tinyint] NULL,
	CONSTRAINT [PK_AT7461] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
