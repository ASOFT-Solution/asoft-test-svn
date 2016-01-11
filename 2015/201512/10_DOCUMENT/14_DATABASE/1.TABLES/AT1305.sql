-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1305]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1305](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReDeTypeID] [nvarchar](50) NOT NULL,
	[ReDeTypeName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[IsReceived] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1305] PRIMARY KEY NONCLUSTERED 
(
	[ReDeTypeID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1305_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1305] ADD CONSTRAINT [DF_AT1305_Disabled] DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1305_IsReceived]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1305] ADD CONSTRAINT [DF_AT1305_IsReceived] DEFAULT ((0)) FOR [IsReceived]
END