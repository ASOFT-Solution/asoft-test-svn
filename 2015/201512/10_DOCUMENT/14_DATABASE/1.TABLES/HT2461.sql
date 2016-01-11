-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2461]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2461](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[InSurID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[DepartmentID] [nvarchar](50) NOT NULL,
	[TeamID] [nvarchar](50) NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[CalDate] [datetime] NULL,
	[BaseSalaryFieldID] [nvarchar](50) NULL,
	[IsGeneralCo] [tinyint] NULL,
	[GeneralCoID] [nvarchar](50) NULL,
	[GeneralCo] [decimal](28, 8) NULL,
	[BaseSalary] [decimal](28, 8) NULL,
	[IsGeneralAbsent] [tinyint] NULL,
	[GeneralAbentID] [nvarchar](50) NULL,
	[GeneralAbsent] [decimal](28, 8) NULL,
	[AbsentAmount] [decimal](28, 8) NULL,
	[SRate] [decimal](28, 8) NULL,
	[HRate] [decimal](28, 8) NULL,
	[TRate] [decimal](28, 8) NULL,
	[SRate2] [decimal](28, 8) NULL,
	[HRate2] [decimal](28, 8) NULL,
	[TRate2] [decimal](28, 8) NULL,
	[SAmount] [decimal](28, 8) NULL,
	[HAmount] [decimal](28, 8) NULL,
	[TAmount] [decimal](28, 8) NULL,
	[SAmount2] [decimal](28, 8) NULL,
	[HAmount2] [decimal](28, 8) NULL,
	[TAmount2] [decimal](28, 8) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT2461] PRIMARY KEY NONCLUSTERED 
(
	[InSurID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_IsGeneralCo]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_IsGeneralCo]  DEFAULT ((0)) FOR [IsGeneralCo]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_GeneralCo]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_GeneralCo]  DEFAULT ((1)) FOR [GeneralCo]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_BaseSalary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_BaseSalary]  DEFAULT ((0)) FOR [BaseSalary]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_SRate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_SRate]  DEFAULT ((0)) FOR [SRate]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_HRate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_HRate]  DEFAULT ((0)) FOR [HRate]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_TRate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_TRate]  DEFAULT ((0)) FOR [TRate]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_SRate2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_SRate2]  DEFAULT ((0)) FOR [SRate2]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_HRate2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_HRate2]  DEFAULT ((0)) FOR [HRate2]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_TRate2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_TRate2]  DEFAULT ((0)) FOR [TRate2]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_SAmount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_SAmount]  DEFAULT ((0)) FOR [SAmount]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_HAmount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_HAmount]  DEFAULT ((0)) FOR [HAmount]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_TAmount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_TAmount]  DEFAULT ((0)) FOR [TAmount]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_SAmount2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_SAmount2]  DEFAULT ((0)) FOR [SAmount2]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_HAmount2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_HAmount2]  DEFAULT ((0)) FOR [HAmount2]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2461_TAmount2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2461] ADD  CONSTRAINT [DF_HT2461_TAmount2]  DEFAULT ((0)) FOR [TAmount2]
END
---- Add Columns
-- Thêm cột SuggestSalary vào bảng HT2460
IF(ISNULL(COL_LENGTH('HT2460', 'SuggestSalary'), 0) <= 0)
ALTER TABLE HT2460 ADD SuggestSalary nvarchar(50) NULL 



