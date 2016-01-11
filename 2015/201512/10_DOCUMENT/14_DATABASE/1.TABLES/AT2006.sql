-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on 07/01/2012 by Lê Thị Thu Hiền
---- Modified on 25/01/2013 by Bảo Anh
---- Modified on 31/10/2011 by Nguyễn Bình Minh
---- Modified on 29/01/2013 by Việt Khánh
---- Modified on 27/12/2013 by Bảo Anh
---- Modified on 24/06/2014 by Lê Thị Thu Hiền
---- Modified on 21/10/2015 by Kim Vu Bo sung 20 Columns SParameter khach hang
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT2006]') AND type in (N'U'))
CREATE TABLE [dbo].[AT2006](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[TableID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[ProjectID] [nvarchar](50) NULL,
	[OrderID] [nvarchar](50) NULL,
	[BatchID] [nvarchar](50) NULL,
	[WareHouseID] [nvarchar](50) NULL,
	[ReDeTypeID] [nvarchar](50) NULL,
	[KindVoucherID] [int] NULL,
	[WareHouseID2] [nvarchar](50) NULL,
	[Status] [tinyint] NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[RefNo01] [nvarchar](100) NULL,
	[RefNo02] [nvarchar](100) NULL,
	[RDAddress] [nvarchar](250) NULL,
	[ContactPerson] [nvarchar](100) NULL,
	[VATObjectName] [nvarchar](250) NULL,
	[InventoryTypeID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT2006] PRIMARY KEY NONCLUSTERED 
(	[DivisionID] ASC,
	[VoucherID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT2006' and xtype ='U') 
Begin
    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'MOrderID')
    Alter Table  AT2006 Add MOrderID nvarchar(50) Null 

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'ApportionID')
    Alter Table  AT2006 Add ApportionID nvarchar(50) Null

	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT2006' AND col.name='IsVoucher')
	ALTER TABLE AT2006 ADD IsVoucher TINYINT DEFAULT(0) NULL

	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT2006' AND col.name='IsGoodsFirstVoucher')
	ALTER TABLE AT2006 ADD IsGoodsFirstVoucher TINYINT DEFAULT(0) NULL

	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name = 'AT2006' and col.name = 'IsGoodsRecycled') 
	Alter Table  AT2006 Add IsGoodsRecycled tinyint Null 

	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'EVoucherID')
	Alter Table  AT2006 Add EVoucherID nvarchar(500) NULL

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'IsInheritWarranty')
    Alter Table  AT2006 Add IsInheritWarranty tinyint Null

	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT2006' AND col.name='ImVoucherID')
	ALTER TABLE AT2006 ADD ImVoucherID VARCHAR(50) NULL

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'ReVoucherID')
    Alter Table  AT2006 Add ReVoucherID nvarchar(50) Null 

---- Add Columns Transport
    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter01')
    Alter Table  AT2006 Add SParameter01 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter02')
    Alter Table  AT2006 Add SParameter02 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter03')
    Alter Table  AT2006 Add SParameter03 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter04')
    Alter Table  AT2006 Add SParameter04 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter05')
    Alter Table  AT2006 Add SParameter05 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter06')
    Alter Table  AT2006 Add SParameter06 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter07')
    Alter Table  AT2006 Add SParameter07 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter08')
    Alter Table  AT2006 Add SParameter08 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter09')
    Alter Table  AT2006 Add SParameter09 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter10')
    Alter Table  AT2006 Add SParameter10 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter11')
    Alter Table  AT2006 Add SParameter11 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter12')
    Alter Table  AT2006 Add SParameter12 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter13')
    Alter Table  AT2006 Add SParameter13 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter14')
    Alter Table  AT2006 Add SParameter14 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter15')
    Alter Table  AT2006 Add SParameter15 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter16')
    Alter Table  AT2006 Add SParameter16 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter17')
    Alter Table  AT2006 Add SParameter17 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter18')
    Alter Table  AT2006 Add SParameter18 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter19')
    Alter Table  AT2006 Add SParameter19 nvarchar(250) Null

    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2006'  and col.name = 'SParameter20')
    Alter Table  AT2006 Add SParameter20 nvarchar(250) Null
End
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2006_TableID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2006] ADD  CONSTRAINT [DF_AT2006_TableID]  DEFAULT ('AT2006') FOR [TableID]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2006_Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2006] ADD  CONSTRAINT [DF_AT2006_Status]  DEFAULT ((0)) FOR [Status]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2006_IsGoodsRecycled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2006] ADD  CONSTRAINT DF_AT2006_IsGoodsRecycled  DEFAULT ((0)) FOR IsGoodsRecycled
END

--CustomizeIndex = 51 (Hoàng Trần)--
	IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2006' AND xtype = 'U') --Tuyến giao hàng
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2006' AND col.name = 'RouteID')
        ALTER TABLE AT2006 ADD RouteID VARCHAR(50) NULL
    END
	IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2006' AND xtype = 'U')--Xác nhân thời gian về
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2006' AND col.name = 'InTime')
        ALTER TABLE AT2006 ADD InTime DATETIME NULL
    END
	IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2006' AND xtype = 'U')--Xác nhận thời gian đi
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2006' AND col.name = 'OutTime')
        ALTER TABLE AT2006 ADD OutTime DATETIME NULL
    END
	IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2006' AND xtype = 'U')--Nhân viên giao hàng
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2006' AND col.name = 'DeliveryEmployeeID')
        ALTER TABLE AT2006 ADD DeliveryEmployeeID VARCHAR(50) NULL
    END
	IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2006' AND xtype = 'U')--Trạng thái hoàn tất phiếu điều phối
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2006' AND col.name = 'DeliveryStatus')
        ALTER TABLE AT2006 ADD DeliveryStatus TINYINT NULL
    END
	IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2006' AND xtype = 'U')--Phiếu nhập, phiếu xuất, phiếu chuyển kho (Phiếu điều phối) lập trên web hay ứng dụng: 0=Ứng dụng; 1=Web
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2006' AND col.name = 'IsWeb')
        ALTER TABLE AT2006 ADD IsWeb TINYINT NULL
    END
--CustomizeIndex = 51 (Hoàng Trần)--


