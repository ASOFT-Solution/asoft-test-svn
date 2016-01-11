-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1331]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1331](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[HistoryID] [nvarchar](50) NOT NULL,
	[CourseID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[JoinDays] [int] NULL,
	[Marks] [decimal](28, 8) NULL,
	[Result] [int] NULL,
	[Notes] [nvarchar](250) NULL,
	[CreateUserID] [nvarchar](50) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT1331] PRIMARY KEY CLUSTERED 
(
	[HistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1311_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1331] ADD  CONSTRAINT [DF_HT1311_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1311_LastModifyDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1331] ADD  CONSTRAINT [DF_HT1311_LastModifyDate]  DEFAULT (getdate()) FOR [LastModifyDate]
END
