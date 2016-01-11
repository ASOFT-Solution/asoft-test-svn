-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT0444]') AND type in (N'U'))
CREATE TABLE [dbo].[MT0444](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ID] [decimal](28, 0) IDENTITY(1,1) NOT NULL,
	[MaterialID] [nvarchar](50) NULL,
	[ProductID] [nvarchar](50) NULL,
	[ProductUnitID] [nvarchar](50) NULL,
	[MaterialUnitID] [nvarchar](50) NULL,
	[ExpenseID] [nvarchar](50) NULL,
	[MaterialQuantity] [decimal](28, 8) NULL,
	[QuantityUnit] [decimal](28, 8) NULL,
	[MaterialTypeID] [nvarchar](50) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[ConvertedUnit] [decimal](28, 8) NULL,
	[ProductQuantity] [decimal](28, 8) NULL,
	[InProcessQuantity] [decimal](28, 8) NULL,
	[PerfectRate] [decimal](28, 8) NULL,
	[MaterialRate] [decimal](28, 8) NULL,
	[HumanResourceRate] [decimal](28, 8) NULL,
	[OthersRate] [decimal](28, 8) NULL,
	[ResultTypeID] [nvarchar](50) NULL,
	CONSTRAINT [PK_MT0444] PRIMARY KEY NONCLUSTERED
	(
	[APK] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
