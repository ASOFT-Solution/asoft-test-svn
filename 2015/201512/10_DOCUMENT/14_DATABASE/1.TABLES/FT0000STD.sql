-- <Summary>
---- 
-- <History>
---- Create on 09/08/2010 by Ngoc Nhut
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FT0000STD]') AND type in (N'U'))
CREATE TABLE [dbo].[FT0000STD](
	[DefTranMonth] [int] NULL,
	[DefTranYear] [int] NULL,
	[AssetAccountID] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[VATGroupID] [nvarchar](50) NULL
) ON [PRIMARY]

