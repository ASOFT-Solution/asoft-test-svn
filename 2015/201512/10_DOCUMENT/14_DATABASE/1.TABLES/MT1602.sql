-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1602]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1602](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ApportionID] [nvarchar](50) NOT NULL,
	[InventoryTypeID] [nvarchar](50) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Disabled] [tinyint] NOT NULL,
	[ApportionIDOld] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[IsBOM] [tinyint] NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
 CONSTRAINT [PK_MT1602] PRIMARY KEY NONCLUSTERED 
(
	[ApportionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1602_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1602] ADD  CONSTRAINT [DF_MT1602_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1602_IsBOM]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1602] ADD  CONSTRAINT [DF_MT1602_IsBOM]  DEFAULT ((0)) FOR [IsBOM]
END
---- Add Columns
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='MT1602' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='MT1602' AND col.name='AdjustDate')
	ALTER TABLE MT1602 ADD AdjustDate DATETIME NULL
END