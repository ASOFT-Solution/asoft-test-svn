-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on 19/09/2014 by Lê Thị Hạnh: Thêm MixVoucherID và ProductID [Customize Index: 36 - Sài Gòn Petro]
---- Modify on 29/09/2014 by Lê Thị Hạnh - Thêm MaterialDate [Customize Index: 36 - Sài Gòn Petro]
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT2001]') AND type in (N'U'))
CREATE TABLE [dbo].[MT2001](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PlanID] [nvarchar](50) NOT NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[SOderID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[PlanStatus] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[Disabled] [tinyint] NOT NULL,
	[InventoryTypeID] [nvarchar](50) NULL,
	[BeginDate] [datetime] NULL,
	[IsApportionID] [tinyint] NOT NULL,
	[IsSum] [tinyint] NOT NULL,
 CONSTRAINT [PK_MT2001] PRIMARY KEY NONCLUSTERED 
(
	[PlanID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT2001_PlanStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT2001] ADD  CONSTRAINT [DF_MT2001_PlanStatus]  DEFAULT ((0)) FOR [PlanStatus]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT2001_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT2001] ADD  CONSTRAINT [DF_MT2001_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__MT2001__IsApport__0A1EA4B8]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT2001] ADD  CONSTRAINT [DF__MT2001__IsApport__0A1EA4B8]  DEFAULT ((0)) FOR [IsApportionID]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__MT2001__IsSum__0B12C8F1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT2001] ADD  CONSTRAINT [DF__MT2001__IsSum__0B12C8F1]  DEFAULT ((0)) FOR [IsSum]
END
---- Add Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT2001' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT2001' AND col.name='ProductID')
		ALTER TABLE MT2001 ADD ProductID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT2001' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT2001' AND col.name='MixVoucherID')
		ALTER TABLE MT2001 ADD MixVoucherID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT2001' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='MT2001' AND col.name='MaterialDate')
		ALTER TABLE MT2001 ADD MaterialDate DATETIME NULL
	END

