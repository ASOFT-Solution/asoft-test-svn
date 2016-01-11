-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT6510]') AND type in (N'U'))
CREATE TABLE [dbo].[AT6510](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[TransactionID] [nvarchar](50) NOT NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[BaseCurrencyID] [nvarchar](50) NOT NULL,
	[CurrencyID] [nvarchar](50) NOT NULL,
	[ExchangeRate] [decimal](28, 8) NULL,
	[ObjectID] [nvarchar](250) NULL,
	[Description] [nvarchar](250) NULL,
	[DueDate] [datetime] NULL,
	[Amount] [decimal](28, 8) NULL,
	[FlowType] [tinyint] NULL
 CONSTRAINT [PK_AT6510] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


