-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2227]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2227](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TranYear] [int] NOT NULL,
	[TranQuater] [int] NOT NULL,
	[TranMonth] [int] NOT NULL,
	[Status] [int] NULL,
	[Orders] [int] NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Amount1] [decimal](28, 8) NOT NULL,
	[Amount2] [decimal](28, 8) NOT NULL,
	[Amount3] [decimal](28, 8) NOT NULL,
	[Bold] [tinyint] NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	CONSTRAINT [PK_HT2227] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2227_Orders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2227] ADD  CONSTRAINT [DF_HT2227_Orders]  DEFAULT ((0)) FOR [Orders]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2227_Amount1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2227] ADD  CONSTRAINT [DF_HT2227_Amount1]  DEFAULT ((0)) FOR [Amount1]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2227_Amount2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2227] ADD  CONSTRAINT [DF_HT2227_Amount2]  DEFAULT ((0)) FOR [Amount2]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2227_Amount3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2227] ADD  CONSTRAINT [DF_HT2227_Amount3]  DEFAULT ((0)) FOR [Amount3]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2227_Bold]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2227] ADD  CONSTRAINT [DF_HT2227_Bold]  DEFAULT ((0)) FOR [Bold]
END