-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT0005]') AND type in (N'U'))
CREATE TABLE [dbo].[OT0005](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TypeID] [nvarchar](50) NOT NULL,
	[SystemName] [nvarchar](250) NULL,
	[UserName] [nvarchar](250) NULL,
	[IsUsed] [tinyint] NOT NULL,
	[UserNameE] [nvarchar](250) NULL,
 CONSTRAINT [PK_OT0005] PRIMARY KEY CLUSTERED 
(
	[TypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT0005_IsUsed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT0005] ADD  CONSTRAINT [DF_OT0005_IsUsed]  DEFAULT ((1)) FOR [IsUsed]
END
---- Add Columns
-- Thêm cột SystemNameE vào bảng OT0005
IF(ISNULL(COL_LENGTH('OT0005', 'SystemNameE'), 0) <= 0)
ALTER TABLE OT0005 ADD SystemNameE NVARCHAR(50) NULL
If Exists (Select * From sysobjects Where name = 'OT0005' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0005'  and col.name = 'TransactionID')
           Alter Table  OT0005 Add TransactionID nvarchar(50) Null
End 