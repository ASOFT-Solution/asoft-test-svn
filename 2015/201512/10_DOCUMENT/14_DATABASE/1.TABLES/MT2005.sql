-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on 18/03/2015 by Lê Thị Hạnh: Thêm 5 trường ghi chú [Customize Index: 36 - Sài Gòn Petro] - Hỗ trợ ngày 17/03/2015
---- Modified on 18/12/2015 by Tiểu Mai: Bổ sung 10 MPT Ana01ID --> Ana10ID
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT2005]') AND type in (N'U'))
CREATE TABLE [dbo].[MT2005](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[VoucherID] [nvarchar](50) NULL,
	[PLanID] [nvarchar](50) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[LinkNo] [nvarchar](50) NULL,
	[ActualQuantity] [decimal](28, 8) NULL,
	[Description] [nvarchar](250) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[Orders] [int] NULL,
	[Finish] [tinyint] NULL,
	[WorkID] [nvarchar](50) NULL,
	[LevelID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	CONSTRAINT [PK_MT2005] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT2005' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT2005' AND col.name='Notes01')
		ALTER TABLE MT2005 ADD Notes01 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT2005' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT2005' AND col.name='Notes02')
		ALTER TABLE MT2005 ADD Notes02 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT2005' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT2005' AND col.name='Notes03')
		ALTER TABLE MT2005 ADD Notes03 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT2005' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT2005' AND col.name='Notes04')
		ALTER TABLE MT2005 ADD Notes04 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT2005' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT2005' AND col.name='Notes05')
		ALTER TABLE MT2005 ADD Notes05 NVARCHAR(250) NULL
	END

-- Tieu Mai, Add columns	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'MT2005' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT2005' AND col.name = 'Ana01ID')
		ALTER TABLE MT2005 ADD  Ana01ID VARCHAR(50) NULL,
								Ana02ID VARCHAR(50) NULL,
								Ana03ID VARCHAR(50) NULL,
								Ana04ID VARCHAR(50) NULL,
								Ana05ID VARCHAR(50) NULL,
								Ana06ID VARCHAR(50) NULL,
								Ana07ID VARCHAR(50) NULL,
								Ana08ID VARCHAR(50) NULL,
								Ana09ID VARCHAR(50) NULL,
								Ana10ID VARCHAR(50) NULL
	END		