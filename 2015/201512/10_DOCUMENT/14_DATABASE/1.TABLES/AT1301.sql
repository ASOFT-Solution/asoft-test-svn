-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on 02/12/2015 by HOàng Vũ: CustomizeIndex = 43 (Secoin): Khi nhập bên Loại mặt hàng bên CI thì bắn qua Loại sản phẩm bên HRM
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1301]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1301](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[InventoryTypeID] [nvarchar](50) NOT NULL,
	[InventoryTypeName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[InventoryTypeNameE] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT1301] PRIMARY KEY NONCLUSTERED 
(
	[InventoryTypeID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1301_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1301] ADD  CONSTRAINT [DF_AT1301_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
--CustomizeIndex = 43 (Secoin): Khi nhập bên Loại mặt hàng bên CI thì bắn qua Loại sản phẩm bên HRM
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1301' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT1301' AND col.name = 'IsToHRM')
        ALTER TABLE AT1301 ADD IsToHRM TINYINT NULL
    END