-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on 25/03/2015 by Thanh Sơn: Bổ sung trường ObjectID
---- Modified on 25/03/2015 by Hoàng Vũ: Bổ sung cột InventoryID  để lưu trữ [Mã phụ] bắn từ màn hình danh mục vật tư qua - CustomizeIndex = 43 (Khách hàng Secoin)
---- Modified by Tiểu Mai on 23/11/2015: Bổ sung cột AccountID cho khách hàng KOYO (CustomizeIndex = 52)
---- Modified by Phương Thảo on 27/11/2015: Bổ sung cột ReAnaID
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1011]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1011](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[AnaID] [nvarchar](50) NOT NULL,
	[AnaTypeID] [nvarchar](50) NOT NULL,
	[AnaName] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Disabled] [tinyint] NOT NULL,
	[RefDate] [datetime] NULL,
	[Amount01] [decimal](28, 8) NULL,
	[Amount02] [decimal](28, 8) NULL,
	[Amount03] [decimal](28, 8) NULL,
	[Amount04] [decimal](28, 8) NULL,
	[Amount05] [decimal](28, 8) NULL,
	[Note01] [nvarchar](250) NULL,
	[Note02] [nvarchar](250) NULL,
	[Note03] [nvarchar](250) NULL,
	[Note04] [nvarchar](250) NULL,
	[Note05] [nvarchar](250) NULL,
	[Amount06] [decimal](28, 8) NULL,
	[Amount07] [decimal](28, 8) NULL,
	[Amount08] [decimal](28, 8) NULL,
	[Amount09] [decimal](28, 8) NULL,
	[Amount10] [decimal](28, 8) NULL,
	[Note06] [nvarchar](250) NULL,
	[Note07] [nvarchar](250) NULL,
	[Note08] [nvarchar](250) NULL,
	[Note09] [nvarchar](250) NULL,
	[Note10] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT1011] PRIMARY KEY CLUSTERED 
(
	[AnaID] ASC,
	[AnaTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1011_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1011] ADD  CONSTRAINT [DF_AT1011_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
---- Add Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1011' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1011' AND col.name = 'ObjectID')
		ALTER TABLE AT1011 ADD ObjectID VARCHAR(50) NULL
	END
If Exists (Select * From sysobjects Where name = 'AT1011' and xtype ='U') 
Begin--Khách hàng Secoin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =  'AT1011' and col.name = 'InventoryID')
           Alter Table AT1011 Add InventoryID NVARCHAR(50) NULL
END

--- Tiểu Mai, Customize Koyo: Add Columns AccountID
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1011' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1011' AND col.name = 'AccountID')
		ALTER TABLE AT1011 ADD AccountID VARCHAR(50) NULL
	END

--- Modify by Phuong Thao: Add Column ReAnaID
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1011' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT1011' AND col.name = 'ReAnaID')
        ALTER TABLE AT1011 ADD ReAnaID NVARCHAR(50) NULL
    END
