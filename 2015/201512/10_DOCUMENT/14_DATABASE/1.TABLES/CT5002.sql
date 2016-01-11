-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CT5002]') AND type in (N'U'))
CREATE TABLE [dbo].[CT5002](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[Orders] [int] NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[VoucherNo] [nvarchar](50) NOT NULL,
	[VoucherID] [nvarchar](50) NULL,
	[RevokeInventoryID] [nvarchar](50) NULL,
	[RevokeQuantity] [decimal](28, 8) NOT NULL,
	[RevokeSerial] [nvarchar](100) NULL,
	[ReplaceInventoryID] [nvarchar](50) NULL,
	[ReplaceQuantity] [decimal](28, 8) NOT NULL,
	[ReplaceSerial] [nvarchar](100) NULL,
	[Notes] [nvarchar](250) NULL,
	CONSTRAINT [PK_CT5002] PRIMARY KEY CLUSTERED 
	(
		[TransactionID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]