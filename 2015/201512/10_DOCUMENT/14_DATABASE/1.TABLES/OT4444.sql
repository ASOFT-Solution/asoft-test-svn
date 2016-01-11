-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT4444]') AND type in (N'U'))
CREATE TABLE [dbo].[OT4444](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[InventoryID] [nvarchar](50) NULL,
	[InventoryName] [nvarchar](250) NULL,
	[UnitID] [nvarchar](50) NULL,
	[UnitName] [nvarchar](250) NULL,
	[Amount01] [decimal](28, 8) NULL,
	[Amount02] [decimal](28, 8) NULL,
	[Amount03] [decimal](28, 8) NULL,
	[Amount04] [decimal](28, 8) NULL,
	[Amount05] [decimal](28, 8) NULL,
	[Amount06] [decimal](28, 8) NULL,
	[Amount07] [decimal](28, 8) NULL,
	[Amount08] [decimal](28, 8) NULL,
	[Amount09] [decimal](28, 8) NULL,
	[Amount10] [decimal](28, 8) NULL,
	[Amount11] [decimal](28, 8) NULL,
	[Amount12] [decimal](28, 8) NULL,
	[Amount13] [decimal](28, 8) NULL,
	[Amount14] [decimal](28, 8) NULL,
	[Amount15] [decimal](28, 8) NULL,
	[Amount16] [decimal](28, 8) NULL,
	[Amount17] [decimal](28, 8) NULL,
	[Amount18] [decimal](28, 8) NULL,
	[Amount19] [decimal](28, 8) NULL,
	[Amount20] [decimal](28, 8) NULL,
	[Amount21] [decimal](28, 8) NULL,
	[Amount22] [decimal](28, 8) NULL,
	[Amount23] [decimal](28, 8) NULL,
	[Amount24] [decimal](28, 8) NULL,
	[Amount25] [decimal](28, 8) NULL,
	[Amount26] [decimal](28, 8) NULL,
	[Amount27] [decimal](28, 8) NULL,
	[Amount28] [decimal](28, 8) NULL,
	[Amount29] [decimal](28, 8) NULL,
	[Amount30] [decimal](28, 8) NULL,
	CONSTRAINT [PK_OT4444] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
