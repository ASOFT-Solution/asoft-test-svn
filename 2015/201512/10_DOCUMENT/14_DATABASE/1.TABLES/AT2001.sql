-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT2001]') AND type in (N'U'))
CREATE TABLE [dbo].[AT2001](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ContactID] [nvarchar](50) NOT NULL,
	[ContactDate] [datetime] NULL,
	[FullName] [nvarchar](250) NULL,
	[Alias] [nvarchar](100) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[ReferBy] [nvarchar](100) NULL,
	[RelativeRefer] [nvarchar](100) NULL,
	[ContactTypeID] [nvarchar](50) NULL,
	[Dear] [nvarchar](100) NULL,
	[CompanyName] [nvarchar](250) NULL,
	[Department] [nvarchar](100) NULL,
	[Title] [nvarchar](100) NOT NULL,
	[Tel] [nvarchar](100) NULL,
	[InternalTel] [nvarchar](100) NULL,
	[Mobi] [nvarchar](100) NULL,
	[LastMeetingDate] [datetime] NULL,
	[CurrenEvens] [nvarchar](100) NULL,
	[EvenDate] [datetime] NULL,
	[HomeAddress] [nvarchar](250) NULL,
	[CityID] [nvarchar](50) NULL,
	[CountryID] [nvarchar](50) NULL,
	[HomePhone] [nvarchar](100) NULL,
	[DateOfBirth] [datetime] NULL,
	[MotherLand] [nvarchar](100) NULL,
	[Hobbies] [nvarchar](100) NULL,
	[Notes] [nvarchar](250) NULL,
	[ImageID] [nvarchar](100) NULL,
	[Degree] [nvarchar](100) NULL,
	[FieldStudy] [nvarchar](100) NULL,
	[MaritalStatus] [tinyint] NOT NULL,
	[WeldingDate] [datetime] NULL,
	[SponsorName] [nvarchar](250) NULL,
	[SponsorNote] [nvarchar](250) NULL,
	[Children1Name] [nvarchar](250) NULL,
	[Children1Note] [nvarchar](250) NULL,
	[DateOfBirth1] [datetime] NULL,
	[Children2Name] [nvarchar](250) NULL,
	[Children2Note] [nvarchar](250) NULL,
	[DateOfBirth2] [datetime] NULL,
	[Children3Name] [nvarchar](250) NULL,
	[Children3Note] [nvarchar](250) NULL,
	[DateOfBirth3] [datetime] NULL,
	CONSTRAINT [PK_AT2001] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2001_MaritalStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2001] ADD  CONSTRAINT [DF_AT2001_MaritalStatus]  DEFAULT ((0)) FOR [MaritalStatus]
END