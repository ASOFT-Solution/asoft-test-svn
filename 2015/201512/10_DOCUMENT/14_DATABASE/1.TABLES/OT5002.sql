-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT5002]') AND type in (N'U'))
CREATE TABLE [dbo].[OT5002](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[PackageID] [nvarchar](50) NOT NULL,
	[Quantity] [decimal](28, 8) NULL,
	[PackageQuantity] [decimal](28, 8) NULL,
	[WeighAmount] [decimal](28, 8) NULL,
	[Note1] [nvarchar](250) NULL,
	[Note2] [nvarchar](250) NULL,
	[InventoryCommonName] [nvarchar](250) NULL,
 CONSTRAINT [PK_OT5002] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
