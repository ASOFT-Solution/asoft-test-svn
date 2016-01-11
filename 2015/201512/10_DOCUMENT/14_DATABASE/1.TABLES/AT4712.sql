-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT4712]') AND type in (N'U'))
CREATE TABLE [dbo].[AT4712](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[ColumnID] [tinyint] NOT NULL,
	[CaculatedType] [nvarchar](5) NOT NULL,
	[ColumnName] [nvarchar](250) NULL,
	[AmountType] [nvarchar](5) NOT NULL,
	[ConditionType] [nvarchar](100) NULL,
	[ConditionFrom] [nvarchar](100) NULL,
	[ConditionTo] [nvarchar](100) NULL,
	[FilterType] [int] NOT NULL,
	[Condition] [nvarchar](100) NULL,
 CONSTRAINT [PK_AT4712] PRIMARY KEY NONCLUSTERED 
(
	[ReportCode] ASC,
	[ColumnID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT4712_AmountType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT4712] ADD  CONSTRAINT [DF_AT4712_AmountType]  DEFAULT ('AQ') FOR [AmountType]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT4712__FilterTy__0A17B073]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT4712] ADD  CONSTRAINT [DF__AT4712__FilterTy__0A17B073]  DEFAULT ((0)) FOR [FilterType]
END