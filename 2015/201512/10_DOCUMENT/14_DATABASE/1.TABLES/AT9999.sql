-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT9999]') AND type in (N'U'))
CREATE TABLE [dbo].[AT9999](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] nvarchar(3) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[Closing] [tinyint] NOT NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Disabled] [tinyint] NOT NULL,
CONSTRAINT [PK_AT9999] PRIMARY KEY NONCLUSTERED 
(
	[DivisionID] ASC,
	[TranMonth] ASC,
	[TranYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT9999_Closing]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT9999] ADD  CONSTRAINT [DF_AT9999_Closing]  DEFAULT ((0)) FOR [Closing]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT9999__Disabled__540B161C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT9999] ADD  CONSTRAINT [DF__AT9999__Disabled__540B161C]  DEFAULT ((0)) FOR [Disabled]
END
