-- <Summary>
---- 
-- <History>
---- Create on 14/03/2013 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2414]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[HT2414](
		[APK] [uniqueidentifier] NOT NULL,
		[DivisionID] [nvarchar](50) NULL,
		[TranMonth] [int] NULL,
		[TranYear] [int] NULL,
		[PayrollMethodID] [nvarchar](50) NULL,
		[DepartmentID] [nvarchar](50) NULL,
		[TeamID] [nvarchar](50) NULL,
		[EmployeeID] [nvarchar](50) NULL,
		[AbsentDate] [datetime] NULL,
		[AbsentHour] [decimal](28, 8) NULL,
		[AbsentDay] [decimal](28, 8) NULL,
		[Coefficient] [decimal](28, 8) NULL,
		[TeamAmount] [decimal](28, 8) NULL,
	 CONSTRAINT [PK_HT2414] PRIMARY KEY CLUSTERED 
	(
		[APK] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]	
END

