-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT1001]') AND type in (N'U'))
CREATE TABLE [dbo].[OT1001](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ClassifyID] [nvarchar](50) NOT NULL,
	[TypeID] [nvarchar](50) NOT NULL,
	[ClassifyName] [nvarchar](250) NOT NULL,
	[Note] [nvarchar](250) NULL,
	[Disabled] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	CONSTRAINT [PK_OT1001] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT1001_TypeID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT1001] ADD  CONSTRAINT [DF_OT1001_TypeID]  DEFAULT ('SO') FOR [TypeID]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT1001_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT1001] ADD  CONSTRAINT [DF_OT1001_Disabled]  DEFAULT ((0)) FOR [Disabled]
END