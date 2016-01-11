-- <Summary>
---- Định nghĩa tham số
-- <History>
---- Create on 06/08/2010 by Tố Oanh
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0315]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0315](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[ReportName1] [nvarchar](250) NOT NULL,
	[ReportName2] [nvarchar](250) NULL,
	[Negative] [tinyint] NULL,
	[AmountFormat] [tinyint] NULL,
	[DecimalPlaces] [tinyint] NULL,
	[Zero] [tinyint] NULL,
	[Disable] [tinyint] NULL,
	[IsDetail] [tinyint] NULL,
	[ReportDate] [tinyint] NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[StepNumber] [tinyint] NULL,
	[Gap] [int] NULL,
	[FromObjectID] [nvarchar](50) NULL,
	[ToObjectID] [nvarchar](50) NULL,
	[IsGroup1] [tinyint] NULL,
	[Group1ID] [nvarchar](50) NULL,
	[FromGroup1ID] [nvarchar](50) NULL,
	[ToGroup1ID] [nvarchar](50) NULL,
	[IsGroup2] [tinyint] NULL,
	[Group2ID] [nvarchar](50) NULL,
	[FromGroup2ID] [nvarchar](50) NULL,
	[ToGroup2ID] [nvarchar](50) NULL,
	[IsGroup3] [tinyint] NULL,
	[Group3ID] [nvarchar](50) NULL,
	[FromGroup3ID] [nvarchar](50) NULL,
	[ToGroup3ID] [nvarchar](50) NULL,
	CONSTRAINT [PK_AT0315] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON
)
) ON [PRIMARY]
END
