-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT5005]') AND type in (N'U'))
CREATE TABLE [dbo].[HT5005](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PayrollMethodID] [nvarchar](50) NOT NULL,
	[IncomeID] [nvarchar](50) NOT NULL,
	[MethodID] [nvarchar](50) NULL,
	[BaseSalaryField] [nvarchar](50) NULL,
	[BaseSalary] [decimal](28, 8) NULL,
	[GeneralCoID] [nvarchar](50) NULL,
	[GeneralAbsentID] [nvarchar](50) NULL,
	[SalaryTotal] [decimal](28, 8) NULL,
	[AbsentAmount] [decimal](28, 8) NULL,
	[Orders] [tinyint] NOT NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[IsCondition] [tinyint] NOT NULL,
	[ConditionCode] [nvarchar](4000) NULL,
 CONSTRAINT [PK_HT5005] PRIMARY KEY NONCLUSTERED 
(
	[PayrollMethodID] ASC,
	[IncomeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT5005_Orders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT5005] ADD  CONSTRAINT [DF_HT5005_Orders]  DEFAULT ((0)) FOR [Orders]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT5005__IsCondit__575EE618]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT5005] ADD  CONSTRAINT [DF__HT5005__IsCondit__575EE618]  DEFAULT ((0)) FOR [IsCondition]
END