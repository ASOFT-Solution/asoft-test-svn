-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1111]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1111](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ObjectID] [nvarchar](50) NOT NULL,
	[ObjectName] [nvarchar](250) NULL,
	[Description] [nvarchar](50) NULL,
	[Type] [nvarchar](50) NULL,
	[Disabled] [tinyint] NOT NULL,
	[IsData] [tinyint] NOT NULL,
 CONSTRAINT [PK_AT1111] PRIMARY KEY NONCLUSTERED 
(
	[ObjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1111_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1111] ADD  CONSTRAINT [DF_AT1111_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1111_IsData]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1111] ADD  CONSTRAINT [DF_AT1111_IsData]  DEFAULT ((0)) FOR [IsData]
END

