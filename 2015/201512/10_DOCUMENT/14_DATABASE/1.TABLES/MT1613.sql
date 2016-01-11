-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1613]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1613](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PeriodID] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[VoucherID] [nvarchar](50) NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[ProductID] [nvarchar](50) NULL,
	[MaterialID] [nvarchar](50) NULL,
	[ExpenseID] [nvarchar](50) NULL,
	[MaterialTypeID] [nvarchar](50) NULL,
	[ProductUnitID] [nvarchar](50) NULL,
	[MaterialUnitID] [nvarchar](50) NULL,
	[PerfectRate] [decimal](28, 8) NULL,
	[MaterialQuantity] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[ProductQuantity] [decimal](28, 8) NULL,
	[QuantityUnit] [decimal](28, 8) NULL,
	[ConvertedUnit] [decimal](28, 8) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Type] [nvarchar](50) NOT NULL,
	[MaterialRate] [decimal](28, 8) NULL,
	[HumanResourceRate] [decimal](28, 8) NULL,
	[OthersRate] [decimal](28, 8) NULL,
	[InprocessQuantity] [decimal](28, 8) NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_MT1613] PRIMARY KEY NONCLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
