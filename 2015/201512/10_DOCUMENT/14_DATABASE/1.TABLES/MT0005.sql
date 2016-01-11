-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT0005]') AND type in (N'U'))
CREATE TABLE [dbo].[MT0005](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TypeDefault] [int] NOT NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[KCSEmployeeID] [nvarchar](50) NULL,
	[Status] [int] NULL,
	[InventoryTypeID] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[IntervalDays] [int] NULL,
	[Times] [int] NULL,
	CONSTRAINT [PK_MT0005] PRIMARY KEY NONCLUSTERED
	(
	[APK] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
