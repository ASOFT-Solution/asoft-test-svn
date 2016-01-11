-- <Summary>
---- 
-- <History>
---- Create on 09/08/2010 by Ngoc Nhut
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WT4710]') AND type in (N'U'))
CREATE TABLE [dbo].[WT4710](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[ReportName1] [nvarchar](250) NULL,
	[ReportName2] [nvarchar](250) NULL,
	[Title] [nvarchar](250) NULL,
	[ReportID] [nvarchar](50) NULL,
	[Disabled] [tinyint] NOT NULL,
	[IsDetail] [tinyint] NOT NULL,
	[DateType] [tinyint] NOT NULL,
	[GetColumnTitle] [tinyint] NOT NULL,
	[AgeStepID] [nvarchar](50) NOT NULL,
	[Group1ID] [nvarchar](50) NULL,
	[Group2ID] [nvarchar](50) NULL,
	[Group3ID] [nvarchar](50) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Selection01ID] [nvarchar](50) NULL,
	[Selection02ID] [nvarchar](50) NULL,
	[Selection03ID] [nvarchar](50) NULL,
 CONSTRAINT [PK_WT4710] PRIMARY KEY NONCLUSTERED 
(
	[ReportCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
