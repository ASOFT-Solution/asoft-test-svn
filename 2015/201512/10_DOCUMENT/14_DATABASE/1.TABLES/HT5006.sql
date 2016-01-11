-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT5006]') AND type in (N'U'))
CREATE TABLE [dbo].[HT5006](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PayrollMethodID] [nvarchar](50) NOT NULL,
	[SubID] [nvarchar](50) NOT NULL,
	[BaseSalaryField] [nvarchar](50) NULL,
	[BaseSalary] [decimal](28, 8) NULL,
	[GeneralCoID] [nvarchar](50) NULL,
	[GeneralAbsentID] [nvarchar](50) NULL,
	[AbsentAmount] [decimal](28, 8) NULL,
	[Orders] [int] NULL,
	[MethodID] [nvarchar](50) NULL,
	[SalaryTotal] [decimal](28, 8) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[IsCondition] [tinyint] NOT NULL,
	[ConditionCode] [nvarchar](4000) NULL,
 CONSTRAINT [PK_HT5006] PRIMARY KEY NONCLUSTERED 
(
	[PayrollMethodID] ASC,
	[SubID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT5006_BaseSalary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT5006] ADD  CONSTRAINT [DF_HT5006_BaseSalary]  DEFAULT ((0)) FOR [BaseSalary]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT5006_Orders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT5006] ADD  CONSTRAINT [DF_HT5006_Orders]  DEFAULT ((1)) FOR [Orders]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT5006__MethodID__5F256108]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT5006] ADD  CONSTRAINT [DF__HT5006__MethodID__5F256108]  DEFAULT ('P01') FOR [MethodID]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT5006__IsCondit__58530A51]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT5006] ADD  CONSTRAINT [DF__HT5006__IsCondit__58530A51]  DEFAULT ((0)) FOR [IsCondition]
END

