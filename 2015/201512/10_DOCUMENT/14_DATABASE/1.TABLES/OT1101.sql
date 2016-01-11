-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT1101]') AND type in (N'U'))
CREATE TABLE [dbo].[OT1101](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[OrderStatus] [tinyint] NOT NULL,
	[Description] [nvarchar](250) NOT NULL,
	[EDescription] [nvarchar](250) NOT NULL,
	[TypeID] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_OT1101] PRIMARY KEY CLUSTERED 
(
	[OrderStatus] ASC,
	[TypeID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
-- Thêm field bảng OT1101
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'OT1101' AND xtype = 'U') 
BEGIN
    IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'OT1101' AND col.name = 'LanguageID')
    ALTER TABLE OT1101 ADD LanguageID VARCHAR(100) NULL
END