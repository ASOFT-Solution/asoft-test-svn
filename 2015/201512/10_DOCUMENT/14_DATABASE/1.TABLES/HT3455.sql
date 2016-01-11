-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT3455]') AND type in (N'U'))
CREATE TABLE [dbo].[HT3455](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[TargetID] [nvarchar](50) NULL,
	[TaxObjectID] [nvarchar](50) NULL,
	[SalaryAmount] [decimal](28, 8) NULL,
	[TaxAmount] [decimal](28, 8) NULL,
	[TaxRate] [decimal](28, 8) NULL,
	CONSTRAINT [PK_HT3455] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
