-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2222]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2222](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TablesName] [nvarchar](250) NULL,
	[Description] [nvarchar](250) NULL,
	[FieldID] [nvarchar](50) NOT NULL,
	[Type] [tinyint] NULL,
	[Orders] [tinyint] NULL,
	[Disabled] [tinyint] NOT NULL,
 CONSTRAINT [PK_HT2222] PRIMARY KEY CLUSTERED 
(
	[FieldID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2222_Type]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2222] ADD  CONSTRAINT [DF_HT2222_Type]  DEFAULT ((0)) FOR [Type]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2222_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2222] ADD  CONSTRAINT [DF_HT2222_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
