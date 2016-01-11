-- <Summary>
---- 
-- <History>
---- Create on 23/09/2011 by Lê Thị Thu Hiền
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on 15/06/2015 by Hoàng vũ: Bổ sung thêm trường OrderTypeID dùng để phân biệt đơn hàng bán và đơn hàng điều chỉnh (Khách hàng secoin)
---- Modified on26/06/2015 by Lê Thị Hạnh: Bổ sung ImpactLevel, duyệt đơn hàng 2 cấp cho đơn hàng bán ---- <Example>
---- Modified on 15/06/2015 by Hoàng vũ: Bổ sung thêm trường ConfirmDate,ConfirmUserID , RouteID, IsInvoice, ghi nhận thời gian duyệt, Tuyến giao hàng, Ghi chú lấy từ đoiố tượng qua đơn hàng (Khách hàng Hoàng Trần)
---- Modified on 22/12/2015 by Tiểu Mai: Bổ sung trường InheritApportionID (đính bộ định mức theo quy cách cho ĐHSX)
---- Modified on 04/01/2016 by Tieu Mai: Bo sung truong DiscountSalesAmount
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT2001]') AND type in (N'U'))
CREATE TABLE [dbo].[OT2001](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[SOrderID] [nvarchar](50) NOT NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[OrderDate] [datetime] NULL,
	[ContractNo] [nvarchar](50) NULL,
	[ContractDate] [datetime] NULL,
	[ClassifyID] [nvarchar](50) NULL,
	[OrderType] [tinyint] NOT NULL DEFAULT ((0)),
	[ObjectID] [nvarchar](50) NULL,
	[DeliveryAddress] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL DEFAULT ((0)),
	[OrderStatus] [tinyint] NOT NULL DEFAULT ((0)),
	[QuotationID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[ExchangeRate] [decimal](28, 8) NULL,
	[InventoryTypeID] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,	
	[EmployeeID] [nvarchar](50) NULL,
	[Transport] [nvarchar](250) NULL,
	[PaymentID] [nvarchar](50) NULL,
	[ObjectName] [nvarchar](250) NULL,
	[VatNo] [nvarchar](50) NULL,
	[Address] [nvarchar](250) NULL,
	[IsPeriod] [tinyint] NULL,
	[IsPlan] [tinyint] NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[SalesManID] [nvarchar](50) NULL,
	[ShipDate] [datetime] NULL,
	[InheritSOrderID] [nvarchar](50) NULL,
	[DueDate] [datetime] NULL,
	[PaymentTermID] [nvarchar](50) NULL,
	[FileType] [int] NULL,
	[Contact] [nvarchar](100) NULL,
	[VATObjectID] [nvarchar](50) NULL,
	[VATObjectName] [nvarchar](250) NULL,
	[IsInherit] [tinyint] NULL,
	[IsConfirm] [tinyint] NOT NULL DEFAULT ((0)),
	[DescriptionConfirm] [nvarchar](250) NULL,
	[PeriodID] [nvarchar](50) NULL,
 CONSTRAINT [PK_OT2001] PRIMARY KEY NONCLUSTERED 
(
	[SOrderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT2001_OrderType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT2001] ADD CONSTRAINT [DF_OT2001_OrderType] DEFAULT ((0)) FOR [OrderType]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT2001_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT2001] ADD CONSTRAINT [DF_OT2001_Disabled] DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT2001_OrderStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT2001] ADD CONSTRAINT [DF_OT2001_OrderStatus] DEFAULT ((0)) FOR [OrderStatus]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__OT2001__IsConfir__7884A6CB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT2001] ADD CONSTRAINT [DF__OT2001__IsConfir__7884A6CB] DEFAULT ((0)) FOR [IsConfirm]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'OT2001' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2001'  and col.name = 'SalesMan2ID')
           Alter Table  OT2001 Add SalesMan2ID nvarchar(50) Null
End 
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'OT2001' AND xtype ='U') 
BEGIN
    IF EXISTS 
    (
    SELECT * 
    FROM syscolumns col 
    INNER JOIN sysobjects tab ON col.id = tab.id 
    WHERE tab.name = 'OT2001' 
    AND col.name = 'InheritSOrderID'
    )
    ALTER TABLE OT2001
    ALTER COLUMN InheritSOrderID NVARCHAR(400) NULL
END
IF(ISNULL(COL_LENGTH('OT2001', 'PriceListID'), 0) <= 0)
	ALTER TABLE OT2001 ADD PriceListID NVARCHAR(50) NULL
If Exists (Select * From sysobjects Where name = 'OT2001' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2001'  and col.name = 'IsPrinted')
           Alter Table  OT2001 Add IsPrinted tinyint  Null Default(0)           
           --- Sinolife:Bổ sung trường nhận biết đơn hàng có tính hoa hồng doanh số không (trường hợp đã được chiết khấu trên đơn hàng)
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2001'  and col.name = 'IsSalesCommission')
           Alter Table  OT2001 Add IsSalesCommission tinyint  Null Default(0)       
End 
If Exists (Select * From sysobjects Where name = 'OT2001' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2001'  and col.name = 'IsPrinted')
           Alter Table  OT2001 Add IsPrinted tinyint Not Null Default(0)
END
If Exists (Select * From sysobjects Where name = 'OT2001' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'OT2001'  and col.name = 'Ana06ID')
Alter Table  OT2001 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End
If Exists (Select * From sysobjects Where name = 'OT2001' and xtype ='U') --Customize Secoin phân biệt đơn hàng bán chính và đơn hàng điều chỉnh
Begin 
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'OT2001'  and col.name = 'OrderTypeID')
	Alter Table  OT2001 Add OrderTypeID tinyint Null Default(0)
END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='OT2001' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='OT2001' AND col.name='ImpactLevel')
		ALTER TABLE OT2001 ADD ImpactLevel TINYINT NULL
	END
---- Bổ sung IsConfirm01, ConfDescription01, IsConfirm02, ConfDescription02 cho duyệt đơn hàng 2 cấp[Customize LAVO]
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='OT2001' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='OT2001' AND col.name='IsConfirm01')
		ALTER TABLE OT2001 ADD IsConfirm01 TINYINT DEFAULT(0) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='OT2001' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='OT2001' AND col.name='ConfDescription01')
		ALTER TABLE OT2001 ADD ConfDescription01 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='OT2001' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='OT2001' AND col.name='IsConfirm02')
		ALTER TABLE OT2001 ADD IsConfirm02 TINYINT DEFAULT(0) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='OT2001' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='OT2001' AND col.name='ConfDescription02')
		ALTER TABLE OT2001 ADD ConfDescription02 NVARCHAR(250) NULL
	END
---Bổ sung ConfirmDate (Thời gian duyệt đơn hàng)--CustomizeIndex = 51 (Hoàng Trần)
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'OT2001' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'OT2001' AND col.name = 'ConfirmDate')
        ALTER TABLE OT2001 ADD ConfirmDate DATETIME NULL
    END
---Bổ sung ConfirmUserID (Người duyệt đơn hàng)--CustomizeIndex = 51 (Hoàng Trần)
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'OT2001' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'OT2001' AND col.name = 'ConfirmUserID')
        ALTER TABLE OT2001 ADD ConfirmUserID VARCHAR(50) NULL
    END
---Bổ sung RouteID (Đơn hàng theo tuyến)--CustomizeIndex = 51 (Hoàng Trần)
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'OT2001' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'OT2001' AND col.name = 'RouteID')
        ALTER TABLE OT2001 ADD RouteID NVARCHAR(50) NULL
    END	
---Bổ sung IsInvoice (Ghi chú lấy từ đối tượng khách hàng qua đơn hàng)--CustomizeIndex = 51 (Hoàng Trần)
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'OT2001' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'OT2001' AND col.name = 'IsInvoice')
        ALTER TABLE OT2001 ADD IsInvoice TINYINT NULL
    END	
    
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'OT2001' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'OT2001' AND col.name = 'InheritApportionID')
        ALTER TABLE OT2001 ADD InheritApportionID VARCHAR(50) NULL
    END
	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'OT2001' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'OT2001' AND col.name = 'DiscountSalesAmount')
        ALTER TABLE OT2001 ADD DiscountSalesAmount Decimal(28,8) NULL
    END	 		    