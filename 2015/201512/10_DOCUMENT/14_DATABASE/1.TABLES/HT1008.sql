-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1008]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1008](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[BankID] [nvarchar](50) NOT NULL,
	[BankName] [nvarchar](250) NULL,
	[Address] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NOT NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT1008] PRIMARY KEY NONCLUSTERED 
(
	[BankID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1008_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1008] ADD  CONSTRAINT [DF_HT1008_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1008_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1008] ADD  CONSTRAINT [DF_HT1008_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1008_LastModifyDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1008] ADD  CONSTRAINT [DF_HT1008_LastModifyDate]  DEFAULT (getdate()) FOR [LastModifyDate]
END