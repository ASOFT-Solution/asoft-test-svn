-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1408]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1408](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[DataTypeID] [nvarchar](50) NOT NULL,
	[DataTypeName] [nvarchar](250) NULL,
	[DataTypeNameE] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT1408] PRIMARY KEY CLUSTERED 
(
	[DataTypeID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

