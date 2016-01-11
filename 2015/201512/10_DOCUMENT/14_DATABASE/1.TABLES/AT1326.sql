-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1326]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1326](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[KITID] [nvarchar](50) NOT NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[ItemID] [nvarchar](50) NOT NULL,
	[InventoryUnitID] [nvarchar](50) NULL,
	[ItemUnitID] [nvarchar](50) NULL,
	[MDescription] [nvarchar](250) NULL,
	[InventoryQuantity] [decimal](28, 8) NOT NULL,
	[DDescription] [nvarchar](250) NULL,
	[ItemQuantity] [decimal](28, 8) NULL,
	[Disabled] [tinyint] NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1326] PRIMARY KEY NONCLUSTERED 
(
	[KITID] ASC,
	[InventoryID] ASC,
	[ItemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

--- Modify on 31/12/2015 by Bảo Anh: Bổ sung trong lượng (Angel)
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT1326' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT1326' AND col.name='Weight')
		ALTER TABLE AT1326 ADD [Weight] decimal(28,8) NULL
	END
