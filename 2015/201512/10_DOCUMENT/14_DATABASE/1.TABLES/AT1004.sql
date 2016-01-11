-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on ... by ...
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1004]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT1004](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[CurrencyID] [nvarchar](50) NOT NULL,
	[CurrencyName] [nvarchar](250) NULL,
	[ExchangeRate] [decimal](28, 8) NULL,
	[Operator] [tinyint] NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[ExchangeRateDecimal] [tinyint] NOT NULL,
	[DecimalName] [nvarchar](50) NULL,
	[UnitName] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1004] PRIMARY KEY NONCLUSTERED 
(
	[CurrencyID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1004_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1004] ADD  CONSTRAINT [DF_AT1004_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT1004__Exchange__6AE5BEB7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1004] ADD  CONSTRAINT [DF__AT1004__Exchange__6AE5BEB7]  DEFAULT ((0)) FOR [ExchangeRateDecimal]
END
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'AT1004' AND xtype = 'U') 
BEGIN
    IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1004' AND col.name = 'IsCommon')
    ALTER TABLE AT1004 ADD [IsCommon] [tinyint] NULL
END