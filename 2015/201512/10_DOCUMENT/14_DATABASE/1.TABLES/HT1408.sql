-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1408]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1408](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ExperienceID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[FromMonth] [int] NULL,
	[FromYear] [int] NULL,
	[ToMonth] [int] NULL,
	[ToYear] [int] NULL,
	[ExperienceTime] [nvarchar](250) NULL,
	[CompanyName] [nvarchar](250) NULL,
	[DepartmentName] [nvarchar](250) NULL,
	[TeamName] [nvarchar](250) NULL,
	[DutyName] [nvarchar](250) NULL,
	[WorkInCharge] [nvarchar](250) NULL,
 CONSTRAINT [PK_HT1408] PRIMARY KEY NONCLUSTERED 
(
	[ExperienceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
