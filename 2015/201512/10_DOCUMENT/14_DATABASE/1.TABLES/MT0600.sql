-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT0600]') AND type in (N'U'))
CREATE TABLE [dbo].[MT0600](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ProductCostID] [nvarchar](50) NOT NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[ProductID] [nvarchar](50) NOT NULL,
	[PeriodID] [nvarchar](50) NOT NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[Cost] [decimal](28, 8) NOT NULL,
	[UnitCost] [decimal](28, 8) NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[ModuleID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[Note] [nvarchar](250) NULL,
	[Description] [nvarchar](250) NULL,
	[Converted621] [decimal](28, 8) NULL,
	[Converted622] [decimal](28, 8) NULL,
	[Converted627] [decimal](28, 8) NULL,
	[ProductQuantity] [decimal](28, 8) NULL,
	[BeginWipAmount] [decimal](28, 8) NULL,
	[EndWipAmount] [decimal](28, 8) NULL,
 CONSTRAINT [PK_MT0600] PRIMARY KEY NONCLUSTERED 
(
	[ProductCostID] ASC,
	[ModuleID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT0600_Cost]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0600] ADD  CONSTRAINT [DF_MT0600_Cost]  DEFAULT ((0)) FOR [Cost]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT0600_UnitCost]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0600] ADD  CONSTRAINT [DF_MT0600_UnitCost]  DEFAULT ((0)) FOR [UnitCost]
END