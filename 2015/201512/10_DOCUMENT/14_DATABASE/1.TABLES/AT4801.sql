-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT4801]') AND type in (N'U'))
CREATE TABLE [dbo].[AT4801](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Tilte] [nvarchar](250) NULL,
	[ReportID] [nvarchar](50) NULL,
	[Type] [tinyint] NOT NULL,
	[FromAccountID] [nvarchar](50) NULL,
	[ToAccountID] [nvarchar](50) NULL,
	[Selection01ID] [nvarchar](50) NULL,
	[Selection02ID] [nvarchar](50) NULL,
	[Selection03ID] [nvarchar](50) NULL,
	[Selection04ID] [nvarchar](50) NULL,
	[Level01] [nvarchar](50) NULL,
	[Level02] [nvarchar](50) NULL,
	[Level03] [nvarchar](50) NULL,
	[Level04] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[Disabled] [tinyint] NOT NULL,
 CONSTRAINT [PK_AT4801] PRIMARY KEY NONCLUSTERED 
(
	[ReportCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT4801_Type]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT4801] ADD  CONSTRAINT [DF_AT4801_Type]  DEFAULT ((0)) FOR [Type]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT4801_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT4801] ADD  CONSTRAINT [DF_AT4801_Disabled]  DEFAULT ((0)) FOR [Disabled]
END