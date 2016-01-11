-- <Summary>
---- 
-- <History>
---- Create on 23/05/2013 by Lê Thị Thu Hiền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0271]') AND type in (N'U')) 
BEGIN
CREATE TABLE [dbo].[HT0271](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](50) NOT NULL,
	[PriceID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[DeleteFlag] [tinyint] default(0) NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,	
 CONSTRAINT [PK_HT0271] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[PriceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT0271' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0271'  and col.name = 'DatePrice')
           Alter Table  HT0271 Add DatePrice decimal(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'HT0271' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0271'  and col.name = 'WaitPrice')
           Alter Table  HT0271 Add WaitPrice decimal(28,8) Null
END
