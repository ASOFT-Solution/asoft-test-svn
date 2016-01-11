-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1533]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1533](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[AssetID] [nvarchar](50) NOT NULL,
	[ReVoucherID] [nvarchar](50) NOT NULL,
	[RetransactionID] [nvarchar](50) NOT NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	CONSTRAINT [PK_AT1533] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

