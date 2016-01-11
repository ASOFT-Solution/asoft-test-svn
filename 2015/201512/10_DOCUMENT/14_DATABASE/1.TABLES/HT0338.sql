-- <Summary>
---- 
-- <History>
---- Create on 24/12/2013 by Lưu Khánh Vân
---- Modified on ... by ...
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0338]') AND type in (N'U'))
CREATE TABLE [dbo].[HT0338](
	[APK] [uniqueidentifier] NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[TransactionID] [nvarchar] (50) Not null,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] Not null,
	[TranYear] [int] Not null,
	[TotalAmount][decimal]  (28,8) NULL,
	[IncomeAmount][decimal]  (28,8) NULL,
	[TaxReducedAmount][decimal]  (28,8) NULL,
	[IncomeTax][decimal]  (28,8) NULL,

 CONSTRAINT [PK_HT0338] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[EmployeeID] Asc,
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0338_APK]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0338] ADD  CONSTRAINT [DF_HT0338_APK]  DEFAULT (newid()) FOR [APK]
END


