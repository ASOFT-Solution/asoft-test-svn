-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 18/06/2015 by Hoàng Vũ: Customizeindex Secoin-Bổ sung trường  IsPhase (Lưu vết: Sản xuất 2 công đoạn, Sản xuất 1 công đoạn, khác), 
-------------------------------------------------------------------------------IsJob (Lưu vết: Kế thừa từ phiếu giao việc), 
-------------------------------------------------------------------------------IsResult (Lưu vết: Kế thừa từ kết quả sản xuất) 
---- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT0810]') AND type in (N'U'))
CREATE TABLE [dbo].[MT0810](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[PeriodID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[ExchangeRate] [decimal](28, 8) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[Serial] [nvarchar](50) NULL,
	[DepartmentID] [nvarchar](50) NOT NULL,
	[TransferPeriodID] [nvarchar](50) NULL,
	[OriginalAmount] [decimal](28, 8) NOT NULL,
	[ConvertedAmount] [decimal](28, 8) NOT NULL,
	[VoucherDate] [datetime] NULL,
	[OrderID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[FindDate] [datetime] NULL,
	[KCSEmployeeID] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[ResultTypeID] [nvarchar](50) NOT NULL,
	[InventoryTypeID] [nvarchar](50) NULL,
	[Disabled] [tinyint] NOT NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[IsPrice] [tinyint] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[IsDistribute] [tinyint] NOT NULL,
	[WareHouseID] [nvarchar](50) NULL,
	[IsWareHouseID] [tinyint] NULL,
	[IsWareHouse] [tinyint] NOT NULL,
	[TeamID] [nvarchar](50) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[IsTransfer] [tinyint] NOT NULL,
	[ApportionID] [nvarchar](50) NULL,
	[ExWarehouseID] [nvarchar](50) NULL,
 CONSTRAINT [PK_MT0810] PRIMARY KEY NONCLUSTERED 
(
	[VoucherID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT0810_TranMonth]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0810] ADD  CONSTRAINT [DF_MT0810_TranMonth]  DEFAULT ((0)) FOR [TranMonth]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT0810_TranYear]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0810] ADD  CONSTRAINT [DF_MT0810_TranYear]  DEFAULT ((0)) FOR [TranYear]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT0810_OriginalAmount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0810] ADD  CONSTRAINT [DF_MT0810_OriginalAmount]  DEFAULT ((0)) FOR [OriginalAmount]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT0810_ConvertedAmount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0810] ADD  CONSTRAINT [DF_MT0810_ConvertedAmount]  DEFAULT ((0)) FOR [ConvertedAmount]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT0810_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0810] ADD  CONSTRAINT [DF_MT0810_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__MT0810__IsPric__47C76B03]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0810] ADD  CONSTRAINT [DF__MT0810__IsPric__47C76B03]  DEFAULT ((0)) FOR [IsPrice]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT0810_Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0810] ADD  CONSTRAINT [DF_MT0810_Status]  DEFAULT ((0)) FOR [Status]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__MT0810__IsDist__01819F1B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0810] ADD  CONSTRAINT [DF__MT0810__IsDist__01819F1B]  DEFAULT ((0)) FOR [IsDistribute]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__MT0810__IsWareHo__06E2DEE7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0810] ADD  CONSTRAINT [DF__MT0810__IsWareHo__06E2DEE7]  DEFAULT ((0)) FOR [IsWareHouse]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__MT0810__IsTransf__3A1A32A2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0810] ADD  CONSTRAINT [DF__MT0810__IsTransf__3A1A32A2]  DEFAULT ((0)) FOR [IsTransfer]
END
---- Add Columns
if(isnull(COL_LENGTH('MT0810','MOrderID'),0)<=0)
ALTER TABLE MT0810 ADD MOrderID nvarchar(50) NULL
if(isnull(COL_LENGTH('MT0810','SOrderID'),0)<=0)
ALTER TABLE MT0810 ADD SOrderID nvarchar(50) NULL
if(isnull(COL_LENGTH('MT0810','MTransactionID'),0)<=0)
ALTER TABLE MT0810 ADD MTransactionID nvarchar(50) NULL
if(isnull(COL_LENGTH('MT0810','STransactionID'),0)<=0)
ALTER TABLE MT0810 ADD STransactionID nvarchar(50) NULL

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT0810' AND xtype='U')--Cutomize index Secoin
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT0810' AND col.name='IsPhase')
		ALTER TABLE MT0810 ADD IsPhase tinyint NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT0810' AND xtype='U')--Cutomize index Secoin
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT0810' AND col.name='IsJob')
		ALTER TABLE MT0810 ADD IsJob tinyint NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT0810' AND xtype='U')--Cutomize index Secoin
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT0810' AND col.name='IsResult')
		ALTER TABLE MT0810 ADD IsResult tinyint NULL
	END
