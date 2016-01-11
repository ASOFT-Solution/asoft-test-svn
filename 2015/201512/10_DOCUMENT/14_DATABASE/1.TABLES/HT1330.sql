-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1330]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1330](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[CourseID] [nvarchar](50) NOT NULL,
	[CourseName] [nvarchar](250) NULL,
	[SchoolID] [nvarchar](50) NULL,
	[MajorID] [nvarchar](50) NULL,
	[TypeID] [int] NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Status] [int] NULL,
	[Notes] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateUserID] [nvarchar](50) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT1310] PRIMARY KEY CLUSTERED 
(
	[CourseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1310_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1330] ADD  CONSTRAINT [DF_HT1310_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1310_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1330] ADD  CONSTRAINT [DF_HT1310_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1310_LastModifyDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1330] ADD  CONSTRAINT [DF_HT1310_LastModifyDate]  DEFAULT (getdate()) FOR [LastModifyDate]
END