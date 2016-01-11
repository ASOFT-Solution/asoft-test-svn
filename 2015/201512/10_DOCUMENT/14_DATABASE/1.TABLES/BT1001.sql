-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BT1001]') AND type in (N'U'))
CREATE TABLE [dbo].[BT1001](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[SeriID] [nvarchar](50) NOT NULL,
	[TableID] [nvarchar](50) NULL,
	[VoucherID] [nvarchar](50) NULL,
	[TransactionID] [nvarchar](50) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[Orders] [int] NULL,
	[SeriNo] [nvarchar](50) NULL,
CONSTRAINT [PK_BT1001] PRIMARY KEY CLUSTERED 
(
	[SeriID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
