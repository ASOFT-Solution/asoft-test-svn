-- <Summary>
---- 
-- <History>
---- Create on 04/04/2012 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0254]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HT0254](
	[APK] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[DivisionID] [nvarchar] (50) NOT NULL,
	[TimeRecorderID] [nvarchar] (50) NOT NULL,
	[TimeRecorderName] [nvarchar] (250) NULL,
	[Type] [nvarchar] (250) NOT NULL,
	[IPAddress] [nvarchar] (50) NOT NULL,
	[Port]  [int] NOT NULL,
	[IsMethodSSR] [tinyint] NOT NULL,
	[Disabled] [tinyint] NOT NULL,
	[Notes] [nvarchar](250) NULL,	
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
CONSTRAINT [PK_HT0254] PRIMARY KEY NONCLUSTERED 
(
	[DivisionID] ASC,
	[TimeRecorderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT0254' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0254'  and col.name = 'MachineNumber')
           Alter Table  HT0254 Add MachineNumber [int] NULL
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0254'  and col.name = 'PassWord')
           Alter Table  HT0254 Add PassWord [int] NULL
End 
