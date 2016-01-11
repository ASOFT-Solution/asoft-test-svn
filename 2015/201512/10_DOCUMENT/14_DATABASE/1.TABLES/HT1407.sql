-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1407]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1407](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[AbsentCardID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[AbsentCardNo] [nvarchar](50) NOT NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Notes] [nvarchar](250) NULL,
	[IsCurrent] [tinyint] NOT NULL,
 CONSTRAINT [PK_HT1407] PRIMARY KEY NONCLUSTERED 
(
	[AbsentCardID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT1407__IsCurren__713F7F03]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1407] ADD  CONSTRAINT [DF__HT1407__IsCurren__713F7F03]  DEFAULT ((0)) FOR [IsCurrent]
END