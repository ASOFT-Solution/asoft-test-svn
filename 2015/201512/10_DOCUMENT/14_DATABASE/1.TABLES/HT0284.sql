-- <Summary>
---- 
-- <History>
---- Create on 21/08/2013 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0284]') AND type in (N'U')) 
BEGIN
	CREATE TABLE [dbo].[HT0284](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [NVARCHAR](50) NOT NULL,
		[EmployeeID][NVARCHAR](50) NOT NULL,
		[AbsentDate][DATETIME] NOT NULL,
		[ShiftID][NVARCHAR](50) NOT NULL,
		[AbsentTypeID][NVARCHAR](50) NOT NULL,
		[DepartmentID][NVARCHAR](50) NULL,
		[TeamID][NVARCHAR](50) NULL,		
		[AbsentAmount][DECIMAL](28,8)NULL,
		[TranMonth][INT] NULL,
		[TranYear][INT] NULL,
		[CreateUserID] [NVARCHAR](50) NULL,
		[CreateDate] [DATETIME] NULL,
		[LastModifyUserID] [NVARCHAR](50) NULL,
		[LastModifyDate] [DATETIME] NULL
	 CONSTRAINT [PK_HT0284] PRIMARY KEY CLUSTERED 
	(
		[DivisionID] ASC,
		[EmployeeID] ASC,
		[AbsentDate] ASC,
 		[ShiftID] ASC,
 		[AbsentTypeID] ASC
 		
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

