-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2223]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2223](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[Orders] [int] NOT NULL,
	[Bold] [tinyint] NULL,
	[Frame] [tinyint] NULL,
	[Step] [int] NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Code0] [nvarchar](50) NULL,
	[Sign] [numeric](18, 0) NOT NULL,
	[Caption1] [nvarchar](250) NULL,
	[Caption2] [nvarchar](250) NULL,
	[Amount1] [decimal](28, 8) NULL,
	[Amount2] [decimal](28, 8) NULL,
	[FCaption1] [nvarchar](250) NULL,
	[FCaption2] [nvarchar](250) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT2223] PRIMARY KEY CLUSTERED 
(
	[Code] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2223_Bold_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2223] ADD  CONSTRAINT [DF_HT2223_Bold_1]  DEFAULT ((0)) FOR [Bold]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2223_Frame_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2223] ADD  CONSTRAINT [DF_HT2223_Frame_1]  DEFAULT ((0)) FOR [Frame]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2223_Step]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2223] ADD  CONSTRAINT [DF_HT2223_Step]  DEFAULT ((9)) FOR [Step]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2223_Sign]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2223] ADD  CONSTRAINT [DF_HT2223_Sign]  DEFAULT ((1)) FOR [Sign]
END

