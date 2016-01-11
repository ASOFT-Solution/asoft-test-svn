-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7621]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7621](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[LineID] [nvarchar](50) NOT NULL,
	[LineCode] [nvarchar](50) NULL,
	[LineDescription] [nvarchar](250) NULL,
	[LevelID] [tinyint] NULL,
	[Sign] [nvarchar](5) NULL,
	[AccuLineID] [nvarchar](50) NULL,
	[CaculatorID] [nvarchar](50) NULL,
	[FromAccountID] [nvarchar](50) NULL,
	[ToAccountID] [nvarchar](50) NULL,
	[FromCorAccountID] [nvarchar](50) NULL,
	[ToCorAccountID] [nvarchar](50) NULL,
	[AnaTypeID] [nvarchar](50) NULL,
	[FromAnaID] [nvarchar](50) NULL,
	[ToAnaID] [nvarchar](50) NULL,
	[IsPrint] [tinyint] NULL,
	[BudgetID] [nvarchar](50) NULL,
CONSTRAINT [PK_AT7621] PRIMARY KEY CLUSTERED 
(
	[ReportCode] ASC,
	[LineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
