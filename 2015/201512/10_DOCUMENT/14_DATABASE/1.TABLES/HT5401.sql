-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT5401]') AND type in (N'U'))
CREATE TABLE [dbo].[HT5401](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[DepartmentName] [nvarchar](250) NULL,
	[InsuranceSalary] [decimal](28, 8) NULL,
	[Orders] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[Notes] [nvarchar](250) NULL,
	[IncomeID] [nvarchar](50) NULL,
	[Signs] [numeric](18, 0) NULL,
	[Amount] [decimal](28, 8) NULL,
	[Caption] [nvarchar](250) NULL,
	[FOrders] [int] NULL,
	CONSTRAINT [PK_HT5401] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
