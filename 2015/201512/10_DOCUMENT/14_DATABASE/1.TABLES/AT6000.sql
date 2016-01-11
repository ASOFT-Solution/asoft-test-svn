-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT6000]') AND type in (N'U'))
CREATE TABLE [dbo].[AT6000](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Type] [tinyint] NOT NULL,
	[Orders] [tinyint] NOT NULL,
	[Disabled] [tinyint] NOT NULL,
	[IsASOFTFA] [tinyint] NULL,
	[DescriptionE] [nvarchar](250) NULL,
	CONSTRAINT [PK_AT6000] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT6000_Type]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6000] ADD  CONSTRAINT [DF_AT6000_Type]  DEFAULT ((0)) FOR [Type]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT6000_Orders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6000] ADD  CONSTRAINT [DF_AT6000_Orders]  DEFAULT ((0)) FOR [Orders]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT6000__Disabled__661FD680]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6000] ADD  CONSTRAINT [DF__AT6000__Disabled__661FD680]  DEFAULT ((0)) FOR [Disabled]
END
