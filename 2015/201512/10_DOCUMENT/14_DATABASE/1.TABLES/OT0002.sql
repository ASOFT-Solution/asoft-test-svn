-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT0002]') AND type in (N'U'))
CREATE TABLE [dbo].[OT0002](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[OrderStatus] [tinyint] NULL,
	[InventoryTypeID] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[Dear] [nvarchar](100) NULL,
	[Condition] [nvarchar](100) NULL,
	[Attention1] [nvarchar](250) NULL,
	[Attention2] [nvarchar](250) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyDate] [datetime] NULL,
	[ApportionType] [nvarchar](100) NULL,
	[PaymentID] [nvarchar](50) NULL,
	CONSTRAINT [PK_OT0002] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
