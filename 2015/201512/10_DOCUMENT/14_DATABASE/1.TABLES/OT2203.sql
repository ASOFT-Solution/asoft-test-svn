-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on Quốc Tuấn by Quốc Tuấn: bổ sung thêm 2 cột Level và ApportionID
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT2203]') AND type in (N'U'))
CREATE TABLE [dbo].[OT2203](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[EstimateID] [nvarchar](50) NULL,	
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[MaterialID] [nvarchar](50) NULL,
	[MaterialQuantity] [decimal](28, 8) NULL,
	[MDescription] [nvarchar](250) NULL,
	[Orders] [int] NULL,
	[WareHouseID] [nvarchar](50) NULL,
	[IsPicking] [tinyint] NULL,
	[EDetailID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[ExpenseID] [nvarchar](50) NULL,
	[MaterialTypeID] [nvarchar](50) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[MaterialPrice] [decimal](28, 8) NULL,
	[ConvertedUnit] [decimal](28, 8) NULL,
	[QuantityUnit] [decimal](28, 8) NULL,
	[Num01] [decimal](28, 8) NULL,
	[Num02] [decimal](28, 8) NULL,
	[ProductID] [nvarchar](50) NULL,
	[PeriodID] [nvarchar](50) NULL,
	[MaterialDate] [datetime] NULL,
 CONSTRAINT [PK_OT2203] PRIMARY KEY NONCLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
if(isnull(COL_LENGTH('OT2203','MOrderID'),0)<=0)
ALTER TABLE OT2203 ADD MOrderID nvarchar(50) NULL
if(isnull(COL_LENGTH('OT2203','SOrderID'),0)<=0)
ALTER TABLE OT2203 ADD SOrderID nvarchar(50) NULL
if(isnull(COL_LENGTH('OT2203','MTransactionID'),0)<=0)
ALTER TABLE OT2203 ADD MTransactionID nvarchar(50) NULL
if(isnull(COL_LENGTH('OT2203','STransactionID'),0)<=0)
ALTER TABLE OT2203 ADD STransactionID nvarchar(50) NULL

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'OT2203' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'OT2203' AND col.name = 'Level')
		ALTER TABLE OT2203 ADD [Level] TINYINT NULL
	END
	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'OT2203' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'OT2203' AND col.name = 'ApportionID')
		ALTER TABLE OT2203 ADD ApportionID VARCHAR(50) NULL
	END
