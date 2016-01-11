-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1370]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1370](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[AccidentID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[AccidentTime] [nvarchar](100) NULL,
	[AccidentDate] [datetime] NULL,
	[AccidentPlace] [nvarchar](250) NULL,
	[Wounds] [nvarchar](100) NULL,
	[Status01] [tinyint] NOT NULL,
	[Status02] [tinyint] NOT NULL,
	[Status03] [tinyint] NOT NULL,
	[Status04] [tinyint] NOT NULL,
	[Status05] [tinyint] NOT NULL,
	[Cause01] [tinyint] NOT NULL,
	[Cause02] [tinyint] NOT NULL,
	[Cause03] [tinyint] NOT NULL,
	[Cause04] [tinyint] NOT NULL,
	[Cause05] [tinyint] NOT NULL,
	[Cause06] [tinyint] NOT NULL,
	[Cause07] [tinyint] NOT NULL,
	[Cause08] [tinyint] NOT NULL,
	[Cause09] [tinyint] NOT NULL,
	[OtherCause] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[Leaves] [int] NULL,
	[ActualLeaves] [int] NULL,
	[ReturnDate] [datetime] NULL,
	[HospitalFees] [decimal](28, 8) NULL,
	[AccSalary] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT1370] PRIMARY KEY CLUSTERED 
(
	[AccidentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1370_Status01]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1370] ADD  CONSTRAINT [DF_HT1370_Status01]  DEFAULT ((0)) FOR [Status01]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1370_Status02]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1370] ADD  CONSTRAINT [DF_HT1370_Status02]  DEFAULT ((0)) FOR [Status02]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1370_Status03]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1370] ADD  CONSTRAINT [DF_HT1370_Status03]  DEFAULT ((0)) FOR [Status03]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1370_Status04]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1370] ADD  CONSTRAINT [DF_HT1370_Status04]  DEFAULT ((0)) FOR [Status04]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1370_Status05]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1370] ADD  CONSTRAINT [DF_HT1370_Status05]  DEFAULT ((0)) FOR [Status05]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1370_Cause01]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1370] ADD  CONSTRAINT [DF_HT1370_Cause01]  DEFAULT ((0)) FOR [Cause01]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1370_Cause02]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1370] ADD  CONSTRAINT [DF_HT1370_Cause02]  DEFAULT ((0)) FOR [Cause02]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1370_Cause03]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1370] ADD  CONSTRAINT [DF_HT1370_Cause03]  DEFAULT ((0)) FOR [Cause03]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1370_Cause04]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1370] ADD  CONSTRAINT [DF_HT1370_Cause04]  DEFAULT ((0)) FOR [Cause04]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1370_Cause05]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1370] ADD  CONSTRAINT [DF_HT1370_Cause05]  DEFAULT ((0)) FOR [Cause05]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1370_Cause06]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1370] ADD  CONSTRAINT [DF_HT1370_Cause06]  DEFAULT ((0)) FOR [Cause06]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1370_Cause07]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1370] ADD  CONSTRAINT [DF_HT1370_Cause07]  DEFAULT ((0)) FOR [Cause07]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1370_Cause08]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1370] ADD  CONSTRAINT [DF_HT1370_Cause08]  DEFAULT ((0)) FOR [Cause08]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1370_Cause09]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1370] ADD  CONSTRAINT [DF_HT1370_Cause09]  DEFAULT ((0)) FOR [Cause09]
END
