-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PT2101]') AND type in (N'U'))
CREATE TABLE [dbo].[PT2101](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[OrderStatus] [tinyint] NOT NULL,
	[ObjectID] [nvarchar](50) NULL,
	[ObjectName] [nvarchar](250) NULL,
	[VATNo] [nvarchar](50) NULL,
	[Address] [nvarchar](250) NULL,
	[ContractNo] [nvarchar](50) NULL,
	[ContractDate] [datetime] NULL,
	[ShipDate] [datetime] NULL,
	[DeliveryAddress] [nvarchar](250) NULL,
	[Transport] [nvarchar](100) NULL,
	[Contact] [nvarchar](250) NULL,
	[SalesManID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[Notes] [nvarchar](250) NULL,
	[Disabled] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_PT2101] PRIMARY KEY CLUSTERED 
(
	[VoucherID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PT2101_OrderStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PT2101] ADD  CONSTRAINT [DF_PT2101_OrderStatus]  DEFAULT ((0)) FOR [OrderStatus]
END
