-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT3337]') AND type in (N'U'))
CREATE TABLE [dbo].[AT3337](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[HideID] [nvarchar](50) NOT NULL,
	[WareHouseID] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[InventoryID] [nvarchar](50) NULL,
	[Quantity] [decimal](28, 8) NULL,
 CONSTRAINT [PK_AT3337] PRIMARY KEY CLUSTERED 
(
	[HideID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

