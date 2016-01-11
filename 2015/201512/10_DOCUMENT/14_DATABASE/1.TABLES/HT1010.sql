﻿-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1010]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1010](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PoliticsID] [nvarchar](50) NOT NULL,
	[PoliticsName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateUserID] [nvarchar](50) NOT NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NOT NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT1010] PRIMARY KEY NONCLUSTERED 
(
	[PoliticsID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1010_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1010] ADD  CONSTRAINT [DF_HT1010_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1010_LastModifyDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1010] ADD  CONSTRAINT [DF_HT1010_LastModifyDate]  DEFAULT (getdate()) FOR [LastModifyDate]
END
