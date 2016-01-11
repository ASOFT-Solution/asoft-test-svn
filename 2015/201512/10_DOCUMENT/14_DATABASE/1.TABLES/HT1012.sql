-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1012]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1012](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TaxID] [nvarchar](50) NOT NULL,
	[TaxObjectID] [nvarchar](50) NOT NULL,
	[MaxSalary] [decimal](28, 8) NULL,
	[MinSalary] [decimal](28, 8) NULL,
	[RateOrAmount] [decimal](28, 8) NULL,
	[TotalAmount] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT1012] PRIMARY KEY NONCLUSTERED 
(
	[TaxID] ASC,
	[TaxObjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
