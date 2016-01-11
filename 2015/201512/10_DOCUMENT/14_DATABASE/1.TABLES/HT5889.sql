-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT5889]') AND type in (N'U'))
CREATE TABLE [dbo].[HT5889](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[PayrollMethodID] [nvarchar](50) NULL,
	[IsTax] [int] NULL,
	[IncomeAmount] [decimal](28, 8) NULL,
	[SubAmount] [decimal](28, 8) NULL,
	CONSTRAINT [PK_HT5889] PRIMARY KEY NONCLUSTERED
	(
		[APK] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
