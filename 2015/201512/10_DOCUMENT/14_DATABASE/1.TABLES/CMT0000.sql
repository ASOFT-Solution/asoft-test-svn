-- <Summary>
---- 
-- <History>
---- Create on 26/12/2014 by Lưu Khánh Vân
---- Modified on ... by ...
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CMT0000]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CMT0000](
	[APK] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[DefDivisionID] [nvarchar](50) NOT NULL,
	[DefTranMonth] [int] NULL,
	[DefTranYear] [int] NULL,
	[OriginalDecimal] [tinyint] NULL,
	[ConvertDecimal] [tinyint] NULL,
	[UnitPriceDecimal] [tinyint] NULL,
	[QuantityDecimal] [tinyint] NULL,
	[UserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_CMT0000] PRIMARY KEY CLUSTERED 
(
	[APK] ASC,
	[DefDivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add Columns
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='CMT0000' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='CMT0000' AND col.name='CurrencyID')
	ALTER TABLE CMT0000 ADD CurrencyID nvarchar(50) NULL
END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='CMT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='CMT0000' AND col.name='IsPermissionView')
		ALTER TABLE CMT0000 ADD IsPermissionView TINYINT NULL
	END