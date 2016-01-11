-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT2202]') AND type in (N'U'))
CREATE TABLE [dbo].[OT2202](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EDetailID] [nvarchar](50) NOT NULL,
	[EstimateID] [nvarchar](50) NULL,	
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[ProductID] [nvarchar](50) NULL,
	[ApportionID] [nvarchar](50) NULL,
	[ProductQuantity] [decimal](28, 8) NULL,
	[PDescription] [nvarchar](250) NULL,
	[LinkNo] [nvarchar](50) NULL,
	[Orders] [int] NULL,
	[UnitID] [nvarchar](50) NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[MOTransactionID] [nvarchar](50) NULL,
 CONSTRAINT [PK_OT2202] PRIMARY KEY NONCLUSTERED 
(
	[EDetailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='OT2202' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='OT2202' AND col.name='RefInfor')
	ALTER TABLE OT2202 ADD RefInfor NVARCHAR (250) NULL
END
if(isnull(COL_LENGTH('OT2202','MOrderID'),0)<=0)
ALTER TABLE OT2202 ADD MOrderID nvarchar(50) NULL
if(isnull(COL_LENGTH('OT2202','SOrderID'),0)<=0)
ALTER TABLE OT2202 ADD SOrderID nvarchar(50) NULL
if(isnull(COL_LENGTH('OT2202','MTransactionID'),0)<=0)
ALTER TABLE OT2202 ADD MTransactionID nvarchar(50) NULL
if(isnull(COL_LENGTH('OT2202','STransactionID'),0)<=0)
ALTER TABLE OT2202 ADD STransactionID nvarchar(50) NULL
If Exists (Select * From sysobjects Where name = 'OT2202' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'Ana06ID')
Alter Table  OT2202 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
END

If Exists (Select * From sysobjects Where name = 'OT2202' and xtype ='U') 
BEGIN
			
			If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED01')
           Alter Table  OT2202 Add ED01 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED02')
           Alter Table  OT2202 Add ED02 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED03')
           Alter Table  OT2202 Add ED03 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED04')
           Alter Table  OT2202 Add ED04 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED05')
           Alter Table  OT2202 Add ED05 decimal(28,8) NULL			
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED06')
           Alter Table  OT2202 Add ED06 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED07')
           Alter Table  OT2202 Add ED07 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED08')
           Alter Table  OT2202 Add ED08 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED09')
           Alter Table  OT2202 Add ED09 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED10')
           Alter Table  OT2202 Add ED10 decimal(28,8) NULL  
END

If Exists (Select * From sysobjects Where name = 'OT2202' and xtype ='U') 
BEGIN
			
			If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED01')
           Alter Table  OT2202 ALTER column ED01 NVARCHAR(50) NULL           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED02')
           Alter Table  OT2202 ALTER column ED02 NVARCHAR(50) NULL           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED03')
           Alter Table  OT2202 ALTER column ED03 NVARCHAR(50) NULL           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED04')
           Alter Table  OT2202 ALTER column ED04 NVARCHAR(50) NULL           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED05')
           Alter Table  OT2202 ALTER column ED05 NVARCHAR(50) NULL			
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED06')
           Alter Table  OT2202 ALTER column ED06 NVARCHAR(50) NULL           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED07')
           Alter Table  OT2202 ALTER column ED07 NVARCHAR(50) NULL           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED08')
           Alter Table  OT2202 ALTER column ED08 NVARCHAR(50) NULL           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED09')
           Alter Table  OT2202 ALTER column ED09 NVARCHAR(50) NULL           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2202'  and col.name = 'ED10')
           Alter Table  OT2202 ALTER column ED10 NVARCHAR(50) NULL  
END