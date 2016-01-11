-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1404]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1404](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[RelationID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[RelationName] [nvarchar](250) NULL,
	[RelationDate] [datetime] NULL,
	[RelationAddress] [nvarchar](250) NULL,
	[RelationPhone] [nvarchar](100) NULL,
	[RelationType] [tinyint] NULL,
	[Notes] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT1404] PRIMARY KEY NONCLUSTERED 
(
	[RelationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1404_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1404] ADD  CONSTRAINT [DF_HT1404_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1404_LastModifyDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1404] ADD  CONSTRAINT [DF_HT1404_LastModifyDate]  DEFAULT (getdate()) FOR [LastModifyDate]
END