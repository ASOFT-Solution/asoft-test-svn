-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh 
---- Modified on 31/10/2012 by Bảo Anh: Thêm trường ReMarkQuantity, DeMarkQuantity, EndMarkQuantity
-- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0114]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0114](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[InventoryID] [nvarchar](50) NULL,
	[WareHouseID] [nvarchar](50) NULL,
	[ReVoucherID] [nvarchar](50) NULL,
	[ReTransactionID] [nvarchar](50) NULL,
	[ReVoucherNo] [nvarchar](50) NULL,
	[ReVoucherDate] [datetime] NULL,
	[ReTranMonth] [int] NULL,
	[ReTranYear] [int] NULL,
	[ReSourceNo] [nvarchar](50) NULL,
	[LimitDate] [datetime] NULL,
	[ReQuantity] [decimal](28, 8) NULL,
	[DeQuantity] [decimal](28, 8) NULL,
	[EndQuantity] [decimal](28, 8) NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[DeVoucherID] [nvarchar](50) NULL,
	[DeTransactionID] [nvarchar](50) NULL,
	[DeVoucherNo] [nvarchar](50) NULL,
	[DeVoucherDate] [nvarchar](50) NULL,
	[DeLocationNo] [nvarchar](50) NULL,
	[DeTranMonth] [int] NULL,
	[DeTranYear] [int] NULL,
	[Status] [tinyint] DEFAULT 0 NOT NULL,
	[IsLocked] [tinyint] DEFAULT 0 NOT NULL
	CONSTRAINT [PK_AT0114] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON

)
) ON [PRIMARY]
END
---- Update giá trị default
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0114_IsLocked]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0114] ADD  CONSTRAINT [DF_AT0114_IsLocked]  DEFAULT ((0)) FOR [IsLocked]
END
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0114_Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0114] ADD  CONSTRAINT [DF_AT0114_Status]  DEFAULT ((0)) FOR [Status]
END
---- AddColumns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0114' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0114' AND col.name='ReMarkQuantity')
		ALTER TABLE AT0114 ADD ReMarkQuantity DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0114' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0114' AND col.name='DeMarkQuantity')
		ALTER TABLE AT0114 ADD DeMarkQuantity DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0114' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0114' AND col.name='EndMarkQuantity')
		ALTER TABLE AT0114 ADD EndMarkQuantity DECIMAL(28,8) NULL
	END
