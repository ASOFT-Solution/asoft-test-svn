-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1505]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1505](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[S] [nvarchar](50) NOT NULL,
	[STypeID] [nvarchar](50) NOT NULL,
	[SName] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[Disabled] [tinyint] NOT NULL,
 CONSTRAINT [PK_AT1505] PRIMARY KEY CLUSTERED 
(
	[S] ASC,
	[STypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1505_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1505] ADD  CONSTRAINT [DF_AT1505_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
