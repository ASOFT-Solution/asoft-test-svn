-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT1013]') AND type in (N'U'))
CREATE TABLE [dbo].[OT1013](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[OrderID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[OrderDate] [datetime] NULL,
	[OrderStatus] [tinyint] NULL,
	[ObjectID] [nvarchar](50) NULL,
	[ObjectName] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[OrderType] [tinyint] NULL,
	[ContractNo] [nvarchar](50) NULL,
	[PaymentID] [nvarchar](50) NULL,
	[Disabled] [tinyint] NULL,
	[Address] [nvarchar](250) NULL,
	[Type] [nvarchar](50) NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	CONSTRAINT [PK_OT1013] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

) ON [PRIMARY]
---- Drop giá trị default
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT1013_TypeID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT1013] DROP CONSTRAINT [DF_OT1013_TypeID]
END
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT1013_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT1013] DROP CONSTRAINT [DF_OT1013_Disabled]
END
