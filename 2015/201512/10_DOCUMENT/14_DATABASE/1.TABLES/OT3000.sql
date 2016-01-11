-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT3000]') AND type in (N'U'))
CREATE TABLE [dbo].[OT3000](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[WareHouseID] [nvarchar](50) NOT NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[ActualQuantity] [decimal](28, 8) NOT NULL,
	[SOQuantity] [decimal](28, 8) NOT NULL,
	[POQuantity] [decimal](28, 8) NOT NULL,
 CONSTRAINT [PK_OT3000] PRIMARY KEY NONCLUSTERED 
(
	[WareHouseID] ASC,
	[InventoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT3000_ActualQuantity]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT3000] ADD  CONSTRAINT [DF_OT3000_ActualQuantity]  DEFAULT ((0)) FOR [ActualQuantity]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT3000_SOQuantity]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT3000] ADD  CONSTRAINT [DF_OT3000_SOQuantity]  DEFAULT ((0)) FOR [SOQuantity]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT3000_POQuantity]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT3000] ADD  CONSTRAINT [DF_OT3000_POQuantity]  DEFAULT ((0)) FOR [POQuantity]
END