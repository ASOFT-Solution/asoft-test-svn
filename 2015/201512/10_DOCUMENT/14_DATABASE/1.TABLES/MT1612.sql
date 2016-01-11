-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on 21/12/2015 by Tiểu Mai: Bổ sung 20 cột quy cách sản phẩm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1612]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1612](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[WipVoucherID] [nvarchar](50) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[VoucherTypeID] [nvarchar](50) NOT NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[VoucherDate] [datetime] NULL,
	[PeriodID] [nvarchar](50) NOT NULL,
	[ProductID] [nvarchar](50) NULL,
	[ProductQuantity] [decimal](28, 8) NULL,
	[PerfectRate] [decimal](28, 8) NULL,
	[WipQuantity] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[ConvertedUnit] [decimal](28, 8) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[MaterialID] [nvarchar](50) NULL,
	[ExpenseID] [nvarchar](50) NULL,
	[MaterialTypeID] [nvarchar](50) NULL,
	[MaterialPrice] [decimal](28, 8) NULL,
	[Type] [nvarchar](50) NOT NULL,
	[FromPeriodID] [nvarchar](50) NULL,
 CONSTRAINT [PK_MT1612] PRIMARY KEY NONCLUSTERED 
(
	[WipVoucherID] ASC,
	[VoucherID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__MT1612__Type__2255EF32]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1612] ADD  CONSTRAINT [DF__MT1612__Type__2255EF32]  DEFAULT ('B') FOR [Type]
END

---- Tieu Mai: Add Columns
If Exists (Select * From sysobjects Where name = 'MT1612' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'MT1612'  and col.name = 'PS01ID')
Alter Table  MT1612 Add PS01ID nvarchar(50) Null,
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