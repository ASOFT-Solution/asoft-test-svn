-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1000]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1000](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[MethodID] [nvarchar](50) NOT NULL,
	[SystemName] [nvarchar](250) NULL,
	[UserName] [nvarchar](250) NULL,
	[Description] [nvarchar](250) NULL,
	[IsDivision] [tinyint] NOT NULL,
	[IsUsed] [tinyint] NULL,
 CONSTRAINT [PK_HT1000] PRIMARY KEY NONCLUSTERED 
(
	[MethodID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1000_IsDivision]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1000] ADD  CONSTRAINT [DF_HT1000_IsDivision]  DEFAULT ((0)) FOR [IsDivision]
END