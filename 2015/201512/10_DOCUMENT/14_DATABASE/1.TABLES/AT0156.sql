-- <Summary>
---- 
-- <History>
---- Create on 04/01/2016 by Bảo Anh: Danh mục máy (master)
---- Modified on ... by ...

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0156]') AND type in (N'U'))
CREATE TABLE [dbo].[AT0156](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[CombineID] [nvarchar](50) NOT NULL,
	[CombineName] [nvarchar](50) NULL,
	[MachineID] [nvarchar](50) NULL,
	[BlockID] [nvarchar](50) NULL,
	[MachineNo] [nvarchar](3) NULL,
	[ProductID] [nvarchar](50) NULL,
	[CavityNo] [tinyint] NULL,
	[Pressure] [tinyint] NULL,
	[Weight] [decimal] (28,8) NULL,
	[ProductQty] [decimal] (28,8) NULL,
	[BlockTypeID] [nvarchar] (1) NULL,
	[Notes] [nvarchar] (250) NULL,
	[Disabled] [tinyint] NULL,

 CONSTRAINT [PK_AT0156] PRIMARY KEY NONCLUSTERED 
(
	[DivisionID] ASC,
	[CombineID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]