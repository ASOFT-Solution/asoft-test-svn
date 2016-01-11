-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT5554]') AND type in (N'U'))
CREATE TABLE [dbo].[AT5554](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ModuleID] [nvarchar](50) NOT NULL,
	[FieldID] [nvarchar](500) NOT NULL,
	[Description] [nvarchar](250) NOT NULL,
	[DescriptionE] [nvarchar](250) NOT NULL,
	[DataType] [nvarchar](50) NOT NULL,
	[Orders] [int] NOT NULL,
	CONSTRAINT [PK_AT5554] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


