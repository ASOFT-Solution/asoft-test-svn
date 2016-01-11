-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on 12/01/2015 by Thanh Sơn: Thêm trường CurrencyID, ExWareHouseID
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1007]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT1007](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[VoucherTypeID] [nvarchar](50) NOT NULL,
	[VoucherTypeName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[IsDefault] [tinyint] NOT NULL,
	[DebitAccountID] [nvarchar](50) NULL,
	[CreditAccountID] [nvarchar](50) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[WareHouseID] [nvarchar](50) NULL,
	[VDescription] [nvarchar](250) NULL,
	[TDescription] [nvarchar](250) NULL,
	[BDescription] [nvarchar](250) NULL,
	[Auto] [tinyint] NOT NULL,
	[S1] [nvarchar](50) NULL,
	[S2] [nvarchar](50) NULL,
	[S3] [nvarchar](50) NULL,
	[OutputOrder] [tinyint] NULL,
	[OutputLength] [tinyint] NULL,
	[Separated] [tinyint] NOT NULL,
	[separator] [nvarchar](5) NULL,
	[S1Type] [tinyint] NULL,
	[S2Type] [tinyint] NULL,
	[S3Type] [tinyint] NULL,
	[Enabled1] [tinyint] NULL,
	[Enabled2] [tinyint] NULL,
	[Enabled3] [tinyint] NULL,
	[Enabled] [tinyint] NOT NULL,
	[VoucherGroupID] [nvarchar](50) NULL,
	[BankAccountID] [nvarchar](50) NULL,
	[BankName] [nvarchar](250) NULL,
	[IsVAT] [tinyint] NULL,
	[VATTypeID] [nvarchar](50) NULL,
	[IsBDescription] [tinyint] NULL,
	[IsTDescription] [tinyint] NULL,
 CONSTRAINT [PK_AT1007] PRIMARY KEY NONCLUSTERED 
(
	[VoucherTypeID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add giá trị default
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1007_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1007] ADD  CONSTRAINT [DF_AT1007_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1007_IsDefault]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1007] ADD  CONSTRAINT [DF_AT1007_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
END
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1007_Auto]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1007] ADD  CONSTRAINT [DF_AT1007_Auto]  DEFAULT ((0)) FOR [Auto]
END
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1007_Separated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1007] ADD  CONSTRAINT [DF_AT1007_Separated]  DEFAULT ((0)) FOR [Separated]
END
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1007_Enabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1007] ADD  CONSTRAINT [DF_AT1007_Enabled]  DEFAULT ((1)) FOR [Enabled]
END
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1007_IsVAT]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1007] ADD  CONSTRAINT [DF_AT1007_IsVAT]  DEFAULT ((0)) FOR [IsVAT]
END
---- Add Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE name = 'AT1007' AND xtype = 'U') 
BEGIN
	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1007' AND col.name = 'CurrencyID')
    ALTER TABLE AT1007 ADD CurrencyID NVARCHAR(50) NULL
END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE name = 'AT1007' AND xtype = 'U') 
BEGIN
	IF NOT EXISTS (select TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1007' AND col.name = 'ExWareHouseID')
    ALTER TABLE AT1007 ADD ExWareHouseID NVARCHAR(50) NULL
END
