-- <Summary>
---- 
-- <History>
---- Create on 09/08/2010 by Ngoc Nhut
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FT0000]') AND type in (N'U'))
CREATE TABLE [dbo].[FT0000](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DefDivisionID] [nvarchar](3) NULL,
	[DefTranMonth] [int] NULL,
	[DefTranYear] [int] NULL,
	[AssetAccountID] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[VATGroupID] [nvarchar](50) NULL,
	CONSTRAINT [PK_FT0000] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]