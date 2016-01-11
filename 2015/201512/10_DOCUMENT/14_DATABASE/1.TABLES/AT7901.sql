-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7901]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7901](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[ReportName] [nvarchar](250) NULL,
	[ReportTitle] [nvarchar](250) NULL,
	[AmountFormat] [decimal](28, 8) NULL,
	[BracketNegative] [decimal](28, 8) NULL,
	[ReportID] [nvarchar](50) NULL,
	[IsCustomized] [decimal](28, 8) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
CONSTRAINT [PK_AT9701] PRIMARY KEY NONCLUSTERED 
(
	[ReportCode] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

