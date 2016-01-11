-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1302]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1302](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[HistoryID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[IsPast] [tinyint] NULL,
	[FromMonth] [int] NULL,
	[FromYear] [int] NULL,
	[ToMonth] [int] NULL,
	[ToYear] [int] NULL,	
	[DivisionName] [nvarchar](250) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[DepartmentName] [nvarchar](250) NULL,
	[TeamID] [nvarchar](50) NULL,
	[TeamName] [nvarchar](250) NULL,
	[DutyID] [nvarchar](50) NULL,
	[DutyName] [nvarchar](250) NULL,
	[Works] [nvarchar](250) NULL,
	[SalaryAmounts] [decimal](28, 8) NULL,
	[SalaryCoefficient] [decimal](28, 8) NULL,
	[Contactor] [nvarchar](250) NULL,
	[ContactAddress] [nvarchar](250) NULL,
	[ContactTelephone] [nvarchar](50) NULL,
	[DivisionIDOld] [nvarchar](50) NULL,
	[DepartmentIDOld] [nvarchar](50) NULL,
	[TeamIDOld] [nvarchar](50) NULL,
	[DutyIDOld] [nvarchar](50) NULL,
	[WorksOld] [nvarchar](250) NULL,
	[IsBeforeTranfer] [tinyint] NULL,
	[Description] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
 CONSTRAINT [PK_HT1302] PRIMARY KEY NONCLUSTERED 
(
	[HistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
