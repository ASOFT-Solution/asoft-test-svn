-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT2009]') AND type in (N'U'))
CREATE TABLE [dbo].[OT2009](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[SOrderID] [nvarchar](50) NOT NULL,	
	[InventoryID] [nvarchar](50) NOT NULL,
	[OrderQuantity] [decimal](28, 8) NULL,
	[ActualQuantity] [decimal](28, 8) NULL,
	[AdjustQuantity] [decimal](28, 8) NULL,
 CONSTRAINT [PK_OT2011] PRIMARY KEY NONCLUSTERED 
(
	[SOrderID] ASC,
	[DivisionID] ASC,
	[InventoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
