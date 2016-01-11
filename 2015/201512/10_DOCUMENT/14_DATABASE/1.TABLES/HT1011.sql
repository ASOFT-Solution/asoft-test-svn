-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1011]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1011](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TaxObjectID] [nvarchar](50) NOT NULL,
	[TaxObjectName] [nvarchar](250) NULL,
	[IsProgressive] [tinyint] NOT NULL,
	[IsMaxSalary] [tinyint] NOT NULL,
	[IsPercent] [tinyint] NOT NULL,
	[Disabled] [tinyint] NOT NULL,
	[IsPercentSurtax] [tinyint] NOT NULL,
	[RateOrAmount] [decimal](28, 8) NULL,
	[IncomeAfterTax] [decimal](28, 8) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT1011] PRIMARY KEY NONCLUSTERED 
(
	[TaxObjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1011_IsProgressive]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1011] ADD  CONSTRAINT [DF_HT1011_IsProgressive]  DEFAULT ((0)) FOR [IsProgressive]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1011_IsMaxSalary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1011] ADD  CONSTRAINT [DF_HT1011_IsMaxSalary]  DEFAULT ((0)) FOR [IsMaxSalary]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1011_IsPercent]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1011] ADD  CONSTRAINT [DF_HT1011_IsPercent]  DEFAULT ((0)) FOR [IsPercent]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1011_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1011] ADD  CONSTRAINT [DF_HT1011_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT1011' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT1011'  and col.name = 'IsForeigner')
           Alter Table  HT1011 Add IsForeigner tinyint NULL
End

