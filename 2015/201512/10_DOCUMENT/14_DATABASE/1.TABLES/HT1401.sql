-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1401]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1401](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,	
	[FatherName] [nvarchar](250) NULL,
	[FatherYear] [int] NULL,
	[FatherJob] [nvarchar](250) NULL,
	[FatherAddress] [nvarchar](250) NULL,
	[FatherNote] [nvarchar](250) NULL,
	[IsFatherDeath] [tinyint] NOT NULL,
	[MotherName] [nvarchar](250) NULL,
	[MotherYear] [int] NULL,
	[MotherJob] [nvarchar](250) NULL,
	[MotherAddress] [nvarchar](250) NULL,
	[MotherNote] [nvarchar](250) NULL,
	[IsMotherDeath] [tinyint] NOT NULL,
	[SpouseName] [nvarchar](250) NULL,
	[SpouseYear] [int] NULL,
	[SpouseAddress] [nvarchar](250) NULL,
	[SpouseNote] [nvarchar](250) NULL,
	[SpouseJob] [nvarchar](250) NULL,
	[IsSpouseDeath] [tinyint] NOT NULL,
	[EducationLevelID] [nvarchar](50) NULL,
	[PoliticsID] [nvarchar](50) NULL,
	[Language1ID] [nvarchar](50) NULL,
	[Language2ID] [nvarchar](50) NULL,
	[Language3ID] [nvarchar](50) NULL,
	[LanguageLevel1ID] [nvarchar](50) NULL,
	[LanguageLevel2ID] [nvarchar](50) NULL,
	[LanguageLevel3ID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT1401] PRIMARY KEY NONCLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1401_IsFatherDeath]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1401] ADD  CONSTRAINT [DF_HT1401_IsFatherDeath]  DEFAULT ((0)) FOR [IsFatherDeath]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1401_IsMotherDeath]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1401] ADD  CONSTRAINT [DF_HT1401_IsMotherDeath]  DEFAULT ((0)) FOR [IsMotherDeath]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1401_IsSpouseDeath]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1401] ADD  CONSTRAINT [DF_HT1401_IsSpouseDeath]  DEFAULT ((0)) FOR [IsSpouseDeath]
END

