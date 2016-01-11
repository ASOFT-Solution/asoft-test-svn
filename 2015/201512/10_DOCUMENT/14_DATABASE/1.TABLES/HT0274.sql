-- <Summary>
---- 
-- <History>
---- Create on 13/06/2013 by Bảo Anh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0274]') AND type in (N'U')) 
BEGIN
	CREATE TABLE [dbo].[HT0274](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](50) NOT NULL,
		[WorkTypeID] [nvarchar](50) NULL,
		[ResultVoucherID] [nvarchar](50) NOT NULL,
		[ResultVoucherNo] [nvarchar](50) NOT NULL,
		[TranMonth] [int] NOT NULL,
		[TranYear] [int] NOT NULL,		
		[ResultAmount] [decimal](28,8) NULL,
		[WaitingAmount] [decimal](28,8) NULL,
		[DailyAmount] [decimal](28,8) NULL,
		[EmployeesTotal] [int] NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[CreateDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
	 CONSTRAINT [PK_HT0274] PRIMARY KEY CLUSTERED
	(
		[DivisionID] ASC,
 		[APK] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

