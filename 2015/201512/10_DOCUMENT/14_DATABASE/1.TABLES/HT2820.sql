-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2820]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2820](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[SalaryCondID] [nvarchar](50) NOT NULL,
	[SalaryCondName] [nvarchar](250) NULL,
	[ParameterBased] [nvarchar](50) NULL,
	[ParameterCal] [nvarchar](50) NULL,
	[IsPercent] [tinyint] NULL,
	[Disabled] [tinyint] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT2820] PRIMARY KEY NONCLUSTERED 
(
	[SalaryCondID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2820_IsPercent]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2820] ADD  CONSTRAINT [DF_HT2820_IsPercent]  DEFAULT ((0)) FOR [IsPercent]
END