-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1102]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1102](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[DutyID] [nvarchar](50) NOT NULL,
	[DutyName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateUserID] [nvarchar](50) NOT NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NOT NULL,
	[LastModifyDate] [datetime] NULL,
	[DutyRate] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT1102] PRIMARY KEY NONCLUSTERED 
(
	[DutyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1102_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1102] ADD  CONSTRAINT [DF_HT1102_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1102_LastModifyDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1102] ADD  CONSTRAINT [DF_HT1102_LastModifyDate]  DEFAULT (getdate()) FOR [LastModifyDate]
END