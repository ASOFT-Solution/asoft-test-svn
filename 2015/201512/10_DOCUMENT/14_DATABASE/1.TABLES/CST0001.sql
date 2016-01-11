-- <Summary>
---- 
-- <History>
---- Create on 09/06/2014 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CST0001]') AND type in (N'U')) 	
BEGIN	
CREATE TABLE [dbo].[CST0001](	
	[APK] uniqueidentifier NOT NULL CONSTRAINT [DF_CST0001_APK] DEFAULT newid(),
	[DivisionID] nvarchar(50) NOT NULL,
	[MotoTypeID] nvarchar(50) NULL,
	[ComponentTypeID] nvarchar(50) NULL,
	[TranMonth] Int NOT NULL CONSTRAINT [DF_CST0001_TranMonth] DEFAULT (0),
	[TranYear] Int NOT NULL CONSTRAINT [DF_CST0001_TranYear] DEFAULT (0),
	 CONSTRAINT [PK_CST0001] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC

)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'CST0001' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'CST0001'  and col.name = 'RepairWorkerID')
           Alter Table  CST0001 Add RepairWorkerID nvarchar(50) Null
End 