-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT2223]') AND type in (N'U'))
CREATE TABLE [dbo].[MT2223](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[LinkNo] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[InventoryID] [nvarchar](50) NULL,
	[InventoryName] [nvarchar](250) NULL,
	[PlanQuantity] [decimal](28, 8) NULL,
	[ActualQuantity] [decimal](28, 8) NULL,
	[Parts] [int] NULL,
	[Orders] [int] NULL,
	[Description] [nvarchar](250) NULL,
	CONSTRAINT [PK_MT2223] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
