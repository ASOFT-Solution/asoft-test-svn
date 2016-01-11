-- <Summary>
---- 
-- <History>
---- Create on 12/09/2013 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0291]') AND type in (N'U')) 
BEGIN
CREATE TABLE [dbo].[HT0291](
	[APK] [uniqueidentifier] DEFAULT NEWID() NOT NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[AllocationID][uniqueidentifier] NOT NULL,
	[DepartmentID] [nvarchar](50) NOT NULL,
	[TeamID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NOT NULL	
 CONSTRAINT [PK_HT0291] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[AllocationID] ASC,
	[EmployeeID] ASC
	
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
