-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT0005STD]') AND type in (N'U'))
CREATE TABLE [dbo].[OT0005STD](
	[TypeID] [nvarchar](50) NOT NULL,
	[SystemName] [nvarchar](250) NULL,
	[UserName] [nvarchar](250) NULL,
	[IsUsed] [tinyint] NOT NULL,
	[UserNameE] [nvarchar](250) NULL
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'OT0005STD' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0005STD'  and col.name = 'TransactionID')
           Alter Table  OT0005STD Add TransactionID nvarchar(50) Null
End 
-- Thêm cột SystemNameE vào bảng OT0005STD
IF(ISNULL(COL_LENGTH('OT0005STD', 'SystemNameE'), 0) <= 0)
ALTER TABLE OT0005STD ADD SystemNameE NVARCHAR(50) NULL