-- <Summary>
---- Định nghĩa tham số
-- <History>
---- Create on 06/08/2010 by Tố Oanh
--- Modify by Phuong Thao on 14/10/2015: Bo sung them ma phan tich (Customize Sieu Thanh)
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0303]') AND type in (N'U'))
CREATE TABLE [dbo].[AT0303](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[GiveUpID] [nvarchar](50) NOT NULL,
	[GiveUpDate] [datetime] NULL,
	[GiveUpEmployeeID] [nvarchar](50) NULL,
	[ObjectID] [nvarchar](50) NOT NULL,
	[AccountID] [nvarchar](50) NOT NULL,
	[CurrencyID] [nvarchar](50) NOT NULL,
	[DebitVoucherID] [nvarchar](50) NOT NULL,
	[DebitBatchID] [nvarchar](50) NOT NULL,
	[DebitTableID] [nvarchar](50) NOT NULL,
	[CreditVoucherID] [nvarchar](50) NOT NULL,
	[CreditBatchID] [nvarchar](50) NOT NULL,
	[CreditTableID] [nvarchar](50) NOT NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[IsExrateDiff] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUseID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[DebitVoucherDate] [datetime] NULL,
	[CreditVoucherDate] [datetime] NULL,
 CONSTRAINT [PK_AT0303] PRIMARY KEY NONCLUSTERED 
(
	[GiveUpID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0303_IsExrateDiff]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0303] ADD  CONSTRAINT [DF_AT0303_IsExrateDiff]  DEFAULT ((0)) FOR [IsExrateDiff]
END



------------- Customize Sieu Thanh: Giai tru theo phong ban ---------------	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT0303' AND xtype = 'U')
BEGIN
    IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
    ON col.id = tab.id WHERE tab.name = 'AT0303' AND col.name = 'Ana01ID')
    ALTER TABLE AT0303 ADD Ana01ID nvarchar (50) NULL

	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
    ON col.id = tab.id WHERE tab.name = 'AT0303' AND col.name = 'Ana02ID')
    ALTER TABLE AT0303 ADD Ana02ID nvarchar (50) NULL

	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
    ON col.id = tab.id WHERE tab.name = 'AT0303' AND col.name = 'Ana03ID')
    ALTER TABLE AT0303 ADD Ana03ID nvarchar (50) NULL

	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
    ON col.id = tab.id WHERE tab.name = 'AT0303' AND col.name = 'Ana04ID')
    ALTER TABLE AT0303 ADD Ana04ID nvarchar (50) NULL

	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
    ON col.id = tab.id WHERE tab.name = 'AT0303' AND col.name = 'Ana05ID')
    ALTER TABLE AT0303 ADD Ana05ID nvarchar (50) NULL

	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
    ON col.id = tab.id WHERE tab.name = 'AT0303' AND col.name = 'Ana06ID')
    ALTER TABLE AT0303 ADD Ana06ID nvarchar (50) NULL

	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
    ON col.id = tab.id WHERE tab.name = 'AT0303' AND col.name = 'Ana07ID')
    ALTER TABLE AT0303 ADD Ana07ID nvarchar (50) NULL

	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
    ON col.id = tab.id WHERE tab.name = 'AT0303' AND col.name = 'Ana08ID')
    ALTER TABLE AT0303 ADD Ana08ID nvarchar (50) NULL

	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
    ON col.id = tab.id WHERE tab.name = 'AT0303' AND col.name = 'Ana09ID')
    ALTER TABLE AT0303 ADD Ana09ID nvarchar (50) NULL

	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
    ON col.id = tab.id WHERE tab.name = 'AT0303' AND col.name = 'Ana10ID')
    ALTER TABLE AT0303 ADD Ana10ID nvarchar (50) NULL

END

