-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT4712]') AND type in (N'U'))
CREATE TABLE [dbo].[HT4712](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[ColumnID] [int] NOT NULL,
	[FOrders] [int] NULL,
	[Caption] [nvarchar](250) NULL,
	[Disabled] [tinyint] NULL,
	[AmountType] [nvarchar](50) NULL,
	[AmountTypeFrom] [nvarchar](50) NULL,
	[AmountTypeTo] [nvarchar](50) NULL,
	[OtherAmount] [decimal](28, 8) NULL,
	[Signs] [nvarchar](50) NULL,
	[IsTotal] [tinyint] NULL,
	[IsSerie] [tinyint] NULL,
	[FromColumn] [int] NULL,
	[ToColumn] [int] NULL,
	[IsChangeCurrency] [tinyint] NULL,
	CONSTRAINT [PK_HT4712] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT4712' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT4712'  and col.name = 'NetIncomeMethod')
           Alter Table HT4712 Add NetIncomeMethod tinyint NULL
End