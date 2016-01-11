-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 25/11/2011 by Lê Thị Thu Hiền
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7802]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7802](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[AllocationID] [nvarchar](50) NOT NULL,
	[SequenceID] [int] NOT NULL,
	[SequenceDesc] [nvarchar](250) NOT NULL,
	[SourceAccountIDFrom] [nvarchar](50) NOT NULL,
	[SourceAccountIDTo] [nvarchar](50) NOT NULL,
	[TargetAccountID] [nvarchar](50) NOT NULL,
	[SourceAmountID] [tinyint] NOT NULL,
	[AllocationMode] [tinyint] NOT NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[Percentage] [decimal](28, 8) NOT NULL,
CONSTRAINT [PK_AT7802] PRIMARY KEY NONCLUSTERED 
(
	[AllocationID] ASC,
	[SequenceID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7802_Percentage]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7802] ADD  CONSTRAINT [DF_AT7802_Percentage]  DEFAULT ((100)) FOR [Percentage]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT7802' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7802'  and col.name = 'Ana01ID')
           Alter Table  AT7802 Add Ana01ID nvarchar(50) Null Default('')
End 
If Exists (Select * From sysobjects Where name = 'AT7802' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7802'  and col.name = 'Ana02ID')
           Alter Table  AT7802 Add Ana02ID nvarchar(50) Null Default('')
End 
If Exists (Select * From sysobjects Where name = 'AT7802' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7802'  and col.name = 'Ana03ID')
           Alter Table  AT7802 Add Ana03ID nvarchar(50) Null Default('')
End 
If Exists (Select * From sysobjects Where name = 'AT7802' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7802'  and col.name = 'Ana04ID')
           Alter Table  AT7802 Add Ana04ID nvarchar(50)  Null Default('')
End 
If Exists (Select * From sysobjects Where name = 'AT7802' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7802'  and col.name = 'Ana05ID')
           Alter Table  AT7802 Add Ana05ID nvarchar(50)  Null Default('')
END
If Exists (Select * From sysobjects Where name = 'AT7802' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7802'  and col.name = 'AnaTypeID')
           Alter Table  AT7802 Add AnaTypeID nvarchar(50) Null Default('')
End 
If Exists (Select * From sysobjects Where name = 'AT7802' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7802'  and col.name = 'FromAnaID')
           Alter Table  AT7802 Add FromAnaID nvarchar(50)  Null Default('')
End 
If Exists (Select * From sysobjects Where name = 'AT7802' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7802'  and col.name = 'ToAnaID')
           Alter Table  AT7802 Add ToAnaID nvarchar(50)  Null Default('')
End 
If Exists (Select * From sysobjects Where name = 'AT7802' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT7802'  and col.name = 'Ana06ID')
Alter Table  AT7802 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End