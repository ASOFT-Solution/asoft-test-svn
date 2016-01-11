-- <Summary>
---- 
-- <History>
---- Create on 28/12/2012 by Huỳnh Tấn Phú
---- Modified on 28/12/2012 by Huỳnh Tấn Phú: Bổ sung MinDepreciation,MaxDepreciation
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1501]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[AT1501](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](3) NOT NULL,
		[AssetGroupID] [nvarchar](50) NOT NULL,
		[AssetGroupName] [nvarchar](250) NULL,
		[Disabled] [tinyint] NULL,
		[CreateDate] [datetime] NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
		[Orders] [tinyint] NULL,
	 CONSTRAINT [PK_AT1501] PRIMARY KEY NONCLUSTERED 
	(
		[AssetGroupID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT1501' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT1501'  and col.name = 'MinDepreciation')
           Alter Table  AT1501 Add MinDepreciation decimal(28,8) NULL
           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT1501'  and col.name = 'MaxDepreciation')
           Alter Table  AT1501 Add MaxDepreciation decimal(28,8) NULL
End