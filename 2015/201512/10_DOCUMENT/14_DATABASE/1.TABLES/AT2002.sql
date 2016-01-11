-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT2002]') AND type in (N'U'))
CREATE TABLE [dbo].[AT2002](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ProjectID] [nvarchar](50) NOT NULL,
	[ProjectName] [nvarchar](250) NULL,
	[Address] [nvarchar](250) NULL,
	[CityID] [nvarchar](50) NULL,
	[Tel] [nvarchar](100) NULL,
	[Fax] [nvarchar](100) NULL,
	[MainActivities] [nvarchar](250) NULL,
	[TotalCapital] [decimal](28, 8) NULL,
	[ExpectedProduct] [nvarchar](100) NULL,
	[ProjectValues] [decimal](28, 8) NULL,
	[Chance] [decimal](28, 8) NULL,
	[Investor] [nvarchar](100) NULL,
	[InvestorRole] [nvarchar](100) NULL,
	[InvestorContact] [nvarchar](100) NULL,
	[Consultant] [nvarchar](100) NULL,
	[ConsultantRole] [nvarchar](100) NULL,
	[ConsultantContact] [nvarchar](100) NULL,
	[MainCon] [nvarchar](100) NULL,
	[MainConRole] [nvarchar](100) NULL,
	[ME] [nvarchar](100) NULL,
	[MERole] [nvarchar](100) NULL,
	[MEContact] [nvarchar](100) NULL,
	[StartTime] [datetime] NULL,
	[TenderTime] [datetime] NULL,
	[Poteltial] [tinyint] NULL,
	[Status] [tinyint] NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT2002] PRIMARY KEY NONCLUSTERED 
(
	[ProjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2002_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2002] ADD  CONSTRAINT [DF_AT2002_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
