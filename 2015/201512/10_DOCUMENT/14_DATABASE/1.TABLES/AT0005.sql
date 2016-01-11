-- <Summary>
---- Thiết lập mã phân tích
-- <History>
---- Create on 10/12/2010 by Thanh Trẫm
---- Modified on 30/01/2011 by Việt Khánh: Thêm cột SystemNameE, Nhập dữ liệu cho SystemNameE và UserNameE
---- Modified on 18/05/2015 by Thanh Sơn: Bổ sung IsExtraFee
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bổ sung IsCommon
---- Modified on 27/11/2015 by Phương Thảo: Bổ sung ReTypeID
-- <Example>

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0005]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0005](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TypeID] [nvarchar](50) NOT NULL,
	[SystemName] [nvarchar](250) NULL,
	[UserName] [nvarchar](250) NULL,
	[IsUsed] [tinyint] NOT NULL,
	[UserNameE] [nvarchar](250) NULL,
	[Status] [tinyint] NOT NULL,
 CONSTRAINT [PK_AT0005] PRIMARY KEY CLUSTERED 
(
	[TypeID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0005_IsUsed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0005] ADD  CONSTRAINT [DF_AT0005_IsUsed]  DEFAULT ((1)) FOR [IsUsed]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT0005__Status__42F7FAB8]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0005] ADD  CONSTRAINT [DF__AT0005__Status__42F7FAB8]  DEFAULT ((0)) FOR [Status]
END
---- Add Data
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT0005' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT0005' AND col.name = 'IsExtraFee')
		ALTER TABLE AT0005 ADD IsExtraFee TINYINT NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0005' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0005' AND col.name='IsCommon')
		ALTER TABLE AT0005 ADD IsCommon TINYINT DEFAULT (0) NOT NULL
	END

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT0005' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT0005' AND col.name = 'ReTypeID')
        ALTER TABLE AT0005 ADD ReTypeID NVARCHAR(50) NULL
    END