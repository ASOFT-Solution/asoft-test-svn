-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2809]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2809](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmpLoaMonthID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[EmployeeStatus] [tinyint] NULL,
	[LeaveDate] [datetime] NULL,
	[LoaCondID] [nvarchar](50) NULL,
	[DaysPrevYear] [decimal](28, 8) NULL,
	[DaysInYear] [decimal](28, 8) NULL,
	[DaysAllowed] [decimal](28, 8) NULL,
	[DaysSpent] [decimal](28, 8) NULL,
	[GeneralAbsentID] [nvarchar](50) NULL,
	[WorkDate] [datetime] NULL,
	[BeginDate] [datetime] NULL,
	[IsCal] [tinyint] NOT NULL,
	[IsAdded] [tinyint] NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyDate] [datetime] NULL,
	[WorkMonth] [decimal](28, 8) NULL,
	[DaysRemained] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT2809] PRIMARY KEY NONCLUSTERED 
(
	[EmpLoaMonthID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT2809__IsCal__165BF519]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2809] ADD  CONSTRAINT [DF__HT2809__IsCal__165BF519]  DEFAULT ((0)) FOR [IsCal]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT2809__IsAdded__17501952]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2809] ADD  CONSTRAINT [DF__HT2809__IsAdded__17501952]  DEFAULT ((1)) FOR [IsAdded]
END