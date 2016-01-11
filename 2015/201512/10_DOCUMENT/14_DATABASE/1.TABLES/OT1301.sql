-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT1301]') AND type in (N'U'))
CREATE TABLE [dbo].[OT1301](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[OID] [nvarchar](50) NULL,
	[InventoryTypeID] [nvarchar](50) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_OT1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT1_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT1301] ADD  CONSTRAINT [DF_OT1_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'OT1301' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT1301'  and col.name = 'TypeID')
           Alter Table  OT1301 Add TypeID tinyint Null Default(0)
End 
If Exists (Select * From sysobjects Where name = 'OT1301' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT1301'  and col.name = 'CurrencyID')
           Alter Table  OT1301 Add CurrencyID nvarchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'OT1301' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT1301'  and col.name = 'InheritID')
           Alter Table  OT1301 Add InheritID nvarchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'OT1301' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT1301'  and col.name = 'IsConvertedPrice')
           Alter Table  OT1301 Add IsConvertedPrice tinyint Null
End