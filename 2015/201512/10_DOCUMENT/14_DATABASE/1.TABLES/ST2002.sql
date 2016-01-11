-- <Summary>
---- 
-- <History>
---- Create on 23/10/2013 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ST2002]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ST2002](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](50) NOT NULL,
		[ModuleID] [nvarchar](50) NULL,
		[FormID] [nvarchar](50) NULL,
		[TranMonth] [int] NULL,
		[TranYear] [int] NULL,
		[RequestID] [nvarchar](50) NOT NULL,
		[VoucherTypeID] [nvarchar](50) NULL,
		[VoucherNo] [nvarchar](50) NULL,
		[VoucherDate] [datetime] NULL,
		[EmployeeID] [nvarchar](50) NULL,
		[RequestDescription] [nvarchar](500) NULL,
		[RequestTransactionTypeID] [nvarchar](50) NULL,
		[RequestVoucherID] [nvarchar](50) NOT NULL,
		[RequestVoucherNo] [nvarchar](50) NOT NULL,
		[IsApproved] [tinyint] NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[CreateDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
	 CONSTRAINT [PK_ST2002] PRIMARY KEY CLUSTERED 
	(
		[DivisionID] ASC,
		[RequestID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END