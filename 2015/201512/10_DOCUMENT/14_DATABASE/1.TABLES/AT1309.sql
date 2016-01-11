-- <Summary>
---- 
-- <History>
---- Create on 10/08/2010 by Ngọc Nhựt
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1309]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1309](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[UnitID] [nvarchar](50) NOT NULL,
	[ConversionFactor] [decimal](28, 8) NULL,
	[Disabled] [tinyint] NOT NULL,
	[Orders] [tinyint] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Operator] [tinyint] NULL,
	[DataType] [tinyint] NOT NULL,
	[FormulaID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1309] PRIMARY KEY NONCLUSTERED 
(
	[InventoryID] ASC,
	[UnitID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1309_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1309] ADD CONSTRAINT [DF_AT1309_Disabled] DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT1309__Operator__6CDF4ED9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1309] ADD CONSTRAINT [DF__AT1309__Operator__6CDF4ED9] DEFAULT ((0)) FOR [Operator]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT1309__DataType__076AF05B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1309] ADD CONSTRAINT [DF__AT1309__DataType__076AF05B] DEFAULT ((0)) FOR [DataType]
END
-- Tạo Column IsCommon by Thinh : 25/08/2015
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'AT1309' AND xtype = 'U') 
BEGIN
    IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1309' AND col.name = 'IsCommon')
    ALTER TABLE AT1309 ADD [IsCommon] [tinyint] NULL
END