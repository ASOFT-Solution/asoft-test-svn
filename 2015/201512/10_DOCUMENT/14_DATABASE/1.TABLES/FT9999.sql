-- <Summary>
---- 
-- <History>
---- Create on 09/08/2010 by Ngoc Nhut
---- Modified on ... by ...
---- <Example>
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FT9999]') AND type in (N'U'))
CREATE TABLE [dbo].[FT9999](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,	
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[Closing] [tinyint] NOT NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Disabled] [tinyint] NOT NULL,
	CONSTRAINT [PK_FT9999] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_FT9999_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[FT9999] ADD  CONSTRAINT [DF_FT9999_Disabled]  DEFAULT ((0)) FOR [Disabled]
END