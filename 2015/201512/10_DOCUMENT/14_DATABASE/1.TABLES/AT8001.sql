-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT8001]') AND type in (N'U'))
CREATE TABLE [dbo].[AT8001](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Language] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Disabled] [tinyint] NULL,
CONSTRAINT [PK_AT8001] PRIMARY KEY NONCLUSTERED 
(
	[Code] ASC,
	[Type] ASC,
	[Language] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT8001_Language]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT8001] ADD  CONSTRAINT [DF_AT8001_Language]  DEFAULT ('84') FOR [Language]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT8001_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT8001] ADD  CONSTRAINT [DF_AT8001_Disabled]  DEFAULT ((0)) FOR [Disabled]
END