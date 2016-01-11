-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2808]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2808](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmpLoaID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[EmployeeStatus] [tinyint] NULL,
	[WorkDate] [datetime] NULL,
	[BeginDate] [datetime] NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[DaysPrevYear] [decimal](28, 8) NULL,
	[DaysInYear] [decimal](28, 8) NULL,
	[DaysAllowed] [decimal](28, 8) NULL,
	[IsAdded] [tinyint] NULL,
	[IsCal] [tinyint] NULL,
	[LeaveDate] [datetime] NULL,
	[LoaCondID] [nvarchar](50) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT2808] PRIMARY KEY NONCLUSTERED 
(
	[EmpLoaID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
