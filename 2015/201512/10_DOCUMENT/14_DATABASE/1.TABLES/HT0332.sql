-- <Summary>
---- 
-- <History>
---- Create on 24/12/2013 by Lưu Khánh Vân
---- Modified on ... by ...
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0332]') AND type in (N'U'))
CREATE TABLE [dbo].[HT0332](
	[APK] [uniqueidentifier] NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[TaxStepID] [nvarchar](50) NOT NULL,
	[StepID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Orders] [int] NOT NULL,
	[FromSalary] [decimal](28,8) NULL,
	[ToSalary] [decimal](28,8) NULL,
	[Rate] [decimal](28,8) NULL,
	[DefinedUserID] [nvarchar](50) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,

 CONSTRAINT [PK_HT0332] PRIMARY KEY CLUSTERED 
(
	[StepID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0332_APK]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0332] ADD  CONSTRAINT [DF_HT0332_APK]  DEFAULT (newid()) FOR [APK]
END
