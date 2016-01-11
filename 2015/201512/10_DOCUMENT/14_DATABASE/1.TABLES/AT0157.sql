-- <Summary>
---- 
-- <History>
---- Create on 04/01/2016 by Bảo Anh: Danh mục máy (detail)
---- Modified on ... by ...

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0157]') AND type in (N'U'))
CREATE TABLE [dbo].[AT0157](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[CombineID] [nvarchar](50) NOT NULL,
	[Orders] [int] NULL,
	[GroupID] [nvarchar](50) NULL,
	[TypeID] [nvarchar](50) NULL,
	[DetailTypeID] [nvarchar](50) NULL,
	[UnitOrMaterial] [nvarchar](50) NULL,
	[Value] [nvarchar](250) NULL,
	
 CONSTRAINT [PK_AT0157] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]