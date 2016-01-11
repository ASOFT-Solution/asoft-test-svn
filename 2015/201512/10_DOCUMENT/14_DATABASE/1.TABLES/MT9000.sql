-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on 17/12/2015 by Tiểu Mai: Bổ sung 20 cột quy cách PS01ID --> PS20ID
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT9000]') AND type in (N'U'))
CREATE TABLE [dbo].[MT9000](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[BatchID] [nvarchar](50) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[TableID] [nvarchar](50) NOT NULL,
	[TransactionTypeID] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[PeriodID] [nvarchar](50) NULL,
	[ExpenseID] [nvarchar](50) NULL,
	[MaterialTypeID] [nvarchar](50) NULL,
	[ProductID] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[ExchangeRate] [decimal](28, 8) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[Quantity] [decimal](28, 8) NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[DebitAccountID] [nvarchar](50) NULL,
	[CreditAccountID] [nvarchar](50) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[VDescription] [nvarchar](250) NULL,
	[BDescription] [nvarchar](250) NULL,
	[TDescription] [nvarchar](250) NULL,
	[Status] [tinyint] NOT NULL,
	[Orders] [int] NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[IsFromPeriodID] [tinyint] NOT NULL,
	[ParentPeriodID] [nvarchar](50) NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[SourceNo] [nvarchar](50) NULL,
 CONSTRAINT [PK_ZT9000] PRIMARY KEY NONCLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT9000_TableID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT9000] ADD  CONSTRAINT [DF_MT9000_TableID]  DEFAULT ('MT9000') FOR [TableID]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT9000_Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT9000] ADD  CONSTRAINT [DF_MT9000_Status]  DEFAULT ((0)) FOR [Status]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT9000_IsFromPeriodID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT9000] ADD  CONSTRAINT [DF_MT9000_IsFromPeriodID]  DEFAULT ((0)) FOR [IsFromPeriodID]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'MT9000' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'MT9000'  and col.name = 'Ana06ID')
Alter Table  MT9000 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
END

---- Tieu Mai: Add Columns
If Exists (Select * From sysobjects Where name = 'MT9000' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'MT9000'  and col.name = 'PS01ID')
Alter Table  MT9000 Add PS01ID nvarchar(50) Null,
					 PS02ID nvarchar(50) Null,
					 PS03ID nvarchar(50) Null,
					 PS04ID nvarchar(50) Null,
					 PS05ID nvarchar(50) Null,
					 PS06ID nvarchar(50) Null,
					 PS07ID nvarchar(50) Null,
					 PS08ID nvarchar(50) Null,
					 PS09ID nvarchar(50) Null,
					 PS10ID nvarchar(50) Null,
					 PS11ID nvarchar(50) Null,
					 PS12ID nvarchar(50) Null,
					 PS13ID nvarchar(50) Null,
					 PS14ID nvarchar(50) Null,
					 PS15ID nvarchar(50) Null,
					 PS16ID nvarchar(50) Null,
					 PS17ID nvarchar(50) Null,
					 PS18ID nvarchar(50) Null,
					 PS19ID nvarchar(50) Null,
					 PS20ID nvarchar(50) Null
End