-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lam
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1411]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1411](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[RecruitTimeID] [nvarchar](50) NULL,
	[RecruitDetail] [nvarchar](50) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[DutyID] [nvarchar](50) NULL,
	[NoOfRecruit] [decimal](28, 8) NULL,
	[NoOfMale] [decimal](28, 8) NULL,
	[NoOfApplicant] [decimal](28, 8) NULL,
	[NoOfRecruited] [decimal](28, 8) NULL,
	[NoOfProbation] [decimal](28, 8) NULL,
	CONSTRAINT [PK_HT1411] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
