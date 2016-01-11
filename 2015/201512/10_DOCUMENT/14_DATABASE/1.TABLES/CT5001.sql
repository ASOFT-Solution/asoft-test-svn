-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CT5001]') AND type in (N'U'))
CREATE TABLE [dbo].[CT5001](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[Orders] [int] NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[SubInventoryID] [nvarchar](50) NOT NULL,
	[UnitID] [nvarchar](50) NULL,
	[SubQuantity] [decimal](28, 8) NULL,
	[SubSerial] [nvarchar](50) NULL,
	[SubStatus] [tinyint] NULL,
	[Notes] [nvarchar](250) NULL,
	CONSTRAINT [PK_CT5001] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]