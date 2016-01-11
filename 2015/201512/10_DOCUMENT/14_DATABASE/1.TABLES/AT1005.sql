-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on ... by ...
-- <Example>
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1005]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT1005](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[AccountID] [nvarchar](50) NOT NULL,
	[AccountName] [nvarchar](250) NULL,
	[Notes1] [nvarchar](250) NULL,
	[Notes2] [nvarchar](250) NULL,
	[GroupID] [nvarchar](50) NULL,
	[SubGroupID] [nvarchar](50) NULL,
	[IsBalance] [tinyint] NOT NULL,
	[IsDebitBalance] [tinyint] NOT NULL,
	[IsObject] [tinyint] NOT NULL,
	[IsNotShow] [tinyint] NOT NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[AccountNameE] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT1005] PRIMARY KEY NONCLUSTERED 
(
	[AccountID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add giá trị default 
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1005_IsBalance]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1005] ADD  CONSTRAINT [DF_AT1005_IsBalance]  DEFAULT ((0)) FOR [IsBalance]
END
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1005_IsDebitBalance]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1005] ADD  CONSTRAINT [DF_AT1005_IsDebitBalance]  DEFAULT ((0)) FOR [IsDebitBalance]
END
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1005_IsObject]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1005] ADD  CONSTRAINT [DF_AT1005_IsObject]  DEFAULT ((0)) FOR [IsObject]
END
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1005_IsNotShow]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1005] ADD  CONSTRAINT [DF_AT1005_IsNotShow]  DEFAULT ((0)) FOR [IsNotShow]
END
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1005_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1005] ADD  CONSTRAINT [DF_AT1005_Disabled]  DEFAULT ((0)) FOR [Disabled]
END


