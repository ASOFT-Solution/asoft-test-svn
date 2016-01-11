-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0004]') AND type in (N'U'))
CREATE TABLE [dbo].[HT0004](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[NativeCountry] [nvarchar](250) NULL,
	[CountryID] [nvarchar](50) NULL,
	[EthnicID] [nvarchar](50) NULL,
	[ReligionID] [nvarchar](50) NULL,
	[IsMale] [tinyint] NULL,
	[IsSingle] [tinyint] NULL,
	[CityID] [nvarchar](50) NULL,
	[RecruitPlace] [nvarchar](250) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	CONSTRAINT [PK_HT0004] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
