-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2537]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2537](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmployeeID] [nvarchar](20) NOT NULL,
	[FullName] [nvarchar](200) NULL,
	[DepartmentID] [nvarchar](20) NULL,
	[DepartmentName] [nvarchar](100) NULL,
	[InsuranceSalary] [decimal](28, 8) NULL,
	[BaseSalary] [decimal](28, 8) NULL,
	[Salary01] [decimal](28, 8) NULL,
	[Salary02] [decimal](28, 8) NULL,
	[Salary03] [decimal](28, 8) NULL,
	[Orders] [int] NULL,
	[DutyName] [nvarchar](250) NULL,
	[TeamID] [nvarchar](20) NULL,
	[TeamName] [nvarchar](200) NULL,
	[WorkDate] [datetime] NULL,
	[Notes] [nvarchar](200) NULL,
	[Note1] [nvarchar](200) NULL,
	[IncomeID] [nvarchar](20) NULL,
	[Signs] [int] NULL,
	[Displayed] [int] NULL,
	[Amount] [decimal](28, 8) NULL,
	[Caption] [nvarchar](200) NULL,
	[FOrders] [int] NULL,
	[a] [nvarchar](20) NULL,
 CONSTRAINT [PK_HT2537] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
