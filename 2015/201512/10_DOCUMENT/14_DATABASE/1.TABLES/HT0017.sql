-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0017]') AND type in (N'U'))
CREATE TABLE [dbo].[HT0017](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ParaID] [nvarchar](50) NOT NULL,
	[Parameter] [nvarchar](50) NOT NULL,
	[ParameterE] [nvarchar](50) NULL,
	[Position] [int] NOT NULL,
	[Width] [int] NULL,
	[IsUsed] [tinyint] NOT NULL,
	[ViewIndex] [int] NOT NULL,
 CONSTRAINT [PK_HT0017] PRIMARY KEY CLUSTERED 
(
	[ParaID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0017_Position]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0017] ADD  CONSTRAINT [DF_HT0017_Position]  DEFAULT ((0)) FOR [Position]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0017_Width]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0017] ADD  CONSTRAINT [DF_HT0017_Width]  DEFAULT ((2)) FOR [Width]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0017_IsUsed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0017] ADD  CONSTRAINT [DF_HT0017_IsUsed]  DEFAULT ((1)) FOR [IsUsed]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0017_ViewIndex]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0017] ADD  CONSTRAINT [DF_HT0017_ViewIndex]  DEFAULT ((0)) FOR [ViewIndex]
END

