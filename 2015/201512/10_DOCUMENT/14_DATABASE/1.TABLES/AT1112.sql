-- <Summary>
---- 
-- <History>
---- Create on 23/10/2010 by Huỳnh Tấn Phú
---- Modified on 27/11/2015 by Trần Quốc Tuấn chuyển thêm độ dài VoucherID tăng độ dài thành 50
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1112]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1112](
	[APK] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[DivisionID] [nvarchar](20) NOT NULL,
	[InvoiceNo] [nvarchar](20) NULL,
	[ReportID] [nvarchar](20) NOT NULL,
	[UserID] [nvarchar](20) NOT NULL,
	[PrintDate] [datetime] NOT NULL,
	[VoucherID] [nvarchar](25) NULL,
 CONSTRAINT [PK_AT1112] PRIMARY KEY CLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

---Alter column 
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT1112' AND xtype='U')
BEGIN
	IF EXISTS (SELECT TOP 1 1 FROM syscolumns col
				INNER JOIN sysobjects obj ON obj.id = col.id AND obj.xtype='U'
	           WHERE col.name='VoucherID' AND obj.name='AT1112')
	           ALTER TABLE AT1112 ALTER COLUMN VoucherID VARCHAR(50)
END


