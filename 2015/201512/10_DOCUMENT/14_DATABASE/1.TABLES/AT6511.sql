-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT6511]') AND type in (N'U'))
CREATE TABLE [dbo].[AT6511](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[CurrencyID] [nvarchar](50) NOT NULL,
	[ExchangeRate] [decimal](28, 8) NULL,
	[Operator] [tinyint] NULL
 CONSTRAINT [PK_AT6511] PRIMARY KEY CLUSTERED 
(
	[CurrencyID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
