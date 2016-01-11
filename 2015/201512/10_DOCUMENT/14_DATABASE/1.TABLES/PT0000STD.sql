-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PT0000STD]') AND type in (N'U'))
CREATE TABLE [dbo].[PT0000STD](
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[OriginalDecimal] [tinyint] NULL,
	[ConvertDecimal] [tinyint] NULL,
	[UnitPriceDecimal] [tinyint] NULL,
	[QuantityDecimal] [tinyint] NULL
) ON [PRIMARY]
