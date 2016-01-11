-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7422]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7422](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[LineID] [int] NOT NULL,
	[Sign] [int] NULL,
	[AccumulateLineID1] [int] NULL,
	[AccumulateLineID2] [int] NULL,
	[TurnOverCode] [nvarchar](50) NULL,
	[TaxCode] [nvarchar](50) NULL,
	[IsBold] [tinyint] NOT NULL,
	[Description] [nvarchar](250) NULL,
	[TurnOverAmount] [decimal](28, 8) NULL,
	[TaxAmount] [decimal](28, 8) NULL,
	CONSTRAINT [PK_AT7422] PRIMARY KEY NONCLUSTERED
	(
	[APK] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]	
) ON [PRIMARY]



