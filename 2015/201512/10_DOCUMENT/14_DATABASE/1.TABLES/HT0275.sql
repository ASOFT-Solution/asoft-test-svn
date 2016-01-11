-- <Summary>
---- 
-- <History>
---- Create on 13/06/2013 by Bảo Anh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0275]') AND type in (N'U')) 
BEGIN
	CREATE TABLE [dbo].[HT0275](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](50) NOT NULL,
		[ResultVoucherID] [nvarchar](50) NULL,
		[EmployeeID] [nvarchar](50) NOT NULL,
		[SalaryAmount] [decimal](28,8) NULL,
	 CONSTRAINT [PK_HT0275] PRIMARY KEY CLUSTERED
	(
		[DivisionID] ASC,
 		[APK] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

