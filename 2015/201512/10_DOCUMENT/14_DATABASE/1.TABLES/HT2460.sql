-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2460]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2460](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[InsurFileID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[DepartmentID] [nvarchar](50) NOT NULL,
	[TeamID] [nvarchar](50) NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[SNo] [nvarchar](50) NULL,
	[SBeginDate] [datetime] NULL,
	[HNo] [nvarchar](50) NULL,
	[HFromDate] [datetime] NULL,
	[HToDate] [datetime] NULL,
	[CNo] [nvarchar](50) NULL,
	[CFromDate] [datetime] NULL,
	[CToDate] [datetime] NULL,
	[HospitalID] [nvarchar](50) NULL,
	[Basesalary] [decimal](28, 8) NULL,
	[InsuranceSalary] [decimal](28, 8) NULL,
	[Salary01] [decimal](28, 8) NULL,
	[Salary02] [decimal](28, 8) NULL,
	[Salary03] [decimal](28, 8) NULL,
	[IsS] [tinyint] NOT NULL,
	[IsH] [tinyint] NOT NULL,
	[IsT] [tinyint] NOT NULL,
	[Notes] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	CONSTRAINT [PK_HT2460] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2460_Basesalary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2460] ADD  CONSTRAINT [DF_HT2460_Basesalary]  DEFAULT ((0)) FOR [Basesalary]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2460_InsuranceSalary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2460] ADD  CONSTRAINT [DF_HT2460_InsuranceSalary]  DEFAULT ((0)) FOR [InsuranceSalary]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2460_Salary01]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2460] ADD  CONSTRAINT [DF_HT2460_Salary01]  DEFAULT ((0)) FOR [Salary01]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2460_Salary02]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2460] ADD  CONSTRAINT [DF_HT2460_Salary02]  DEFAULT ((0)) FOR [Salary02]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2460]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2460] ADD  CONSTRAINT [DF_HT2460]  DEFAULT ((0)) FOR [Salary03]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2460_IsS]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2460] ADD  CONSTRAINT [DF_HT2460_IsS]  DEFAULT ((1)) FOR [IsS]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2460_IsH]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2460] ADD  CONSTRAINT [DF_HT2460_IsH]  DEFAULT ((1)) FOR [IsH]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2460_IsT]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2460] ADD  CONSTRAINT [DF_HT2460_IsT]  DEFAULT ((1)) FOR [IsT]
END