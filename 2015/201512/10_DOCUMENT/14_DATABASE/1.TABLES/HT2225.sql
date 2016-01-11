-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2225]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2225](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[Orders] [int] NOT NULL,
	[Bold] [tinyint] NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Step] [tinyint] NULL,
	[Code] [nvarchar](50) NULL,
	[Code0] [nvarchar](50) NULL,
	[Sign] [numeric](18, 0) NOT NULL,
	[Amount1] [decimal](28, 8) NULL,
	[Amount2] [decimal](28, 8) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL
CONSTRAINT [PK_HT2225] PRIMARY KEY CLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2225_Bold_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2225] ADD  CONSTRAINT [DF_HT2225_Bold_1]  DEFAULT ((0)) FOR [Bold]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2225_Step]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2225] ADD  CONSTRAINT [DF_HT2225_Step]  DEFAULT ((9)) FOR [Step]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2225_Sign]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2225] ADD  CONSTRAINT [DF_HT2225_Sign]  DEFAULT ((1)) FOR [Sign]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2225_Amount1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2225] ADD  CONSTRAINT [DF_HT2225_Amount1]  DEFAULT ((0)) FOR [Amount1]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2225_Amount2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2225] ADD  CONSTRAINT [DF_HT2225_Amount2]  DEFAULT ((0)) FOR [Amount2]
END
