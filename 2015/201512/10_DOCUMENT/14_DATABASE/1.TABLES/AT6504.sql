-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT6504]') AND type in (N'U'))
CREATE TABLE [dbo].[AT6504](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[LineID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[BudgetID] [nvarchar](50) NOT NULL,
	[BudgetAmount] [decimal](28, 8) NULL,
 CONSTRAINT [PK_AT6504] PRIMARY KEY CLUSTERED 
(
	[ReportCode] ASC,
	[LineID] ASC,
	[TranMonth] ASC,
	[TranYear] ASC,
	[BudgetID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


