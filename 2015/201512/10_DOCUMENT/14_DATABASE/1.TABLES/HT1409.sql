-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1409]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1409](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[RecruitTimeID] [nvarchar](50) NOT NULL,
	[RecruitName] [nvarchar](250) NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[NoOfRecruit] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
	[TotalCost] [decimal](28, 8) NULL,
	[NoOfApplicant] [decimal](28, 8) NULL,
	[NoOfRecruited] [decimal](28, 8) NULL,
	[NoOfProbation] [decimal](28, 8) NULL,
	[Disabled] [tinyint] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT1409] PRIMARY KEY NONCLUSTERED 
(
	[RecruitTimeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


