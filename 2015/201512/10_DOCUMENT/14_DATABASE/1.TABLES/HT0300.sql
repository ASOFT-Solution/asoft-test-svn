-- <Summary>
---- 
-- <History>
---- Create on 12/09/2013 by Bảo Anh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0300]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[HT0300](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](3) NOT NULL,
		[ContractNo] [nvarchar](50) NULL,
		[EmployeeID] [nvarchar](50) NOT NULL,
		[TranYear] int NOT NULL,
		[Amount] decimal(28,8) NULL,
		[Notes] [nvarchar](250) NULL,
		[CreateDate] [datetime] NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
	 CONSTRAINT [PK_HT0300] PRIMARY KEY NONCLUSTERED 
	(
		[DivisionID] ASC,
		[TranYear] ASC,
		[EmployeeID] ASC	
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT0300' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0300'  and col.name = 'RegDate')
           Alter Table  HT0300 Add RegDate datetime Null
           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0300'  and col.name = 'LimitDate')
           Alter Table  HT0300 Add LimitDate datetime Null       
End
