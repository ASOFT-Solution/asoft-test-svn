-- <Summary>
---- 
-- <History>
---- Create on 15/01/2014 by Khánh Vân
---- Modified on ... by ...
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1633]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1633](
	[APK] [uniqueidentifier] DEFAULT NEWID() NOT NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[ReVoucherID] [nvarchar](50) NOT NULL,
	[RetransactionID] [nvarchar](50) NOT NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
 CONSTRAINT [PK_AT1633] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

