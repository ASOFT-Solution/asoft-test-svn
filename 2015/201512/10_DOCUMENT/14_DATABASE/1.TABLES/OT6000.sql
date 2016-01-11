-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT6000]') AND type in (N'U'))
CREATE TABLE [dbo].[OT6000](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ScreenID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[SQLString] [nvarchar](500) NULL,
	[OrderBy] [nvarchar](100) NULL,
	[Orders] [int] NULL,
	[Disabled] [tinyint] NOT NULL,
	CONSTRAINT [PK_OT6000] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT6000_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT6000] ADD  CONSTRAINT [DF_OT6000_Disabled]  DEFAULT ((0)) FOR [Disabled]
END