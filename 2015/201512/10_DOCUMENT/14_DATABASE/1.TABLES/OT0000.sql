-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 29/09/2014 by Lê Thị Hạnh : Thêm Cam kết chiết khấu [Customize Index: 36 - Sài Gòn Petro]
---- Modified by Tiểu Mai on 04/01/2016: Bổ sung trường Duyệt đơn hàng bán 2 cấp IsConfirmPO
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT0000]') AND type in (N'U'))
CREATE TABLE [dbo].[OT0000](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[ConvertDecimal] [tinyint] NULL,
	[UnitPriceDecimal] [tinyint] NULL,
	[PercentDecimal] [tinyint] NULL,
	[QuantityDecimal] [tinyint] NULL,
	[IsDiscount] [tinyint] NULL,
	[IsCommission] [tinyint] NULL,
	[IsInventoryCommonName] [tinyint] NULL,
	[IsNotRepeatLinkNo] [tinyint] NULL,
	[IsPriceControl] [tinyint] NULL,
	[IsQuantityControl] [tinyint] NULL,
	[OPriceTypeID] [nvarchar](50) NULL,
	[IsPicking] [tinyint] NULL,
	[MaterialRate] [decimal](28, 8) NULL,
	[IsNotDebit] [tinyint] NULL,
	[IsConvertUnit] [tinyint] NULL,
	[IsLockSalePrice] [tinyint] NULL,
	[IsBarcode] [tinyint] NULL,
	[IsSaleOff] [int] NOT NULL,
	[IsConfirm] [tinyint] NOT NULL,
	[IsUpdateOStatus] [tinyint] NOT NULL,
	CONSTRAINT [PK_OT0000] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__OT0000__IsSaleOf__130392DD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT0000] ADD  CONSTRAINT [DF__OT0000__IsSaleOf__130392DD]  DEFAULT ((0)) FOR [IsSaleOff]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__OT0000__IsConfir__13F7B716]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT0000] ADD  CONSTRAINT [DF__OT0000__IsConfir__13F7B716]  DEFAULT ((0)) FOR [IsConfirm]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__OT0000__IsUpdate__590F28CE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT0000] ADD  CONSTRAINT [DF__OT0000__IsUpdate__590F28CE]  DEFAULT ((0)) FOR [IsUpdateOStatus]
END
---- Add Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='OT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='OT0000' AND col.name='IsCommitDiscount')
		ALTER TABLE OT0000 ADD IsCommitDiscount TINYINT NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='OT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='OT0000' AND col.name='OTypeID')
		ALTER TABLE OT0000 ADD OTypeID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='OT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='OT0000' AND col.name='ITypeID')
		ALTER TABLE OT0000 ADD ITypeID NVARCHAR(50) NULL
	END
If Exists (Select * From sysobjects Where name = 'OT0000' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0000'  and col.name = 'IsQuantityPrice')
           Alter Table  OT0000 Add IsQuantityPrice tinyint Null
End 

If Exists (Select * From sysobjects Where name = 'OT0000' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0000'  and col.name = 'IsConfirmPO')
           Alter Table  OT0000 Add IsConfirmPO tinyint default(0) Not null
End 
