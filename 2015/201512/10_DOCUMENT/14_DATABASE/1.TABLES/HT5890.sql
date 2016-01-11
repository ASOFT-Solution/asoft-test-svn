-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT5890]') AND type in (N'U'))
CREATE TABLE [dbo].[HT5890](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[PayrollMethodID] [nvarchar](50) NULL,
	[TeamSalary] [decimal](28, 8) NULL,
	CONSTRAINT [PK_HT5890] PRIMARY KEY NONCLUSTERED
	(
	[APK] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
