-- <Summary>
---- 
-- <History>
---- Create on 11/06/2014 by Lê Thị Thu Hiền
---- Modified on ... by ...
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WT0102]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WT0102](
	[APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,	
	[Orders] [int] NOT NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[UnitID] [nvarchar](50) NULL,
	[Price] [decimal](28, 8) NULL,
	[ActualQuantity] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
	[ReVoucherID] [nvarchar](50) NULL,
	[ReTransactionID] [nvarchar](50) NULL,	
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[Ana06ID] [nvarchar](50) NULL,
	[Ana07ID] [nvarchar](50) NULL,
	[Ana08ID] [nvarchar](50) NULL,
	[Ana09ID] [nvarchar](50) NULL,
	[Ana10ID] [nvarchar](50) NULL,
 CONSTRAINT [PK_WT0102] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
	
END
