-- <Summary>
---- 
-- <History>
---- Create on 26/12/2014 by Lưu Khánh Vân
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CMT0000STD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CMT0000STD](
	[DefTranMonth] [int] NULL,
	[DefTranYear] [int] NULL,
	[OriginalDecimal] [tinyint] NULL,
	[ConvertDecimal] [tinyint] NULL,
	[UnitPriceDecimal] [tinyint] NULL,
	[QuantityDecimal] [tinyint] NULL,
	[UserID] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar] (50) NULL

) ON [PRIMARY]
END