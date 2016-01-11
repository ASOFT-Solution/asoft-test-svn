-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on ... by ...
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1006]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT1006](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[GroupID] [nvarchar](50) NOT NULL,
	[GroupName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[GroupNameE] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT1006] PRIMARY KEY NONCLUSTERED 
(
	[GroupID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1006_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1006] ADD  CONSTRAINT [DF_AT1006_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
