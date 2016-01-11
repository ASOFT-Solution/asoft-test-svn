-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT5558]') AND type in (N'U'))
CREATE TABLE [dbo].[AT5558](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[OrderID] [nvarchar](50) NOT NULL,
	[ItemID] [int] NULL,
	[OrderDate] [smalldatetime] NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[Object_ID] [nvarchar](50) NULL,
	[Ordertotal] [decimal](28, 8) NULL,
	[TaxMethod] [tinyint] NULL,
	[payment] [decimal](28, 8) NULL,
	[Note] [nvarchar](4000) NULL,
	[storename] [nvarchar](50) NULL,
	[VAT] [int] NULL,
	[CK] [float] NULL,
	[Redbillcode] [nvarchar](50) NULL,
	[MethodOrder] [nvarchar](50) NULL,
	[ImportID] [nvarchar](50) NULL,
	[DepID] [float] NULL,
	[SalerID] [nvarchar](50) NULL,
	[hh] [float] NULL,
	[kg] [tinyint] NULL,
	[Descr] [nvarchar](250) NULL,
	[TienCL] [decimal](28, 8) NULL,
	[Tienthanhtoan] [decimal](28, 8) NULL,
	[Census] [tinyint] NULL,
	[Phieuthu] [nvarchar](50) NULL,
	[POID] [nvarchar](50) NULL,
	[CKsauVAT] [tinyint] NULL,
	[chanel_id] [nvarchar](50) NULL,
	[IsThuTien] [tinyint] NULL,
	[IsXuatKho] [tinyint] NULL,
	[Hanthanhtoan] [int] NULL,
	[CounterID] [nvarchar](50) NULL,
	[IsTax] [tinyint] NULL,
	[OrverTax] [decimal](28, 8) NULL,
	[PayTax] [decimal](28, 8) NULL,
	[IDSort] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[TicketCode] [nvarchar](50) NULL,
	[inword] [nvarchar](250) NULL,
	[issend] [tinyint] NULL,
	[GroupProduct] [nvarchar](1000) NULL,
	[FullOrderDate] [nvarchar](50) NULL,
	[SoHieuHD] [nvarchar](50) NULL,
	[SoHD] [nvarchar](50) NULL,
	CONSTRAINT [PK_AT5558] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

) ON [PRIMARY]

