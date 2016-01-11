-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT0811]') AND type in (N'U'))
CREATE TABLE [dbo].[MT0811](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ResultTypeID] [nvarchar](50) NOT NULL,
	[ResultTypeName] [nvarchar](250) NOT NULL,
	[InventoryTypeCaption] [nvarchar](100) NULL,
	[InventoryCaption] [nvarchar](100) NULL,
	[DefaultTypeID] [nvarchar](50) NULL,
	[ResultOrder] [tinyint] NULL,
	[Type] [tinyint] NOT NULL,
	[ResultTypeNameOther] [nvarchar](50) NULL,
	[InventoryTypeOther] [nvarchar](50) NULL,
	[InventoryOther] [nvarchar](50) NULL,
 CONSTRAINT [PK_MT0811] PRIMARY KEY NONCLUSTERED 
(
	[ResultTypeID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
