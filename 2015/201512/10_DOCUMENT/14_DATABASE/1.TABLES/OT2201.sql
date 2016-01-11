-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT2201]') AND type in (N'U'))
CREATE TABLE [dbo].[OT2201](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EstimateID] [nvarchar](50) NOT NULL,	
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[Status] [int] NULL,
	[SOrderID] [nvarchar](50) NULL,
	[ApportionType] [nvarchar](50) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[InventoryTypeID] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[WareHouseID] [nvarchar](50) NULL,
	[OrderStatus] [int] NULL,
	[IsPicking] [tinyint] NULL,
	[FileType] [int] NULL,
	[PeriodID] [nvarchar](50) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[IsConfirm] [tinyint] NOT NULL,
	[DescriptionConfirm] [nvarchar](250) NULL,
 CONSTRAINT [PK_OT2201] PRIMARY KEY NONCLUSTERED 
(
	[EstimateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__OT2201__IsConfir__1D039511]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT2201] ADD  CONSTRAINT [DF__OT2201__IsConfir__1D039511]  DEFAULT ((0)) FOR [IsConfirm]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar01')
           Alter Table  OT2201 Add Varchar01 nvarchar(100) Null
End 
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar02')
           Alter Table  OT2201 Add Varchar02 nvarchar(100) Null
End 
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar03')
           Alter Table  OT2201 Add Varchar03 nvarchar(100) Null
End 
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar04')
           Alter Table  OT2201 Add Varchar04 nvarchar(100) Null
END
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar05')
           Alter Table  OT2201 Add Varchar05 nvarchar(100) Null
End 
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar06')
           Alter Table  OT2201 Add Varchar06 nvarchar(100) Null
END
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar07')
           Alter Table  OT2201 Add Varchar07 nvarchar(100) Null
End 
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar08')
           Alter Table  OT2201 Add Varchar08 nvarchar(100) Null
END
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar09')
           Alter Table  OT2201 Add Varchar09 nvarchar(100) Null
End 
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar10')
           Alter Table  OT2201 Add Varchar10 nvarchar(100) Null
END
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar11')
           Alter Table  OT2201 Add Varchar11 nvarchar(100) Null
End 
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar12')
           Alter Table  OT2201 Add Varchar12 nvarchar(100) Null
END
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar13')
           Alter Table  OT2201 Add Varchar13 nvarchar(100) Null
End 
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar14')
           Alter Table  OT2201 Add Varchar14 nvarchar(100) Null
END
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar15')
           Alter Table  OT2201 Add Varchar15 nvarchar(100) Null
End 
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar16')
           Alter Table  OT2201 Add Varchar16 nvarchar(100) Null
END
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar17')
           Alter Table  OT2201 Add Varchar17 nvarchar(100) Null
End 
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar18')
           Alter Table  OT2201 Add Varchar18 nvarchar(100) Null
END
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar19')
           Alter Table  OT2201 Add Varchar19 nvarchar(100) Null
End 
If Exists (Select * From sysobjects Where name = 'OT2201' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2201'  and col.name = 'Varchar20')
           Alter Table  OT2201 Add Varchar20 nvarchar(100) Null
End