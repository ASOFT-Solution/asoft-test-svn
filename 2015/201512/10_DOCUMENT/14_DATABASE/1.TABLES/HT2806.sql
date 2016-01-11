-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2806]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2806](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[LoaCondID] [nvarchar](50) NOT NULL,
	[LoaCondName] [nvarchar](250) NULL,
	[MinWorkPeriod] [int] NULL,
	[DaysAllowed] [decimal](28, 8) NULL,
	[Disabled] [tinyint] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[IsManage] [tinyint] NOT NULL,
	CONSTRAINT [PK_HT2806] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT2806__IsManage__1567D0E0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2806] ADD  CONSTRAINT [DF__HT2806__IsManage__1567D0E0]  DEFAULT ((1)) FOR [IsManage]
END