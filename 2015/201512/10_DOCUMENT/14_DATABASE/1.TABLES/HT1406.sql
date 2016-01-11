-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1406]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1406](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[RetributionID] [nvarchar](50) NOT NULL,
	[DepartmentID] [nvarchar](50) NOT NULL,
	[TeamID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[IsReward] [tinyint] NOT NULL,
	[DecisionNo] [nvarchar](50) NULL,
	[RetributeDate] [datetime] NULL,
	[Rank] [nvarchar](250) NULL,
	[SuggestedPerson] [nvarchar](250) NULL,
	[Reason] [nvarchar](250) NULL,
	[Form] [nvarchar](250) NULL,
	[Value] [decimal](28, 8) NULL,
	[DutyID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT1406] PRIMARY KEY NONCLUSTERED 
(
	[RetributionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
