-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7776]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7776](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[RefInventoryID] [nvarchar](50) NOT NULL,
	[Quantity] [decimal](28, 8) NOT NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
CONSTRAINT [PK_AT7776] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


