-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2705]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2705](
	[APK] [uniqueidentifier] DEFAULT NEWID(),	
	[DivisionID] [nvarchar](3) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[EmployeeName] [nvarchar](250) NULL,
	[PaidTax] [decimal](28, 8) NULL,
	[NetAmount] [decimal](28, 8) NULL,
	[SumTax] [decimal](28, 8) NULL,
	[UnPaidTax] [decimal](28, 8) NULL,
	[TaxObjectID] [nvarchar](50) NULL,
	CONSTRAINT [PK_HT2705] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
