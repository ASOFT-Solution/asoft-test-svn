-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2811]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2811](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[EmployeeStatus] [tinyint] NULL,
	[WorkDate] [datetime] NULL,
	[LeaveDate] [datetime] NULL,
	[WorkMonth] [int] NULL,
	[LoaCondID] [nvarchar](50) NULL,
	[DaysPrevYear] [decimal](28, 8) NULL,
	[DaysInYear] [decimal](28, 8) NULL,
	[DaysAllowed] [decimal](28, 8) NULL,
	CONSTRAINT [PK_HT2811] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

) ON [PRIMARY]
