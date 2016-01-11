-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 24/02/2015 by Phan thanh hoàng Vũ: Bổ sung trường cho checkbox [Phân quyền xem dữ liệu của người khác]ư
---- Modified on 21/09/2015 by Tieu Mai: Bổ sung thêm cột OthersDecimal
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT0000]') AND type in (N'U'))
CREATE TABLE [dbo].[MT0000](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[PeriodID] [nvarchar](50) NULL,
	[DistributionID] [nvarchar](50) NULL,
	[InProcessID] [nvarchar](50) NULL,
	[OriginalDecimal] [tinyint] NULL,
	[ConvertDecimal] [tinyint] NULL,
	[UnitPriceDecimal] [tinyint] NULL,
	[PercentDecimal] [tinyint] NULL,
	[QuantityDecimal] [tinyint] NULL,
	[MaterialAccountID] [nvarchar](50) NULL,
	[HumanAccountID] [nvarchar](50) NULL,
	[OtherAccountID] [nvarchar](50) NULL,
	[InprocessAccountID] [nvarchar](50) NULL,
	[IsWork] [tinyint] NULL,
	[IsConvertUnit] [tinyint] NOT NULL,
	CONSTRAINT [PK_MT0000] PRIMARY KEY NONCLUSTERED
	(
	[APK] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__MT0000__IsConver__085F1494]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0000] ADD  CONSTRAINT [DF__MT0000__IsConver__085F1494]  DEFAULT ((0)) FOR [IsConvertUnit]
END
---- Add Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT0000' AND col.name='IsPermissionView')
		ALTER TABLE MT0000 ADD IsPermissionView TINYINT NULL
	END
-- Thêm cột IsAutoExMaterialDelivery vào bảng MT0000
IF(ISNULL(COL_LENGTH('MT0000', 'IsAutoExMaterialDelivery'), 0) <= 0)
ALTER TABLE MT0000 ADD IsAutoExMaterialDelivery tinyint NULL
-- Thêm cột IsAutoImScrap vào bảng MT0000
IF(ISNULL(COL_LENGTH('MT0000', 'IsAutoImScrap'), 0) <= 0)
ALTER TABLE MT0000 ADD IsAutoImScrap tinyint NULL
-- Thêm cột ExVoucherTypeID vào bảng MT0000
IF(ISNULL(COL_LENGTH('MT0000', 'ExVoucherTypeID'), 0) <= 0)
ALTER TABLE MT0000 ADD ExVoucherTypeID nvarchar(50) NULL
-- Thêm cột ExWareHouseID vào bảng MT0000
IF(ISNULL(COL_LENGTH('MT0000', 'ExWareHouseID'), 0) <= 0)
ALTER TABLE MT0000 ADD ExWareHouseID nvarchar(50) NULL
-- Thêm cột ImVoucherTypeID vào bảng MT0000
IF(ISNULL(COL_LENGTH('MT0000', 'ImVoucherTypeID'), 0) <= 0)
ALTER TABLE MT0000 ADD ImVoucherTypeID nvarchar(50) NULL
-- Thêm cột ImWareHouseID vào bảng MT0000
IF(ISNULL(COL_LENGTH('MT0000', 'ImWareHouseID'), 0) <= 0)
ALTER TABLE MT0000 ADD ImWareHouseID nvarchar(50) NULL
-- Thêm cột IsBarcode vào bảng MT0000
IF(ISNULL(COL_LENGTH('MT0000', 'IsBarcode'), 0) <= 0)
ALTER TABLE MT0000 ADD IsBarcode tinyint NULL

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT0000' AND col.name='OthersDecimal')
		ALTER TABLE MT0000 ADD OthersDecimal TINYINT NULL
	END