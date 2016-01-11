-- <Summary>
---- 
-- <History>
---- Create on 14/10/2013 by Lê Thị Thu Hiền
---- Modified on ... by 
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[HT3445]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[HT3445](
	[APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[GeneralCo] [decimal](28, 8) NULL,
	[AbsentAmount] [decimal](28, 8) NULL,
	[BaseSalary] [decimal](28, 8) NULL,
	[GeneralAbsentID] [nvarchar](50)NOT NULL,
 CONSTRAINT [PK_HT3445] PRIMARY KEY CLUSTERED 
(
	[DivisionID],
	[TranMonth],
	[TranYear],
	[EmployeeID],
	[GeneralAbsentID]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
