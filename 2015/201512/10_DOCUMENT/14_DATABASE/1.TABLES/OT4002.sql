-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT4002]') AND type in (N'U'))
CREATE TABLE [dbo].[OT4002](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[SOrderID] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[CostID] [nvarchar](50) NULL,
	[Sales] [decimal](28, 8) NULL,
	[PrimeCost] [decimal](28, 8) NULL,
	[OthersCost] [decimal](28, 8) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[Orders] [int] NULL,
	[DisCountAmount] [decimal](28, 8) NULL,
	[OrderQuantity] [decimal](28, 8) NULL,
	[CommissionAmount] [decimal](28, 8) NULL,
 CONSTRAINT [PK_OT4001] PRIMARY KEY NONCLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
