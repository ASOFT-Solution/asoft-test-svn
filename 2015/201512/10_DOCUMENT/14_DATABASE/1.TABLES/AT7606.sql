-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7606]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7606](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[LineCode] [nvarchar](50) NOT NULL,
	[LineDescription] [nvarchar](250) NULL,
	[PrintCode] [nvarchar](50) NULL,
	[Amount1] [decimal](28, 8) NULL,
	[Amount2] [decimal](28, 8) NULL,
	[Amount3] [decimal](28, 8) NULL,
	[Amount4] [decimal](28, 8) NULL,
	[Amount5] [decimal](28, 8) NULL,
	[Amount6] [decimal](28, 8) NULL,
	[AccuSign] [nvarchar](5) NULL,
	[Accumulator] [nvarchar](100) NULL,
	[Level1] [tinyint] NULL,
	[PrintStatus] [tinyint] NULL,
	[Type] [tinyint] NOT NULL,
	[LineDescriptionE] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT7606] PRIMARY KEY NONCLUSTERED 
(
	[LineCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7606_Amount1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7606] ADD  CONSTRAINT [DF_AT7606_Amount1]  DEFAULT ((0)) FOR [Amount1]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7606_Amount2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7606] ADD  CONSTRAINT [DF_AT7606_Amount2]  DEFAULT ((0)) FOR [Amount2]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7606_Amount3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7606] ADD  CONSTRAINT [DF_AT7606_Amount3]  DEFAULT ((0)) FOR [Amount3]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7606_Amount4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7606] ADD  CONSTRAINT [DF_AT7606_Amount4]  DEFAULT ((0)) FOR [Amount4]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7606_Amount5]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7606] ADD  CONSTRAINT [DF_AT7606_Amount5]  DEFAULT ((0)) FOR [Amount5]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7606_Amount6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7606] ADD  CONSTRAINT [DF_AT7606_Amount6]  DEFAULT ((0)) FOR [Amount6]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7606_PrintStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7606] ADD  CONSTRAINT [DF_AT7606_PrintStatus]  DEFAULT ((1)) FOR [PrintStatus]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7606_Type]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7606] ADD  CONSTRAINT [DF_AT7606_Type]  DEFAULT ((2)) FOR [Type]
END

