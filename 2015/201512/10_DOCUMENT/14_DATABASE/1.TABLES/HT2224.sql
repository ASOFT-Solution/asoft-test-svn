-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2224]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2224](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TranYear] [int] NOT NULL,
	[TranQuater] [int] NOT NULL,
	[TranMonth] [int] NOT NULL,
	[Amount1] [decimal](28, 8) NOT NULL,
	[Amount2] [decimal](28, 8) NOT NULL,
	[Amount3] [decimal](28, 8) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT2224] PRIMARY KEY NONCLUSTERED 
(
	[DivisionID] ASC,
	[TranYear] ASC,
	[TranQuater] ASC,
	[TranMonth] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2224_Amount1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2224] ADD  CONSTRAINT [DF_HT2224_Amount1]  DEFAULT ((0)) FOR [Amount1]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2224_Amount2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2224] ADD  CONSTRAINT [DF_HT2224_Amount2]  DEFAULT ((0)) FOR [Amount2]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2224_Amount3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2224] ADD  CONSTRAINT [DF_HT2224_Amount3]  DEFAULT ((0)) FOR [Amount3]
END
