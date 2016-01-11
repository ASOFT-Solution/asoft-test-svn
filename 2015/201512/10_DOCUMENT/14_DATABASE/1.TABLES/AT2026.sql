-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on 28/12/2015 by Hoàng Vũ: CustomizeIndex = 51 (Hoàng trần), Bổ sung thêm 3 trường RouteID, InTime, OutTime, DeliveryEmployeeID, DeliveryStatus, IsWeb.
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT2026]') AND type in (N'U'))
CREATE TABLE [dbo].[AT2026](
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
	[Status] [tinyint] NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[RefNo01] [nvarchar](100) NULL,
	[RefNo02] [nvarchar](100) NULL,
	[KindVoucherID] [int] NULL,
 CONSTRAINT [PK_AT2026] PRIMARY KEY NONCLUSTERED 
(
	[VoucherID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

--CustomizeIndex = 51 (hoàng trần)
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2026' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2026' AND col.name = 'RouteID')
        ALTER TABLE AT2026 ADD RouteID VARCHAR(50) NULL
    END
--CustomizeIndex = 51 (hoàng trần)	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2027' AND xtype = 'U')
    IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2026' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2026' AND col.name = 'InTime')
        ALTER TABLE AT2026 ADD InTime DATETIME NULL
    END	
--CustomizeIndex = 51 (hoàng trần)
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2026' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2026' AND col.name = 'OutTime')
        ALTER TABLE AT2026 ADD OutTime DATETIME NULL
    END
--CustomizeIndex = 51 (hoàng trần)
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2026' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2026' AND col.name = 'DeliveryEmployeeID')
        ALTER TABLE AT2026 ADD DeliveryEmployeeID VARCHAR(50) NULL
    END
--CustomizeIndex = 51 (hoàng trần)
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2026' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2026' AND col.name = 'DeliveryStatus')
        ALTER TABLE AT2026 ADD DeliveryStatus TINYINT NULL
    END
--CustomizeIndex = 51 (hoàng trần)	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2026' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2026' AND col.name = 'IsWeb')
        ALTER TABLE AT2026 ADD IsWeb TINYINT NULL
    END	