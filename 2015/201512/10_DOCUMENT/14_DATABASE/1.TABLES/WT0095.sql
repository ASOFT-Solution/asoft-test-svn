-- <Summary>
---- 
-- <History>
---- Create on 06/06/2014 by Thanh Sơn
---- Modified on 09/06/2014 by Lê Thị Thu Hiền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[WT0095]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[WT0095]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NOT NULL,
      [TranMonth] INT NOT NULL,
      [TranYear] INT NOT NULL,
      [VoucherTypeID] VARCHAR(50) NULL,
      [VoucherID] VARCHAR(50) NOT NULL,
      [VoucherNo] VARCHAR(50) NULL,
      [VoucherDate] DATETIME NULL,
      [RefNo01] NVARCHAR(100) NULL,
      [RefNo02] NVARCHAR(100) NULL,
      [ObjectID] VARCHAR(50) NULL,
      [WareHouseID] VARCHAR(50) NULL,
      [InventoryTypeID] VARCHAR(50) NULL,
      [EmployeeID] VARCHAR(50) NULL,
      [ContactPerson] NVARCHAR(250) NULL,
      [RDAddress] NVARCHAR(250) NULL,
      [Description] NVARCHAR(1000) NULL,
      [TableID] VARCHAR(50) NULL,
      [ProjectID] VARCHAR(50) NULL,
      [OrderID] VARCHAR(50) NULL,
      [BatchID] VARCHAR(50) NULL,
      [ReDeTypeID] VARCHAR(50) NULL,
      [KindVoucherID] INT NULL,
      [WareHouseID2] VARCHAR(50) NULL,
      [Status] TINYINT DEFAULT (0) NULL,
      [VATObjectName] NVARCHAR(250) NULL,
      [IsGoodsFirstVoucher] TINYINT DEFAULT (0) NULL,
      [MOrderID] VARCHAR(50) NULL,
      [ApportionID] VARCHAR(50) NULL,
      [IsInheritWarranty] TINYINT DEFAULT (0) NULL,
      [EVoucherID] NVARCHAR(500) NULL,
      [IsGoodsRecycled] TINYINT DEFAULT (0) NULL,
      [RefVoucherID] VARCHAR(50) NULL,
      [IsCheck] TINYINT DEFAULT (0) NULL,
      [IsVoucher] TINYINT DEFAULT (0) NULL,
      [CreateUserID] VARCHAR(50) NULL,
      [CreateDate] DATETIME NULL,
      [LastModifyUserID] VARCHAR(50) NULL,
      [LastModifyDate] DATETIME NULL,
      [StandardPrice] DECIMAL(28,8) DEFAULT (0) NULL
    CONSTRAINT [PK_WT0095] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [VoucherID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'WT0095' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'WT0095'  and col.name = 'StatusID')
           Alter Table  WT0095 Add StatusID tinyint Null
End 