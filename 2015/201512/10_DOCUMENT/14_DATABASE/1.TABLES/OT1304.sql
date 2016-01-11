-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT1304]') AND type in (N'U'))
CREATE TABLE [dbo].[OT1304](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[DetailID] [nvarchar](50) NOT NULL,
	[ID] [nvarchar](50) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[MinQuantity] [decimal](28, 8) NULL,
	[MaxQuantity] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
	[Orders] [int] NULL,
 CONSTRAINT [PK_OT1304] PRIMARY KEY CLUSTERED 
(
	[DetailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
