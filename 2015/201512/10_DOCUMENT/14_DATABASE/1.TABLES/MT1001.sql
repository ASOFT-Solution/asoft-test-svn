-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 13/02/2015 by Hoàng Vũ: Bổ sung cột InheritTableID, InheritVoucherID, InheritTransactionID để check kế thừa
---- Modified on 19/08/2013 by Bảo Anh: Bổ sung cột EmployeeID để kết chuyển KQSX qua chấm công sản phẩm (Thuận Lợi)
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on 18/06/2015 by Hoàng Vũ: Customizeindex Secoin-Bổ sung trường ExtraID (Quản lý thông tin mã phụ khách hàng theo vật tư) 
---- Modified on 07/09/2015 by Tiểu Mai: Bổ sung 10 cột tham số.
---- Modified on 16/12/2015 by Bảo Anh: Sửa cột ConvertedAmount là NULL
---- Modified by Tieu Mai on 04/01/2016: Bo sung truong KITID
---- <Example>


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1001]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1001](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[InventoryID] [nvarchar](50) NULL,
	[Quantity] [decimal](28, 8) NULL,
	[UnitID] [nvarchar](50) NULL,
	[Price] [decimal](28, 8) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[IsRepair] [tinyint] NOT NULL,
	[PerfectRate] [decimal](28, 8) NULL,
	[Note] [nvarchar](250) NULL,
	[ProductID] [nvarchar](50) NULL,
	[MaterialRate] [decimal](28, 8) NULL,
	[HumanResourceRate] [decimal](28, 8) NULL,
	[OthersRate] [decimal](28, 8) NULL,
	[DebitAccountID] [nvarchar](50) NULL,
	[CreditAccountID] [nvarchar](50) NULL,
	[SourceNo] [nvarchar](50) NULL,
	[LimitDate] [datetime] NULL,
	[Orders] [int] NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[ProductID1] [nvarchar](50) NULL,
	[OTransactionID] [nvarchar](50) NULL,
	[MTransactionID] [nvarchar](50) NULL,
	[Parameter01] [decimal](28, 8) NULL,
	[Parameter02] [decimal](28, 8) NULL,
	[Parameter03] [decimal](28, 8) NULL,
	[Parameter04] [decimal](28, 8) NULL,
	[Parameter05] [decimal](28, 8) NULL,
	[ConvertedQuantity] [decimal](28, 8) NULL,
	[ConvertedPrice] [decimal](28, 8) NULL,
	[ConvertedUnitID] [nvarchar](50) NULL,
 CONSTRAINT [PK_MT1001] PRIMARY KEY NONCLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1001_Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1001] ADD  CONSTRAINT [DF_MT1001_Status]  DEFAULT ((0)) FOR [Status]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1001_IsRepair]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1001] ADD  CONSTRAINT [DF_MT1001_IsRepair]  DEFAULT ((0)) FOR [IsRepair]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1001_PerfectRate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1001] ADD  CONSTRAINT [DF_MT1001_PerfectRate]  DEFAULT ((0)) FOR [PerfectRate]
END
---- Add Columns
if(isnull(COL_LENGTH('MT1001','MOrderID'),0)<=0)
ALTER TABLE MT1001 ADD MOrderID nvarchar(50) NULL
if(isnull(COL_LENGTH('MT1001','SOrderID'),0)<=0)
ALTER TABLE MT1001 ADD SOrderID nvarchar(50) NULL
if(isnull(COL_LENGTH('MT1001','MTransactionID'),0)<=0)
ALTER TABLE MT1001 ADD MTransactionID nvarchar(50) NULL
if(isnull(COL_LENGTH('MT1001','STransactionID'),0)<=0)
ALTER TABLE MT1001 ADD STransactionID nvarchar(50) NULL
If Exists (Select * From sysobjects Where name = 'MT1001' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT1001'  and col.name = 'HRMEmployeeID')
           Alter Table  MT1001 Add HRMEmployeeID varchar(50) Null
END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT1001' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT1001' AND col.name='InheritTableID')
		ALTER TABLE MT1001 ADD InheritTableID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT1001' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT1001' AND col.name='InheritVoucherID')
		ALTER TABLE MT1001 ADD InheritVoucherID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT1001' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT1001' AND col.name='InheritTransactionID')
		ALTER TABLE MT1001 ADD InheritTransactionID NVARCHAR(50) NULL
	END
If Exists (Select * From sysobjects Where name = 'MT1001' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'MT1001'  and col.name = 'Ana06ID')
Alter Table  MT1001 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'MT1001' AND xtype = 'U') --Cutomize index Secoin thông tin mã phụ
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1001' AND col.name = 'ExtraID')
		ALTER TABLE MT1001 ADD ExtraID NVARCHAR(50) NULL
	END
	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'MT1001' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1001' AND col.name = 'MD01')
		ALTER TABLE MT1001 ADD MD01 NVARCHAR(50) NULL
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1001' AND col.name = 'MD02')
		ALTER TABLE MT1001 ADD MD02 NVARCHAR(50) NULL
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1001' AND col.name = 'MD03')
		ALTER TABLE MT1001 ADD MD03 NVARCHAR(50) NULL
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1001' AND col.name = 'MD04')
		ALTER TABLE MT1001 ADD MD04 NVARCHAR(50) NULL
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1001' AND col.name = 'MD05')
		ALTER TABLE MT1001 ADD MD05 NVARCHAR(50) NULL
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1001' AND col.name = 'MD06')
		ALTER TABLE MT1001 ADD MD06 NVARCHAR(50) NULL
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1001' AND col.name = 'MD07')
		ALTER TABLE MT1001 ADD MD07 NVARCHAR(50) NULL
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1001' AND col.name = 'MD08')
		ALTER TABLE MT1001 ADD MD08 NVARCHAR(50) NULL
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1001' AND col.name = 'MD09')
		ALTER TABLE MT1001 ADD MD09 NVARCHAR(50) NULL
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1001' AND col.name = 'MD10')
		ALTER TABLE MT1001 ADD MD10 NVARCHAR(50) NULL

		--- Modify on 16/12/2015 by Bảo Anh: Cho phép trường ConvertedAmount NULL
		ALTER TABLE MT1001 ALTER COLUMN ConvertedAmount DECIMAL(28,8) NULL

		--- Modified by Tieu Mai on 04/01/2016: Bo sung truong KITID
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1001' AND col.name = 'KITID')
		ALTER TABLE MT1001 ADD KITID NVARCHAR(50) NULL
	END	


