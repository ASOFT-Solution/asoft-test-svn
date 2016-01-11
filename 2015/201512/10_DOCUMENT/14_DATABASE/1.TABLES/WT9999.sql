-- <Summary>
---- 
-- <History>
---- Create on 09/08/2010 by Ngoc Nhut
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WT9999]') AND type in (N'U'))
CREATE TABLE [dbo].[WT9999](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[Closing] [tinyint] NOT NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Disabled] [tinyint] NOT NULL,
 CONSTRAINT [PK_WT9999] PRIMARY KEY NONCLUSTERED 
(
	[DivisionID] ASC,
	[TranMonth] ASC,
	[TranYear] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_WT9999_Closing]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[WT9999] ADD  CONSTRAINT [DF_WT9999_Closing]  DEFAULT ((0)) FOR [Closing]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__WT9999__Disabled__540B161C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[WT9999] ADD  CONSTRAINT [DF__WT9999__Disabled__540B161C]  DEFAULT ((0)) FOR [Disabled]
END
