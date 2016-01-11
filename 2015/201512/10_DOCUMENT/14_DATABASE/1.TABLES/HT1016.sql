-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1016]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1016](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[LevelID] [tinyint] NOT NULL,
	[ProductID] [nvarchar](50) NOT NULL,
	[FromValues] [decimal](28, 8) NULL,
	[ToValues] [decimal](28, 8) NULL,
	[Amount] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT1016] PRIMARY KEY NONCLUSTERED 
(
	[LevelID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
