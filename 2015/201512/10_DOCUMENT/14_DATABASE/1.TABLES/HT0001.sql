-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0001]') AND type in (N'U'))
CREATE TABLE [dbo].[HT0001](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TargetTypeID] [nvarchar](50) NOT NULL,
	[TargetName] [nvarchar](250) NULL,
	[Caption] [nvarchar](250) NULL,
	[IsUsed] [tinyint] NOT NULL,
	[IsAmount] [tinyint] NOT NULL,
 CONSTRAINT [PK_HT0001] PRIMARY KEY NONCLUSTERED 
(
	[TargetTypeID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0001_IsUsed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0001] ADD  CONSTRAINT [DF_HT0001_IsUsed]  DEFAULT ((0)) FOR [IsUsed]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0001_IsAmount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0001] ADD  CONSTRAINT [DF_HT0001_IsAmount]  DEFAULT ((0)) FOR [IsAmount]
END