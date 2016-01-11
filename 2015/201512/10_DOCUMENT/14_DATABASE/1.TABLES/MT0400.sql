-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 31/12/2015 by Tieu Mai: Bo sung 20 cot quy cach cho san pham (PSxxID)
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT0400]') AND type in (N'U'))
CREATE TABLE [dbo].[MT0400](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ApportionCostID] [nvarchar](50) NOT NULL,
	[PeriodID] [nvarchar](50) NOT NULL,
	[MaterialQuantity] [decimal](28, 8) NULL,
	[ProductQuantity] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[ConvertedUnit] [decimal](28, 8) NULL,
	[QuantityUnit] [decimal](28, 8) NULL,
	[ProductID] [nvarchar](50) NOT NULL,
	[MaterialID] [nvarchar](50) NULL,
	[ExpenseID] [nvarchar](50) NOT NULL,
	[TranMonth] [tinyint] NOT NULL,
	[TranYear] [int] NOT NULL,
	[Description] [nvarchar](250) NULL,
	[BatchID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[Automatic] [int] NULL,
	[MaterialTypeID] [nvarchar](50) NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[ResultTypeID] [nvarchar](50) NULL,
	[InProcessQuantity] [decimal](28, 8) NULL,
	[PerfectRate] [decimal](28, 8) NULL,
	[HumanResourceRate] [decimal](28, 8) NULL,
	[OthersRate] [decimal](28, 8) NULL,
	[MaterialRate] [decimal](28, 8) NULL,
	[UnitID] [nvarchar](50) NULL,
 CONSTRAINT [PK_MT0400] PRIMARY KEY NONCLUSTERED 
(
	[ApportionCostID] ASC,
	[PeriodID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT0400_Automatic]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0400] ADD  CONSTRAINT [DF_MT0400_Automatic]  DEFAULT ((0)) FOR [Automatic]
END

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT0400' AND col.name = 'PS01ID')
        ALTER TABLE MT0400 ADD	PS01ID NVARCHAR(50) NULL,
								PS02ID NVARCHAR(50) NULL,
								PS03ID NVARCHAR(50) NULL,
								PS04ID NVARCHAR(50) NULL,
								PS05ID NVARCHAR(50) NULL,
								PS06ID NVARCHAR(50) NULL,
								PS07ID NVARCHAR(50) NULL,
								PS08ID NVARCHAR(50) NULL,
								PS09ID NVARCHAR(50) NULL,
								PS10ID NVARCHAR(50) NULL,
								PS11ID NVARCHAR(50) NULL,
								PS12ID NVARCHAR(50) NULL,
								PS13ID NVARCHAR(50) NULL,
								PS14ID NVARCHAR(50) NULL,
								PS15ID NVARCHAR(50) NULL,
								PS16ID NVARCHAR(50) NULL,
								PS17ID NVARCHAR(50) NULL,
								PS18ID NVARCHAR(50) NULL,
								PS19ID NVARCHAR(50) NULL,
								PS20ID NVARCHAR(50) NULL
